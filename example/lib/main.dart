import 'package:dart_objc_example/delegatestub.dart';
import 'package:dart_objc_example/runtimestub.dart';
import 'package:flutter/material.dart';
import 'package:dart_objc/dart_objc.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  RuntimeStub stub = RuntimeStub();
  DelegateStub delegate = DelegateStub();
  Block block;

  @override
  void initState() {
    super.initState();

    int int8 = 0;
    int start = DateTime.now().millisecondsSinceEpoch;
    for (var i = 0; i < 100000; i++) {
      int8 = stub.fooInt8();
    }
    int duration = DateTime.now().millisecondsSinceEpoch - start;
    print('duration:$duration, selectorDuration:${stub.selectorDuration}');
    print(
        'message duration1:$msg_duration1, duration2:$msg_duration2, duration3:$msg_duration3, duration4:$msg_duration4, duration5:$msg_duration5');
    // stub.fooDelegate(delegate);
    // Block block = stub.fooBlock(testFunc);
    // int result = block.invoke([stub]);
    // print(result);
    // block.release();
    // CGRect rect = stub.fooCGRect(CGRect.allocate(4, 3, 2, 1));
    // print(rect);
    // rect.free();
    // stub.release();
  }

  Function testFunc = (NSObject a) {
    print('hello block! ${a.toString()}');
    return 101;
  };

  Future<void> press() async {
    delegate.release();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: MaterialButton(
              child: Text('dialog'),
              onPressed: () {
                press();
              }),
        ),
      ),
    );
  }
}
