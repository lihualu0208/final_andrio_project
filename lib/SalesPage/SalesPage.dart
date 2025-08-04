import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'AppLocalizations.dart';
import 'SalesDatabase.dart';
import 'SalesRecords.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';

/// The main SalesPage widget that provides a responsive UI for managing
/// sales records, including creation, viewing, updating, deleting, and
/// persisting input data using encrypted shared preferences.
///
/// This widget supports localization (English and French) and allows
/// parent widgets to control the displayed locale via [forcedLocale] and
/// to respond to language changes via [onLocaleChange].
class SalesPage extends StatefulWidget {
  /// Callback to change the application's locale.
  final void Function(Locale) onLocaleChange;
  /// If provided, overrides the system locale for this page.
  final Locale? forcedLocale;

  /// Creates a [SalesPage] widget with optional locale forcing.
  const SalesPage({
    super.key,
    required this.onLocaleChange,
    this.forcedLocale,
  });

  @override
  State<SalesPage> createState() => SalesPageState();
}

/// The internal state class for [SalesPage].
///
/// Handles initialization of controllers, database, shared preferences,
/// and builds the localized UI including a split layout for wide screens.
class SalesPageState extends State<SalesPage> {
  // Controllers for input fields when creating a new sales record.
  late TextEditingController _controller0;
  late TextEditingController _controller1;
  late TextEditingController _controller2;
  late TextEditingController _controller3;
  late TextEditingController _controller4;

  // Controllers for editing existing sales records.
  late TextEditingController _displayCustID;
  late TextEditingController _displayTitle;
  late TextEditingController _displayCarID;
  late TextEditingController _displayDID;
  late TextEditingController _displayDate;

  /// List of current sales records fetched from the database.
  List<SalesRecords> records = [];
  /// DAO object from the SalesDatabase.
  late var daoObj;
  /// The currently selected record to view/edit.
  SalesRecords? selectedItem;

  /// Initializes controllers, loads sales records from the local database,
  /// and retrieves previously saved input values from encrypted shared preferences.
  ///
  /// This method is called once when the [SalesPageState] is first created.
  @override
  void initState() {
    super.initState();
    _controller0 = TextEditingController();
    _controller1 = TextEditingController();
    _controller2 = TextEditingController();
    _controller3 = TextEditingController();
    _controller4 = TextEditingController();

    _displayCustID = TextEditingController();
    _displayTitle = TextEditingController();
    _displayCarID = TextEditingController();
    _displayDID = TextEditingController();
    _displayDate = TextEditingController();

    $FloorSalesDatabase.databaseBuilder('final_database.db')
        .build()
        .then((database) async {
      daoObj = database.getDAO;
      var dbResults = await daoObj.getRecords();
      setState(() {
        records = dbResults;
      });
    });

    Future.delayed(Duration.zero, () async {
      EncryptedSharedPreferences prefs = EncryptedSharedPreferences();
      String prefsTitle = await prefs.getString("SalesPageTitle");
      String prefsCustId = await prefs.getString("SalesPageCustID");
      String prefsCarId = await prefs.getString("SalesPageCarID");
      String prefsDId = await prefs.getString("SalesPageDID");
      String prefsDate = await prefs.getString("SalesPageDate");

      if (prefsTitle != "" &&
          prefsCustId != "" &&
          prefsCarId != "" &&
          prefsDId != "" &&
          prefsDate != "") {
        setState(() {
          _controller0.text = prefsTitle;
          _controller1.text = prefsCustId;
          _controller2.text = prefsCarId;
          _controller3.text = prefsDId;
          _controller4.text = prefsDate;
        });
      }
    });
  }

  /// Disposes all text editing controllers to free resources.
  ///
  /// This method is called when the [SalesPageState] is permanently removed
  /// from the widget tree.
  @override
  void dispose() {
    _controller0.dispose();
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    _controller4.dispose();

    _displayTitle.dispose();
    _displayCustID.dispose();
    _displayCarID.dispose();
    _displayDID.dispose();
    _displayDate.dispose();

    super.dispose();
  }

