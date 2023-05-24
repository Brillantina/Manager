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
    @State private var numberOfGames = 10
    @State private var gameStatus = ""
    
    init() {
        gameStatus = String(repeating: "0", count: numberOfGames)
    }
    
    var body: some View {
        VStack {
            HStack(spacing: 250){
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
            
            VStack{
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
                
                DatePicker("Date of Birth", selection: $dateOfBirth, displayedComponents: .date)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .padding(.horizontal)
            }
            
            ScrollView {
                VStack {
                    ForEach(0..<numberOfGames, id: \.self) { gameIndex in
                        Toggle(isOn: Binding(
                            get: {
                                guard gameStatus.count > gameIndex else {
                                    return false
                                }
                                return gameStatus[gameStatus.index(gameStatus.startIndex, offsetBy: gameIndex)] == "1"
                            },
                            set: { newValue in
                                guard gameStatus.count > gameIndex else {
                                    return
                                }
                                gameStatus.replaceSubrange(gameStatus.index(gameStatus.startIndex, offsetBy: gameIndex)...gameStatus.index(gameStatus.startIndex, offsetBy: gameIndex), with: newValue ? "1" : "0")
                                print(gameStatus)
                                print("\(dateOfBirth)")
                            }
                        )) {
                            Text("Game \(gameIndex + 1)")
                        }
                        .padding()
                    }
                }
            }
        }
        .onAppear {
            gameStatus = String(repeating: "0", count: numberOfGames)
        }
    }
    
    func savePatient() {
        let patientID = UUID().uuidString
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
