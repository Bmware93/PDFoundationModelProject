//
//  AvailibilityView.swift
//  FoundationModelDemo
//
//  Created by Benia Morgan-Ware on 3/2/26.
//

import SwiftUI
import FoundationModels

struct AvailibilityView: View {
    private var model = SystemLanguageModel.default
    
    var body: some View {
        switch model.availability {
        case .available:
            ContentView()
            
        case .unavailable(.modelNotReady):
            Text("The model is not ready yet. Please try again later.")
        case .unavailable(.appleIntelligenceNotEnabled):
            Text("Apple intelligence is not enabled on this device. Please enable Apple Intelligence in Settings.app.")
        case .unavailable(.deviceNotEligible):
            Text("This device does not support Apple Intelligence. Apple Intelligence requires a compatible device.")
            
        case .unavailable(let other):
            Text("An unknown error occurred: \(other)")
        }
    }
}

#Preview {
    AvailibilityView()
}
