import XCTest
@testable import OSet

class OSetTests: XCTestCase {
    // MARK: SetAlgebra

    func testInit() {
        let cases = [
            [],
            [1, 2, 3],
            [1, 3, 2],
            [2, 1, 3],
            [2, 3, 1],
            [3, 1, 2],
            [3, 2, 1],
            [581, 5448, 23, 1, 0, 23954, 123, 456703]
        ]
        cases.forEach({
            let oset = OSet($0)

            XCTAssertEqual(oset.a, $0)
            XCTAssertEqual(oset.s, Set($0))
        })
    }

    func testInitDup() {
        let oset = OSet([1, 2, 3, 3, 2, 1])

        XCTAssertEqual(oset.a, [1, 2, 3])
        XCTAssertEqual(oset.s, Set([1, 2, 3]))
    }

    func testContains() {
        let cases = [
            ([], 0, false),
            ([1, 2, 3], 1, true),
            ([1, 2, 3], 4, false)
        ]
        cases.forEach({
            let oset = OSet($0)

            XCTAssertEqual(oset.contains($1), $2)
        })
    }

    func testUnion() {
        let cases = [
            ([1, 2, 3], [5, 6], [1, 2, 3, 5, 6]),
            ([1, 3, 5], [2, 4], [1, 3, 5, 2, 4]),
            ([1, 3, 5], [2, 4, 5], [1, 3, 5, 2, 4])
        ]
        cases.forEach({
            let oset = OSet($0)

            let out = oset.union(OSet($1)) // TODO: Make union accept Sequence

            XCTAssertEqual(out.a, $2)
            XCTAssertEqual(out.s, Set($2))
            XCTAssertEqual(oset.a, $0)
            XCTAssertEqual(oset.s, Set($0))
        })
    }

    func testIntersection() {
        let cases = [
            ([1, 2, 3], [3, 4, 5], [3]),
            ([3, 2, 1], [3, 1, 5], [3, 1]),
            ([2, 1, 3], [], []),
            ([2, 1, 3], [4, 5, 6], []),
            ([1, 3, 2], [3, 2, 1], [1, 3, 2])
        ]
        cases.forEach({
            let oset = OSet($0)

            let out = oset.intersection(OSet($1))

            XCTAssertEqual(out.a, $2)
            XCTAssertEqual(out.s, Set($2))
            XCTAssertEqual(oset.a, $0)
            XCTAssertEqual(oset.s, Set($0))
        })
    }

    func testSymmetricDifference() {
        let cases = [
            ([1, 5, 6], [4, 5], [1, 6, 4]),
            ([1, 2, 3], [4, 5], [1, 2, 3, 4, 5]),
            ([3, 2, 1], [1, 3, 2], []),
            ([1, 2, 3, 4, 5, 6], [1, 3, 5, 8], [2, 4, 6, 8])
        ]
        cases.forEach({
            let oset = OSet($0)

            let out = oset.symmetricDifference(OSet($1))

            XCTAssertEqual(out.a, $2)
            XCTAssertEqual(out.s, Set($2))
            XCTAssertEqual(oset.a, $0)
            XCTAssertEqual(oset.s, Set($0))
        })
    }

    func testInsert() {
        let cases = [
            ([], 1, [1], true, 1),
            ([1], 3, [1, 3], true, 3),
            ([1, 3], 2, [1, 3, 2], true, 2),
            ([1, 2, 3], 2, [1, 2, 3], false, 2)
        ]
        cases.forEach({
            var oset = OSet($0)

            let (inserted, memberAfterInsert) = oset.insert($1)

            XCTAssertEqual(oset.a, $2)
            XCTAssertEqual(oset.s, Set($2))
            XCTAssertEqual(inserted, $3)
            XCTAssertEqual(memberAfterInsert, $4)
        })
    }

    func testRemove() {
        let cases = [
            ([], 1, [], nil),
            ([1], 1, [], 1),
            ([1, 3], 3, [1], 3),
            ([1, 2, 3], 2, [1, 3], 2),
            ([3, 2, 1], 4, [3, 2, 1], nil)
        ]
        cases.forEach({
            var oset = OSet($0)

            let e = oset.remove($1)

            XCTAssertEqual(oset.a, $2)
            XCTAssertEqual(oset.s, Set($2))
            XCTAssertEqual(e, $3)
        })
    }

