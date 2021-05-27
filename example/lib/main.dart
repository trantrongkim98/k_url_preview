import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kurlpreview_example/http_config.dart';
import 'package:kurlpreview/src/ui/k_url_preview_custom.dart';

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<String> list = [];
  @override
  void initState() {
    final list1 = [
      'https://www.google.com',
      ...List.generate(2, (index) => '')
    ];
    final list2 = ['https://www.fb.com', ...List.generate(2, (index) => '')];
    final list3 = ['https://www.gmail.com', ...List.generate(2, (index) => '')];
    final list4 = [
      'https://www.google.com/search?q=sieu+nhan&btnK=Google+Search&source=hp&ei=reepYNuHOdjR-QbuhYPYBQ&iflsig=AINFCbYAAAAAYKn1vb5dr_qurPj_UyPl-Lgj0Zf7CqUP&oq=url&gs_lcp=Cgdnd3Mtd2l6EAMyAggAMgUIABCxAzIFCAAQsQMyAggAMgIIADICCAAyAggAMgIIADICCAAyAggAOgsILhCxAxDHARCjAjoICC4QsQMQgwE6BQguELEDOggILhDHARCvAToICAAQsQMQgwE6CwguELEDEMcBEK8BUIgIWJ0KYLEMaABwAHgAgAG-AYgBtgOSAQMwLjOYAQCgAQGqAQdnd3Mtd2l6&sclient=gws-wiz&ved=0ahUKEwibkpfbiN_wAhXYaN4KHe7CAFsQ4dUDCAc&uact=5',
      ...List.generate(2, (index) => '')
    ];
    final list5 = [
      'https://www.facebook.com',
      ...List.generate(2, (index) => '')
    ];
    final list6 = ['https://vnpt.com.vn/', ...List.generate(2, (index) => '')];
    final list7 = [
      'https://en.wikipedia.org/wiki/Vietnam_Posts_and_Telecommunications_Group',
      ...List.generate(2, (index) => '')
    ];
    final list8 = ['https://github.com/', ...List.generate(2, (index) => '')];
    final list9 = [
      'https://minaprotocol.com/',
      ...List.generate(2, (index) => '')
    ];
    final list10 = [
      'https://twitter.com/sisainfosec?lang=en',
      ...List.generate(2, (index) => '')
    ];
    list = [
      ...list1,
      ...list2,
      ...list3,
      ...list4,
      ...list5,
      ...list6,
      ...list7,
      ...list8,
      ...list9,
      ...list10,
      ...list1,
      ...list2,
      ...list3,
      ...list4,
      ...list5,
      ...list6,
      ...list7,
      ...list8,
      ...list9,
      ...list10,
      ...list1,
      ...list2,
      ...list3,
      ...list4,
      ...list5,
      ...list6,
      ...list7,
      ...list8,
      ...list9,
      ...list10,
      ...list1,
      ...list2,
      ...list3,
      ...list4,
      ...list5,
      ...list6,
      ...list7,
      ...list8,
      ...list9,
      ...list10
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Plugin example app'),
          ),
          backgroundColor: Colors.black,
          body: Container(
            alignment: Alignment.center,
            child: LayoutBuilder(
              builder: (BuildContext ctx, BoxConstraints constraints) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    color: Colors.grey[900],
                    child: KUrlPreview(
                      'https://pub.dev/packages/expandable_text',
                      type: KUrlPreviewLayoutType.column,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(ctx).size.width * 0.5,
                        // maxHeight: MediaQuery.of(ctx).size.height*0.3
                      ),
                      imagePadding: EdgeInsets.only(bottom: 8),
                      imageConstraints: BoxConstraints(
                        maxHeight: 100,
                        minWidth: MediaQuery.of(ctx).size.width,
                      ),
                      items: [
                        KUrlPreviewItem(
                            type: KUrlPreviewItemType.title,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            padding:
                                EdgeInsets.only(bottom: 8, left: 8, right: 8)),
                        KUrlPreviewItem(
                            type: KUrlPreviewItemType.description,
                            style: TextStyle(
                                fontSize: 11,
                                color: Colors.white70,
                                fontWeight: FontWeight.w500),
                            padding:
                                EdgeInsets.only(bottom: 8, left: 8, right: 8)),
                        KUrlPreviewItem(
                            type: KUrlPreviewItemType.siteName,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 9,
                              fontWeight: FontWeight.w400,
                            ),
                            padding:
                                EdgeInsets.only(bottom: 8, left: 8, right: 8)),
                      ],
                    ),
                  ),
                );
              },
            ),
          )),
    );
  }
}
