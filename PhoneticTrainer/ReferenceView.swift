//
//  ReferenceView.swift
//  PhoneticTrainer
//
//  Created by user on 7/28/22.
//

import SwiftUI

struct ReferenceView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @State var mode: String
    
    var body: some View {
        if colorScheme == .light {
            if mode == "NATO" {
                List(NATO.values, id: \.self) { word in
                    Text(word)
                        .font(.title)
                }
                .navigationTitle("NATO Alphabet")
            } else {
                List(LAPD.values, id: \.self) { word in
                    Text(word)
                        .font(.title)
                }
                .navigationTitle("LAPD Alphabet")
            }
            
        } else {
            if mode == "NATO" {
                List(NATO.values, id: \.self) { word in
                    Text(word)
                        .font(.title)
                        .foregroundColor(.secondary)
                }
                .navigationTitle("NATO Alphabet")
            } else {
                List(LAPD.values, id: \.self) { word in
                    Text(word)
                        .font(.title)
                        .foregroundColor(.secondary)
                }
                .navigationTitle("LAPD Alphabet")
            }
        }
    }
}
    
    
    
    
