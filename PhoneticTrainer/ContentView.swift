//
//  ContentView.swift
//  PhoneticTrainer
//
//  Created by user on 7/24/22.
//

import SwiftUI

struct ContentView: View {
    
    let alphabet = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    
    @StateObject var speech = SpeechRecognizer()
    @State private var isRecording = false
    @State private var currLetter = Int.random(in: 0..<26)
    @State private var showMessage = false
    @State private var messageTitle = ""
    @State private var messageBody = ""
    @State private var score = 0
    @State private var buttonTitle = "Begin"
    @State private var mode = ""
    
    func buttonPress() {
        if isRecording {
            speech.stopTranscribing()
            buttonTitle = "Resume"
            isRecording.toggle()
        } else {
            speech.transcribe()
            buttonTitle = "Stop"
            isRecording.toggle()
        }
    }
    
    func chooseMode() {
        messageTitle = "Select phonetic alphabet"
        messageBody = "The NATO phonetic alphabet is used by military and paramilitary organizations as well as private entities that frequently enage in telephony (i.e. airline reservations made via phone). The LAPD phonetic alphabet is used primarily by public safety dispatchers in North America."
        showMessage = true
    }
    
    func setNATO() {
        mode = "NATO"
    }
    
    func setLAPD() {
        mode = "LAPD"
    }
    
    func getLAPD() -> String {
        return LAPD[alphabet[currLetter]]!
    }
    
    func getNATO() -> String {
        return NATO[alphabet[currLetter]]!
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(stops: [
                    .init(color: .red, location: 0.3),
                    .init(color: .white, location: 0.5),
                    .init(color: .blue, location: 0.7)
                ]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
                
                VStack {
                    Text(alphabet[currLetter])
                        .font(.system(size: 140).weight(.bold))
                    Spacer()
                    Spacer()
                    
                    if speech.waiting {
                        ProgressView()
                            .scaleEffect(5)
                    }
                    
                    Text(speech.transcript)
                        .font(.largeTitle)
                    Spacer()
                }
            }
            .alert(messageTitle, isPresented: $showMessage) {
                Button("NATO", action: setNATO)
                Button("LAPD", action: setLAPD)
            } message: {
                Text(messageBody)
            }
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    Button {
                        buttonPress()
                    } label: {
                        Text(buttonTitle)
                            .foregroundColor(.white)
                            .font(.largeTitle.weight(.bold))
                    }
                }
                ToolbarItem(placement: .principal) {
                    Image(systemName: isRecording ? "mic" : "mic.slash")
                        .font(.title)
                }
                ToolbarItem() {
                    Text(mode)
                        .font(.largeTitle)
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("Score: \(score)")
                        .font(.largeTitle)
                }
            }
            .onAppear {
                speech.reset()
                chooseMode()
            }
            .onDisappear {
                speech.stopTranscribing()
                isRecording = false
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
