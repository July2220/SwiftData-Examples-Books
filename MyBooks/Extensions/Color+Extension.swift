//
//  Color+Extension.swift
//  MyBooks
//
//  Created by july on 2024/3/18.
//

import SwiftUI


//convert HEX strings to Color
extension Color {

    init?(hex: String) {
        guard let uiColor = UIColor(hex: hex) else { return nil }
        self.init(uiColor: uiColor)
    }

    func toHexString(includeAlpha: Bool = false) -> String? {
        return UIColor(self).toHexString(includeAlpha: includeAlpha)
    }

}
