//
//  RegisterView.swift
//  LangBite
//
//  Created by farenthigh on 24/11/2568 BE.
//

import SwiftUI

struct RegisterView: View {
    @State private var username: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var errorMessage: String = ""
    
    @EnvironmentObject var auth: AuthViewModel
    @Binding var showRegister: Bool
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                
                // Header
                Text("สมัครสมาชิก")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 20)
                
                // Username
                VStack(alignment: .leading, spacing: 5) {
                    Text("ชื่อผู้ใช้")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    TextField("ป้อนชื่อผู้ใช้", text: $username)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .autocapitalization(.none)
                }
                
                // Email
                VStack(alignment: .leading, spacing: 5) {
                    Text("อีเมล")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    TextField("ป้อนอีเมล", text: $email)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                }
                
                // Password
                VStack(alignment: .leading, spacing: 5) {
                    Text("รหัสผ่าน")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    SecureField("ป้อนรหัสผ่าน", text: $password)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                }
                
                // Error message
                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.footnote)
                        .padding(.top, 5)
                }
                
                // Register Button
                Button(action: {
                    Task {
                        do {
                            try await auth.Register(username: username, email: email, password: password)
                            
                        } catch {
                            errorMessage = error.localizedDescription
                        }
                    }
                }) {
                    Text("สมัครสมาชิก")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.top, 10)
                
                Spacer()
            }
            .padding(.horizontal, 30)
            .padding(.top, 50)
            .navigationTitle("สมัครสมาชิก")
            .navigationBarHidden(true)
        }
    }
}


//#Preview {
//    RegisterView(showRegister: .constant(false))
//        .environmentObject(AuthViewModel.preview)
//}
