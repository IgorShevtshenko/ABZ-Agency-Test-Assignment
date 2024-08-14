import SignUpFormValidator
import SwiftUI

extension SignUpNewUserView {
    
    var fields: [SignUpFormField] {
        SignUpFormField.allCases.sorted { $0.order < $1.order }
    }
    
    func placeholder(for field: SignUpFormField) -> String {
        switch field {
        case .name:
            "Your name"
        case .email:
            "Email"
        case .phone:
            "Phone"
        }
    }
    
    func subtext(for field: SignUpFormField) -> String? {
        let errorForField = viewModel.state.fieldErrors.first { $0.key == field }
        guard errorForField == nil else {
            return errorForField?.value
        }
        switch field {
        case .name, .email:
            return nil
        case .phone:
            return "+380 (XXX) XXX - XX - XX"
        }
    }
    
    func text(for field: SignUpFormField) -> String {
        switch field {
        case .name:
            viewModel.state.form.name
        case .email:
            viewModel.state.form.email
        case .phone:
            viewModel.state.form.phone
        }
    }
}

extension SignUpFormField {
    
    var order: Int {
        switch self {
        case .name:
            0
        case .email:
            1
        case .phone:
            2
        }
    }
    
    var textContentType: UITextContentType {
        switch self {
        case .name:
                .name
        case .phone:
                .telephoneNumber
        case .email:
                .emailAddress
        }
    }
    
    var keyboardType: UIKeyboardType {
        switch self {
        case .name:
                .default
        case .phone:
                .phonePad
        case .email:
                .emailAddress
        }
    }
}

