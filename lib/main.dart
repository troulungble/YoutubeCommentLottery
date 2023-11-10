import 'dart:async';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:receive_intent/receive_intent.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:receive_intent/receive_intent.dart' as ReceiveIntentPackage;

import 'Widget.dart';
import 'commentEntity.dart';
import 'common.dart';
import 'generated/l10n.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    MaterialColor getThemeColor() {
      Map<int, Color> color =
      {
        50: Color.fromRGBO(92, 255, 184, .1),
        100: Color.fromRGBO(92, 255, 184, .2),
        200: Color.fromRGBO(92, 255, 184, .3),
        300: Color.fromRGBO(92, 255, 184, .4),
        400: Color.fromRGBO(92, 255, 184, .5),
        500: Color.fromRGBO(92, 255, 184, .6),
        600: Color.fromRGBO(92, 255, 184, .7),
        700: Color.fromRGBO(92, 255, 184, .8),
        800: Color.fromRGBO(92, 255, 184, .9),
        900: Color.fromRGBO(92, 255, 184, 1),
      };

      return MaterialColor(0xff51c794, color) ;
    }

    return MaterialApp(
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      supportedLocales: [
        Locale('en', 'US'),
        const Locale.fromSubtags(languageCode: 'zh',countryCode: "CN"),
        const Locale.fromSubtags(languageCode: 'zh',countryCode: "TW"),
        const Locale.fromSubtags(languageCode: 'zh',countryCode: "HK"),
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        for (var supportedLocaleLanguage in supportedLocales) {
          if (supportedLocaleLanguage.languageCode == locale?.languageCode &&
              supportedLocaleLanguage.countryCode == locale?.countryCode) {
            return supportedLocaleLanguage;
          }
        }
        // If device not support with locale to get language code then default get first on from the list
        return supportedLocales.first;
      },
      home: Scaffold(
        body: MainPage(),
      ),
      theme: ThemeData(
        primarySwatch: getThemeColor(),
        scaffoldBackgroundColor: Colors.white, //<-- SEE HERE
      ),
    );
  }
}

// Create UrlPage
class MainPage extends StatefulWidget {
  @override
  MainPageState createState() {
    return MainPageState();
  }
}

class MainPageState extends State<MainPage> {

  final _formKey = GlobalKey<FormState>();
  String ytVideoURL = "" ;
  String ytVideoId = "" ;
  var showImg = false ;
  String previewImgUrl_prefix = "https://img.youtube.com/vi/";
  String previewImgUrl_suffix = "/0.jpg" ;
  String previewImgUrl = "";

  late StreamSubscription _intentDataStreamSubscription;

  TextEditingController videoUrlController = TextEditingController();
  final TextEditingController startEndDateInputCtrl = TextEditingController();
  final DateRangePickerController dateRangePickerCtrl = DateRangePickerController();
  final TextEditingController searchKeywordController = TextEditingController() ;

  String tempStartDate = "" ;
  String tempEndDate = "";
  String startDate = "" ;
  String endDate = "";

  late List<Comment> youtubeVideoComment ;

  InterstitialAd? _interstitialAd;

  // TODO: replace this test ad unit with your own ad unit.
  final adUnitId_full = "ca-app-pub-7157197349004035/2796193619" ;

  final focus = FocusNode();

  bool showAds = true ;

  Future<void> videoUrlOnChange(String value) async {
    LoadingScreen.show(context, S.of(context).loading);

    await checkNetwork(context, S.of(context).alert_error, S.of(context).alert_no_network, S.of(context).btn_Retry) ;

    if (value.isNotEmpty) {

      if (ytVideoId.isNotEmpty) {
        Uri imageUri = Uri.parse(
            previewImgUrl_prefix + ytVideoId + previewImgUrl_suffix);
        bool validImage = await checkHttpUrl(imageUri);
        if (validImage) {
          setState(() {
            showImg = true;
            previewImgUrl = previewImgUrl_prefix + ytVideoId + previewImgUrl_suffix;
            FocusScope.of(context).requestFocus(focus);
          });
        } else {
          setState(() {
            showImg = false;
          });
        }
      } else {
        setState(() {
          showImg = false;
        });
      }
    }else{
      setState(() {
        ytVideoId = "" ;
        showImg = false;
      });
    }

    LoadingScreen.hide(context);
  }

