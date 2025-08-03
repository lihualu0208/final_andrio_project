import 'package:flutter/material.dart';
import 'AppLocalizations.dart';
import 'SalesDatabase.dart';
import 'SalesRecords.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';

///Page class to extend StatefulWidget superclass
class SalesPage extends StatefulWidget {
  @override State<SalesPage> createState() {return SalesPageState();}
}

///the state for the Sales Page to be returned to SalesPage statefulWidget class create state method
class SalesPageState extends State<SalesPage> {
  ///This controller contains the Title of the new record to be added
  late TextEditingController _controller0;
  ///This controller contains the customer ID of the new record to be added
  late TextEditingController _controller1;
  ///This controller contains the car ID of the new record to be added
  late TextEditingController _controller2;
  ///This controller contains the Dealer ID of the new record to be added
  late TextEditingController _controller3;
  ///This controller contains the date of the new record to be added
  late TextEditingController _controller4;
  ///List of SalesRecords objects to be used to display the list of records from the database
  List<SalesRecords> records = [];
  ///variable to hold the data access object for the database
  late var daoObj;
  ///a variable to hold a reference to the selected object from the list of records from the database
  SalesRecords? selectedItem;
  ///This controller contains the customer ID of the current record displayed in the details page
  late TextEditingController _displayCustID;
  ///This controller contains the new title for the current record displayed in the details page to potentially be updated
  late TextEditingController _displayTitle;
  ///This controller contains the new car ID for the current record displayed in the details page to potentially be updated
  late TextEditingController _displayCarID;
  ///This controller contains the new dealer ID for the current record displayed in the details page to potentially be updated
  late TextEditingController _displayDID;
  ///This controller contains the new date for the current record displayed in the details page to potentially be updated
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
                    title: Text("${AppLocalizations.of(context)!.translate('InstTitle')}"),
                    content: Text("${AppLocalizations.of(context)!.translate('Instructions')}"),
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

