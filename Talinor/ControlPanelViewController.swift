//
//  ControlPanelViewController.swift
//  Talinor
//
//  Created by Taras Kibitkin on 09/07/2019.
//  Copyright © 2019 Taras Kibitkin. All rights reserved.
//

import UIKit
import BlueCapKit
import os.log

class ControlPanelViewController: UIViewController{
    
    init(){
        super.init(nibName: nil, bundle: nil)
    }
    
    init(dataCharacteristic: Characteristic) {
        super.init(nibName: nil, bundle: nil)
        self.dataCharacteristic = dataCharacteristic
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private var uiid: String!
    lazy var UI = UIControlPanel(superView: self.view)
    private let controllElementsData = ControlPanelButtonsType.allCases
    private let notificationFeedBack = UINotificationFeedbackGenerator()
    private var dataCharacteristic : Characteristic!
    
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
        read()
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
    
    private func read(){
        //read a value from the characteristic
        let readFuture = self.dataCharacteristic?.read(timeout: 5)
        readFuture?.onSuccess { (_) in
            //the value is in the dataValue property
            let s = String(data:(self.dataCharacteristic?.dataValue)!, encoding: .utf8)
            DispatchQueue.main.async {
                print("Read", "Read value is \(String(describing: s))")
                os_log("Read value is: %@", "\(String(describing: s))")
            }
        }
        readFuture?.onFailure { (error) in
            os_log("Read error: %@", "\(error.localizedDescription)")
            print("Read error:\(error.localizedDescription)")
        }
    }
    
    private func write(text: String){
        //write a value to the characteristic
        let writeFuture = self.dataCharacteristic?.write(data:text.data(using: .utf8)!)
        writeFuture?.onSuccess(completion: { (_) in
            print("Write:\(text) succes!")
            os_log("Write: %@ success!", text)
        })
        writeFuture?.onFailure(completion: { (error) in
            os_log("Write failed: %@", "\(error.localizedDescription)")
            print("Write failed:\(error.localizedDescription)")
        })
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
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let code = controllElementsData[indexPath.row].title
        
        os_log("Select: %@", "\(code ?? "")")
        print("Select:", code)
        
        notificationFeedBack.notificationOccurred(.success)
        
        switch controllElementsData[indexPath.row] {
            case .youtube: openYoutube()
        default: guard let code = code else { return }; write(text: code)
        }
    }
}

extension ControlPanelViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: controllElementsData[indexPath.row].width, height: 50)
    }
}
