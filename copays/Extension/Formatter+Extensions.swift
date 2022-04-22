//
//  Formatter+Extensions.swift
//  copays
//
//  Created by Christianto Vinsen on 22/04/22.
//

import Foundation

extension Formatter {
    static let withSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        return formatter
    }()
}
