import 'package:unittest/unittest.dart';
import 'package:unittest/mock.dart';
import '../web/picasaphotopresentor.dart';
import '../web/picasa_web_albums.dart';
import 'dart:async';

@proxy
class MockView extends Mock implements PicasaPhotoView{}
class MockUser extends Mock implements User{}
class MockAlbum extends Mock implements Album{}
class MockPhoto extends Mock implements Photo{}


void main(){
  
  test("constuctor should request the albums from the user ",(){
    
    MockUser user = new MockUser();
    MockView view = new MockView();  

    MockAlbum album = new MockAlbum();
    List<Album> listOfAlbums = [ album];

    MockPhoto photo = new MockPhoto();
    List<Album> listOfPhotos = [ album];
    
    user.when( callsTo( "albums")).thenReturn(  new Future( ()=>listOfAlbums ));    
    album.when( callsTo( "photos")).thenReturn( new Future( ()=>listOfPhotos));
    
    PicasaPhotoPresentor underTest = new PicasaPhotoPresentor( view, user);
    
    user.getLogs( callsTo( "albums")).verify( happenedOnce);
    //expect( album.getLogs( callsTo( "photos")).verify( happenedOnce));

  });
}
