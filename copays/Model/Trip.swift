//
//  Trip.swift
//  copays
//
//  Created by Ryan Vieri Kwa on 05/04/22.
//

import Foundation

class Trip: Codable{
    var name: String?
    var date: String?
    var totalExpenses: Double?
    var totalMembers: Int?
    var isDone: Bool?
    var members = [Member]()
    var transactions = [Transaction]()
    
    init(name: String, date: String, totalExpenses: Double, totalMembers: Int, isDone: Bool, members: [Member], transactions: [Transaction]) {
        self.name = name
        self.date = date
        self.totalExpenses = totalExpenses
        self.totalMembers = totalMembers
        self.isDone = isDone
        self.members = members
        self.transactions = transactions
    }
}
