//
//  UIScanDevices.swift
//  Talinor
//
//  Created by Taras Kibitkin on 21/06/2019.
//  Copyright © 2019 Taras Kibitkin. All rights reserved.
//

import UIKit
import CoreBluetooth

class UIScanDevices: UIViewElementsActions{
    
    init(superView: UIView){
        self.superView = superView
        self.superView.backgroundColor = #colorLiteral(red: 0.9793191552, green: 0.9800599217, blue: 0.9794338346, alpha: 1)
    }
    
    var superView: UIView!
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.register(ScanDeviceTableViewCell.self, forCellReuseIdentifier: "ScanDeviceTableViewCell")
        tableView.backgroundColor = .clear
        
        superView.addSubview(tableView)
        tableView.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview()
        })
        return tableView
    }()
    
    lazy var connectButton: UIButton = {
        let button = UIButton()
        button.setTitle("CONNECT", for: .normal)
        button.setTitleColor(.darkGray, for: .normal)
        
        return button
    }()
    
    lazy var settingsButton: UIButton = {
        let button = UIButton()
        button.setTitle("...", for: .normal)
        button.setTitleColor(.darkGray, for: .normal)
        
        return button
    }()
    
    lazy var buttonRefresh: UIButton = {
        let button = UIButton()
        button.setTitle("Use CONNECT to refresh devices", for: .normal)
        button.setTitleColor(.darkGray, for: .normal)
        
        superView.addSubview(button)
        button.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview()
        })
        return button
    }()
    
    func addElementsToSuperView() {
        tableView.isHidden = true
        buttonRefresh.isHidden = false
        superView.layoutIfNeeded()
    }
    
    func removeElementsFromSuperView() {
        
    }
    
}

class ScanDeviceTableViewCell: UITableViewCell{
    override var reuseIdentifier: String?{ return "ScanDeviceTableViewCell" }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addSubviews()
    }
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        
        return label
    }()
    
    lazy var uiidLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        return label
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        
        addSubview(stackView)
        stackView.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview()
        })
        
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(uiidLabel)
        return stackView
    }()
    
    var data: CBPeripheral?{
        didSet{
            nameLabel.text = data?.name
            uiidLabel.text = data?.identifier.uuidString
        }
    }
    private func addSubviews(){
        stackView.isHidden = false
        layoutIfNeeded()
    }
}
