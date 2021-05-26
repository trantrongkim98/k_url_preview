String addHttpToUrlImage(String webUrl ,String urlImage){
  if(urlImage.contains(RegExp(r'(http+s?:?\/\/)'))){
    return urlImage;
  }
  return '$webUrl$urlImage';
}

String resolveUrl(String host,String url){
  final uri = Uri.tryParse(url);
  final hostUri = Uri.tryParse(host);
  if(uri?.host.isEmpty??true){
    hostUri;
    String schema = '';
    if(hostUri?.scheme.isNotEmpty??false){
      schema = '${hostUri!.scheme}://';
    }
    return '$schema${hostUri?.host??''}$url';
  }
  return url;
}