//
//  TransactionHeaderCell.swift
//  copays
//
//  Created by Christianto Vinsen on 21/04/22.
//

import UIKit

class TransactionHeaderCell: UITableViewCell {

    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelTotalExpenses: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
