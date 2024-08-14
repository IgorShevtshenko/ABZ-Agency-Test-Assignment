import NetworkClient
import AuthenticationTokenRepository
import Foundation
import Combine

public struct AuthenticationNetworkClientDecorator: NetworkClient {
    
    private let client: NetworkClient
    private let authenticationTokenRepository: AuthenticationTokenRepository
    
    public init(client: NetworkClient, authenticationTokenRepository: AuthenticationTokenRepository) {
        self.client = client
        self.authenticationTokenRepository = authenticationTokenRepository
    }
    
    public func execute<RequestBody, ResponseBody>(
        method: HTTPMethod,
        path: String,
        queryItems: [URLQueryItem],
        body: RequestBody?,
        responseType: ResponseBody.Type
    ) -> AnyPublisher<ResponseBody, any Error> where RequestBody : Encodable, ResponseBody : Decodable {
        getToken()
            .handleEvents(receiveOutput: { authenticationTokenRepository.updateToken($0) })
            .flatMap { _ in
                client.execute(
                    method: method,
                    path: path,
                    queryItems: queryItems,
                    body: body,
                    responseType: responseType
                )
            }
            .eraseToAnyPublisher()
    }
    
    private func getToken() -> AnyPublisher<String, Error> {
        client.get(TokenResponse.self, path: "token")
            .map(\.token)
            .eraseToAnyPublisher()
    }
}

private struct TokenResponse: Decodable {
    let token: String
}
