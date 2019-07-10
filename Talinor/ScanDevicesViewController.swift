//
//  ScanDevicesViewController.swift
//  Talinor
//
//  Created by Taras Kibitkin on 21/06/2019.
//  Copyright © 2019 Taras Kibitkin. All rights reserved.
//

import UIKit
import CoreBluetooth
import BlueCapKit
import os.log

struct PeripheralCellData{
    var peripheral: Peripheral
    var isSelect: Bool = false
    var isConnected: Bool = false
    var isConnecting: Bool = false
    
    init(peripheral: Peripheral) {
        self.peripheral = peripheral
    }
}

class ScanDevicesViewController: UIViewController{
    
    lazy var UI = UIScanDevices(superView: self.view)
    
    var peripherals: [PeripheralCellData] = []
    var peripheral: Peripheral?
    var dataCharacteristic : Characteristic?
    let manager = CentralManager(options: [CBCentralManagerOptionRestoreIdentifierKey : "CentralMangerKey" as NSString])
    
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
    
    private func openPanelForConnectedDevice(){
        guard let characteristic = dataCharacteristic else { return }
        
        let vc = ControlPanelViewController(dataCharacteristic: characteristic)
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
    
    private func resetConnections(){
        peripheral?.disconnect()
        
        for (i, _) in peripherals.enumerated(){
            peripherals[i].isConnecting = false
            peripherals[i].isConnected = false
        }
        
        UI.tableView.reloadData()
    }
    
    @objc func connectAction(){
        UI.connectButton.currentTitle == "SCAN" ? beginScan() : stopScan()
    }
    
    @objc func settingsAction(){
        let alert = UIAlertController(title: "Actions", message: "Choose action", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Bluetooth settings", style: .default, handler: { (_) in
            self.openBluetoothSettings()
        }))
        alert.addAction(UIAlertAction(title: "http://www.talinor.co.uk/", style: .default, handler: { (_) in
            self.openSite()
        }))
        alert.addAction(UIAlertAction(title: "User Info", style: .default, handler: { (_) in
            self.showUserInfo()
        }))
        alert.addAction(UIAlertAction(title: "Reset connections", style: .default, handler: { (_) in
            self.resetConnections()
        }))
        alert.addAction(UIAlertAction(title: "Open control panel", style: .default, handler: { (_) in
            let vc = ControlPanelViewController()
            self.navigationController?.pushViewController(vc, animated: true)
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
        
        let dataItem = peripherals[indexPath.row]
        var indexesSet: Set<IndexPath> = [indexPath]
        
        if dataItem.isConnected{
//            peripherals[indexPath.row].isConnected = false
//            self.peripheral?.disconnect()
//            tableView.reloadRows(at: indexesSet.map{ $0 }, with: .bottom)
            openPanelForConnectedDevice()
            
            
        } else if dataItem.isConnected == false, dataItem.isConnecting == false{
            self.peripheral = dataItem.peripheral
            
            //Check for past connected or connecting state
            if let connectedIndex = (peripherals.firstIndex{ $0.isConnecting || $0.isConnected }) {
                peripherals[connectedIndex].isConnected = false
                peripherals[connectedIndex].isConnecting = false
                indexesSet.insert(IndexPath(row: connectedIndex, section: 0))
            }
            
            waannaConnect(with: dataItem.peripheral)
            peripherals[indexPath.row].isConnecting = true
            
            let copyItem = peripherals.remove(at: indexPath.row)
            peripherals = [ copyItem ] + peripherals
            
            indexesSet.insert(IndexPath(row: 0, section: 0))
            tableView.performBatchUpdates({
                tableView.moveRow(at: indexPath, to: IndexPath(row: 0, section: 0))
            }, completion: { (result) in
                tableView.reloadRows(at: indexesSet.map{ $0 }, with: .bottom)
            })
            
        }
        //openPanelForDevice(with: uuidString)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

extension ScanDevicesViewController{
    // MARK: BLE Scanning
    func scanBLEDevices() {
        let stateChangeFuture = manager.whenStateChanges()
        
        //handle state changes and return a scan future if the bluetooth is powered on.
        let scanFuture = stateChangeFuture.flatMap {[weak self] state -> FutureStream<Peripheral> in
            switch state {
            case .poweredOn:
                DispatchQueue.main.async {
                    print("Start scanning.")
                    os_log("Start scanning.")
                }
                //scan for peripherlas that advertise the ec00 service
                return (self?.manager.startScanning())!// startScanning(forServiceUUIDs: [serviceUUID])
            case .poweredOff:
                throw AppError.poweredOff
            case .unauthorized, .unsupported:
                throw AppError.invalidState
            case .resetting:
                throw AppError.resetting
            case .unknown:
                //generally this state is ignored
                throw AppError.unknown
            }
        }
        
        scanFuture.onFailure {[weak self] error in
            guard let appError = error as? AppError else {
                return
            }
            
            os_log("ScanFuture on failure: %@", "\(error.localizedDescription)")
            
            switch appError {
            case .invalidState:
                break
            case .resetting:
                self?.manager.reset()
            case .poweredOff:
                break
            case .unknown:
                break
            default:
                break;
            }
        }
        
        scanFuture.onSuccess {[weak self] (peripheral) in
            if(self?.peripherals.contains{ $0.peripheral == peripheral}) == false {
                
                DispatchQueue.main.async {
                    self?.UI.tableView.performBatchUpdates({
                        let amountOfRows = self?.peripherals.count ?? 0
                        
                        self?.peripherals.append(PeripheralCellData(peripheral: peripheral))
                        self?.UI.tableView.insertRows(at: [IndexPath(row: amountOfRows, section: 0)], with: .bottom)
                    }, completion: { (result) in
                        print("tableviw update success.")
                    })
                }
                os_log("Found device: %@", "with name: \(peripheral.name), and id: \(peripheral.identifier)")
                print("On success: (name: \(peripheral.name),id: \(peripheral.identifier)")
            }
        }
    }
    
    func stopScanForBLEDevices() {
        manager.stopScanning()
    }
    
    func waannaConnect(with peripheral: Peripheral){
        let serviceUUID = CBUUID(string:"49535343-FE7D-4AE5-8FA9-9FAFD205E455")
        let dateCharacteristicUUID = CBUUID(string:"49535343-1E4D-4BD9-BA61-23C647249616")
        
        os_log("Try peripheral connect: %@", "with name: \(peripheral.name), and id: \(peripheral.identifier)")
        
        //We will connect to the first scanned peripheral
        let connectionFuture = peripheral.connect(connectionTimeout: 10, capacity: 5)
        
        //we will next discover the "ec00" service in order be able to access its characteristics
        let discoveryFuture = connectionFuture.flatMap {[weak self] _ -> Future<Void> in
            guard let peripheral = self?.peripheral else {
                throw AppError.unknown
            }
            return peripheral.discoverServices([serviceUUID])
            }.flatMap {[weak self] _ -> Future<Void> in
                guard let discoveredPeripheral = self?.peripheral else {
                    throw AppError.unknown
                }
                guard let service = discoveredPeripheral.services(withUUID:serviceUUID)?.first else {
                    throw AppError.serviceNotFound
                }
                self?.peripheral = discoveredPeripheral
                DispatchQueue.main.async {
                    print("Discovered service \(service.uuid.uuidString). Trying to discover characteristics")
                    os_log("Discovered service: %@", "\(service.uuid.uuidString). Trying to discover characteristics")
                }
                //we have discovered the service, the next step is to discover the "ec0e" characteristic
                return service.discoverCharacteristics([dateCharacteristicUUID])
        }
        
        /**
         1- checks if the characteristic is correctly discovered
         2- Register for notifications using the dataFuture variable
         */
        let dataFuture = discoveryFuture.flatMap {[weak self] _ -> Future<Void> in
            guard let discoveredPeripheral = self?.peripheral else {
                throw AppError.unknown
            }
            guard let dataCharacteristic = discoveredPeripheral.services(withUUID:serviceUUID)?.first?.characteristics(withUUID:dateCharacteristicUUID)?.first else {
                throw AppError.dataCharactertisticNotFound
            }
            self?.dataCharacteristic = dataCharacteristic
            DispatchQueue.main.async {
                print("Discovered characteristic \(dataCharacteristic.uuid.uuidString). COOL :)")
                 os_log("Discovered characteristic: %@", "\(dataCharacteristic.uuid.uuidString). COOL :)")
            }
            //when we successfully discover the characteristic, we can show the characteritic view
            DispatchQueue.main.async {
                guard let index = (self?.peripherals.firstIndex{ $0.isConnecting }) else { return }
                
                self?.peripherals[index].isConnected = true
                self?.UI.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .bottom)
            }
            //read the data from the characteristic
            
            //Ask the characteristic to start notifying for value change
            return dataCharacteristic.startNotifying()
            }.flatMap {[weak self] _ -> FutureStream<Data?> in
                guard let discoveredPeripheral = self?.peripheral else {
                    throw AppError.unknown
                }
                guard let characteristic = discoveredPeripheral.services(withUUID:serviceUUID)?.first?.characteristics(withUUID:dateCharacteristicUUID)?.first else {
                    throw AppError.dataCharactertisticNotFound
                }
                //regeister to recieve a notifcation when the value of the characteristic changes and return a future that handles these notifications
                return characteristic.receiveNotificationUpdates(capacity: 10)
        }
        
        //The onSuccess method is called every time the characteristic value changes
        dataFuture.onSuccess { data in
            let s = String(data:data!, encoding: .utf8)
            DispatchQueue.main.async {
                print("Notified value is \(String(describing: s))")
                os_log("Notified value is: %@", String(describing: s))
            }
        }
        
        //handle any failure in the previous chain
        dataFuture.onFailure {[weak self] error in
            
            print("DataFuture on failure:\(error.localizedDescription)")
            os_log("DataFuture on failure: %@", "\(error.localizedDescription)")
            
            switch error {
            case PeripheralError.disconnected:
                self?.peripheral?.reconnect()
            case AppError.serviceNotFound:
                break
            case AppError.dataCharactertisticNotFound:
                break
            default:
                break
            }
            
            guard let index = (self?.peripherals.firstIndex{ $0.isConnecting }) else { return }
            self?.peripherals[index].isConnecting = false
            
            DispatchQueue.main.async {
                self?.UI.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .bottom)
            }
        }
    }
}
