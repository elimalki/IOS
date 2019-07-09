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
    var authController: AuthController = AuthController(typeAuth: .login)
    
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
    
        hideNavBar()
        setupDelegates()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        unsubscribeDelegates()
    }
    
    private func setupUI(){
        UI.addElementsToSuperView()
    }
    
    private func setupActions(){
        UI.buttonLogin.addTarget(self, action: #selector(loginAction), for: .touchUpInside)
        UI.dontRegisterButton.addTarget(self, action: #selector(registrationAction), for: .touchUpInside)
        UI.forgotPasswordButton.addTarget(self, action: #selector(forgotPaswordAction), for: .touchUpInside)
    }
    
    private func setupDelegates(){
        addKeyboardCheckStateForSuperScroll()
        authController.delegate = self
    }
    
    private func unsubscribeDelegates(){
        authController.delegate = self
        NotificationCenter.default.removeObserver(self)
    }
    
    private func redirectToMenu(){
        navigationController?.pushViewController(MenuViewController(), animated: true)
    }
    
    private func setAuthDataIfExist(){
        (UI.fieldsStackView.arrangedSubviews as? [AuthFieldView])?.first{ $0.typeOfAuthField == .email }?.textField.text = UserDefaults.standard.string(forKey: "aurhEmail")
        (UI.fieldsStackView.arrangedSubviews as? [AuthFieldView])?.first{ $0.typeOfAuthField == .password }?.textField.text = UserDefaults.standard.string(forKey: "authPassword")
    }
    
    private func tryAutoLogin(){
        authController.tryAutoAuth()
    }
    
    private func showAllertResetPassword(with message: String = "Enter you account email."){
        showAlertWith(textField: "Enter email", message: message, okTitle: "Accept", cancelTitle: "Cancel", complite: { (code) in
            
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
        UI.superView.endEditing(true)
        authController.tryAuth(with: UI.authFields)
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
        UI.buttonLogin.showSpinner(spinnerStyle: .gray)
    }
    
    func successAuth() {
        UI.buttonLogin.hideSpinner()
        redirectToMenu()
    }
    
    func failAuth(_ error: String?) {
        showOkAlert(and: error)
        UI.buttonLogin.hideSpinner()
    }
    
    func failAutoAuth(_ error: String?) {
        UI.buttonLogin.hideSpinner()
    }
    //MARK: - reset password
    
    func successResetPassword(to email: String) {
        UI.forgotPasswordButton.hideSpinner()
        showOkAlert(and: "We send messag to: \(email).")
    }
    
    func failResetPassword(_ error: String?) {
        showOkAlert(and: error)
        UI.forgotPasswordButton.hideSpinner()
    }
}
