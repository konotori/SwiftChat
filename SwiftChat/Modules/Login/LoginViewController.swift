//
//  ViewController.swift
//  SwiftChat
//
//  Created by Tung Nguyen on 20/08/2021.
//

import UIKit
import ProgressHUD

private enum ValidatorType {
    case login
    case register
    case forgotPassword
}

class LoginViewController: UIViewController {
    
    //MARK: -- Outlets
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var repeatPasswordLabel: UILabel!
    @IBOutlet weak var signUpLabel: UILabel!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var resendEmailButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var repeatPasswordLineView: UIView!
    
    //MARK: -- Varibales
    
    var isLogin = true
    var viewModel: LoginViewModel?
    
    //MARK: -- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel = LoginViewModel()
        self.setupTextFieldDelegates()
        self.setupBackgroundTapped()
        self.updateUIFor(login: true)
    }
    
    //MARK: -- Setup
    private func setupTextFieldDelegates() {
        emailTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        repeatPasswordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        self.updatePlaceholderLabels(textField)
    }
    
    private func setupBackgroundTapped() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc func backgroundTapped() {
        self.view.endEditing(false)
    }
    
    //MARK: -- Actions
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        if isDataInputedFor(type: self.isLogin ? ValidatorType.login : ValidatorType.register) {
            guard let email = self.emailTextField.text,
                  let password = self.passwordTextField.text else { return }
            if isLogin {
                self.viewModel?.loginUser(email: email, password: password, completion: {
                    self.goToApp()
                })
            } else {
                self.viewModel?.registerUser(email: email, password: password) {
                    self.resendEmailButton.isHidden = false
                }
            }
        }
    }
    
    @IBAction func forgotPasswordButtonPressed(_ sender: Any) {
        if isDataInputedFor(type: ValidatorType.forgotPassword) {
            self.viewModel?.resetPassword(email: self.emailTextField.text!)
        }
    }
    
    @IBAction func resendEmailButtonPressed(_ sender: Any) {
        if isDataInputedFor(type: ValidatorType.forgotPassword) {
            self.viewModel?.resendVerificationEmail(email: self.emailTextField.text!)
        }
    }
    
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        self.updateUIFor(login: sender.titleLabel?.text == "Login")
        self.isLogin.toggle()
    }
    
    //MARK: -- Animations
    
    private func updatePlaceholderLabels(_ textField: UITextField) {
        switch textField {
        case self.emailTextField:
            self.emailLabel.text = self.emailTextField.hasText ? "Email" : ""
        case self.passwordTextField:
            self.passwordLabel.text = self.passwordTextField.hasText ? "Password" : ""
        case self.repeatPasswordTextField:
            self.repeatPasswordLabel.text = self.repeatPasswordTextField.hasText ? "Repeate Password" : ""
        default:
            break
        }
    }
    
    private func updateUIFor(login: Bool) {
        loginButton.setImage(UIImage(named: login ? "loginBtn" : "registerBtn"), for: .normal)
        signUpButton.setTitle(login ? "Sign Up" : "Login", for: .normal)
        signUpLabel.text = login ? "Don't have an account?" : "Have an account?"
        UIView.animate(withDuration: 0.5) {
            self.repeatPasswordTextField.isHidden = login
            self.repeatPasswordLabel.isHidden = login
            self.repeatPasswordLineView.isHidden = login
        }
    }
    
    //MARK: -- Helpers
    
    private func isDataInputedFor(type: ValidatorType) -> Bool {
        switch type {
        case .login:
            if self.emailTextField.text != "" && self.passwordTextField.text != "" {
                return true
            } else {
                ProgressHUD.showFailed("All fields are required")
            }
        case .register:
            if self.emailTextField.text != "" && self.passwordTextField.text != "" && self.repeatPasswordTextField.text != ""{
                if (self.passwordTextField.text == self.repeatPasswordTextField.text) {
                    return true
                } else {
                    ProgressHUD.showFailed("The password don't match")
                }
            } else {
                ProgressHUD.showFailed("All fields are required")
            }
        case .forgotPassword:
            if (self.emailTextField.text != "") {
                return true
            } else {
                ProgressHUD.showFailed("Email is required")
            }
        }
        
        return false
    }
    
    //MARK: - Navigation
    
    private func goToApp() {
        let homeView = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(identifier: "HomeView") as! UITabBarController
        homeView.modalPresentationStyle = .fullScreen
        self.present(homeView, animated: true, completion: nil)
    }
    
}

