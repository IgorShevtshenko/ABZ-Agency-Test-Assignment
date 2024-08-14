import Domain
import Utils
import Foundation

public struct SignUpForm {
    public let name: String
    public let phone: String
    public let email: String
    public let position: Position
    public let photo: Data
    
    public init(name: String, phone: String, email: String, position: Position, photo: Data) {
        self.name = name
        self.phone = phone
        self.email = email
        self.position = position
        self.photo = photo
    }
}

public enum SignUpError: Error {
    case noInternetConnection
    case general
    case userAlreadyExists
}

public protocol SignUp {
    func callAsFunction(using form: SignUpForm) -> Completable<SignUpError>
}
