//
//  LoginViewController.swift
//  Talinor
//
//  Created by Taras Kibitkin on 20/06/2019.
//  Copyright © 2019 Taras Kibitkin. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController{
    
    lazy var UI = UILoginView(superView: self.view)
    var authController: AuthController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupActions()
        setupDelegates()
        setAuthDataIfExist()
        tryAutoLogin()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        authController?.delegate = self
        hideNavBar()
        addKeyboardCheckStateForSuperScroll()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        authController?.delegate = nil
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupUI(){
        UI.addElementsToSuperView()
    }
    
    private func setupActions(){
        UI.buttonLogin.addTarget(self, action: #selector(loginAction), for: .touchUpInside)
        UI.dontRegisterButton.addTarget(self, action: #selector(registrationAction), for: .touchUpInside)
        UI.forgotPasswordButton.addTarget(self, action: #selector(forgotPaswordAction), for: .touchUpInside)
    }
    
    private func setupDelegates(){}
    
    private func redirectToMenu(){
        navigationController?.pushViewController(MenuViewController(), animated: true)
    }
    
    private func setAuthDataIfExist(){
        (UI.fieldsStackView.arrangedSubviews as? [AuthFieldView])?.first{ $0.typeOfAuthField == .email }?.textField.text = UserDefaults.standard.string(forKey: "aurhEmail")
        (UI.fieldsStackView.arrangedSubviews as? [AuthFieldView])?.first{ $0.typeOfAuthField == .password }?.textField.text = UserDefaults.standard.string(forKey: "authPassword")
    }
    
    private func tryAutoLogin(){
        guard let authFields = UI.fieldsStackView.arrangedSubviews as? [AuthFieldView] else { return }
        
        authController = AuthController(authFields: authFields, typeAuth: .login)
        authController.delegate = self
        authController.checkActualLogin()
    }
    
    private func showAllertResetPassword(with message: String = "Enter you account email."){
        showAlertWith(textField: "Enter email", message: "Enter you account email.", okTitle: "Accept", cancelTitle: "Cancel", complite: { (code) in
            guard let email = code else { return }
            guard let error = AuthValidator.validate(field: .email, text: email) else {
                self.authController.resetPassword(with: email)
                self.UI.forgotPasswordButton.showSpinner()
                return
            }
            self.showAllertResetPassword(with: "\(error) Try Again.")
        }, failed: {})
    }
    
    @objc func loginAction(){
        authController.tryAuthWithNewCredentials()
    }
    
    @objc func registrationAction(){
        let vc = RegistrationViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func forgotPaswordAction(){
        showAllertResetPassword()
    }
}

extension LoginViewController: AuthControllerDelegate{
    
    func startAuth() {
        UI.buttonLogin.showSpinner()
    }
    
    func successAuth() {
        UI.buttonLogin.hideSpinner()
        redirectToMenu()
    }
    
    func failAuth(_ error: String?) {
        showOkAlert(and: error)
        UI.buttonLogin.hideSpinner()
    }
    
    //MARK: - reset password
//    func sendResetPasswordCode() {
//        showAlertWithField(textField: "Enter code", message: "We send code in you email. Write under.") { (code) in
//            guard let code = code else { return }
//
//            self.showAlertWithField(textField: "Enter new password", message: "Write new password.", complite: { (newPassword) in
//                guard let newPassword = newPassword else { return }
//
//                self.authController.confirmPasswordReset(with: code, and: newPassword)
//            })
//        }
//    }
    
    func successResetPassword(to email: String) {
        UI.forgotPasswordButton.hideSpinner()
        showOkAlert(and: "We send messag to \(email).")
    }
    
    func failResetPassword(_ error: String?) {
        showOkAlert(and: error)
        UI.forgotPasswordButton.hideSpinner()
    }

//
//    func failResetPasswordCode(_ error: String?) {
//        let vc = UIAlertController(title: "Fail", message: (error ?? "") + "\n", preferredStyle: .alert)
//        vc.addAction(UIAlertAction(title: "Send code again.", style: .default, handler: { (_) in
//            self.sendResetPasswordCode()
//        }))
//
//
//        present(vc, animated: true, completion: nil)
//    }
//
//    func failResetPasswordEmail(_ error: String?) {
//
//    }
}
