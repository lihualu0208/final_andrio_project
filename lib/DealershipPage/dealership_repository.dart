/**
 * Handles persistent storage of dealership data using encrypted shared preferences.
 * Manages the last saved dealership information.
 */
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';

/// Manages dealership data persistence using encrypted shared preferences
class DealershipRepository {
  // Keys for shared preferences
  static const _nameKey = 'dealership_name';
  static const _addressKey = 'dealership_address';
  static const _cityKey = 'dealership_city';
  static const _postalCodeKey = 'dealership_postalCode';

  // Private fields
  String _name = '';
  String _address = '';
  String _city = '';
  String _postalCode = '';

  /// Getter for dealership name
  String get name => _name;

  /// Getter for dealership address
  String get address => _address;

  /// Getter for dealership city
  String get city => _city;

  /// Getter for dealership postal code
  String get postalCode => _postalCode;

  /// Instance of encrypted shared preferences
  final EncryptedSharedPreferences _prefs = EncryptedSharedPreferences();

  /// Loads saved dealership data from shared preferences
  Future<void> loadData() async {
    _name = (await _prefs.getString(_nameKey)) ?? '';
    _address = (await _prefs.getString(_addressKey)) ?? '';
    _city = (await _prefs.getString(_cityKey)) ?? '';
    _postalCode = (await _prefs.getString(_postalCodeKey)) ?? '';
  }

  /// Saves current dealership data to shared preferences
  Future<void> saveData() async {
    await Future.wait([
      _prefs.setString(_nameKey, _name),
      _prefs.setString(_addressKey, _address),
      _prefs.setString(_cityKey, _city),
      _prefs.setString(_postalCodeKey, _postalCode),
    ]);
  }

  /**
   * Saves complete dealership data to shared preferences.
   * Updates all fields and persists them.
   *
   * @param name The dealership name to save
   * @param address The dealership address to save
   * @param city The dealership city to save
   * @param postalCode The dealership postal code to save
   */
  Future<void> saveDealershipData({
    required String name,
    required String address,
    required String city,
    required String postalCode,
  }) async {
    this._name = name;
    this._address = address;
    this._city = city;
    this._postalCode = postalCode;
    await saveData();
  }
}