//
//  RegistrationViewController.swift
//  Talinor
//
//  Created by Taras Kibitkin on 20/06/2019.
//  Copyright © 2019 Taras Kibitkin. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController {
    lazy var UI = UIRegistrationView(superView: self.view)
    var authController: AuthController = AuthController(typeAuth: .registration)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupActions()
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
        UI.buttonRegistration.addTarget(self, action: #selector(registrationAction), for: .touchUpInside)
        UI.toLogin.addTarget(self, action: #selector(toLoginAction), for: .touchUpInside)
    }
    
    private func setupDelegates(){
        authController.delegate = self
        addKeyboardCheckStateForSuperScroll()
    }
    
    private func unsubscribeDelegates(){
        authController.delegate = nil
        NotificationCenter.default.removeObserver(self)
    }
    
    private func redirectToMenu(){
        let vc = MenuViewController()
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func registrationAction(){
        authController.tryAuth(with: UI.authFields)
    }
    
    @objc func toLoginAction(){
        navigationController?.popViewController(animated: true)
    }
}

extension RegistrationViewController: AuthControllerDelegate{
    func startAuth() {
        UI.buttonRegistration.showSpinner()
    }
    
    func successAuth() {
        UI.buttonRegistration.hideSpinner()
        redirectToMenu()
    }
    
    func failAuth(_ error: String?) {
        UI.buttonRegistration.hideSpinner()
        showOkAlert(and: error)
    }
}
