protocol Component {
    associatedtype Parent
    var parent: Parent { get }
}

extension Component where Parent == Never {
    var parent: Never { fatalError("Shouldn't be caller") }
}
