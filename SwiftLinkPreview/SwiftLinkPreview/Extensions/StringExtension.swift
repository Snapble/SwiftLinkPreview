//
//  StringExtension.swift
//  SwiftLinkPreview
//
//  Created by Leonardo Cardoso on 09/06/2016.
//  Copyright © 2016 leocardz.com. All rights reserved.
//

import Foundation

extension String {
    
    // Trim
    var trim: String {
        
        return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        
    }
    
    // Remove extra white spaces
    var extendedTrim: String {
        
        let components = self.componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        return components.filter { !$0.isEmpty }.joinWithSeparator(" ").trim
        
    }
    
    // Decode HTML entities
    var decoded: String {
        
        let encodedData = self.dataUsingEncoding(NSUTF8StringEncoding)!
        let attributedOptions : [String: AnyObject] = [
            NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
            NSCharacterEncodingDocumentAttribute: NSUTF8StringEncoding
        ]
        
        do {
            
            let attributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
            
            return attributedString.string
            
        } catch _ {
            
            return self
            
        }
        
    }
    
    // Strip tags
    var tagsStripped: String {
        
        return self.stringByReplacingOccurrencesOfString(Regex.rawTagPattern, withString: "", options: .RegularExpressionSearch, range: nil)
        
    }
    
    // Delete HTML comments
    func deleteHtmlComments() -> String {
        
        return self.stringByReplacingOccurrencesOfString(Regex.htmlCommentPattern, withString: "", options: .RegularExpressionSearch, range: nil)
        
    }
    
    
    // Delete CDATA
    func deleteCData() -> String {
        
        return self.stringByReplacingOccurrencesOfString(Regex.cDataPattern, withString: "", options: .RegularExpressionSearch, range: nil)
        
    }
    
    // Delete HTML tags
    func deleteHTMLTag(tag: String) -> String {
        
        return
            self.stringByReplacingOccurrencesOfString("<\(tag)([^>]*)/>" , withString: "", options: .RegularExpressionSearch, range: nil).stringByReplacingOccurrencesOfString("<\(tag)([^>]*)>(.*?)</\(tag)>", withString: "", options: .RegularExpressionSearch, range: nil).stringByReplacingOccurrencesOfString("(?i)</?\(tag)\\b[^<]*>", withString: "", options: .RegularExpressionSearch, range: nil)
        
    }
    
    // Replace
    func replace(search: String, with: String) -> String {
        
        if let clearWith: String = with.stringByReplacingOccurrencesOfString(" ", withString: ""),
            let replaced: String = self.stringByReplacingOccurrencesOfString(search, withString: clearWith) {
            
            return replaced
            
        } else {
            
            return self
            
        }
        
    }
    
    // Substring
    func substring(start: Int, end: Int) -> String {
        
        return self.substringWithRange(Range(self.startIndex.advancedBy(start) ..< self.startIndex.advancedBy(end)))
        
    }
    func substring(range: NSRange) -> String {
        
        return self.substringWithRange(Range(self.startIndex.advancedBy(range.location) ..< self.startIndex.advancedBy(range.location + range.length)))
        
    }
    
    // Check if it's a valid url
    func isValidURL() -> Bool {
        
        return Regex.test(self, regex: Regex.rawUrlPattern)
            // && UIApplication.sharedApplication().canOpenURL(NSURL(string: self)!)
        
    }
    
    // Check if url is an image
    func isImage() -> Bool {
        
        return Regex.test(self, regex: Regex.imagePattern)
        
    }
    
}