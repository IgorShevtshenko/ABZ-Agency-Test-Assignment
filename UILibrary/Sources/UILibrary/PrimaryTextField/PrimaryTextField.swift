import SwiftUI
import Utils

struct KeyboardConfiguration {
    var contentType: UITextContentType?
    var keyboardType: UIKeyboardType?
}

struct TextFieldConfiguration {
    var subtext: String?
    var placeholder = ""
    var validateInput: (String) -> Void = { _ in }
}

public struct PrimaryTextField: View {
    
    private var keyboardConfiguration = KeyboardConfiguration()
    private var textFieldConfiguration = TextFieldConfiguration()
    
    @Binding private var text: String
    @Binding private var isErrorActive: Bool
    @FocusState private var isFocused: Bool
    
    @StateObject private var textFieldValidation: TextFieldValidation
    
    public init(text: Binding<String>, isErrorActive: Binding<Bool>) {
        _text = text
        _isErrorActive = isErrorActive
        _textFieldValidation = StateObject(wrappedValue: TextFieldValidation())
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            TextField("", text: $text.removeDuplicates())
                .focused($isFocused)
                .modifier(
                    TextFieldConfigurationViewModifier(keyboardConfiguration: keyboardConfiguration)
                )
                .padding(.top, isPlaceholderActive ? 22 : 16)
                .padding(.bottom, isPlaceholderActive ? 8 : 16)
                .modifier(
                    TextFieldPlaceholderModifier(
                        placeholder: textFieldConfiguration.placeholder,
                        foregroundColor: placeholderColor,
                        isActivePlaceholder: isPlaceholderActive
                    )
                )
                .padding(.leading, 16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(borderColor, lineWidth: isFocused && !isErrorActive ? 2 : 1)
                )
            if let subtext = textFieldConfiguration.subtext {
                Text(subtext)
                    .font(.body4)
                    .foregroundStyle(!isErrorActive ? Color.secondaryLabel : .negative)
                    .padding(.horizontal, 16)
            }
        }
        .onChange(of: text) { _, _ in
            textFieldValidation.inputChange()
        }
        .onChange(of: isFocused) { _, isFocused in
            if !isFocused {
                textFieldValidation.resignTextField()
            }
        }
        .onReceive(textFieldValidation.onValidationUpdate) { _ in
            textFieldConfiguration.validateInput(text)
        }
        .animation(.default, value: isPlaceholderActive)
    }
    
    public func updatePlaceholder(_ placeholder: String) -> Self {
        updateView { view in
            view.textFieldConfiguration.placeholder = placeholder
        }
    }
    
    public func updateSubtext(_ text: String?) -> Self {
        updateView { view in
            view.textFieldConfiguration.subtext = text
        }
    }
    
    public func updateContentType(_ type: UITextContentType) -> Self {
        updateView { view in
            view.keyboardConfiguration.contentType = type
        }
    }
    
    public func updateKeyboardType(_ type: UIKeyboardType) -> Self {
        updateView { view in
            view.keyboardConfiguration.keyboardType = type
        }
    }
    
    public func updateValidateInput(content: @escaping (String) -> Void) -> Self {
        updateView { $0.textFieldConfiguration.validateInput = content }
    }
    
    private func updateView(_ update: (inout Self) -> Void) -> Self {
        var view = self
        update(&view)
        return view
    }
}

private extension PrimaryTextField {
    
    var borderColor: Color {
        guard !isErrorActive else {
            return .negative
        }
        return isFocused ? .secondaryColor : .inactiveTextField
    }
    
    var placeholderColor: Color {
        guard !isErrorActive else {
            return .negative
        }
        return isFocused ? .secondaryColor : .disabledLabel
    }
    
    var isPlaceholderActive: Bool {
        isFocused || !text.isEmpty
    }
}

private struct TextFieldConfigurationViewModifier: ViewModifier {
    
    private let keyboardConfiguration: KeyboardConfiguration
    
    init(keyboardConfiguration: KeyboardConfiguration) {
        self.keyboardConfiguration = keyboardConfiguration
    }
    
    func body(content: Content) -> some View {
        content
            .autocorrectionDisabled(true)
            .font(.body1)
            .foregroundColor(.primaryLabel)
            .keyboardType(keyboardConfiguration.keyboardType ?? .default)
            .textInputAutocapitalization(.never)
            .textContentType(keyboardConfiguration.contentType)
    }
}
