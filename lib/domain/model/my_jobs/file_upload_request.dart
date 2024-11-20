class FileUploadRequest {
  String? fileName;
  String? fileType;

  FileUploadRequest({
    this.fileName,
    this.fileType,
  });

  toJson() {
    return {
      'fileName': fileName,
      'fileType': fileType,
    };
  }
}
