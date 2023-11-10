import 'package:intl/intl.dart';

import 'common.dart';

class YoutubeVideoResponse {
  final String kind ;
  final String etag ;
  final List<VideoItem> items ;
  final PageInfo pageInfo ;

  YoutubeVideoResponse({
    required this.kind,
    required this.etag,
    required this.pageInfo,
    required this.items
  });

  factory YoutubeVideoResponse.fromJson(Map<String, dynamic> json) {

    List<dynamic>? tempItemStringList = List.from(json['items']) ;
    List<VideoItem> tempItems = [];
    for (var i=0 ; i<tempItemStringList.length ; i++){
      VideoItem videoItem = VideoItem.fromJson(tempItemStringList[i]) ;
      tempItems.add(videoItem) ;
    }

    return YoutubeVideoResponse(
        kind: json['kind'],
        etag: json['etag'],
        pageInfo: PageInfo.fromJson(json['pageInfo']),
        items: tempItems
    );
  }
}

class VideoItem {
  final String kind ;
  final String etag ;
  final String id ;
  final VideoSnippet snippet ;

  const VideoItem({
    required this.kind,
    required this.etag,
    required this.id,
    required this.snippet
  });

  factory VideoItem.fromJson(Map<String, dynamic> json) {
    return VideoItem(
        kind: json['kind'],
        etag: json['etag'],
        id: json['id'],
        snippet: VideoSnippet.fromJson(json['snippet'])
    );
  }
}

class VideoSnippet{
  final String channelId ;

  VideoSnippet({
    required this.channelId
  });

  factory VideoSnippet.fromJson(Map<String, dynamic> json) {
    return VideoSnippet(
      channelId: json['channelId'],
    );
  }
}

class Comment{
  final String authorDisplayName ;
  final String authorChannelId ;
  final String authorChannelUrl ;
  final String authorProfileImageUrl ;
  final DateTime commentUpdateDateTime ;
  final String textDisplay ;

  Comment({
    required this.authorDisplayName,
    required this.authorChannelId,
    required this.authorChannelUrl,
    required this.authorProfileImageUrl,
    required this.commentUpdateDateTime,
    required this.textDisplay
  });

  factory Comment.transfer(CommentItem commentItem) {
    return Comment(
      authorDisplayName: commentItem.snippet.topLevelComment.snippet.authorDisplayName,
      authorChannelId: commentItem.snippet.topLevelComment.snippet.authorChannelId.value,
      authorChannelUrl: commentItem.snippet.topLevelComment.snippet.authorChannelUrl,
      authorProfileImageUrl: commentItem.snippet.topLevelComment.snippet.authorProfileImageUrl,
      commentUpdateDateTime: commentItem.snippet.topLevelComment.snippet.updatedAt,
      textDisplay: commentItem.snippet.topLevelComment.snippet.textDisplay,
    );
  }
}

class YoutubeCommentResponse {
  final String kind ;
  final String etag ;
  String? nextPageToken;
  final PageInfo pageInfo ;
  final List<CommentItem> items ;

  YoutubeCommentResponse({
    required this.kind,
    required this.etag,
    this.nextPageToken,
    required this.pageInfo,
    required this.items
  });

  factory YoutubeCommentResponse.fromJson(Map<String, dynamic> json) {

    List<dynamic>? tempItemStringList = List.from(json['items']) ;
    // print("tempItemList") ;
    // print(tempItemStringList!.length) ;
    List<CommentItem> tempItems = [];
    // print(tempItemStringList[0]) ;
    for (var i=0 ; i<tempItemStringList.length ; i++){
      CommentItem commentItem = CommentItem.fromJson(tempItemStringList[i]) ;
      tempItems.add(commentItem) ;
      // print(tempItems[i].snippet.topLevelComment.snippet.textDisplay) ;
    }

    return YoutubeCommentResponse(
        kind: json['kind'],
        etag: json['etag'],
        nextPageToken: json['nextPageToken'],
        pageInfo: PageInfo.fromJson(json['pageInfo']),
        items: tempItems
    );
  }
}

