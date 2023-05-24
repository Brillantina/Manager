//
//  SearchBar.swift
//  Manager
//
//  Created by Rita Marrano on 24/05/23.
//

import Foundation
import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            TextField("Cerca", text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            Button(action: {
                // Azione da eseguire quando viene premuto il pulsante di ricerca
                print("Ricerca avviata")
            }) {
                Image(systemName: "magnifyingglass")
                    .padding(.trailing)
            }
        }
    }
}

