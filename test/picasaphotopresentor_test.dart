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
class MockFuture extends Mock implements Future{}
void main(){
  
  test("constuctor should call userAlbums",(){
    
    Mock user = new Mock.custom();
    MockView view = new MockView();  
//    MockUser user = new MockUser.custom();
    MockFuture futureAlbums = new MockFuture();
    Future<List<Album>> albums = futureAlbums ; 
    
    user.when( callsTo( "albums")).thenReturn( albums);
    
    PicasaPhotoPresentor underTest = new PicasaPhotoPresentor( view, user);
    
    user.getLogs(logFilter, actionMatcher, true)
    

  });
}
