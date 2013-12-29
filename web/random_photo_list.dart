import "dart:math";

class RandomPhotoList<T>{
  
  static Random random = new Random();
  List<T> originalItems =[];
  List<T> items = [];
  List<T> nextItemList = [];
  
  void addList(List<T> items) {
    this.items.addAll( items);
    this.originalItems.addAll( items);
  }
  
  T nextItem( {int length: 10}){
    if( nextItemList.isEmpty){
      nextItemList = randomSubList(length: length);
    }
    return nextItemList.removeAt( 0);
  }
  
  List<T> randomSubList({int length: 10}) {
    
    if( length >= items.length){
      return _listIsAlmostEmpty();      
    }else{
      return _listIsFullEnough(length);
    }
  }

  List<T> _listIsFullEnough(int length) {
    int startFrom = getRandom(length);
    int endsAt = startFrom + length;        
    List<T> result = new List<T>.from( items.getRange( startFrom, endsAt));
    items.removeRange( startFrom, endsAt);
    return result;
  }

  List<T> _listIsAlmostEmpty() {
    List<T> result = items;
    items.clear();
    items.addAll( originalItems);
    return result;
  }
  
  int getRandom( int length){
    int max = items.length - length;
    return random.nextInt( max);
  }
}