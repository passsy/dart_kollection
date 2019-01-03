import 'package:dart_kollection/dart_kollection.dart';
import 'package:dart_kollection/src/collection/iterable.dart';
import 'package:test/test.dart';

import '../test/assert_dart.dart';

void main() {
  group("iterable", () {
    testIterable(<T>() => EmptyIterable<T>(),
        <T>(Iterable<T> iterable) => DartIterable(iterable));
  });
  group("list", () {
    testIterable(<T>() => emptyList<T>(),
        <T>(Iterable<T> iterable) => listFrom(iterable));
  });
  group("mutableList", () {
    testIterable(<T>() => emptyList<T>(),
        <T>(Iterable<T> iterable) => mutableListFrom(iterable));
  });
  group("set", () {
    testIterable(
        <T>() => emptySet<T>(), <T>(Iterable<T> iterable) => setOf(iterable));
  });
  group("hashset", () {
    testIterable(<T>() => emptySet<T>(),
        <T>(Iterable<T> iterable) => hashSetOf(iterable),
        ordered: false);
  });
  group("linkedSet", () {
    testIterable(<T>() => emptySet<T>(),
        <T>(Iterable<T> iterable) => linkedSetOf(iterable));
  });
}

void testIterable(KIterable<T> Function<T>() emptyIterable,
    KIterable<T> Function<T>(Iterable<T> iterable) iterableOf,
    {bool ordered = true}) {
  group('all', () {
    test("matches all", () {
      final iterable = iterableOf(["abc", "bcd", "cde"]);
      expect(iterable.all((e) => e.contains("c")), isTrue);
    });
    test("matches none", () {
      final iterable = iterableOf(["abc", "bcd", "cde"]);
      expect(iterable.all((e) => e.contains("x")), isFalse);
    });
    test("matches one", () {
      final iterable = iterableOf(["abc", "bcd", "cde"]);
      expect(iterable.all((e) => e.contains("a")), isFalse);
    });
    test("predicate can't be null", () {
      final iterable = iterableOf(["abc", "bcd", "cde"]);
      final e = catchException<ArgumentError>(() => iterable.all(null));
      expect(e.message, allOf(contains("null")));
    });
  });

  group('any', () {
    test("matches single", () {
      final iterable = iterableOf(["abc", "bcd", "cde"]);
      expect(iterable.any((e) => e.contains("a")), isTrue);
    });
    test("matches all", () {
      final iterable = iterableOf(["abc", "bcd", "cde"]);
      expect(iterable.any((e) => e.contains("c")), isTrue);
    });
    test("is false when none matches", () {
      final iterable = iterableOf(["abc", "bcd", "cde"]);
      expect(iterable.any((e) => e.contains("x")), isFalse);
    });
    test("any without args returns true with items", () {
      final iterable = iterableOf(["abc", "bcd", "cde"]);
      expect(iterable.any(), isTrue);
    });
    test("any without args returns false for no items", () {
      final iterable = emptyIterable();
      expect(iterable.any(), isFalse);
    });
  });

  group('associate', () {
    test("associate", () {
      final list = iterableOf(["a", "b", "c"]);
      var result = list.associate((it) => KPair(it.toUpperCase(), it));
      var expected = mapOf({"A": "a", "B": "b", "C": "c"});
      expect(result, equals(expected));
    });
    test("associate on empty map", () {
      final list = emptyIterable<String>();
      var result = list.associate((it) => KPair(it.toUpperCase(), it));
      expect(result, equals(emptyMap()));
    });
    test("associate doesn't allow null as transform function", () {
      final list = emptyIterable<String>();
      var e = catchException<ArgumentError>(() => list.associate(null));
      expect(e.message, allOf(contains("null"), contains("transform")));
    });
  });

  group('associateBy', () {
    test("associateBy", () {
      final list = iterableOf(["a", "b", "c"]);
      var result = list.associateBy((it) => it.toUpperCase());
      var expected = mapOf({"A": "a", "B": "b", "C": "c"});
      expect(result, equals(expected));
    });
    test("associateBy on empty map", () {
      final list = emptyList<String>();
      var result = list.associateWith((it) => it.toUpperCase());
      expect(result, equals(emptyMap()));
    });
    test("when conflicting keys, use last ", () {
      final list = iterableOf(["a", "b", "c"]);
      var result = list.associateBy((it) => it.length);
      expect(result.size, equals(1));
      expect(result.containsKey(1), isTrue);
    });

    test("associateBy doesn't allow null as keySelector", () {
      final list = emptyIterable<String>();
      var e = catchException<ArgumentError>(() => list.associateBy(null));
      expect(e.message, allOf(contains("null"), contains("keySelector")));
    });
  });

  group('associateByTo', () {
    test("associateByTo doesn't allow null destination", () {
      final list = iterableOf(["a", "b", "c"]);
      var e = catchException<ArgumentError>(
          () => list.associateByTo(null, (it) => it));
      expect(e.message, allOf(contains("null"), contains("destination")));
    });
  });

  group('associateByTransform', () {
    test("associateByTransform", () {
      final list = iterableOf(["a", "bb", "ccc"]);
      var result = list.associateByTransform(
          (it) => it.length, (it) => it.toUpperCase());
      var expected = mapOf({1: "A", 2: "BB", 3: "CCC"});
      expect(result, equals(expected));
    });
    test("associateByTransform on empty map", () {
      final list = emptyList<String>();
      var result = list.associateWith((it) => it.toUpperCase());
      expect(result, equals(emptyMap()));
    });
    test("associateByTransform doesn't allow null as keySelector", () {
      final list = emptyIterable<String>();
      var e = catchException<ArgumentError>(
          () => list.associateByTransform(null, (it) => it));
      expect(e.message, allOf(contains("null"), contains("keySelector")));
    });
  });

  group('associateWith', () {
    test("associateWith", () {
      final iterable = iterableOf(["a", "b", "c"]);
      var result = iterable.associateWith((it) => it.toUpperCase());
      var expected = mapOf({"a": "A", "b": "B", "c": "C"});
      expect(result, equals(expected));
    });
    test("associateWith on empty map", () {
      final iterable = emptyIterable<String>();
      var result = iterable.associateWith((it) => it.toUpperCase());
      expect(result, equals(emptyMap()));
    });
    test("associateWith doesn't allow null as valueSelector", () {
      final list = emptyIterable<String>();
      var e = catchException<ArgumentError>(() => list.associateWith(null));
      expect(e.message, allOf(contains("null"), contains("valueSelector")));
    });
  });

  group('average', () {
    test("average of ints", () {
      final ints = iterableOf([1, 2, 3, 4]);
      var result = ints.averageBy((it) => it);
      expect(result, equals(2.5));
    });
    test("average of empty is NaN", () {
      final ints = emptyIterable<num>();
      var result = ints.averageBy((it) => it);
      expect(identical(result, double.nan), isTrue);
    });
    test("average of nums", () {
      final ints = iterableOf([1, 2.0, 3, 4]);
      var result = ints.averageBy((it) => it);
      expect(result, equals(2.5));
    });
    test("averageBy doesn't allow null as selector", () {
      final list = emptyIterable<String>();
      var e = catchException<ArgumentError>(() => list.averageBy(null));
      expect(e.message, allOf(contains("null"), contains("selector")));
    });
  });

  group("distinct", () {
    if (ordered) {
      test("distinct elements", () {
        final iterable = iterableOf(["a", "b", "c", "b"]);
        expect(iterable.distinct(), equals(listOf("a", "b", "c")));
      });
      test("distinct by ordered", () {
        final iterable = iterableOf(["paul", "peter", "john", "lisa"]);
        expect(iterable.distinctBy((it) => it.length),
            equals(listOf("paul", "peter")));
      });
    } else {
      test("distinct elements", () {
        final iterable = iterableOf(["a", "b", "c", "b"]);
        expect(iterable.distinct().toSet(), equals(setOf(["a", "b", "c"])));
      });

      test("distinct by unordered", () {
        final iterable = iterableOf(["paul", "peter", "john", "lisa"]);
        var distinct = iterable.distinctBy((it) => it.length);
        expect(distinct.contains("peter"), true);
        expect(
            distinct.contains("paul") ||
                distinct.contains("john") ||
                distinct.contains("lisa"),
            true);
      });
    }

    test("distinctBy doesn't allow null as selector", () {
      final list = emptyIterable<String>();
      var e = catchException<ArgumentError>(() => list.distinctBy(null));
      expect(e.message, allOf(contains("null"), contains("selector")));
    });
  });

  group("count", () {
    test("count elements", () {
      expect(iterableOf([1, 2, 3, 4, 5]).count(), 5);
    });

    test("count even", () {
      expect(iterableOf([1, 2, 3, 4, 5]).count((it) => it % 2 == 0), 2);
    });
  });

  group("chunked", () {
    test("chunk", () {
      final chunks = iterableOf([1, 2, 3, 4, 5]).chunked(3);
      expect(chunks, listOf(listOf(1, 2, 3), listOf(4, 5)));
    });

    test("chunked doesn't allow null as size", () {
      final list = emptyIterable<String>();
      var e = catchException<ArgumentError>(() => list.chunked(null));
      expect(e.message, allOf(contains("null"), contains("size")));
    });

    test("chunkedTransform", () {
      final chunks =
          iterableOf([1, 2, 3, 4, 5]).chunkedTransform(3, (it) => it.sum());
      expect(chunks, listOf(6, 9));
    });

    test("chunkedTransform doesn't allow null as size", () {
      final list = emptyIterable<String>();
      var e = catchException<ArgumentError>(
          () => list.chunkedTransform(null, (it) => it));
      expect(e.message, allOf(contains("null"), contains("size")));
    });

    test("chunkedTransform doesn't allow null as transform function", () {
      final list = emptyIterable<String>();
      var e =
          catchException<ArgumentError>(() => list.chunkedTransform(3, null));
      expect(e.message, allOf(contains("null"), contains("transform")));
    });
  });

  group("drop", () {
    if (ordered) {
      test("drop first value ordered", () {
        final iterable = iterableOf(["a", "b", "c"]);
        expect(iterable.drop(1), equals(listOf("b", "c")));
      });
    } else {
      test("drop on iterable returns a iterable", () {
        final iterable = emptyIterable<int>();
        expect(iterable.drop(1), TypeMatcher<KList<int>>());
      });
    }
    test("drop empty does nothing", () {
      final iterable = emptyIterable<int>();
      expect(iterable.drop(1).toList(), equals(emptyList<int>()));
    });
    test("drop on iterable returns a iterable", () {
      final iterable = emptyIterable<int>();
      expect(iterable.drop(1), TypeMatcher<KList<int>>());
    });

    test("drop negative, drops nothing", () {
      final iterable = iterableOf(["a", "b", "c"]);
      expect(iterable.drop(-10).toList(), iterable.toList());
    });

    test("drop doesn't allow null as size", () {
      final list = emptyIterable<String>();
      var e = catchException<ArgumentError>(() => list.drop(null));
      expect(e.message, allOf(contains("null"), contains("n")));
    });
  });

  group("dropWhile", () {
    if (ordered) {
      test("dropWhile two", () {
        final iterable = iterableOf(["a", "b", "c"]);
        expect(iterable.dropWhile((it) => it != "c"), equals(listOf("c")));
      });
      test("dropWhile one", () {
        final iterable = iterableOf(["a", "b", "c"]);
        expect(iterable.dropWhile((it) => it != "b"), equals(listOf("b", "c")));
      });
    } else {
      test("dropWhile first value unordered", () {
        final iterable = iterableOf(["a", "b", "c"]);
        int i = 0;
        expect(iterable.dropWhile((_) => ++i <= 2).size, 1);
      });
    }
    test("dropWhile empty does nothing", () {
      final iterable = emptyIterable<int>();
      expect(
          iterable.dropWhile((_) => false).toList(), equals(emptyList<int>()));
    });
    test("dropWhile all makes an empty list", () {
      final iterable = iterableOf(["a", "b", "c"]);
      expect(
          iterable.dropWhile((_) => true).toList(), equals(emptyList<int>()));
    });
    test("dropWhile on iterable returns a iterable", () {
      final iterable = emptyIterable<int>();
      expect(iterable.dropWhile((_) => false), TypeMatcher<KList<int>>());
    });
    test("dropWhile doesn't allow null as predicate", () {
      final list = emptyIterable<String>();
      var e = catchException<ArgumentError>(() => list.dropWhile(null));
      expect(e.message, allOf(contains("null"), contains("predicate")));
    });
  });

  group("elementAt", () {
    if (ordered) {
      test("returns correct elements", () {
        final iterable = iterableOf(["a", "b", "c"]);
        expect(iterable.elementAt(0), equals("a"));
        expect(iterable.elementAt(1), equals("b"));
        expect(iterable.elementAt(2), equals("c"));
      });
    } else {
      test("returns all elements", () {
        final iterable = iterableOf(["a", "b", "c"]);
        final set = setOf([
          iterable.elementAt(0),
          iterable.elementAt(1),
          iterable.elementAt(2)
        ]);
        expect(set.containsAll(iterable.toSet()), isTrue);
      });
    }

    test("throws out of bounds exceptions", () {
      final iterable = iterableOf(["a", "b", "c"]);
      final eOver = catchException<IndexOutOfBoundsException>(
          () => iterable.elementAt(3));
      expect(eOver.message, allOf(contains("index"), contains("3")));

      final eUnder = catchException<IndexOutOfBoundsException>(
          () => iterable.elementAt(-1));
      expect(eUnder.message, allOf(contains("index"), contains("-1")));
    });

    test("null is not a valid index", () {
      final iterable = iterableOf(["a", "b", "c"]);
      final e = catchException<ArgumentError>(() => iterable.elementAt(null));
      expect(e.message, allOf(contains("index"), contains("null")));
    });
  });

  group("elementAtOrElse", () {
    if (ordered) {
      test("returns correct elements", () {
        final iterable = iterableOf(["a", "b", "c"]);
        expect(iterable.elementAtOrElse(0, (i) => "x"), equals("a"));
        expect(iterable.elementAtOrElse(1, (i) => "x"), equals("b"));
        expect(iterable.elementAtOrElse(2, (i) => "x"), equals("c"));
      });
    } else {
      test("returns all elements", () {
        final iterable = iterableOf(["a", "b", "c"]);
        final set = setOf([
          iterable.elementAtOrElse(0, (i) => "x"),
          iterable.elementAtOrElse(1, (i) => "x"),
          iterable.elementAtOrElse(2, (i) => "x")
        ]);
        expect(set.containsAll(iterable.toSet()), isTrue);
      });
    }

    test("returns else case", () {
      final iterable = iterableOf(["a", "b", "c"]);
      expect(iterable.elementAtOrElse(-1, (i) => "x"), equals("x"));
    });

    test("returns else case based on index", () {
      final iterable = iterableOf(["a", "b", "c"]);
      expect(iterable.elementAtOrElse(-1, (i) => "$i"), equals("-1"));
      expect(iterable.elementAtOrElse(10, (i) => "$i"), equals("10"));
    });

    test("null is not a valid index", () {
      final iterable = iterableOf(["a", "b", "c"]);
      final e = catchException<ArgumentError>(
          () => iterable.elementAtOrElse(null, (i) => "x"));
      expect(e.message, allOf(contains("index"), contains("null")));
    });

    test("null is not a function", () {
      final iterable = iterableOf(["a", "b", "c"]);
      final e = catchException<ArgumentError>(
          () => iterable.elementAtOrElse(1, null));
      expect(e.message, allOf(contains("defaultValue"), contains("null")));
    });
  });

  group("elementAtOrNull", () {
    if (ordered) {
      test("returns correct elements", () {
        final iterable = iterableOf(["a", "b", "c"]);
        expect(iterable.elementAtOrNull(0), equals("a"));
        expect(iterable.elementAtOrNull(1), equals("b"));
        expect(iterable.elementAtOrNull(2), equals("c"));
      });
    } else {
      test("returns all elements", () {
        final iterable = iterableOf(["a", "b", "c"]);
        final set = setOf([
          iterable.elementAtOrNull(0),
          iterable.elementAtOrNull(1),
          iterable.elementAtOrNull(2)
        ]);
        expect(set.containsAll(iterable.toSet()), isTrue);
      });
    }

    test("returns null when out of range", () {
      final iterable = iterableOf(["a", "b", "c"]);
      expect(iterable.elementAtOrNull(-1), isNull);
      expect(iterable.elementAtOrNull(10), isNull);
    });

    test("null is not a valid index", () {
      final iterable = iterableOf(["a", "b", "c"]);
      final e =
          catchException<ArgumentError>(() => iterable.elementAtOrNull(null));
      expect(e.message, allOf(contains("index"), contains("null")));
    });
  });

  group("filter", () {
    test("filter", () {
      final iterable = iterableOf(["paul", "peter", "john", "lisa"]);
      expect(iterable.filter((it) => it.contains("a")).toSet(),
          equals(setOf(["paul", "lisa"])));
    });

    test("filter doesn't allow null as predicate", () {
      final list = emptyIterable<String>();
      var e = catchException<ArgumentError>(() => list.filter(null));
      expect(e.message, allOf(contains("null"), contains("predicate")));
    });
  });

  group("filterIndexed", () {
    test("filterIndexed", () {
      final iterable = iterableOf(["paul", "peter", "john", "lisa"]);
      var i = 0;
      expect(
          iterable.filterIndexed((index, it) {
            expect(index, i);
            i++;
            return it.contains("a");
          }).toSet(),
          equals(setOf(["paul", "lisa"])));
    });

    test("filterIndexed doesn't allow null as predicate", () {
      final list = emptyIterable<String>();
      var e = catchException<ArgumentError>(() => list.filterIndexed(null));
      expect(e.message, allOf(contains("null"), contains("predicate")));
    });
  });

  group("filterNot", () {
    test("filterNot", () {
      final iterable = iterableOf(["paul", "peter", "john", "lisa"]);
      expect(iterable.filterNot((it) => it.contains("a")).toSet(),
          equals(setOf(["peter", "john"])));
    });

    test("filterNot doesn't allow null as predicate", () {
      final list = emptyIterable<String>();
      var e = catchException<ArgumentError>(() => list.filterNot(null));
      expect(e.message, allOf(contains("null"), contains("predicate")));
    });
  });

  group("filterNotNull", () {
    test("filterNotNull", () {
      final iterable = iterableOf(["paul", null, "john", "lisa"]);
      expect(iterable.filterNotNull().toSet(),
          equals(setOf(["paul", "john", "lisa"])));
    });
  });

  group("filterIsInstance", () {
    test("filterIsInstance", () {
      final iterable = iterableOf<Object>(["paul", null, "john", 1, "lisa"]);
      expect(iterable.filterIsInstance<String>().toSet(),
          equals(setOf(["paul", "john", "lisa"])));
    });
  });

  group("find", () {
    test("find item", () {
      var iterable = iterableOf(["paul", "john", "max", "lisa"]);
      var result = iterable.find((it) => it.contains("l"));

      if (ordered) {
        expect(result, "paul");
      } else {
        expect(result, anyOf("paul", "lisa"));
      }
    });

    test("find predicate can't be null", () {
      final iterable = iterableOf([1, 2, 3]);
      var e = catchException<ArgumentError>(() => iterable.find(null));
      expect(e.message, allOf(contains("null"), contains("predicate")));
    });
  });

  group("findLast", () {
    test("findLast item", () {
      var iterable = iterableOf(["paul", "john", "max", "lisa"]);
      var result = iterable.findLast((it) => it.contains("l"));
      if (ordered) {
        expect(result, "lisa");
      } else {
        expect(result, anyOf("paul", "lisa"));
      }
    });

    test("find predicate can't be null", () {
      final iterable = iterableOf([1, 2, 3]);
      var e = catchException<ArgumentError>(() => iterable.findLast(null));
      expect(e.message, allOf(contains("null"), contains("predicate")));
    });
  });

  group("first", () {
    if (ordered) {
      test("get first element", () {
        expect(iterableOf(["a", "b"]).first(), "a");
      });
    } else {
      test("get random first element", () {
        var result = iterableOf(["a", "b"]).first();
        expect(result == "a" || result == "b", true);
      });
    }

    test("first throws for no elements", () {
      expect(() => emptyIterable().first(),
          throwsA(TypeMatcher<NoSuchElementException>()));
    });

    test("finds nothing throws", () {
      expect(() => iterableOf<String>(["a"]).first((it) => it == "b"),
          throwsA(TypeMatcher<NoSuchElementException>()));
    });
  });

  group("firstOrNull", () {
    if (ordered) {
      test("get first element", () {
        expect(iterableOf(["a", "b"]).firstOrNull(), "a");
      });
    } else {
      test("get random first element", () {
        var result = iterableOf(["a", "b"]).firstOrNull();
        expect(result == "a" || result == "b", true);
      });
    }

    test("firstOrNull returns null for empty", () {
      expect(emptyIterable().firstOrNull(), isNull);
    });

    test("finds nothing throws", () {
      expect(iterableOf<String>(["a"]).firstOrNull((it) => it == "b"), isNull);
    });
  });

  group("flatMap", () {
    test("flatMap int to string", () {
      final iterable = iterableOf([1, 2, 3]);
      expect(
          iterable.flatMap((it) => iterableOf([it, it + 1, it + 2])).toList(),
          listOf(1, 2, 3, 2, 3, 4, 3, 4, 5));
    });

    test("flatMap doesn't allow null as tranform function", () {
      final iterable = iterableOf([1, 2, 3]);
      var e = catchException<ArgumentError>(() => iterable.flatMap(null));
      expect(e.message, allOf(contains("null"), contains("transform")));
    });

    test("flatMapTo doesn't allow null as destination", () {
      final iterable = iterableOf([1, 2, 3]);
      var e = catchException<ArgumentError>(
          () => iterable.flatMapTo(null, (_) => emptyIterable()));
      expect(e.message, allOf(contains("null"), contains("destination")));
    });
  });

  group("fold", () {
    if (ordered) {
      test("fold division", () {
        final iterable = iterableOf([
          [1, 2],
          [3, 4],
          [5, 6]
        ]);
        final result = iterable.fold(
            listFrom<int>(), (KList<int> acc, it) => acc + listFrom(it));
        expect(result, listOf(1, 2, 3, 4, 5, 6));
      });
    }

    test("operation must be non null", () {
      final e = catchException<ArgumentError>(
          () => emptyIterable().fold("foo", null));
      expect(e.message, allOf(contains("null"), contains("operation")));
    });
  });

  group("foldIndexed", () {
    if (ordered) {
      test("foldIndexed division", () {
        final iterable = iterableOf([
          [1, 2],
          [3, 4],
          [5, 6]
        ]);
        var i = 0;
        final result =
            iterable.foldIndexed(listFrom<int>(), (index, KList<int> acc, it) {
          expect(index, i);
          i++;
          return acc + listFrom(it);
        });
        expect(result, listOf(1, 2, 3, 4, 5, 6));
      });
    }

    test("operation must be non null", () {
      final e = catchException<ArgumentError>(
          () => emptyIterable().foldIndexed("foo", null));
      expect(e.message, allOf(contains("null"), contains("operation")));
    });
  });

  group("forEach", () {
    test("forEach", () {
      final result = mutableListOf<String>();
      var iterable = iterableOf(["a", "b", "c", "d"]);
      iterable.forEach((it) {
        result.add(it);
      });
      if (ordered) {
        expect(result, listOf("a", "b", "c", "d"));
      } else {
        expect(result.size, 4);
        expect(result.toSet(), iterable.toSet());
      }
    });

    test("action must be non null", () {
      final e =
          catchException<ArgumentError>(() => emptyIterable().forEach(null));
      expect(e.message, allOf(contains("null"), contains("action")));
    });
  });

  group("forEachIndexed", () {
    test("forEachIndexed", () {
      final result = mutableListOf<String>();
      var iterable = iterableOf(["a", "b", "c", "d"]);
      iterable.forEachIndexed((index, it) {
        result.add("$index$it");
      });
      if (ordered) {
        expect(result, listOf("0a", "1b", "2c", "3d"));
      } else {
        expect(result.size, 4);
        expect(result.toSet(),
            iterable.mapIndexed((index, it) => "$index$it").toSet());
      }
    });

    test("action must be non null", () {
      final e = catchException<ArgumentError>(
          () => emptyIterable().forEachIndexed(null));
      expect(e.message, allOf(contains("null"), contains("action")));
    });
  });

  group("groupBy", () {
    if (ordered) {
      test("basic", () {
        final iterable = iterableOf(["paul", "peter", "john", "lisa"]);
        expect(
            iterable.groupBy((it) => it.length),
            equals(mapOf({
              4: listOf("paul", "john", "lisa"),
              5: listOf("peter"),
            })));
      });

      test("valuetransform", () {
        final iterable = iterableOf(["paul", "peter", "john", "lisa"]);
        expect(
            iterable.groupByTransform(
                (it) => it.length, (it) => it.toUpperCase()),
            equals(mapOf({
              4: listOf("PAUL", "JOHN", "LISA"),
              5: listOf("PETER"),
            })));
      });
    } else {
      test("basic", () {
        final iterable = iterableOf(["paul", "peter", "john", "lisa"]);
        expect(
            iterable
                .groupBy((it) => it.length)
                .mapValues((it) => it.value.toSet()),
            equals(mapOf({
              4: setOf(["paul", "john", "lisa"]),
              5: setOf(["peter"]),
            })));
      });

      test("valuetransform", () {
        final iterable = iterableOf(["paul", "peter", "john", "lisa"]);
        expect(
            iterable
                .groupByTransform((it) => it.length, (it) => it.toUpperCase())
                .mapValues((it) => it.value.toSet()),
            equals(mapOf({
              4: setOf(["PAUL", "JOHN", "LISA"]),
              5: setOf(["PETER"]),
            })));
      });
    }

    test("groupBy doesn't allow null as keySelector", () {
      final iterable = iterableOf([1, 2, 3]);
      var e = catchException<ArgumentError>(() => iterable.groupBy(null));
      expect(e.message, allOf(contains("null"), contains("keySelector")));
    });

    test("groupByTransform doesn't allow null as keySelector", () {
      final iterable = iterableOf([1, 2, 3]);
      var e = catchException<ArgumentError>(
          () => iterable.groupByTransform(null, (it) => it));
      expect(e.message, allOf(contains("null"), contains("keySelector")));
    });

    test("groupByTransform doesn't allow null as valueTransform", () {
      final iterable = iterableOf([1, 2, 3]);
      var e = catchException<ArgumentError>(
          () => iterable.groupByTransform((it) => it, null));
      expect(e.message, allOf(contains("null"), contains("valueTransform")));
    });

    test("groupByToTransform doesn't allow null as destination", () {
      final iterable = iterableOf([1, 2, 3]);
      var e = catchException<ArgumentError>(
          () => iterable.groupByToTransform(null, (it) => it, (it) => it));
      expect(e.message, allOf(contains("null"), contains("destination")));
    });
  });

  group("indexOf", () {
    test("returns index", () {
      final iterable = iterableOf(["a", "b", "c", "b"]);
      var found = iterable.indexOf("b");
      if (iterable.count() == 4) {
        // ordered list
        expect(found, 1);
      } else {
        // set, position is unknown
        expect(found, isNot(-1));
      }
    });
  });

  group("indexOfFirst", () {
    test("returns index", () {
      final iterable = iterableOf(["a", "b", "c", "b"]);
      var found = iterable.indexOfFirst((it) => it == "b");
      if (iterable.count() == 4) {
        // ordered list
        expect(found, 1);
      } else {
        // set, position is unknown
        expect(found, isNot(-1));
      }
    });

    test("indexOfFirst predicate can't be null", () {
      final iterable = iterableOf([1, 2, 3]);
      var e = catchException<ArgumentError>(() => iterable.indexOfFirst(null));
      expect(e.message, allOf(contains("null"), contains("predicate")));
    });
  });

  group("indexOfLast", () {
    test("returns index", () {
      final iterable = iterableOf(["a", "b", "c", "b"]);
      var found = iterable.indexOfLast((it) => it == "b");
      if (iterable.count() == 4) {
        // ordered list
        expect(found, 3);
      } else {
        // set, position is unknown
        expect(found, isNot(-1));
      }
    });
    test("indexOfLast predicate can't be null", () {
      final iterable = iterableOf([1, 2, 3]);
      var e = catchException<ArgumentError>(() => iterable.indexOfLast(null));
      expect(e.message, allOf(contains("null"), contains("predicate")));
    });
  });

  group("intersect", () {
    test("remove one item", () {
      var a = iterableOf(["paul", "john", "max", "lisa"]);
      var b = iterableOf(["julie", "richard", "john", "lisa"]);
      final result = a.intersect(b);
      expect(result, setOf(["john", "lisa"]));
    });

    test("other can't be null", () {
      var a = iterableOf(["paul", "john", "max", "lisa"]);
      final e = catchException<ArgumentError>(() => a.intersect(null));
      expect(e.message, allOf(contains("null")));
    });
  });

  group("last", () {
    if (ordered) {
      test("get last element", () {
        expect(iterableOf(["a", "b"]).last(), "b");
      });
    } else {
      test("get random last element", () {
        var result = iterableOf(["a", "b"]).last();
        expect(result == "a" || result == "b", true);
      });
    }

    test("last throws for no elements", () {
      expect(() => emptyIterable().last(),
          throwsA(TypeMatcher<NoSuchElementException>()));
    });

    test("finds nothing throws", () {
      expect(() => iterableOf<String>(["a"]).last((it) => it == "b"),
          throwsA(TypeMatcher<NoSuchElementException>()));
    });
  });

  group("lastOrNull", () {
    if (ordered) {
      test("get lastOrNull element", () {
        expect(iterableOf(["a", "b"]).lastOrNull(), "b");
      });
    } else {
      test("get random last element", () {
        var result = iterableOf(["a", "b"]).lastOrNull();
        expect(result == "a" || result == "b", true);
      });
    }

    test("lastOrNull returns null for empty", () {
      expect(emptyIterable().lastOrNull(), isNull);
    });

    test("finds nothing throws", () {
      expect(iterableOf<String>(["a"]).lastOrNull((it) => it == "b"), isNull);
    });
  });

  group("lastIndexOf", () {
    test("returns last index", () {
      final iterable = iterableOf(["a", "b", "c", "b"]);
      var found = iterable.lastIndexOf("b");
      if (iterable.count() == 4) {
        // ordered list
        expect(found, 3);
      } else {
        // set, position is unknown
        expect(found, isNot(-1));
      }
    });
  });

  group("map", () {
    test("map int to string", () {
      final iterable = iterableOf([1, 2, 3]);
      expect(
          iterable.map((it) => it.toString()).toList(), listOf("1", "2", "3"));
    });
  });

  group("map", () {
    test("map int to string", () {
      final iterable = iterableOf([1, 2, 3]);
      expect(
          iterable.map((it) => it.toString()).toList(), listOf("1", "2", "3"));
    });
  });

  group("mapNotNull", () {
    test("mapNotNull int to string", () {
      final iterable = iterableOf([1, null, 2, null, 3]);
      expect(iterable.mapNotNull((it) => it?.toString()).toList(),
          listOf("1", "2", "3"));
    });
  });

  group("mapNotNullTo", () {
    test("mapNotNullTo int to string", () {
      final list = mutableListOf<String>();
      final iterable = iterableOf([1, null, 2, null, 3]);
      iterable.mapNotNullTo(list, (it) => it?.toString());

      expect(list, listOf("1", "2", "3"));
    });

    test("mapNotNullTo doesn't allow null as destination", () {
      final iterable = iterableOf([1, 2, 3]);
      var e = catchException<ArgumentError>(
          () => iterable.mapNotNullTo(null, (it) => it));
      expect(e.message, allOf(contains("null"), contains("destination")));
    });

    test("mapNotNullTo doesn't allow null as transform function", () {
      final iterable = iterableOf([1, 2, 3]);
      int Function(int) mapper = null;
      var e = catchException<ArgumentError>(
          () => iterable.mapNotNullTo(mutableListOf<int>(), mapper));
      expect(e.message, allOf(contains("null"), contains("transform")));
    });
  });

  group("mapTo", () {
    test("mapTo int to string", () {
      final list = mutableListOf<String>();
      final iterable = iterableOf([1, 2, 3]);
      iterable.mapTo(list, (it) => it.toString());

      expect(list, listOf("1", "2", "3"));
    });

    test("mapTo doesn't allow null as destination", () {
      final iterable = iterableOf([1, 2, 3]);
      var e =
          catchException<ArgumentError>(() => iterable.mapTo(null, (it) => it));
      expect(e.message, allOf(contains("null"), contains("destination")));
    });

    test("mapTo doesn't allow null as transform function", () {
      final iterable = iterableOf([1, 2, 3]);
      int Function(int) mapper = null;
      var e = catchException<ArgumentError>(
          () => iterable.mapTo(mutableListOf<int>(), mapper));
      expect(e.message, allOf(contains("null"), contains("transform")));
    });
  });

  if (ordered) {
    group("mapIndexedTo", () {
      test("mapIndexedTo int to string", () {
        final list = mutableListOf<String>();
        final iterable = iterableOf(["a", "b", "c"]);
        iterable.mapIndexedTo(list, (index, it) => "$index$it");

        expect(list, listOf("0a", "1b", "2c"));
      });

      test("mapIndexedTo doesn't allow null as destination", () {
        final iterable = iterableOf([1, 2, 3]);
        var e = catchException<ArgumentError>(
            () => iterable.mapIndexedTo(null, (_, it) => it));
        expect(e.message, allOf(contains("null"), contains("destination")));
      });

      test("mapIndexedTo doesn't allow null as transform function", () {
        final iterable = iterableOf([1, 2, 3]);
        int Function(int, int) indexedMapper = null;
        var e = catchException<ArgumentError>(
            () => iterable.mapIndexedTo(mutableListOf<int>(), indexedMapper));
        expect(e.message, allOf(contains("null"), contains("transform")));
      });
    });
  }

  if (ordered) {
    group("mapIndexed", () {
      test("mapIndexed int to string", () {
        final iterable = iterableOf(["a", "b", "c"]);
        final result = iterable.mapIndexed((index, it) => "$index$it");

        expect(result, listOf("0a", "1b", "2c"));
      });
    });
  }

  if (ordered) {
    group("mapIndexedNotNull", () {
      test("mapIndexedNotNull int to string", () {
        final iterable = iterableOf(["a", null, "b", "c"]);
        expect(
            iterable.mapIndexedNotNull((index, it) {
              if (it == null) return null;
              return "$index$it";
            }).toList(),
            listOf("0a", "2b", "3c"));
      });
    });
  }

  if (ordered) {
    group("mapIndexedNotNull", () {
      test("mapIndexedNotNull int to string", () {
        final set = linkedSetOf<String>();
        final iterable = iterableOf(["a", null, "b", "c"]);
        iterable.mapIndexedNotNullTo(set, (index, it) {
          if (it == null) return null;
          return "$index$it";
        }).toList();
        expect(set, setOf(["0a", "2b", "3c"]));
      });

      test("mapIndexedNotNullTo doesn't allow null as destination", () {
        final iterable = iterableOf([1, 2, 3]);
        var e = catchException<ArgumentError>(
            () => iterable.mapIndexedNotNullTo(null, (_, it) => it));
        expect(e.message, allOf(contains("null"), contains("destination")));
      });

      test("mapIndexedNotNullTo doesn't allow null as transform function", () {
        final iterable = iterableOf([1, 2, 3]);
        int Function(int, int) indexedMapper = null;
        var e = catchException<ArgumentError>(() =>
            iterable.mapIndexedNotNullTo(mutableListOf<int>(), indexedMapper));
        expect(e.message, allOf(contains("null"), contains("transform")));
      });
    });
  }

  group("max", () {
    test("gets max value", () {
      final iterable = iterableOf([1, 3, 2]);
      expect(iterable.max(), 3);
    });

    test("empty iterable return null", () {
      final iterable = emptyIterable<int>();
      expect(iterable.max(), null);
    });

    test("throws for non nums", () {
      expect(() => iterableOf(["1", "2", "3"]).max(), throwsArgumentError);
    });
  });

  group("maxBy", () {
    test("gets max value", () {
      final iterable = iterableOf(["1", "3", "2"]);
      expect(iterable.maxBy((it) => num.parse(it)), "3");
    });

    test("empty iterable return null", () {
      final iterable = emptyIterable<int>();
      expect(iterable.maxBy<num>((it) => it), null);
    });

    test("maxBy requires a non null selector", () {
      final e =
          catchException<ArgumentError>(() => emptyIterable().maxBy<num>(null));
      expect(e.message, allOf(contains("null"), contains("selector")));
    });
  });

  group("maxWith", () {
    int _intComparison(int value, int other) {
      return value.compareTo(other);
    }

    test("gets max value", () {
      final iterable = iterableOf([2, 1, 3]);
      expect(iterable.maxWith(_intComparison), 3);
    });

    test("empty iterable return null", () {
      final iterable = emptyIterable<int>();
      expect(iterable.maxWith(_intComparison), null);
    });

    test("maxWith requires a non null comparator", () {
      final e =
          catchException<ArgumentError>(() => emptyIterable().maxWith(null));
      expect(e.message, allOf(contains("null"), contains("comparator")));
    });
  });

  group("min", () {
    test("gets min value", () {
      final iterable = iterableOf([3, 1, 2]);
      expect(iterable.min(), 1);
    });

    test("empty iterable return null", () {
      final iterable = emptyIterable<int>();
      expect(iterable.min(), null);
    });

    test("throws for non nums", () {
      expect(() => iterableOf(["1", "2", "3"]).min(), throwsArgumentError);
    });
  });

  group("minBy", () {
    test("gets min value", () {
      final iterable = iterableOf(["1", "3", "2"]);
      expect(iterable.minBy((it) => num.parse(it)), "1");
    });

    test("empty iterable return null", () {
      final iterable = emptyIterable<int>();
      expect(iterable.minBy<num>((it) => it), null);
    });

    test("maxBy requires a non null selector", () {
      final e =
          catchException<ArgumentError>(() => emptyIterable().minBy<num>(null));
      expect(e.message, allOf(contains("null"), contains("selector")));
    });
  });

  group("minWith", () {
    int _intComparison(int value, int other) {
      return value.compareTo(other);
    }

    test("gets max value", () {
      final iterable = iterableOf([2, 1, 3]);
      expect(iterable.minWith(_intComparison), 3);
    });

    test("empty iterable return null", () {
      final iterable = emptyIterable<int>();
      expect(iterable.minWith(_intComparison), null);
    });

    test("minWith requires a non null comparator", () {
      final e =
          catchException<ArgumentError>(() => emptyIterable().minWith(null));
      expect(e.message, allOf(contains("null"), contains("comparator")));
    });
  });

  group("minus", () {
    if (ordered) {
      test("remove iterable", () {
        final result = iterableOf(["paul", "john", "max", "lisa"])
            .minus(iterableOf(["max", "john"]));
        expect(result, listOf("paul", "lisa"));
      });

      test("infix", () {
        final result =
            iterableOf(["paul", "john", "max", "lisa"]) - iterableOf(["max"]);
        expect(result.toList(), listOf("paul", "john", "lisa"));
      });

      test("remove one item", () {
        final result =
            iterableOf(["paul", "john", "max", "lisa"]).minusElement("max");
        expect(result.toList(), listOf("paul", "john", "lisa"));
      });
    } else {
      test("remove iterable", () {
        final result = iterableOf(["paul", "john", "max", "lisa"])
            .minus(iterableOf(["max", "john"]));
        expect(result.toSet(), setOf(["paul", "lisa"]));
      });

      test("infix", () {
        final result =
            iterableOf(["paul", "john", "max", "lisa"]) - iterableOf(["max"]);
        expect(result.toSet(), setOf(["paul", "john", "lisa"]));
      });

      test("remove one item", () {
        final result =
            iterableOf(["paul", "john", "max", "lisa"]).minusElement("max");
        expect(result.toSet(), setOf(["paul", "john", "lisa"]));
      });
    }

    test("minus doesn't allow null as elements", () {
      final iterable = emptyIterable<String>();
      var e = catchException<ArgumentError>(() => iterable.minus(null));
      expect(e.message, allOf(contains("null"), contains("elements")));
    });
  });

  group("none", () {
    test("no matching returns true", () {
      final items = iterableOf(["paul", "john", "max", "lisa"]);
      expect(items.none((it) => it.contains("y")), isTrue);
    });
    test("matching returns false", () {
      final items = iterableOf(["paul", "john", "max", "lisa"]);
      expect(items.none((it) => it.contains("p")), isFalse);
    });

    test("none without predicate returns false when iterable has items", () {
      final items = iterableOf(["paul", "john", "max", "lisa"]);
      expect(items.none(), isFalse);
    });

    test("empty returns always true", () {
      expect(emptyIterable().none(), isTrue);
    });
  });

  group("onEach", () {
    test("onEach", () {
      final iterable = iterableOf([
        [1, 2],
        [3, 4],
        [5, 6]
      ]);
      iterable.onEach((it) => it.add(0));
      expect(iterable.map((it) => it.last).toList(), listOf(0, 0, 0));
    });

    test("onEach doesn't allow null as action", () {
      final iterable = emptyIterable<String>();
      var e = catchException<ArgumentError>(() => iterable.onEach(null));
      expect(e.message, allOf(contains("null"), contains("action")));
    });
  });

  group("partition", () {
    test("partition", () {
      final result =
          iterableOf([7, 31, 4, 3, 92, 32]).partition((it) => it > 10);
      expect(result.first.toSet(), setOf([31, 92, 32]));
      expect(result.second.toSet(), setOf([7, 4, 3]));
    });

    test("partition doesn't allow null as predicate", () {
      final iterable = emptyIterable<String>();
      var e = catchException<ArgumentError>(() => iterable.partition(null));
      expect(e.message, allOf(contains("null"), contains("predicate")));
    });
  });

  group("plus", () {
    test("concat two iterables", () {
      final result = iterableOf([1, 2, 3]).plus(iterableOf([4, 5, 6]));
      expect(result.toList(), listOf(1, 2, 3, 4, 5, 6));
    });

    test("infix", () {
      final result = iterableOf([1, 2, 3]) + iterableOf([4, 5, 6]);
      expect(result.toList(), listOf(1, 2, 3, 4, 5, 6));
    });

    test("plus doesn't allow null as elements", () {
      final iterable = emptyIterable<String>();
      var e = catchException<ArgumentError>(() => iterable.plus(null));
      expect(e.message, allOf(contains("null"), contains("elements")));
    });
  });

  group("plusElement", () {
    test("concat item", () {
      final result = iterableOf([1, 2, 3]).plusElement(5);
      expect(result.toList(), listOf(1, 2, 3, 5));
    });

    test("element can be null", () {
      final result = iterableOf([1, 2, 3]).plusElement(null);
      expect(result.toList(), listFrom([1, 2, 3, null]));
    });
  });

  group("reduce", () {
    test("reduce", () {
      final result = iterableOf([1, 2, 3, 4]).reduce((int acc, it) => it + acc);
      expect(result, 10);
    });

    test("empty throws", () {
      expect(() => emptyIterable<int>().reduce((int acc, it) => it + acc),
          throwsUnsupportedError);
    });

    test("reduce doesn't allow null as operation", () {
      final iterable = emptyIterable<String>();
      var e = catchException<ArgumentError>(() => iterable.reduce(null));
      expect(e.message, allOf(contains("null"), contains("operation")));
    });
  });

  group("reduceIndexed", () {
    test("reduceIndexed", () {
      var i = 1;
      final result =
          iterableOf([1, 2, 3, 4]).reduceIndexed((index, int acc, it) {
        expect(index, i);
        i++;
        return it + acc;
      });
      expect(result, 10);
    });

    test("empty throws", () {
      expect(
          () => emptyIterable<int>()
              .reduceIndexed((index, int acc, it) => it + acc),
          throwsUnsupportedError);
    });

    test("reduceIndexed doesn't allow null as operation", () {
      final iterable = emptyIterable<String>();
      var e = catchException<ArgumentError>(() => iterable.reduceIndexed(null));
      expect(e.message, allOf(contains("null"), contains("operation")));
    });
  });

  group("requireNoNulls", () {
    test("throw when nulls are found", () {
      final e = catchException<ArgumentError>(
          () => iterableOf(["paul", null, "john", "lisa"]).requireNoNulls());
      expect(e.message, contains("null element found"));
    });
  });

  group("reversed", () {
    test("mutliple", () {
      final result = iterableOf([1, 2, 3, 4]).reversed();
      expect(result.toList(), listOf(4, 3, 2, 1));
    });

    test("empty", () {
      expect(emptyIterable<int>().reversed().toList(), emptyList<int>());
    });

    test("one", () {
      expect(iterableOf<int>([1]).reversed().toList(), listFrom<int>([1]));
    });
  });

  group("single", () {
    test("single", () {
      expect(iterableOf([1]).single(), 1);
    });
    test("single throws when list has more elements", () {
      final e =
          catchException<ArgumentError>(() => iterableOf([1, 2]).single());
      expect(e.message, contains("has more than one element"));
    });
    test("single throws for empty iterables", () {
      final e = catchException<NoSuchElementException>(
          () => emptyIterable().single());
      expect(e.message, contains("is empty"));
    });
    test("single with predicate finds item", () {
      final found = iterableOf(["paul", "john", "max", "lisa"])
          .single((it) => it.contains("x"));
      expect(found, "max");
    });
    test("single with predicate without match", () {
      final e = catchException<NoSuchElementException>(() =>
          iterableOf(["paul", "john", "max", "lisa"])
              .single((it) => it.contains("y")));
      expect(e.message, contains("no element matching the predicate"));
    });
    test("single with predicate multiple matches", () {
      final e = catchException<ArgumentError>(() =>
          iterableOf(["paul", "john", "max", "lisa"])
              .single((it) => it.contains("l")));
      expect(e.message, contains("more than one matching element"));
    });
  });

  group("singleOrNull", () {
    test("singleOrNull", () {
      expect(iterableOf([1]).singleOrNull(), 1);
    });
    test("singleOrNull on multiple iterable returns null", () {
      expect(iterableOf([1, 2]).singleOrNull(), null);
    });
    test("singleOrNull on empty iterable returns null", () {
      expect(emptyIterable().singleOrNull(), null);
    });
    test("singleOrNull with predicate finds item", () {
      final found = iterableOf(["paul", "john", "max", "lisa"])
          .singleOrNull((it) => it.contains("x"));
      expect(found, "max");
    });
    test("singleOrNull with predicate without match returns null", () {
      final result = iterableOf(["paul", "john", "max", "lisa"])
          .singleOrNull((it) => it.contains("y"));
      expect(result, null);
    });
    test("singleOrNull with predicate multiple matches returns null", () {
      final result = iterableOf(["paul", "john", "max", "lisa"])
          .singleOrNull((it) => it.contains("l"));
      expect(result, null);
    });
  });

  group("sort", () {
    test("sort", () {
      final result = iterableOf([4, 2, 3, 1]).sorted();
      expect(result.toList(), listOf(1, 2, 3, 4));
    });

    test("sortedDescending", () {
      final result = iterableOf([4, 2, 3, 1]).sortedDescending();
      expect(result.toList(), listOf(4, 3, 2, 1));
    });

    var lastChar = (String it) {
      var last = it.runes.last;
      return String.fromCharCode(last);
    };

    test("sortedBy", () {
      final result =
          iterableOf(["paul", "john", "max", "lisa"]).sortedBy(lastChar);
      expect(result, listOf("lisa", "paul", "john", "max"));
    });

    test("sortedByDescending", () {
      final result = iterableOf(["paul", "john", "max", "lisa"])
          .sortedByDescending(lastChar);
      expect(result, listOf("max", "john", "paul", "lisa"));
    });

    test("sortedBy doesn't allow null as selector", () {
      final iterable = emptyIterable<String>();
      num Function(String) sortFun = null;
      var e = catchException<ArgumentError>(() => iterable.sortedBy(sortFun));
      expect(e.message, allOf(contains("null"), contains("selector")));
    });

    test("sortedByDescending doesn't allow null as selector", () {
      final iterable = emptyIterable<String>();
      num Function(String) sortFun = null;
      var e = catchException<ArgumentError>(
          () => iterable.sortedByDescending(sortFun));
      expect(e.message, allOf(contains("null"), contains("selector")));
    });
    test("sortedWith doesn't allow null as comparator", () {
      final iterable = emptyIterable<String>();
      Comparator comparator = null;
      var e =
          catchException<ArgumentError>(() => iterable.sortedWith(comparator));
      expect(e.message, allOf(contains("null"), contains("comparator")));
    });
  });

  group("subtract", () {
    test("remove one item", () {
      final result = iterableOf(["paul", "john", "max", "lisa"])
          .subtract(iterableOf(["max"]));
      expect(result, setOf(["paul", "john", "lisa"]));
    });

    test("subtract doesn't allow null as other", () {
      final iterable = emptyIterable<String>();
      var e = catchException<ArgumentError>(() => iterable.subtract(null));
      expect(e.message, allOf(contains("null"), contains("other")));
    });
  });

  group("sum", () {
    test("sum of ints", () {
      expect(iterableOf([1, 2, 3, 4, 5]).sum(), 15);
    });

    test("sum of doubles", () {
      var sum = iterableOf([1.0, 2.1, 3.2]).sum();
      expect(sum, closeTo(6.3, 0.000000001));
    });

    test("sum of strings throws", () {
      expect(() => iterableOf(["1", "2", "3"]).sum(), throwsArgumentError);
    });
  });

  group("sumBy", () {
    test("double", () {
      expect(iterableOf([1, 2, 3]).sumBy((i) => i * 2), 12);
    });

    test("factor 1.5", () {
      expect(iterableOf([1, 2, 3]).sumByDouble((i) => i * 1.5), 9.0);
    });

    test("sumBy doesn't allow null as selector", () {
      final iterable = emptyIterable<num>();
      var e = catchException<ArgumentError>(() => iterable.sumBy(null));
      expect(e.message, allOf(contains("null"), contains("selector")));
    });

    test("sumByDouble doesn't allow null as selector", () {
      final iterable = emptyIterable<num>();
      var e = catchException<ArgumentError>(() => iterable.sumByDouble(null));
      expect(e.message, allOf(contains("null"), contains("selector")));
    });
  });

  group("take", () {
    test("take zero returns empty", () {
      final iterable = iterableOf([1, 2, 3, 4]);
      expect(iterable.take(0).toList(), emptyList());
    });

    test("take negative returns empty", () {
      final iterable = iterableOf([1, 2, 3, 4]);
      final e = catchException<ArgumentError>(() => iterable.take(-3));
      expect(e.message, allOf(contains("-3"), contains("less than zero")));
    });

    test("take more than size returns full list", () {
      final iterable = iterableOf([1, 2, 3, 4]);
      expect(iterable.take(10).toList(), iterable.toList());
    });

    if (ordered) {
      test("take smaller list size returns first elements", () {
        final iterable = iterableOf([1, 2, 3, 4]);
        expect(iterable.take(2).toList(), listOf(1, 2));
      });
    }

    test("take doesn't allow null as n", () {
      final iterable = emptyIterable<num>();
      var e = catchException<ArgumentError>(() => iterable.take(null));
      expect(e.message, allOf(contains("null"), contains("n")));
    });

    if (ordered) {
      test("take first element which is null", () {
        final iterable = iterableOf([null, 1]);
        expect(iterable.take(1).toList(), listFrom([null]));
        expect(iterable.take(2).toList(), listFrom([null, 1]));
      });
    }
  });
  group("windowed", () {
    test("default step", () {
      expect(
          iterableOf([1, 2, 3, 4, 5]).windowed(3),
          listOf(
            listOf(1, 2, 3),
            listOf(2, 3, 4),
            listOf(3, 4, 5),
          ));
    });

    test("larger step", () {
      expect(
          iterableOf([1, 2, 3, 4, 5]).windowed(3, step: 2),
          listOf(
            listOf(1, 2, 3),
            listOf(3, 4, 5),
          ));
    });

    test("step doesn't fit length", () {
      expect(
          iterableOf([1, 2, 3, 4, 5, 6]).windowed(3, step: 2),
          listOf(
            listOf(1, 2, 3),
            listOf(3, 4, 5),
          ));
    });

    test("window can be smaller than length", () {
      expect(iterableOf([1]).windowed(3, step: 2), emptyList());
    });

    test("step doesn't fit length, partial", () {
      expect(
          iterableOf([1, 2, 3, 4, 5, 6])
              .windowed(3, step: 2, partialWindows: true),
          listOf(
            listOf(1, 2, 3),
            listOf(3, 4, 5),
            listOf(5, 6),
          ));
    });
    test("partial doesn't crash on empty iterable", () {
      expect(emptyIterable().windowed(3, step: 2, partialWindows: true),
          emptyList());
    });
    test("window can be smaller than length, emitting partial only", () {
      expect(iterableOf([1]).windowed(3, step: 2, partialWindows: true),
          listOf(listOf(1)));
    });

    test("window doesn't allow null as size", () {
      final iterable = emptyIterable<String>();
      var e = catchException<ArgumentError>(() => iterable.windowed(null));
      expect(e.message, allOf(contains("null"), contains("size")));
    });

    test("window doesn't allow null as step", () {
      final iterable = emptyIterable<String>();
      var e =
          catchException<ArgumentError>(() => iterable.windowed(3, step: null));
      expect(e.message, allOf(contains("null"), contains("step")));
    });

    test("window doesn't allow null as partialWindows", () {
      final iterable = emptyIterable<String>();
      var e = catchException<ArgumentError>(
          () => iterable.windowed(3, partialWindows: null));
      expect(e.message, allOf(contains("null"), contains("partialWindows")));
    });
  });

  group("windowedTransform", () {
    test("default step", () {
      expect(iterableOf([1, 2, 3, 4, 5]).windowedTransform(3, (l) => l.sum()),
          listOf(6, 9, 12));
    });

    test("larger step", () {
      expect(
          iterableOf([1, 2, 3, 4, 5])
              .windowedTransform(3, (l) => l.sum(), step: 2),
          listOf(6, 12));
    });

    test("step doesn't fit length", () {
      expect(
          iterableOf([1, 2, 3, 4, 5, 6])
              .windowedTransform(3, (l) => l.sum(), step: 2),
          listOf(6, 12));
    });

    test("window can be smaller than length", () {
      expect(iterableOf([1]).windowed(3, step: 2), emptyList());
    });

    test("step doesn't fit length, partial", () {
      expect(
          iterableOf([1, 2, 3, 4, 5, 6]).windowedTransform(3, (l) => l.sum(),
              step: 2, partialWindows: true),
          listOf(6, 12, 11));
    });
    test("partial doesn't crash on empty iterable", () {
      expect(
          emptyIterable().windowedTransform(3, (l) => l.sum(),
              step: 2, partialWindows: true),
          emptyList());
    });
    test("window can be smaller than length, emitting partial only", () {
      expect(
          iterableOf([1]).windowedTransform(3, (l) => l.sum(),
              step: 2, partialWindows: true),
          listOf(1));
    });

    test("windowedTransform doesn't allow null as size", () {
      final iterable = emptyIterable<String>();
      var e = catchException<ArgumentError>(
          () => iterable.windowedTransform(null, (it) => it));
      expect(e.message, allOf(contains("null"), contains("size")));
    });

    test("windowedTransform doesn't allow null as transform function", () {
      final iterable = emptyIterable<String>();
      var e = catchException<ArgumentError>(
          () => iterable.windowedTransform(3, null));
      expect(e.message, allOf(contains("null"), contains("transform")));
    });

    test("windowedTransform doesn't allow null as step", () {
      final iterable = emptyIterable<String>();
      var e = catchException<ArgumentError>(
          () => iterable.windowedTransform(3, (it) => it, step: null));
      expect(e.message, allOf(contains("null"), contains("step")));
    });

    test("windowedTransform doesn't allow null as partialWindows", () {
      final iterable = emptyIterable<String>();
      var e = catchException<ArgumentError>(() =>
          iterable.windowedTransform(3, (it) => it, partialWindows: null));
      expect(e.message, allOf(contains("null"), contains("partialWindows")));
    });
  });

  group("zip", () {
    test("to pair", () {
      final result = iterableOf([1, 2, 3, 4, 5]).zip(iterableOf(["a", "b"]));
      expect(result, listFrom([KPair(1, "a"), KPair(2, "b")]));
    });
    test("transform", () {
      final result = iterableOf([1, 2, 3, 4, 5])
          .zipTransform(iterableOf(["a", "b"]), (a, b) => "$a$b");
      expect(result, listOf("1a", "2b"));
    });

    test("zipWithNextTransform", () {
      final result =
          iterableOf([1, 2, 3, 4, 5]).zipWithNextTransform((a, b) => a + b);
      expect(result, listOf(3, 5, 7, 9));
    });
    test("zipWithNextTransform doesn't allow null as transform function", () {
      final iterable = emptyIterable<String>();
      int Function(dynamic, dynamic) transform = null;
      var e = catchException<ArgumentError>(
          () => iterable.zipWithNextTransform(transform));
      expect(e.message, allOf(contains("null"), contains("transform")));
    });

    test("zip doesn't allow null as other", () {
      final iterable = emptyIterable<String>();
      var e = catchException<ArgumentError>(() => iterable.zip(null));
      expect(e.message, allOf(contains("null"), contains("other")));
    });
    test("zipTransform doesn't allow null as other", () {
      final iterable = emptyIterable<String>();
      var e = catchException<ArgumentError>(
          () => iterable.zipTransform(null, (a, b) => a));
      expect(e.message, allOf(contains("null"), contains("other")));
    });
    test("zipTransform doesn't allow null as transform function", () {
      final iterable = emptyIterable<String>();
      int Function(dynamic, dynamic) transform = null;
      var e = catchException<ArgumentError>(
          () => iterable.zipTransform(emptyIterable(), transform));
      expect(e.message, allOf(contains("null"), contains("transform")));
    });
  });
}
