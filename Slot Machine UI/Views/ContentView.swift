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
    
    let haptics = UINotificationFeedbackGenerator()
    
    @State private var highscore: Int = UserDefaults.standard.integer(forKey: "HighScore")
    @State private var coins: Int = 100
    @State private var betAmount: Int = 10
    
    @State private var reels: Array = [0,1,2]
    @State private var showingInfoView: Bool = false
    
    @State private var isActivateBet10: Bool = true
    @State private var isActivateBet20: Bool = false
    @State private var showingModal: Bool = false
    
    @State private var animatingModal: Bool = false
    
    @State private var animationSymbol: Bool =  false
    
    
    
    //MARK: - functions
    // spin reels
    func spinReels(){
        //reels[0] = Int.random(in: 0...symbols.count - 1)
        //reels[1] = Int.random(in: 0...symbols.count - 1)
        //reels[2] = Int.random(in: 0...symbols.count - 1)
        
        reels = reels.map({ _ in
            Int.random(in: 0...symbols.count - 1)
            
        })
        
        playSound(sound: "spin", type: "mp3")
        haptics.notificationOccurred(.success)
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
            }else{
                playSound(sound: "win", type: "mp3")
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
        UserDefaults.standard.set(highscore, forKey: "HighScore")
        playSound(sound: "high-score", type: "mp3")
    }
    
    func playerLoses(){
        coins -= betAmount
    }
    
    func activateBet20(){
        betAmount = 20
        isActivateBet20 = true
        isActivateBet10 = false
        playSound(sound: "casino-chips", type: "mp3")
        haptics.notificationOccurred(.success)
    }
    
    func activateBet10(){
        betAmount = 10
        isActivateBet20 = false
        isActivateBet10 = true
        playSound(sound: "casino-chips", type: "mp3")
        haptics.notificationOccurred(.success)
    }
    
    //game is over
    func isGameOver(){
        if coins <= 0 {
            showingModal = true
            playSound(sound: "game-over", type: "mp3")
        }
    }
    
    func resetGame(){
        UserDefaults.standard.set(0, forKey: "HighScore")
        highscore = 0
        activateBet10()
        playSound(sound: "chimeup", type: "mp3")
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
                            .opacity(self.animationSymbol ? 1: 0)
                            .offset(y: self.animationSymbol ? 0 : -50)
                            .animation(.easeOut(duration : Double.random(in: 0.5...0.7)))
                            .onAppear(perform: {
                                self.animationSymbol.toggle()
                                playSound(sound: "riseup", type: "mp3")
                            })
                    }
                    Spacer()
                    //MARK: - reel #2
                    HStack{
                        ZStack(){
                            ReelView()
                            Image(symbols[reels[1]])
                                .resizable()
                                .modifier(ImageModifier())
                                .opacity(self.animationSymbol ? 1: 0)
                                .offset(y: self.animationSymbol ? 0 : -50)
                                .animation(.easeOut(duration : Double.random(in: 0.7...0.9)))
                                .onAppear(perform: {
                                    self.animationSymbol.toggle()
                                })
                        }
                        //MARK: - reel #3
                        ZStack(){
                            ReelView()
                            
                            Image(symbols[reels[2]])
                                .resizable()
                                .modifier(ImageModifier())
                                .opacity(self.animationSymbol ? 1: 0)
                                .offset(y: self.animationSymbol ? 0 : -50)
                                .animation(.easeOut(duration : Double.random(in: 0.9...1.1)))
                                .onAppear(perform: {
                                    self.animationSymbol.toggle()
                                })
                        }
                    }.frame(maxWidth: 500)
                    //MARK: - spin button
                    
                    Button(action: {
                        //1set the deafult state: no animatio
                        withAnimation{
                            self.animationSymbol = false
                        }
                        //2sping the reels
                        self.spinReels()
                        
                        //3 trigger the animation after changing the symbols
                        withAnimation{
                            self.animationSymbol = true
                        }
                        
                        //4 check winning
                        self.checkWinning()
                        
                        //5. game over
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
                            .offset(x: isActivateBet20 ? 0 : 20)
                            .opacity(isActivateBet20 ? 1 :0)
                            .modifier(CasinoChipsModifier())
                    }
                    
                    Spacer()
                    //MARK: - bet 10
                    HStack(spacing: 10) {
                        Image("gfx-casino-chips")
                            .resizable()
                            .offset(x: isActivateBet10 ? 0 : -20)
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
                        self.resetGame()
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

