//
//  Extentions.swift
//  Slot Machine UI
//
//  Created by José Javier Cueto Mejía on 24/05/20.
//  Copyright © 2020 Pozolx. All rights reserved.
//

import SwiftUI

extension Text {
    func scoreLabelStyle() -> Text {
        self
            .foregroundColor(.white)
            .font(.system(size: 10, weight: .bold, design: .rounded))
    }
    
    func scoreNumberLabelStyle() -> Text {
        self
            .foregroundColor(.white)
            .font(.system(.title, design: .rounded))
            .fontWeight(.heavy)
        
    }
}


