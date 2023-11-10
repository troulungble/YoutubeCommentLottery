
import 'package:flutter/material.dart';
import 'commentEntity.dart';
import 'common.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'main.dart';

class CommentDataTable extends DataTableSource {
  // Generate some made-up data
  late List<Comment> _data ;
  late BuildContext context ;

  CommentDataTable(BuildContext context, List<Comment> _data) {
    this.context = context ;
    this._data = _data;
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _data.length;

  @override
  int get selectedRowCount => 0;
  
  @override
  DataRow getRow(int index) {
    return DataRow(
        cells: [
          DataCell(
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                  child: GestureDetector(
                    onTap: () {
                      showCommentDialog(context,"", _data[index].authorProfileImageUrl, _data[index].authorDisplayName, _data[index].authorChannelUrl, _data[index].textDisplay, "") ;
                    },
                    child: ClipOvalShadow(
                      shadow: Shadow(
                        color: Colors.black26,
                        offset: Offset(1.0, 1.0),
                        blurRadius: 1,
                      ),
                      clipper: CustomClipperOval(),
                      child: ClipOval(
                        child: Material(
                          color: Colors.white, // button color
                          child: InkWell(
                            // splashColor: Colors.red, // inkwell color
                            child:  Image.network(_data[index].authorProfileImageUrl,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child: GestureDetector(
                      onTap: () {
                        showCommentDialog(context,"", _data[index].authorProfileImageUrl, _data[index].authorDisplayName, _data[index].authorChannelUrl, _data[index].textDisplay, "") ;
                      },
                      child: Text(
                          style: TextStyle(
                            color: HexColor("#51c794"),
                          ),
                          _data[index].authorDisplayName),
                    ),
                )
              ],
            ),
            onTap: () {
              showCommentDialog(context,"", _data[index].authorProfileImageUrl, _data[index].authorDisplayName, _data[index].authorChannelUrl, _data[index].textDisplay, "") ;
            },
          )
      ]
    );
  }
}

class CustomClipperOval extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    return Rect.fromCircle(
        center: new Offset(size.width / 2, size.width / 2),
        radius: size.width / 2 + 3);
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return false;
  }
}

class ClipOvalShadow extends StatelessWidget {
  final Shadow shadow;
  final CustomClipper<Rect> clipper;
  final Widget child;

  ClipOvalShadow({
    required this.shadow,
    required this.clipper,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _ClipOvalShadowPainter(
        clipper: this.clipper,
        shadow: this.shadow,
      ),
      child: ClipRect(child: child, clipper: this.clipper),
    );
  }
}

class _ClipOvalShadowPainter extends CustomPainter {
  final Shadow shadow;
  final CustomClipper<Rect> clipper;

  _ClipOvalShadowPainter({required this.shadow, required this.clipper});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = shadow.toPaint();
    var clipRect = clipper.getClip(size).shift(Offset(0, 0));
    canvas.drawOval(clipRect, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

Future<T?> showCommentDialog<T>(BuildContext context,String title, String imgUrl, String name, String profileUrl,  String commentText, String btnText){
  return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))
            ),
            content: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(title),
                      ),
                      Expanded(child: SizedBox()),
                      Align(
                        alignment: Alignment.topRight,
                        child: GestureDetector(child: Icon(Icons.clear,color: Colors.red),
                          onTap: (){
                            Navigator.pop(context);
                          },),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                          alignment: Alignment.topLeft,
                          margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                          child: GestureDetector(
                            onTap: () {
                              if (isNotNullAndNotEmpty(profileUrl))
                                launchUrl(Uri.parse(profileUrl.replaceFirst("http", "vnd.youtube"))) ;
                            },
                            child: ClipOvalShadow(
                              shadow: Shadow(
                                color: Colors.black26,
                                offset: Offset(1.0, 1.0),
                                blurRadius: 1,
                              ),
                              clipper: CustomClipperOval(),
                              child: ClipOval(
                                child: Material(
                                  color: Colors.white, // button color
                                  child: InkWell(
                                    // splashColor: Colors.red, // inkwell color
                                    child:  Image.network(imgUrl,
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                    )

                                  ),
                                ),
                              ),
                            ),
                          )
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: GestureDetector(
                                onTap: () {
                                  if (isNotNullAndNotEmpty(profileUrl))
                                    launchUrl(Uri.parse(profileUrl.replaceFirst("http", "vnd.youtube"))) ;
                                },
                                child: Text(
                                    style: TextStyle(
                                      color: (isNotNullAndNotEmpty(profileUrl))?HexColor("#1a0dab"):Colors.black,
                                      decoration: TextDecoration.underline,
                                    ),
                                    name),
                              )
                            ),
                            Padding(
                                padding: const EdgeInsets.fromLTRB(12,0,12,12),
                                child: Text(
                                  commentText,
                                  style: TextStyle(fontSize: 12),
                                  textAlign: TextAlign.justify,
                                  softWrap: true,
                                  maxLines: 10,
                                  overflow: TextOverflow.ellipsis,
                                )
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              )
            ),
            actions:[
              Visibility(
                  visible: (btnText!=""),
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    //return false when click on "NO"
                    child:Text(btnText),
                  )
              )
            ],
        );
      });
}

