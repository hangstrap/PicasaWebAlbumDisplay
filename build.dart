import 'package:polymer/builder.dart';
        
main(args) { 
  lint(entryPoints: ['web/picasawebalbumdisplay.html'], options: parseOptions(args));
  
  build(entryPoints: ['web/picasawebalbumdisplay.html'],
        options: parseOptions(args));
}
