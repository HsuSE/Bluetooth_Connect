//
//  ViewController.swift
//  Bluetooth_Test
//
//  Created by NKMU.EDU on 2017/4/3.
//  Copyright © 2017年 NKMU.EDU.shion.ble_test. All rights reserved.
//

import UIKit
import CoreBluetooth

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    var CentralManager:CBCentralManager!
    var SelectedPeripheral: CBPeripheral!
    var discoveredPeripherals: [CBPeripheral] = []
    var Peripheral_service:[CBService] = []
    var data: NSMutableData!
    var refreshController:UIRefreshControl!
    var timer = Timer()

    @IBOutlet weak var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        refreshController = UIRefreshControl()
        self.tableview.addSubview(refreshController)
        CentralManager  = CBCentralManager(delegate: self, queue: nil)
        
    }
    override func viewDidAppear(_ animated: Bool)  {
        CentralManager.delegate = self
      
        if SelectedPeripheral != nil {
            CentralManager.cancelPeripheralConnection(SelectedPeripheral!)
        }
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if refreshController.isRefreshing {
            self.scan()
        }
    }
    
    func scan() {
        discoveredPeripherals.removeAll()
        print("Scan Start!")
        self.CentralManager?.scanForPeripherals(withServices: nil, options: nil)
        timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(scanstop), userInfo: nil, repeats: false)
    }
    
    func scanstop() {
        self.CentralManager?.stopScan()
        self.refreshController.endRefreshing()
        timer.invalidate()

        print("Scanstop!")
        self.tableview.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.discoveredPeripherals.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellid = "cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellid,for: indexPath) as!  CellTableViewCell
        var Name = ""
        if discoveredPeripherals[indexPath.row].name != nil {
            Name = discoveredPeripherals[indexPath.row].name!
        } else {
            Name = "No Name"
        }
        let UUID = discoveredPeripherals[indexPath.row].identifier
        let RSSI = discoveredPeripherals[indexPath.row].rssi
        
        cell.label1.text = "Peripherial Info:\nName:\(Name)\nUUID:\(UUID)\nRSSI:\(RSSI)"
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detail" {
            if let index = self.tableview.indexPathForSelectedRow {
                let vc = segue.destination as! DetailViewController
                SelectedPeripheral = self.discoveredPeripherals[index.row]
                vc.selectedPeripheral = SelectedPeripheral
                vc.centralManager = self.CentralManager
            }
        }
    }
    
}

extension ViewController: CBCentralManagerDelegate {
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        //        // 顯示狀態
        print(central.state)
        switch central.state {
            case .unknown:
                print("Unknown")
                
            case .unsupported:
                print("Unsupported")
                
            case .unauthorized:
                print("Unauthorized")
                
            case .resetting:
                print("Resetting")
                
            case .poweredOff:
                print("PoweredOff")
                
            case .poweredOn:
                print("PoweredOn")
                self.scan()
            
        }
        
        
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {

//        self.discoveredPeripherals.append(peripheral)
        print("Peripheral\(peripheral)")
        print("Peripheral info: \nNAME:\(peripheral.name)\nRSSI:\(peripheral.rssi)")
        print("AdvertisementData\(advertisementData)")
//        
//        let temp = discoveredPeripherals.filter { (pl) -> Bool in
//            return pl.identifier.uuidString == peripheral.identifier.uuidString
//        }
//        
//        if temp.count == 0 {
            discoveredPeripherals.append(peripheral)
//            discoveredPeripherals.append(RSSI)
//            discoveredPeripherals.append(Int((advertisementData[CBAdvertisementDataIsConnectable]! as AnyObject).description)!)
//        }
    }
    
    
    

}
