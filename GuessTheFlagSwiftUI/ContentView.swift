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
    
    func ImageFlag(content: Image) -> some View {
        content
            .renderingMode(.original)
            .clipShape(RoundedRectangle(cornerRadius: 3))
            .overlay(RoundedRectangle(cornerRadius: 3).stroke(Color.black, lineWidth: 0.5))
            .shadow(color: .black, radius: 2)
    }
    
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
                        self.ImageFlag(content: Image(self.countries[number]))
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
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            score += 1
            withAnimation {
                self.animationAmount += 360
            }
        } else {
            scoreTitle = "Wrong! That’s the flag of \(countries[number])"
        }
        
        showingScore = true
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        self.questionNumber += 1
        resetingGame()
    }
    
    func resetingGame() {
        if self.questionNumber == 11 {
            self.questionNumber = 0
            self.score = 0
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
