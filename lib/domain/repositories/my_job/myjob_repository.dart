import 'package:customerapp/domain/model/address/address_request.dart';
import 'package:customerapp/domain/model/common_responds.dart';
import 'package:customerapp/domain/model/my_jobs/file_upload_request.dart';
import 'package:customerapp/domain/model/my_jobs/file_upload_responds.dart';
import 'package:customerapp/domain/model/my_jobs/my_job_responds.dart';
import 'package:customerapp/domain/model/my_jobs/myjob_request.dart';
import 'package:customerapp/domain/model/my_jobs/update_addon_request.dart';

abstract class MyJobRepository {
  Future<MyJobResponds?> getJob(MyJobRequest request);
  Future<CommonResponds?> cancelJob(String jobId);
  Future<FileUploadResponse?> fileUpload(List<FileUploadRequest> file);
  Future<CommonResponds?> reScheduleJob(ReScheduleJobRequest request);
  Future<CommonResponds?> reviewJob(JobCommentRequest request);
  Future<CommonResponds?> ratingJob(JobCommentRequest request);
  Future<CommonResponds?> confirmAddress(ConfirmAddressRequest request);
  Future<CommonResponds?> updateAddOns(UpdateAddonRequest request);
}
