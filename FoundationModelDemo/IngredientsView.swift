//
//  IngredientsView.swift
//  FoundationModelDemo
//
//  Created by Benia Morgan-Ware on 3/4/26.
//

import SwiftUI

struct IngredientsView: View {
    let selectedMood: Moods
    @Environment(\.dismiss) private var dismiss
    @State private var appState = AppState()
    @State private var searchText = ""
    @State private var currentMood: Moods
    
    // Sample quick add ingredients
    private let quickAddIngredients = ["Eggs", "Chicken", "Avocado", "Rice", "Tomatoes", "Onions", "Garlic", "Pasta"]
    
    init(selectedMood: Moods) {
        self.selectedMood = selectedMood
        self._currentMood = State(initialValue: selectedMood)
    }
    
    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                // Header with back button and mood indicator
                header
                
                // Main content
                ScrollView {
                    VStack(spacing: 24) {
                        Spacer()
                        
                        titleSection
                        searchSection
                        quickAddSection
                        fridgeContentsSection
                    }
                    .padding(.horizontal)
                }
            }
        }
        .navigationBarHidden(true)
    }
    
    private var header: some View {
        HStack {
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
            
            Spacer()
        }
        .padding(.horizontal)
        .padding(.top, 8)
    }
    
    private var moodIndicator: some View {
        HStack {
            Text("\(selectedMood.emoji) Feeling \(selectedMood.rawValue)")
                .font(.subheadline)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(selectedMood.color, in: Capsule())
            
            Spacer()
        }
        .padding(.horizontal)
        .padding(.top, 8)
    }
    
    private var titleSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Mood indicator with menu
            HStack {
                Menu {
                    ForEach(Moods.allCases, id: \.self) { mood in
                        Button {
                            currentMood = mood
                        } label: {
                            HStack {
                                Text("\(mood.emoji) \(mood.rawValue)")
                                if currentMood == mood {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    }
                } label: {
                    Text("\(currentMood.emoji) Feeling \(currentMood.rawValue)")
                        .font(.subheadline)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(currentMood.color.opacity(0.60), in: Capsule())
                        .foregroundStyle(.white)
                }
                
                Spacer()
            }
            .padding(.bottom, 16)
            
            Text("What's in your fridge?")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("Add ingredients and we'll craft the perfect meal for you")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    private var searchSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Image(systemName: "leaf.fill")
                    .foregroundStyle(.green)
                
                TextField("Type an ingredient...", text: $searchText)
                    .textFieldStyle(.plain)
                    .font(.body)
                    .onSubmit {
                        appState.addIngredient(searchText)
                        searchText = ""
                    }
            }
            .padding()
            .background(
                Color(UIColor.systemBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color(UIColor.separator), lineWidth: 1)
                    )
            )
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
    
    private var quickAddSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("QUICK ADD")
                .font(.caption)
                .fontWeight(.medium)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                ForEach(quickAddIngredients.filter { !appState.fridgeIngredients.contains($0) }, id: \.self) { ingredient in
                    Button {
                        appState.addIngredient(ingredient)
                    } label: {
                        Text("+ \(ingredient)")
                            .font(.subheadline)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .background(
                                Color(UIColor.systemBackground)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color(UIColor.separator), lineWidth: 1)
                                    )
                            )
                            .foregroundStyle(.primary)
                            .clipShape(Capsule())
                    }
                }
            }
        }
    }
    
    private var fridgeContentsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            if appState.fridgeIngredients.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "refrigerator")
                        .font(.system(size: 48))
                        .foregroundStyle(.quaternary)
                    
                    Text("Add some ingredients above")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 32)
            } else {
                Text("IN YOUR FRIDGE")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 12) {
                    ForEach(appState.fridgeIngredients, id: \.self) { ingredient in
                        HStack(spacing: 8) {
                            Text(ingredient)
                                .font(.subheadline)
                                .lineLimit(1)
                                .minimumScaleFactor(0.7)
                                .truncationMode(.tail)
                            
                            Spacer(minLength: 0)
                            
                            Button {
                                appState.removeIngredient(ingredient)
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(
                            Color(UIColor.systemBackground)
                                .overlay(
                                    Capsule()
                                        .stroke(Color(UIColor.separator), lineWidth: 1)
                                )
                        )
                        .clipShape(Capsule())
                    }
                }
                
                // Continue button
                NavigationLink {
                    MealSuggestionsView(mood: currentMood, ingredients: appState.fridgeIngredients)
                } label: {
                    Text("Find Perfect Meals")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(currentMood.color, in: RoundedRectangle(cornerRadius: 12))
                }
                .padding(.top, 24)
            }
        }
    }
}

#Preview {
    IngredientsView(selectedMood: .lowEnergy)
}
