import 'dart:html';

import 'package:unittest/unittest.dart';
import 'package:unittest/mock.dart';
import 'package:../web/picasaphotopresentor.dart';

@proxy
class MockView extends Mock implements PicasaPhotoView{}
class MockElement extends Mock implements Element{}

void main(){
  
  test("",(){
    MockView view = new MockView();  
    MockElement element = new MockElement();
    
    PicasaPhotoPresentor underTest = new PicasaPhotoPresentor( view, element,  null );
    setUp((){
      
    });
  });
}