class LoadingScreen {
  LoadingScreen._();

  static show(BuildContext context, String text) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () async => false,
            child: Dialog(
              elevation: 0,
              backgroundColor: Colors.transparent,
              child: _customDialog(context, text),
            )
          ) ;
        });
  }

  static hide(BuildContext context) {
    Navigator.pop(context);
  }

  static _customDialog(BuildContext context, String text) {
    return Container(
      child: Center(
        child: Container(
          decoration: BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: EdgeInsets.all(30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CircularProgressIndicator(
                  strokeWidth: 10,
                  valueColor: AlwaysStoppedAnimation(HexColor("#51c794")),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20),
                ),
                Text(
                  text,
                  style: TextStyle(
                      color: HexColor("#51c794"), fontWeight: FontWeight.w600),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

PreferredSizeWidget getAppbar(){
  return AppBar(
    centerTitle: true,
    flexibleSpace: Image(
      image: AssetImage('assets/appbar_bg.png'),
      fit: BoxFit.cover,
    ),
    backgroundColor: Colors.transparent,
    iconTheme: IconThemeData(color: HexColor("#51c794")),
  );
}

PreferredSizeWidget getBackMenu(context){
  return AppBar(
      centerTitle: true,
      leading: GestureDetector(
        child: Icon( Icons.arrow_back_ios, color: HexColor("#51c794") ),
        onTap: () {
          Navigator.pop(context);
        } ,
      ) ,
      flexibleSpace: Image(
        image: AssetImage('assets/appbar_bg.png'),
        fit: BoxFit.cover,
      ),
      backgroundColor: Colors.transparent,
  );
}

Widget getMenu(context, title, List<String> menulabel, List<Widget> htd_items){

  int currentPage = 1 ;

  return Drawer(
    child: ListView(
      // Important: Remove any padding from the ListView.
      padding: EdgeInsets.zero,
      children: [
        SizedBox(
            height: 100,
            child: DrawerHeader(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Image.asset(
                    height: 50,
                    width: 50,
                      "assets/ic_launcher-web.png"
                  ),
                  Text(title),
                ],
              ),
            )
        ),
        ListTile(
          leading: Icon(
            Icons.home,
          ),
          title: Text(menulabel[0]),
          onTap: () {
            if (currentPage==1)
              Navigator.pop(context);
            else {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => MainPage()));
            }
          },
        ),
        ListTile(
          leading: Icon(
            Icons.label_important,
          ),
          title: Text(menulabel[1]),
          onTap: () {
            Navigator.pop(context);

            showHowToUse(context, menulabel[1], htd_items) ;
            // Navigator.push(context, MaterialPageRoute(builder: (context) => HowToUseCarouselWithIndicatorPage()));
          },
        )
      ],
    ),
  );
}

Future<T?> showHowToUse<T>(BuildContext context, String title, List<Widget> htd_items){
  return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))
                ),
                title: Text(title),
                content: HowToUseCarouselWithIndicatorPage(htd_items: htd_items)
            );
          },
        );
      });
}

