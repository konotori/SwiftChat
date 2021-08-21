//
//  UsersViewModel.swift
//  SwiftChat
//
//  Created by Tung Nguyen on 21/08/2021.
//

import Foundation

class UsersViewModel {
    var allUsers: [User] = []
    
    func downloadUser(completion: @escaping () -> Void) {
        FirebaseUserListener.shared.downloadAlluserFromFirebase { users in
            self.allUsers = users
            completion()
        }
    }
}
