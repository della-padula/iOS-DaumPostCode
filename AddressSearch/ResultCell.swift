//
//  ResultCell.swift
//  AddressSearch
//
//  Created by TaeinKim on 2020/03/16.
//  Copyright © 2020 TaeinKim. All rights reserved.
//

import Foundation
import UIKit

public struct Address {
    let addressName   : String
    var postCode      : String
    
    var roadAddr      : String
    var jibunAddr     : String
    
    var depthOneAddr  : String
    var deptTwoAddr   : String
    var deptThreeAddr : String
}

protocol ResultCellDelegate {
    func didSelectOK(didSelectItem: Address?)
}

class ResultCell: UITableViewCell {
    @IBOutlet weak var lblPostCode: UILabel!
    @IBOutlet weak var lblRoadAddr: UILabel!
    @IBOutlet weak var lblJibunAddr: UILabel!
    
    var item: Address? {
        didSet {
            self.lblPostCode.text  = item?.postCode
            self.lblRoadAddr.text  = item?.roadAddr
            self.lblJibunAddr.text = item?.jibunAddr
        }
    }
    
    var delegate: ResultCellDelegate?
    
    @IBAction func onClickSelect(_ sender: Any) {
        self.delegate?.didSelectOK(didSelectItem: self.item)
    }
}
