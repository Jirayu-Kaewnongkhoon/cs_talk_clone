class Comment {

  String postID;
  String commentID;
  String commentDetail;
  String ownerID;
  int voteCount;
  bool isUpVote;
  bool isDownVote;
  bool isAccepted;
  int timestamp;

  Comment({ 
    this.postID, 
    this.commentID, 
    this.commentDetail,
    this.ownerID, 
    this.voteCount, 
    this.isUpVote, 
    this.isDownVote, 
    this.isAccepted, 
    this.timestamp 
  });
}