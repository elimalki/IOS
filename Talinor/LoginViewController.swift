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
        
        tryAutoLogin()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        authController?.delegate = self
        hideNavBar()
        addKeyboardNotification()
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
    }
    
    private func setupDelegates(){}
    
    private func addKeyboardNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(kbAction),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(kbAction),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    private func redirectToMenu(){
        let vc = MenuViewController()
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func tryAutoLogin(){
        guard let authFields = UI.fieldsStackView.arrangedSubviews as? [AuthFieldView] else { return }
        
        authController = AuthController(authFields: authFields, typeAuth: .login)
        authController.delegate = self
        authController.checkActualLogin()
    }
    
    @objc func loginAction(){
        authController.tryAuthWithNewCredentials()
    }
    
    @objc func registrationAction(){
        let vc = RegistrationViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func kbAction(_ notification: Notification){
        let userInfo = notification.userInfo!
        
        let keyboardScreenEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification{
            UI.superScroll.contentInset = UIEdgeInsets.zero
        } else {
            UI.superScroll.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height + 10, right: 0)
        }
        UI.superScroll.scrollIndicatorInsets = UI.superScroll.contentInset
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
        UI.buttonLogin.hideSpinner()
    }
}
