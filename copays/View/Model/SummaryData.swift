//
//  Summary.swift
//  copays
//
//  Created by Christianto Vinsen on 12/04/22.
//

import Foundation

struct SummaryData {
    var summaryMemberData: [SummaryMemberData]

    func getTotalExpenses() -> Double {
        var totalExpenses: Double = 0

        for data in summaryMemberData {
            totalExpenses += data.getTotalMemberExpenses()
        }
        return totalExpenses
    }
}

struct SummaryMemberData {
    var memberName: String
    var summaryMemberExpenseData: [SummaryMemberExpenseData]

    func getTotalMemberExpenses() -> Double {
        var totalMemberExpenses: Double = 0

        for data in summaryMemberExpenseData {
            totalMemberExpenses += data.transactionAmount
        }

        return totalMemberExpenses
    }
}

struct SummaryMemberExpenseData {
    var categoryIndex: Int
    var transactionName: String
    var transactionAmount: Double

    func getCategoryDetails() -> TransactionCategory {
        return Constant.transactionCategories[categoryIndex]
    }
}
