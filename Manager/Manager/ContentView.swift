//
//  ContentView.swift
//  Manager
//
//  Created by Rita Marrano on 24/05/23.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var searchText = ""
    @State private var isShowingAddPatientSheet = false
    
    
    
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \PatientEntity.patientName, ascending: true)],
        animation: .default)
    
    
    private var items: FetchedResults<PatientEntity>

    var body: some View {
        
        NavigationView{
            
            VStack{
  
                List {
                    
                    SearchBar(text: $searchText)
                    
                    ForEach(items) { item in
                        NavigationLink {
                            
                            PatientDetailView(patientEntity: item)

                        } label: {
                            
                            Text(item.patientSurname ?? "")
                        }
                    }
                    .onDelete(perform: deleteItems)
                }
            }
            .toolbar {
                
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                
                ToolbarItem {
                    Button(action: {
                        isShowingAddPatientSheet = true
                    }) {
                        Label("Add Patient", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $isShowingAddPatientSheet) {
                // Contenuto dello Sheet per aggiungere un paziente
                AddPatientView()
                
            }
            Text("Select a patient")
        }
    }


    func savePatient(_ patient: Patient) {
        let context = viewContext
        // Ottieni il tuo contesto di Core Data
        
        let entity = NSEntityDescription.entity(forEntityName: "PatientEntity", in: context)!
        let patientEntity = NSManagedObject(entity: entity, insertInto: context)
        
        patientEntity.setValue(patient.id, forKey: "id")
        patientEntity.setValue(patient.patientName, forKey: "patientName")
        patientEntity.setValue(patient.patientSurname, forKey: "patientSurname")
        patientEntity.setValue(patient.gameStatus, forKey: "gameStatus")
        
        do {
            try context.save()
            print("Paziente salvato con successo")
        } catch let error as NSError {
            print("Errore durante il salvataggio del paziente: \(error)")
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
   
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
