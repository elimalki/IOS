//
//  UIMenuView.swift
//  Talinor
//
//  Created by Taras Kibitkin on 21/06/2019.
//  Copyright © 2019 Taras Kibitkin. All rights reserved.
//

import UIKit

enum MenuButtonType: Int, CaseIterable{
    case programmingToll = 0, support, t2qForm, download, loginToIoT
}

extension MenuButtonType{
    var title: String{
        switch self {
        case .programmingToll: return "PROGRAMMING TOOL"
        case .support: return "SUPPORT"
        case .t2qForm: return "T2Q FORM"
        case .download: return "DOWNLOAD"
        case .loginToIoT: return "LOGIN to IoT"
        }
    }
    
    var link: String?{
        switch self {
        case .support: return "http://talinor.co.uk/support2"
        case .t2qForm: return "http://talinor.co.uk/quote"
        case .download: return "http://talinor.co.uk/downloads"
        case .loginToIoT: return "https://talinor.devicewise.net/app/login"
        default: return nil
        }
    }
}

class UIMenuView: UIViewElementsActions{
    
    init(superView: UIView){
        self.superView = superView
        self.superView.backgroundColor = #colorLiteral(red: 0.9793191552, green: 0.9800599217, blue: 0.9794338346, alpha: 1)
    }
    
    var superView: UIView!
    
    lazy var logoImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "talinor_logo"))
        imageView.contentMode = .scaleAspectFit
        
        superView.addSubview(imageView)
        imageView.snp.makeConstraints({ (make) in
            make.top.equalToSuperview().inset(30)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(titleLabel.snp.top).offset(-20)
            make.height.equalTo(80)
            make.width.equalTo(100)
        })
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome!"
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 43)
        label.textAlignment = .center
        
        superView.addSubview(label)
        label.snp.makeConstraints({ (make) in
            make.left.right.equalToSuperview().inset(12)
            make.bottom.equalTo(collectionView.snp.top).offset(-40)
        })
        return label
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 15
        layout.sectionInset = UIEdgeInsets(top: 0, left: 3, bottom: 0, right: 3)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(MenuCollectionViewCell.self, forCellWithReuseIdentifier: "MenuCollectionViewCell")
        collectionView.backgroundColor = .clear
        
        superView.addSubview(collectionView)
        collectionView.snp.makeConstraints({ (make) in
            make.height.equalTo(300)
            make.left.right.equalToSuperview().inset(12)
            make.bottom.equalTo(titleDebug.snp.top).offset(-15)
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
            make.right.equalToSuperview().inset(12)
            make.width.equalTo(100)
            make.height.equalTo(25)
        })
        return label
    }()
    
    func addElementsToSuperView() {
        logoImage.isHidden = false
        superView.layoutIfNeeded()
    }
    
    func removeElementsFromSuperView() {
        
    }
    
}

class MenuCollectionViewCell: UICollectionViewCell{
    override var reuseIdentifier: String?{ return "MenuCollectionViewCell" }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addSubviews()
    }
    
    lazy var titlLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = #colorLiteral(red: 0, green: 0.5113713145, blue: 0, alpha: 1)
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .center
        
        addSubview(label)
        label.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview()
        })
        return label
    }()
    
    var type: MenuButtonType?{
        didSet{
            titlLabel.text = type?.title
        }
    }
    
    private func addSubviews(){
        layer.cornerRadius = 8
        layer.masksToBounds = true
        
        titlLabel.isHidden = false
        layoutIfNeeded()
    }
}
