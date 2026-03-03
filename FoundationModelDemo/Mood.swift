//
//  Mood.swift
//  FoundationModelDemo
//
//  Created by Benia Morgan-Ware on 3/3/26.
//

import Foundation
import SwiftUI

class Mood {
    var name: String
    var description: String
    var emoji: String
    var associatedColor: Color
    
    init(name: String, description: String, emoji: String, associatedColor: Color) {
        self.name = name
        self.description = description
        self.emoji = emoji
        self.associatedColor = associatedColor
    }
    
}
