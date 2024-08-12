import Domain
import Foundation

public enum SignUpNewUserFormField: CaseIterable {
    case name
    case email
    case phone
}

public enum SignUpresult {
    case success
    case userAlreadyRegistered
    case noInternetConnection
}

public struct SignUpNewUserState {
    var form = SignUpNewUserForm()
    var signupResult: SignUpresult?
    
    var fieldErrors = [SignUpNewUserFormField: String]()
    var editingInputs = [SignUpNewUserFormField: Bool]()
    
    var positions = [Position]()
    
    var isNoInternetConnection = false
}

public struct SignUpNewUserForm {
    var name = ""
    var phone = ""
    var email = ""
    var position: Position?
    var photo: Data?
}
