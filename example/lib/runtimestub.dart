import 'package:dart_objc/dart_objc.dart';
import 'package:dart_objc_example/delegatestub.dart';

class RuntimeStub extends NSObject {
  RuntimeStub() : super('RuntimeStub');
  int selectorDuration = 0;

  bool fooBool(bool b) {
    return perform('fooBOOL:'.toSelector(), args: [b]);
  }

  int fooInt8(int int8) {
    return perform(Selector('fooInt8:'), args: [int8]);
  }

  String fooCharPtr(String charPtr) {
    return perform(Selector('fooCharPtr:'), args: [charPtr]);
  }

  String fooChar(String char) {
    return perform(Selector('fooChar:'), args: [char]);
  }

  String fooUChar(String char) {
    return perform(Selector('fooUChar:'), args: [char]);
  }

  NSObject fooObject(NSObject object) {
    return perform(Selector('fooObject:'), args: [object]);
  }

  Block fooBlock(Function func) {
    Block result = perform(Selector('fooBlock:'), args: [func]);
    return result;
  }

  CGRect fooCGRect(CGRect rect) {
    return perform(Selector('fooCGRect:'), args: [rect]);
  }

  NSString fooNSString(String string) {
    NSObject result = perform(Selector('fooNSString:'), args: [string]);
    return NSString.fromPointer(result.pointer);
  }

  fooDelegate(DelegateStub delegate) {
    perform(Selector('fooDelegate:'), args: [delegate]);
  }
}
