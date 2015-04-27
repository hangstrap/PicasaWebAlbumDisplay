import 'package:json_object/json_object.dart';
import '../web/picasa_web_albums.dart' ;
import 'package:unittest/unittest.dart';
import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:mock/mock.dart';


Future<String> getHttpRequest(Uri url) {
    return http.get( url).then( (response)=> response.body);
}
Future<String> getStubbedHttpRequest(Uri url) {
  print( "stub ${url}");
  if( url.toString() == "https://picasaweb.google.com/data/feed/api/user/9999?alt=json"){
    return new Future( getXmlForUser);
  }
  if( url.toString() == "https://picasaweb.google.com/data/feed/api/user/101488109748928583216/albumid/5938894451891583841?alt=json&imgmax=d"){
    return new File(  "test/5938894451891583841").readAsString();
  }
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
      expect( photo.width, equals( 1536));
      expect( photo.height, equals( 2048));      
      expect( photo.isLandscape, equals( false));
      expect( photo.url(),                equals( "https://lh5.googleusercontent.com/-IvEtX1Hcztg/UoaKrLqG3-I/AAAAAAAAT7E/9jyfqPDIl5c/d/IMG_5271.JPG"));
      expect( photo.url( imgmax:"1200"),  equals( "https://lh5.googleusercontent.com/-IvEtX1Hcztg/UoaKrLqG3-I/AAAAAAAAT7E/9jyfqPDIl5c/s1200/IMG_5271.JPG"));
    });
    
    test("should load albums from json object", (){        
      List<Album> albums = new User("aa", getHttpRequest).loadFromJson( getJsonForUser());
      expect( albums.length, equals( 1));
      expect( albums.first.title, equals( "Tessa d\'Jappervilla"));
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
    

    test( "The album titled 'd\'Jappervilla' should contain a photo with a title of '2013-10-26 09.36.22.jpg'", (){
      
      Future< List<Album>> albumsFuture = user.albums();      
      expect( albumsFuture.then( (albums)=>isPhotoInAlbum( albums, 'Tessa d\'Jappervilla', "2013-10-26 09.36.22.jpg")), completion(equals( true)));
    }); 
  });
  group( "When server is mocked", (){
    User user ;
    setUp((){
      user = new User( "9999", getStubbedHttpRequest);
    });

    test( "loadPhotsFromAlub should return one Album when mocked", (){
      
      void loadPhotosFromAlbum( Album album, List<Photo> photos){  
        expect( album.title, equals("Tessa d'Jappervilla"));
        expect( photos.length, equals( 29));
        print( 'album ${album.title} has ${photos.length} photos');
      }
      
      user.loadAllAlbums( expectAsync( loadPhotosFromAlbum, count:1));
    });
  });
}
Future<bool> isPhotoInAlbum( List<Album> albums, String albumTitle, String photoTitle){

  Album album = albums.firstWhere( (album)=> album.title == albumTitle);

  bool findPhoto(List<Photo> photos){
    return photos.any( ( Photo photo) => photo.title == photoTitle);
  }  
  return album.photos().then( findPhoto);
}



JsonObject getJsonForPhoto() {
  return new JsonObject.fromJsonString( new File(  "test/photo.json").readAsStringSync());
}

String getXmlForAlbum(){
  //5938894451891583841 //"album.json"
  return new File(  "test/album.json").readAsStringSync();
}
JsonObject getJsonForAlbum(){
  return new JsonObject.fromJsonString( getXmlForAlbum());  
}

String getXmlForUser(){
  return new File(  "test/user.json").readAsStringSync();
}
JsonObject getJsonForUser(){
  return new JsonObject.fromJsonString( getXmlForUser(), new JsonObject())  ;
}

class MockAlbum extends Mock implements Album{}