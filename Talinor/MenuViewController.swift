//
//  MenuViewController.swift
//  Talinor
//
//  Created by Taras Kibitkin on 20/06/2019.
//  Copyright © 2019 Taras Kibitkin. All rights reserved.
//

import UIKit
import WebKit

class MenuViewController: UIViewController{
    lazy var UI = UIMenuView(superView: self.view)
    let buttons = MenuButtonType.allCases
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupDelegates()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func setupUI(){
        UI.addElementsToSuperView()
    }
    
    private func setupActions(){}
    
    private func setupDelegates(){
        UI.collectionView.delegate = self
        UI.collectionView.dataSource = self
    }
    
    private func openUrl(url: URL){
        
        let vc = WebViewConteoller(url: url)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func openScanDevices(){
        navigationController?.pushViewController(ScanDevicesViewController(), animated: true)
    }
}

extension MenuViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return buttons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuCollectionViewCell", for: indexPath) as! MenuCollectionViewCell
        cell.type = buttons[indexPath.row]
        return cell
    }
}

extension MenuViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch buttons[indexPath.row] {
        case .programmingToll:
            openScanDevices()
            
        default:
            guard let link = buttons[indexPath.row].link else { return }
            openUrl(url: URL(string: link)!)
        }
        
    }
}

extension MenuViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 45)
    }
}

