import 'package:hashlib/hashlib.dart' as hashlib;
import 'package:hashlib/random.dart' as hashlib;

abstract final class UniqueStringGenerator {
  const UniqueStringGenerator._();

  static String hashcode() => hashlib.xxh32sum(hashlib.uuid.v4());

  static String uuid() => hashlib.uuid.v4();
}
