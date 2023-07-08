//
//  ContentView.swift
//  ChordInTheAct
//
//  Created by Dimitri Brukakis on 06.07.23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            Color.gray.ignoresSafeArea(.all)
            
            VStack {
                Spacer()
                
                VStack {
                    VStack(alignment: .center) {
                        Text("Cm")
                            .font(.system(size: 80, weight: .bold))
                            .foregroundColor(.black)
                    }
                    .frame(minWidth: 80, maxWidth: .infinity, minHeight: 300)
                    .background(Color.white)
                    .cornerRadius(24)
                    .padding(.horizontal, 24)
                }.background(Color.green)
                                
                Button(action: {}) {
                    Text("Start")
                        .font(.system(size: 24, weight: .heavy))
                        .foregroundColor(.black)
                }
                .buttonStyle(.automatic)
                
                Spacer()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
