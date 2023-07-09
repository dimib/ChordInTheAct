//
//  ContentView.swift
//  ChordInTheAct
//
//  Created by Dimitri Brukakis on 06.07.23.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var viewModel: ApplicationModel
    
    var analyzerIconName: String {
        viewModel.audioStreamState != .idle ? "waveform.circle.fill" : "waveform.circle"
    }
    
    var stopIconName: String {
        viewModel.audioStreamState == .idle ? "stop.fill" : "stop"
    }

    var body: some View {
        ZStack {
            Color.gray.ignoresSafeArea(.all)
            
            VStack {
                Spacer()
                
                VStack {
                    VStack(alignment: .center) {
                        ZStack {
                            Text(viewModel.chordSuggestion)
                                .font(.system(size: 80, weight: .bold))
                                .foregroundColor(.black)
                            Text(viewModel.suggestionConfidence)
                                .font(.system(size: 120, weight: .bold))
                                .foregroundColor(.gray.opacity(0.2))
                        }
                    }
                    .frame(minWidth: 80, maxWidth: .infinity, minHeight: 300)
                    .background(Color.white)
                    .cornerRadius(24)
                    .padding(.horizontal, 24)
                }
                VStack {
                    WaveView(data: viewModel.audioAnalyzerData)
                        .background(Color.black)
                        .frame(minWidth: 80, maxWidth: .infinity, minHeight: 80, maxHeight: 80)
                        .cornerRadius(9)
                }
                .padding(.horizontal, 24)
                .padding(.top, 24)
                                
                HStack(spacing: 32) {
                    Button(action: { viewModel.startAnalyzer() }) {
                        Image(systemName: analyzerIconName)
                            .resizable()
                            .frame(width: 64, height: 64)
                            .foregroundColor(.black)
                    }

                    Button(action: { viewModel.stopAnalyzer() }) {
                        Image(systemName: stopIconName)
                            .resizable()
                            .frame(width: 64, height: 64)
                            .foregroundColor(.black)
                    }
                    .buttonStyle(.automatic)
                }
                .padding(.top, 24)
                
                Spacer()
            }
        }
        .onAppear {
            AudioAuthorization.requestAuthorization()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ApplicationModel())
    }
}
