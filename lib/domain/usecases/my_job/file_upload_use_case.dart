import 'package:customerapp/core/usecases/pram_usecase.dart';
import 'package:customerapp/domain/model/my_jobs/file_upload_request.dart';
import 'package:customerapp/domain/model/my_jobs/file_upload_responds.dart';
import 'package:customerapp/domain/repositories/my_job/myjob_repository.dart';

class FileUploadUseCase
    extends ParamUseCase<FileUploadResponse?, List<FileUploadRequest>> {
  final MyJobRepository _repo;
  FileUploadUseCase(this._repo);

  @override
  Future<FileUploadResponse?> execute(params) {
    return _repo.fileUpload(params);
  }
}
