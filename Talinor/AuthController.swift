//
//  AuthController.swift
//  Talinor
//
//  Created by Taras Kibitkin on 20/06/2019.
//  Copyright © 2019 Taras Kibitkin. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

enum AuthType{
    case login, registration
}

protocol AuthControllerDelegate{
    func startAuth()
    func successAuth()
    func failAuth(_ error: String?)

    func successResetPassword(to email: String)
    func failResetPassword(_ error: String?)
}

extension AuthControllerDelegate{
    func failResetPassword(_ error: String?){}
    func successResetPassword(to email: String){}
}

class AuthController{
    var authType: AuthType!
    
    private var channelReference: CollectionReference {
        return Firestore.firestore().collection("users")
    }
    
    var dataAuth: [String: String] = [:]
    private var authFields: [AuthFieldView]?
    private let registrationQueue = DispatchQueue(label: "registration", attributes: .concurrent)
    private let reigstrationGroup = DispatchGroup()
    
    var delegate: AuthControllerDelegate?
    
    init(authFields: [AuthFieldView], typeAuth: AuthType){
        self.authType = typeAuth
        self.authFields = authFields
    }
    
    private func saveData(user info: AppUser){
        channelReference.document(info.email!).setData( info.asDictionary )
        delegate?.successAuth()
    }
    
    func checkActualLogin(){
        delegate?.startAuth()
        guard let email = Auth.auth().currentUser?.email else {
            delegate?.failAuth("User not loggined!")
            return
        }
        
        getDataFromRemote(by: email)
    }
    
    private func getDataFromRemote(by email: String){
        channelReference.document(email).getDocument(completion: {[weak self] (document, error) in
            guard let data = document?.data() else {
                self?.delegate?.failAuth("info user nil!")
                return
            }
            
            _User.shared.info = AppUser(dictionary: data)
            self?.delegate?.successAuth()
        })
    }
    
    func tryAuthWithNewCredentials(){
        guard let authViews = authFields else { return }
        
        var errors = ""
        for authView in authViews{
            let text = authView.textField.text
            
            if let error = authView.validationError(){
                errors.append("\(error)\n")
                delegate?.failAuth(error)
                return
            }
            
            dataAuth[authView.typeOfAuthField.likeParamField] = text!
        }
        
        if authType == .login{
            tryAuth()
        } else {
            tryRegistration()
        }
    }
    
    private func tryAuth(){
        let email = dataAuth[TypeOfAuthFields.email.likeParamField]!
        let password = dataAuth[TypeOfAuthFields.email.likeParamField]!
        
        delegate?.startAuth()
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            guard error == nil else {
                self.delegate?.failAuth(error?.localizedDescription)
                return
            }
            
            guard let _ = user?.user else {
                self.delegate?.failAuth("No such user!")
                return
            }
            
            UserDefaults.standard.set(email, forKey: "aurhEmail")
            UserDefaults.standard.set(password, forKey: "authPassword")
            
            self.getDataFromRemote(by: email)
        }
    }
    
    private func tryRegistration(){
        let email = dataAuth[TypeOfAuthFields.email.likeParamField]!
        let password = dataAuth[TypeOfAuthFields.password.likeParamField]!
        let company_name = dataAuth[TypeOfAuthFields.companyName.likeParamField]!
        let first_name = dataAuth[TypeOfAuthFields.firstName.likeParamField]!
        let last_name = dataAuth[TypeOfAuthFields.lastName.likeParamField]!
        let phone_number = dataAuth[TypeOfAuthFields.phoneNumber.likeParamField]!
        
        delegate?.startAuth()
        reigstrationGroup.enter()
        registrationQueue.async {[weak self] in
            Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                guard error == nil else {
                    self?.reigstrationGroup.leave()
                    self?.delegate?.failAuth("\(error!.localizedDescription)")
                    return
                }
                
                guard let _ = user else {
                    self?.reigstrationGroup.leave()
                    self?.delegate?.failAuth("user nil")
                    return
                }
                
                _User.shared.info = AppUser(email: email,
                                            company_name: company_name,
                                            date_creation: DateFormatter().string(from: Date()),
                                            first_name: first_name,
                                            last_name: last_name,
                                            phone_number: phone_number)
                self?.reigstrationGroup.leave()
            }
        }
        
        reigstrationGroup.notify(queue: .main){[weak self] in
            guard let info = _User.shared.info else { self?.delegate?.failAuth("singletone nil"); return }
            
            self?.saveData(user: info)
        }
    }
    
    func resetPassword(with email: String){
        Auth.auth().sendPasswordReset(withEmail: email) {[weak self] (error) in
            guard let error = error else {
                self?.delegate?.successResetPassword(to: email)
                return
            }
            
            self?.delegate?.failResetPassword(error.localizedDescription)
        }
    }
    
    private func logOut(){
        do {
            try Auth.auth().signOut()
            
        } catch let error {
            
            print("Error when try logout:\(error.localizedDescription)")
            
        }
    }
}
