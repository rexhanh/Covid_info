//
//  Extension.swift
//  Covid Information
//
//  Created by Yuanrong Han on 8/1/20.
//  Copyright © 2020 Rex_han. All rights reserved.
//

import Foundation
import UIKit

extension Date{
    var formatteddate: String {
        return Formatter.datestr.string(from: self)
    }
}

extension String {
    var formatteddate: Date {
        return Formatter.datestr.date(from: self)!
    }
    
    var formatteddate0: Date {
        return Formatter.datestr0.date(from: self)!
    }
}

extension Formatter {
    static let withSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = ","
        formatter.numberStyle = .decimal
        return formatter
    }()
}

extension Numeric{
    var formattedWithSeparator: String {
        return Formatter.withSeparator.string(for: self) ?? ""
    }
}

extension Formatter {
    static let datestr: DateFormatter = {
        let formatter = DateFormatter()
        switch NSLocale.current.identifier {
        case "en_US":
            formatter.dateFormat = "MM/dd/yyyy"
        case "zh-Hans_US":
            formatter.dateFormat = "yyyy/MM/dd"
        default:
            formatter.dateFormat = "MM/dd/yyyy"
        }
        return formatter
    }()
    
    static let datestr0: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        return formatter
    }()
}


extension UIColor {
    static var linechartRed: UIColor {
        return UIColor(displayP3Red: 181/255, green: 30/255, blue: 47/255, alpha: 1)
    }
    
    static var linechartDarkBlue: UIColor {
        return UIColor(displayP3Red: 93/255, green: 112/255, blue: 144/255, alpha: 1)
    }
}

extension UIFont {
    func withTraits(traits:UIFontDescriptor.SymbolicTraits) -> UIFont {
        let descriptor = fontDescriptor.withSymbolicTraits(traits)
        return UIFont(descriptor: descriptor!, size: 0) //size 0 means keep the size as it is
    }

    func bold() -> UIFont {
        return withTraits(traits: .traitBold)
    }

    func italic() -> UIFont {
        return withTraits(traits: .traitItalic)
    }
}
