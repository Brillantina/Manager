//
//  GameLevelsView.swift
//  Manager
//
//  Created by Rita Marrano on 26/05/23.
//

import SwiftUI

struct GameLevelsView: View {
    
    @Binding var inputString: String
    @State private var selectedLevels: [[Bool]] = [[]]
    
    init(inputString: Binding<String>) {
        _inputString = inputString
        _selectedLevels = State(initialValue: convertStringToBoolMatrix(inputString.wrappedValue))
    }
    
    var body: some View {
        VStack {
            ForEach(0..<selectedLevels.count, id: \.self) { gameIndex in
                Toggle(isOn: Binding(
                    get: {
                        guard gameIndex < selectedLevels.count else {
                            return false
                        }
                        
                        let areLevelsEnabled = selectedLevels[gameIndex].dropFirst().contains(true)
                        let isGameEnabled = selectedLevels[gameIndex][0] && areLevelsEnabled
                        
                        return isGameEnabled
                    },
                    set: { newValue in
                        guard gameIndex < selectedLevels.count else {
                            return
                        }
                        
                        selectedLevels[gameIndex][0] = newValue
                        
                        if !newValue {
                            for index in 1..<selectedLevels[gameIndex].count {
                                selectedLevels[gameIndex][index] = false
                            }
                        } else {
                            selectedLevels[gameIndex][1] = true
                        }
                    }
                )) {
                    Text("Game \(gameIndex + 1)")
                }
                .padding()
                
                if selectedLevels[gameIndex][0] && selectedLevels[gameIndex].dropFirst().contains(true) {
                    HStack {
                        ForEach(1..<selectedLevels[gameIndex].count, id: \.self) { levelIndex in
                            Button(action: {
                                selectedLevels[gameIndex][levelIndex].toggle()
                            }) {
                                Text("Level \(levelIndex)")
                                    .padding()
                                    .background(selectedLevels[gameIndex][levelIndex] ? Color.blue : Color.gray)
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .onChange(of: selectedLevels) { newValue in
            inputString = convertBoolMatrixToString(newValue)
        }
    }
    
    func convertStringToBoolMatrix(_ inputString: String) -> [[Bool]] {
        let chunkSize = 4
        let paddedString = inputString.padding(toLength: ((inputString.count + chunkSize - 1) / chunkSize) * chunkSize, withPad: "0", startingAt: 0)
        let chunkCount = paddedString.count / chunkSize
        
        var boolMatrix: [[Bool]] = []
        
        for chunkIndex in 0..<chunkCount {
            let startIndex = paddedString.index(paddedString.startIndex, offsetBy: chunkIndex * chunkSize)
            let endIndex = paddedString.index(startIndex, offsetBy: chunkSize)
            let chunk = paddedString[startIndex..<endIndex]
            
            let boolArray = chunk.map { $0 == "1" }
            boolMatrix.append(boolArray)
        }
        
        return boolMatrix
    }
    
    
    func convertBoolMatrixToString(_ boolMatrix: [[Bool]]) -> String {
        let stringArray = boolMatrix.flatMap { $0.map { $0 ? "1" : "0" } }
        return stringArray.joined()
    }
}


struct GameLevelsView_Previews: PreviewProvider {
    static var previews: some View {
        GameLevelsView(inputString: .constant("1100000000001011"))
    }
}
