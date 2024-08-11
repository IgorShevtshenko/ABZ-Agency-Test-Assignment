import Domain
import Foundation

public enum SignUpNewUserFormField {
    case name
    case phone
    case email
    case photo
}

public struct SignUpNewUserState {
    var form = SignUpNewUserForm()
}

public struct SignUpNewUserForm {
    var name = ""
    var phone = ""
    var email = ""
    var position: Position?
    var photo: Data?
}
