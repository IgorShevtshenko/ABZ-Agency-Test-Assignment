import NetworkClient
import Foundation

public struct EndpointConfigurationImpl: EndpointConfiguration {
    
    public init() {}
    
    public func url(
        applying path: String,
        queryItems: [URLQueryItem]
    ) -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "frontend-test-assignment-api.abz.agency"
        components.path = "/api/v1/\(path)"
        components.queryItems = queryItems
        return components.url
    }

    public func configureRequest(
        url: URL,
        method: HTTPMethod,
        body: Data?
    ) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = body
        return request
    }
}
