//
//  PatientDetailView.swift
//  Manager
//
//  Created by Rita Marrano on 24/05/23.
//

import SwiftUI

struct PatientDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(entity: PatientEntity.entity(), sortDescriptors: [], predicate: nil) var fetchedPatientEntities: FetchedResults<PatientEntity>
    @State private var dateOfBirth = Date()
    
    var patientEntity: PatientEntity?
    
    @ObservedObject private var editedPatient: Patient
    
    init(patientEntity: PatientEntity?) {
        self.patientEntity = patientEntity
        
        // Initialize the editedPatient observed object
        if let patientEntity = patientEntity {
            self._editedPatient = ObservedObject(wrappedValue: Patient(
                id: patientEntity.id ?? "",
                patientName: patientEntity.patientName ?? "",
                patientSurname: patientEntity.patientSurname ?? "",
                gameStatus: Binding(
                    get: { patientEntity.gameStatus ?? "" },
                    set: { patientEntity.gameStatus = $0 }
                )
            ))
        } else {
            self._editedPatient = ObservedObject(wrappedValue: Patient(
                id: "",
                patientName: "",
                patientSurname: "",
                gameStatus: Binding.constant("")
            ))
        }
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
                    reSavePatient()
                }) {
                    Text("Save")
                        .foregroundColor(.gray)
                }
            }
            
            Spacer()
            
            VStack {
                TextField("", text: $editedPatient.patientName)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .padding(.horizontal)
                
                TextField("", text: $editedPatient.patientSurname)
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
                    ForEach(0..<editedPatient.gameStatus.wrappedValue.count, id: \.self) { gameIndex in
                        Toggle(isOn: Binding(
                            get: {
                                guard editedPatient.gameStatus.wrappedValue.count > gameIndex else {
                                    return false
                                }
                                let index = editedPatient.gameStatus.wrappedValue.index(
                                    editedPatient.gameStatus.wrappedValue.startIndex,
                                    offsetBy: gameIndex
                                )
                                return editedPatient.gameStatus.wrappedValue[index] == "1"
                            },
                            set: { newValue in
                                guard editedPatient.gameStatus.wrappedValue.count > gameIndex else {
                                    return
                                }
                                var updatedGameStatus = editedPatient.gameStatus.wrappedValue
                                let index = updatedGameStatus.index(
                                    updatedGameStatus.startIndex,
                                    offsetBy: gameIndex
                                )
                                updatedGameStatus.replaceSubrange(index...index, with: newValue ? "1" : "0")
                                editedPatient.gameStatus.wrappedValue = updatedGameStatus
                                print(editedPatient.gameStatus.wrappedValue)
                            }
                        )) {
                            Text("Game \(gameIndex + 1)")
                        }
                        .padding()
                        .foregroundColor(.primary)
                        .toggleStyle(SwitchToggleStyle(tint: .green))
                    }
                }
            }
        }
    }
    
    func reSavePatient() {
        guard let patientEntity = patientEntity else {
            // Create a new patient entity
            let newPatientEntity = PatientEntity(context: viewContext)
            updatePatientEntity(with: newPatientEntity)
            return
        }
        
        // Update the existing patient entity
        updatePatientEntity(with: patientEntity)
    }
    
    private func updatePatientEntity(with entity: PatientEntity) {
        entity.id = editedPatient.id
        entity.patientName = editedPatient.patientName
        entity.patientSurname = editedPatient.patientSurname
        entity.gameStatus = editedPatient.gameStatus.wrappedValue
        
        
        do {
            try viewContext.save()
            print("Paziente salvato con successo")
            presentationMode.wrappedValue.dismiss()
        } catch let error as NSError {
            print("Errore durante il salvataggio del paziente: \(error)")
        }
    }
}


//struct PatientDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        PatientDetailView(patient: Patient(id: "1", patientName: "Giuseppe", patientSurname: "Iodice", gameStatus: Binding.constant("0101")))
//    }
//}
