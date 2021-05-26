import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class KPreviewImage extends StatelessWidget {
  final String? imageUrl;
  final BaseCacheManager? cacheManager;
  final EdgeInsets padding;
  final BoxFit boxFit;

  const KPreviewImage(
      {Key? key,
        this.imageUrl = '',
        this.cacheManager,
        this.boxFit = BoxFit.cover,
        this.padding = EdgeInsets.zero})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: CachedNetworkImage(
        cacheKey: imageUrl!,
        cacheManager: cacheManager,
        fadeInDuration: Duration(seconds: 0),
        placeholderFadeInDuration: Duration(seconds: 0),
        fadeOutDuration: Duration(seconds: 0),
        imageUrl: imageUrl!,
        fit: boxFit,
        errorWidget: (ctx, error, stackTrace) {
          return Padding(padding: padding, child: SizedBox());
        },
      ),
    );
  }
}