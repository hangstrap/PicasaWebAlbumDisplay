import 'package:polymer/polymer.dart';
import 'picasa_web_albums.dart';
import 'dart:html';
import "dart:async";
import "dart:math";
import "random_photo_list.dart";

/**
 * A Polymer click counter element.
 */
@CustomTag('picasa-photo')
class PicasaPhoto extends PolymerElement {
  
  RandomPhotoList<Photo> randomPhotoList = new RandomPhotoList();
  Photo current = null;
  
  @observable
  String imageUrl = "https://lh5.googleusercontent.com/-IvEtX1Hcztg/UoaKrLqG3-I/AAAAAAAAT7E/9jyfqPDIl5c/s1200/IMG_5271.JPG";
  @observable  
  String title = "cute puppy";
  @observable
  String delay = '3';
  
  Element imgElement;

  StreamSubscription nextPhotoSubscription;
    
  PicasaPhoto.created() : super.created() {
    
    imgElement = shadowRoot.querySelector('#img-tag');
    User user = new User( "101488109748928583216", getHttpRequest);
    user.albums().then( _processAlbums);
  }

  void delayChanged( ){
    print( "had event ${delay}");
    

    print( "width=${imgElement.clientWidth} height=${imgElement.clientHeight}");
    _setUpStream();
  }
  

  
  _processAlbums(List<Album> albums) {
    albums.forEach( (album)=>album.photos.then( _processPhotos));
  }
  
  _processPhotos(List<Photo> photos) {
    if( randomPhotoList.originalItems.length ==0){
      _setUpStream();
    }
    randomPhotoList.addList(photos);
  }
  
  void _displayNextPhoto(){
    current = randomPhotoList.nextItem(); 
    if( current != null){
      imageUrl = current.url(imgmax: _getImgageMaxSize());
      title= "Album '${current.album.title}'  ${current.summary}";
    }else{
      print( "nothing to display");
    }    
  }
  
  int _getImgageMaxSize(){
    return max( imgElement.clientHeight, imgElement.clientWidth);
  }

  
  void _setUpStream(){
    
    if( nextPhotoSubscription != null){
      nextPhotoSubscription.cancel();
    };
    int currentDelay = int.parse( delay);
    Stream stream = new Stream.periodic( new Duration ( seconds: currentDelay));
    nextPhotoSubscription = stream.listen( (_)=>_displayNextPhoto());
  }
}



Future<String> getHttpRequest(Uri url) {
  print( url.toString());
  return HttpRequest.getString( url.toString());
}

