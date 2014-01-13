import 'package:polymer/polymer.dart';
import 'picasa_web_albums.dart';
import 'dart:html';
import "dart:async";
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
  String title = "";
  @observable
  String delay = '3';

  StreamSubscription nextPhotoSubscription;
    
  PicasaPhoto.created() : super.created() {
    
    User user = new User( "101488109748928583216", getHttpRequest);
    user.albums().then( _processAlbums);
  }

  void delayChanged( ){
    print( "had event ${delay}");
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
      imageUrl = current.url(imgmax: 600);
    }else{
      print( "nothing to display");
    }    

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

