//
//  ContentView.swift
//  GuessTheFlagSwiftUI
//
//  Created by metalnodeug on 13/10/2019.
//  Copyright © 2019 metalnodeug. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var score = 0
    @State private var questionNumber = 0
    @State private var animationAmount = 0.0
    
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30) {
                VStack {
                    Text("Tap the flag of")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                    Text(countries[correctAnswer])
                        .font(.largeTitle)
                        .fontWeight(.black)
                        .foregroundColor(.white)
                }
                
                ForEach(0 ..< 3) { number in
                    Button(action: {
                        self.flagTapped(number)
                    }) {
                        Image(self.countries[number])
                            .renderingMode(.original)
                            .flagStyle()

                    }
                }
                .rotation3DEffect(.degrees(self.animationAmount), axis: (x: 0, y: 1, z: 0))
                Spacer()
                
                Text("Question number \(questionNumber) / 10")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                
                Spacer()
            }
            .alert(isPresented: $showingScore) {
                Alert(title: Text(scoreTitle), message: Text("Your score is \(score) / 10"), dismissButton: .default(Text("Continue")) {
                    self.askQuestion()
                    })
            }
        }
    }

    // Check if answer are correct or not
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            score += 1
            correctAnimation(number: correctAnswer)
        } else {
            scoreTitle = "Wrong! That’s the flag of \(countries[number])"
        }
        
        showingScore = true
    }


    //Ask a question and choose a random element
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        self.questionNumber += 1
        resetingGame()
    }

    // Reset the game
    func resetingGame() {
        if self.questionNumber == 11 {
            self.questionNumber = 0
            self.score = 0
        }
    }

    // Use this function to create a correct animation
    func correctAnimation(number: Int) {
        for flag in 0...2 {
            if flag == number {
                withAnimation {
                    self.animationAmount += 360
                }
            }
        }
    }

    // Use this function to create a wrong animation
    func wrongAnimation() {

    }
    
}

// Creating ViewModifier Style
struct FlagStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .clipShape(RoundedRectangle(cornerRadius: 3))
            .overlay(RoundedRectangle(cornerRadius: 3).stroke(Color.black, lineWidth: 0.5))
            .shadow(color: .black, radius: 2)
    }
}

// Used an extension to use with FlagStyle ViewModifier
extension View {
    func flagStyle() -> some View {
        self.modifier(FlagStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
