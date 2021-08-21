//
//  SettingViewModel.swift
//  SwiftChat
//
//  Created by Tung Nguyen on 20/08/2021.
//

import Foundation

class SettingsViewModel {
    func logout(completion: @escaping () -> Void) {
        FirebaseUserListener.shared.logoutCurrentUser { error in
            if error == nil {
                completion()
            }
        }
    }
    
    
}
