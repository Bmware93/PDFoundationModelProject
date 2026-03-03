//
//  ContentView.swift
//  FoundationModelDemo
//
//  Created by Benia Morgan-Ware on 3/2/26.
//

import SwiftUI

struct ContentView: View {
    let columns = [
        GridItem(.adaptive(minimum: 140), spacing: 16)
    ]
    
    var body: some View {
        NavigationStack {
            Text("Mood Kitchen")
                .font(.largeTitle)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding([.horizontal,.top])
            VStack(spacing: 8) {
                Text("What are you feeling right now?")
                    .font(.title)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                
                Text("We'll suggest the perfect meal for your energy and mood")
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                
                GeometryReader { geo in
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(Moods.allCases, id: \.self) { mood in
                                CardView(mood: mood)
                                    .frame(minHeight: geo.size.height * 0.28)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 8)
                    }
                }
            }
            .padding(.top)
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
