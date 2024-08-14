import Domain
import Foundation
import SignUpFormValidator

enum SignUpNewUserEvent {
    case didChangeInput(SignUpFormField, String)
    case didFinishEditingField(SignUpFormField)
    case didChangeValidation(String, SignUpFormField)
    case didDropValidation(SignUpFormField)
    
    case didChangeAvailablePositions([Position])
    case didChangePosition(Position?)
    
    case didChangePhoto(Data?)
    
    case didRecevieNoInternetConnection
    
    case didFinishSignUp
    case didRecieveErrorUserAlreadyExists
    case didRecieveNoInternetConnectionForSignUp
    case didCancelResultView
}
