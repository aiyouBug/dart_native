import 'dart:ffi';
import 'dart:typed_data';

import 'package:dart_objc/dart_objc.dart';
import 'package:dart_objc/runtime.dart';
import 'package:dart_objc/src/foundation/native_struct.dart';
import 'package:dart_objc/src/runtime/id.dart';
import 'package:ffi/ffi.dart';

/// return complete closure to clear memory etc.
storeValueToPointer(dynamic object, Pointer<Pointer<Void>> ptr, String encoding,
    [bool auto = true]) {
  if (object == null && encoding == 'void') {
    return;
  }
  if (object is num || object is bool || object is Box) {
    if (object is Box) {
      object = object.value;
    }
    if (object is bool) {
      // TODO: waiting for ffi bool type support.
      object = object ? 1 : 0;
    }
    switch (encoding) {
      case 'bool':
      case 'sint8':
        ptr.cast<Int8>().store(object);
        break;
      case 'sint16':
        ptr.cast<Int16>().store(object);
        break;
      case 'sint32':
        ptr.cast<Int32>().store(object);
        break;
      case 'sint64':
        ptr.cast<Int64>().store(object);
        break;
      case 'uint8':
        ptr.cast<Uint8>().store(object);
        break;
      case 'uint16':
        ptr.cast<Uint16>().store(object);
        break;
      case 'uint32':
        ptr.cast<Uint32>().store(object);
        break;
      case 'uint64':
        ptr.cast<Uint64>().store(object);
        break;
      case 'float32':
        ptr.cast<Float>().store(object);
        break;
      case 'float64':
        ptr.cast<Double>().store(object);
        break;
      default:
        throw '$object not match type $encoding!';
    }
  } else if (object is Pointer<Void> &&
      !encoding.contains('int') &&
      !encoding.contains('float')) {
    ptr.store(object);
  } else if (object is id &&
      (encoding == 'object' ||
          encoding == 'class' ||
          encoding == 'block' ||
          encoding == 'ptr')) {
    ptr.store(object.pointer);
  } else if (object is Selector &&
      (encoding == 'selector' || encoding == 'ptr')) {
    ptr.store(object.toPointer());
  } else if (object is Block &&
      (encoding == 'block' || encoding == 'ptr' || encoding == 'object')) {
    ptr.store(object.pointer);
  } else if (object is Function &&
      (encoding == 'block' || encoding == 'ptr' || encoding == 'object')) {
    Block block = Block(object);
    ptr.store(block.pointer);
  } else if (object is String) {
    if (encoding == 'char *' || encoding == 'ptr') {
      Pointer<Utf8> charPtr = Utf8.toUtf8(object);
      NSObject('DOCharPtrWrapper')
          .autorelease()
          .perform(Selector('setCString:'), args: [charPtr]);
      ptr.cast<Pointer<Utf8>>().store(charPtr);
    } else if (encoding == 'object') {
      NSString string = NSString(object);
      ptr.store(string.pointer);
    }
  } else if (encoding == 'char *' || encoding == 'ptr') {
    if (object is Pointer<Utf8>) {
      ptr.cast<Pointer<Utf8>>().store(object);
    } else if (object is Pointer) {
      Pointer<Void> tempPtr = object.cast<Void>();
      ptr.store(tempPtr);
    }
  } else if (encoding.startsWith('{')) {
    // ptr is struct pointer
    storeStructToPointer(object, ptr);
  } else {
    throw '$object not match type $encoding!';
  }
}

dynamic loadValueFromPointer(Pointer<Void> ptr, String encoding,
    [bool auto = true]) {
  dynamic result;
  if (encoding.startsWith('{')) {
    // ptr is struct pointer
    result = loadStructFromPointer(ptr, encoding);
  } else if (encoding.contains('int') || encoding.contains('float') || encoding == 'bool') {
    ByteBuffer buffer = Int64List.fromList([ptr.address]).buffer;
    ByteData data = ByteData.view(buffer);
    switch (encoding) {
      case 'bool':
        result = data.getInt8(0) != 0;
        break;
      case 'sint8':
        result = data.getInt8(0);
        break;
      case 'sint16':
        result = data.getInt16(0, Endian.host);
        break;
      case 'sint32':
        result = data.getInt32(0, Endian.host);
        break;
      case 'sint64':
        result = data.getInt64(0, Endian.host);
        break;
      case 'uint8':
        result = data.getUint8(0);
        break;
      case 'uint16':
        result = data.getUint16(0, Endian.host);
        break;
      case 'uint32':
        result = data.getUint32(0, Endian.host);
        break;
      case 'uint64':
        result = data.getUint64(0, Endian.host);
        break;
      case 'float32':
        result = data.getFloat32(0, Endian.host);
        break;
      case 'float64':
        result = data.getFloat64(0, Endian.host);
        break;
      default:
        result = 0;
    }
  } else {
    switch (encoding) {
      case 'object':
        result = NSObject.fromPointer(ptr);
        break;
      case 'class':
        result = Class.fromPointer(ptr);
        break;
      case 'selector':
        result = Selector.fromPointer(ptr);
        break;
      case 'block':
        result = Block.fromPointer(ptr);
        break;
      case 'char *':
        if (auto) {
          Pointer<Utf8> temp = ptr.cast();
          result = Utf8.fromUtf8(temp);
        }
        break;
      case 'void':
        break;
      case 'ptr':
      default:
        result = ptr;
    }
  }

  return result;
}

storeStructToPointer(dynamic object, Pointer<Pointer<Void>> ptr) {
  if (object is CGSize ||
      object is CGPoint ||
      object is CGVector ||
      object is CGRect ||
      object is NSRange) {
    Pointer<Void> result = object.addressOf.cast<Void>();
    ptr.store(result);
  }
}

String structNameForEncoding(String encoding) {
  int index = encoding.indexOf('=');
  if (index != -1) {
    return encoding.substring(1, index);
  }
  return null;
}

dynamic loadStructFromPointer(Pointer<Void> ptr, String encoding) {
  dynamic result;
  String structName = structNameForEncoding(encoding);
  if (structName != null) {
    // struct
    switch (structName) {
      case 'CGSize':
        result = CGSize.fromPointer(ptr);
        break;
      case 'CGPoint':
        result = CGPoint.fromPointer(ptr);
        break;
      case 'CGVector':
        result = CGVector.fromPointer(ptr);
        break;
      case 'CGRect':
        result = CGRect.fromPointer(ptr);
        break;
      case 'NSRange':
        result = NSRange.fromPointer(ptr);
        break;
      default:
    }
  }
  return result;
}
