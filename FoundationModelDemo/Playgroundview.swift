//
//  Playgroundview.swift
//  FoundationModelDemo
//
//  Created by Benia Morgan-Ware on 3/2/26.
//

import Foundation
import Playgrounds
import FoundationModels

#Playground {

    let instructions = """
        You are a creative and empathetic personal chef assistant. Your job is to suggest recipes based on the user's current mood and the ingredients they have available at home.

        """
    let session = LanguageModelSession(instructions: instructions)
    
    let prompt = """
        When given a mood and a list of ingredients, you will:
        1. Acknowledge the user's mood briefly and warmly (1 sentence).
        2. Suggest 1–3 recipes that match both their emotional state and available ingredients.
        3. For each recipe, provide:
           - Recipe name
           - Why it suits their mood
           - Ingredients needed (only from the provided list)
           - Simple step-by-step instructions (5–8 steps)
           - Estimated prep + cook time
        """
    do {
        let response = try await session.respond(to: prompt)
        print(response.content)
    } catch {
        print("error: \(error)")
        if let error = error as?
            FoundationModels.LanguageModelSession
            .GenerationError {
            print("Error \(error.localizedDescription)")
        }
    }
    
}


