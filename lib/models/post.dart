class Post {

  String postID;
  String postTitle;
  String postDetail;
  List<String> tags;
  String imageUrl;
  String ownerID;
  String acceptedCommentID;
  int timestamp;

  Post({ this.postID, this.postTitle, this.postDetail, this.tags, this.imageUrl, this.ownerID, this.acceptedCommentID, this.timestamp });

  Post clone() => Post(
    postID: this.postID,
    postTitle: this.postTitle,
    postDetail: this.postDetail,
    tags: this.tags,
    imageUrl: this.imageUrl,
    ownerID: this.ownerID,
    acceptedCommentID: this.acceptedCommentID,
    timestamp: this.timestamp,
  );
}