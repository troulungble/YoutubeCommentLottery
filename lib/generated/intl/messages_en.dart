// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "alert_error": MessageLookupByLibrary.simpleMessage("Error"),
        "alert_no_network": MessageLookupByLibrary.simpleMessage(
            "This may be due to a connection issue. Please check your network connection and try again."),
        "appName":
            MessageLookupByLibrary.simpleMessage("YT Comment Lottery"),
        "btn_Next": MessageLookupByLibrary.simpleMessage("Next"),
        "btn_OK": MessageLookupByLibrary.simpleMessage("OK"),
        "btn_Retry": MessageLookupByLibrary.simpleMessage("Retry"),
        "candidatePage_Title":
            MessageLookupByLibrary.simpleMessage("Candidate list"),
        "drawPage_Congratulations":
            MessageLookupByLibrary.simpleMessage("🎊Congratulations🎊"),
        "drawPage_Title": MessageLookupByLibrary.simpleMessage("Draw"),
        "htd_desc": MessageLookupByLibrary.simpleMessage(
            "This APP can capture the comments by Youtube video, and take a lottery.\n"),
        "htd_step1": MessageLookupByLibrary.simpleMessage("Step 1："),
        "htd_step1_1":
            MessageLookupByLibrary.simpleMessage("Input Youtube video URL"),
        "htd_step1_2": MessageLookupByLibrary.simpleMessage(
            "Share Youtube video to this APP."),
        "htd_step1_or": MessageLookupByLibrary.simpleMessage("or"),
        "htd_step2": MessageLookupByLibrary.simpleMessage("Step 2："),
        "htd_step2_1": MessageLookupByLibrary.simpleMessage(
            "Pick a comment data range and input comment keyword (optional), then press \'Next\'. "),
        "htd_step2_2": MessageLookupByLibrary.simpleMessage(
            "P.S. Process time based on the number of comment."),
        "htd_step3": MessageLookupByLibrary.simpleMessage("Step 3："),
        "htd_step3_1":
            MessageLookupByLibrary.simpleMessage("Preview all comment."),
        "htd_step3_2": MessageLookupByLibrary.simpleMessage(
            "Hints：Press comment record to view the comment content."),
        "htd_step4": MessageLookupByLibrary.simpleMessage("Step 4："),
        "htd_step4_1": MessageLookupByLibrary.simpleMessage(
            "The winner of the sliding bead machine draw.\n(Drawing and winning can be repeated)"),
        "htd_step4_2": MessageLookupByLibrary.simpleMessage(
            "Hints：Press the winner\'s avatar or name to browse the winner\'s Youtube channel."),
        "loading": MessageLookupByLibrary.simpleMessage("Loading..."),
        "mainPage_Title":
            MessageLookupByLibrary.simpleMessage("YT Comment Lottery"),
        "mainPage_alert_Comment_Date": MessageLookupByLibrary.simpleMessage(
            "Please enter valid date range."),
        "mainPage_alert_YT_Video_Link": MessageLookupByLibrary.simpleMessage(
            "Please enter valid Youtube Link."),
        "mainPage_data_to": MessageLookupByLibrary.simpleMessage(" to "),
        "mainPage_hints_YT_Video_Link":
            MessageLookupByLibrary.simpleMessage("https://youtu.be/XXXXXX"),
        "mainPage_label_Comment_Date":
            MessageLookupByLibrary.simpleMessage("Comment Date *"),
        "mainPage_label_Keyword":
            MessageLookupByLibrary.simpleMessage("Comment Keyword (Optional)"),
        "mainPage_label_YT_Video_Link":
            MessageLookupByLibrary.simpleMessage("Youtube video link *"),
        "menu_home": MessageLookupByLibrary.simpleMessage("Home"),
        "menu_how_to_use": MessageLookupByLibrary.simpleMessage("How to use"),
        "menu_remove_ads": MessageLookupByLibrary.simpleMessage("Remove Ads")
      };
}
