public protocol AuthenticationTokenRepository {
    var token: String? { get }
    func updateToken(_ token: String)
}
