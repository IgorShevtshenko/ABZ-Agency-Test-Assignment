import Domain
import Foundation
import SignUpFormValidator

public enum SignUpresult: Identifiable {
    case success
    case userAlreadyRegistered
    case noInternetConnection
    
    public var id: Self {
        self
    }
}

public struct SignUpNewUserState {
    var form =  SignUpNewUserFormPayload()
    var signupResult: SignUpresult?
    
    var fieldErrors = [SignUpFormField: String]()
    var editingInputs = [SignUpFormField: Bool]()
    
    var positions = [Position]()
    
    var isNoInternetConnection = false
}

public struct SignUpNewUserFormPayload {
    var name = ""
    var phone = ""
    var email = ""
    var position: Position?
    var photo: Data?
}
