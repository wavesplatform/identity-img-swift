//
//  Array+Assisstants.swift
//  IdentityImg
//
//  Created by Prokofev Ruslan on 16/09/2018.
//  Copyright © 2018 Waves. All rights reserved.
//

import Foundation

extension Array {

    /**
     beginIndex
     The zero-based index at which to begin extraction. If negative, it is treated as strLength + beginIndex where strLength is the length of the string (for example, if beginIndex is -3 it is treated as strLength - 3). If beginIndex is greater than or equal to the length of the string, slice() returns an empty string.
     endIndex
     Optional. The zero-based index before which to end extraction. The character at this index will not be included. If endIndex is omitted, slice() extracts to the end of the string. If negative, it is treated as strLength + endIndex where strLength is the length of the string (for example, if endIndex is -3 it is treated as strLength - 3).
     */

    func slice(beginIndex: Int, endIndex: Int) -> Array<Element> {

        var trueBeginIndex: Int = 0
        if beginIndex < 0 {
            trueBeginIndex = count + beginIndex
        } else {
            trueBeginIndex = beginIndex
        }

        var trueEndIndex: Int = 0
        if endIndex < 0 {
            trueEndIndex = count + endIndex
        } else {
            trueEndIndex = endIndex
        }

        trueBeginIndex = Swift.min(count, trueBeginIndex)
        trueBeginIndex = Swift.max(trueBeginIndex, 0)
        trueEndIndex = Swift.min(count, trueEndIndex)
        trueEndIndex = Swift.max(trueEndIndex, 0)

        return Array<Element>(self[trueBeginIndex..<trueEndIndex])
    }
}