  Future<T?> showDateRangePickerDialog<T>(){
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              content: Container(
                width: 100,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListView(
                      shrinkWrap: true,
                      children: [
                        getDateRangePicker()
                      ],
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: ElevatedButton(
                        child: Text(S.of(context).btn_OK),
                        onPressed: () {
                          setState(() {
                            if (isDateTime(tempStartDate) && isDateTime(tempEndDate)){
                              startDate = tempStartDate ;
                              endDate = tempEndDate ;
                              startEndDateInputCtrl.text = startDate + S.of(context).mainPage_data_to + endDate ;
                            }
                          });
                          Navigator.pop(context);
                        },
                      ),
                    )
                  ],
                )
              ));
        });
  }

  void dateRangeSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    SchedulerBinding.instance!.addPostFrameCallback((duration) {
      tempStartDate = "" ;
      tempEndDate = "" ;

      if (args.value.startDate!=null) {
        tempStartDate = DateFormat('yyyy-MM-dd').format(args.value.startDate).toString();
      }

      if (args.value.endDate!=null) {
        tempEndDate = DateFormat('yyyy-MM-dd').format(args.value.endDate).toString();
      }else{
        if (tempStartDate.isNotEmpty){
          tempEndDate = tempStartDate ;
        }
      }
    });
  }

  Widget getDateRangePicker() {
    return Card(
        child: SfDateRangePicker(
          monthViewSettings: DateRangePickerMonthViewSettings(
            viewHeaderHeight: 70,
          ),
          controller: dateRangePickerCtrl,
          view: DateRangePickerView.month,
          initialSelectedRange: dateRangePickerCtrl.selectedRange ,
          selectionMode: DateRangePickerSelectionMode.range,
          minDate: DateTime(2000),
          maxDate: DateTime(2100),
          onSelectionChanged: dateRangeSelectionChanged,
          onViewChanged: (DateRangePickerViewChangedArgs args) {
            final PickerDateRange visibleDates = args.visibleDateRange;
            final DateRangePickerView view = args.view;
          },
        )
    );
  }

  Future<void> receivedIntentInit() async {
    final receivedIntent = await ReceiveIntent.getInitialIntent();

    StreamSubscription _sub;

    _sub = ReceiveIntent.receivedIntentStream.listen((ReceiveIntentPackage.Intent? intent) {
      // Validate receivedIntent and warn the user, if it is not correct,

      if (intent!=null){

        setState(() {
          while (Navigator.canPop(context)){
            Navigator.pop(context) ;
          }

          //Navigator.popUntil(context, ModalRoute.withName("/MainPage"));

          ytVideoURL = intent.extra?['android.intent.extra.TEXT'] ;
          if (isNotNullAndNotEmpty(ytVideoURL)) {
            ytVideoId = validateYoutubeUrl(ytVideoURL!) ;
            if (ytVideoId.isNotEmpty) {
              videoUrlOnChange(ytVideoURL);

              tempStartDate = "" ;
              tempEndDate = "";
              startDate = "" ;
              endDate = "";

              setState(() {
                startEndDateInputCtrl.clear() ;
                videoUrlController.text = ytVideoURL ;
                searchKeywordController.clear();
                dateRangePickerCtrl.selectedRange = null ;
              });
            }
          }
        });

      }


    }, onError: (err) {
      // Handle exception
    });

  }

  @override
  void initState() {
    super.initState();

    receivedIntentInit();

    // final receivedIntent = await ReceiveIntent.getInitialIntent();

    // For sharing or opening urls/text coming from outside the app while the app is in the memory
    // _intentDataStreamSubscription =
    //   ReceiveSharingIntent.getTextStream().listen((String value) {
    //     while (Navigator.canPop(context)){
    //       Navigator.pop(context) ;
    //     }
    //
    //     //Navigator.popUntil(context, ModalRoute.withName("/MainPage"));
    //
    //     ytVideoURL = value;
    //     if (isNotNullAndNotEmpty(ytVideoURL)) {
    //       ytVideoId = validateYoutubeUrl(ytVideoURL!) ;
    //       if (ytVideoId.isNotEmpty) {
    //         videoUrlOnChange(ytVideoURL);
    //
    //         tempStartDate = "" ;
    //         tempEndDate = "";
    //         startDate = "" ;
    //         endDate = "";
    //
    //         setState(() {
    //           startEndDateInputCtrl.clear() ;
    //           videoUrlController.text = ytVideoURL ;
    //           searchKeywordController.clear();
    //           dateRangePickerCtrl.selectedRange = null ;
    //         });
    //       }
    //     }
    //   }, onError: (err) {
    //     print("getLinkStream error: $err");
    //   });
  }

  @override
  void dispose() {
    _intentDataStreamSubscription.cancel();
    super.dispose();
  }

  Future<void> setDataRecord(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  Future<String> getDataRecord(String key) async {
    final prefs = await SharedPreferences.getInstance();
    var postDataRecord = prefs.getString(key);
    if (postDataRecord == null) {
      return "";
    }
    return postDataRecord.toString();
  }

  @override
  Widget build(BuildContext context) {

    // print("main build") ;
    loadAd();

    List<String> menuLabel = [
      S.of(context).menu_home, S.of(context).menu_how_to_use, S.of(context).menu_remove_ads
    ];

    List<Widget> htd_items = [
      howToUse_1([S.of(context).htd_desc,S.of(context).htd_step1,S.of(context).htd_step1_1,S.of(context).htd_step1_or,S.of(context).htd_step1_2]),
      howToUse_2([S.of(context).htd_step2,S.of(context).htd_step2_1,S.of(context).htd_step2_2]),
      howToUse_3([S.of(context).htd_step3,S.of(context).htd_step3_1,S.of(context).htd_step3_2]),
      howToUse_4([S.of(context).htd_step4,S.of(context).htd_step4_1,S.of(context).htd_step4_2])
    ] ;

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await checkNetwork(context, S.of(context).alert_error, S.of(context).alert_no_network, S.of(context).btn_Retry) ;

      String readHowtoDoStr = await getDataRecord("readHowtoDo") ;
      if (isNotNullAndNotEmpty(readHowtoDoStr)) {
        if ("TRUE" == readHowtoDoStr.toUpperCase()){
          showHowToUse(context, menuLabel[1], htd_items) ;
          setDataRecord("readHowtoDo", "FALSE") ;
        }
      }else{
        showHowToUse(context, menuLabel[1], htd_items) ;
        setDataRecord("readHowtoDo", "FALSE") ;
      }
    });

    return Scaffold(
      appBar: getAppbar(),
      drawer: getMenu(context, S.of(context).appName, menuLabel, htd_items),
      body: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/bg.png"), fit: BoxFit.fill)
          ),
          height: double.infinity,
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.all(15.0),
            children: <Widget>[
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                        children: [
                          TextFormField(
                            controller: videoUrlController,
                            decoration: InputDecoration(
                              icon: Icon(Icons.link), //icon of text field
                              labelText: S.of(context).mainPage_label_YT_Video_Link,
                              hintText: S.of(context).mainPage_hints_YT_Video_Link,
                              suffixIcon: IconButton(
                                onPressed: (){
                                  setState(() {
                                    videoUrlController.clear();
                                    videoUrlOnChange("");
                                  });
                                },
                                icon: Icon(Icons.clear),
                              ),
                            ),
                            autofocus: true,
                            validator: (value) {
                              // print("ytVideoId1 = " + ytVideoId) ;
                              if (isNotNullAndNotEmpty(ytVideoId)) {
                                return null;
                              }else {
                                return S.of(context).mainPage_alert_YT_Video_Link ;
                              }
                            },
                            onChanged: (value) async {
                              if (isNotNullAndNotEmpty(value)) {
                                ytVideoId = validateYoutubeUrl(value!) ;
                                videoUrlOnChange(value);
                              }
                            },
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                          ),
                          Visibility(
                            visible: showImg,
                            child: Image.network(previewImgUrl),
                          ),
                          // Container(
                          //   alignment: Alignment.topLeft,
                          //   child: const Text("Winning conditions:"),
                          // ),
                          TextFormField(
                            focusNode: focus,
                            controller: startEndDateInputCtrl,
                            //editing controller of this TextField
                            decoration: InputDecoration(
                                icon: Icon(Icons.calendar_today), //icon of text field
                                labelText: S.of(context).mainPage_label_Comment_Date //label text of field
                            ),
                            readOnly: true,
                            //set it true, so that user will not able to edit text
                            onTap: () async {
                              showDateRangePickerDialog() ;
                            },
                            validator: (value) {
                              if (isDateTime(tempStartDate) && isDateTime(tempEndDate)){
                                return null;
                              }else {
                                return S.of(context).mainPage_alert_Comment_Date;
                              }
                            },
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                          ),
                          TextFormField(
                            controller: searchKeywordController,
                            decoration: InputDecoration(
                              icon: Icon(Icons.search), //icon of text field
                              labelText: S.of(context).mainPage_label_Keyword,
                              suffixIcon: IconButton(
                                onPressed: (){
                                  setState(() {
                                    searchKeywordController.clear();
                                  });
                                },
                                icon: Icon(Icons.clear),
                              ),
                            ),
                          ),
                          Align(
                            child: ElevatedButton(
                              autofocus: true,
                              onPressed: () async {
                                if (!_formKey.currentState!.validate()){
                                  // if (!isNotNullAndNotEmpty(ytVideoId)) {
                                  //   showAlertDialog(context, "Please enter Youtube Link.", "OK") ;
                                  // }else if (!isDateTime(startDate) || !isDateTime(endDate)) {
                                  //   showAlertDialog(context, "Please enter valid date range.", "OK") ;
                                  // }
                                }else{
                                  if (isDateTime(tempStartDate) && isDateTime(tempEndDate)) {
                                    LoadingScreen.show(context, S.of(context).loading);

                                    await checkNetwork(context, S.of(context).alert_error, S.of(context).alert_no_network, S.of(context).btn_Retry) ;
                                    youtubeVideoComment = await getYoutubeVideoComment(ytVideoId, startDate, endDate,searchKeywordController.text);

                                    if (showAds && _interstitialAd!=null) {
                                      _interstitialAd?.show();
                                    }else{
                                      int currentRowsPerPage = 5 ;
                                      List<int> pagePageArray = <int>[5,10,15] ;
                                      if (MediaQuery.of(context).size.height>=640){
                                        pagePageArray = <int>[8,16,24] ;
                                        currentRowsPerPage = 8 ;
                                      }

                                      LoadingScreen.hide(context) ;
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => CandidateListPage(youtubeVideoComment: youtubeVideoComment, currentRowsPerPage: currentRowsPerPage, pagePageArray: pagePageArray, showAds:showAds)));
                                      _interstitialAd = null ;
                                    }
                                  }else{
                                    //showAlertDialog(context, "Please enter valid date range.", "OK") ;
                                  }
                                }
                              },
                              child: Text(S.of(context).btn_Next),
                            ),
                          ),
                        ]
                    )
                  ],
                ),
              )
            ],
          )
      )
    );
  }

  void loadAd() {
    // print("loadAd") ;
    InterstitialAd.load(
        adUnitId: adUnitId_full,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          // Called when an ad is successfully received.
          onAdLoaded: (ad) {
            ad.fullScreenContentCallback = FullScreenContentCallback(
              // Called when the ad showed the full screen content.
                onAdShowedFullScreenContent: (ad) {
                  print("onAdShowedFullScreenContent") ;
                },
                // Called when an impression occurs on the ad.
                onAdImpression: (ad) {
                  print("onAdImpression") ;
                },
                // Called when the ad failed to show full screen content.
                onAdFailedToShowFullScreenContent: (ad, err) {
                  // Dispose the ad here to free resources.
                  ad.dispose();

                  _interstitialAd = null ;

                  int currentRowsPerPage = 5 ;
                  List<int> pagePageArray = <int>[5,10,15] ;
                  if (MediaQuery.of(context).size.height>=640){
                    pagePageArray = <int>[8,16,24] ;
                    currentRowsPerPage = 8 ;
                  }

                  LoadingScreen.hide(context) ;
                  Navigator.push(context, MaterialPageRoute(builder: (context) => CandidateListPage(youtubeVideoComment: youtubeVideoComment, currentRowsPerPage: currentRowsPerPage, pagePageArray: pagePageArray, showAds:showAds)));
                },
                // Called when the ad dismissed full screen content.
                onAdDismissedFullScreenContent: (ad) {
                  // Dispose the ad here to free resources.
                  ad.dispose();

                  int currentRowsPerPage = 5 ;
                  List<int> pagePageArray = <int>[5,10,15] ;
                  if (MediaQuery.of(context).size.height>=640){
                    pagePageArray = <int>[8,16,24] ;
                    currentRowsPerPage = 8 ;
                  }

                  LoadingScreen.hide(context) ;
                  Navigator.push(context, MaterialPageRoute(builder: (context) => CandidateListPage(youtubeVideoComment: youtubeVideoComment, currentRowsPerPage: currentRowsPerPage, pagePageArray: pagePageArray, showAds:showAds)));
                },
                // Called when a click is recorded for an ad.
                onAdClicked: (ad) {});

            print('$ad loaded.');
            // Keep a reference to the ad so you can show it later.
            _interstitialAd = ad;
          },
          // Called when an ad request failed.
          onAdFailedToLoad: (LoadAdError error) {
            print('InterstitialAd failed to load: $error');
            _interstitialAd = null ;
          },
        ));
  }
}

