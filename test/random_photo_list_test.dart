
import 'package:unittest/unittest.dart';
import '../web/random_photo_list.dart' ;
import "dart:math";
import 'package:mock/mock.dart';

void main(){

  MockRandom random;
  RandomPhotoList<int> underTest;
  
  List<int> firstItems = createItems( 0, 9);
  List<int> secondItems = createItems( 10, 19);    
  
  setUp((){
    underTest = new RandomPhotoList<int>();
    RandomPhotoList.random = random = new MockRandom();

  });

  group("Adding lists of items", (){
    test("should be added to items list",() {
      
      underTest.addList( firstItems );
      expect( underTest.items, orderedEquals( firstItems ));
    });
    test("should be added to originalItems list",() {
      
      underTest.addList( firstItems );
      expect( underTest.originalItems, orderedEquals( firstItems ));
    });
    test("should be able to add multiple lists",() {
      
      underTest.addList( firstItems);
      underTest.addList( secondItems);
      
      var total = [];
      total.addAll( firstItems);
      total.addAll( secondItems);      
      expect( underTest.items, orderedEquals( total));
    });  
  });    
  group( "sub list", (){
    
    group( "when have less items than requested", (){
      test("then should return all items",(){
  
        underTest.addList( firstItems );
        List<int> subItems = underTest.randomSubList( length:10);      
        expect( subItems, unorderedEquals( firstItems ));
        
      });
      test("then items list should be repoputated with orignal list",(){
        
        underTest.addList( firstItems );
        List<int> subItems = underTest.randomSubList( length:10);      
        expect( underTest.items, orderedEquals( underTest.originalItems ));
        
      });

    });      
    group( "when more items than requested", (){
      
      setUp((){
        random.when( callsTo("nextInt", anything)).thenReturn( 2);               
        underTest.addList( firstItems );          
      });
    
      test("then should return list with length matching requested",(){
        
        List<int> subItems = underTest.randomSubList( length:5);      
        expect( subItems, hasLength( 5));        
      });
      test("should have list starting from value returned by random",(){
        
        List<int> subItems = underTest.randomSubList( length:5);
        expect( subItems, orderedEquals( [2,3,4,5,6]));
      });
      test("subitems should be removed from the original list", (){
        List<int> subItems = underTest.randomSubList( length:5);
        expect( underTest.items, orderedEquals( [0,1,7,8,9]));
      });
      test("when items are low then original items should be added to list", (){
        underTest.randomSubList( length:5);
        underTest.randomSubList( length:5);
        expect( underTest.items, orderedEquals( underTest.originalItems));
      });
    });    
    group("nextItem", (){
      
      test("Should return correct patten", (){

        underTest.addList( firstItems );
        random.when( callsTo("nextInt", anything)).thenReturn( 2).thenReturn( 0, 4);        
        expect( underTest.nextItem( length:3), equals(2));
        expect( underTest.nextItem( length:3), equals(3));
        expect( underTest.nextItem( length:3), equals(4));        
        //random will be called, which will return 0
        expect( underTest.nextItem( length:3), equals(0));
        expect( underTest.nextItem( length:3), equals(1));
        expect( underTest.nextItem( length:3), equals(5));
        //random will be called, which will return 0
        expect( underTest.nextItem( length:3), equals(6));
        expect( underTest.nextItem( length:3), equals(7));
        expect( underTest.nextItem( length:3), equals(8));
        //random will be called, which will return 0        
        //This should reload the list
        expect( underTest.nextItem( length:3), equals(0));
        expect( underTest.nextItem( length:3), equals(1));
        expect( underTest.nextItem( length:3), equals(2));
        
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
@proxy
class MockRandom extends Mock implements Random{
  
}