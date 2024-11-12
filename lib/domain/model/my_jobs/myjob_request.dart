class MyJobRequest {
  String? userId;
  String? bookingStatus;

  MyJobRequest({this.userId, this.bookingStatus});
}

class JobCommentRequest {
  String? userId;
  String? comment;
  String? jobId;

  JobCommentRequest({this.userId, this.comment, this.jobId});

  toJson() {
    return {'userId': userId, 'comment': comment, 'jobId': jobId};
  }
}

class ReScheduleJobRequest {
  bool? goldenHourAdded;
  List<int>? supervisors;
  String? jobId;
  String? jobDate;

  ReScheduleJobRequest(
      {this.goldenHourAdded, this.supervisors, this.jobId, this.jobDate});

  toJson() {
    return {
      'goldenHourAdded': goldenHourAdded,
      'supervisors': supervisors,
      'jobId': jobId,
      'jobDate': jobDate
    };
  }
}
