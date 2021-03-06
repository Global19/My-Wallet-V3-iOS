//
//  NSAttributedString+Conveniences.swift
//  Blockchain
//
//  Created by Alex McGregor on 7/30/18.
//  Copyright © 2018 Blockchain Luxembourg S.A. All rights reserved.
//

import PlatformKit
import ToolKit
import UIKit

@objc extension NSMutableAttributedString {

    /// Sets the foreground color of the substring `text` to the provided `color`
    /// if `text` is within this attributed string's range.
    ///
    /// - Parameters:
    ///   - color: the foreground color to set
    ///   - text: the text to set a foreground color to
    public func addForegroundColor(_ color: UIColor, to text: String) {
        guard let range = string.range(of: text) else {
            Logger.shared.info("Cannot add color to attributed string. Text is not in range.")
            return
        }
        addAttribute(
            NSAttributedString.Key.foregroundColor,
            value: color,
            range: NSRange(range, in: string)
        )
    }
}

extension NSAttributedString {

    public var height: CGFloat {
        heightForWidth(width: CGFloat.greatestFiniteMagnitude)
    }

    public var width: CGFloat {
        let size = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        let rect = boundingRect(with: size, options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)
        return ceil(rect.size.width)
    }

    public func boundingRectForWidth(_ width: CGFloat) -> CGRect {
        let size = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        return boundingRect(with: size, options: [.usesLineFragmentOrigin, .usesDeviceMetrics], context: .none)
    }

    public func fontAttribute() -> UIFont? {
        guard length > 0 else { return nil }
        guard let font = attribute(NSAttributedString.Key.font, at: 0, effectiveRange: nil) as? UIFont else { return nil }
        return font
    }

    public func heightForWidth(width: CGFloat) -> CGFloat {
        let size = CGSize(width: width, height: width == CGFloat.greatestFiniteMagnitude ? 0 : CGFloat.greatestFiniteMagnitude)
        let rect = boundingRect(with: size, options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)
        return ceil(rect.size.height)
    }

    public func withFont(_ font: UIFont) -> NSAttributedString {
        if fontAttribute() == .none {
            let copy = NSMutableAttributedString(attributedString: self)
            copy.addAttribute(NSAttributedString.Key.font, value: font, range: NSRange(location: 0, length: copy.length))
            return copy
        }
        return copy() as! NSAttributedString
    }
    
    public static func lineBreak() -> NSAttributedString {
        NSAttributedString(string: "\n")
    }
    
    public static func space() -> NSAttributedString {
        NSAttributedString(string: " ")
    }
}

extension Sequence where Element: NSAttributedString {
    
    func join(withSeparator separator: NSAttributedString? = nil) -> NSAttributedString {
        let result = NSMutableAttributedString()
        for (index, string) in enumerated() {
            if index > 0 {
                if let separator = separator {
                    result.append(separator)
                }
            }
            result.append(string)
        }
        return result
    }
}
