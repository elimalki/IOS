//
//  FoundationExtension.swift
//  Talinor
//
//  Created by Vlad Kovalyov on 02/01/2019.
//  Copyright © 2019 Organization. All rights reserved.
//

import Foundation
import UIKit

extension String{
    func formattedNumber() -> String {
        let cleanPhoneNumber = self.map{ Int(String( $0 )) }.filter{ $0 != nil}
        let mask = "+X (XXX) XXX-XXXX"
        
        var result = ""
        var index = cleanPhoneNumber.startIndex
        for ch in mask {
            if index == cleanPhoneNumber.endIndex {
                break
            }
            if ch == "X" {
                result.append("\(cleanPhoneNumber[index]!)")
                index = cleanPhoneNumber.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }
    var isEmpty: Bool{
        return ( self.filter{ String( $0 ) != "" }.count <= 0 )
    }
    
    func size(with font: UIFont = UIFont.systemFont(ofSize: 18)) -> CGSize{
        let size = CGSize(width: 250, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let estimatedFrame = NSString(string: self).boundingRect(with: size,
                                                                 options: options,
                                                                 attributes: [NSAttributedString.Key.font: font],
                                                                 context: nil)
        return estimatedFrame.size
    }
    
    func canOpenURL() -> Bool {
        
        guard let url = URL(string: self) else {return false}
        if !UIApplication.shared.canOpenURL(url) {return false}
        
        //
        let regEx = "((https|http)://)((\\w|-)+)(([.]|[/])((\\w|-)+))+"
        let predicate = NSPredicate(format:"SELF MATCHES %@", argumentArray:[regEx])
        return predicate.evaluate(with: self, substitutionVariables: nil)
    }
}

extension Dictionary{
    mutating func merge(dict: [Key: Value]){
        for (k, v) in dict {
            updateValue(v, forKey: k)
        }
    }
}

extension Date {
    var yesterday: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    var tomorrow: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    var month: Int {
        return Calendar.current.component(.month,  from: self)
    }
    var isLastDayOfMonth: Bool {
        return tomorrow.month != month
    }
    var minutes: Int{
        return Calendar.current.dateComponents([.minute], from: self).minute ?? 0
    }
    var hour: Int{
        return Calendar.current.dateComponents([.hour], from: self).hour ?? 0
    }
    var second: Int{
        return Calendar.current.dateComponents([.second], from: self).second ?? 0
    }
    
    var day: Int{
        return Calendar.current.dateComponents([.day], from: self).day ?? 0
    }
}

extension Data {
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: self, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print("error:", error)
            return  nil
        }
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}

extension String {
    var html2AttributedString: NSAttributedString? {
        return Data(utf8).html2AttributedString
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}
