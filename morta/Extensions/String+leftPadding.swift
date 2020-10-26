//
//  String+leftPadding.swift
//  morta
//
//  Created by unkonow on 2020/10/24.
//

import Foundation

extension String {

      func leftPadding(toLength: Int, withPad: String) -> String {
        let stringLength = self.count
        if stringLength < toLength {
            return String(repeating:withPad, count: toLength - stringLength) + self
        } else {
            return String(self.suffix(toLength))
        }
    }
}
