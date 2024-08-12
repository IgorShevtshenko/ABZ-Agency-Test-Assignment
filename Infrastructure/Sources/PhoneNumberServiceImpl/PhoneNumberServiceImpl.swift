import PhoneNumberKit
import PhoneNumberService
import Domain

public final class PhoneNumberServiceImpl: PhoneNumberService {
    
    private let phoneNumberKit = PhoneNumberKit()
    
    public init() {}
    
    public func getPhoneNumber(by number: String) -> Domain.PhoneNumber? {
        if let phoneNumber = try? phoneNumberKit.parse(number) {
            return Domain.PhoneNumber(
                callingCode: "+\(String(phoneNumber.countryCode))",
                phoneNumber: String(phoneNumber.nationalNumber)
            )
        }
        return nil
    }
    
    public func isValid(_ phone: String) -> Bool {
        phoneNumberKit.isValidPhoneNumber(phone)
    }
}
