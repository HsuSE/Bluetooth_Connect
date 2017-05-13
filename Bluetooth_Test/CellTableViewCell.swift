//
//  CellTableViewCell.swift
//  Bluetooth_Test
//
//  Created by NKMU.EDU on 2017/4/3.
//  Copyright © 2017年 NKMU.EDU.shion.ble_test. All rights reserved.
//

import UIKit

class CellTableViewCell: UITableViewCell {

    @IBOutlet weak var label1: UILabel!
    
}

class DetailViewCell: UITableViewCell {
    
    @IBOutlet weak var lbUUID: UILabel!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbProp: UILabel!
    @IBOutlet weak var lbValue: UILabel!
    @IBOutlet weak var lbPropHex: UILabel!
}
