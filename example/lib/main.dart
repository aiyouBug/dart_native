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

    stub.fooDelegate(delegate);
    Block block = stub.fooBlock(testFunc);
    int result = block.invoke([stub]);
    print(result);
    block.release();
    CGRect rect = stub.fooCGRect(CGRect.allocate(4, 3, 2, 1));
    print(rect);
    rect.free();
    stub.release();
  }

  Function testFunc = (NSObject a) {
    print('hello block! ${a.toString()}');
    return 101;
  };

  Future<void> press() async {
    
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
