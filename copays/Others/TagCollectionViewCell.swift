//
//  TagCollectionViewCell.swift
//  copays
//
//  Created by Christianto Vinsen on 07/04/22.
//

import UIKit

class TagCollectionViewCell: UICollectionViewCell {
  
    @IBOutlet weak var textName: UILabel!
    @IBOutlet weak var viewContainer: UIView!
    
    func setup(member: Member, active: Bool) {
        
        if active {
            viewContainer.backgroundColor = #colorLiteral(red: 0.05490196078, green: 0.662745098, blue: 0.3450980392, alpha: 1)
            textName.textColor = .white
        } else {
            viewContainer.backgroundColor = .white
            textName.textColor = #colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        }
        textName.text = String(member.name.prefix(20))
    }
    
    func setupActive(member: Member) {
        viewContainer.backgroundColor = UIColor(red: 0.05, green: 0.66, blue: 0.35, alpha: 0.25)
        textName.text = String(member.name.prefix(20))
    }
}
