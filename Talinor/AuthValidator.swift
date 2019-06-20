//
//  AuthValidator.swift
//  Talinor
//
//  Created by Taras Kibitkin on 20/06/2019.
//  Copyright © 2019 Taras Kibitkin. All rights reserved.
//

import Foundation

class AuthValidator{
    
    static func validate(field: TypeOfAuthFields, text: String?) -> String? {
        var errors: String = ""
        let minLenth = field.validLenthText
        let name = field.placeholder
        
        if text == nil || text == ""{
            errors += "\(name) must be not empty!"
        }
        
        if (text?.count ?? 0) < minLenth{
            errors += "\nThe \(name) must be longer than \(minLenth) charactersy!"
        }
        
        if field == .email{
            if text?.first != "+"{ // email
                if text?.contains("@") == false{
                    errors += "\nThe \(name) must be have '@' symbol in field!"
                }
                if text?.contains(".") == false{
                    errors += "\nThe \(name) must be have '.' symbol in field!"
                }
                if text?.first == "." || text?.last == "."{
                    errors += "\nThe \(name) must don't have '.' symbol at first or last symbol in field!"
                }
            }
        }
        
        if field == .password {
            // Contains 1 char at lower case
            let lowLetterRegEx  = ".*[a-z]+.*"
            let lowCharPredicate = NSPredicate(format:"SELF MATCHES %@", lowLetterRegEx)
            let containsLowChar = lowCharPredicate.evaluate(with: text)
            
            //contains 1 char at upper case
            let upperLetterRegEx  = ".*[a-z]+.*"
            let upperCharPredicate = NSPredicate(format:"SELF MATCHES %@", upperLetterRegEx)
            let containsUpChar = upperCharPredicate.evaluate(with: text)
            
            //contains 1 number
            let numberRegEx  = ".*[0-9]+.*"
            let numberPredicat = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
            let containsNumber = numberPredicat.evaluate(with: text)
            
            if !containsLowChar || !containsUpChar || !containsNumber{
                errors += "\n In the \(name) should at least contain 1 number, 1 character at the lower and 1 uppercase character!"
            }
        }
        
        return errors == "" ? nil : errors
    }
}

