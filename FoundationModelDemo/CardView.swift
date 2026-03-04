//
//  CardView.swift
//  FoundationModelDemo
//
//  Created by Maria Reyna on 3/3/26.
//

import SwiftUI

struct CardView: View {
    let mood: Moods
    @State private var isPressed = false
    
    var body: some View {
        NavigationLink {
            IngredientsView(selectedMood: mood)
        } label: {
            RoundedRectangle(cornerRadius: 20)
                .frame(width: 175, height: 148)
                .foregroundStyle(isPressed ? mood.color : Color(UIColor.secondarySystemGroupedBackground))
                .overlay(alignment: .leading) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(mood.emoji)
                            .font(.system(size: 40))
                            .padding(.bottom, 8)
                            
                        Text(mood.rawValue)
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(isPressed ? .white : .primary)
                        
                        Text(mood.description)
                            .font(.caption)
                            .foregroundColor(isPressed ? .white.opacity(0.9) : .secondary)
                            .multilineTextAlignment(.leading)
                    }
                    .padding(.leading, 16)
                    .padding(.trailing, 8)
                }
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(
                            isPressed ? mood.color.opacity(0.3) : Color(UIColor.separator),
                            lineWidth: isPressed ? 2 : 1
                        )
                )
                .scaleEffect(isPressed ? 0.95 : 1.0)
                .animation(.easeInOut(duration: 0.25), value: isPressed)
        }
        .buttonStyle(PlainButtonStyle())
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    if !isPressed {
                        withAnimation(.easeInOut(duration: 0.30)) {
                            isPressed = true
                        }
                    }
                }
                .onEnded { _ in
                    withAnimation(.easeInOut(duration: 0.5)) {
                        isPressed = false
                    }
                }
        )
    }
}
 


#Preview {
    ZStack {
        Color(.systemGroupedBackground)
            .ignoresSafeArea()
        CardView(mood: .lowEnergy)
    }
    
}