// Create CandidateListPage
class CandidateListPage extends StatefulWidget {
  List<Comment> youtubeVideoComment;
  int currentRowsPerPage ;
  List<int> pagePageArray ;
  bool showAds;

  CandidateListPage({super.key,required this.youtubeVideoComment,required this.currentRowsPerPage,required this.pagePageArray, required this.showAds}) ;

  @override
  CandidateListPageState createState() {
    return CandidateListPageState(youtubeVideoComment:youtubeVideoComment, currentRowsPerPage: currentRowsPerPage, pagePageArray: pagePageArray, showAds:showAds);
  }
}

class CandidateListPageState extends State<CandidateListPage> {
  List<Comment> youtubeVideoComment;
  int currentRowsPerPage ;
  List<int> pagePageArray ;
  bool showAds ;

  CandidateListPageState({required this.youtubeVideoComment,required this.currentRowsPerPage,required this.pagePageArray,required this.showAds});

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getBackMenu(context),
      body:Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/bg.png"), fit: BoxFit.fill)
        ),
        child: Column(
          children: [
            Expanded(
              child: Container(
                  child: ListView(
                      shrinkWrap: true,
                      padding: EdgeInsets.all(15.0),
                      children: <Widget>[
                        PaginatedDataTable(
                          headingRowHeight: 0,
                          source: CommentDataTable(context, youtubeVideoComment),
                          columns: const [
                            DataColumn(label: Text('')),
                          ],
                          columnSpacing: 0,
                          horizontalMargin: 0,
                          dataRowHeight: 60,
                          showCheckboxColumn: false,
                          rowsPerPage: currentRowsPerPage,
                          availableRowsPerPage: pagePageArray,
                          onRowsPerPageChanged: (value) {
                            setState(() {
                              currentRowsPerPage = value!;
                            });
                          },
                        ),
                      ]
                  )
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Visibility(
                visible: youtubeVideoComment.length>0,
                child: ElevatedButton(
                  onPressed: () async {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => DrawPage(youtubeVideoComment:youtubeVideoComment,showAds:showAds)));
                  },
                  child: Text(S.of(context).btn_Next),
                ),
              ),
            )
          ],
        )
      )
    );
  }
}

