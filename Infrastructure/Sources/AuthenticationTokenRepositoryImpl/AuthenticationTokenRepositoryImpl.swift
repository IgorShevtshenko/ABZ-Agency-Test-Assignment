import AuthenticationTokenRepository

public final class AuthenticationTokenRepositoryImpl: AuthenticationTokenRepository {
    
    public var token: String?
    
    public init() {}
    
    public func updateToken(_ token: String) {
        self.token = token
    }
}
