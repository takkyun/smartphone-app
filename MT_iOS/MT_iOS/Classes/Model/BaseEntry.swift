//
//  BaseEntry.swift
//  MT_iOS
//
//  Created by CHEEBOW on 2015/05/22.
//  Copyright (c) 2015年 Six Apart, Ltd. All rights reserved.
//

import UIKit
import SwiftyJSON

class BaseEntry: BaseObject {
    enum Status: Int {
        case Publish = 0,
        Draft,
        Future,
        Unpublish
        
        func text()-> String {
            switch(self) {
            case .Publish:
                return "Publish"
            case .Draft:
                return "Draft"
            case .Future:
                return "Future"
            case .Unpublish:
                return "Unpublish"
            }
        }

        func label()-> String {
            switch(self) {
            case .Publish:
                return NSLocalizedString("Publish", comment: "Publish")
            case .Draft:
                return NSLocalizedString("Draft", comment: "Draft")
            case .Future:
                return NSLocalizedString("Future", comment: "Future")
            case .Unpublish:
                return NSLocalizedString("Unpublish", comment: "Unpublish")
            }
        }
    }

    enum EditMode: Int {
        case PlainText = 0,
        RichText,
        Markdown
        
        func text()-> String {
            switch(self) {
            case .PlainText:
                return "PlainText"
            case .RichText:
                return "RichText"
            case .Markdown:
                return "Markdown"
            }
        }
        
        func label()-> String {
            switch(self) {
            case .PlainText:
                return NSLocalizedString("PlainText", comment: "PlainText")
            case .RichText:
                return NSLocalizedString("RichText", comment: "RichText")
            case .Markdown:
                return NSLocalizedString("Markdown", comment: "Markdown")
            }
        }

        func format()-> String {
            switch(self) {
            case .PlainText:
                return "0"
            case .RichText:
                return "richtext"
            case .Markdown:
                return "markdown"
            }
        }
    }
    
    var title = ""
    var date: NSDate?
    var modifiedDate: NSDate?
    var unpublishedDate: NSDate?
    var status = ""
    var blogID = ""
    var body = ""
    var more = ""
    var excerpt = ""
    var keywords = ""
    var tags = [Tag]()
    var author: Author!
    var customFields = [CustomField]()
    var permalink = ""
    var basename = ""
    var format = ""
    
    var editMode: EditMode = .RichText

    override init(json: JSON) {
        super.init(json: json)
        
        title = json["title"].stringValue
        let dateString = json["date"].stringValue
        if !dateString.isEmpty {
            date = Utils.dateTimeFromISO8601String(dateString)
        }
        let modifiedDateString = json["modifiedDate"].stringValue
        if !modifiedDateString.isEmpty {
            modifiedDate = Utils.dateTimeFromISO8601String(modifiedDateString)
        }
        let unpublishedDateString = json["unpublishedDate"].stringValue
        if !unpublishedDateString.isEmpty {
            unpublishedDate = Utils.dateTimeFromISO8601String(unpublishedDateString)
        }
        status = json["status"].stringValue
        blogID = json["blog"]["id"].stringValue
        body = json["body"].stringValue
        more = json["more"].stringValue
        excerpt = json["excerpt"].stringValue
        keywords = json["keywords"].stringValue
        basename = json["basename"].stringValue
        
        tags.removeAll(keepCapacity: false)
        for item in json["tags"].arrayValue {
            let tag = Tag(json: item)
            tags.append(tag)
        }
        
        customFields.removeAll(keepCapacity: false)
        for item in json["customFields"].arrayValue {
            let customField = CustomField(json: item)
            customFields.append(customField)
        }
        
        author = Author(json: json["author"])

        permalink = json["permalink"].stringValue

        format = json["format"].stringValue
    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        super.encodeWithCoder(aCoder)
        aCoder.encodeObject(self.title, forKey: "title")
        aCoder.encodeObject(self.date, forKey: "date")
        aCoder.encodeObject(self.modifiedDate, forKey: "modifiedDate")
        aCoder.encodeObject(self.unpublishedDate, forKey: "unpublishedDate")
        aCoder.encodeObject(self.status, forKey: "status")
        aCoder.encodeObject(self.blogID, forKey: "blogID")
        aCoder.encodeObject(self.excerpt, forKey: "excerpt")
        aCoder.encodeObject(self.keywords, forKey: "keywords")
        aCoder.encodeObject(self.tags, forKey: "tags")
        aCoder.encodeObject(self.author, forKey: "author")
        aCoder.encodeObject(self.customFields, forKey: "customFields")
        aCoder.encodeObject(self.permalink, forKey: "permalink")
        aCoder.encodeObject(self.basename, forKey: "basename")
        aCoder.encodeObject(self.format, forKey: "format")
        aCoder.encodeInteger(self.editMode.rawValue, forKey: "editMode")
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.title = aDecoder.decodeObjectForKey("title") as! String
        self.date = aDecoder.decodeObjectForKey("date") as? NSDate
        self.modifiedDate = aDecoder.decodeObjectForKey("modifiedDate") as? NSDate
        self.unpublishedDate = aDecoder.decodeObjectForKey("unpublishedDate") as? NSDate
        self.status = aDecoder.decodeObjectForKey("status") as! String
        self.blogID = aDecoder.decodeObjectForKey("blogID") as! String
        self.excerpt = aDecoder.decodeObjectForKey("excerpt") as! String
        self.keywords = aDecoder.decodeObjectForKey("keywords") as! String
        self.tags = aDecoder.decodeObjectForKey("tags") as! [Tag]
        self.author = aDecoder.decodeObjectForKey("author") as! Author
        self.customFields = aDecoder.decodeObjectForKey("customFields") as! [CustomField]
        self.permalink = aDecoder.decodeObjectForKey("permalink") as! String
        self.basename = aDecoder.decodeObjectForKey("basename") as! String
        if let object: AnyObject = aDecoder.decodeObjectForKey("format") {
            self.format = object as! String
        }
        self.editMode = BaseEntry.EditMode(rawValue: aDecoder.decodeIntegerForKey("editMode"))!
    }
    
    func tagsString()-> String {
        var array = [String]()
        for tag in tags {
            array.append(tag.name)
        }
        
        return array.joinWithSeparator(",")
    }
    
    func setTagsFromString(string: String) {
        tags.removeAll(keepCapacity: false)
        let list = string.characters.split { $0 == "," }.map { String($0) }
        for item in list {
            tags.append(Tag(json: JSON(item)))
        }
    }
    
    func customFieldWithBasename(basename: String)-> CustomField? {
        for field in customFields {
            if field.basename == basename {
                return field
            }
        }
        
        return nil
    }
}