// Create DrawPage
class DrawPage extends StatefulWidget {
  List<Comment> youtubeVideoComment;
  bool showAds ;
  DrawPage({super.key,required this.youtubeVideoComment, required this.showAds}) ;

  @override
  DrawPageState createState() {
    return DrawPageState(youtubeVideoComment:youtubeVideoComment, showAds:showAds);
  }
}

class DrawPageState extends State<DrawPage> with SingleTickerProviderStateMixin {
  List<Comment> youtubeVideoComment;
  bool showAds ;

  DrawPageState({required this.youtubeVideoComment, required this.showAds});

  final player1 = AudioPlayer();
  final player2 = AudioPlayer();

  BannerAd? _bannerAd_1;
  BannerAd? _bannerAd_2;

  bool _isLoaded_1 = false;
  bool _isLoaded_2 = false;

  var adUnitId_banner1 = "ca-app-pub-7157197349004035/6941384382" ;
  var adUnitId_banner2 = "ca-app-pub-7157197349004035/1449384559" ;

  late AnimationController animationController ;
  var moving = false ;
  var secondMoving = false ;
  var reseting = false ;

  var resultIndex = -1;


  @override
  void initState() {
    animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_bannerAd_1==null)
      loadAd_1() ;
    if (_bannerAd_2==null)
      loadAd_2() ;

