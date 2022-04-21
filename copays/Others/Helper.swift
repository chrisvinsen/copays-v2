//
//  Helper.swift
//  copays
//
//  Created by Christianto Vinsen on 07/04/22.
//

import Foundation

class Helper {
    static func isTransactionCategoryExists(name: String) -> Bool {
        for trxCategory in Constant.transactionCategories {
            if trxCategory.name.lowercased() == name.lowercased() {
                return true
            }
        }
        
        return false
    }
    
    static func getTransactionCategoryIndex(name: String) -> Int {
        for (trxCategoryIndex, trxCategory) in Constant.transactionCategories.enumerated() {
            if trxCategory.name.lowercased() == name.lowercased() {
                return trxCategoryIndex
            }
        }
        
        // 0 as default value to avoid program crash
        return 0
    }

    static func isShowingOnboardingPage() -> Bool {
        return !UserDefaults.standard.bool(forKey: "isNotShowingOnboardingPage")
    }
    
    static func setNotShowingOnboardingPage() {
        UserDefaults.standard.set(true, forKey: "isNotShowingOnboardingPage")
    }
}