class PageInfo {
  final int totalResults ;
  final int resultsPerPage;

  const PageInfo({
    required this.totalResults,
    required this.resultsPerPage
  });

  factory PageInfo.fromJson(Map<String, dynamic> json) {
    return PageInfo(
        totalResults: json['totalResults'],
        resultsPerPage: json['resultsPerPage']
    );
  }
}

class CommentItem {
  final String kind ;
  final String etag ;
  final String id ;
  final Snippet snippet ;

  const CommentItem({
    required this.kind,
    required this.etag,
    required this.id,
    required this.snippet
  });

  factory CommentItem.fromJson(Map<String, dynamic> json) {
    return CommentItem(
        kind: json['kind'],
        etag: json['etag'],
        id: json['id'],
        snippet: Snippet.fromJson(json['snippet'])
    );
  }
}

class Snippet {
  final String videoId;
  final TopLevelComment topLevelComment;
  final bool canReply ;
  final int totalReplyCount ;
  final bool isPublic ;

  const Snippet({
    required this.videoId,
    required this.topLevelComment,
    required this.canReply,
    required this.totalReplyCount,
    required this.isPublic
  });

  factory Snippet.fromJson(Map<String, dynamic> json) {
    return Snippet(
      videoId: json['videoId'],
      topLevelComment: TopLevelComment.fromJson(json['topLevelComment']),
      canReply: json['canReply'],
      totalReplyCount: json['totalReplyCount'],
      isPublic: json['isPublic'],
    );
  }
}

class TopLevelComment{
  final String kind ;
  final String etag ;
  final String id ;
  final Snippet2 snippet ;

  const TopLevelComment({
    required this.kind,
    required this.etag,
    required this.id,
    required this.snippet
  });

  factory TopLevelComment.fromJson(Map<String, dynamic> json) {
    return TopLevelComment(
      kind: json['kind'],
      etag: json['etag'],
      id: json['id'],
      snippet: Snippet2.fromJson(json['snippet'])
    );
  }
}

class Snippet2 {
  final String videoId;
  final String textDisplay;
  final String textOriginal;
  final String authorDisplayName;
  final String authorProfileImageUrl;
  final String authorChannelUrl;
  final AuthorChannelId authorChannelId;
  final bool canRate;
  final String viewerRating ;
  final int likeCount;
  final DateTime publishedAt;
  final DateTime updatedAt;


  const Snippet2({
    required this.videoId,
    required this.textDisplay,
    required this.textOriginal,
    required this.authorDisplayName,
    required this.authorProfileImageUrl,
    required this.authorChannelUrl,
    required this.authorChannelId,
    required this.canRate,
    required this.viewerRating,
    required this.likeCount,
    required this.publishedAt,
    required this.updatedAt,
  });

  factory Snippet2.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic>  emptyAuthorChannelIdMap() => <String, dynamic>{
      "value": ""
    };

    return Snippet2(
      videoId: json['videoId'],
      textDisplay: json['textDisplay'],
      textOriginal: json['textOriginal'],
      authorDisplayName: json['authorDisplayName'],
      authorProfileImageUrl: json['authorProfileImageUrl'],
      authorChannelUrl: json['authorChannelUrl'],
      authorChannelId: (isNotNullAndNotEmpty(json['authorChannelId']))?AuthorChannelId.fromJson(json['authorChannelId']):AuthorChannelId.fromJson(emptyAuthorChannelIdMap()),
      canRate: json['canRate'],
      viewerRating: json['viewerRating'],
      likeCount: json['likeCount'],
      publishedAt: DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").parse(json['publishedAt']),
      updatedAt: DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").parse(json['updatedAt']),
    );
  }
}

class AuthorChannelId {
  final String value;

  const AuthorChannelId({
    required this.value,
  });

  factory AuthorChannelId.fromJson(Map<String, dynamic> json) {
    return AuthorChannelId(
      value: json['value'],
    );
  }
}
