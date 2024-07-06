//
//  CategoryColor.swift
//  OCHITSUKI
//
//  Created by Yoshitaka Tanaka on 2024/07/07.
//  Copyright © 2024 Yoshitaka. All rights reserved.
//

import SwiftUI

let allCategoryColors: [CategoryColor] = CategoryColor.allCases

enum CategoryColor: Int, Hashable, CaseIterable, Codable {
    case gray, red, blue, orange, purple, green, pink

    var color: Color {
        let isDarkMode = UITraitCollection.current.userInterfaceStyle == .dark

        let baseColor = switch self {
        case .gray: Color.gray
        case .red: Color.red
        case .blue: Color.blue
        case .orange: Color.orange
        case .purple: Color.purple
        case .green: Color.green
        case .pink: Color.pink
        }

        return baseColor.opacity(isDarkMode ? 0.8 : 0.4)
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(rawValue)
    }
}
