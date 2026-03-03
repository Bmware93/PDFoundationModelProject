//
//  CardView.swift
//  FoundationModelDemo
//
//  Created by Maria Reyna on 3/3/26.
//

import SwiftUI

struct CardView: View {
    let mood: Moods
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .frame(width: 175, height: 148)
            .foregroundStyle(.gray)
            .overlay(alignment: .leading){
                VStack(alignment: .leading) {
                    Text(mood.emoji)
                        .font(.largeTitle)
                        
                    Text(mood.rawValue)
                        .font(.title2)
                    Text(mood.description)
                        .font(.caption)
                        .italic()
                }.padding(.leading)
            }
    }
 
}

#Preview {
    CardView(mood: .lowEnergy)
}
