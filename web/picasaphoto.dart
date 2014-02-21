import 'package:polymer/polymer.dart';
import 'picasaphotopresentor.dart';

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

  PicasaPhotoPresentor presentor;
  
  
  PicasaPhoto.created() : super.created() {
    
    Element imgElement = shadowRoot.querySelector('#img-tag');
    presentor = new PicasaPhotoPresentor( this, imgElement, getHttpRequest);
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

