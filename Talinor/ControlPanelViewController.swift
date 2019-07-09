//
//  ControlPanelViewController.swift
//  Talinor
//
//  Created by Taras Kibitkin on 09/07/2019.
//  Copyright © 2019 Taras Kibitkin. All rights reserved.
//

import UIKit

class ControlPanelViewController: UIViewController{
    
    init(uiid: String) {
        super.init(nibName: nil, bundle: nil)
        self.uiid = uiid
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private var uiid: String!
    lazy var UI = UIControlPanel(superView: self.view)
    private let controllElementsData = ControlPanelButtonsType.allCases
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupActions()
        setupDelegates()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupDelegates()
        setupNavBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeDelegates()
    }
    
    private func setupUI(){
        UI.addElementsToSuperView()
    }
    
    private func setupActions(){}
    
    private func setupDelegates(){
        UI.collectionView.dataSource = self
        UI.collectionView.delegate = self
    }
    
    private func setupNavBar(){
        let imageView = UIImageView(image: UIImage(named: "talinor_logo"))
        imageView.contentMode = .scaleAspectFit
        navigationItem.titleView = imageView
    }
    
    private func unsubscribeDelegates(){
        UI.collectionView.dataSource = nil
        UI.collectionView.delegate = nil
    }
    
    private func openYoutube(){
        let vc = WebViewConteoller(url: URL(string: "http://www.talinor.co.uk/videos")!)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ControlPanelViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return controllElementsData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UIControlPanelCollectionViewCell", for: indexPath) as! UIControlPanelCollectionViewCell
        
        cell.data = controllElementsData[indexPath.row]
        
        return cell
    }
}

extension ControlPanelViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Select:", controllElementsData[indexPath.row].title)
        
        switch controllElementsData[indexPath.row] {
            case .youtube: openYoutube()
            default: return
        }
    }
}

extension ControlPanelViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: controllElementsData[indexPath.row].width, height: 50)
    }
}
