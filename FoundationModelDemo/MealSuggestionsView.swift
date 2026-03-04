//
//  MealSuggestionsView.swift
//  FoundationModelDemo
//
//  Created by Benia Morgan-Ware on 3/4/26.
//

import SwiftUI

struct MealSuggestionsView: View {
    let mood: Moods
    let ingredients: [String]
    @Environment(\.dismiss) private var dismiss
    @State private var mealService = MealSuggestionService()
    
    // Add a dismiss to root environment value
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    header
                    
                    ScrollView {
                        VStack(spacing: 24) {
                            titleSection
                            
                            if !mealService.isModelAvailable {
                                unavailableView
                            } else if mealService.isGenerating {
                                loadingView
                            } else if let errorMessage = mealService.errorMessage {
                                errorView(errorMessage)
                            } else if mealService.mealSuggestions.isEmpty {
                                emptyView
                            } else {
                                suggestionsView
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .task {
            if mealService.isModelAvailable && mealService.mealSuggestions.isEmpty {
                await mealService.generateMealSuggestions(for: mood, ingredients: ingredients)
            }
        }
    }
    
    private var header: some View {
        HStack {
            if mealService.isGenerating {
                // Show "Start Over" button when generating
                Button {
                    // Reset and dismiss to root
                    mealService.mealSuggestions = []
                    mealService.errorMessage = nil
                    dismiss()
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "arrow.uturn.backward")
                            .font(.title2)
                        Text("Start Over")
                            .font(.body)
                    }
                    .foregroundStyle(mood.color)
                }
            } else if mealService.mealSuggestions.isEmpty {
                // Show normal back button only when no meals are shown
                Button {
                    dismiss()
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                        Text("Back")
                            .font(.body)
                    }
                    .foregroundStyle(.primary)
                }
            }
            // No back button when meals are displayed
            
            Spacer()
            
            if mealService.isModelAvailable && !mealService.mealSuggestions.isEmpty && !mealService.isGenerating {
                Button {
                    Task {
                        await mealService.generateMealSuggestions(for: mood, ingredients: ingredients)
                    }
                } label: {
                    Image(systemName: "arrow.clockwise")
                        .font(.title2)
                        .foregroundStyle(.primary)
                }
            }
        }
        .padding(.horizontal)
        .padding(.top, 8)
    }
    
    private var titleSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("\(mood.emoji) Feeling \(mood.rawValue)")
                    .font(.subheadline)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(mood.color, in: Capsule())
                    .foregroundStyle(.white)
                
                Spacer()
            }
            .padding(.bottom, 16)
            
            Text("Perfect Meals for You")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("Based on your mood and ingredients")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    private var unavailableView: some View {
        VStack(spacing: 16) {
            Image(systemName: "brain.head.profile")
                .font(.system(size: 48))
                .foregroundStyle(.secondary)
            
            Text("Apple Intelligence Required")
                .font(.headline)
                .foregroundStyle(.primary)
            
            Text(mealService.unavailabilityReason)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 32)
        .background(
            Color(UIColor.secondarySystemGroupedBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color(UIColor.separator), lineWidth: 1)
                )
        )
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal)
    }
    
    private var loadingView: some View {
        CreativeMealLoadingView(mood: mood)
    }
    
    private func errorView(_ message: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 48))
                .foregroundStyle(.orange)
            
            Text("Something went wrong")
                .font(.headline)
            
            Text(message)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            
            Button {
                Task {
                    await mealService.generateMealSuggestions(for: mood, ingredients: ingredients)
                }
            } label: {
                Text("Try Again")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        mood.color
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(.white.opacity(0.2), lineWidth: 1)
                            )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 32)
    }
    
    private var emptyView: some View {
        VStack(spacing: 16) {
            Button {
                Task {
                    await mealService.generateMealSuggestions(for: mood, ingredients: ingredients)
                }
            } label: {
                VStack(spacing: 16) {
                    Image(systemName: "chef.hat")
                        .font(.system(size: 48))
                        .foregroundStyle(mood.color)
                    
                    Text("Generate Meal Ideas")
                        .font(.headline)
                        .foregroundStyle(mood.color)
                }
            }
            .disabled(mealService.isGenerating)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 32)
    }
    
    private var suggestionsView: some View {
        LazyVStack(spacing: 20) {
            ForEach(mealService.mealSuggestions, id: \.name) { suggestion in
                MealSuggestionCard(suggestion: suggestion, mood: mood)
            }
            
            // Try another meal button
            Button {
                // Navigate back to the root (ContentView)
                dismissToRoot()
            } label: {
                HStack {
                    Image(systemName: "arrow.uturn.left")
                        .font(.headline)
                    Text("Try Another Meal")
                        .font(.headline)
                }
                .foregroundStyle(mood.color)
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(mood.color, lineWidth: 1.5)
                        .fill(mood.color.opacity(0.05))
                )
            }
            .padding(.top, 16)
        }
    }
    
    // Helper function to dismiss to root
    private func dismissToRoot() {
        // Simple approach: dismiss this view and let navigation handle the rest
        presentationMode.wrappedValue.dismiss()
        
        // Post a notification to dismiss all views if needed
        NotificationCenter.default.post(name: Notification.Name("DismissToRoot"), object: nil)
    }
}

struct MealSuggestionCard: View {
    let suggestion: MealSuggestion
    let mood: Moods
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Image and Header
            VStack(alignment: .leading, spacing: 12) {
                // Enhanced placeholder with food emoji and mood-based styling
                EnhancedMealImagePlaceholder(meal: suggestion, mood: mood)
                
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(suggestion.name)
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Text("\(suggestion.estimatedTimeMinutes) minutes")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(
                                Color(UIColor.secondarySystemBackground)
                                    .overlay(
                                        Capsule()
                                            .stroke(Color(UIColor.separator), lineWidth: 0.5)
                                    )
                            )
                            .clipShape(Capsule())
                    }
                    
                    Spacer()
                    
                    Button {
                        withAnimation(.spring()) {
                            isExpanded.toggle()
                        }
                    } label: {
                        Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                            .font(.title2)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            
            // Why it fits your mood
            Text(suggestion.whyItFitsYourMood)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            if isExpanded {
                VStack(alignment: .leading, spacing: 16) {
                    // Ingredients
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Ingredients")
                            .font(.headline)
                            .foregroundStyle(mood.color)
                        
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 8) {
                            ForEach(suggestion.ingredientsUsed, id: \.self) { ingredient in
                                Text("• \(ingredient)")
                                    .font(.subheadline)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                    }
                    
                    // Cooking steps
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Cooking Steps")
                            .font(.headline)
                            .foregroundStyle(mood.color)
                        
                        ForEach(Array(suggestion.cookingSteps.enumerated()), id: \.offset) { index, step in
                            HStack(alignment: .top, spacing: 8) {
                                Text("\(index + 1).")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundStyle(mood.color)
                                
                                Text(step)
                                    .font(.subheadline)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                    }
                }
            }
        }
        .padding()
        .background(
            Color(UIColor.secondarySystemGroupedBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color(UIColor.separator), lineWidth: 1)
                )
        )
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    MealSuggestionsView(
        mood: .needComfort,
        ingredients: ["Eggs", "Bread", "Cheese", "Butter"]
    )
}
