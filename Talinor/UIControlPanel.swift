//
//  UIControlPanel.swift
//  Talinor
//
//  Created by Taras Kibitkin on 09/07/2019.
//  Copyright © 2019 Taras Kibitkin. All rights reserved.
//

import UIKit

import UIKit

class UIControlPanel: UIViewElementsActions{
    
    init(superView: UIView){
        self.superView = superView
        self.superView.backgroundColor = #colorLiteral(red: 0.9793191552, green: 0.9800599217, blue: 0.9794338346, alpha: 1)
    }
    
    var superView: UIView!
    
    lazy var modeView: InOutView = {
        let view = InOutView()
        view.backgroundColor = .white
        view.titleLabel.text = "Mode :"
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 1
        
        superView.addSubview(view)
        view.snp.makeConstraints({ (make) in
            make.top.equalTo(superView.safeAreaLayoutGuide).inset(10)
            make.left.right.equalToSuperview().inset(10)
            make.height.equalTo(70)
            make.bottom.equalTo(regularView.snp.top).offset(-8)
        })
        return view
    }()
    
    lazy var regularView: InOutView = {
        let view = InOutView()
        view.backgroundColor = .white
        view.titleLabel.text = "Regular :"
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 1
        
        superView.addSubview(view)
        view.snp.makeConstraints({ (make) in
            make.left.right.equalToSuperview().inset(10)
            make.height.equalTo(70)
            make.bottom.equalTo(collectionView.snp.top).offset(-12)
        })
        return view
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing  = 20
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(UIControlPanelCollectionViewCell.self, forCellWithReuseIdentifier: "UIControlPanelCollectionViewCell")
        collectionView.backgroundColor = .clear
        
        superView.addSubview(collectionView)
        collectionView.snp.makeConstraints({ (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(titleDebug.snp.top).offset(-5)
        })
        return collectionView
    }()
    
    lazy var titleDebug: UILabel = {
        let label = UILabel()
        label.text = "1.0.4.debug"
        label.textColor = #colorLiteral(red: 0, green: 0.5113713145, blue: 0, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 12)
        
        superView.addSubview(label)
        label.snp.makeConstraints({ (make) in
            make.right.equalToSuperview().inset(4)
            make.width.equalTo(100)
            make.height.equalTo(25)
            make.bottom.equalToSuperview().inset(4)
        })
        return label
    }()
    
    func addElementsToSuperView() {
        modeView.isHidden = false
        superView.layoutIfNeeded()
    }
    
    func removeElementsFromSuperView() {
        
    }
    
}
