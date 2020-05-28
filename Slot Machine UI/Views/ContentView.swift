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
    
    @State private var isActivateBet10: Bool = true
    @State private var isActivateBet20: Bool = false
    @State private var showingModal: Bool = true
    
    @State private var animatingModal: Bool = true
    
    
    
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
    
    func activateBet20(){
        betAmount = 20
        isActivateBet20 = true
        isActivateBet10 = false
    }
    
    func activateBet10(){
        betAmount = 10
        isActivateBet20 = false
        isActivateBet10 = true
    }
    
    //game is over
    func isGameOver(){
        if coins <= 0 {
            showingModal = true
        }
    }
    
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
                        
                        // game over
                        self.isGameOver()
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
                            self.activateBet20()
                        }){
                            Text("20")
                                .fontWeight(.heavy)
                                .foregroundColor(isActivateBet20 ? Color("ColorYellow") : .white)
                                .modifier(BetNumberModifier())
                        }
                        .modifier(BetCapsuleModifier())
                        
                        
                        Image("gfx-casino-chips")
                            .resizable()
                            .opacity(isActivateBet20 ? 1 :0)
                            .modifier(CasinoChipsModifier())
                    }
                    
                    //MARK: - bet 10
                    HStack(spacing: 10) {
                        Image("gfx-casino-chips")
                            .resizable()
                            .opacity(isActivateBet10 ? 1 :0)
                            .modifier(CasinoChipsModifier())
                        
                        Button(action: {
                            print("10 coins")
                            self.activateBet10()
                        }){
                            Text("10")
                                .fontWeight(.heavy)
                                .foregroundColor(isActivateBet10 ? Color("ColorYellow") : .white)
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
                .blur(radius: $showingModal.wrappedValue ? 5 : 0, opaque: false)
            //MARK: - popup
            if $showingModal.wrappedValue {
                ZStack{
                    Color("ColorTransparentBlack").edgesIgnoringSafeArea(.all)
                    
                    // MODAL
                    VStack(spacing: 0) {
                        // TITLE
                        Text("GAME OVER")
                            .font(.system(.title, design: .rounded))
                            .fontWeight(.heavy)
                            .padding()
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .background(Color("ColorPink"))
                            .foregroundColor(Color.white)
                        
                        Spacer()
                        
                        // MESSAGE
                        VStack(alignment: .center, spacing: 16) {
                            Image("gfx-seven-reel")
                                .resizable()
                                .scaledToFit()
                                .frame(maxHeight: 72)
                            
                            Text("Bad luck! You lost all of the coins. \nLet's play again!")
                                .font(.system(.body, design: .rounded))
                                .lineLimit(2)
                                .multilineTextAlignment(.center)
                                .foregroundColor(Color.gray)
                                .layoutPriority(1)
                            
                            Button(action: {
                                self.showingModal = false
                                self.animatingModal = false
                                self.activateBet10()
                                self.coins = 100
                            }) {
                                Text("New Game".uppercased())
                                    .font(.system(.body, design: .rounded))
                                    .fontWeight(.semibold)
                                    .accentColor(Color("ColorPink"))
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .frame(minWidth: 128)
                                    .background(
                                        Capsule()
                                            .strokeBorder(lineWidth: 1.75)
                                            .foregroundColor(Color("ColorPink"))
                                )
                            }
                        }
                        
                        Spacer()
                    }
                    .frame(minWidth: 280, idealWidth: 280, maxWidth: 320, minHeight: 260, idealHeight: 280, maxHeight: 320, alignment: .center)
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(color: Color("ColorTransparentBlack"), radius: 6, x: 0, y: 8)
                    .opacity($animatingModal.wrappedValue ? 1 : 0)
                    .offset(y: $animatingModal.wrappedValue ? 0 : -100)
                    .animation(Animation.spring(response: 0.6, dampingFraction: 1.0, blendDuration: 1.0))
                    .onAppear(perform: {
                        self.animatingModal = true
                    })
                }
            }
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

