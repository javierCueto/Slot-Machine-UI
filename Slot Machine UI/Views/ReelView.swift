//
//  ReelView.swift
//  Slot Machine UI
//
//  Created by José Javier Cueto Mejía on 25/05/20.
//  Copyright © 2020 Pozolx. All rights reserved.
//

import SwiftUI

struct ReelView: View {
    var body: some View {
        Image("gfx-reel")
            .resizable()
            .modifier(ImageModifier())
    }
}

struct ReelView_Previews: PreviewProvider {
    static var previews: some View {
        ReelView()
            .previewLayout(.fixed(width: 220, height: 220))
    }
}
