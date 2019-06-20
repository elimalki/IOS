//
//  AuthFieldView.swift
//  Bagit
//
//  Created by Taras Kibitkin on 12/02/2019.
//  Copyright © 2019 George Heints. All rights reserved.
//

import UIKit
import SnapKit

enum TypeOfAuthFields: CaseIterable{
    case firstName
    case lastName
    case companyName
    case email
    case password
    case phoneNumber
}

extension TypeOfAuthFields{
    static func registrationOnly() -> [TypeOfAuthFields] {
        return TypeOfAuthFields.allCases
    }
    
    static func loginOnly() -> [TypeOfAuthFields] {
        return [.email, .password]
    }
    
    var keyboardType: UIKeyboardType {
        switch self {
        case .firstName:
            return UIKeyboardType.default
        case .email:
            return UIKeyboardType.emailAddress
        case .password:
            return UIKeyboardType.default
        case .lastName:
            return UIKeyboardType.default
        case .companyName:
            return UIKeyboardType.default
        case .phoneNumber:
            return UIKeyboardType.numberPad
        }
        
    }
    
    var likeParamField: String {
        switch self {
        case .firstName:
            return "username"
        case .email:
            return "useremail"
        case .password:
            return "password"
        case .lastName:
            return "lastName"
        case .companyName:
            return "companyName"
        case .phoneNumber:
            return "phoneNumber"
        }
        
    }
    
    var validLenthText: Int{
        switch self{
        case .firstName:
            return 2
        case .email:
            return 8
        case .password:
            return 8
        case .lastName:
            return 2
        case .companyName:
            return 2
        case .phoneNumber:
            return 8
        }
        
    }
    
    var placeholder: String? {
        switch self {
        case .firstName:
            return "First Name"
        case .email:
            return "E-Mail"
        case .password:
            return "Password"
        case .lastName:
            return "Last Name"
        case .companyName:
            return "Company Name"
        case .phoneNumber:
            return "Phone number"
        }
    }
}

class AuthFieldView: UIView{
    
