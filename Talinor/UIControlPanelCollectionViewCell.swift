//
//  UIControlPanelCollectionViewCell.swift
//  Talinor
//
//  Created by Taras Kibitkin on 09/07/2019.
//  Copyright © 2019 Taras Kibitkin. All rights reserved.
//

import UIKit

class UIControlPanelCollectionViewCell: UICollectionViewCell{
    override var reuseIdentifier: String?{ return "UIControlPanelCollectionViewCell" }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addSubviews()
    }
    
    override var isSelected: Bool{
        didSet{
            containerView.backgroundColor = isSelected ? #colorLiteral(red: 0.06273943931, green: 0.717831866, blue: 0.05909318477, alpha: 1) : #colorLiteral(red: 0.06273943931, green: 0.5384469628, blue: 0.05909318477, alpha: 1) 
        }
    }
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.06273943931, green: 0.5384469628, blue: 0.05909318477, alpha: 1)
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        
        addSubview(view)
        view.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview()
        })
        return view
    }()
    
    lazy var tagLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 22)
        
        containerView.addSubview(label)
        label.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview()
        })
        return label
    }()
    
    lazy var tagImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        
        containerView.addSubview(imageView)
        imageView.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview()
        })
        return imageView
    }()
    
    var data: ControlPanelButtonsType?{
        didSet{
            guard let data = data else { return }
            
            tagLabel.text = data.title
            tagImage.image = data.icon
            
            containerView.backgroundColor = (data != .home && data != .youtube) ? #colorLiteral(red: 0.06273943931, green: 0.5384469628, blue: 0.05909318477, alpha: 1) : .clear
        }
    }
    
    private func addSubviews(){
        tagLabel.isHidden = false
        tagImage.isHidden = false
        
        layoutIfNeeded()
    }
}
