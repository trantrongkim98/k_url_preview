import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:kurlpreview/src/data/k_preview_meta.dart';
import 'package:kurlpreview/src/http/http.dart';
import 'package:kurlpreview/src/ui/k_preview_image.dart';
import 'package:kurlpreview/src/ui/k_preview_text.dart';

enum KUrlPreviewLayoutType { column, row }
enum KUrlPreviewItemType { title, siteName, originalUrl, description }

class KUrlPreviewItem {
  final KUrlPreviewItemType? type;
  final TextStyle? style;
  final EdgeInsets padding;

  const KUrlPreviewItem({
    this.style,
    @required this.type,
    this.padding = EdgeInsets.zero,
  });
}

class KUrlPreview extends StatefulWidget {
  final String url;
  final Duration maxAge;
  final String? cacheKey;
  final KUrlPreviewLayoutType type;
  final BoxConstraints constraints;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;
  final EdgeInsets imagePadding;
  final List<KUrlPreviewItem> items;
  final BoxConstraints imageConstraints;
  const KUrlPreview(
      this.url, {
        Key? key,
        this.constraints = const BoxConstraints(),
        this.imagePadding = EdgeInsets.zero,
        this.type = KUrlPreviewLayoutType.column,
        this.crossAxisAlignment = CrossAxisAlignment.center,
        this.mainAxisAlignment = MainAxisAlignment.start,
        this.maxAge = const Duration(days: 30),
        this.imageConstraints = const BoxConstraints(),
        this.cacheKey,
        this.items = const <KUrlPreviewItem>[],
      }) : super(key: key);

  @override
  _KUrlPreviewState createState() => _KUrlPreviewState();
}

class _KUrlPreviewState extends State<KUrlPreview>
    with AutomaticKeepAliveClientMixin {
  KPreviewMetaData? _meta;
  bool _isReloadedItem = false;
  List<Widget> _items = <Widget>[];
  final _cacheManager = DefaultCacheManager();
  @override
  void initState() {
    _loadCache();
    super.initState();
  }

  /// load website from file cached
  void _loadCache() async {
    String key = widget.cacheKey ?? widget.url;
    FileInfo? fileInfo = await _cacheManager.getFileFromMemory(key);
    if (fileInfo == null) {
      fileInfo = await _cacheManager.getFileFromCache(key);
    }

    /// call api so don't file cached
    if (fileInfo == null) {
      _loadPreview();
    } else {
      /// load data from fileInfo
      List<int> data = fileInfo.file.readAsBytesSync();
      String str = utf8.decode(data, allowMalformed: true).toString();
      Map map = json.decode(str);

      if (mounted) {
        setState(() {
          _isReloadedItem = false;
          _meta = KPreviewMetaData.fromJSon(map);
        });
      }
    }
  }

  /// call api to get website
  void _loadPreview() {
    NetworkHttp.get(widget.url).then((value) {
      if (!mounted) {
        _meta = value;
        return;
      }

      setState(() {
        _isReloadedItem = false;
        _meta = value;
      });
      if (_meta == null) return;
      String js = json.encode(_meta!.toMap());
      final encryptedBase64EncodedString = utf8.encode(js);

      _cacheManager.putFile(
        widget.url,
        Uint8List.fromList(encryptedBase64EncodedString),
        key: widget.cacheKey ?? widget.url,
        maxAge: widget.maxAge,
      );
    });
  }

  @override
  void didUpdateWidget(covariant KUrlPreview oldWidget) {
    if (widget.url != oldWidget.url) {

      _loadCache();
    } else if (widget.imagePadding != oldWidget.imagePadding ||
        widget.imageConstraints != oldWidget.imageConstraints ||
        widget.items != oldWidget.items) {
      _isReloadedItem = false;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (_meta == null) {
      return SizedBox(width: 0);
    }

    if (!_isReloadedItem) {
      _isReloadedItem = true;
      _items= [];
      widget.items.forEach((item) {
        switch (item.type) {
          case KUrlPreviewItemType.title:
            final w = KPreviewText(
              text: _meta!.title,
              style: item.style,
              padding: item.padding,
            );
            _items.add(w);
            break;
          case KUrlPreviewItemType.siteName:
            final w = KPreviewText(
              text: _meta!.siteName,
              style: item.style,
              padding: item.padding,
            );
            _items.add(w);
            break;
          case KUrlPreviewItemType.description:
            final w = KPreviewText(
              text: _meta!.description,
              style: item.style,
              padding: item.padding,
            );
            _items.add(w);
            break;
          case KUrlPreviewItemType.originalUrl:
            final w = KPreviewText(
              text: widget.url,
              style: item.style,
              padding: item.padding,
            );
            _items.add(w);
            break;
          default:
            break;
        }
      });
    }

    return ConstrainedBox(
      constraints: widget.constraints,
      child: _KPreviewLayout(
        _meta!,
        type: widget.type,
        imagePadding: widget.imagePadding,
        imageConstraints: widget.imageConstraints,
        mainAxisAlignment: widget.mainAxisAlignment,
        crossAxisAlignment: widget.crossAxisAlignment,
        items: _items,
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    super.dispose();
  }
}

class _KPreviewLayout extends StatelessWidget {
  final KPreviewMetaData meta;
  final KUrlPreviewLayoutType type;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;
  final EdgeInsets imagePadding;
  final List<Widget> items;
  final BoxConstraints imageConstraints;
  const _KPreviewLayout(this.meta,
      {Key? key,
        this.imagePadding = EdgeInsets.zero,
        this.type = KUrlPreviewLayoutType.column,
        this.crossAxisAlignment = CrossAxisAlignment.center,
        this.mainAxisAlignment = MainAxisAlignment.start,
        this.imageConstraints = const BoxConstraints(),
        this.items = const <Widget>[]})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    switch (type) {
      case KUrlPreviewLayoutType.column:
        return Column(
          crossAxisAlignment: crossAxisAlignment,
          mainAxisAlignment: mainAxisAlignment,
          mainAxisSize: MainAxisSize.min,
          children: [
            ConstrainedBox(
              constraints: imageConstraints,
              child: KPreviewImage(
                imageUrl: meta.imageUrl,
                padding: imagePadding,
                boxFit: BoxFit.cover,
              ),
            ),
            ...items
          ],
        );
        break;
      case KUrlPreviewLayoutType.row:
        return Row(
          crossAxisAlignment: crossAxisAlignment,
          mainAxisAlignment: mainAxisAlignment,
          mainAxisSize: MainAxisSize.min,
          children: [
            ConstrainedBox(
              constraints: imageConstraints,
              child: KPreviewImage(
                imageUrl: meta.imageUrl,
                padding: imagePadding,
                boxFit: BoxFit.fitWidth,
              ),
            ),
            ...items
          ],
        );
        break;
    }
  }
}




