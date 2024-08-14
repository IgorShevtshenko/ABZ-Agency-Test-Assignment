import Domain
import Foundation
import SignUpFormValidator
import SignUp

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

extension SignUpNewUserState {
    
    var isEligableToSignUp: Bool {
        fieldErrors.isEmpty && completedForm != nil && editingInputs.allSatisfy{ !$0.value }
    }
    
    var completedForm: SignUpForm? {
        guard
            let position = form.position,
            let photo = form.photo
        else {
            return nil
        }
        return SignUpForm(
            name: form.name,
            phone: form.phone,
            email: form.email,
            position: position,
            photo: photo
        )
    }
}
