//
//  UIView+Extension.swift
//  copays
//
//  Created by Julyo  on 09/04/22.
//

import UIKit

extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get{ return cornerRadius }
        set{
            self.layer.cornerRadius = newValue
        }
    }
}