    func testUpdate() {
        let cases = [
            ([], 1, [1], nil),
            ([1], 1, [1], 1),
            ([1, 2], 3, [1, 2, 3], nil),
            ([1, 2, 3], 2, [1, 2, 3], 2)
        ]
        cases.forEach({
            var oset = OSet($0)

            let e = oset.update(with: $1)

            XCTAssertEqual(oset.a, $2)
            XCTAssertEqual(oset.s, Set($2))
            XCTAssertEqual(e, $3)
        })
    }

    func testFormUnion() {
        let cases = [
            ([1, 2, 3], [5, 6], [1, 2, 3, 5, 6]),
            ([1, 3, 5], [2, 4], [1, 3, 5, 2, 4]),
            ([1, 3, 5], [2, 4, 5], [1, 3, 5, 2, 4])
        ]
        cases.forEach({
            var oset = OSet($0)

            oset.formUnion(OSet($1))

            XCTAssertEqual(oset.a, $2)
            XCTAssertEqual(oset.s, Set($2))
        })
    }

    func testFormIntersection() {
        let cases = [
            ([1, 2, 3], [3, 4, 5], [3]),
            ([3, 2, 1], [3, 1, 5], [3, 1]),
            ([2, 1, 3], [], []),
            ([2, 1, 3], [4, 5, 6], []),
            ([1, 3, 2], [3, 2, 1], [1, 3, 2])
        ]
        cases.forEach({
            var oset = OSet($0)

            oset.formIntersection(OSet($1))

            XCTAssertEqual(oset.a, $2)
            XCTAssertEqual(oset.s, Set($2))
        })
    }

    func testFormSymmetricDifference() {
        let cases = [
            ([1, 5, 6], [4, 5], [1, 6, 4]),
            ([1, 2, 3], [4, 5], [1, 2, 3, 4, 5]),
            ([3, 2, 1], [1, 3, 2], []),
            ([1, 2, 3, 4, 5, 6], [1, 3, 5, 8], [2, 4, 6, 8])
        ]
        cases.forEach({
            var oset = OSet($0)

            oset.formSymmetricDifference(OSet($1))

            XCTAssertEqual(oset.a, $2)
            XCTAssertEqual(oset.s, Set($2))
        })
    }

    func testEquals() {
        let cases = [
            ([], [], true),
            ([], [1], false),
            ([1], [], false),
            ([1, 2, 3], [1, 2, 3], true)
        ]
        cases.forEach({
            let oset1 = OSet($0)
            let oset2 = OSet($1)

            XCTAssertEqual(oset1 == oset2, $2)
        })
    }

    func testSubtract() {
        let cases = [
            ([], [], []),
            ([1], [1], []),
            ([1, 2], [1], [2]),
            ([1, 2], [3], [1, 2]),
            ([1, 2, 3], [3, 1, 2], []),
            ([3, 2, 1], [2], [3, 1]),
        ]
        cases.forEach({
            var oset = OSet($0)

            oset.subtract(OSet($1))

            XCTAssertEqual(oset.a, $2)
            XCTAssertEqual(oset.s, Set($2))
        })
    }

    func testSubtracting() {
        let cases = [
            ([], [], []),
            ([1], [1], []),
            ([1, 2], [1], [2]),
            ([1, 2], [3], [1, 2]),
            ([1, 2, 3], [3, 1, 2], []),
            ([3, 2, 1], [2], [3, 1]),
        ]
        cases.forEach({
            let oset = OSet($0)

            let out = oset.subtracting(OSet($1))

            XCTAssertEqual(out.a, $2)
            XCTAssertEqual(out.s, Set($2))
            XCTAssertEqual(oset.a, $0)
            XCTAssertEqual(oset.s, Set($0))
        })
    }

    // MARK: - SetAlgebra
    // MARK: Collection

    func testIterator() {
        let cases = [
            [],
            [1, 2, 3],
            [1, 3, 2],
            [2, 1, 3],
            [2, 3, 1],
            [3, 1, 2],
            [3, 2, 1],
            [581, 5448, 23, 1, 0, 23954, 123, 456703]
        ]
        cases.forEach({
            let oset = OSet($0)

            for (i, e) in oset.enumerated() {
                XCTAssertEqual(e, $0[i])
            }
        })
    }

