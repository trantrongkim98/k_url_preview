import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';
import 'package:kurlpreview/src/data/k_preview_meta.dart';
import 'package:kurlpreview/src/util/html_util.dart';
import 'package:kurlpreview/src/util/url_util.dart';

enum ContentType { html, json }

extension ContentTypeValue on ContentType {
  String get value {
    switch (this) {
      case ContentType.html:
        return 'text/html';
      case ContentType.json:
        return 'text/json';
    }
  }

  String get key => 'Content-Type';
}

class NetworkHttp {
  static Future<KPreviewMetaData?> get(String url,
      {bool isRedirect = false}) async {
    String uri = url;
    if (!url.contains('http')) {
      uri = 'https://$url';
    }

    final response = await http.get(Uri.parse(uri), headers: {
      'Content-Type': ContentType.html.value,
      'Accept':
          'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9',
      'sec-ch-ua':
          'Not A;Brand";v="99", "Chromium";v="90", "Google Chrome";v="90',
      'Cache-Control': 'max-age=0',
      'sec-ch-ua-mobile': '?0',
      'ec-fetch-mode': 'navigate',
      'upgrade-insecure-requests': '1',
      'sec-fetch-dest': 'document',
    'Cookie': 'notice-ssb=1%3B1621959666590; prov=66ffb83f-4725-01f3-4a90-fda6052a0a58',
      'User-Agent':
          'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.212 Safari/537.36'
    });
    final result =
        await compute(getIsolate, {'body': response.body, 'url': uri});
    return result;
  }

  static Future<KPreviewMetaData> getIsolate(Map<String, String> map) async {
    String body = map['body'] ?? '';
    String originUrl = map['url'] ?? '';
    var doc = parse(body);
    final metas = doc.head!.getElementsByTagName('meta');
    String title = '';
    String description = '';
    String mediaType = '';
    String image = '';
    String favicon = '';
    String url = '';
    String siteName = '';
    List<Element> titles = doc.getElementsByTagName('title');
    if (titles.isNotEmpty) {
      title = titles.first.text;
    }
    metas.forEach((element) {
      /// title
      if (element.attributes.containsValue('og:title')) {
        title = element.attributes['content'] ?? title;
      }

      /// description
      if (element.attributes.containsValue('description') ||
          element.attributes.containsValue('Description') ||
          element.attributes.containsValue('og:description')) {
        description = element.attributes['content'] ?? description;
      }

      /// media type
      if (element.attributes.containsValue('medium') ||
          element.attributes.containsValue('og:type')) {
        mediaType = element.attributes['content'] ?? mediaType;
        mediaType = mediaType == 'image' ? 'photo' : mediaType;
      }

      /// image
      if (element.attributes.containsValue('og:image') ||
          element.attributes.containsValue('image')) {
        image = element.attributes['content'] ?? image;
        image = resolveUrl(originUrl, image);
      }

      /// url
      if (element.attributes.containsValue('og:url')) {
        url = element.attributes['content'] ?? '';
      }

      /// site name
      if (element.attributes.containsValue('og:site_name')) {
        siteName = element.attributes['content'] ?? '';
      }
    });
    List<Element> elements;

    /// run if image is empty
    if (image.isEmpty) {
      String src = '';
      elements = tryCatchQueryAll(() {
        return doc.querySelectorAll('link[rel=image_src]');
      });
      if (elements.isNotEmpty) {
        src = elements.first.attributes['href'] ?? '';
        image = resolveUrl(originUrl, src);
      } else {
        elements = tryCatchQueryAll(() {
          return doc.querySelectorAll('link[rel=apple-touch-icon]');
        });
        if (elements.isNotEmpty) {
          src = elements.first.attributes['href'] ?? '';
          image = resolveUrl(originUrl, src);
          favicon = image;
        } else {
          elements = tryCatchQueryAll(() {
            return doc.querySelectorAll('link[rel=icon]');
          });
          if (elements.isNotEmpty) {
            src = elements.first.attributes['href'] ?? '';
            image = resolveUrl(originUrl, src);
            favicon = image;
          } else {
            elements = tryCatchQueryAll(() {
              return doc.querySelectorAll('link[rel=shortcut icon]');
            });
            if (elements.isNotEmpty) {
              src = elements.first.attributes['href'] ?? '';
              image = resolveUrl(originUrl, src);
              favicon = image;
            }
          }
        }
      }
    }

    /// favicon

    elements = tryCatchQueryAll(() {
      return doc.querySelectorAll('link[rel=apple-touch-icon]');
    });
    String src = '';
    if (elements.isNotEmpty) {
      src = elements.first.attributes['href'] ?? '';
      if (src.isNotEmpty) {
        favicon = resolveUrl(originUrl, src);
      }
    } else {
      elements = tryCatchQueryAll(() {
        return doc.querySelectorAll('link[rel=icon]');
      });
      if (elements.isNotEmpty) {
        src = elements.first.attributes['href'] ?? '';
        favicon = resolveUrl(originUrl, src);
      } else {
        elements = tryCatchQueryAll(() {
          return doc.querySelectorAll('link[rel=shortcut icon]');
        });
        if (elements.isNotEmpty) {
          src = elements.first.attributes['href'] ?? '';
          favicon = resolveUrl(originUrl, src);
        }
      }
    }

    if (siteName.isEmpty) {
      siteName = Uri.tryParse(originUrl)?.host ?? '';
    }

    /// site name

    return KPreviewMetaData(
      title: title,
      mediaType: mediaType,
      description: description,
      imageUrl: image,
      siteName: siteName,
      favicon: favicon,
    );
  }
}
