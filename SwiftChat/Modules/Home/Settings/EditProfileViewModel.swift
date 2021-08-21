//
//  EditProfileViewModel.swift
//  SwiftChat
//
//  Created by Tung Nguyen on 21/08/2021.
//

import Foundation
import UIKit

class EditProfileViewModel {
    func uploadImage(_ image: UIImage) {
        let fileDirectory = "Avatars/" + "_\(User.currentId)" + ".jpg"
        FileStorage.uploadImage(image, directory: fileDirectory) { avatarLink in
            if var user = User.currentUser {
                user.avatarLink = avatarLink ?? ""
                saveUserLocally(user)
                FirebaseUserListener.shared.saveUserToFireStore(user)
            }
        }
        
        //TODO: Save image locally
        FileStorage.saveFileLocally(fileData: image.jpegData(compressionQuality: 1.0)! as NSData, fileName: fileNameFrom(fileUrl: User.currentUser!.avatarLink))
    }
}
