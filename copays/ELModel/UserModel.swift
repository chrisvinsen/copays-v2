//
//  UserModel.swift
//  copays
//
//  Created by Suherda Dwi Santoso on 09/04/22.
//

import Foundation

class ChildModel: NSObject {

    var childName = ""
    var Expensess = ""
    var toyName = ""
    var depthLevel = 2
    var isExpanded = false
    
    init(dataDict : Dictionary<String, Any>) {
        super.init()
        childName = dataDict["childName"] as! String
        Expensess = dataDict["Expensess"] as! String
        toyName = dataDict["toyName"] as! String
    }
}
