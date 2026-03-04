//
//  MealImageService.swift
//  FoundationModelDemo
//
//  Created by Benia Morgan-Ware on 3/4/26.
//

import SwiftUI
import Foundation

struct MealImageService {
    
    /// Alternative approaches for getting meal images without Foundation Models image generation
    
    // MARK: - Option 1: Food Emoji-Based Visual Representations
    
    static func getFoodEmoji(for mealName: String) -> String {
        let mealLower = mealName.lowercased()
        
        // Map common meal types to appropriate emojis
        if mealLower.contains("pasta") || mealLower.contains("spaghetti") || mealLower.contains("noodle") {
            return "🍝"
        } else if mealLower.contains("pizza") {
            return "🍕"
        } else if mealLower.contains("burger") || mealLower.contains("sandwich") {
            return "🍔"
        } else if mealLower.contains("soup") || mealLower.contains("stew") {
            return "🍲"
        } else if mealLower.contains("salad") {
            return "🥗"
        } else if mealLower.contains("egg") || mealLower.contains("omelet") {
            return "🍳"
        } else if mealLower.contains("rice") || mealLower.contains("curry") {
            return "🍛"
        } else if mealLower.contains("fish") || mealLower.contains("salmon") {
            return "🐟"
        } else if mealLower.contains("chicken") {
            return "🍗"
        } else if mealLower.contains("meat") || mealLower.contains("beef") || mealLower.contains("steak") {
            return "🥩"
        } else if mealLower.contains("bread") || mealLower.contains("toast") {
            return "🍞"
        } else if mealLower.contains("taco") {
            return "🌮"
        } else if mealLower.contains("pancake") {
            return "🥞"
        } else if mealLower.contains("waffle") {
            return "🧇"
        } else if mealLower.contains("smoothie") {
            return "🥤"
        } else {
            return "🍽️" // Generic meal emoji
        }
    }
    
    // MARK: - Option 2: SF Symbols-Based Icons
    
    static func getSFSymbol(for mealName: String) -> String {
        let mealLower = mealName.lowercased()
        
        if mealLower.contains("soup") || mealLower.contains("stew") {
            return "bowl.fill"
        } else if mealLower.contains("coffee") || mealLower.contains("drink") {
            return "cup.and.saucer.fill"
        } else if mealLower.contains("breakfast") {
            return "sun.max.fill"
        } else if mealLower.contains("dinner") {
            return "moon.stars.fill"
        } else if mealLower.contains("salad") {
            return "leaf.fill"
        } else if mealLower.contains("grill") || mealLower.contains("bbq") {
            return "flame.fill"
        } else {
            return "fork.knife"
        }
    }
    
    // MARK: - Option 3: Bundled Food Images
    
    /// You could include a set of generic food photos in your app bundle
    /// This method would return appropriate bundled images
    static func getBundledImage(for mealName: String) -> String? {
        let mealLower = mealName.lowercased()
        
        // Map to bundled image names (you would include these in your app)
        let imageMap: [String: String] = [
            "pasta": "pasta-generic",
            "soup": "soup-generic", 
            "salad": "salad-generic",
            "sandwich": "sandwich-generic",
            "breakfast": "breakfast-generic"
        ]
        
        for (keyword, imageName) in imageMap {
            if mealLower.contains(keyword) {
                return imageName
            }
        }
        
        return nil
    }
    
    // MARK: - Option 4: Generated Pattern/Gradient Images
    
    static func createPatternImage(for meal: MealSuggestion, mood: Moods) -> some View {
        GeometryReader { geometry in
            ZStack {
                // Base gradient
                LinearGradient(
                    colors: [
                        mood.color.opacity(0.8),
                        mood.color.opacity(0.4),
                        Color.clear
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                
                // Pattern overlay
                Canvas { context, size in
                    let rows = Int(size.height / 20)
                    let cols = Int(size.width / 20)
                    
                    for row in 0..<rows {
                        for col in 0..<cols {
                            if (row + col) % 3 == 0 {
                                let rect = CGRect(
                                    x: CGFloat(col) * 20,
                                    y: CGFloat(row) * 20,
                                    width: 20,
                                    height: 20
                                )
                                context.fill(
                                    Path(rect),
                                    with: .color(.white.opacity(0.1))
                                )
                            }
                        }
                    }
                }
                
                // Content overlay
                VStack(spacing: 8) {
                    Text(getFoodEmoji(for: meal.name))
                        .font(.system(size: 32))
                    
                    Text(meal.name)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 8)
                        .background(.black.opacity(0.3), in: Capsule())
                }
            }
        }
    }
}

// MARK: - Option 5: Third-Party Image APIs

extension MealImageService {
    
