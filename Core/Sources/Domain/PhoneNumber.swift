public struct PhoneNumber: Hashable {

    public let callingCode: String
    public let phoneNumber: String
    
    public init(callingCode: String, phoneNumber: String) {
        self.callingCode = callingCode
        self.phoneNumber = phoneNumber
    }
    
    public func getFullPhoneNumber() -> String {
        "\(callingCode) \(phoneNumber)"
    }
}
