import 'dart:ffi';
import 'package:dart_native/src/android/runtime/functions.dart';
import 'package:dart_native/src/android/common/pointer_encoding.dart';
import 'package:ffi/ffi.dart';

import 'JObjectPool.dart';
import 'class.dart';

class JObject extends Class{
  Pointer _ptr;

  //init target class
  JObject(String className, Pointer ptr, [List args]) : super(className) {
    ArgumentPointers pointers = argsToPointers(args);
    _ptr = ptr == null ? nativeCreateClass(super.classUtf8(), pointers.argPointers, pointers.typePointers) : ptr;
    JObjectPool.sInstance.retain(this);
  }

  Pointer get pointer {
    return _ptr;
  }

  dynamic invoke(String methodName, List args, [String returnType]) {
    Pointer<Utf8> methodNamePtr = Utf8.toUtf8(methodName);
    Pointer<Utf8> returnTypePtr = Utf8.toUtf8(returnType);

    ArgumentPointers pointers = argsToPointers(args);
    Pointer<Void> invokeMethodRet =
        nativeInvokeNeo(_ptr, methodNamePtr, pointers.argPointers, pointers.typePointers, returnTypePtr);
    dynamic result = loadValueFromPointer(invokeMethodRet, returnType);
    if (pointers != null) {
      free(pointers.argPointers);
      free(pointers.typePointers);
    }
    return result;
  }

  ArgumentPointers argsToPointers(List args) {
    int argLength = args?.length ?? 0;
    Pointer<Pointer<Void>> argPointers = allocate<Pointer<Void>>(count: argLength + 1);
    Pointer<Pointer<Utf8>> typePointers = allocate<Pointer<Utf8>>(count: argLength + 1);
    if (args != null) {
      for (var i = 0; i < args.length; i++) {
        var arg = args[i];
        storeValueToPointer(arg, argPointers.elementAt(i), typePointers.elementAt(i));
      }
    }
    argPointers.elementAt(argLength).value = nullptr;
    typePointers.elementAt(argLength).value = nullptr;
    return ArgumentPointers(argPointers, typePointers);
  }

  release() {
    if (JObjectPool.sInstance.release(this)) {
      nativeReleaseClass(_ptr);
    }
  }

  @override
  int compareTo(other) {
    if (other is JObject && other._ptr == _ptr) {
      return 0;
    }
    return 1;
  }
}

class ArgumentPointers {
  Pointer<Pointer<Void>> argPointers;
  Pointer<Pointer<Utf8>> typePointers;

  ArgumentPointers(this.argPointers, this.typePointers);
}
