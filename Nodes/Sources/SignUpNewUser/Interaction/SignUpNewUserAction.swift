import Domain
import Foundation
import SignUpFormValidator

public enum SignUpNewUserAction {
    
    case changeInput(SignUpFormField, String)
    case validateField(SignUpFormField)
    
    case changePosition(Position?)
    
    case changePhoto(Data?)
    
    case fetchPositions
    
    case signUp
    
    case cancelResultView
}
