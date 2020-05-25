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
                        Text("100")
                            .scoreNumberLabelStyle()
                            .modifier(ScoreNumberModifier())
                        
                    }.modifier(ScoreContainerModifier())
                    
                    Spacer()
                    
                    HStack(){
                        
                        Text("200")
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
                        Image("gfx-bell")
                            .resizable()
                            .modifier(ImageModifier())
                    }
                    Spacer()
                    //MARK: - reel #2
                    HStack{
                        ZStack(){
                            ReelView()
                            Image("gfx-seven")
                                .resizable()
                                .modifier(ImageModifier())
                        }
                        //MARK: - reel #3
                        ZStack(){
                            ReelView()
                            
                            Image("gfx-cherry")
                                .resizable()
                                .modifier(ImageModifier())
                        }
                    }.frame(maxWidth: 500)
                    //MARK: - spin button
                    
                    Button(action: {
                        print("spinner")
                    }){
                        Image("gfx-spin")
                            .renderingMode(.original)
                            .resizable()
                            .modifier(ImageModifier())
                    }
                }.layoutPriority(2)
                
                //MARK: - footer
                Spacer()
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
                        print("info view")
                    }){
                        Image(systemName: "info.circle")
                    }.modifier(ButtonModifier()),
                    alignment: .topTrailing
                    
                    
                    
            )
                
                .padding()
                .frame(maxWidth: 720)
            //MARK: - popup
        }
        
        
        
    }
}


//MARK: - preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

