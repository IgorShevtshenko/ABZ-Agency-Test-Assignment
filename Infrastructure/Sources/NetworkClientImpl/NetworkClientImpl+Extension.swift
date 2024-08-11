import Foundation
import NetworkClient
import Utils
import Combine

extension NetworkClientImpl {
    
    func prepareURL(
        path: String,
        queryItems: [URLQueryItem]
    ) throws -> URL {
        guard let url = url(applying: path, queryItems: queryItems) else {
            throw NetworkClientError.failedToGenerateURL(path)
        }
        return url
    }
    
    func url(
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

    func configureRequest(
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
