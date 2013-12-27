library picasa_web_album;

/*
 * A User has a set of Albums   -> url = https://picasaweb.google.com/data/feed/api/user/101488109748928583216
 * An Ablum has a ser of Photos -> url for each album = https://picasaweb.google.com/data/feed/api/user/101488109748928583216/albumid/5938894451891583841?alt=json
 */

import "dart:async";
import 'package:json_object/json_object.dart';


abstract class HttpRequester{
  Future<String> get(Uri url);
}

class Photo{
  JsonObject json;
  Photo( this.json);
  
  String get title => json.title.$t;
  String get summary => json.summary.$t;
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
  
  Future<List<Photo>> get photos{
    
    Uri url = getAlbumUri();
    return requester.get(url).then( (String response){
      
      List<Photo> result = [];
      
      JsonObject json = new JsonObject.fromJsonString( response);
      List<JsonObject> jsonEntries = json.feed.entry;
      jsonEntries.forEach( (e)=> result.add( new Photo( e)));
      
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
    return requester.get( myAlbum ).then( (String response){
      JsonObject json = new JsonObject.fromJsonString( response);
      return loadFromJson( json);
    });    
  }
}