import Architecture
import SwiftUI
import UILibrary
import SignUpFormValidator

public struct SignUpNewUserView: View {
    
    @ObservedObject private var viewModel: ViewModel<SignUpNewUserState, SignUpNewUserAction>
    
    public init(viewModel: ViewModel<SignUpNewUserState, SignUpNewUserAction>) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .center, spacing: 24) {
                VStack(alignment: .leading, spacing: 32) {
                    ForEach(fields, id: \.self) { field in
                        PrimaryTextField(
                            text: Binding(
                                get: { text(for: field) },
                                set: { viewModel.send(.changeInput(field, $0)) }
                            ),
                            isErrorActive: .constant(
                                viewModel.state.fieldErrors.first { $0.key == field } != nil
                            )
                        )
                        .updatePlaceholder(placeholder(for: field))
                        .updateSubtext(subtext(for: field))
                        .updateValidateInput { _ in viewModel.send(.validateField(field)) }
                        .updateContentType(field.textContentType)
                        .updateKeyboardType(field.keyboardType)
                    }
                }
                
                PositionPicker(
                    positions: viewModel.state.positions,
                    selectedPosition: Binding(
                        get: { viewModel.state.form.position },
                        set: { viewModel.send(.changePosition($0)) }
                    )
                )
            }
            .safeAreaPadding(.horizontal, 16)
            .safeAreaPadding(.vertical, 32)
        }
        .primaryNavBar(title: "Working with POST request")
        .primaryBackground()
        .fullScreenCover(item: .constant(viewModel.state.signupResult)) { result in
            Group {
                switch result {
                case .noInternetConnection:
                    NoInternetConnectionErrorView {
                        viewModel.send(.fetchPositions)
                    }
                case .userAlreadyRegistered:
                    Text("Asd")
                case .success:
                    Text("ASD")
                }
            }
            .primaryNavBar(title: "Working with POST request")
            .primaryBackground()
        }
    }
}

private extension SignUpNewUserView {
    
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

private extension SignUpFormField {
    
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
