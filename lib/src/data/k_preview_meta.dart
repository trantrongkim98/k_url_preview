import 'dart:convert';
import 'dart:typed_data';

class KPreviewMetaData {
  final String title;
  final String imageUrl;
  final String description;
  final String siteName;
  final String mediaType;
  final String favicon;

  factory KPreviewMetaData.fromJSon(Map json) {
    return KPreviewMetaData(
      title: json['title'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      description: json['description'] ?? '',
      siteName: json['siteName'] ?? '',
      mediaType: json['mediaType'] ?? '',
      favicon: json['favicon'] ?? '',
    );
  }

  KPreviewMetaData({
    this.title = '',
    this.imageUrl = '',
    this.description = '',
    this.siteName = '',
    this.mediaType = '',
    this.favicon = '',
  });
  KPreviewMetaData copyWith({
    String? title,
    String? imageUrl,
    String? description,
    String? siteName,
    String? mediaType,
    String? favicon,
  }) {
    return KPreviewMetaData(
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      favicon: favicon ?? this.favicon,
      mediaType: mediaType ?? this.mediaType,
      siteName: siteName ?? this.siteName,
    );
  }

  Map<String, String> toMap() => {
        'title': this.title,
        'imageUrl': this.imageUrl,
        'description': this.description,
        'siteName': this.siteName,
        'mediaType': this.mediaType,
        'favicon': this.favicon,
      };
  @override
  String toString() {
    return '$title \n $description \n $imageUrl \n $favicon \n $siteName \n $mediaType ';
  }
}
