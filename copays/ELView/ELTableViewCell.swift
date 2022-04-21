//
//  ELTableViewCell.swift
//  copays
//
//  Created by Suherda Dwi Santoso on 09/04/22.
//

import Foundation
import UIKit

class ELTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titlel: UILabel!
    @IBOutlet weak var expEnses: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setUpData() {
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }


}