    /// Example integration with Unsplash or similar food photo APIs
    /// Note: This would require API keys and network requests
    static func searchFoodImage(for mealName: String) async -> URL? {
        // This is a placeholder for integrating with services like:
        // - Unsplash API (free food photos)
        // - Pexels API (free stock photos)  
        // - Your own curated food photo collection
        
        let query = mealName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "food"
        
        // Example Unsplash URL (you'd need to register for an API key)
        // let urlString = "https://api.unsplash.com/search/photos?query=\(query)&orientation=landscape&category=food"
        
        // For now, return nil to indicate no external image found
        return nil
    }
}

// MARK: - Enhanced UI Components

struct EnhancedMealImagePlaceholder: View {
    let meal: MealSuggestion
    let mood: Moods
    
    var body: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(
                LinearGradient(
                    colors: [
                        mood.color.opacity(0.6),
                        mood.color.opacity(0.3),
                        mood.color.opacity(0.1)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .frame(height: 120)
            .overlay {
                VStack(spacing: 12) {
                    // Large food emoji
                    Text(MealImageService.getFoodEmoji(for: meal.name))
                        .font(.system(size: 40))
                    
                    // Meal name with stylish background
                    Text(meal.name)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background(
                            Capsule()
                                .fill(.black.opacity(0.4))
                                .stroke(.white.opacity(0.3), lineWidth: 1)
                        )
                        .multilineTextAlignment(.center)
                }
            }
            .overlay(
                // Subtle pattern overlay
                RoundedRectangle(cornerRadius: 12)
                    .stroke(
                        LinearGradient(
                            colors: [.white.opacity(0.3), .clear],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
    }
}

// MARK: - Creative Loading Animation

struct CreativeMealLoadingView: View {
    let mood: Moods
    @State private var rotationAngle: Double = 0
    @State private var pulseScale: CGFloat = 1.0
    @State private var currentStep = 0
    
    private let loadingSteps = [
        "🧄 Chopping ingredients...",
        "🍳 Heating up the pan...",
        "👨‍🍳 Mixing flavors...",
        "🔥 Adding some heat...",
        "✨ Perfecting the recipe...",
        "🍽️ Plating your meal..."
    ]
    
    var body: some View {
        VStack(spacing: 32) {
            // Animated cooking elements
            ZStack {
                // Background circle with mood color
                Circle()
                    .stroke(mood.color.opacity(0.2), lineWidth: 4)
                    .frame(width: 120, height: 120)
                
                // Rotating cooking utensils
                ForEach(0..<8, id: \.self) { index in
                    Image(systemName: getCookingIcon(for: index))
                        .font(.title2)
                        .foregroundStyle(mood.color.opacity(0.7))
                        .offset(x: 45)
                        .rotationEffect(.degrees(rotationAngle + Double(index * 45)))
                }
                
                // Center chef hat with pulsing animation
                ZStack {
                    Circle()
                        .fill(mood.color.opacity(0.1))
                        .frame(width: 60, height: 60)
                        .scaleEffect(pulseScale)
                    
                    Text("👨‍🍳")
                        .font(.system(size: 32))
                }
            }
            .onAppear {
                withAnimation(.linear(duration: 3).repeatForever(autoreverses: false)) {
                    rotationAngle = 360
                }
                
                withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                    pulseScale = 1.2
                }
            }
            
            // Dynamic loading text
            VStack(spacing: 12) {
                Text(loadingSteps[currentStep])
                    .font(.headline)
                    .foregroundStyle(mood.color)
                    .transition(.opacity.combined(with: .scale))
                
                Text("Crafting the perfect meal for your mood")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            .onAppear {
                startLoadingSequence()
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 32)
    }
    
    private func getCookingIcon(for index: Int) -> String {
        let icons = ["fork.knife", "spatula", "carrot.fill", "leaf.fill", "flame.fill", "drop.fill", "sparkles", "heart.fill"]
        return icons[index % icons.count]
    }
    
    private func startLoadingSequence() {
        var stepTimer: Timer?
        stepTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { _ in
            withAnimation(.easeInOut(duration: 0.5)) {
                currentStep = (currentStep + 1) % loadingSteps.count
            }
        }
    }
}