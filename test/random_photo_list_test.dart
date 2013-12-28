
import 'package:unittest/unittest.dart';
import '../web/random_photo_list.dart' ;

void main(){

  RandomPhotoList<int> underTest;
  
  List<int> firstItems = createItems( 0, 9);  
  setUp((){
    print( "setup");
    underTest = new RandomPhotoList<int>();

  });

  group("Basic", (){
    test("should be able to add list",() {
      
      underTest.addList( firstItems );
      expect( underTest.items, unorderedEquals( firstItems ));
    });
    test("should be able to add multiple lists",() {
      
      underTest.addList( firstItems);
      
      List<int> secondItems = createItems( 10, 19);
      underTest.addList( secondItems);
      
      var total = [];
      total.addAll( firstItems);
      total.addAll( secondItems);
      
      expect( underTest.items, unorderedEquals( total));
    });  
    
    group( "sub list", (){
      test("when have less items than requested then should return all items",(){
  
        underTest.addList( firstItems );
        List<int> subItems = underTest.randomSubList( length:10);      
        expect( subItems, unorderedEquals( firstItems ));
        
      });
      test("when have more items than requested then should return list with length matching requested",(){
        
        underTest.addList( firstItems );
        List<int> subItems = underTest.randomSubList( length:5);      
        expect( subItems, hasLength( 5));        
      });
    });
    
  });
}

List<int> createItems(int from, int to) {
  var list = [];
  for( int i=from; i <= to; i++){
    list.add( i);
  }
  return list;
}