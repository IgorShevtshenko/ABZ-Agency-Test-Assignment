import Foundation
import Utils
import NetworkClient
import Combine

private struct ErrorResponse: Decodable, Error {
    let message: String
}

public struct NetworkClientImpl: NetworkClient {
    
    private let session: URLSession
    private let requestSerializer: RequestSerializer
    private let responseSerializer: ResponseSerializer
    
    public init(
        session: URLSession,
        requestSerializer: RequestSerializer,
        responseSerializer: ResponseSerializer
    ) {
        self.session = session
        self.requestSerializer = requestSerializer
        self.responseSerializer = responseSerializer
    }
    
    public func execute<RequestBody, ResponseBody>(
        method: HTTPMethod,
        path: String,
        queryItems: [URLQueryItem],
        body: RequestBody?,
        responseType: ResponseBody.Type
    ) -> AnyPublisher<ResponseBody, any Error> where RequestBody : Encodable, ResponseBody : Decodable {
        let url: URL
        do {
            url = try prepareURL(path: path, queryItems: queryItems)
        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }
        return prepareRequest(
            method: method,
            url: url,
            body: body
        )
        .flatMap { request in
            session.dataTaskPublisher(for: request).mapError { $0 as Error }
        }
        .mapError(\.identifiedConnectionError)
        .tryMap { try $1.validate(data: $0) }
        .receive(on: DispatchQueue.main)
        .tryMap { data in
            try responseSerializer.decode(ResponseBody.self, from: data)
        }
        .eraseToAnyPublisher()
    }
}

private extension NetworkClientImpl {
    
    func prepareRequest(
        method: HTTPMethod,
        url: URL,
        body: (some Encodable)?
    ) -> AnyPublisher<URLRequest, Error> {
        Deferred {
            try requestSerializer.configureContentType(
                on: configureRequest(
                    url: url,
                    method: method,
                    body: body.map(requestSerializer.encode)
                )
            )
        }
        .eraseToAnyPublisher()
    }
}

private extension URLResponse {

    func validate(data: Data) throws -> Data {
        guard let response = self as? HTTPURLResponse else {
            fatalError("Could not downcast response")
        }
        guard (200...299).contains(response.statusCode) else {
            print("NetworkClient received negative statusCode: \(response)")
            guard let errorBody = try? JSONDecoder().decode(ErrorResponse.self, from: data) else {
                throw NetworkClientError.invalidStatusCode(response.statusCode)
            }
            throw NetworkClientError.externalError(errorBody)
        }
        return data
    }
}


private extension Error {

    var identifiedConnectionError: Error {
        if (self as NSError).code == URLError.Code.notConnectedToInternet.rawValue {
            return NetworkClientError.noInternetConnection
        } else {
            return self
        }
    }
}
