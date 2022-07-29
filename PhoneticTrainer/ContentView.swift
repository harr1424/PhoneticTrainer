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
    @State private var messageTitle = ""
    @State private var messageBody = ""
    @State private var score = 0
    @State private var mode = ""
    @State private var numQuestion = 0
    @State private var lettersRemaining = 26
    @State private var availableLetters = alphabet
    @State private var correctAnswer = false
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
        messageBody = "The NATO phonetic alphabet is used by military and paramilitary organizations as well as businesses that frequently enage in telephony (i.e. airline and freight call centers).\n\nThe LAPD phonetic alphabet is used primarily by public safety dispatchers in North America."
        showMessage = true
    }
    
    func setNATO() {
        mode = "NATO"
    }
    
    func setLAPD() {
        mode = "LAPD"
    }
    
    func getWords() -> [String] {
        targetWords = allWords.filter { $0.starts(with: currLetter) }.shuffled()
        
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
                correctAnswer = true
            } else {
                withAnimation {
                    correctAnswer = false
                }
            }
        }
        
        if mode == "LAPD" {
            if word == LAPD[currLetter] {
                score += 1
                correctAnswer = true
            } else {
                withAnimation {
                    correctAnswer = false
                }
            }
        }
        nextQuestion()
    }
    
    
    
    func nextQuestion() {
        numQuestion += 1
        lettersRemaining -= 1
        correctAnswer = false
        
        availableLetters.removeAll(where : {$0 == currLetter})
        
        print(lettersRemaining, availableLetters)
        
        guard lettersRemaining > 0 else {
            endGame()
            
            return
        }
        currLetter = availableLetters[Int.random(in: 0..<lettersRemaining)]
        
        targetWords = getWords()
    }
    
    func endGame() {
        endingTitle = "Game Over!"
        endingBody = String(format: "You scored %.0f%% accuracy", ((Double(score) / 26) * 100))
        showEndingMessage = true
    }
    
    func resetGame() {
        currLetter = alphabet[Int.random(in: 0..<26)]
        showMessage = false
        messageTitle = ""
        messageBody = ""
        score = 0
        mode = ""
        numQuestion = 0
        lettersRemaining = 26
        availableLetters = alphabet
        correctAnswer = false
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
                        .animation(.easeIn)
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
                            .animation(.easeIn)
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



