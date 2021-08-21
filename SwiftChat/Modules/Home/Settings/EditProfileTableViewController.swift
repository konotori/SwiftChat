//
//  EditProfileTableViewController.swift
//  SwiftChat
//
//  Created by Tung Nguyen on 20/08/2021.
//

import UIKit
import Gallery
import ProgressHUD

class EditProfileTableViewController: UITableViewController {

    //MARK: - Outlets
    
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var usernameTextField: UITextField!
    
    //MARK: - Variable
    
    var gallery: GalleryController!
    var viewmodel: EditProfileViewModel!
    
    //MARK: - View Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureTextField()
        self.viewmodel = EditProfileViewModel()
        tableView.tableFooterView = UIView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.showUserInfo()
    }
    
    //MARK: - Table view Delegates
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor(named: "tableViewBackgroundColor")
        
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return section == 0 ? 0.0 : 30.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 1 && indexPath.row == 0 {
            performSegue(withIdentifier: "editProfileToStatusSeg", sender: self)
        }
    }
    
    //MARK: - Actions
    
    @IBAction func editButtonPressed(_ sender: Any) {
        showImageGallery()
    }
    
    //MARK: - UpdateUI
    
    private func showUserInfo() {
        if let user = User.currentUser {
            self.usernameTextField.text = user.username
            self.statusLabel.text = user.status
        
            if user.avatarLink != "" {
                FileStorage.downloadImage(imageUrl: user.avatarLink) { image in
                    DispatchQueue.main.async {
                        self.avatarImage.image = image?.circleMasked
                    }
                }
                
            }
        }
    }
    
    //MARK: - Configure
    
    private func configureTextField() {
        self.usernameTextField.delegate = self
        self.usernameTextField.clearButtonMode = .whileEditing
    }
    
    //MARK: - Gallery
    
    private func showImageGallery() {
        self.gallery = GalleryController()
        self.gallery.delegate = self
        
        Config.tabsToShow = [.imageTab, .cameraTab]
        Config.Camera.imageLimit = 1
        Config.initialTab = .imageTab
        
        self.present(self.gallery, animated: true, completion: nil)
    }

}

extension EditProfileTableViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.usernameTextField {
            if textField.text != "" {
                if var user = User.currentUser {
                    user.username = textField.text!
                    saveUserLocally(user)
                    FirebaseUserListener.shared.saveUserToFireStore(user)
                }
            }
            textField.resignFirstResponder()
            return false
        }
        return true
    }
}

extension EditProfileTableViewController: GalleryControllerDelegate {
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        if images.count > 0 {
            images.first!.resolve { avatarImage in
                if avatarImage != nil {
                    self.viewmodel.uploadImage(avatarImage!)
                    self.avatarImage.image = avatarImage
                } else {
                    ProgressHUD.showError("Couldn't select image.")
                }
            }
        }
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryController(_ controller: GalleryController, didSelectVideo video: Video) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryController(_ controller: GalleryController, requestLightbox images: [Image]) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryControllerDidCancel(_ controller: GalleryController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
}
