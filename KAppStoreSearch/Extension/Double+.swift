//
//  Double+.swift
//  KAppStoreSearch
//
//  Created by yc on 2023/09/17.
//

import Foundation

extension Double {
    var convertToUnitString: String {
        let numberFomatter = NumberFormatter()
        numberFomatter.roundingMode = .floor
        
        var target = self
        var unit = ""
        
        if self / 10000.0 >= 10 {
            numberFomatter.maximumFractionDigits = 0
            target = self / 10000.0
            unit = "만"
        } else if self / 10000.0 >= 1 {
            numberFomatter.maximumFractionDigits = 1
            target = self / 10000.0
            unit = "만"
        } else if self / 1000.0 >= 1 {
            numberFomatter.maximumFractionDigits = 1
            target = self / 1000.0
            unit = "천"
        } else {
            numberFomatter.maximumFractionDigits = 0
            target = self
            unit = ""
        }
        
        return "\(numberFomatter.string(for: target) ?? "0")\(unit)"
    }
}
