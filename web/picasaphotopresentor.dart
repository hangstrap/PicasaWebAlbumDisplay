import 'picasa_web_albums.dart';
import 'dart:html';
import "dart:async";
import "dart:math";
import "random_photo_list.dart";

class PicasaPhotoView{
  String imageUrl ;   
  String title;  
  String delay;    
  String width;
  String height;  
}
class PicasaPhotoPresentor{

  PicasaPhotoView view;
  
  RandomPhotoList<Photo> randomPhotoList = new RandomPhotoList();
  Photo current = null;
  
  
  Element imgElement;
  StreamSubscription nextPhotoSubscription;
    
  PicasaPhotoPresentor ( PicasaPhotoView view,  Element imgElement, getHttpRequest ){
    this.view = view;
    this.imgElement = imgElement;
    User user = new User( "101488109748928583216", getHttpRequest);
    user.albums().then( _processAlbums);
  }

  void delayChanged( ){
    print( "had event ${view.delay}");
    _setUpStream();
  }
  void imageEvent(){
    if( current == null){
      return;
    }
    view.title= "Album '${current.album.title}'  ${current.summary}";
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
      view.imageUrl = current.url(imgmax: _getImgageMaxSize());
   
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
    int currentDelay = int.parse( view.delay);
    Stream stream = new Stream.periodic( new Duration ( seconds: currentDelay));
    nextPhotoSubscription = stream.listen( (_)=>_displayNextPhoto());
  }
}