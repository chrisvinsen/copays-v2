//
//  DateModel.swift
//  copays
//
//  Created by Suherda Dwi Santoso on 09/04/22.
//

import Foundation

class GrandParentModel : NSObject {
    var grandParentName = ""
    var Expense = ""
    var parentMArr = [ParentModel]()
    var depthLevel = 0
    var isExpanded = false
    var hasChild = false
    
    init(dataDict : Dictionary<String, Any>) {
        super.init()
        grandParentName = dataDict["grandParentName"] as! String
        Expense = dataDict["Expense"] as! String
        let parentArr = dataDict["parent"] as! Array<Any>
        for item in parentArr
        {
            let parentM = ParentModel(dataDict: item as! Dictionary<String, Any>)
            parentMArr.append(parentM)
        }
    }
}
