import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'commentEntity.dart';


bool isNotNullAndNotEmpty(var str){
  if (str!=null && !str.isEmpty)
    return true;
  return false ;
}

bool isDateTime(String str){
  if(DateTime.tryParse(str) != null){
    return true ;
  }
  return false ;
}

Future<bool> checkHttpUrl(Uri url) async {
  // print("checkHttpUrl:"+url.path) ;
  var client = http.Client();
  http.Response _response = await client.head(url);
  if (_response.statusCode == 200) {
    // print("Valid") ;
    return true ;
  }else{
    // print("Invalid") ;
    return false ;
  }
}

class HexColor extends Color {
  static int _getColor(String hex) {
    String formattedHex =  "FF" + hex.toUpperCase().replaceAll("#", "");
    return int.parse(formattedHex, radix: 16);
  }
  HexColor(final String hex) : super(_getColor(hex));
}

String validateYoutubeUrl(String url) {
  // print("validateYoutubeUrl:"+url) ;

  List<String> youtubeUrlPre = ["https://youtu.be/", "https://www.youtube.com/watch?v=", "https://m.youtube.com/watch?v=", "https://www.youtube.com/live/"] ;
  String ytVideoId = "";
  for (var i = 0; i < youtubeUrlPre.length; i++) {
    if (url.contains(youtubeUrlPre[i])){
      //get youtube ID
      ytVideoId = url.substring(youtubeUrlPre[i].length) ;
      if (ytVideoId.contains("/")){
        ytVideoId = ytVideoId.substring(0, ytVideoId.indexOf("/")) ;
      }
      if (ytVideoId.contains("&")){
        ytVideoId = ytVideoId.substring(0, ytVideoId.indexOf("&")) ;
      }
      if (ytVideoId.contains("?")){
        ytVideoId = ytVideoId.substring(0, ytVideoId.indexOf("?")) ;
      }
    }
  }

  return ytVideoId;
}

Future<bool> requestNetwork(BuildContext context) async {
  // print("requestNetwork") ;
  try {
    final result = await InternetAddress.lookup('example.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      // print('connected');
      return true ;
    }
  } on SocketException catch (_) {
    // print('not connected');
    return false ;
  }

  return false ;
}

Future<void> checkNetwork(BuildContext context, String title, String body, String btnText) async {
  // print("checkNetwork") ;
  bool haveNetwork = false ;

  while (!haveNetwork){
    haveNetwork = await requestNetwork(context) ;
    if (!haveNetwork) {
      await showAlertDialog(context, false, title, body, btnText) ;
    }
  }
}

Future<T?> showAlertDialog<T>(BuildContext context,bool barrierDismissible, String title, String body, String btnText){
  return showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(body),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop() ;
              },
              //return false when click on "NO"
              child:Text(btnText),
            )
          ]
        );
      });
}

