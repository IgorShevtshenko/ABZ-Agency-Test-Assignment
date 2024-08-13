import SignUpFormValidator
import PhoneNumberService
import Foundation

public struct SignUpFormValidatorImpl: SignUpFormValidator {
    
    private let phoneNumberService: PhoneNumberService
    
    public init(phoneNumberService: PhoneNumberService) {
        self.phoneNumberService = phoneNumberService
    }
    
    public func validate(field: SignUpFormField, for input: String) -> String? {
        if let isRequiredValidation = validateForAbsence(value: input) {
            return isRequiredValidation
        }
        switch field {
        case .name:
            return validateName(input)
        case .phone:
            return validatePhone(input)
        case .email:
            return validateEmail(input)
        }
    }
    
    private func validateForAbsence(
        value: String
    ) -> String? {
        !value.isEmpty ? nil : "Required field"
    }
    private func validateName(_ name: String) -> String? {
        (2...60).contains(name.count) ? nil : "Username should contain 2-60 characters"
    }
    
    private func validatePhone(_ phone: String) -> String? {
        phoneNumberService.isValid(phone) ? nil : "Invalid phone number"
    }
    
    private func validateEmail(_ email: String) -> String? {
        let emailRegex = "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,64}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES[c] %@", emailRegex)
        return emailPredicate.evaluate(with: email) ? nil : "Invalid email"
    }
}
