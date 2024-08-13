import SwiftUI
import UILibrary

@main
struct ABZ_Agency_Test_AssignmentApp: App {
    
    init() {
        Font.registerFonts()
    }
    
    var body: some Scene {
        WindowGroup {
//            UsersListComponent().makeUsersList()
            SignUpNewUserComponent().makeSignUpNewUser()
        }
    }
}
