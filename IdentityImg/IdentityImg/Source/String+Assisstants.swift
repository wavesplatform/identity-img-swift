//
//  String+Assisstants.swift
//  IdentityImg
//
//  Created by Prokofev Ruslan on 16/09/2018.
//  Copyright © 2018 Waves. All rights reserved.
//

import Foundation

extension String {
    func symbol(by index: Int) -> String? {
        guard index < count else { return nil }
        let index = self.index(startIndex, offsetBy: index)
        return String(self[index])
    }
}
