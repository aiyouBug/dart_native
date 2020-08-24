import 'dart:ffi';

import 'package:dart_native/dart_native.dart';

class ConstructorTest extends JObject {

  ConstructorTest.alongXAxis([Pointer ptr]) : this("", 0, 0, false);

  ConstructorTest(String s, int i, int b, bool bo, [Pointer ptr]): super("com/dartnative/dart_native_example/ConstructorTest", ptr, [s, i, byte(b), bo]);

}
