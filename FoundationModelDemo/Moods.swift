//
//  mood.swift
//  FoundationModelDemo
//
//  Created by Maria Reyna on 3/3/26.
//

import SwiftUI

enum Moods: String, CaseIterable {
    case lowEnergy = "Low Energy"
    case highEnergy = "High Energy"
    case needComfort = "Need Comfort"
    case needFuel = "Need Fuel"
    case quickAndEasy = "Quick & Easy"
    case slowAndMindful = "Slow & Mindful"
    
    var emoji: String {
        switch self {
        case .lowEnergy:
            "🛋️"
        case .highEnergy:
            "⚡️"
        case .needComfort:
            "🥰"
        case .needFuel:
            "⛽"
        case .quickAndEasy:
            "⏱️"
        case .slowAndMindful:
            "🧘"
        }
    }
    var description: String {
        switch self {
        case .lowEnergy:      return "Couch vibes only."
        case .highEnergy:     return "Go big or go home."
        case .needComfort:    return "Hugs on a plate."
        case .needFuel:       return "Power bites, activate."
        case .quickAndEasy:   return "Fast. Tasty. Done."
        case .slowAndMindful: return "Savor the moment."
        }
    }
    var color: Color {
        switch self {
        case .lowEnergy:      return Color(.systemBlue).opacity(0.8)
        case .highEnergy:     return Color(.systemOrange)
        case .needComfort:    return Color(.systemPink)
        case .needFuel:       return Color(.systemRed)
        case .quickAndEasy:   return Color(.systemYellow)
        case .slowAndMindful: return Color(.systemGreen)
        }
    }
}
