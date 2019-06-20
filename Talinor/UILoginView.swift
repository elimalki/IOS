//
//  UILoginView.swift
//  Talinor
//
//  Created by Taras Kibitkin on 20/06/2019.
//  Copyright © 2019 Taras Kibitkin. All rights reserved.
//

import UIKit

class UILoginView: UIViewElementsActions{
    init(superView: UIView) {
        self.superView = superView
        self.superView.backgroundColor = #colorLiteral(red: 0.9793191552, green: 0.9800599217, blue: 0.9794338346, alpha: 1)
    }
    
    var superView: UIView!
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome, back!"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 33)
        label.textColor = .lightGray
        
        scrollContentView.addSubview(label)
        label.snp.makeConstraints({ (make) in
            make.top.equalTo(superView.safeAreaLayoutGuide).inset(120)
            make.height.equalTo(40)
            make.left.right.equalToSuperview().inset(10)
            make.bottom.equalTo(fieldsStackView.snp.top).offset(-24)
            
        })
        return label
    }()
    
    lazy var fieldsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        
        scrollContentView.addSubview(stackView)
        stackView.snp.makeConstraints({ (make) in
            make.height.equalTo(110)
            make.left.right.equalToSuperview().inset(8)
            make.bottom.equalTo(buttonLogin.snp.top).offset(-12)
        })
        
        for typeField in TypeOfAuthFields.loginOnly(){
            let view = AuthFieldView(type: typeField, withLeftImage: false)
            stackView.addArrangedSubview(view)
        }
        return stackView
    }()
    
    lazy var buttonLogin: UIButton = {
        let button = UIButton()
        button.setTitleColor(.white, for: .normal)
        button.setTitle("LOGIN", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.backgroundColor = #colorLiteral(red: 0.06273943931, green: 0.5384469628, blue: 0.05909318477, alpha: 1)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 8
        
        scrollContentView.addSubview(button)
        button.snp.makeConstraints({ (make) in
            make.height.equalTo(50)
            make.left.right.equalToSuperview().inset(12)
            make.bottom.equalTo(dontRegisterButton.snp.top).offset(-12)
        })
        return button
    }()
    
    lazy var debugLable: UILabel = {
        let label = UILabel()
        label.text = "1.0.4 debug"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = #colorLiteral(red: 0.06273943931, green: 0.5384469628, blue: 0.05909318477, alpha: 1)
        
        scrollContentView.addSubview(label)
        label.snp.makeConstraints({ (make) in
            make.centerY.equalTo(dontRegisterButton)
            make.width.equalTo(80)
            make.height.equalTo(40)
            make.right.equalToSuperview().inset(10)
            
        })
        return label
    }()
    
    lazy var dontRegisterButton: UIButton = {
        let button = UIButton()
        button.setTitle("Don't registered?", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.setTitleColor(.lightGray, for: .normal)
        button.titleLabel?.numberOfLines = 2
        
        scrollContentView.addSubview(button)
        button.snp.makeConstraints({ (make) in
            make.left.equalToSuperview().inset(10)
            make.width.equalTo(80)
            make.height.equalTo(40)
        })
        return button
    }()
    
    lazy var superScroll: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.keyboardDismissMode = .onDrag
        
        superView.addSubview(scrollView)
        scrollView.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview()
        })
        return scrollView
    }()
    
    lazy var scrollContentView: UIView = {
        let view = UIView()
        
        superScroll.addSubview(view)
        view.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview()
            make.height.equalTo(superView.frame.height + 100)
            make.width.equalTo(superView.frame.width)
        })
        return view
    }()
    
    func addElementsToSuperView() {
        titleLabel.isHidden = false
        debugLable.isHidden = false
        
        superView.layoutIfNeeded()
        superScroll.layoutIfNeeded()
    }
    
    func removeElementsFromSuperView() {
        
    }
}
