//
//  IngredientHeader.swift
//  FoundationModelDemo
//
//  Created by Benia Morgan-Ware on 3/3/26.
//

import SwiftUI

struct IngredientHeader: View {
    var body: some View {
        header
    }
}

#Preview {
    IngredientHeader()
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
