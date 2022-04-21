//
//  MyTripTableViewCell.swift
//  copays
//
//  Created by Ryan Vieri Kwa on 04/04/22.
//

import UIKit

class MyTripTableViewCell: UITableViewCell {

    @IBOutlet weak var cardView: UIView!

    @IBOutlet weak var tripImage: UIImageView!
    @IBOutlet weak var memberIcon: UIImageView!
    
    @IBOutlet weak var tripName: UILabel!
    @IBOutlet weak var totalMember: UILabel!
    @IBOutlet weak var totalExpense: UILabel!
    @IBOutlet weak var tripDate: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        memberIcon.tintColor = .black
        configureCardView()
    }

    func configureCardView(){
        cardView.backgroundColor = .gray
        cardView.layer.cornerRadius = 10.0
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
