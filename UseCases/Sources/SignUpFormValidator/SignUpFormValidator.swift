public enum SignUpFormField: CaseIterable {
    case name
    case phone
    case email
}

public struct SignUpForm {
    
    public let name: String
    public let phone: String
    public let email: String
    
    public init(name: String, phone: String, email: String) {
        self.name = name
        self.phone = phone
        self.email = email
    }
}

public struct SignUpFormFieldValidationResult {
    
    public let field: SignUpFormField
    public let error: String?
    
    public init(field: SignUpFormField, error: String?) {
        self.field = field
        self.error = error
    }
}

public protocol SignUpFormValidator {
    func validate(_ form: SignUpForm) -> [SignUpFormFieldValidationResult]
}
