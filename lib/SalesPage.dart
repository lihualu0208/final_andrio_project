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
  late TextEditingController _displayCustID;
  late TextEditingController _displayTitle;
  late TextEditingController _displayCarID;
  late TextEditingController _displayDID;
  late TextEditingController _displayDate;




  @override
  void initState() {
    super.initState();
    //listpage controllers
    _controller0 = TextEditingController();
    _controller1 = TextEditingController();
    _controller2 = TextEditingController();
    _controller3 = TextEditingController();
    _controller4 = TextEditingController();
    //display page controllers
    _displayCustID = TextEditingController();
    _displayTitle = TextEditingController();
    _displayCarID = TextEditingController();
    _displayDID = TextEditingController();
    _displayDate = TextEditingController();




    $FloorSalesDatabase.databaseBuilder('final_database.db')
        .build().then( (database) async {
      daoObj = database.getDAO;
      var dbResults = await daoObj.getRecords();
      setState(() {
        records = dbResults;
      });

    });

    Future.delayed(Duration.zero, () async {
      EncryptedSharedPreferences prefs = EncryptedSharedPreferences();
                            //set strings to hold ESP's
      String prefsTitle = await prefs.getString("SalesPageTitle");
      String prefsCustId = await prefs.getString("SalesPageCustID");
      String prefsCarId = await prefs.getString("SalesPageCarID");
      String prefsDId = await prefs.getString("SalesPageDID");
      String prefsDate = await prefs.getString("SalesPageDate");

      //if statements to check all prefs have values
      //if NOT NULL, then
      if (prefsTitle != "") {
        if (prefsCustId != "") {
          if (prefsCarId != ""){
            if (prefsDId != ""){
              if (prefsDate != ""){
                setState(() {
                  // set controllers text to EncrypSharPrefs
                  //eg _controller1.text = username;
                  _controller0.text = prefsTitle;
                  _controller1.text = prefsCustId;
                  _controller2.text = prefsCarId;
                  _controller3.text = prefsDId;
                  _controller4.text = prefsDate;
                });
              }
            }
          }
        }
      }
    });
  }

  @override
  void dispose() {
    //listpage controllers
    _controller0.dispose();
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    _controller4.dispose();
    //displayPage controllers
    _displayTitle.dispose();
    _displayCustID.dispose();
    _displayCarID.dispose();
    _displayDID.dispose();
    _displayDate.dispose();

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
                    content: const Text(
                        'To use this page, please enter '
                        'the ID\'s related to the customers, dealer, and car '
                        'sold, alongside the date of sale (in format dd-mm-yyyy)'
                            ' and a name for the '
                        'sale record.\nAfter creating an entry using the button,'
                        ' clicking an entry will reveal a page detailing the '
                        'features of the entry, as well as buttons to update or '
                        'delete the entry.\n In addition, after adding an entry,'
                        ' you are given the option to keep the same features to '
                        'autofill the text boxes to be reused next time you load'
                        ' the page.'
                    ),
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
            child: responsiveLayout()

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
                  if (_controller0.text.trim().isEmpty ||
                      _controller1.text.trim().isEmpty ||
                      _controller2.text.trim().isEmpty ||
                      _controller3.text.trim().isEmpty ||
                      _controller4.text.trim().isEmpty){
                          var popUp = SnackBar(
                            content: Text("Please enter data for all fields "
                                "before adding the record"),
                            duration: Duration(seconds: 60),
                            action: SnackBarAction(label: "OK", onPressed: () {
                              ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar();}),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(popUp);
                  } else if (_controller0.text.trim().isNotEmpty ||
                      _controller1.text.trim().isNotEmpty ||
                      _controller2.text.trim().isNotEmpty ||
                      _controller3.text.trim().isNotEmpty ||
                      _controller4.text.trim().isEmpty){
                            var inputTitle = _controller0.value.text;
                            var inputCustID = _controller1.value.text;
                            var inputCarID = _controller2.value.text;
                            var inputDealerID = _controller3.value.text;
                            var inputDate = _controller4.value.text;
                            final prefs = EncryptedSharedPreferences();
                            showDialog(context: context,
                                builder: (BuildContext context) => AlertDialog(

                                  content: const Text('Would you like to save '
                                      'these values for next time?'),
                                  actions: <Widget>[

                                    ElevatedButton(onPressed: () {
                                      prefs.setString("SalesPageTitle", inputTitle);
                                      prefs.setString("SalesPageCustID", inputCustID);
                                      prefs.setString("SalesPageCarID", inputCarID);
                                      prefs.setString("SalesPageDID", inputDealerID);
                                      prefs.setString("SalesPageDate", inputDate);
                                      Navigator.pop(context);
                                    }, child: Text("Yes")),

                                    ElevatedButton(onPressed: () {
                                      prefs.clear();
                                      Navigator.pop(context);
                                    }, child: Text("No"))
                                  ],
                                ));
                            setState(() {
                              var newRecord = SalesRecords(
                                  SalesRecords.ID++,
                                  inputTitle,
                                  int.parse(inputCustID),
                                  int.parse(inputCarID),
                                  int.parse(inputDealerID),
                                  inputDate
                              );
                              daoObj.addSalesRecord(newRecord);
                              records.add(newRecord);
                            });
                            _controller0.text = "";
                            _controller1.text = "";
                            _controller2.text = "";
                            _controller3.text = "";
                            _controller4.text = "";
                  }

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
                  onTap: (){
                    setState(() {
                      selectedItem = records[rowNumber];
                    });
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
  Widget detailsPage(){
    if(selectedItem != null){
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children:[
          Text("Title: ${selectedItem?.title}"),
          Text("Item Current Customer ID is ${selectedItem?.custID}"),
          Text("Item Current Car ID is ${selectedItem?.carID}"),
          Text("Item Current Dealer ID is ${selectedItem?.dealerID}"),
          Text("Item Current Date of Sale is ${selectedItem?.date}\n\n"),

          TextField(
            controller: _displayTitle,
            decoration: InputDecoration(
                hintText: "Updated name for record",
                border: OutlineInputBorder()
            ),
          ),
          TextField(
            controller: _displayCustID,
            decoration: InputDecoration(
                hintText: "Updated Customer ID for record",
                border: OutlineInputBorder()
            ),
          ),
          TextField(
            controller: _displayCarID,
            decoration: InputDecoration(
                hintText: "Updated Car ID for record",
                border: OutlineInputBorder()
            ),
          ),
          TextField(
            controller: _displayDID,
            decoration: InputDecoration(
                hintText: "Updated Dealer ID for record",
                border: OutlineInputBorder()
            ),
          ),
          TextField(
            controller: _displayDate,
            decoration: InputDecoration(
                hintText: "Updated date for record",
                border: OutlineInputBorder()
            ),
          ),



          //button to delete an record from list
          ElevatedButton(
              onPressed: (){
                setState(() {
                  daoObj.removeSalesRecord(selectedItem);
                  records.remove(selectedItem);
                  selectedItem = null;
                  _displayTitle.text = "";
                  _displayCustID.text = "";
                  _displayCarID.text = "";
                  _displayDID.text = "";
                  _displayDate.text = "";
                });

              },
              child: Text("Delete Entry")
          ),

          //button to update a record from list
          ElevatedButton(
              onPressed: (){
                setState(() {
                  String newTitle = _displayTitle.value.text;
                  String newCustID = _displayCustID.value.text;
                  String newCarID = _displayCarID.value.text;
                  String newDID = _displayDID.value.text;
                  String newDate = _displayDate.value.text;

                  if (_displayTitle.text != "") {
                    selectedItem?.title = newTitle;
                  }
                  if (_displayCustID.text != "") {
                    selectedItem?.custID = int.parse(newCustID);
                  }
                  if (_displayCarID.text != "") {
                    selectedItem?.carID = int.parse(newCarID);
                  }
                  if (_displayDID.text != "") {
                    selectedItem?.dealerID = int.parse(newDID);
                  }
                  if (_displayDate.text != "") {
                    selectedItem?.date = newDate;
                  }

                  daoObj.updateSalesRecord(selectedItem);

                  selectedItem = null;
                  _displayTitle.text = "";
                  _displayCustID.text = "";
                  _displayCarID.text = "";
                  _displayDID.text = "";
                  _displayDate.text = "";
                });

              },
              child: Text("Update Entry")
          ),
          ElevatedButton(
              onPressed: (){
                setState(() {
                  selectedItem = null;
                });

              },
              child: Text("Close")
          ),
        ],);
    } else {
      return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(""),
          ]
      );
    }
  }

  Widget responsiveLayout(){
    var size = MediaQuery.of(context).size;
    var height = size.height;
    var width = size.width;

    if (width>height && width > 720.00){
      return Row(children: [
        Expanded(
            flex: 3,
            child: listPage()
        ),

        Expanded(
            flex: 2,
            child: detailsPage())
        ,

      ],);
    } else {
      if(selectedItem==null){
        return listPage();
      } else {
        return detailsPage();
      }
    }
  }

}

