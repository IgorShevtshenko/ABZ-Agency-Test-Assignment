public enum SignUpFormField: CaseIterable {
    case name
    case phone
    case email
}

public protocol SignUpFormValidator {
    
    func validate(field: SignUpFormField, for input: String) -> String?
}
