//
//  Patient.swift
//  Manager
//
//  Created by Rita Marrano on 24/05/23.
//


import Foundation
import SwiftUI
import Combine

class Patient: ObservableObject {
    @Published var id: String
    @Published var patientName: String
    @Published var patientSurname: String
    @Published var gameStatus: Binding<String>
    
    init(id: String, patientName: String, patientSurname: String, gameStatus: Binding<String>) {
        self.id = id
        self.patientName = patientName
        self.patientSurname = patientSurname
        self.gameStatus = gameStatus
    }
}
