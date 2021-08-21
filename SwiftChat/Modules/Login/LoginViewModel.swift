//
//  LoginViewModel.swift
//  SwiftChat
//
//  Created by Tung Nguyen on 20/08/2021.
//

import Foundation
import ProgressHUD

class LoginViewModel {
     
    func loginUser(email: String, password: String, completion: @escaping () -> Void) {
        FirebaseUserListener.shared.loginUserWithEmal(email: email, password: password) { error, isEmailVerified in
            if error == nil {
                if isEmailVerified {
                    print("login")
                    completion()
                }
            } else {
                ProgressHUD.showFailed(error?.localizedDescription)
            }
        }
    }
    
    func registerUser(email: String, password: String, completion: @escaping () -> Void) {
        FirebaseUserListener.shared.registerUserWith(email: email, password: password) { error in
            if error == nil {
                ProgressHUD.showSuccess("Verification email sent.")
                completion()
            } else {
                ProgressHUD.showFailed(error?.localizedDescription)
            }
        }
    }
    
    func resetPassword(email: String) {
        FirebaseUserListener.shared.resetPasswordFor(email: email) { error in
            if error == nil {
                ProgressHUD.showSuccess("Reset link sent to email.")
            } else {
                ProgressHUD.showFailed(error!.localizedDescription)
            }
        }
    }
    
    func resendVerificationEmail(email: String) {
        FirebaseUserListener.shared.resendVerificationEmail(email: email) { error in
            if error == nil {
                ProgressHUD.showSuccess("New verification email sent.")
            } else {
                ProgressHUD.showFailed(error!.localizedDescription)
            }
        }
    }
}
