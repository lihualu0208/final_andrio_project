
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'SalesPage/AppLocalizations.dart';
import 'SalesPage/SalesPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp>{
  var _locale = Locale("en", "CA");

  void changeLanguage(Locale newLocale){
    setState(() {
      _locale = newLocale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      supportedLocales: [
        Locale("en", "CA"),
        Locale("fr", "FR"),
      ],

      localizationsDelegates: const[
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      locale: _locale,
      debugShowCheckedModeBanner: false,
      title: 'Group Project App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Group Project App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.help),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('App Instructions'),
                  content: const Text(
                    'Welcome to our group project app! Select one of the features below to get started.\n\n'
                        'Customer Page: Manage customer records\n'
                        'Car Page: Manage car inventory\n'
                        'Dealership Page: Manage dealership locations\n'
                        'Sales Page: Track car sales',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Customer Page coming soon!')),
                );
              },
              child: const Text('Customer Page'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Car Page coming soon!')),
                );
              },
              child: const Text('Car Page'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Dealership Page coming soon!')),
                );
              },
              child: const Text('Dealership Page'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SalesPage()),
                );
              },
              child: const Text('Sales Page'),
            ),
          ],
        ),
      ),
    );
  }
}
