import Domain

public protocol PhoneNumberService {
    func getPhoneNumber(by number: String) -> PhoneNumber?
}
