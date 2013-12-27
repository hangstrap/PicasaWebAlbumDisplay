import 'package:polymer/polymer.dart';
import 'picasa_web_albums.dart';
import 'dart:html';
import "dart:async";

/**
 * A Polymer click counter element.
 */
@CustomTag('picasa-photo')
class PicasaPhoto extends PolymerElement {
  
  
  @observable
  String imageUrl = "https://lh5.googleusercontent.com/-IvEtX1Hcztg/UoaKrLqG3-I/AAAAAAAAT7E/9jyfqPDIl5c/s1200/IMG_5271.JPG";
    
  PicasaPhoto.created() : super.created() {
    
    User user = new User( "101488109748928583216", getHttpRequest);
    user.albums().then( processAlbums);
  }

  
  processAlbums(List<Album> albums) {
    albums.first.photos.then( processPhotos);
  }
  
  processPhotos(List<Photo> photos) {
    imageUrl = photos.first.url(imgmax: 600);
  }
}

Future<String> getHttpRequest(Uri url) {
  return HttpRequest.getString( url.toString());
}

