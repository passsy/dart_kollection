import "package:kt_dart/collection.dart";
import 'package:kt_dart/src/util/arguments.dart';
import "package:test/test.dart";

import "../test/assert_dart.dart";

void main() {
  group("KtList", () {
    group("list", () {
      testList(emptyList, listOf, listFrom, mutable: false);
      // ignore: prefer_const_constructors
      testList(<T>() => KtList<T>.empty(), listOf, listFrom, mutable: false);
    });
    group("mutableList", () {
      testList(mutableListOf, mutableListOf, mutableListFrom);
      testList(<T>() => KtMutableList.empty(), mutableListOf, mutableListFrom);
    });
    group("CastKtList", () {
      testList(
        <T>() => KtList<T>.empty().cast(),
        <T>(
                [dynamic arg0,
                dynamic arg1,
                dynamic arg2,
                dynamic arg3,
                dynamic arg4,
                dynamic arg5,
                dynamic arg6,
                dynamic arg7,
                dynamic arg8,
                dynamic arg9]) =>
            KtList<dynamic>.of(
                    arg0 as T? ?? defaultArgument,
                    arg1 as T? ?? defaultArgument,
                    arg2 as T? ?? defaultArgument,
                    arg3 as T? ?? defaultArgument,
                    arg4 as T? ?? defaultArgument,
                    arg5 as T? ?? defaultArgument,
                    arg6 as T? ?? defaultArgument,
                    arg7 as T? ?? defaultArgument,
                    arg8 as T? ?? defaultArgument,
                    arg9 as T? ?? defaultArgument)
                .cast(),
        <T>([Iterable<T> iterable = const []]) =>
            KtList<T>.from(iterable).cast(),
        mutable: false,
      );
    });
  });

  group("KtList.of constructor", () {
    test("creates correct size", () {
      final list = KtList.of("1", "2", "3");
      expect(list.size, 3);
    });
    test("creates empty", () {
      final list = KtList<String>.of();
      expect(list.isEmpty(), isTrue);
      expect(list.size, 0);
      expect(list, emptyList<String>());
    });
    test("allows null", () {
      final list = KtList.of("1", null, "3");
      expect(list.size, 3);
      expect(list.dart, ["1", null, "3"]);
      expect(list, KtList.from(["1", null, "3"]));
    });
    test("only null is fine", () {
      // ignore: avoid_redundant_argument_values
      final list = KtList<String?>.of(null);
      expect(list.size, 1);
      expect(list.dart, [null]);
      expect(list, KtList.from([null]));
    });
  });
}