class HowToUseCarouselWithIndicatorPage extends StatefulWidget {
  List<Widget> htd_items ;

  HowToUseCarouselWithIndicatorPage({super.key,required this.htd_items}) ;

  @override
  State<StatefulWidget> createState() {
    return _HowToUseCarouselWithIndicatorState(htd_items:htd_items);
  }
}

class _HowToUseCarouselWithIndicatorState extends State<HowToUseCarouselWithIndicatorPage> {
  var currentIndex = 0;
  final CarouselController _carouselController = CarouselController() ;
  List<Widget> htd_items ;

  _HowToUseCarouselWithIndicatorState({required this.htd_items});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: CarouselSlider(
              items: htd_items,
              carouselController: _carouselController,
              options: CarouselOptions(
                  initialPage: 0,
                  viewportFraction: 1,
                  enableInfiniteScroll: false,
                  reverse: false,
                  autoPlay: false,
                  scrollDirection: Axis.horizontal,
                  disableCenter: true,
                  onPageChanged: (index, reason){
                    setState(() {
                      currentIndex = index ;
                    });
                  }
              )
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: htd_items.asMap().entries.map((entry) {
              return GestureDetector(
                onTap: () => _carouselController.animateToPage(entry.key),
                child: Container(
                  width: 12.0,
                  height: 12.0,
                  margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: (Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : HexColor("#51c794"))
                          .withOpacity(currentIndex == entry.key ? 0.9 : 0.4)),
                ),
              );
            }).toList(),
          ),
        ],
      )
    );
  }
}

StatelessWidget howToUse_1(List<String> data){
  return Builder(
    builder: (BuildContext context) {
      return Scaffold(
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              setHowToUseText(data[0]),

              setHowToUseText(data[1]),
              setHowToUseText(data[2]),
              setHotToUseImage('assets/step1_1.png'),
              setHowToUseText(data[3]),
              setHowToUseText(data[4]),
              setHotToUseImage('assets/step1_2.png'),
            ],
          )
        )
      );
    }
  );
}

StatelessWidget howToUse_2(List<String> data){
  return Builder(
      builder: (BuildContext context) {
        return Scaffold(
            body: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  setHowToUseText(data[0]),
                  setHowToUseText(data[1]),
                  setHotToUseImage('assets/step2.png'),
                  setHowToUseText("\n"),
                  setHowToUseText(data[2]),
                ],
              )
            )
        );
      }
  );
}

StatelessWidget howToUse_3(List<String> data){
  return Builder(
      builder: (BuildContext context) {
        return Scaffold(
            body: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  setHowToUseText(data[0]),
                  setHowToUseText(data[1]),
                  setHotToUseImage('assets/step3_1.png'),
                  setHowToUseText("\n"),
                  setHowToUseText(data[2]),
                  setHotToUseImage('assets/step3_2.png'),
                ],
              )
            )
        );
      }
  );
}

StatelessWidget howToUse_4(List<String> data){
  return Builder(
      builder: (BuildContext context) {
        return Scaffold(
            body: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  setHowToUseText(data[0]),
                  setHowToUseText(data[1]),
                  setHotToUseImage('assets/step4_1.png'),
                  setHowToUseText("\n"),
                  setHowToUseText(data[2]),
                  setHotToUseImage('assets/step4_2.png')
                ],
              )
            )
        );
      }
  );
}

Text setHowToUseText(data){
  return Text(data,
      // textAlign: TextAlign.justify,
      softWrap: true,
      style: TextStyle(letterSpacing: 3)
    );
}

Container setHotToUseImage(data){
  return Container(
    decoration: BoxDecoration(
      border: Border.all(width: 2, color: HexColor("#51c794")), //<-- SEE HERE
      borderRadius: BorderRadius.all(Radius.circular(5))
    ),
    child: Center(
      child: Image.asset(data)
    ),
  );
}