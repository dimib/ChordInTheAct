//
//  ApplicationState.swift
//  ChordInTheAct
//
//  Created by Dimitri Brukakis on 06.07.23.
//

import Foundation
import Combine

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
    
    let audioStreamManager = AudioStreamManager()
    private var soundClassifier: SoundClassifier?
    private var audioAnalyzer: AudioAnalyzer?

    func startAnalyzer() {
        do {
            try audioStreamManager.setupCaptureSession()
        } catch {
            
        }
    }
    
}
