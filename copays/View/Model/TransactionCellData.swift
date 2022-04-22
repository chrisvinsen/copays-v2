//
//  TripCellData.swift
//  copays
//
//  Created by Christianto Vinsen on 21/04/22.
//

import Foundation

struct SectionTransactionCellData {
    var transactionCellData = [TransactionCellData]()
}

struct TransactionCellData {
    var masterTrxIndex: Int
    var categoryIndex: Int?
    var transactionName: String?
    var totalAmount: String?
    var memberName: String?
    var splitedAmount: String?
    var cellType: TransactionTableCellType // Required
}
