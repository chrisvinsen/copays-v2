//
//  ELModel.swift
//  copays
//
//  Created by Suherda Dwi Santoso on 09/04/22.
//

import Foundation

class FamilyModel : NSObject {

    var grandParentMArr = [GrandParentModel]()
    
    init(dataDict : Dictionary<String, Any>) {
        super.init()
        let grandParentList = dataDict["grandParent"] as! Array<Any>
        for item in grandParentList
        {
            let grandparentM = GrandParentModel(dataDict: item as! Dictionary<String , Any>)
            grandParentMArr.append(grandparentM)
        }
    }
}
