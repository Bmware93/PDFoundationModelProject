//
//  ContentView.swift
//  FoundationModelDemo
//
//  Created by Benia Morgan-Ware on 3/2/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea(edges: .all)
            VStack {
                header
               
               
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
