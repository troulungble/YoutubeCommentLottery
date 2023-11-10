// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Youtube Comment Lottery`
  String get appName {
    return Intl.message(
      'Youtube Comment Lottery',
      name: 'appName',
      desc: '',
      args: [],
    );
  }

  /// `Loading...`
  String get loading {
    return Intl.message(
      'Loading...',
      name: 'loading',
      desc: '',
      args: [],
    );
  }

  /// `OK`
  String get btn_OK {
    return Intl.message(
      'OK',
      name: 'btn_OK',
      desc: '',
      args: [],
    );
  }

  /// `Next`
  String get btn_Next {
    return Intl.message(
      'Next',
      name: 'btn_Next',
      desc: '',
      args: [],
    );
  }

  /// `Retry`
  String get btn_Retry {
    return Intl.message(
      'Retry',
      name: 'btn_Retry',
      desc: '',
      args: [],
    );
  }

  /// `Error`
  String get alert_error {
    return Intl.message(
      'Error',
      name: 'alert_error',
      desc: '',
      args: [],
    );
  }

  /// `This may be due to a connection issue. Please check your network connection and try again.`
  String get alert_no_network {
    return Intl.message(
      'This may be due to a connection issue. Please check your network connection and try again.',
      name: 'alert_no_network',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get menu_home {
    return Intl.message(
      'Home',
      name: 'menu_home',
      desc: '',
      args: [],
    );
  }

  /// `How to use`
  String get menu_how_to_use {
    return Intl.message(
      'How to use',
      name: 'menu_how_to_use',
      desc: '',
      args: [],
    );
  }

  /// `Remove Ads`
  String get menu_remove_ads {
    return Intl.message(
      'Remove Ads',
      name: 'menu_remove_ads',
      desc: '',
      args: [],
    );
  }

  /// `Youtube Comment Lottery`
  String get mainPage_Title {
    return Intl.message(
      'Youtube Comment Lottery',
      name: 'mainPage_Title',
      desc: '',
      args: [],
    );
  }

  /// ` to `
  String get mainPage_data_to {
    return Intl.message(
      ' to ',
      name: 'mainPage_data_to',
      desc: '',
      args: [],
    );
  }

  /// `Youtube video link *`
  String get mainPage_label_YT_Video_Link {
    return Intl.message(
      'Youtube video link *',
      name: 'mainPage_label_YT_Video_Link',
      desc: '',
      args: [],
    );
  }

  /// `https://youtu.be/XXXXXX`
  String get mainPage_hints_YT_Video_Link {
    return Intl.message(
      'https://youtu.be/XXXXXX',
      name: 'mainPage_hints_YT_Video_Link',
      desc: '',
      args: [],
    );
  }

  /// `Please enter valid Youtube Link.`
  String get mainPage_alert_YT_Video_Link {
    return Intl.message(
      'Please enter valid Youtube Link.',
      name: 'mainPage_alert_YT_Video_Link',
      desc: '',
      args: [],
    );
  }

  /// `Comment Date *`
  String get mainPage_label_Comment_Date {
    return Intl.message(
      'Comment Date *',
      name: 'mainPage_label_Comment_Date',
      desc: '',
      args: [],
    );
  }

  /// `Please enter valid date range.`
  String get mainPage_alert_Comment_Date {
    return Intl.message(
      'Please enter valid date range.',
      name: 'mainPage_alert_Comment_Date',
      desc: '',
      args: [],
    );
  }

  /// `Comment Keyword (Optional)`
  String get mainPage_label_Keyword {
    return Intl.message(
      'Comment Keyword (Optional)',
      name: 'mainPage_label_Keyword',
      desc: '',
      args: [],
    );
  }

  /// `Candidate list`
  String get candidatePage_Title {
    return Intl.message(
      'Candidate list',
      name: 'candidatePage_Title',
      desc: '',
      args: [],
    );
  }

  /// `Draw`
  String get drawPage_Title {
    return Intl.message(
      'Draw',
      name: 'drawPage_Title',
      desc: '',
      args: [],
    );
  }

  /// `🎊Congratulations🎊`
  String get drawPage_Congratulations {
    return Intl.message(
      '🎊Congratulations🎊',
      name: 'drawPage_Congratulations',
      desc: '',
      args: [],
    );
  }

  /// `This APP can capture the comments by Youtube video, and take a lottery.\n`
  String get htd_desc {
    return Intl.message(
      'This APP can capture the comments by Youtube video, and take a lottery.\n',
      name: 'htd_desc',
      desc: '',
      args: [],
    );
  }

  /// `Step 1：`
  String get htd_step1 {
    return Intl.message(
      'Step 1：',
      name: 'htd_step1',
      desc: '',
      args: [],
    );
  }

  /// `Input Youtube video URL`
  String get htd_step1_1 {
    return Intl.message(
      'Input Youtube video URL',
      name: 'htd_step1_1',
      desc: '',
      args: [],
    );
  }

  /// `or`
  String get htd_step1_or {
    return Intl.message(
      'or',
      name: 'htd_step1_or',
      desc: '',
      args: [],
    );
  }

  /// `Share Youtube video to this APP.`
  String get htd_step1_2 {
    return Intl.message(
      'Share Youtube video to this APP.',
      name: 'htd_step1_2',
      desc: '',
      args: [],
    );
  }

  /// `Step 2：`
  String get htd_step2 {
    return Intl.message(
      'Step 2：',
      name: 'htd_step2',
      desc: '',
      args: [],
    );
  }

  /// `Pick a comment data range and input comment keyword (optional), then press 'Next'. `
  String get htd_step2_1 {
    return Intl.message(
      'Pick a comment data range and input comment keyword (optional), then press \'Next\'. ',
      name: 'htd_step2_1',
      desc: '',
      args: [],
    );
  }

  /// `P.S. Process time based on the number of comment.`
  String get htd_step2_2 {
    return Intl.message(
      'P.S. Process time based on the number of comment.',
      name: 'htd_step2_2',
      desc: '',
      args: [],
    );
  }

  /// `Step 3：`
  String get htd_step3 {
    return Intl.message(
      'Step 3：',
      name: 'htd_step3',
      desc: '',
      args: [],
    );
  }

  /// `Preview all comment.`
  String get htd_step3_1 {
    return Intl.message(
      'Preview all comment.',
      name: 'htd_step3_1',
      desc: '',
      args: [],
    );
  }

  /// `Hints：Press comment record to view the comment content.`
  String get htd_step3_2 {
    return Intl.message(
      'Hints：Press comment record to view the comment content.',
      name: 'htd_step3_2',
      desc: '',
      args: [],
    );
  }

  /// `Step 4：`
  String get htd_step4 {
    return Intl.message(
      'Step 4：',
      name: 'htd_step4',
      desc: '',
      args: [],
    );
  }

  /// `The winner of the sliding bead machine draw.\n(Drawing and winning can be repeated)`
  String get htd_step4_1 {
    return Intl.message(
      'The winner of the sliding bead machine draw.\n(Drawing and winning can be repeated)',
      name: 'htd_step4_1',
      desc: '',
      args: [],
    );
  }

  /// `Hints：Press the winner's avatar or name to browse the winner's Youtube channel.`
  String get htd_step4_2 {
    return Intl.message(
      'Hints：Press the winner\'s avatar or name to browse the winner\'s Youtube channel.',
      name: 'htd_step4_2',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'zh', countryCode: 'CN'),
      Locale.fromSubtags(languageCode: 'zh', countryCode: 'HK'),
      Locale.fromSubtags(languageCode: 'zh', countryCode: 'TW'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
