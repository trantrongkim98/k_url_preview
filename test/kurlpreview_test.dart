import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kurlpreview/src/data/k_preview_meta.dart';
import 'package:kurlpreview/src/http/http.dart';

void main() {
  group('[NetworkHttp] - ', () {
    test('url valid', () async {
      final response = await NetworkHttp.get('https://cafef.vn/chon-sai-co-phieu-nhieu-nha-dau-tu-van-thua-lo-bat-chap-thi-truong-vuot-dinh-2021052517311072.chn');
      expect(response, isA<KPreviewMetaData>());
    });

    test('url valid missing https and add https to url', () async {
      final response = await NetworkHttp.get('cafef.vn/chon-sai-co-phieu-nhieu-nha-dau-tu-van-thua-lo-bat-chap-thi-truong-vuot-dinh-2021052517311072.chn');
      expect(response, isA<KPreviewMetaData>());
    });

    test('url valid with http://www', () async {
      final response = await NetworkHttp.get('https://www.cafef.vn/chon-sai-co-phieu-nhieu-nha-dau-tu-van-thua-lo-bat-chap-thi-truong-vuot-dinh-2021052517311072.chn');
      expect(response, isA<KPreviewMetaData>());
    });

    test("url with don't have image", () async {
      final response = await NetworkHttp.get('https://mail.google.com/mail/u/0/#inbox');
      expect(response, isA<KPreviewMetaData>());
    });

    test('Stack Overflow ',()async{

      final response = await NetworkHttp.get('https://stackoverflow.com/questions/25694168/how-do-you-handle-stale-cache-records-in-mobile-app');
      expect(response, isA<KPreviewMetaData>());
    });



  });
}
