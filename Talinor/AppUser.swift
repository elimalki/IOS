//
//  AppUser.swift
//  Talinor
//
//  Created by Taras Kibitkin on 20/06/2019.
//  Copyright © 2019 Taras Kibitkin. All rights reserved.
//

import Foundation
import FirebaseAuth

class _User{
    static var shared = _User()
    var info: AppUser?
    
}

struct AppUser{
    var uid: String?
    var email: String?
    var company_name: String?
    var date_creation: String?
    var first_name: String?
    var last_name: String?
    var phone_number: String?
    
    init(_ user: User) {
        self.uid = user.uid
        self.email = user.email
    }
    
    init(email: String, company_name: String?, date_creation: String?, first_name: String?, last_name: String?, phone_number: String?) {
        self.email = email
        self.company_name = company_name
        self.date_creation = date_creation
        self.first_name = first_name
        self.last_name = last_name
        self.phone_number = phone_number
    }
    
    init(){ }
    
    init(dictionary: [String : Any]){
        self.email = dictionary["email"] as? String
        self.company_name = dictionary["company_name"] as? String
        self.date_creation = dictionary["date_creation"] as? String
        self.first_name = dictionary["first_name"] as? String
        self.last_name = dictionary["last_name"] as? String
        self.phone_number = dictionary["phone_number"] as? String
    }
}

extension AppUser{
    var asDictionary: [String: Any]{
        return ["company_name": self.company_name,
                "date_creation": self.date_creation,
                "email": self.email,
                "first_name": self.first_name,
                "last_name": self.last_name,
                "phone_number": self.phone_number]
    }
}
