import Foundation

public struct User: Hashable, Identifiable {
    
    public let id: String
    public let name: String
    public let email: String
    public let phone: String
    public let photoUrl: URL?
    public let positionTitle: String
    public let registrationDate: Date
    
    public init(
        id: String,
        name: String,
        email: String,
        phone: String,
        photoUrl: URL?,
        positionTitle: String,
        registrationDate: Date
    ) {
        self.id = id
        self.name = name
        self.email = email
        self.phone = phone
        self.photoUrl = photoUrl
        self.positionTitle = positionTitle
        self.registrationDate = registrationDate
    }
}
