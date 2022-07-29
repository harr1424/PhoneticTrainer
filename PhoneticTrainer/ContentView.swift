//
//  ContentView.swift
//  PhoneticTrainer
//
//  Created by user on 7/24/22.
//

import SwiftUI


struct ContentView: View {
    
    // Get a random alphabet character
    @State private var currLetter = alphabet[Int.random(in: 0..<26)]
    
    // Display a message upon starting game prompting user to choose a mode
    @State private var mode = ""
    @State private var showMessage = false
    @State private var messageTitle = ""
    @State private var messageBody = ""
    
    // Store an array of alphabet characters that have not yet been shown to the user
    @State private var availableLetters = alphabet
    @State private var lettersRemaining = 26


    @State private var score = 0
    @State private var correctAnswer = false
    
    // Display an ending message to the user showing score and prompting them to play again
    @State private var endingTitle = ""
    @State private var endingBody = ""
    @State private var showEndingMessage = false
    
    
    /* Called in .onAppear(), loads a wordlist from the app bundle and sets targetWords to contain
     all words beginning with the current randomly chosen character. */
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
    
    /* Called in .onAppear() and resetGame(), displays a message to the user containing information
     about the different phonetic alphabets and prompts them to select one. */
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
    
    /* Called in nextQuestion(), each time a new question is loaded, updates targetWords to contain
     words beginning with the current randomly chosen character. Shuffles this array, adds the correct
     answer from either the NATO or LAPD alphabet, removes potential duplicates, and shuffles the result
     so that the correct answer is randomly placed in the list of choices. */
    func getWords() -> [String] {
        targetWords = allWords.filter { $0.starts(with: currLetter) }.shuffled()
        
        var shownWords = targetWords[0...4]
        
        if mode == "NATO" {
            shownWords.append(NATO[currLetter]!)
        }
        
        if mode == "LAPD" {
            shownWords.append(LAPD[currLetter]!)
        }
        
        let uniqueWords = Array(Set(shownWords))
        
        return uniqueWords.shuffled()
    }
    
    /* Called each time a user selects a word, evaluates the chosen word for correctness, updates the
     running score, and calls nextQuestion() to load the next question. */
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
    
    /* Decrements lettersRemaining and removes the previously shown character from the array of available
     characters. Provided there are still unusedcharacters remaining, selects a new randomly chosen character to display.
     If all alphabet characters have been used, endGame() is called. */
    func nextQuestion() {
        lettersRemaining -= 1
        correctAnswer = false
        
        availableLetters.removeAll(where : {$0 == currLetter})
                
        guard lettersRemaining > 0 else {
            endGame()
            
            return
        }
        currLetter = availableLetters[Int.random(in: 0..<lettersRemaining)]
        
        targetWords = getWords()
    }
    
    // Displays ending message to user and prompts them to play again
    func endGame() {
        endingTitle = "Game Over!"
        endingBody = String(format: "You scored %.0f%% accuracy", ((Double(score) / 26) * 100))
        showEndingMessage = true
    }
    
    // Reset the game state to original condition 
    func resetGame() {
        currLetter = alphabet[Int.random(in: 0..<26)]
        showMessage = false
        messageTitle = ""
        messageBody = ""
        score = 0
        mode = ""
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
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



