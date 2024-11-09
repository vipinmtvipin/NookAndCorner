import 'package:customerapp/domain/model/my_jobs/my_job_responds.dart';
import 'package:customerapp/domain/model/my_jobs/myjob_request.dart';

abstract class MyJobRepository {
  Future<MyJobResponds?> getJob(MyJobRequest request);
}
