
import 'package:html/dom.dart';

List<Element>? querySelectorAllDoc(Document doc,String ogSelect,String selector){
  String description = '';
  try{
    List<Element> descriptions = doc.querySelectorAll(selector);

    if (descriptions.isNotEmpty) {
      return descriptions;
    }
    if (descriptions.isEmpty) {
      descriptions = doc.querySelectorAll('meta[name=Description]');
      if (descriptions.isNotEmpty) {
       return descriptions;
      }
    }
    List<Element>? metas = doc.head?.getElementsByTagName('meta');
    metas?.forEach((element) {
      print(element.text);
    });
    if(descriptions.isEmpty){
      descriptions = doc.querySelectorAll("meta[property=og:description]");
      if(descriptions.isNotEmpty){
       return descriptions;
      }
    }
    return descriptions;
  }catch(_){
    return <Element>[];
  }
}

List<Element> tryCatchQueryAll(Function() fn){
  try{
    return fn();
  }catch(_){
    return <Element>[];
  }
}

Element? tryCatchQuery(Function() fn){
  try{
    return fn();
  }catch(e){
    return null;
  }
}