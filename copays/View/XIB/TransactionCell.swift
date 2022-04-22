//
//  TransactionCell.swift
//  copays
//
//  Created by Christianto Vinsen on 21/04/22.
//

import UIKit

class TransactionCell: UITableViewCell {

    @IBOutlet weak var imgTrxCategory: UIImageView!
    @IBOutlet weak var labelTrxName: UILabel!
    @IBOutlet weak var labelTrxAmount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