  ///Widget to return the list portion of the page, containing input textFields
  ///for record fields an add button to add record to database and list, and
  ///the output of the list of returned SalesRecords objects for viewing and selection
  ///to display in detailsPage widget
  Widget listPage(){
    return Column(children: [
      Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children:[

            Expanded(child: TextField(
              controller: _controller0,
              decoration: InputDecoration(
                  hintText: "${AppLocalizations.of(context)!.translate('Title')}",
                  border: OutlineInputBorder()
              ),
            )),

            Expanded(child: TextField(
              controller: _controller1,
              decoration: InputDecoration(
                  hintText: "${AppLocalizations.of(context)!.translate('CustID')}",
                  border: OutlineInputBorder()
              ),
            )),

            Expanded(child: TextField(
                controller: _controller2,
                decoration: InputDecoration(
                    hintText: "${AppLocalizations.of(context)!.translate('CarID')}",
                    border: OutlineInputBorder()

                ))
            ),
            Expanded(child: TextField(
                controller: _controller3,
                decoration: InputDecoration(
                    hintText: "${AppLocalizations.of(context)!.translate('DID')}",
                    border: OutlineInputBorder()

                ))
            ),
            Expanded(child: TextField(
                controller: _controller4,
                decoration: InputDecoration(
                    hintText: "${AppLocalizations.of(context)!.translate('Date')}",
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
                    ///a snackBar item to reveal a popup to notify of empty fields
                    var popUp = SnackBar(
                      content: Text("${AppLocalizations.of(context)!.translate('FailMsg')}"),
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
                    ///variable to hold input in Title textfield
                    var inputTitle = _controller0.value.text;
                    ///variable to hold input in Customer ID textfield
                    var inputCustID = _controller1.value.text;
                    ///variable to hold input in CarID textfield
                    var inputCarID = _controller2.value.text;
                    ///variable to hold input in Dealer ID textfield
                    var inputDealerID = _controller3.value.text;
                    ///variable to hold input in date textfield
                    var inputDate = _controller4.value.text;

                    ///instance of EncryptedSharedPreferences to store
                    ///previous inputs for autofill upon page reaccess based
                    ///on user choice
                    final prefs = EncryptedSharedPreferences();
                    showDialog(context: context,
                        builder: (BuildContext context) => AlertDialog(

                          content: Text("${AppLocalizations.of(context)!.translate('Save')}"),
                          actions: <Widget>[

                            ElevatedButton(onPressed: () {
                              prefs.setString("SalesPageTitle", inputTitle);
                              prefs.setString("SalesPageCustID", inputCustID);
                              prefs.setString("SalesPageCarID", inputCarID);
                              prefs.setString("SalesPageDID", inputDealerID);
                              prefs.setString("SalesPageDate", inputDate);
                              Navigator.pop(context);
                            }, child: Text("${AppLocalizations.of(context)!.translate('Yes')}")),

                            ElevatedButton(onPressed: () {
                              prefs.clear();
                              Navigator.pop(context);
                            }, child: Text("${AppLocalizations.of(context)!.translate('No')}"))
                          ],
                        ));
                    setState(() {
                      ///create new object of SalesRecord class to add to
                      ///database
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
                child: Text("${AppLocalizations.of(context)!.translate('Add')}")
            ),

          ]),


      Expanded(child:
      ListView.builder(
          itemCount: records.length,
          itemBuilder: (context, rowNumber) {
            if (records.isEmpty) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text("${AppLocalizations.of(context)!.translate('NoVals')}")],
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

  ///detail pane of web page, to display attributes for currently selected
  ///SalesRecords object, as well as prompt the user with options to update
  ///or delete the viewed record of sale or any of its attributes (excepting ID)
  Widget detailsPage(){
    if(selectedItem != null){
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children:[
          Text("${AppLocalizations.of(context)!.translate('CurrTitle')} ${selectedItem?.title}"),
          Text("${AppLocalizations.of(context)!.translate('CurrCustID')} ${selectedItem?.custID}"),
          Text("${AppLocalizations.of(context)!.translate('CurrCarID')} ${selectedItem?.carID}"),
          Text("${AppLocalizations.of(context)!.translate('CurrDID')} ${selectedItem?.dealerID}"),
          Text("${AppLocalizations.of(context)!.translate('CurrDate')} ${selectedItem?.date}\n\n"),

          TextField(
            controller: _displayTitle,
            decoration: InputDecoration(
                hintText: "${AppLocalizations.of(context)!.translate('UpdTitle')}",
                border: OutlineInputBorder()
            ),
          ),
          TextField(
            controller: _displayCustID,
            decoration: InputDecoration(
                hintText: "${AppLocalizations.of(context)!.translate('UpdCustID')}",
                border: OutlineInputBorder()
            ),
          ),
          TextField(
            controller: _displayCarID,
            decoration: InputDecoration(
                hintText: "${AppLocalizations.of(context)!.translate('UpdCarID')}",
                border: OutlineInputBorder()
            ),
          ),
          TextField(
            controller: _displayDID,
            decoration: InputDecoration(
                hintText: "${AppLocalizations.of(context)!.translate('UpdDID')}",
                border: OutlineInputBorder()
            ),
          ),
          TextField(
            controller: _displayDate,
            decoration: InputDecoration(
                hintText: "${AppLocalizations.of(context)!.translate('UpdDate')}",
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
              child: Text("${AppLocalizations.of(context)!.translate('DelBtn')}")
          ),

          //button to update a record from list
          ElevatedButton(
              onPressed: (){
                setState(() {
                  ///var to hold title from updated title textField
                  String newTitle = _displayTitle.value.text;
                  ///var to hold potentially updated customer ID from updated customer ID textField
                  String newCustID = _displayCustID.value.text;
                  ///var to hold potentially updated car ID from updated car ID textField
                  String newCarID = _displayCarID.value.text;
                  ///var to hold potentially updated Dealer ID from updated Dealer ID textField
                  String newDID = _displayDID.value.text;
                  ///var to hold potentially updated date from updated date textField
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
              child: Text("${AppLocalizations.of(context)!.translate('UpdBtn')}")
          ),
          ElevatedButton(
              onPressed: (){
                setState(() {
                  selectedItem = null;
                });

              },
              child: Text("${AppLocalizations.of(context)!.translate('Close')}")
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

  ///widget to return a responsive layout based on window size, if Landscape
  ///returns view of the listPage and detailsPage widgets in a single pane,
  ///else if portrait dimensions, returns a changing layout where it displays
  ///the listPage until a record is selected, then returns detailsPage until
  ///record unselected
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

