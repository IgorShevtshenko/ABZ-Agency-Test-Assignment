import Foundation
import Domain
import Utils

extension UserResponseEntity {
    
    var asPaginatedArray: PaginatedArray<User> {
        PaginatedArray(
            elements: users.compactMap(User.init),
            cursor: page >= total_pages ? .end : .page(page)
        )
    }
}

private extension User {
    
    init?(from entity: UserEntity) {
        self = User(
            id: "\(entity.id)",
            name: entity.name,
            email: entity.email,
            phone: entity.phone,
            photoUrl: URL(string: entity.photo),
            positionTitle: entity.position,
            registrationDate: Date(timeIntervalSince1970: Double(entity.registration_timestamp))
        )
    }
}
