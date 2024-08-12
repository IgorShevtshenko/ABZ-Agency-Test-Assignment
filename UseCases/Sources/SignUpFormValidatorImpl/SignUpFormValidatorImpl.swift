import SignUpFormValidator
import PhoneNumberService

public struct SignUpFormValidatorImpl: SignUpFormValidator {
    
    private let emailValidation: EmailValidation
    private let phoneNumberService: PhoneNumberService
    
    public init(phoneNumberService: PhoneNumberService) {
        self.emailValidation = EmailValidation()
        self.phoneNumberService = phoneNumberService
    }
    
    public func validate(_ form: SignUpForm) -> [SignUpFormFieldValidationResult] {
        SignUpFormField.allCases
            .reduce(into: [SignUpFormFieldValidationResult]()) { result, field in
                let fieldValue = form.value(for: field)
                if let isRequiredValidation = validateForAbsence(
                    field: field,
                    value: fieldValue
                ) {
                    result.append(isRequiredValidation)
                }
                switch field {
                case .name:
                    result.append(validateName(fieldValue))
                case .phone:
                    result.append(validatePhone(fieldValue))
                case .email:
                    result.append(validateEmail(fieldValue))
                }
        }
    }
    
    private func validateForAbsence(
        field: SignUpFormField,
        value: String
    ) -> SignUpFormFieldValidationResult? {
        guard !value.isEmpty else {
            return SignUpFormFieldValidationResult(
                field: field,
                error: "Required field"
            )
        }
        return nil
    }
    private func validateName(_ name: String) -> SignUpFormFieldValidationResult {
        SignUpFormFieldValidationResult(
            field: .name,
            error: (2..<60).contains(name.count) ? nil : "Username should contain 2-60 characters"
        )
    }
    
    private func validatePhone(_ phone: String) -> SignUpFormFieldValidationResult {
        SignUpFormFieldValidationResult(
            field: .phone,
            error: phoneNumberService.isValid(phone) ? nil : "Invalid phone number"
        )
    }
    
    private func validateEmail(_ email: String) -> SignUpFormFieldValidationResult {
        SignUpFormFieldValidationResult(
            field: .email,
            error: emailValidation.isValid(email) ? nil : "Invalid email"
        )
    }
}

private extension SignUpForm {
    
    func value(for field: SignUpFormField) -> String {
        switch field {
        case .name:
            name
        case .phone:
            phone
        case .email:
            email
        }
    }
}
