//
//  MealSuggestionService.swift
//  FoundationModelDemo
//
//  Created by Benia Morgan-Ware on 3/4/26.
//

import Foundation
import FoundationModels
import SwiftUI

@Observable
@MainActor
class MealSuggestionService {
    var isGenerating = false
    var errorMessage: String?
    var mealSuggestions: [MealSuggestion] = []

    
    private let model = SystemLanguageModel.default
    private var currentSession: LanguageModelSession?
    
    var isModelAvailable: Bool {
        model.availability == .available
    }
    
    var unavailabilityReason: String {
        switch model.availability {
        case .available:
            return ""
        case .unavailable(.deviceNotEligible):
            return "Device not eligible for Apple Intelligence"
        case .unavailable(.appleIntelligenceNotEnabled):
            return "Please enable Apple Intelligence in Settings"
        case .unavailable(.modelNotReady):
            return "Model is downloading or not ready"
        case .unavailable(let other):
            return "Model unavailable: \(other)"
        }
    }
    
    func generateMealSuggestions(for mood: Moods, ingredients: [String]) async {
        guard isModelAvailable else {
            errorMessage = unavailabilityReason
            return
        }
        
        isGenerating = true
        errorMessage = nil
        
        do {
            let suggestions = try await requestMealSuggestions(mood: mood, ingredients: ingredients)
            mealSuggestions = suggestions
            
        } catch let error as LanguageModelSession.GenerationError {
            // Handle specific Foundation Models errors
            switch error {
            case .guardrailViolation:
                errorMessage = "Unable to generate suggestions with these ingredients. Try different ingredients or try again."
            case .exceededContextWindowSize:
                errorMessage = "Too many ingredients provided. Please try with fewer ingredients."
            default:
                errorMessage = "Unable to generate meal suggestions. Please try again with different ingredients."
            }
            mealSuggestions = []
        } catch {
            errorMessage = "Failed to generate meal suggestions. Please check your connection and try again."
            mealSuggestions = []
        }
        
        isGenerating = false
    }

    
    private func requestMealSuggestions(mood: Moods, ingredients: [String]) async throws -> [MealSuggestion] {
        // Create very conservative, safety-focused instructions
        let instructions = """
        You are a family-friendly cooking assistant that helps create simple meal ideas.
        
        Rules:
        - Only suggest basic, everyday cooking recipes
        - Use only common household ingredients
        - Keep all suggestions appropriate for all ages
        - Focus on simple preparation methods like mixing, heating, or combining ingredients
        - Avoid any complex cooking techniques
        - Be positive and encouraging
        """
        
        // Create a new session for this request
        let session = LanguageModelSession(instructions: instructions)
        currentSession = session
        
        // Create a very simple, safe prompt
        let prompt = createSafePrompt(mood: mood, ingredients: ingredients)
        
        // Use guided generation for structured output
        let response = try await session.respond(to: prompt, generating: MealSuggestionsResponse.self)
        
        return response.content.meals
    }
    
    private func createSafePrompt(mood: Moods, ingredients: [String]) -> String {
        // Filter and clean ingredients to avoid any problematic terms
        let safeIngredients = ingredients.filter { ingredient in
            // Only include basic food ingredients
            let basicFoods = ["eggs", "chicken", "beef", "fish", "rice", "pasta", "bread", "cheese", 
                             "milk", "butter", "tomatoes", "onions", "garlic", "potatoes", "carrots",
                             "lettuce", "spinach", "avocado", "banana", "apple", "salt", "pepper",
                             "oil", "flour", "sugar", "beans", "corn", "mushrooms", "broccoli"]
            return basicFoods.contains(ingredient.lowercased()) || ingredient.count < 15
        }
        
        let ingredientsList = safeIngredients.prefix(8).joined(separator: ", ")
        let moodContext = getSafeMoodContext(mood)
        
        return """
        Available ingredients: \(ingredientsList)
        
        Context: I'm looking for \(moodContext) meal ideas.
        
        Please suggest 2 simple recipes using these ingredients.
        """
    }
    
    private func getSafeMoodContext(_ mood: Moods) -> String {
        switch mood {
        case .lowEnergy:
            return "easy and quick"
        case .highEnergy:
            return "energizing"
        case .needComfort:
            return "comforting"
        case .needFuel:
            return "nutritious"
        case .quickAndEasy:
            return "fast"
        case .slowAndMindful:
            return "thoughtfully prepared"
        }
    }
}

// Structured response types for guided generation
@Generable(description: "Response containing meal suggestions")
struct MealSuggestionsResponse {
    @Guide(description: "List of 2-3 meal suggestions", .count(2...3))
    var meals: [MealSuggestion]
}

@Generable(description: "A single meal suggestion with details")
struct MealSuggestion: Hashable {
    @Guide(description: "Creative name for the meal")
    var name: String
    
    @Guide(description: "Brief explanation of why this meal fits the current mood")
    var whyItFitsYourMood: String
    
    @Guide(description: "List of ingredients needed from the provided ingredients")
    var ingredientsUsed: [String]
    
    @Guide(description: "Simple step-by-step cooking instructions", .count(3...6))
    var cookingSteps: [String]
    
    @Guide(description: "Estimated total time in minutes", .range(5...120))
    var estimatedTimeMinutes: Int
}
