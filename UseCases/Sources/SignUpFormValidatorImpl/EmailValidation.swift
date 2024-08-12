import Foundation

struct EmailValidation {

    private let types: NSTextCheckingResult.CheckingType = [.link]
    private let detector: NSDataDetector

    public init() {
        guard let dataDetector = try? NSDataDetector(types: types.rawValue) else {
            fatalError("Didn't get types of value")
        }
        detector = dataDetector
    }

    public func isValid(_ email: String) -> Bool {
        let range = NSRange(location: 0, length: email.count)
        let matches = detector.matches(in: email, options: [], range: range)

        guard let result = matches.first else {
            return false
        }
        guard result.url?.scheme == "mailto" else {
            return false
        }
        guard NSEqualRanges(result.range, range) else {
            return false
        }
        return true
    }
}
