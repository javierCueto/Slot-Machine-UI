//
//  ContentView.swift
//  Slot Machine UI
//
//  Created by José Javier Cueto Mejía on 24/05/20.
//  Copyright © 2020 Pozolx. All rights reserved.
//

import SwiftUI

//MARK: - properties

struct ContentView: View {
    
    //MARK: - properties
    let symbols = ["gfx-bell","gfx-cherry","gfx-coin","gfx-grape","gfx-seven","gfx-strawberry",]
    
    @State private var highscore: Int = 0
    @State private var coins: Int = 100
    @State private var betAmount: Int = 10
    
    @State private var reels: Array = [0,1,2]
    @State private var showingInfoView: Bool = false
    
    
    //MARK: - functions
    // spin reels
    func spinReels(){
        //reels[0] = Int.random(in: 0...symbols.count - 1)
        //reels[1] = Int.random(in: 0...symbols.count - 1)
        //reels[2] = Int.random(in: 0...symbols.count - 1)
        
        reels = reels.map({ _ in
            Int.random(in: 0...symbols.count - 1)
            
        })
    }
    //check the winning
    func checkWinning(){
        if reels[0] == reels[1] &&  reels[1] == reels[2]  {
            //player wins
            playerWins()
            //new highscore
            print("here same data")
            if coins > highscore {
                newHighScore()
            }
            
        }else {
            //player loses
            playerLoses()
        }
        
    }
    
    func playerWins(){
        coins += betAmount * 10
    }
    
    func newHighScore(){
        highscore = coins
    }
    
    func playerLoses(){
        coins -= betAmount
    }
    
    //game is over
    
    //MARK: - body
    var body: some View {
        
        ZStack {
            
            //MARK: - background
            LinearGradient(gradient: Gradient(colors: [Color("ColorPink"),Color("ColorPurple")]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            //MARK: - interface
            
            
            VStack(spacing: 5) {
                
                //MARK: - header
                LogoView()
                Spacer()
                //MARK: - score
                HStack {
                    HStack(){
                        
                        Text("You\n Score")
                            .scoreLabelStyle()
                            .multilineTextAlignment(.trailing)
                        Text("\(coins)")
                            .scoreNumberLabelStyle()
                            .modifier(ScoreNumberModifier())
                        
                    }.modifier(ScoreContainerModifier())
                    
                    Spacer()
                    
                    HStack(){
                        
                        Text("\(highscore)")
                            .scoreNumberLabelStyle()
                            .modifier(ScoreNumberModifier())
                        
                        Text("Hight\nScore")
                            .scoreLabelStyle()
                            .multilineTextAlignment(.leading)
                        
                    }.modifier(ScoreContainerModifier())
                }
                
                //MARK: - slot machine
                VStack(spacing: 0){
                    
                    //MARK: - reel #1
                    ZStack(){
                        ReelView()
                        Image(symbols[reels[0]])
                            .resizable()
                            .modifier(ImageModifier())
                    }
                    Spacer()
                    //MARK: - reel #2
                    HStack{
                        ZStack(){
                            ReelView()
                            Image(symbols[reels[1]])
                                .resizable()
                                .modifier(ImageModifier())
                        }
                        //MARK: - reel #3
                        ZStack(){
                            ReelView()
                            
                            Image(symbols[reels[2]])
                                .resizable()
                                .modifier(ImageModifier())
                        }
                    }.frame(maxWidth: 500)
                    //MARK: - spin button
                    
                    Button(action: {
                        self.spinReels()
                        
                        //check winning
                        self.checkWinning()
                    }){
                        Image("gfx-spin")
                            .renderingMode(.original)
                            .resizable()
                            .modifier(ImageModifier())
                    }
                }.layoutPriority(2)
                
                //MARK: - footer
                Spacer()
                
                
                HStack {
                    
                    //MARK: - bet 20
                    HStack(spacing: 10) {
                        Button(action: {
                            print("20 coins")
                        }){
                            Text("20")
                                .fontWeight(.heavy)
                                .foregroundColor(.white)
                                .modifier(BetNumberModifier())
                        }
                        .modifier(BetCapsuleModifier())
                        
                        
                        Image("gfx-casino-chips")
                            .resizable()
                            .opacity(0)
                            .modifier(CasinoChipsModifier())
                    }
                    
                    //MARK: - bet 10
                    HStack(spacing: 10) {
                        Image("gfx-casino-chips")
                            .resizable()
                            .opacity(1)
                            .modifier(CasinoChipsModifier())
                        
                        Button(action: {
                            print("10 coins")
                        }){
                            Text("10")
                                .fontWeight(.heavy)
                                .foregroundColor(.yellow)
                                .modifier(BetNumberModifier())
                        }
                        .modifier(BetCapsuleModifier())
                        
                        
                        
                    }
                }
                
            }
                
                //MARK: - buttons
                .overlay(
                    Button(action: {
                        print("reset the game")
                    }){
                        Image(systemName: "arrow.2.circlepath.circle")
                    }.modifier(ButtonModifier()),
                    alignment: .topLeading
                    
                    
                    
                    
            )
                .overlay(
                    Button(action: {
                        self.showingInfoView = true
                    }){
                        Image(systemName: "info.circle")
                    }.modifier(ButtonModifier()),
                    alignment: .topTrailing
                    
                    
                    
            )
                
                .padding()
                .frame(maxWidth: 720)
            //MARK: - popup
        }
        .sheet(isPresented: self.$showingInfoView) {
            InfoView()
        }
        
        
        
    }
}


//MARK: - preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

