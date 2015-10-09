//
//  EntryTagItem.swift
//  MT_iOS
//
//  Created by CHEEBOW on 2015/06/08.
//  Copyright (c) 2015年 Six Apart, Ltd. All rights reserved.
//

import UIKit

class EntryTagItem: EntryTextItem {
    override init() {
        super.init()
        
        type = "tags"
    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        super.encodeWithCoder(aCoder)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func makeParams()-> [String : AnyObject] {
        let list = self.value().characters.split { $0 == "," }.map { String($0) }
        
        return ["tags":list]
    }
}
