import 'package:polymer/polymer.dart';
import 'picasaphotopresentor.dart';
import 'picasa_web_albums.dart';

import 'dart:html';
import "dart:async";

/**
 * A Polymer click counter element.
 */
@CustomTag('picasa-photo')
class PicasaPhoto extends PolymerElement implements PicasaPhotoView{
   
  @observable
  String imageUrl = "https://lh5.googleusercontent.com/-IvEtX1Hcztg/UoaKrLqG3-I/AAAAAAAAT7E/9jyfqPDIl5c/s1200/IMG_5271.JPG";
  @observable  
  String title = "cute puppy";
  @observable
  String delay = '3';
  
  @observable
  String width ="";
  @observable
  String height="";
  
  int get clientHeight => imgElement.clientHeight;
  int get clientWidth=>imgElement.clientWidth;

  PicasaPhotoPresentor presentor;
  Element imgElement; 
  
  PicasaPhoto.created() : super.created() {
    
    imgElement = shadowRoot.querySelector('#img-tag');
    User user = new User( "101488109748928583216", getHttpRequest);
    
    presentor = new PicasaPhotoPresentor( this, user);
  }

  void delayChanged( ){
    presentor.delayChanged();
  }
  void imageEvent(){
    presentor.imageEvent();
  }  
}



Future<String> getHttpRequest(Uri url) {
  print( url.toString());
  return HttpRequest.getString( url.toString());
}

