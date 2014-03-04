library picasa_web_album;

/*
 * A User has a set of Albums   -> url = https://picasaweb.google.com/data/feed/api/user/101488109748928583216
 * An Ablum has a ser of Photos -> url for each album = https://picasaweb.google.com/data/feed/api/user/101488109748928583216/albumid/5938894451891583841?alt=json
 */

import "dart:async";
import 'package:json_object/json_object.dart';

//Use this method to make the correct type of httpRequest
typedef Future<String> HttpRequester(Uri url);

typedef void LoadPhotosFromAlbum( List<Photo> photos);

class Photo{
  final JsonObject json;
  final Album album;
  
  Photo( this.album, this.json);
  
  String get title => json.title.$t;
  String get summary => json.summary.$t;
  int get width => int.parse( json.gphoto$width.$t);
  int get height => int.parse( json.gphoto$height.$t);
  bool get isLandscape => width > height;
  
  String url( {imgmax:'d'}){
    if( imgmax=='d'){
      return json.media$group.media$content[0].url;
    }else{
      String defaultUrl = url(); 
      return defaultUrl.replaceFirst("/d", "/s${imgmax}");
    }
  }

}


class Album {
  
  JsonObject json;
  HttpRequester requester;
  
  Album( this.json, this.requester);
  
  String get title => json.title.$t;
  String get rights => json.rights.$t;
  
  Future<List<Photo>> photos(){
    
    Uri url = getAlbumUri();
    return requester(url).then( (String response){
      
      List<Photo> result = [];
      
      JsonObject json = new JsonObject.fromJsonString( response);
      List<JsonObject> jsonEntries = json.feed.entry;
      jsonEntries.forEach( (e)=> result.add( new Photo( this, e)));
      
      return result;
    });
  }
    
  
  Uri getAlbumUri(){
    List<JsonObject> links = json.link;
    JsonObject link = links.firstWhere( (JsonObject e)=> e.rel.startsWith( "http://schemas"));
    return Uri.parse( "${link.href}&imgmax=d");
  }
}

  
class User{
  
  String id;
  HttpRequester requester;
  
  User( this.id, this.requester);
      
  List<Album> loadFromJson( JsonObject json){       
    
    List<JsonObject> entries = json.feed.entry;
    List<Album> result = [];
    entries.forEach( (e)=> result.add( new Album( e, requester)));
    return result;
  }


  Future<List<Album>> albums(){
    Uri myAlbum = Uri.parse("https://picasaweb.google.com/data/feed/api/user/${id}?alt=json");
    return requester( myAlbum ).then( (String response){
      JsonObject json = new JsonObject.fromJsonString( response);
      return loadFromJson( json);
    });    
  }
  
  void loadAllAlbums( LoadPhotosFromAlbum loadPhotosFromAlbum){
    
    void processAlbum( List<Album> albums){
      albums.forEach( (album){
        album.photos().then( (photos) => loadPhotosFromAlbum( photos));
      });
    }
    albums().then( (albums) =>processAlbum( albums));
  }
}

