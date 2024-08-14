import Architecture
import SwiftUI
import UILibrary
import SignUpFormValidator

public struct SignUpNewUserView: View {
    
    @ObservedObject private(set) var viewModel: ViewModel<SignUpNewUserState, SignUpNewUserAction>
    
    public init(viewModel: ViewModel<SignUpNewUserState, SignUpNewUserAction>) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .center, spacing: 36) {
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
                    
                    PhotoPicker(
                        photo: Binding(
                            get: { viewModel.state.form.photo },
                            set: { viewModel.send(.changePhoto($0)) }
                        )
                    )
                }
                Button("Sign up") {
                    viewModel.send(.signUp)
                }
                .buttonStyle(.primary)
                .disabled(!viewModel.state.isEligableToSignUp)
            }
            .safeAreaPadding(.horizontal, 16)
            .safeAreaPadding(.vertical, 32)
        }
        .overlay {
            if viewModel.state.isNoInternetConnection {
                NoInternetConnectionErrorView {
                    viewModel.send(.fetchPositions)
                }
                .primaryBackground()
            }
        }
        .animation(.default, value: viewModel.state.isNoInternetConnection)
        .primaryNavBar(title: "Working with POST request")
        .primaryBackground()
        .scrollDismissesKeyboard(.interactively)
        .fullScreenCover(
            item: Binding(
                get: { viewModel.state.signupResult },
                set:  { _ in viewModel.send(.cancelResultView) }
        )
        ) { result in
            Group {
                switch result {
                case .noInternetConnection:
                    NoInternetConnectionErrorView {
                        viewModel.send(.signUp)
                    }
                case .userAlreadyRegistered:
                    SignUpResultView(
                        title: "User with this phone or email already registered",
                        image: .failedSignUp,
                        buttonTitle: "Try again",
                        action: { viewModel.send(.cancelResultView) }
                    )
                case .success:
                    SignUpResultView(
                        title: "User successfully registered",
                        image: .successfulSignUp,
                        buttonTitle: "Got it",
                        action: { viewModel.send(.cancelResultView) }
                    )
                }
            }
            .primaryBackground()
        }
    }
}
