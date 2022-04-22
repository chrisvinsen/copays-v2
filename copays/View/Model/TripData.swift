//
//  TransactionList.swift
//  copays
//
//  Created by Christianto Vinsen on 21/04/22.
//

import Foundation

struct TripData {
    var expenseDatas = [ExpenseData]()
    
    func getTotalTripExpenses() -> Int64 {
        var totalExpenses: Int64 = 0
        for expense in expenseDatas {
            totalExpenses += expense.getTotalTransactionExpenses()
        }
        
        return totalExpenses
    }
}

struct ExpenseData {
    let date: String
    var transactionDatas = [TransactionData]()
    
    func getFormattedDate() -> String {
        CDate.toDateString(CDate.parse(date), format: "d MMMM YYYY")
    }
    
    func getTotalTransactionExpenses() -> Int64 {
        var totalExpenses: Int64 = 0
        for transaction in transactionDatas {
            totalExpenses += transaction.totalAmount
        }
        
        return totalExpenses
    }
}

struct TransactionData {
    let masterTrxIndex: Int
    let categoryIndex: Int
    let name: String
    let totalAmount: Int64
    var memberDatas = [MemberData]()
}

struct MemberData {
    let name: String
    let splitedAmount: Int64
}