  /// Builds the main SalesPage UI with localization and responsive layout.
  ///
  /// Includes:
  /// - AppBar with language switch buttons and help dialog
  /// - A responsive body that adapts to screen size
  ///
  /// Locale is overridden using [widget.forcedLocale] if provided.
  @override
  Widget build(BuildContext context) {
    final locale = widget.forcedLocale ?? const Locale('en');

    return Localizations.override(
      context: context,
      locale: locale,
      delegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      child: Builder(builder: (context) {
        final loc = AppLocalizations.of(context)!;

        return Scaffold(
          backgroundColor: const Color(0xFFF3F6FA),
          appBar: AppBar(
            backgroundColor: const Color(0xFFDFDFE4),
            title: Text(loc.translate("SalesPageTitle") ?? "Sales Page"),
            actions: [
              OutlinedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                ),
                onPressed: () => widget.onLocaleChange(const Locale("en")),
                child: const Text("EN"),
              ),
              OutlinedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                ),
                onPressed: () => widget.onLocaleChange(const Locale("fr")),
                child: const Text("FR"),
              ),
              IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(loc.translate('InstTitle') ?? 'Instructions'),
                      backgroundColor: const Color(0xFFE4E7ED),
                      content: Text(loc.translate('Instructions') ?? ''),
                      actions: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.black,
                          ),
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Got it!"),
                        )
                      ],
                    ),
                  );
                },
                icon: const Icon(Icons.question_mark),
              ),
            ],
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: responsiveLayout(loc),
            ),
          ),
        );
      }),
    );
  }

  /// Builds the responsive layout for the Sales page.
  ///
  /// - On large screens: displays both the list and details side-by-side.
  /// - On small screens: shows either the list or the selected item details.
  Widget responsiveLayout(AppLocalizations loc) {
    var size = MediaQuery.of(context).size;
    if (size.width > size.height && size.width > 720.0) {
      return Row(
        children: [
          Expanded(flex: 3, child: listPage(loc)),
          Expanded(flex: 2, child: detailsPage(loc)),
        ],
      );
    } else {
      return selectedItem == null
          ? listPage(loc)
          : detailsPage(loc);
    }
  }

  /// Builds the list panel UI containing:
  /// - Input fields for new sales record (Title, CustID, CarID, DID, Date)
  /// - Add button to insert new record
  /// - Scrollable list of existing sales records
  ///
  /// Tapping on a list item will show its details.
  Widget listPage(AppLocalizations loc) {
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: TextField(
            controller: _controller0,
            decoration: InputDecoration(
              hintText: loc.translate('Title'),
              border: const OutlineInputBorder(),
            ),
          )),
          Expanded(child: TextField(
            controller: _controller1,
            decoration: InputDecoration(
              hintText: loc.translate('CustID'),
              border: const OutlineInputBorder(),
            ),
          )),
          Expanded(child: TextField(
            controller: _controller2,
            decoration: InputDecoration(
              hintText: loc.translate('CarID'),
              border: const OutlineInputBorder(),
            ),
          )),
          Expanded(child: TextField(
            controller: _controller3,
            decoration: InputDecoration(
              hintText: loc.translate('DID'),
              border: const OutlineInputBorder(),
            ),
          )),
          Expanded(child: TextField(
            controller: _controller4,
            decoration: InputDecoration(
              hintText: loc.translate('Date'),
              border: const OutlineInputBorder(),
            ),
          )),
          ElevatedButton(
            onPressed: addRecord,
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.black,
            ),
            child: Text(loc.translate('Add') ?? "Add"),
          ),
        ],
      ),
      Expanded(
        child: ListView.builder(
          itemCount: records.length,
          itemBuilder: (context, i) {
            return GestureDetector(
              onTap: () => setState(() {
                selectedItem = records[i];
              }),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("${i + 1}: ${records[i].title}"),
                ],
              ),
            );
          },
        ),
      ),
    ]);
  }

  /// Validates and adds a new sales record to the database and shared preferences.
  ///
  /// - If fields are empty: shows an error SnackBar.
  /// - If valid: shows confirmation dialog and adds record,
  ///   then clears input fields and updates the list.
  void addRecord() async {
    if (_controller0.text.trim().isEmpty ||
        _controller1.text.trim().isEmpty ||
        _controller2.text.trim().isEmpty ||
        _controller3.text.trim().isEmpty ||
        _controller4.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.translate('FailMsg') ?? 'Please fill all fields'),
          action: SnackBarAction(label: "OK", onPressed: () {}),
        ),
      );
      return;
    }

    final prefs = EncryptedSharedPreferences();
    var inputTitle = _controller0.text;
    var inputCustID = _controller1.text;
    var inputCarID = _controller2.text;
    var inputDealerID = _controller3.text;
    var inputDate = _controller4.text;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(AppLocalizations.of(context)!.translate('Save') ?? "Save this data?"),
        actions: [
          ElevatedButton(
            onPressed: () {
              prefs.setString("SalesPageTitle", inputTitle);
              prefs.setString("SalesPageCustID", inputCustID);
              prefs.setString("SalesPageCarID", inputCarID);
              prefs.setString("SalesPageDID", inputDealerID);
              prefs.setString("SalesPageDate", inputDate);
              Navigator.pop(context);
            },
            child: Text(AppLocalizations.of(context)!.translate('Yes') ?? "Yes"),
          ),
          ElevatedButton(
            onPressed: () {
              prefs.clear();
              Navigator.pop(context);
            },
            child: Text(AppLocalizations.of(context)!.translate('No') ?? "No"),
          ),
        ],
      ),
    );

    setState(() {
      final newRecord = SalesRecords(
        SalesRecords.ID++,
        inputTitle,
        int.parse(inputCustID),
        int.parse(inputCarID),
        int.parse(inputDealerID),
        inputDate,
      );
      daoObj.addSalesRecord(newRecord);
      records.add(newRecord);

      _controller0.clear();
      _controller1.clear();
      _controller2.clear();
      _controller3.clear();
      _controller4.clear();
    });
  }

  /// Builds the details panel for the selected sales record.
  ///
  /// Allows editing the selected record using text fields, and provides
  /// buttons to delete, update, or close the detail view.
  ///
  /// If no item is selected, an empty widget is returned.
  Widget detailsPage(AppLocalizations loc) {
    if (selectedItem == null) return const SizedBox();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("${loc.translate('CurrTitle')} ${selectedItem?.title}"),
        Text("${loc.translate('CurrCustID')} ${selectedItem?.custID}"),
        Text("${loc.translate('CurrCarID')} ${selectedItem?.carID}"),
        Text("${loc.translate('CurrDID')} ${selectedItem?.dealerID}"),
        Text("${loc.translate('CurrDate')} ${selectedItem?.date}\n\n"),
        TextField(
          controller: _displayTitle,
          decoration: InputDecoration(hintText: loc.translate('UpdTitle')),
        ),
        TextField(
          controller: _displayCustID,
          decoration: InputDecoration(hintText: loc.translate('UpdCustID')),
        ),
        TextField(
          controller: _displayCarID,
          decoration: InputDecoration(hintText: loc.translate('UpdCarID')),
        ),
        TextField(
          controller: _displayDID,
          decoration: InputDecoration(hintText: loc.translate('UpdDID')),
        ),
        TextField(
          controller: _displayDate,
          decoration: InputDecoration(hintText: loc.translate('UpdDate')),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              daoObj.removeSalesRecord(selectedItem);
              records.remove(selectedItem);
              selectedItem = null;
              _displayTitle.clear();
              _displayCustID.clear();
              _displayCarID.clear();
              _displayDID.clear();
              _displayDate.clear();
            });
          },
          child: Text(loc.translate('DelBtn') ?? "Delete"),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              if (_displayTitle.text.isNotEmpty) {
                selectedItem?.title = _displayTitle.text;
              }
              if (_displayCustID.text.isNotEmpty) {
                selectedItem?.custID = int.parse(_displayCustID.text);
              }
              if (_displayCarID.text.isNotEmpty) {
                selectedItem?.carID = int.parse(_displayCarID.text);
              }
              if (_displayDID.text.isNotEmpty) {
                selectedItem?.dealerID = int.parse(_displayDID.text);
              }
              if (_displayDate.text.isNotEmpty) {
                selectedItem?.date = _displayDate.text;
              }

              daoObj.updateSalesRecord(selectedItem);

              selectedItem = null;
              _displayTitle.clear();
              _displayCustID.clear();
              _displayCarID.clear();
              _displayDID.clear();
              _displayDate.clear();
            });
          },
          child: Text(loc.translate('UpdBtn') ?? "Update"),
        ),
        ElevatedButton(
          onPressed: () => setState(() => selectedItem = null),
          child: Text(loc.translate('Close') ?? "Close"),
        ),
      ],
    );
  }
}
