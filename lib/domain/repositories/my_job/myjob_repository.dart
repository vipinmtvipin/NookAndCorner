import 'package:customerapp/domain/model/common_responds.dart';
import 'package:customerapp/domain/model/my_jobs/my_job_responds.dart';
import 'package:customerapp/domain/model/my_jobs/myjob_request.dart';

abstract class MyJobRepository {
  Future<MyJobResponds?> getJob(MyJobRequest request);
  Future<CommonResponds?> cancelJob(String jobId);
  Future<CommonResponds?> reScheduleJob(ReScheduleJobRequest request);
  Future<CommonResponds?> reviewJob(JobCommentRequest request);
  Future<CommonResponds?> ratingJob(JobCommentRequest request);
}
