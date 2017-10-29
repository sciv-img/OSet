internal func copy<E>(_ oset: OSet<E>, op: (inout OSet<E>) -> Void) -> OSet<E> {
    var copy = oset
    op(&copy)
    return copy
}

public struct OSet<E: Hashable & Comparable>: SetAlgebra, MutableCollection, RandomAccessCollection {
    internal var a: [E]
    internal var s: Set<E>

    // MARK: SetAlgebra

    public typealias Element = E

    public init() {
        self.a = []
        self.s = Set()
    }

    /// Checks if given item exists in the OSet.
    ///
    /// - Parameter item: An item to look for.
    /// - Returns: `true` if item exists, `false` otherwise.
    public func contains(_ item: E) -> Bool {
        return self.s.contains(item)
    }

    /// Adds items from given OSet to the OSet, returning a new copy.
    /// If some items already exist in the original oset, they are kept.
    ///
    /// - Parameter other: An OSet to add to the current OSet.
    /// - Returns: New OSet instance with items of both original and given OSet.
    public func union(_ other: OSet) -> OSet {
        return copy(self) { (s: inout OSet) in s.formUnion(other) }
    }

    /// Gets items common among two OSets.
    ///
    /// - Parameter other: A second OSet to intersect with.
    /// - Returns: New OSet instance with items contained in both original and given OSet.
    public func intersection(_ other: OSet) -> OSet {
        return copy(self) { (s: inout OSet) in s.formIntersection(other) }
    }

    /// Gets items that are only in one OSet or the other, but not both.
    ///
    /// - Parameter other: A second OSet to differ with.
    /// - Returns: New OSet instance with items contained either in original or in given OSet.
    public func symmetricDifference(_ other: OSet) -> OSet {
        return copy(self) { (s: inout OSet) in s.formSymmetricDifference(other) }
    }

    /// Inserts new item at the end, if no such item is already present.
    ///
    /// - Parameter item: An item to insert.
    /// - Returns: `(true, item)` if item got inserted, `(false, existingItem)` if and equal
    ///   item already existed.
    @discardableResult
    public mutating func insert(_ item: E) -> (inserted: Bool, memberAfterInsert: E) {
        let (inserted, e) = self.s.insert(item)
        if inserted {
            self.a.append(item)
        }
        return (inserted, e)
    }

    /// Removes item.
    ///
    /// - Parameter item: An item to remove.
    /// - Returns: Removed item, if it existed, `nil` otherwise.
    @discardableResult
    public mutating func remove(_ item: E) -> E? {
        let e = self.s.remove(item)
        if e != nil {
            let i = self.a.index(of: item)
            self.a.remove(at: i!)
        }
        return e
    }

    /// Updates an existing item, or inserts a new one at the end, if it didn't exist.
    ///
    /// - Parameter item: Element to update or insert.
    /// - Returns: Old item, if it was updated, `nil` otherwise.
    @discardableResult
    public mutating func update(with item: E) -> E? {
        guard let existingItem = self.s.update(with: item) else {
            self.a.append(item)
            return nil
        }
        return existingItem
    }

    /// Performs `union` in place.
    public mutating func formUnion(_ other: OSet) {
        for item in other {
            self.insert(item)
        }
    }

    /// Performs `intersection` in place.
    public mutating func formIntersection(_ other: OSet) {
        for item in self {
            if !other.contains(item) {
                self.s.remove(item)
            }
        }
        self.a = self.a.filter({ self.s.contains($0) })
    }

    /// Performs `symmetricDifference` in place.
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

    /// Checks whether two OSets are equal.
    /// Note that this follows Array semantics, not Set ones, i.e
    /// OSets with the same items, but at different positions are
    /// reported as different.
    ///
    /// - Parameters:
    ///   - lhs: First OSet to compare.
    ///   - rhs: Second OSet to compare.
    /// - Returns: `true` if OSets are equal, `false` otherwise.
    public static func == (lhs: OSet, rhs: OSet) -> Bool {
        return lhs.a == rhs.a
    }

    /// Gets items that are only present in the first OSet and not the other.
    ///
    /// - Parameter other: An OSet to subtract with.
    /// - Returns: New OSet instance with items only present in the original one.
    public func subtracting(_ other: OSet) -> OSet {
        return copy(self) { (s: inout OSet) in s.subtract(other) }
    }

    /// Performs `subtracting` in place.
    public mutating func subtract(_ other: OSet) {
        for e in other {
            self.s.remove(e)
        }
        self.a = self.a.filter({ self.s.contains($0) })
    }

    // MARK: - SetAlgebra
    // MARK: Collection

    public typealias Iterator = IndexingIterator<[E]>

    /// Returns an iterator view to the collection.
    ///
    /// - Returns: New iterator instance.
    public func makeIterator() -> Iterator {
        return self.a.makeIterator()
    }

    /// The position of the first item in the OSet.
    public var startIndex: Int {
        return self.a.startIndex
    }

    /// The position *after* the last item in the OSet.
    public var endIndex: Int {
        return self.a.endIndex
    }

    /// Returns the position of item immediately after the given index.
    ///
    /// - Parameter after: An index valid for the current OSet instance.
    /// - Returns: An index immediately after `after`.
    public func index(after: Int) -> Int {
        return self.a.index(after: after)
    }

    /// Checks if OSet contains any items.
    ///
    /// - Returns: `true` if no items, `false`, otherwise.
    public var isEmpty: Bool {
        return self.a.isEmpty
    }

    /// Swaps two items' positions (in place).
    ///
    /// - Parameters:
    ///   - i: Index of the first item.
    ///   - j: Index of the second item.
    public mutating func swapAt(_ i: Int, _ j: Int) {
        guard i != j else {
            return
        }
        let tmp = self.a[i]
        self.a[i] = self.a[j]
        self.a[j] = tmp
    }

    /// Sorts the collection ascendingly, in place.
    public mutating func sort() {
        self.a.sort()
    }

    /// Sorts the collection in place, using given comparison predicate.
    public mutating func sort(by: (E, E) throws -> Bool) rethrows {
        try self.a.sort(by: by)
    }

    // MARK: - Collection
    // MARK: Subscript

    /// Gets or sets an item at the given index.
    /// Enables the `[]` notation.
    ///
    /// Note that Set, and OSet too, must not contain duplicates.
    /// Therefore, if one sets an item that's equal to another item
    /// already existing in the OSet, the old one will be removed.
    /// E.g.
    ///     let oset = OSet([1, 2, 3, 4])
    ///     oset[1] = 4
    ///     print(oset)
    ///     // Prints "OSet([1, 4, 3])"
    public subscript(index: Int) -> E {
        get {
            return self.a[index]
        }
        set(item) {
            let idx = self.a.index(of: item)

            self.s.remove(self.a[index])

            self.a[index] = item
            self.s.update(with: item)

            if idx != nil && idx! != index {
                self.a.remove(at: idx!)
            }
        }
    }

    // MARK: - Subscript
}

extension OSet: CustomStringConvertible {
    public var description: String {
        return "OSet(\(self.a))"
    }
}
