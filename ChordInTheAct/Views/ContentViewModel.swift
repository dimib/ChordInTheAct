//
//  ContentViewModel.swift
//  ChordInTheAct
//
//  Created by Dimitri Brukakis on 06.07.23.
//

import Foundation

final class ContentViewModel: ObservableObject {
    
    @Published var analyzerData: AudioAnalyzerData = .zero
    let model = ApplicationModel()
    
    init() {
    }
    
    func startClassifier() {
        model.audioAnalyzerPublisher
            .receive(on: DispatchQueue.main)
    }
    
    func stopClassifier() {
        
    }
}
