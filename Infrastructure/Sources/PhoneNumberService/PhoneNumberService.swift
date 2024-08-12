import Domain

public protocol PhoneNumberService {
    func getPhoneNumber(by number: String) -> PhoneNumber?
    func isValid(_ number: String) -> Bool
}