    func testStartIndex() {
        let cases = [
            [],
            [1],
            [1, 2, 3],
            [581, 5448, 23, 1, 0, 23954, 123, 456703]
        ]
        cases.forEach({
            let oset = OSet($0)

            XCTAssertEqual(oset.startIndex, 0)
        })
    }

    func testEndIndex() {
        let cases = [
            ([], 0),
            ([1], 1),
            ([1, 2, 3], 3),
            ([581, 5448, 23, 1, 0, 23954, 123, 456703], 8)
        ]
        cases.forEach({
            let oset = OSet($0)

            XCTAssertEqual(oset.endIndex, $1)
        })
    }

    func testIndex() {
        let cases = [
            ([1], 0, 1),
            ([1, 2, 3], 0, 1),
            ([3, 2, 1], 1, 2),
            ([2, 3, 1], 2, 3),
            ([581, 5448, 23, 1, 0, 23954, 123, 456703], 3, 4)
        ]
        cases.forEach({
            let oset = OSet($0)

            XCTAssertEqual(oset.index(after: $1), $2)
        })
    }

    func testIsEmpty() {
        let cases = [
            ([], true),
            ([1], false),
            ([1, 2, 3], false),
            ([581, 5448, 23, 1, 0, 23954, 123, 456703], false)
        ]
        cases.forEach({
            let oset = OSet($0)

            XCTAssertEqual(oset.isEmpty, $1)
        })
    }

    func testSwapAt() {
        let cases = [
            ([1, 2], 0, 1, [2, 1]),
            ([1, 2, 3], 0, 2, [3, 2, 1]),
            ([2, 1, 3], 1, 2, [2, 3, 1]),
            ([3, 1, 2], 0, 1, [1, 3, 2]),
            ([581, 5448, 23, 1, 0, 23954, 123, 456703], 2, 6, [581, 5448, 123, 1, 0, 23954, 23, 456703]),
        ]
        cases.forEach({
            var oset = OSet($0)

            oset.swapAt($1, $2)

            XCTAssertEqual(oset.a, $3)
            XCTAssertEqual(oset.s, Set($3))
        })
    }

    func testSort() {
        let cases = [
            ([1, 2, 3], [1, 2, 3]),
            ([3, 1, 2], [1, 2, 3]),
            ([581, 5448, 23, 1, 0, 23954, 123, 456703], [0, 1, 23, 123, 581, 5448, 23954, 456703]),
        ]
        cases.forEach({
            var oset = OSet($0)

            oset.sort()

            XCTAssertEqual(oset.a, $1)
            XCTAssertEqual(oset.s, Set($1))
        })
    }

    func testSortBy() {
        let cases: [([Int], (Int, Int) -> Bool, [Int])] = [
            ([1, 2, 3], { $0 < $1 }, [1, 2, 3]),
            ([3, 1, 2], { $0 < $1 }, [1, 2, 3]),
            ([2, 3, 1], { $0 > $1 }, [3, 2, 1]),
            ([581, 5448, 23, 1, 0, 23954, 123, 456703], { $0 > $1 }, [456703, 23954, 5448, 581, 123, 23, 1, 0]),
        ]
        cases.forEach({
            var oset = OSet($0)

            oset.sort(by: $1)

            XCTAssertEqual(oset.a, $2)
            XCTAssertEqual(oset.s, Set($2))
        })
    }

    // MARK: - Collection
    // MARK: Subscript

    func testSubscriptGet() {
        let cases = [
            ([1], 0, 1),
            ([1, 2, 3], 1, 2),
            ([3, 2, 1], 2, 1),
            ([581, 5448, 23, 1, 0, 23954, 123, 456703], 4, 0)
        ]
        cases.forEach({
            let oset = OSet($0)

            XCTAssertEqual(oset[$1], $2)
        })
    }

    func testSubscriptSet() {
        let cases = [
            ([1], 0, 2, [2]),
            ([1, 2, 3], 1, 4, [1, 4, 3]),
            ([3, 1, 2], 2, 1, [3, 1]),
            ([3, 1, 2, 4, 5], 3, 3, [1, 2, 3, 5])
        ]
        cases.forEach({
            var oset = OSet($0)

            oset[$1] = $2

            XCTAssertEqual(oset.a, $3)
            XCTAssertEqual(oset.s, Set($3))
        })
    }

    // MARK: - Subscript
}
