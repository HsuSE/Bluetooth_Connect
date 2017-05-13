//
//  DetailViewController.swift
//  Bluetooth_Test
//
//  Created by NKMU.EDU on 2017/4/4.
//  Copyright © 2017年 NKMU.EDU.shion.ble_test. All rights reserved.
//

import UIKit
import CoreBluetooth

class BTServiceInfo {
    var service: CBService!
    var characteristics: [CBCharacteristic]
    init(service: CBService, characteristics: [CBCharacteristic]) {
        self.service = service
        self.characteristics = characteristics
    }
}

class DetailViewController: UIViewController ,UITableViewDelegate ,UITableViewDataSource {

    var selectedPeripheral: CBPeripheral!
    var centralManager:CBCentralManager!
    var btServices: [BTServiceInfo] = []
    
    @IBOutlet weak var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        centralManager.delegate = self
        selectedPeripheral.delegate = self

        // Do any additional setup after loading the view.
        centralManager.connect(selectedPeripheral, options: nil)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        centralManager.delegate = self
        selectedPeripheral.delegate = self
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return btServices[section].service.uuid.description
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return btServices.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.btServices[section].characteristics.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.performSegue(withIdentifier: "characteristicdetail", sender: ["section": indexPath.section, "row": indexPath.row])
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender:Any?) {
        var s = sender as! [String:Int]

        if segue.identifier == "characteristicdetail" {
            let targetVC = segue.destination as! CharacteristicDetailViewController
            targetVC.peripheral = self.selectedPeripheral
            targetVC.characteristic = btServices[s["section"]!].characteristics[s["row"]!]
        }
        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellid = "detailcell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellid,for: indexPath) as!  DetailViewCell
        
        cell.lbUUID.text = btServices[indexPath.section].characteristics[indexPath.row].uuid.uuidString
        cell.lbPropHex.text = String(format: "0x%02X", btServices[indexPath.section].characteristics[indexPath.row].properties.rawValue)
        cell.lbProp.text = btServices[indexPath.section].characteristics[indexPath.row].getPropertyContent()
        cell.lbName.text = btServices[indexPath.section].characteristics[indexPath.row].uuid.description
        cell.lbValue.text = btServices[indexPath.section].characteristics[indexPath.row].value?.description ?? "null"
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        
        return cell
    }

}

extension DetailViewController: CBCentralManagerDelegate {
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.discoverServices(nil)
        print("Connected!")
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        // 顯示狀態
        
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
                
        }
    }
        
}

extension DetailViewController: CBPeripheralDelegate {
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {

        for serviceObj in peripheral.services! {
            let service:CBService = serviceObj
            let isServiceIncluded = self.btServices.filter({ (item: BTServiceInfo) -> Bool in
                return item.service.uuid == service.uuid
            }).count
            if isServiceIncluded == 0 {
                btServices.append(BTServiceInfo(service: service, characteristics: []))
            }
            peripheral.discoverCharacteristics(nil, for: service)
            
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        
        let serviceCharacteristics = service.characteristics
        
        for item in btServices {
            if item.service.uuid == service.uuid {
                item.characteristics = serviceCharacteristics!
                break
            }
        }
        
        tableview.reloadData()
    }

}
