//
//  ButtonView.swift
//  Orange Weather
//
//  Created by user on 6/14/22.
//

import SwiftUI

/* A struct to define how buttons will appear throughout the application. */
struct NavButton {
    var text: String
}

struct ButtonView: View {
    
    let text: String
    
    var body: some View {
        Text("\(text)")
            .font(.title)
            .foregroundStyle(.white)
    }
}

struct ButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ButtonView(text: "test")
    }
}
