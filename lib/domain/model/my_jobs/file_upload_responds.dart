import 'dart:convert';

FileUploadResponse fileUploadRespondsFromJson(String str) =>
    FileUploadResponse.fromJson(json.decode(str));

class FileUploadResponse {
  FileUploadResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  final bool? success;
  final String? message;
  final Data? data;

  factory FileUploadResponse.fromJson(Map<String, dynamic> json) {
    return FileUploadResponse(
      success: json["success"],
      message: json["message"],
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data?.toJson(),
      };
}

class Data {
  Data({
    required this.urls,
  });

  final List<Url> urls;

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      urls: json["urls"] == null
          ? []
          : List<Url>.from(json["urls"]!.map((x) => Url.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "urls": urls.map((x) => x?.toJson()).toList(),
      };
}

class Url {
  Url({
    required this.preSignedUrl,
    required this.key,
    required this.filePath,
  });

  final String? preSignedUrl;
  final String? key;
  final String? filePath;

  factory Url.fromJson(Map<String, dynamic> json) {
    return Url(
      preSignedUrl: json["preSignedUrl"],
      key: json["key"],
      filePath: json["filePath"],
    );
  }

  Map<String, dynamic> toJson() => {
        "preSignedUrl": preSignedUrl,
        "key": key,
        "filePath": filePath,
      };
}
