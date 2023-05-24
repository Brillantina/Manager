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
        NavigationView {
            VStack{
//                SearchBar(text: $searchText)
                List {
                    
                    SearchBar(text: $searchText)
                    
                    ForEach(items) { item in
                        NavigationLink {
                            
                            
                            
                            let patientEntity: PatientEntity = item
                            
                            var patient = Patient(
                                id: patientEntity.id ?? "",
                                patientName: patientEntity.patientName ?? "",
                                patientSurname: patientEntity.patientSurname ?? "",
                                gameStatus: Binding<String>(
                                    get: {
                                        patientEntity.gameStatus ?? ""
                                    },
                                    set: { newValue in
                                        patientEntity.gameStatus = newValue
                                    }
                                ))
                            
                            PatientDetailView(patientEntity: patientEntity)
//                            Text("Patient \(item.patientSurname!)")
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

//    private func addItem() {
//        withAnimation {
//            let newItem = PatientEntity(context: viewContext)
//            newItem.timestamp = Date()
//
//            do {
//                try viewContext.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nsError = error as NSError
//                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//            }
//        }
//    }
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
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
