//
//  ScanDevicesViewController.swift
//  Talinor
//
//  Created by Taras Kibitkin on 21/06/2019.
//  Copyright © 2019 Taras Kibitkin. All rights reserved.
//

import UIKit
import CoreBluetooth

class ScanDevicesViewController: UIViewController{
    
    lazy var UI = UIScanDevices(superView: self.view)
    
    var peripherals: [CBPeripheral] = []
    var manager: CBCentralManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupActions()
        setupDelegates()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UI.tableView.dataSource = self
        UI.tableView.delegate = self
        showNavBar()
        setupNavBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        UI.tableView.dataSource = nil
        UI.tableView.delegate = nil
        stopScan()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func setupUI(){
        UI.addElementsToSuperView()
    }
    
    private func setupActions(){
        UI.connectButton.addTarget(self, action: #selector(connectAction), for: .touchUpInside)
        UI.settingsButton.addTarget(self, action: #selector(settingsAction), for: .touchUpInside)
    }
    
    private func setupDelegates(){
        manager = CBCentralManager(delegate: self, queue: nil)
    }
    
    private func setupNavBar(){
        let connectNavItem = UIBarButtonItem(customView: UI.connectButton)
        let settingsNavItem = UIBarButtonItem(customView: UI.settingsButton)
        
        navigationItem.rightBarButtonItems = [settingsNavItem, connectNavItem]
        
        let imageView = UIImageView(image: UIImage(named: "talinor_logo"))
        imageView.contentMode = .scaleAspectFit
        navigationItem.titleView = imageView
    }
    
    private func showUserInfo(){
        guard let userInfo = _User.shared.info else { return }
        showOkAlert(with: "User Info", and: "Launch number: -\nRegistered:-\nFirst Name: \(userInfo.first_name ?? "")\nSecond Name: \(userInfo.last_name ?? "")\nCompany Name:\(userInfo.company_name ?? "")\nE-mail:\(userInfo.email ?? "")\nPhone Number:\(userInfo.phone_number ?? "")\nDate create:\(userInfo.date_creation ?? "")")
    }
    
    private func openSite(){
        let vc = WebViewConteoller(url: URL(string: "http://www.talinor.co.uk/")!)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func openPanelForDevice(with uiid: String){
        let vc = ControlPanelViewController(uiid: uiid)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func openBluetoothSettings(){
        guard let url = URL(string: "App-Prefs:root=Bluetooth") else {
            return
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    private func beginScan(){
        peripherals = []
        UI.tableView.reloadData()
        UI.buttonRefresh.showSpinner(spinnerStyle: .gray)
        UI.tableView.isHidden = false
        UI.buttonRefresh.isHidden = false
        UI.connectButton.setTitle("STOP", for: .normal)
        scanBLEDevices()
    }
    
    private func stopScan(){
        stopScanForBLEDevices()
        UI.buttonRefresh.hideSpinner()
        UI.buttonRefresh.isHidden = true
        UI.connectButton.setTitle("SCAN", for: .normal)
    }
    
    @objc func connectAction(){
        UI.connectButton.currentTitle == "SCAN" ? beginScan() : stopScan()
    }
    
    @objc func settingsAction(){
        let alert = UIAlertController(title: "Actions", message: "", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Bluetooth settings", style: .default, handler: { (_) in
            self.openBluetoothSettings()
        }))
        alert.addAction(UIAlertAction(title: "http://www.talinor.co.uk/", style: .default, handler: { (_) in
            self.openSite()
        }))
        alert.addAction(UIAlertAction(title: "User Info", style: .default, handler: { (_) in
            self.showUserInfo()
        }))
        alert.addAction(UIAlertAction(title: "Reset User Info", style: .default, handler: { (_) in
            
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension ScanDevicesViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peripherals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScanDeviceTableViewCell", for: indexPath) as! ScanDeviceTableViewCell
        cell.data = peripherals[indexPath.row]
        
        return cell
    }
}

extension ScanDevicesViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let uuidString = peripherals[indexPath.row].identifier.uuidString
        openPanelForDevice(with: uuidString)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

extension ScanDevicesViewController: CBCentralManagerDelegate, CBPeripheralDelegate{
    // MARK: BLE Scanning
    func scanBLEDevices() {
        //manager?.scanForPeripherals(withServices: [CBUUID.init(string: parentView!.BLEService)], options: nil)
        
        //if you pass nil in the first parameter, then scanForPeriperals will look for any devices.
        manager.scanForPeripherals(withServices: nil, options: nil)
        
        //stop scanning after 3 seconds
        
    }
    
    func stopScanForBLEDevices() {
        manager.stopScan()
    }
    
    // MARK: - CBCentralManagerDelegate Methods
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if(!peripherals.contains(peripheral)) {
            peripherals.append(peripheral)
        }
        
        UI.tableView.reloadData()
    }

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print(central.state)
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        
        //pass reference to connected peripheral to parent view
        
        peripheral.delegate = self
        peripheral.discoverServices(nil)
        
        //set the manager's delegate view to parent so it can call relevant disconnect methods
        manager?.delegate = self
        
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
        
        print("Connected to " +  peripheral.identifier.uuidString)
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print(error!)
    }
}
