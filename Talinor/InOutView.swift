//
//  InOutView.swift
//  Talinor
//
//  Created by Taras Kibitkin on 09/07/2019.
//  Copyright © 2019 Taras Kibitkin. All rights reserved.
//

import UIKit

class InOutView: UIView{
    
    init(){
        super.init(frame: .zero)
        addSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addSubviews()
    }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22)
        label.textColor = .lightGray
        
        addSubview(label)
        label.snp.makeConstraints({ (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(40)
            make.height.equalTo(25)
            make.right.equalTo(valueLabel.snp.left).offset(-5)
        })
        return label
    }()
    
    lazy var valueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22)
        label.textColor = .lightGray
        label.text = "- - - - - - - "
        
        addSubview(label)
        label.snp.makeConstraints({ (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(10)
            make.height.equalTo(25)
        })
        return label
    }()
    
    private func addSubviews(){
        titleLabel.isHidden = false
        layoutIfNeeded()
    }
}
