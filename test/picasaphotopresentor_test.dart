import 'package:unittest/unittest.dart';
import 'package:mock/mock.dart';
import '../web/random_photo_list.dart';
import '../web/picasaphotopresentor.dart';
import '../web/picasa_web_albums.dart';

import 'dart:async';

@proxy

class MockUser extends Mock implements User{}
class MockAlbum extends Mock implements Album{}
class MockPhoto extends Mock implements Photo{}
class MockRandomPhotoList extends Mock implements RandomPhotoList<Photo>{}


void main(){
  group( "Test it", (){
    
    MockUser user;
    PicasaPhotoView view;  
    
    MockAlbum album;
    List<Album> listOfAlbums;
    
    MockPhoto photo;
    List<Album> listOfPhotos;
    
    MockRandomPhotoList randomPhotoList;
    
    PicasaPhotoPresentor underTest; 

    setUp( (){
      randomPhotoList = new MockRandomPhotoList();
      randomPhotoList.when( callsTo( "get originalItems")).alwaysReturn(0);
      randomPhotoList.when( callsTo( "addList"));
      user = new MockUser();
      view = new PicasaPhotoView();  
      
      album = new MockAlbum();
      listOfAlbums = [ album];
      
      photo = new MockPhoto();
      listOfPhotos = [ album];

      user.when( callsTo( "albums")).thenReturn(  new Future( ()=>listOfAlbums ));    
      album.when( callsTo( "photos")).thenReturn( new Future( ()=>listOfPhotos));

      underTest = new PicasaPhotoPresentor( randomPhotoList, view);
      
    });
    
    test("constuctor should request the albums from the user ",(){                       
      user.getLogs( callsTo( "albums")).verify( happenedOnce);
    });
    test( "the photos should be requested from the album", (){
      expectAsync( (){
        album.getLogs( callsTo( "photos")).verify(  happenedOnce);
        expect( underTest.randomPhotoList.items, hasLength( 1));        
      });

    });
  });
}
