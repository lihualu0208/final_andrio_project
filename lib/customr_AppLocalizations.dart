import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/synchronous_future.dart';
import 'package:flutter/foundation.dart'; // For SynchronousFuture

class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
  _AppLocalizationsDelegate();

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'appTitle': 'Customer Management',
      'addCustomer': 'Add Customer',
      'editCustomer': 'Edit Customer',
      'firstName': 'First Name',
      'lastName': 'Last Name',
      'address': 'Address',
      'birthday': 'Birthday',
      'save': 'Save',
      'cancel': 'Cancel',
      'update': 'Update',
      'delete': 'Delete',
      'back': 'Back',
      'selectCustomer': 'Select a customer',
      'allFieldsRequired': 'All fields are required',
      'customerAdded': 'Customer added',
      'customerUpdated': 'Customer updated',
      'customerDeleted': 'Customer deleted',
      'instructionsTitle': 'App Instructions',
      'instructions':
      '• Tap + to add new customers\n'
          '• Select customers to view details\n'
          '• On large screens: Details show side-by-side\n'
          '• On phones: Details replace the list view\n'
          '• Use copy button to reuse previous data',
      'gotIt': 'Got it!',
      'usePrevious': 'Use previous customer data',
      'language': 'Language',
      'english': 'English',
      'chinese': 'Chinese',
    },
    'zh': {
      'appTitle': '客户管理',
      'addCustomer': '添加客户',
      'editCustomer': '编辑客户',
      'firstName': '名字',
      'lastName': '姓氏',
      'address': '地址',
      'birthday': '生日',
      'save': '保存',
      'cancel': '取消',
      'update': '更新',
      'delete': '删除',
      'back': '返回',
      'selectCustomer': '选择客户',
      'allFieldsRequired': '所有字段都是必填的',
      'customerAdded': '客户已添加',
      'customerUpdated': '客户已更新',
      'customerDeleted': '客户已删除',
      'instructionsTitle': '应用说明',
      'instructions':
      '• 点击+添加新客户\n'
          '• 选择客户查看详情\n'
          '• 大屏幕上：详情会并排显示\n'
          '• 手机上：详情会替换列表视图\n'
          '• 使用复制按钮重用之前的数据',
      'gotIt': '明白了！',
      'usePrevious': '使用之前的客户数据',
      'language': '语言',
      'english': '英文',
      'chinese': '中文',
    }
  };

  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ??
        _localizedValues['en']?[key] ??
        key;
  }

  static List<Locale> get supportedLocales {
    return const [Locale('en'), Locale('zh')];
  }
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'zh'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}