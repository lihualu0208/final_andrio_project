import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';

class CustomerRepository {
  // Keys
  static const _firstNameKey = 'customer_firstName';
  static const _lastNameKey = 'customer_lastName';
  static const _addressKey = 'customer_address';
  static const _birthdayKey = 'customer_birthday';

  // Private fields
  String _firstName = '';
  String _lastName = '';
  String _address = '';
  String _birthday = '';

  // Getters
  String get firstName => _firstName;
  String get lastName => _lastName;
  String get address => _address;
  String get birthday => _birthday;

  final EncryptedSharedPreferences _prefs = EncryptedSharedPreferences();

  Future<void> loadData() async {
    _firstName = (await _prefs.getString(_firstNameKey)) ?? '';
    _lastName = (await _prefs.getString(_lastNameKey)) ?? '';
    _address = (await _prefs.getString(_addressKey)) ?? '';
    _birthday = (await _prefs.getString(_birthdayKey)) ?? '';
  }

  Future<void> saveData() async {
    await Future.wait([
      _prefs.setString(_firstNameKey, _firstName),
      _prefs.setString(_lastNameKey, _lastName),
      _prefs.setString(_addressKey, _address),
      _prefs.setString(_birthdayKey, _birthday),
    ]);
  }

  Future<void> clearData() async {
    await Future.wait([
      _prefs.remove(_firstNameKey),
      _prefs.remove(_lastNameKey),
      _prefs.remove(_addressKey),
      _prefs.remove(_birthdayKey),
    ]);
    _firstName = '';
    _lastName = '';
    _address = '';
    _birthday = '';
  }

  // Setters
  set firstName(String value) => _firstName = value.trim();
  set lastName(String value) => _lastName = value.trim();
  set address(String value) => _address = value.trim();
  set birthday(String value) => _birthday = value.trim();

  Future<void> saveCustomerData({
    required String firstName,
    required String lastName,
    required String address,
    required String birthday,
  }) async {
    this.firstName = firstName;
    this.lastName = lastName;
    this.address = address;
    this.birthday = birthday;
    await saveData();
  }
}