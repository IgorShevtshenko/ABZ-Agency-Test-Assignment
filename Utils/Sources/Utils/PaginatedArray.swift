public enum Cursor: Hashable {
    case end
    case page(Int)
}

public struct PaginatedArray<Element: Hashable>: Equatable {

    public let elements: [Element]
    public let cursor: Cursor

    public init(elements: [Element], cursor: Cursor) {
        self.elements = elements
        self.cursor = cursor
    }
}
