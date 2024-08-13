import Foundation
import NetworkClient
import AuthenticationTokenRepository

public final class AuthenticationTokenEndpointConfigurationDecorator: EndpointConfiguration {

    private let configuration: EndpointConfiguration
    private let authenticationTokenRepository: AuthenticationTokenRepository

    public init(
        configuration: EndpointConfiguration,
        authenticationTokenRepository: AuthenticationTokenRepository
    ) {
        self.configuration = configuration
        self.authenticationTokenRepository = authenticationTokenRepository
    }

    public func url(applying path: String, queryItems: [URLQueryItem]) -> URL? {
        configuration.url(applying: path, queryItems: queryItems)
    }

    public func configureRequest(url: URL, method: HTTPMethod, body: Data?) -> URLRequest {
        var request = configuration.configureRequest(url: url, method: method, body: body)
        if let token = authenticationTokenRepository.token {
            request.setValue(token, forHTTPHeaderField: "Token")
        }
        return request
    }
}
