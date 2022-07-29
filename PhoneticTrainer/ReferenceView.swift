//
//  ReferenceView.swift
//  PhoneticTrainer
//
//  Created by user on 7/28/22.
//

import SwiftUI

struct ReferenceView: View {
    @State var mode: String
    
    var body: some View {
        if mode == "NATO" {
            List(NATO.values, id: \.self) { word in
                Text(word)
                    .font(.title)
            }
        } else {
            List(LAPD.values, id: \.self) { word in
                Text(word)
                    .font(.title)
            }
        }
    }
}


