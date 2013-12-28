import "dart:math";

class RandomPhotoList<T>{
  
  static Random random = new Random();
  
  List<T> items = [];
  
  void addList(List<T> items) {
    this.items.addAll( items);
  }
  
  
  List<int> randomSubList({int length: 10}) {
    if( length >= items.length){
      return items;      
    }else{
      var result = [];
      for( int i=0; i < length; i++){
        result.add( items.getRange(getRandom(length), length));
      }
      return result;
    }
  }
  
  int getRandom( int length){
    int max = items.length - length;
    return random.nextInt( max);
  }
}