//
//  EntryBlocksItem.swift
//  MT_iOS
//
//  Created by CHEEBOW on 2015/06/10.
//  Copyright (c) 2015年 Six Apart, Ltd. All rights reserved.
//

import UIKit
import MMMarkdown

class EntryBlocksItem: EntryTextAreaItem {
    var blocks = [BaseEntryItem]()
   
    override init() {
        super.init()
        
        type = "blocks"
    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        super.encodeWithCoder(aCoder)
        aCoder.encodeObject(self.blocks, forKey: "blocks")
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.blocks = aDecoder.decodeObjectForKey("blocks") as! [BaseEntryItem]
    }
    
    override func value() -> String {
        var value = ""
        for block in blocks {
            if block is BlockImageItem {
                value += block.value() + "\n"
            } else {
                let sourceText = block.value()
                if (block as! BlockTextItem).format == Entry.EditMode.Markdown {
                    if isPreview {
                        do {
                            let markdown = try MMMarkdown.HTMLStringWithMarkdown(sourceText, extensions: MMMarkdownExtensions.GitHubFlavored)
                            value += markdown + "\n"
                        } catch _ {
                            value += sourceText + "\n"
                        }
                    } else {
                        value += sourceText + "\n"
                    }
                } else {
                    value += "<p>" + sourceText + "</p>" + "\n"
                }
            }
        }
        
        return value
    }
    
    override func dispValue()-> String {
        if blocks.count == 0 {
            return ""
        }
        
        if isImageCell() {
            let block = blocks[0] as! BlockImageItem
            if block.asset != nil {
                return block.url
            }
            
            return block.imageFilename
        } else {
            let block = blocks[0] as! BlockTextItem
            return block.text
        }
    }
    
    func isImageCell()-> Bool {
        if blocks.count == 0 {
            return false
        }
        
        let block = blocks[0]
        
        if block is BlockImageItem {
            return true
        }
        
        return false
    }
    
    override func clear() {
        blocks.removeAll(keepCapacity: false)
    }
}
