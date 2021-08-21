//
//  SettingsTableViewController.swift
//  SwiftChat
//
//  Created by Tung Nguyen on 20/08/2021.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var avatarImage: UIImageView!
    
    //MARK: - Variables
    var viewmodel: SettingsViewModel?
    
    
    //MARK: - View Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewmodel = SettingsViewModel()
        tableView.tableFooterView = UIView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.showUserInfo()
    }
    
    //MARK: - Actions
    
    @IBAction func tellAFriendButtonPressed(_ sender: Any) {
        
    }
    
    @IBAction func termAndConditionsButtonPressed(_ sender: Any) {
        
    }
    
    @IBAction func logoutBUttonPressed(_ sender: Any) {
        self.viewmodel?.logout {
            let loginView = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "loginView")
            loginView.modalPresentationStyle = .fullScreen
            
            DispatchQueue.main.async {
                self.present(loginView, animated: true, completion: nil)
            }
        }
    }
    
    //MARK: - UpdateUI
    
    private func showUserInfo() {
        if let user = User.currentUser {
            self.usernameLabel.text = user.username
            self.statusLabel.text = user.status
            self.versionLabel.text = "App version \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] ?? "")"
            if user.avatarLink != "" {
                FileStorage.downloadImage(imageUrl: user.avatarLink) { image in
                    DispatchQueue.main.async {
                        self.avatarImage.image = image?.circleMasked
                    }
                }
                
            }
        }
    }
    
    //MARK: - Table view Delegates
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor(named: "tableViewBackgroundColor")
        
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0.0 : 10.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 && indexPath.row == 0  {
            performSegue(withIdentifier: "settingsToEditProfileSeg", sender: self)
        }
    }
    
}
