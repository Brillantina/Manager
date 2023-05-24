//
//  LoginView.swift
//  Manager
//
//  Created by Rita Marrano on 24/05/23.
//

import SwiftUI


struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isLoginSuccessful = false
    var body: some View {
        VStack(alignment: .center) {

            
            TextField("Email", text: $email)
                .frame(width: 500, height: 50)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                
            
            SecureField("Password", text: $password)
                .frame(width: 500, height: 50)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button(action: {
                            // Perform login action here
                            if email.isEmpty && password.isEmpty {
                                isLoginSuccessful = true
                            } else {
                                // Perform other login validations here
                            }
                        })  {
                Text("Login")
                    .foregroundColor(.gray)
                    .frame(width: 100, height: 20)
                    .padding()
                    .cornerRadius(10)
            }
            .padding()
            .fullScreenCover(isPresented: $isLoginSuccessful, content: {
                ContentView()
            })
        }
        .padding()
    }
    
    private func login() {
        // Perform login logic here
        // You can access the entered email and password using the `email` and `password` variables
        // Validate credentials, make API calls, etc.
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}


