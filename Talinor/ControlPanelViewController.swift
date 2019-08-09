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

enum State {case INIT, START, BODY}
enum Line {case Line_xx, Line_01, Line_02}

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
    
    private var cmd_state: State = .INIT
    private var flag: Line = .Line_xx
    private var len: Int = 0
    private var max_size: Int = 16
    private var cmd_buf: [UInt8] = []
    
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
    
    private func read(){
        //read a value from the characteristic
        let readFuture = self.dataCharacteristic?.read(timeout: 5)
        readFuture?.onSuccess { [weak self](_) in
            //the value is in the dataValue property
            if let dataValue = self?.dataCharacteristic?.dataValue{
                let byteArray: [UInt8] = [UInt8](dataValue)
                self?.handleInput(data_in: byteArray)
                DispatchQueue.main.async {
                    print("Read", "Read value is \(byteArray.map{ String($0)}.joined(separator: ","))")
                    os_log("Read value is: %@", "\(byteArray.map{ String($0)}.joined(separator: ","))")
                }
            } else {
                DispatchQueue.main.async { [weak self] in
                    self?.UI.modeView.valueLabel.text = "Read value is \(String(describing: self?.dataCharacteristic?.dataValue))"
                    
                    print("Read", "Read value is \(String(describing: self?.dataCharacteristic?.dataValue))")
                    os_log("Read error value is: %@", "\(String(describing: self?.dataCharacteristic?.dataValue))")
                }
            }
        }
        readFuture?.onFailure { [weak self] (error) in
            self?.UI.modeView.valueLabel.text = "\(error.localizedDescription)"
            
            os_log("Read error: %@", "\(error.localizedDescription)")
            print("Read error:\(error.localizedDescription)")
        }
    }
    
    private func writeOne(code: UInt8){
        guard let data = "\(code)".data(using: .windowsCP1252, allowLossyConversion: true) else { return }
        //write a value to the characteristic
        
        let writeFuture = self.dataCharacteristic?.write(data: data, timeout: 100, type: .withResponse)
        writeFuture?.onSuccess(completion: { [weak self] (_) in
            self?.read()
            self?.UI.modeView.valueLabel.text = "Write:\(code) succes!"
            print("Write:\(code) succes!")
            os_log("Write: %@ success!", "\(code)")
        })
        writeFuture?.onFailure(completion: { [weak self] (error) in
            self?.UI.modeView.valueLabel.text = "\(error.localizedDescription)"
            
            os_log("Write failed: %@", "\(error.localizedDescription)")
            print("Write failed:\(error.localizedDescription)")
        })
    }
    
    private func writeTwo(code: UInt8){
        guard let data = "\(code)".data(using: .utf8) else { return }
        //write a value to the characteristic
        
        let writeFuture = self.dataCharacteristic?.write(data: data, timeout: 100, type: .withResponse)
        writeFuture?.onSuccess(completion: { [weak self] (_) in
            self?.read()
            self?.UI.modeView.valueLabel.text = "Write:\(code) succes!"
            print("Write:\(code) succes!")
            os_log("Write: %@ success!", "\(code)")
        })
        writeFuture?.onFailure(completion: { [weak self] (error) in
            self?.UI.modeView.valueLabel.text = "\(error.localizedDescription)"
            
            os_log("Write failed: %@", "\(error.localizedDescription)")
            print("Write failed:\(error.localizedDescription)")
        })
    }
    
    private func writeThree(code: UInt8){
        guard let data = "\(code)".data(using: .ascii) else { return }
        //write a value to the characteristic
        
        let writeFuture = self.dataCharacteristic?.write(data: data, timeout: 100, type: .withResponse)
        writeFuture?.onSuccess(completion: { [weak self] (_) in
            self?.read()
            self?.UI.modeView.valueLabel.text = "Write:\(code) succes!"
            print("Write:\(code) succes!")
            os_log("Write: %@ success!", "\(code)")
        })
        writeFuture?.onFailure(completion: { [weak self] (error) in
            self?.UI.modeView.valueLabel.text = "\(error.localizedDescription)"
            
            os_log("Write failed: %@", "\(error.localizedDescription)")
            print("Write failed:\(error.localizedDescription)")
        })
    }
    
    private func writeFour(code: UInt8){
        
        let data = Data(bytes: [code], count: MemoryLayout<UInt8>.size)
        
        let writeFuture = self.dataCharacteristic?.write(data: data)
        writeFuture?.onSuccess(completion: { [weak self] (_) in
            self?.read()
            self?.UI.modeView.valueLabel.text = "Write:\(code) succes!"
            print("Write:\(code) succes!")
            os_log("Write: %@ success!", "\(code)")
        })
        writeFuture?.onFailure(completion: { [weak self] (error) in
            self?.UI.modeView.valueLabel.text = "\(error.localizedDescription)"
            
            os_log("Write failed: %@", "\(error.localizedDescription)")
            print("Write failed:\(error.localizedDescription)")
        })
    }
    
    private func handleInput(data_in: [UInt8]) {
    var data_len = data_in.count
    var index = 0
    var test_byte: UInt8 = 0
        
    UI.modeView.valueLabel.text = data_in.map{ String( $0 ) }.joined(separator: "/")
        
    while (data_len > 0) {
    switch cmd_state {
    
    case .INIT:
                len = 0
                index = 0
                self.cmd_state = State.START
                self.flag = Line.Line_xx
    
                for i in 0..<max_size {
                    cmd_buf[i] = 32
                }    // заполняем все пробелами для избегания мигания
                cmd_buf[max_size] = 0                                 // за границами допустимых символов MAX_LINE_LENGTH добиваем нулем
    
    case .START:
        test_byte = data_in[index]
    
        data_len -= 1
        index += 1
        
        // reset lines if there is special symbol
        if (test_byte == 0x01) {
            flag = Line.Line_01;
            len = 0;
            cmd_state = State.BODY;
            for i in 0..<max_size {
                cmd_buf[i] = 32
            }
            UI.modeView.valueLabel.text = cmd_buf.map{ String( $0 ) }.joined()
        }
        
        if (test_byte == 0x02) {
            flag = Line.Line_02;
            len = 0;
            cmd_state = State.BODY;
            for i in 0..<max_size {
                cmd_buf[i] = 32
            }
            UI.regularView.valueLabel.text = cmd_buf.map{ String( $0 ) }.joined()
        }
    
    case .BODY:
        test_byte = data_in[index];
        
        data_len -= 1
        index += 1
        
        // reset lines if there is special symbol
        if (test_byte == 0x01) {
            flag = Line.Line_01;
            len = 0;
            for i in 0..<max_size {
                cmd_buf[i] = 32
            }
            UI.modeView.valueLabel.text = cmd_buf.map{ String( $0 ) }.joined()
            break;
        }
        
        if (test_byte == 0x02) {
            flag = Line.Line_02;
            len = 0;
            for i in 0..<max_size {
                cmd_buf[i] = 32
            }
            UI.regularView.valueLabel.text = cmd_buf.map{ String( $0 ) }.joined()
            break;
        }
        
        // check if this is printable ASCII char
        if ((test_byte >= 32) && (test_byte <= 126)) {
            cmd_buf[len] = test_byte;
            len += 1
        }
        
        // plot the lines depend flag
        if (flag == Line.Line_01) {
            UI.modeView.valueLabel.text = cmd_buf.map{ String( $0 ) }.joined()
        }
        
        if (flag == Line.Line_02) {
            UI.regularView.valueLabel.text = cmd_buf.map{ String( $0 ) }.joined()
        }
        
        // wait for new start symbol if len more than max allowed
        if (len >= max_size) {
            flag = Line.Line_xx;
            cmd_state = State.START;
        }
      }
    }
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
        
        let code = controllElementsData[indexPath.row].code
        
        os_log("Select: %@", "\(code)")
        print("Select:", code)

        notificationFeedBack.notificationOccurred(.success)
        
        switch controllElementsData[indexPath.row] {
            case .youtube: openYoutube()
            case .one: writeOne(code: code!)
            case .two: writeTwo(code: code!)
            case .three: writeThree(code: code!)
            case .four: writeFour(code: code!)
        default: guard let _code = code else { return }; writeOne(code: _code)
        }
    }
}

extension ControlPanelViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: controllElementsData[indexPath.row].width, height: 50)
    }
}