     return Scaffold(
       appBar: getBackMenu(context),
       body: Container(
         decoration: const BoxDecoration(
             image: DecorationImage(
                 image: AssetImage("assets/bg.png"), fit: BoxFit.fill)
         ),
         child: Column(
           mainAxisSize: MainAxisSize.max,
           crossAxisAlignment: CrossAxisAlignment.center,
           children: [
             Container(
               height: 50,
               child: Visibility(
                   visible: _isLoaded_1 && showAds,
                   child: Align(
                     alignment: Alignment.bottomCenter,
                     child: SafeArea(
                       child: SizedBox(
                         width: _bannerAd_1!.size.width.toDouble(),
                         height: _bannerAd_1!.size.height.toDouble(),
                         child: AdWidget(ad: _bannerAd_1!),
                       ),
                     ),
                   )
               ),
             ),
             Expanded(
                 child: Center(
                     child: Column(
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: [
                         Container(
                             margin: const EdgeInsets.fromLTRB(75, 30, 30, 0),
                             padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                             child: Stack(
                               alignment: Alignment.center,
                               children: [
                                 Container(
                                     child: AnimatedPositioned(
                                         left: moving? (secondMoving? 0 : 20) : 150,
                                         bottom: moving? 0 : 50,
                                         duration: const Duration(milliseconds: 1500),
                                         child: Visibility(
                                           visible: (moving || secondMoving),
                                           child: Image.asset('assets/cc.png',height: 20, width: 20),
                                         )
                                     )
                                 ),
                                 Center(
                                   child: RotationTransition(
                                       turns: Tween(begin: 0.0, end: 0.5).animate(animationController),
                                       child: GestureDetector(
                                           onTap: () => print(""),
                                           onVerticalDragEnd:  (_) => startRotate(),
                                           child: Image.asset('assets/mc.png',fit: BoxFit.contain)
                                       )
                                   ),
                                 ),
                               ],
                             )
                         ),
                         Container(
                             margin: const EdgeInsets.fromLTRB(50, 0, 100, 0),
                             child: Image.asset('assets/mcp.png',fit: BoxFit.contain,)
                         ),
                       ],
                     )
                 )
             ),
             Container(
               height: 50,
               child: Visibility(
                   visible: _isLoaded_2 && showAds,
                   child: Align(
                     alignment: Alignment.bottomCenter,
                     child: SafeArea(
                       child: SizedBox(
                         width: _bannerAd_2!.size.width.toDouble(),
                         height: _bannerAd_2!.size.height.toDouble(),
                         child: AdWidget(ad: _bannerAd_2!),
                       ),
                     ),
                   )
               ),
             )
           ],
         )
       )
     );
  }

  void startRotate(){
    if (!moving && !reseting) {
      //print(youtubeVideoComment.length) ;
      Random random = new Random();
      resultIndex = random.nextInt(youtubeVideoComment.length);
      //print(resultIndex) ;

      setState(() {
        player1.play(AssetSource("roll.mp3")) ;

        moving = true;
        secondMoving = false ;
      });

      animationController.forward();
      Future.delayed(
          const Duration(milliseconds: 1500), () => secondMove());
    }
  }

  void secondMove(){
    setState(() {
      player2.play(AssetSource("drop.mp3")) ;
      secondMoving = true ;
    });

    Future.delayed(
         const Duration(milliseconds: 1500), () => showResult()) ;
  }

  void showResult(){
    player1.stop() ;
    player2.stop() ;

    showCommentDialog(context,S.of(context).drawPage_Congratulations, youtubeVideoComment[resultIndex].authorProfileImageUrl, youtubeVideoComment[resultIndex].authorDisplayName, youtubeVideoComment[resultIndex].authorChannelUrl, youtubeVideoComment[resultIndex].textDisplay, "") ;

    Future.delayed(
          const Duration(seconds: 1), () => restRotate());
  }

  void restRotate(){
    setState(() {
      moving = false;
      secondMoving = false;
      reseting = true ;
    });
    animationController.reset() ;

    Future.delayed(
     const Duration(milliseconds: 1000), () => reseting = false);
  }

  /// Loads a banner ad.
  void loadAd_1() {
    _bannerAd_1 = BannerAd(
      adUnitId: adUnitId_banner1,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          debugPrint('$ad loaded.');
          setState(() {
            _isLoaded_1 = true;
          });
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (ad, err) {
          debugPrint('BannerAd failed to load');
          // Dispose the ad here to free resources.
          ad.dispose();
        },
        // Called when an ad opens an overlay that covers the screen.
        onAdOpened: (Ad ad) {},
        // Called when an ad removes an overlay that covers the screen.
        onAdClosed: (Ad ad) {},
        // Called when an impression occurs on the ad.
        onAdImpression: (Ad ad) {},
      ),
    )..load();
  }

  void loadAd_2() {
    _bannerAd_2 = BannerAd(
      adUnitId: adUnitId_banner2,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          debugPrint('$ad loaded.');
          setState(() {
            _isLoaded_2 = true;
          });
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (ad, err) {
          debugPrint('BannerAd failed to load');
          // Dispose the ad here to free resources.
          ad.dispose();
        },
        // Called when an ad opens an overlay that covers the screen.
        onAdOpened: (Ad ad) {},
        // Called when an ad removes an overlay that covers the screen.
        onAdClosed: (Ad ad) {},
        // Called when an impression occurs on the ad.
        onAdImpression: (Ad ad) {},
      ),
    )..load();
  }
}
