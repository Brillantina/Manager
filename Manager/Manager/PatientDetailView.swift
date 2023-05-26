//
//  PatientDetailView.swift
//  Manager
//
//  Created by Rita Marrano on 24/05/23.
//

import SwiftUI

import SwiftUI

struct PatientDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(entity: PatientEntity.entity(), sortDescriptors: [], predicate: nil) var fetchedPatientEntities: FetchedResults<PatientEntity>
    @State private var dateOfBirth = Date()
    
    var patientEntity: PatientEntity?
    let numberOfGames = 4
    var numberOfLevels = 3
    
    @ObservedObject private var editedPatient: Patient
    @State private var selectedLevels: [[Bool]] = []
    
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
            HStack(spacing: 50) {
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
                
                TextField("", text: $editedPatient.id)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .padding(.horizontal)
                
                
                
            }
            
            GameLevelsView(inputString: editedPatient.gameStatus)
            
            Spacer()
            
            
            
            
            
            
            
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
            print("GAMESTATUS: \(entity.gameStatus)")
            print("Paziente salvato con successo")
            presentationMode.wrappedValue.dismiss()
        } catch let error as NSError {
            print("Errore durante il salvataggio del paziente: \(error)")
        }
    }
    
    
}











struct PatientDetailView_Previews: PreviewProvider {
    static var previews: some View {
        // Create a constant instance of PatientEntity
        let patientEntity = PatientEntity(context: PersistenceController.preview.container.viewContext)
        patientEntity.id = "123"
        patientEntity.patientName = "Rita"
        patientEntity.patientSurname = "Marrano"
        patientEntity.gameStatus = "1010010110110000"
        
        return PatientDetailView(patientEntity: patientEntity)
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
