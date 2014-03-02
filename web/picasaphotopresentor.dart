import 'picasa_web_albums.dart';

import "dart:async";
import "dart:math";
import "random_photo_list.dart";

class PicasaPhotoView{
  String imageUrl="" ;   
  String title="";  
  String delay="1";    
  String width="100%";
  String height="100%";
  int get clientHeight=>0;
  int get clientWidth=>0;
}
class PicasaPhotoPresentor{

  PicasaPhotoView view;
  
  RandomPhotoList<Photo> randomPhotoList;
  Photo current = null;
  
  
  StreamSubscription nextPhotoSubscription;
    
  PicasaPhotoPresentor ( RandomPhotoList<Photo> randomPhotoList, PicasaPhotoView view,  User user){
    this.randomPhotoList = randomPhotoList;
    this.view = view;   
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
    print( "here ${albums.length}");
    albums.forEach( (album)=> album.photos().then( _processPhotos)    );
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
    return max( view.clientHeight, view.clientWidth);
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