void testList(
    KtList<T> Function<T>() emptyList,
    KtList<T> Function<T>(
            [T arg0,
            T arg1,
            T arg2,
            T arg3,
            T arg4,
            T arg5,
            T arg6,
            T arg7,
            T arg8,
            T arg9])
        listOf,
    KtList<T> Function<T>([Iterable<T> iterable]) listFrom,
    {bool mutable = true}) {
  group("basic methods", () {
    test("has no elements", () {
      final list = listOf();
      expect(list.size, equals(0));
    });

    test("contains nothing", () {
      final list = listOf<String?>("a", "b", "c");
      expect(list.contains("a"), isTrue);
      expect(list.contains("b"), isTrue);
      expect(list.contains("c"), isTrue);
      expect(list.contains(null), isFalse);
      expect(list.contains(""), isFalse);
      expect(list.contains(null), isFalse);
    });

    test('containsAll', () {
      final list = listOf<String?>("a", "b", "c");
      expect(list.containsAll(listOf("a", "b")), isTrue);
      expect(list.containsAll(listOf("a", "c")), isTrue);
      expect(list.containsAll(listOf()), isTrue);
      expect(list.containsAll(listOf("x")), isFalse);
      expect(list.containsAll(listOf("a", "x")), isFalse);
    });

    test("iterator with 1 element has 1 next", () {
      final list = listOf("a");
      final iterator = list.iterator();
      expect(iterator.hasNext(), isTrue);
      expect(iterator.next(), equals("a"));

      expect(iterator.hasNext(), isFalse);
      expect(() => iterator.next(),
          throwsA(const TypeMatcher<NoSuchElementException>()));
    });

    test("is list", () {
      final list = listOf("asdf");

      expect(list.isEmpty(), isFalse);
      expect(list.isEmpty(), isFalse);
    });

    test("get returns elements", () {
      final list = listOf("a", "b", "c");

      expect(list.get(0), equals("a"));
      expect(list.get(1), equals("b"));
      expect(list.get(2), equals("c"));
      expect(() => list.get(3),
          throwsA(const TypeMatcher<IndexOutOfBoundsException>()));
      expect(() => list.get(-1),
          throwsA(const TypeMatcher<IndexOutOfBoundsException>()));
    });

    test("[] returns elements", () {
      final list = listOf("a", "b", "c");

      expect(list[0], equals("a"));
      expect(list[1], equals("b"));
      expect(list[2], equals("c"));
      expect(() => list[3],
          throwsA(const TypeMatcher<IndexOutOfBoundsException>()));
      expect(() => list[-1],
          throwsA(const TypeMatcher<IndexOutOfBoundsException>()));
    });

    test("indexOf returns first element or -1", () {
      final list = listOf<String?>("a", "b", "c", "a");

      expect(list.indexOf(""), equals(-1));
      expect(list.indexOf("a"), equals(0));
      expect(list.indexOf("b"), equals(1));
      expect(list.indexOf("c"), equals(2));
      expect(list.indexOf("d"), equals(-1));
      expect(list.indexOf(null), equals(-1));
    });

    test("lastIndexOf returns last element or -1", () {
      final list = listOf<String?>("a", "b", "c", "a");

      expect(list.lastIndexOf(""), equals(-1));
      expect(list.lastIndexOf("a"), equals(3));
      expect(list.lastIndexOf("b"), equals(1));
      expect(list.lastIndexOf("c"), equals(2));
      expect(list.lastIndexOf("d"), equals(-1));
      expect(list.lastIndexOf(null), equals(-1));
    });

    test("is equals to another list list", () {
      final list0 = listOf("a", "b", "c");
      final list1 = listOf("a", "b", "c");
      final list2 = listOf("a", "c");

      expect(list0, equals(list1));
      expect(list0.hashCode, equals(list1.hashCode));

      expect(list0, isNot(equals(list2)));
      expect(list0.hashCode, isNot(equals(list2.hashCode)));
    });
  });

  group("reduceRight", () {
    test("reduce", () {
      final result = listOf(1, 2, 3, 4).reduceRight((it, int acc) => it + acc);
      expect(result, 10);
    });

    test("empty throws", () {
      expect(() => emptyList<int>().reduceRight((it, int acc) => it + acc),
          throwsUnsupportedError);
    });
  });

  group("reduceRightIndexed", () {
    test("reduceRightIndexed", () {
      var i = 2;
      final result =
          listOf(1, 2, 3, 4).reduceRightIndexed((index, it, int acc) {
        expect(index, i);
        i--;
        return it + acc;
      });
      expect(result, 10);
    });

    test("empty throws", () {
      expect(
          () => emptyList<int>()
              .reduceRightIndexed((index, it, int acc) => it + acc),
          throwsUnsupportedError);
    });
  });

  test("sublist works ", () {
    final list = listOf("a", "b", "c");
    final subList = list.subList(1, 3);
    expect(subList, equals(listOf("b", "c")));
  });

  test("sublist throws for illegal ranges", () {
    final list = listOf("a", "b", "c");

    expect(
        catchException<IndexOutOfBoundsException>(() => list.subList(0, 10))
            .message,
        allOf(
          contains("0"),
          contains("10"),
          contains("3"),
        ));
    expect(
        catchException<IndexOutOfBoundsException>(() => list.subList(6, 10))
            .message,
        allOf(
          contains("6"),
          contains("10"),
          contains("3"),
        ));
    expect(
        catchException<IndexOutOfBoundsException>(() => list.subList(-1, -1))
            .message,
        allOf(
          contains("-1"),
          contains("3"),
        ));
    expect(
        catchException<ArgumentError>(() => list.subList(3, 1)).message,
        allOf(
          contains("3"),
          contains("1"),
        ));
    expect(
        catchException<IndexOutOfBoundsException>(() => list.subList(2, 10))
            .message,
        allOf(
          contains("2"),
          contains("10"),
          contains("3"),
        ));
  });

  test("access dart list", () {
    // ignore: deprecated_member_use_from_same_package
    final List<String> list = listFrom<String>(["a", "b", "c"]).list;
    expect(list.length, 3);
    expect(list, equals(["a", "b", "c"]));
  });

  test("equals although differnt types (subtypes)", () {
    expect(listOf<int>(1, 2, 3), listOf<num>(1, 2, 3));
    expect(listOf<num>(1, 2, 3), listOf<int>(1, 2, 3));
  });

  test("list iterates with null value", () {
    final list = listFrom([null, "b", "c"]);
    // iterates correctly
    final iterator = list.iterator();
    expect(iterator.hasNext(), isTrue);
    expect(iterator.next(), null);
    expect(iterator.hasNext(), isTrue);
    expect(iterator.next(), "b");
    expect(iterator.hasNext(), isTrue);
    expect(iterator.next(), "c");
    expect(iterator.hasNext(), isFalse);
  });

  test("list iterates with listIterator with null value", () {
    final list = listFrom([null, "b", "c"]);
    // iterates correctly
    final iterator = list.listIterator();
    expect(iterator.hasNext(), isTrue);
    expect(iterator.next(), null);
    expect(iterator.hasNext(), isTrue);
    expect(iterator.next(), "b");
    expect(iterator.hasNext(), isTrue);
    expect(iterator.next(), "c");
    expect(iterator.hasNext(), isFalse);
  });

  test("list allows null as parameter", () {
    final stringList = listFrom([null, "b", "c"]);
    expect(stringList.first(), null);
    expect(stringList.reversed().last(), null);
    expect(stringList.contains(null), isTrue);
    expect(stringList.indexOf(null), 0);
    expect(stringList.lastIndexOf(null), 0);
    expect(stringList.indexOfFirst((it) => it == null), 0);
    expect(stringList.elementAtOrElse(0, (_) => "a"), null);
  });

  if (mutable) {
    test("emptyList, asList allows mutation - empty", () {
      final ktList = emptyList<String>();
      expect(ktList.isEmpty(), isTrue);
      final dartList = ktList.asList();
      dartList.add("asdf");
      expect(dartList.length, 1);
      expect(ktList.size, 1);
    });

    test("empty mutable list, asList allows mutation", () {
      final ktList = listOf<String>();
      expect(ktList.isEmpty(), isTrue);
      final dartList = ktList.asList();
      dartList.add("asdf");
      expect(dartList.length, 1);
      expect(ktList.size, 1);
    });

    test("mutable list, asList allows mutation", () {
      final ktList = listOf("a");
      final dartList = ktList.asList();
      dartList.add("asdf");
      expect(dartList.length, 2);
      expect(ktList.size, 2);
    });
  } else {
    test("emptyList, asList doesn't allow mutation", () {
      final ktList = emptyList();
      expect(ktList.isEmpty(), isTrue);
      final e =
          catchException<UnsupportedError>(() => ktList.asList().add("asdf"));
      expect(e.message, contains("unmodifiable"));
    });

    test("empty list, asList doesn't allows mutation", () {
      final ktList = listOf<String>();
      expect(ktList.isEmpty(), isTrue);
      final e =
          catchException<UnsupportedError>(() => ktList.asList().add("asdf"));
      expect(e.message, contains("unmodifiable"));
    });

    test("list, asList doesn't allows mutation", () {
      final ktList = listOf<String>("a");
      final e =
          catchException<UnsupportedError>(() => ktList.asList().add("asdf"));
      expect(e.message, contains("unmodifiable"));
    });
  }

  group("last", () {
    test("get last element", () {
      expect(listOf("a", "b").last(), "b");
    });

    test("last throws for no elements", () {
      expect(() => emptyList().last(),
          throwsA(const TypeMatcher<NoSuchElementException>()));
    });

    test("finds nothing throws", () {
      expect(() => listOf<String>("a", "b", "c").last((it) => it == "x"),
          throwsA(const TypeMatcher<NoSuchElementException>()));
    });

    test("finds nothing in empty throws", () {
      expect(() => emptyList().last((it) => it == "x"),
          throwsA(const TypeMatcher<NoSuchElementException>()));
    });

    test("returns null when null is the last element", () {
      expect(listFrom([1, 2, null]).last(), null);
      expect(listFrom([1, null, 2]).last(), 2);
    });
  });
}
