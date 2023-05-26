//
//  AddPatientView.swift
//  Manager
//
//  Created by Rita Marrano on 24/05/23.
//

import SwiftUI

struct AddPatientView: View {
        @Environment(\.presentationMode) var presentationMode
        @Environment(\.managedObjectContext) private var viewContext
        
        @State private var name: String = ""
        @State private var surname: String = ""
        @State private var dateOfBirth = Date()
        @State private var numberOfGames = 4
        @State private var gameStatus = ""
        let patientID = UUID().uuidString

        
    
    
    @State private var selectedLevels: [[Bool]] = [[false, false, false, false],
                                                   [false, false, false, false],
                                                   [false, false, false, false],
                                                   [false, false, false, false]]
    
        init() {
            gameStatus = String(repeating: "0", count: numberOfGames)
        }
        
        var body: some View {
            VStack {
                HStack(spacing: 250) {
                    Button(action: {
                        // Delete patient action
                        return
                    }) {
                        Text("Delete")
                            .foregroundColor(.gray)
                    }
                    
                    Text("New patient")
                    
                    Button(action: {
                        // Save patient action
                        savePatient()
                    }) {
                        Text("Save")
                            .foregroundColor(.gray)
                    }
                }
                
                Spacer()
                
                VStack {
                    TextField("Name", text: $name)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .padding(.horizontal)
                    
                    TextField("Surname", text: $surname)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .padding(.horizontal)
                    
                    

                    Text(patientID)
                        .foregroundColor(.black)
                        .frame(width: 670, height: 50)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                    
                    


                }
                
                ScrollView {
                    VStack {
                         ForEach(0..<numberOfGames, id: \.self) { gameIndex in
                             Toggle(isOn: Binding(
                                 get: {
                                     guard gameIndex < selectedLevels.count else {
                                         return false
                                     }
                                     
                                     let isGameEnabled = selectedLevels[gameIndex][0]
                                     let isLevelEnabled = selectedLevels[gameIndex][1]
                                     
                                     return isGameEnabled && isLevelEnabled
                                 },
                                 set: { newValue in
                                     guard gameIndex < selectedLevels.count else {
                                         return
                                     }
                                     
                                     selectedLevels[gameIndex][0] = newValue
                                     selectedLevels[gameIndex][1] = newValue
                                     
                                     // Set other levels to false if the game is disabled
                                     if !newValue {
                                         for index in 2..<selectedLevels[gameIndex].count {
                                             selectedLevels[gameIndex][index] = false
                                         }
                                     }
                                 }
                             )) {
                                 Text("Game \(gameIndex + 1)")
                             }
                             .padding()

                             if selectedLevels[gameIndex][0] {
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
                }
            }
            .onAppear {
                gameStatus = String(repeating: "0", count: numberOfGames)
            }
        }
        

    func savePatient() {
        
        var levelString = ""
        for gameIndex in 0..<numberOfGames {
            let levels = selectedLevels[gameIndex]
            let levelStringForGame = levels.map { $0 ? "1" : "0" }.joined()
            levelString += levelStringForGame
        }
        levelString = levelString.trimmingCharacters(in: .whitespaces)
        
        gameStatus = levelString
        
        
        
//        let patientID = UUID().uuidString
        let patient = Patient(
            id: patientID,
            patientName: name,
            patientSurname: surname,
            gameStatus: $gameStatus
        )
        
        let newPatientEntity = PatientEntity(context: viewContext)
        newPatientEntity.id = patientID
        newPatientEntity.patientName = patient.patientName
        newPatientEntity.patientSurname = patient.patientSurname
        newPatientEntity.gameStatus = gameStatus
        
        do {
            try viewContext.save()
            print("Paziente salvato con successo")
            print("GAME STATUS\(newPatientEntity.gameStatus)")
            presentationMode.wrappedValue.dismiss()
        } catch let error as NSError {
            print("Errore durante il salvataggio del paziente: \(error)")
        }
    }
}

struct AddPatientView_Previews: PreviewProvider {
    static var previews: some View {
        AddPatientView()
    }
}
