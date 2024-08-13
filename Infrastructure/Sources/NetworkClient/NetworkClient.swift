import Foundation
import Utils
import Combine

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

public protocol NetworkClient {
    
    func execute<RequestBody: Encodable, ResponseBody: Decodable>(
        method: HTTPMethod,
        path: String,
        queryItems: [URLQueryItem],
        body: RequestBody?,
        responseType: ResponseBody.Type
    ) -> AnyPublisher<ResponseBody, Error>
}

public extension NetworkClient {
    
    func get<ResponseBody: Decodable>(
        _ responseType: ResponseBody.Type,
        path: String,
        queryItems: [URLQueryItem]
    ) -> AnyPublisher<ResponseBody, Error> {
        execute(
            method: .get,
            path: path,
            queryItems: queryItems,
            body: EmptyRequestEntity?.none,
            responseType: responseType
        )
    }
    
    func get<ResponseBody: Decodable>(
        _ responseType: ResponseBody.Type,
        path: String
    ) -> AnyPublisher<ResponseBody, Error> {
        execute(
            method: .get,
            path: path,
            queryItems: [],
            body: EmptyRequestEntity?.none,
            responseType: responseType
        )
    }
    
    func post(
        _ requestBody: some Encodable,
        path: String
    ) -> Completable<Error> {
        execute(
            method: .post,
            path: path,
            queryItems: [],
            body: requestBody,
            responseType: EmptyResponseEntity.self
        )
        .ignoreOutput()
        .eraseToAnyPublisher()
    }
}

private struct EmptyRequestEntity: Encodable {}
private struct EmptyResponseEntity: Decodable {}
