//
//  CharacteristicDetailViewController.swift
//  Bluetooth_Test
//
//  Created by NKMU.EDU on 2017/4/24.
//  Copyright © 2017年 NKMU.EDU.shion.ble_test. All rights reserved.
//

import UIKit
import CoreBluetooth

class CharacteristicDetailViewController: UIViewController {
    
    var peripheral:CBPeripheral!
    var characteristic: CBCharacteristic!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