    init(type: TypeOfAuthFields, withLeftImage: Bool = true){
        super.init(frame: CGRect.zero)
        self.typeOfAuthField = type
        self.withLeftImage = withLeftImage
        
        typeFieldLabel.isHidden = false
        iconField.isHidden = withLeftImage ? false : true
        buttonClear.alpha = 0
        buttonState.isHidden = false
        
        layer.masksToBounds = true
        layer.cornerRadius = 8
        layer.borderColor = UIColor.darkGray.cgColor
        layer.borderWidth = 1
        
        layoutIfNeeded()
        
        localize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    deinit {
        buttonState.removeTarget(self, action: nil, for: .allEvents)
    }
    
    var typeOfAuthField: TypeOfAuthFields!
    var withLeftImage: Bool!
    
    lazy var typeFieldLabel: UILabel = {
        let label = UILabel()
        label.alpha = 0
        label.textColor = #colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 12)
        addSubview(label)
        label.snp.makeConstraints({ (make) in
            make.top.equalToSuperview()
            make.bottom.equalTo(self.textField.snp.top).offset(-5)
            make.left.equalToSuperview().inset(5)
            make.height.equalTo(20)
        })
        return label
    }()
    
    lazy var iconField: UIImageView = {
        let imageView = UIImageView(image: nil)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = #colorLiteral(red: 0.6322160363, green: 0.6322889924, blue: 0.632174015, alpha: 1)
        
        addSubview(imageView)
        imageView.snp.makeConstraints({ (make) in
            make.centerY.equalTo(self.textField)
            make.left.equalToSuperview()
            make.right.equalTo(self.textField.snp.left).offset(-10)
            make.height.width.equalTo(13)
        })
        
        return imageView
    }()
    
    lazy var buttonClear: UIButton = {
        let button = UIButton()
        button.imageView?.contentMode = .scaleAspectFit
        button.setImage(UIImage(named: "close"), for: .normal)
        button.backgroundColor = .clear
        button.imageEdgeInsets = UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
        
        button.addTarget(self, action: #selector(clearButtonAction), for: .touchUpInside)
        
        addSubview(button)
        button.snp.makeConstraints({ (make) in
            make.centerY.equalTo(self.textField)
            make.left.equalTo(self.textField.snp.right)
            make.right.equalTo(self.buttonState.snp.left).offset(-4)
            make.height.width.equalTo(15)
        })
        
        return button
    }()
    
    lazy var buttonState: UIButton = {
        let button = UIButton()
        button.imageView?.contentMode = .scaleAspectFit
        
        if typeOfAuthField == .password{
            button.addTarget(self, action: #selector(changeStateSecurityTextEntry), for: .touchUpInside)
        }
        
        addSubview(button)
        button.snp.makeConstraints({ (make) in
            make.centerY.equalTo(self.textField)
            make.height.equalTo(15)
            make.width.equalTo(22)
            //make.left.equalTo(self.textField.snp.right)
            make.right.equalToSuperview()
        })
        
        return button
    }()
    
    lazy var textField: UITextField = {
        var textField: UITextField!
        
        textField = UITextField()
        textField.delegate = self
        textField.textAlignment = .center
        textField.returnKeyType = .done
        textField.keyboardType = typeOfAuthField.keyboardType
        textField.font = UIFont.systemFont(ofSize: 18)
        
        if typeOfAuthField == .password{
            textField.isSecureTextEntry = true
        }
        
        addSubview(textField)
        textField.snp.makeConstraints({ (make) in
            make.bottom.equalTo(self.lineLabel.snp.top).offset(-5)
        })
        
        return textField
    }()
    
    lazy var lineLabel: UIView = {
        let label = UIView()
        label.backgroundColor = #colorLiteral(red: 0.865880549, green: 0.866540134, blue: 0.8659827113, alpha: 1)
        label.alpha = 0
        
        addSubview(label)
        label.snp.makeConstraints({ (make) in
            make.height.equalTo(1)
            make.left.right.equalToSuperview()
        })
        
        return label
    }()
    
    func clearField(){
        buttonState.setImage(nil, for: .normal)
        textField.text = ""
    }
    
    func localize(){
        textField.placeholder = typeOfAuthField.placeholder
    }
    
    @discardableResult
    func validationError() -> String?{

        let error = AuthValidator.validate(field: typeOfAuthField, text: textField.text)
        if error != nil {
            guard lineLabel.backgroundColor != .red else { return error }
            updateStateIconsBy(lenghtText: textField.text?.count)
            let originColor = lineLabel.backgroundColor
            
            UIView.animate(withDuration: 1, animations: {[weak self] in
                self?.lineLabel.backgroundColor = #colorLiteral(red: 1, green: 0.3411764706, blue: 0.137254902, alpha: 1)
                
            }) { [weak self] (_) in
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.3, execute: {
                    UIView.animate(withDuration: 3, animations: {
                        self?.lineLabel.backgroundColor = originColor
                    })
                })
            }
            
            //
            //            let length = textField.text?.count ?? 0
            //            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {[weak self] in
            //                self?.updateStateIconsBy(lenghtText: length)
            //            }
        }
        return error
    }
    
    func updateStateIconsBy(lenghtText: Int? = nil){ // lenthText -2 for select city or date only
        let _lenth: Int = lenghtText == nil ? (textField.text?.count ?? 0) : lenghtText!
        var text: String? = textField.text
    
        if AuthValidator.validate(field: typeOfAuthField, text: text) == nil || _lenth == -2{
            
            buttonState.setImage(UIImage(named: "check"), for: .normal)
        } else {
            if typeOfAuthField == .password, _lenth > 0{
                buttonState.setImage(UIImage(named: "eye"), for: .normal)
            } else {
                buttonState.setImage(UIImage(named: "minus"), for: .normal)
            }
        }
    }
    
    @objc private func changeStateSecurityTextEntry(){
        textField.isSecureTextEntry = !textField.isSecureTextEntry
    }
    
    @objc private func clearButtonAction(){
        textField.placeholder = typeFieldLabel.text
    }
}

extension AuthFieldView: UITextFieldDelegate{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        lineLabel.backgroundColor = #colorLiteral(red: 0.2978862226, green: 0.6846809387, blue: 0.3157090545, alpha: 1)
        
        typeFieldLabel.toAlpha(1)
        typeFieldLabel.text = textField.placeholder
        textField.placeholder = ""
        
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        lineLabel.backgroundColor = #colorLiteral(red: 0.9344235751, green: 0.9344235751, blue: 0.9344235751, alpha: 1)
        
        textField.placeholder = typeFieldLabel.text
        
        if textField.text == "" {
            typeFieldLabel.toAlpha(0)
            buttonState.setImage(nil, for: .normal)
        }
        
        textField.endEditing(true)
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let newLenth = (textField.text?.count ?? 0) + (string == "" ? -1 : 1)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {[weak self] in
            self?.updateStateIconsBy(lenghtText: newLenth)
        }
        
        if typeOfAuthField == .phoneNumber{
            if let firstChar = textField.text?.first, (Int(String(firstChar)) != nil || firstChar == "+"){
                let newText = ((textField.text ?? "") + string).formattedNumber()

                if newText != textField.text || string == ""{
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        textField.text = textField.text?.formattedNumber()
                    }
                } else {
                    return false
                }
            }
        }
        return true
    }
}
