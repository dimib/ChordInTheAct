//
//  ApplicationState.swift
//  ChordInTheAct
//
//  Created by Dimitri Brukakis on 06.07.23.
//

import Foundation
import Combine
import SoundAnalysis

final class ApplicationModel: ObservableObject {
    
    private var _audioAnalyzerSubject: PassthroughSubject<AudioAnalyzerData, AudioManagerError>?
    var audioAnalyzerPublisher: AnyPublisher<AudioAnalyzerData, AudioManagerError> {
        if let audioAnalyzerSubject = _audioAnalyzerSubject {
            return audioAnalyzerSubject.eraseToAnyPublisher()
        }
        let audioAnalyzerSubject = PassthroughSubject<AudioAnalyzerData, AudioManagerError>()
        _audioAnalyzerSubject = audioAnalyzerSubject
        return audioAnalyzerSubject.eraseToAnyPublisher()
    }
        
    private let audioStreamManager = AudioStreamManager()
    private var soundClassifier = CustomSoundClassifier()
    private var audioAnalyzer = AudioAnalyzer()
    private var cancellables = Set<AnyCancellable>()

    var audioStreamState: AudioStreamManager.AudioStreamManagerState { audioStreamManager.audioStreamManagerState }
    @Published var audioStreamManagerState: AudioStreamManager.AudioStreamManagerState = .idle
    @Published var audioAnalyzerData: AudioAnalyzerData = .zero
    @Published var chordSuggestion: String = ""
    @Published var suggestionConfidence: String = ""
    
    init() {
    }

    func startAnalyzer() {

        do {
            let audioFormat = try audioStreamManager.setupCaptureSession()
            
            try audioAnalyzer.setupAnalyzer(audioStream: audioStreamManager.audioStream)
            audioAnalyzer.publisher
                .receive(on: DispatchQueue.main)
                .sink(
                    receiveCompletion: { error in
                        self._audioAnalyzerSubject?.send(completion: .finished)
                    },
                    receiveValue: { audioAnalyzerData in
                        self.audioAnalyzerData = audioAnalyzerData
                        self._audioAnalyzerSubject?.send(audioAnalyzerData)
                })
                .store(in: &cancellables)
            
            try soundClassifier.setupClassifier(config: CustomSoundClassifierConfiguration.makeChordsConfig(),
                                                audioFormat: audioFormat, audioStream: audioStreamManager.audioStream)
            
            soundClassifier.soundClassifierState
                .receive(on: DispatchQueue.main)
                .sink { soundClassifierState in
                    switch soundClassifierState {
                    case .classification(let classification):
                        debugPrint(classification.first?.identifier ?? "")
                        self.updateChordSuggestion(classification)
                    default: break
                    }
                }
                .store(in: &cancellables)

        
            try audioStreamManager.start()
        } catch {
        }
    }
    
    func stopAnalyzer() {
        audioStreamManager.stop()
        chordSuggestion = ""
    }
    
    private func updateChordSuggestion(_ classification: [SNClassification]) {
        guard let bestSuggestion = classification.sorted(by: { $0.confidence > $1.confidence }).first else {
            chordSuggestion = ""
            suggestionConfidence = ""
            return
        }
        chordSuggestion = soundClassifier.translate(bestSuggestion.identifier)
        suggestionConfidence = "\(Int(bestSuggestion.confidence * 100))"
    }
}

enum PlayerState {
    case idle
    case recording
    case playing
    case analyzing
}
