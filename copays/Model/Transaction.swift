//
//  Transaction.swift
//  copays
//
//  Created by Christianto Vinsen on 07/04/22.
//

import Foundation

class Transaction: Codable {
    var categoryIndex: Int
    var name: String
    var amount: Double
    var date: Date
    var chosenMembersIndex: [Int]
    
    init(categoryIndex: Int, name: String, amount: Double, date: Date, chosenMembersIndex: [Int]) {
        self.categoryIndex = categoryIndex
        self.name = name
        self.amount = amount
        self.date = date
        self.chosenMembersIndex = chosenMembersIndex
    }
}
