import 'package:flutter/material.dart';
import 'package:my_flutter_labs/SalesDatabase.dart';
import 'package:my_flutter_labs/SalesRecords.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';

class SalesPage extends StatefulWidget {
  @override State<SalesPage> createState() {return SalesPageState();}
}

class SalesPageState extends State<SalesPage> {
  late TextEditingController _controller0;
  late TextEditingController _controller1;
  late TextEditingController _controller2;
  late TextEditingController _controller3;
  late TextEditingController _controller4;
  List<SalesRecords> records = [];
  late var daoObj;
  SalesRecords? selectedItem;



  @override
  void initState() {
    super.initState();
    _controller0 = TextEditingController();
    _controller1 = TextEditingController();
    _controller2 = TextEditingController();
    _controller3 = TextEditingController();
    _controller4 = TextEditingController();


    $FloorSalesDatabase.databaseBuilder('final_database.db')
        .build().then( (database) async {
      daoObj = database.getDAO;
      var dbResults = await daoObj.getRecords();
      setState(() {
        records = dbResults;
      });

    } );
  }

  @override
  void dispose() {
    _controller0.dispose();
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    _controller4.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Sales Page"),
          actions: [

            IconButton(onPressed: () {
              showDialog(context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('Instructions'),
                    content: const Text('To use this page, please enter the ID\'s '
                        'related to the customers, dealer, and car sold, alongside the'
                        ' date of sale and a name for the sale record. After creating '
                        'an entry using the button, clicking an entry will reveal a '
                        'page detailing the features of the entry, as well as buttons '
                        'to update or delete the entry . In addition, after '
                        'adding an entry, you are given the option to keep the same '
                        'features to autofill the text boxes to be reused next time you load the page.'),
                    actions: <Widget>[
                      ElevatedButton(onPressed: () {
                        Navigator.pop(context);
                      }, child: Text("Got it!"))
                    ],));
            },
                icon: Icon(Icons.question_mark)),
          ]
      ),
      body: Center(
        child: Padding(padding: EdgeInsets.all(20),
            child: listPage()

        ),


      ),
    );}

  Widget listPage(){
    return Column(children: [
      Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children:[
            Expanded(child: TextField(
              controller: _controller0,
              decoration: InputDecoration(
                  hintText: "Title",
                  border: OutlineInputBorder()
              ),
            )),

            Expanded(child: TextField(
              controller: _controller1,
              decoration: InputDecoration(
                  hintText: "Customer ID",
                  border: OutlineInputBorder()
              ),
            )),

            Expanded(child: TextField(
                controller: _controller2,
                decoration: InputDecoration(
                    hintText: "Car ID",
                    border: OutlineInputBorder()

                ))
            ),
            Expanded(child: TextField(
                controller: _controller3,
                decoration: InputDecoration(
                    hintText: "Dealer ID",
                    border: OutlineInputBorder()

                ))
            ),
            Expanded(child: TextField(
                controller: _controller4,
                decoration: InputDecoration(
                    hintText: "Date (dd-mm-yyyy)",
                    border: OutlineInputBorder()

                ))
            ),

            ElevatedButton(
                onPressed: () {
                  var inputTitle = _controller0.value.text;
                  var inputCustID = int.parse(_controller1.value.text);
                  var inputCarID = int.parse(_controller2.value.text);
                  var inputDealerID = int.parse(_controller3.value.text);
                  var inputDate = _controller4.value.text;

                  setState(() {
                    var newRecord = SalesRecords(SalesRecords.ID++, inputTitle, inputCustID, inputCarID, inputDealerID, inputDate);

                    daoObj.addSalesRecord(newRecord);
                    records.add(newRecord);


                  });
                  _controller0.text = "";
                  _controller1.text = "";
                  _controller2.text = "";
                  _controller3.text = "";
                  _controller4.text = "";


                },
                child: Text("Add")
            ),

          ]),


      Expanded(child:
      ListView.builder(
          itemCount: records.length,
          itemBuilder: (context, rowNumber) {
            if (records.isEmpty) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text("There are no items in the list")],
              );

            } else if (records.isNotEmpty){
              return GestureDetector(
                  onLongPress: (){
                    setState(() {
                      daoObj.removeSalesRecord(records[rowNumber]);
                      records.removeAt(rowNumber);
                    });

                    // showDialog(context: context, builder: (BuildContext context) => AlertDialog(
                    //   title: Text("Would you like to autofill fields with those input?"),
                    //   actions: <Widget>[
                    //     Row(
                    //       children: [
                    //         ElevatedButton(
                    //             onPressed: () {
                    //                  final prefs = new EncryptedSharedPreferences();
                    //               setState(() {
                    //
                    //               });
                    //               Navigator.pop(context);
                    //             },
                    //             child: Text("Yes")),
                    //
                    //         ElevatedButton(
                    //             onPressed: (){
                    //               Navigator.pop(context);
                    //             },
                    //             child: Text("No"))
                    //       ],
                    //     )
                    //   ],
                    // ));
                  },
                  child:
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("${rowNumber+1}: ${records[rowNumber].title}")
                    ],
                  )
              );
            }
          }
      )
      )
    ],);
  }
  //
  // Widget detailsPage(){
  //
  // }

}

