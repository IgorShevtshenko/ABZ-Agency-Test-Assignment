import Foundation

public protocol EndpointConfiguration {
    func url(applying path: String, queryItems: [URLQueryItem]) -> URL?
    func configureRequest(url: URL, method: HTTPMethod, body: Data?) -> URLRequest
}
