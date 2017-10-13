internal func copy<E>(_ oset: OSet<E>, op: (inout OSet<E>) -> Void) -> OSet<E> {
    var copy = oset
    op(&copy)
    return copy
}

public struct OSet<E: Hashable & Equatable>: SetAlgebra, MutableCollection, RandomAccessCollection {
    internal var a: [E]
    internal var s: Set<E>

    // MARK: SetAlgebra

    public typealias Element = E

    public init() {
        self.a = []
        self.s = Set()
    }

    public func contains(_ item: E) -> Bool {
        return self.s.contains(item)
    }

    public func union(_ other: OSet) -> OSet {
        return copy(self) { (s: inout OSet) in s.formUnion(other) }
    }

    public func intersection(_ other: OSet) -> OSet {
        return copy(self) { (s: inout OSet) in s.formIntersection(other) }
    }

    public func symmetricDifference(_ other: OSet) -> OSet {
        return copy(self) { (s: inout OSet) in s.formSymmetricDifference(other) }
    }

    @discardableResult
    public mutating func insert(_ item: E) -> (inserted: Bool, memberAfterInsert: E) {
        let (inserted, e) = self.s.insert(item)
        if inserted {
            self.a.append(item)
        }
        return (inserted, e)
    }

    @discardableResult
    public mutating func remove(_ item: E) -> E? {
        let e = self.s.remove(item)
        if e != nil {
            let i = self.a.index(of: item)
            self.a.remove(at: i!)
        }
        return e
    }

    @discardableResult
    public mutating func update(with item: E) -> E? {
        guard let existingItem = self.s.update(with: item) else {
            self.a.append(item)
            return nil
        }
        return existingItem
    }

    public mutating func formUnion(_ other: OSet) {
        for item in other {
            self.insert(item)
        }
    }

    public mutating func formIntersection(_ other: OSet) {
        for item in self {
            if !other.contains(item) {
                self.s.remove(item)
            }
        }
        self.a = self.a.filter({ self.s.contains($0) })
    }

    public mutating func formSymmetricDifference(_ other: OSet) {
        for e in other {
            if self.contains(e) {
                self.s.remove(e)
            } else {
                self.update(with: e)
            }
        }
        self.a = self.a.filter({ self.s.contains($0) })
    }

    public static func == (lhs: OSet, rhs: OSet) -> Bool {
        return lhs.a == rhs.a
    }

    public mutating func subtract(_ other: OSet) {
        for e in other {
            self.s.remove(e)
        }
        self.a = self.a.filter({ self.s.contains($0) })
    }

    public func subtracting(_ other: OSet) -> OSet {
        return copy(self) { (s: inout OSet) in s.subtract(other) }
    }

    // MARK: - SetAlgebra
    // MARK: Collection

    public typealias Iterator = IndexingIterator<[E]>

    public func makeIterator() -> Iterator {
        return self.a.makeIterator()
    }

    public var startIndex: Int {
        return self.a.startIndex
    }

    public var endIndex: Int {
        return self.a.endIndex
    }

    public func index(after: Int) -> Int {
        return self.a.index(after: after)
    }

    public var isEmpty: Bool {
        return self.a.isEmpty
    }

    public mutating func swapAt(_ i: Int, _ j: Int) {
        guard i != j else {
            return
        }
        let tmp = self.a[i]
        self.a[i] = self.a[j]
        self.a[j] = tmp
    }

    // MARK: - Collection
    // MARK: Subscript

    public subscript(index: Int) -> E {
        get {
            return self.a[index]
        }
        set(item) {
            let idx = self.a.index(of: item)

            self.s.remove(self.a[index])

            self.a[index] = item
            self.s.update(with: item)

            if idx != nil {
                self.a.remove(at: idx!)
            }
        }
    }

    // MARK: - Subscript
}
