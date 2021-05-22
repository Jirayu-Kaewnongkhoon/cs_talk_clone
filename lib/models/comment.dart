class Comment {

  String postID;
  String commentID;
  String commentDetail;
  String imageUrl;
  String ownerID;
  int voteCount;
  List<String> upVoteList;
  List<String> downVoteList;
  int timestamp;

  Comment({ 
    this.postID, 
    this.commentID, 
    this.commentDetail,
    this.imageUrl,
    this.ownerID, 
    this.voteCount,
    this.upVoteList,
    this.downVoteList, 
    this.timestamp 
  });

  Comment clone() => Comment(
    postID: this.postID,
    commentID: this.commentID,
    commentDetail: this.commentDetail,
    imageUrl: this.imageUrl,
    ownerID: this.ownerID,
    voteCount: this.voteCount,
    upVoteList: this.upVoteList,
    downVoteList: this.downVoteList,
    timestamp: this.timestamp,
  );
}