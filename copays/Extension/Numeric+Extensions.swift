//
//  Int+Extensions.swift
//  copays
//
//  Created by Christianto Vinsen on 22/04/22.
//

import Foundation

extension Numeric {
    var formattedWithSeparator: String { Formatter.withSeparator.string(for: self) ?? "" }
    
    var formattedRupiahCurrency: String {
        "Rp \(Formatter.withSeparator.string(for: self) ?? "0")"
    }
}
