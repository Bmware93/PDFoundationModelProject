//
//  AppState.swift
//  FoundationModelDemo
//
//  Created by Benia Morgan-Ware on 3/4/26.
//

import SwiftUI

@Observable
@MainActor
class AppState {
    var fridgeIngredients: [String] = []
    var selectedMood: Moods?
    
    // Meal suggestion service
    let mealSuggestionService = MealSuggestionService()
    
    func addIngredient(_ ingredient: String) {
        let trimmedIngredient = ingredient.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedIngredient.isEmpty,
              !fridgeIngredients.contains(trimmedIngredient) else { return }
        
        fridgeIngredients.append(trimmedIngredient)
    }
    
    func removeIngredient(_ ingredient: String) {
        fridgeIngredients.removeAll { $0 == ingredient }
    }
    
    func clearFridge() {
        fridgeIngredients.removeAll()
    }
}
