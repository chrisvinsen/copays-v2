//
//  CategoryModel.swift
//  copays
//
//  Created by Suherda Dwi Santoso on 09/04/22.
//

import Foundation

class ParentModel: NSObject {

    var parentName = ""
    var Expenses = ""
    var childMArr = [ChildModel]()
    var depthLevel = 1
    var isExpanded = false
    var hasChild = false
    init(dataDict : Dictionary<String, Any>) {
        super.init()
        parentName = dataDict["parentName"] as! String
        Expenses = dataDict["Expenses"] as! String
        let childArr = dataDict["child"] as! Array<Any>
        for item in childArr
        {
            let topicM = ChildModel(dataDict: item as! Dictionary<String, Any>)
            childMArr.append(topicM)
        }
    }
}
