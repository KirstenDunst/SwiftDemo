//
//  ListModel.swift
//  SwiftTest
//
//  Created by 曹世鑫 on 2019/12/20.
//  Copyright © 2019 曹世鑫. All rights reserved.
//

import UIKit
import HandyJSON

class TotalModel<ListModel: HandyJSON>: HandyJSON {
    required init() {}
    var data: [ListModel] = []
}


class ListModel: HandyJSON {
    required init () {}
    
    var title : String = ""
    var vcClassStr : String = ""

}
