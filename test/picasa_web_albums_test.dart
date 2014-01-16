import 'package:json_object/json_object.dart';
import '../web/picasa_web_albums.dart' ;
import 'package:unittest/unittest.dart';
import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:unittest/mock.dart';


Future<String> getHttpRequest(Uri url) {
    return http.get( url).then( (response)=> response.body);
}

void main(){
  group( "When loading from precanned json data", (){
    
    test( "should load album from json",() {
      Album album = new Album( getJsonForAlbum(), getHttpRequest);
      expect( album.title, equals( "Tessa d\'Jappervilla"));
      expect( album.rights, equals( "public"));
      expect( album.getAlbumUri(), equals( Uri.parse("https://picasaweb.google.com/data/feed/api/user/101488109748928583216/albumid/5938894451891583841?alt=json&imgmax=d")));
      
    });
    
    test( "should load photo from json", (){
      
      MockAlbum mockAlbum = new MockAlbum();
      Photo photo = new Photo( mockAlbum, getJsonForPhoto());
      expect( photo.album, equals( mockAlbum));
      expect( photo.title, equals( "2013-10-26 09.36.22.jpg"));
      expect( photo.summary, equals( "Some sort of comment"));
      expect( photo.url(),                equals( "https://lh5.googleusercontent.com/-IvEtX1Hcztg/UoaKrLqG3-I/AAAAAAAAT7E/9jyfqPDIl5c/d/IMG_5271.JPG"));
      expect( photo.url( imgmax:"1200"),  equals( "https://lh5.googleusercontent.com/-IvEtX1Hcztg/UoaKrLqG3-I/AAAAAAAAT7E/9jyfqPDIl5c/s1200/IMG_5271.JPG"));
    });
    
    test("should load albums from json object", (){        
      List<Album> albums = new User("aa", getHttpRequest).loadFromJson( getJsonForUser());
      expect( albums.length, equals( 85));
      expect( albums.first.title, equals( "Tessa d\'Jappervilla"));
      expect( albums.last.title, equals( "Mana Island"));
    });
  });  
  
  group( "When loading from actual web service", (){
    
    User user ;
    setUp((){
      user = new User( "101488109748928583216", getHttpRequest);
    });
    
    test( "should return at least the current number of my albums", (){
      User user = new User( "101488109748928583216", getHttpRequest);
      Future< List<Album>> albumsFuture = user.albums();
      expect( albumsFuture.then( (albums)=> albums.length), completion( greaterThanOrEqualTo( 85)));      
    });
    

    
    test( "should return a Album titled 'd\'Jappervilla'", (){
      User user = new User( "101488109748928583216", getHttpRequest);
      Future< List<Album>> albumsFuture = user.albums();

      expect( albumsFuture.then( (albums)=> albums.any( isAlbumTess )), completion( equals( true)));
      
    });
    
    test( "Album titled 'd\'Jappervilla' should contain a photo with a title of '2013-10-26 09.36.22.jpg'", (){
      
      Future< List<Album>> albumsFuture = user.albums();      
      expect( albumsFuture.then( isPhotoInAlbum), completion(equals( true)));

    });    
  });
}
Future<bool> isPhotoInAlbum( List<Album> albums){
  Album album = findAlbumTess( albums);
  return album.photos.then( findPhoto);
}

Album findAlbumTess( List<Album> albums){
  return albums.firstWhere( isAlbumTess);
}
bool isAlbumTess(Album album){
  return album.title == 'Tessa d\'Jappervilla';
}

bool findPhoto(List<Photo> photos){
  return photos.any( ( Photo photo) => photo.title == "2013-10-26 09.36.22.jpg");
}


JsonObject getJsonForPhoto() {
  return new JsonObject.fromJsonString( new File(  "photo.json").readAsStringSync());
}


JsonObject getJsonForAlbum(){
  return new JsonObject.fromJsonString( new File(  "album.json").readAsStringSync());  
}


JsonObject getJsonForUser(){
  return new JsonObject.fromJsonString( new File(  "user.json").readAsStringSync(), new JsonObject())  ;
}

class MockAlbum extends Mock implements Album{}