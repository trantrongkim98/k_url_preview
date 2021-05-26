// import 'dart:convert';
// import 'dart:typed_data';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_cache_manager/flutter_cache_manager.dart';
// import 'package:kurlpreview/src/data/k_preview_meta.dart';
// import 'package:kurlpreview/src/http/http.dart';
// import 'package:kurlpreview/src/ui/k_preview_image.dart';
// import 'package:kurlpreview/src/ui/k_preview_text.dart';
//
// class KHorizontalUrlPreview extends StatefulWidget {
//   final String url;
//   final String? cacheKey;
//   final Duration maxAge;
//   final double maxImageWidth;
//   final BoxConstraints boxConstraints;
//   final TextStyle? titleStyle;
//   final EdgeInsets paddingTitle;
//   final TextStyle? descriptionStyle;
//   final EdgeInsets paddingDescription;
//   final TextStyle? siteNameStyle;
//   final EdgeInsets paddingSiteName;
//
//   const KHorizontalUrlPreview(
//       this.url, {
//         Key? key,
//         this.cacheKey,
//         this.maxImageWidth = 60,
//         this.boxConstraints = const BoxConstraints(),
//         this.titleStyle = const TextStyle(
//           fontSize: 14,
//           color: Colors.white,
//           fontWeight: FontWeight.bold,
//         ),
//         this.paddingTitle = const EdgeInsets.only(
//             bottom: 8,left:8,right:8
//         ),
//         this.descriptionStyle = const TextStyle(
//           fontSize: 12,
//           color: Colors.grey,
//           fontWeight: FontWeight.w400,
//         ),
//         this.paddingDescription = const EdgeInsets.only(
//             bottom: 8,left:8,right:8
//         ),
//
//         this.siteNameStyle = const TextStyle(
//           fontSize: 9,
//           color: Colors.grey,
//           fontWeight: FontWeight.w400,
//         ),
//         this.paddingSiteName = const EdgeInsets.only(
//             bottom: 8,left:8,right:8
//         ),
//         this.maxAge = const Duration(days: 1),
//       }) : super(key: key);
//
//   @override
//   _KHorizontalUrlPreviewState createState() => _KHorizontalUrlPreviewState();
// }
//
// class _KHorizontalUrlPreviewState extends State<KHorizontalUrlPreview> {
//   KPreviewMetaData? _meta;
//   final _cacheManager = DefaultCacheManager();
//   @override
//   void initState() {
//     _loadCache();
//     super.initState();
//   }
//
//   /// load website from file cached
//   void _loadCache() async {
//     String key = widget.cacheKey ?? widget.url;
//     FileInfo? fileInfo = await _cacheManager.getFileFromMemory(key);
//     if (fileInfo == null) {
//       fileInfo = await _cacheManager.getFileFromCache(key);
//     }
//
//     /// call api so don't file cached
//     if (fileInfo == null) {
//       _loadPreview();
//     } else {
//       /// load data from fileInfo
//       List<int> data = fileInfo.file.readAsBytesSync();
//       String str = utf8.decode(data, allowMalformed: true).toString();
//       Map map = json.decode(str);
//
//       if (mounted) {
//         setState(() {
//           _meta = KPreviewMetaData.fromJSon(map);
//         });
//       }
//     }
//   }
//
//   /// call api to get website
//   void _loadPreview() {
//     NetworkHttp.get(widget.url).then((value) {
//       if (!mounted) {
//         _meta = value;
//         return;
//       }
//
//       setState(() {
//         _meta = value;
//       });
//       if (_meta == null) return;
//       String js = json.encode(_meta!.toMap());
//       final encryptedBase64EncodedString = utf8.encode(js);
//
//       _cacheManager.putFile(
//         widget.url,
//         Uint8List.fromList(encryptedBase64EncodedString),
//         key: widget.cacheKey ?? widget.url,
//         maxAge: widget.maxAge,
//       );
//     });
//   }
//
//   @override
//   void didUpdateWidget(covariant KHorizontalUrlPreview oldWidget) {
//     if(widget.url != oldWidget.url){
//       _loadCache();
//     }
//     super.didUpdateWidget(oldWidget);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (_meta == null) return SizedBox(width: 0);
//     return ConstrainedBox(
//       constraints: widget.boxConstraints,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Flexible(
//             child: Container(
//             height: 200,
//               child: KPreviewImage(
//                 imageUrl: _meta!.imageUrl,
//                 boxFit: BoxFit.scaleDown,
//                 cacheManager: _cacheManager,
//
//               ),
//             ),
//           ),
//           Flexible(
//             flex: 3,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 KPreviewText(
//                   text: _meta!.title,
//                   style: widget.titleStyle,
//                   padding: widget.paddingTitle,
//                 ),
//                 KPreviewText(
//                   text: _meta!.description,
//                   style: widget.descriptionStyle,
//                   padding: widget.paddingDescription,
//                 ),
//                 KPreviewText(
//                   text: _meta!.siteName,
//                   style: widget.siteNameStyle,
//                   padding: widget.paddingSiteName,
//                 ),
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
