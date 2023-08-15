class MessageModel {
  MessageModel({required this.userID, required this.message, this.messageTitle, required this.dateTime});

  factory MessageModel.fromMap (Map<String, dynamic> data) {
    final String userID=data['userID'] as String;
    final String message=data['message'] as String;
    final List<String> messageTitle=data['messageTitle']==null ? [''] : data['messageTitle'] as List<String>;
    final DateTime dateTime=data['dateTime'] as DateTime;

     return MessageModel(userID: userID, message: message,messageTitle: messageTitle,dateTime: dateTime);
  }

  final String userID;
  final String message;
  final List<String>? messageTitle;
  final DateTime dateTime;


  Map<String, dynamic> toMap (){
    return {
      'userID' : userID,
      'message' : message,
      'messageTitle' : messageTitle,
      'dateTime' : dateTime,
    };
  }
}