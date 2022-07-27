//
//  ContentView.swift
//  PhoneticTrainer
//
//  Created by user on 7/24/22.
//

import SwiftUI


struct ContentView: View {
    
    @State private var currLetter = alphabet[Int.random(in: 0..<26)]
    @State private var showMessage = false
    @State private var showingScore = false
    @State private var messageTitle = ""
    @State private var messageBody = ""
    @State private var score = 0
    @State private var mode = ""
    @State private var scoreTitle = ""
    @State private var numQuestion = 0
    @State private var correctAnswer = false
    @State private var lettersUsed = [String]()
    @State private var endingTitle = ""
    @State private var endingBody = ""
    @State private var showEndingMessage = false
    
    func startGame() {
        if let wordListURL = Bundle.main.url(forResource: "sorted_words", withExtension: "txt") {
            if let sortedWords = try? String(contentsOf: wordListURL) {
                allWords = sortedWords.components(separatedBy: "\n")
                targetWords = allWords.filter { $0.starts(with: currLetter) }
                
                return
            }
        }
        fatalError("Word list could not be loaded")
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
    
    func getWords() -> [String] {
        var shownWords = targetWords[0...3]
        
        if mode == "NATO" {
            shownWords.append(NATO[currLetter]!)
        }
        
        if mode == "LAPD" {
            shownWords.append(LAPD[currLetter]!)
        }
        
        let uniqueWords = Array(Set(shownWords))
        
        return uniqueWords.shuffled()
    }
    
    func wordChoice(word: String) {
        if mode == "NATO" {
            if word == NATO[currLetter] {
                score += 1
                scoreTitle = "Correct!"
                correctAnswer = true
            } else {
                scoreTitle = "Try Again"
            }
        }
        
        if mode == "LAPD" {
            if word == LAPD[currLetter] {
                score += 1
                scoreTitle = "Correct!"
                correctAnswer = true
            } else {
                scoreTitle = "Try Again"
            }
        }
        
        showingScore = true
        checkGameEnd()
    }
    
    func nextQuestion() {
        lettersUsed.append(currLetter)
        
        if correctAnswer == true {
            withAnimation {
                currLetter = alphabet[Int.random(in: 0..<26)]
                while lettersUsed.contains(currLetter) {
                    currLetter = alphabet[Int.random(in: 0..<26)]
                }
                targetWords = allWords.filter { $0.starts(with: currLetter) }
                numQuestion += 1
                correctAnswer = false
            }
        }
    }
    
    func checkGameEnd() {
        if numQuestion >= 25 {
            endingTitle = "Game Over!"
            endingBody = "You scored \((score / 26) * 100)% accuracy."
            showEndingMessage = true
        }
    }
    
    func resetGame() {
        currLetter = alphabet[Int.random(in: 0..<26)]
        showMessage = false
        showingScore = false
        messageTitle = ""
        messageBody = ""
        score = 0
        mode = ""
        scoreTitle = ""
        numQuestion = 0
        correctAnswer = false
        lettersUsed = [String]()
        endingTitle = ""
        endingBody = ""
        showEndingMessage = false
        
        chooseMode()
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(stops: [
                    .init(color: .red, location: 0.35),
                    .init(color: .white, location: 0.4),
                    .init(color: .blue, location: 0.6)
                ]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
                
                VStack {
                    Text(currLetter)
                        .font(.system(size: 140).weight(.bold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    if mode != "" {
                        // display list of words
                        VStack {
                            List(getWords(), id: \.self) { word in
                                Button {
                                    wordChoice(word: word)
                                } label: {
                                    Text(word)
                                        .foregroundStyle(.secondary)
                                        .font(.title)
                                }
                            }
                            .listRowInsets(EdgeInsets()) // << to zero padding
                            .background(.regularMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                        }
                        Spacer()
                    }
                }
            }
            .alert(messageTitle, isPresented: $showMessage) {
                Button("NATO", action: setNATO)
                Button("LAPD", action: setLAPD)
            } message: {
                Text(messageBody)
            }
            .alert(scoreTitle, isPresented: $showingScore) {
                Button("Continue", action: nextQuestion)
            }
            .alert(endingTitle, isPresented: $showEndingMessage) {
                Button("Play Again", action: resetGame)
            } message: {
                Text(endingBody)
            }
            .toolbar {
                ToolbarItem() {
                    Text(mode)
                        .font(.largeTitle)
                        .foregroundColor(.white)
                    
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("Score: \(score)")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                }
            }
            .onAppear {
                chooseMode()
                startGame()
            }
            .onDisappear {
                
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