// Google API
Future<List<Comment>> getYoutubeVideoComment(String videoId, String startDateStr, String endDateStr, String searchKeyword) async {
  String key = "AIzaSyCH4Qe85_IobgM1Na19rZpbU7BgeAoAyFw" ;

  bool flag = true ;
  String? nextPageToken ;

  List<CommentItem> commentItemList = [] ;
  List<String> authorChannelIdList = [] ;
  List<Comment> commentList = [] ;

  //video
  String baseUrl = "https://www.googleapis.com/youtube/v3/videos?" ;
  baseUrl+= "key=" + key ;
  baseUrl+= "&id=" + videoId ;
  baseUrl+= "&part=snippet" ;

  String videoChannelId = "";
  final response = await http.get(Uri.parse(baseUrl));
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    YoutubeVideoResponse youtubeVideoResponse = YoutubeVideoResponse.fromJson(jsonDecode(response.body));
    if (youtubeVideoResponse.items.length==1)
      videoChannelId = youtubeVideoResponse.items[0].snippet.channelId ;
    else
      return [] ;
  }else{
    return [] ;
  }

  print("videoChannelId = " + videoChannelId) ;


  //commentThreads
  while(flag){
    YoutubeCommentResponse? youtubeCommentResponse ;

    String baseUrl = "https://www.googleapis.com/youtube/v3/commentThreads?" ;
    baseUrl+= "key=" + key ;
    baseUrl+= "&videoId=" + videoId ;
    baseUrl+= "&searchTerms=" + searchKeyword ;
    baseUrl+= "&textFormat=plainText&part=snippet&maxResults=100" ;

    if (isNotNullAndNotEmpty(nextPageToken)){
      baseUrl+= "&pageToken=" + nextPageToken! ;
    }

    // print(baseUrl) ;

    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.

      var testData = "{	\"kind\": \"youtube#commentThreadListResponse\",	\"etag\": \"SAsATWTbhVMyizZpuc89C9jxyQQ\",	\"pageInfo\": {		\"totalResults\": 100,		\"resultsPerPage\": 100	},	\"items\": [{			\"kind\": \"youtube#commentThread\",			\"etag\": \"Ru2TrhLzYQESgMWWh2-xqrG1Nsw\",			\"id\": \"Ugx2DqFHqxtYbQ77Dk14AaABAg\",			\"snippet\": {				\"videoId\": \"XUQYr6-Fd1M\",				\"topLevelComment\": {					\"kind\": \"youtube#comment\",					\"etag\": \"h05qi2G9ZEBupPcz88DpxhDCS-A\",					\"id\": \"Ugx2DqFHqxtYbQ77Dk14AaABAg\",					\"snippet\": {						\"videoId\": \"XUQYr6-Fd1M\",						\"textDisplay\": \"Comment 1\",						\"textOriginal\": \"Comment 1\",						\"authorDisplayName\": \"Felix Lee\",						\"authorProfileImageUrl\": \"https://yt3.ggpht.com/ytc/AOPolaRGIyNvbLFj8uAlPtusbE2HFB_8ku949mY7hA=s48-c-k-c0x00ffffff-no-rj\",						\"authorChannelUrl\": \"http://www.youtube.com/channel/UCzIoOTsnh67PtuLeZ0K4A4A\",						\"authorChannelId\": {							\"value\": \"UCzIoOTsnh67PtuLeZ0K4A4A\"						},						\"canRate\": true,						\"viewerRating\": \"none\",						\"likeCount\": 0,						\"publishedAt\": \"2023-07-02T19:16:43Z\",						\"updatedAt\": \"2023-07-02T19:16:43Z\"					}				},				\"canReply\": true,				\"totalReplyCount\": 0,				\"isPublic\": true			}		},		{			\"kind\": \"youtube#commentThread\",			\"etag\": \"Kmh3_BcWkzDoQjjzHu2wPkq3qY0\",			\"id\": \"UgxMhUeDkIRCsMJJZRd4AaABAg\",			\"snippet\": {				\"videoId\": \"XUQYr6-Fd1M\",				\"topLevelComment\": {					\"kind\": \"youtube#comment\",					\"etag\": \"_zPT212Y-dwBYsxXlzpctnCIgys\",					\"id\": \"UgxMhUeDkIRCsMJJZRd4AaABAg\",					\"snippet\": {						\"videoId\": \"XUQYr6-Fd1M\",						\"textDisplay\": \"Comment 2\",						\"textOriginal\": \"Comment 2\",						\"authorDisplayName\": \"Ken Ken\",						\"authorProfileImageUrl\": \"https://yt3.ggpht.com/ytc/AOPolaQqk92gaxx3Nu24ragb2QOGNvO6Q-i6sn5-Kigqhz__phvyRFn2B1rjgdmWa1CT=s48-c-k-c0x00ffffff-no-rj\",						\"authorChannelUrl\": \"http://www.youtube.com/channel/UCv64l2WFSVR5DK136jniuMg\",						\"authorChannelId\": {							\"value\": \"UCv64l2WFSVR5DK136jniuMg\"						},						\"canRate\": true,						\"viewerRating\": \"none\",						\"likeCount\": 0,						\"publishedAt\": \"2023-07-02T15:32:34Z\",						\"updatedAt\": \"2023-07-02T15:33:27Z\"					}				},				\"canReply\": true,				\"totalReplyCount\": 0,				\"isPublic\": true			}		},		{			\"kind\": \"youtube#commentThread\",			\"etag\": \"rpGPSqvgg2uDDaaRqGODKgHuJ78\",			\"id\": \"UgzNc_mOY_G248Q_2Hx4AaABAg\",			\"snippet\": {				\"videoId\": \"XUQYr6-Fd1M\",				\"topLevelComment\": {					\"kind\": \"youtube#comment\",					\"etag\": \"m8zhUrNU_CHF42RCPmJbmDJe_nw\",					\"id\": \"UgzNc_mOY_G248Q_2Hx4AaABAg\",					\"snippet\": {						\"videoId\": \"XUQYr6-Fd1M\",						\"textDisplay\": \"Comment 3\",						\"textOriginal\": \"Comment 3\",						\"authorDisplayName\": \"Paul Wong\",						\"authorProfileImageUrl\": \"https://yt3.ggpht.com/ytc/AOPolaRxEBy-CH2CDnxsXY257PkFsjLEJFhEJnhc93efkQ=s48-c-k-c0x00ffffff-no-rj\",						\"authorChannelUrl\": \"http://www.youtube.com/channel/UC_Z6EntO-i-z-29V5MJAX7Q\",						\"authorChannelId\": {							\"value\": \"UC_Z6EntO-i-z-29V5MJAX7Q\"						},						\"canRate\": true,						\"viewerRating\": \"none\",						\"likeCount\": 0,						\"publishedAt\": \"2023-06-29T18:38:35Z\",						\"updatedAt\": \"2023-06-29T18:38:35Z\"					}				},				\"canReply\": true,				\"totalReplyCount\": 0,				\"isPublic\": true			}		}	]}" ;

      youtubeCommentResponse = YoutubeCommentResponse.fromJson(jsonDecode(response.body));
      if (youtubeCommentResponse.nextPageToken==null){
        flag = false ;
        commentItemList.addAll(youtubeCommentResponse.items) ;
      }else{
        flag = true ;
        nextPageToken = youtubeCommentResponse.nextPageToken ;
        commentItemList.addAll(youtubeCommentResponse.items) ;
      }
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      flag = false ;
      return [] ;
      // throw Exception('Failed to load YoutubeCommentResponse');
    }
  }

  // print("startDateStr = " + startDateStr) ;
  startDateStr += " 00:00:00" ;
  // print("startDateStr = " + startDateStr) ;
  DateTime startDate = DateFormat("yyyy-MM-dd HH:mm:ss").parse(startDateStr) ;

  // print("endDateStr = " + endDateStr) ;
  endDateStr += " 23:59:59" ;
  // print("endDateStr = " + endDateStr) ;
  DateTime endDate = DateFormat("yyyy-MM-dd HH:mm:ss").parse(endDateStr) ;

  //Filter
  for (CommentItem item in commentItemList){
    // print(item.snippet.topLevelComment.snippet.updatedAt) ;

    DateTime commentDate = item.snippet.topLevelComment.snippet.updatedAt ;
    //by time
    if (commentDate.isAfter(startDate) && commentDate.isBefore(endDate)){
      if (item.snippet.topLevelComment.snippet.authorChannelId.value!=videoChannelId) {
        //by same author
        if (!authorChannelIdList.contains(item.snippet.topLevelComment.snippet.authorChannelId.value)) {
          authorChannelIdList.add(
              item.snippet.topLevelComment.snippet.authorChannelId.value);
          commentList.add(Comment.transfer(item));
        }
      }
    }
  }

  return commentList ;

  // pageToken=QURTSl9pMW14WjdZVkdpNTdWeDhvdGhRdG42Z2pWNm4wcERIYzIydEtWZU03UzYwM3NmU2lESzhUM3l6VXRaNDVxZWdmX3NRdXJQdkF5dnQwcF9UMm03NDlGb1lnem5TUi0xdW1kczJzeUtqdHZYVDVYUTQyeEgtQkE=
}