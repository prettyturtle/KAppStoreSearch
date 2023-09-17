//
//  UILabel+.swift
//  KAppStoreSearch
//
//  Created by yc on 2023/09/17.
//

import UIKit

extension UILabel {
    func currentLineCount() -> Int {
        guard let currentText = text as? NSString else {
            return 0
        }
        
        let rect = CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude)
        
        let labelSize = currentText.boundingRect(
            with: rect,
            options: .usesLineFragmentOrigin,
            attributes: [.font: font as Any],
            context: nil
        )
        
        return Int(ceil(CGFloat(labelSize.height) / font.lineHeight))
    }
    
    func setLineHeight(with lineHeight: CGFloat) {
        let attrString = NSMutableAttributedString(string: text ?? "")
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineHeight
        
        let range = NSMakeRange(0, attrString.length)
        attrString.addAttribute(.paragraphStyle, value: paragraphStyle, range: range)
        
        attributedText = attrString
    }
}
