public enum Tab: CaseIterable {
    case usersList
    case signUp
}

public struct CoreState {
    var activeTab: Tab = .usersList
}
