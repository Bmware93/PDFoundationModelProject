//
//  ContentView.swift
//  FoundationModelDemo
//
//  Created by Benia Morgan-Ware on 3/2/26.
//

import SwiftUI

struct ContentView: View {
    let columns = [
        GridItem(.adaptive(minimum: 160), spacing: 16)
    ]
    
    var body: some View {
        ZStack {
            Color(UIColor.systemBackground)
                .ignoresSafeArea()
            
            NavigationStack {
                VStack(spacing: 0) {
                    // Header section
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Image(systemName: "fork.knife.circle.fill")
                                .foregroundStyle(.secondary)
                                .font(.title2)
                            Text("MOODMEAL")
                                .font(.headline)
                                .fontWeight(.medium)
                                .foregroundStyle(.secondary)
                            Spacer()
                        }
                        .padding(.horizontal)
                        .padding(.top)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("How are you feeling right now?")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundStyle(.primary)
                            
                            Text("We'll suggest the perfect meal for your energy & mood.")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.bottom, 32)
                    
                    // Cards section
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(Moods.allCases, id: \.self) { mood in
                                CardView(mood: mood)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .navigationBarHidden(true)
            }
        }
    }
}

#Preview {
    ContentView()
}

private var header: some View {
    VStack(alignment: .leading, spacing: 8) {
        Text("What's in your fridge?")
            .font(.largeTitle.weight(.regular))
            .foregroundStyle(.primary)
        
        Text("Add ingrediants and we'll craft the perfect meal for you!")
            .font(.subheadline)
            .foregroundStyle(.secondary)
    }
}
