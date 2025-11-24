//
//  AuthView.swift
//  LangBite
//
//  Created by farenthigh on 24/11/2568 BE.
//

import SwiftUI

struct AuthView: View {
    @State private var showRegister = false // toggle between Login and Register
        
        var body: some View {
            VStack {
                if showRegister {
                    RegisterView(showRegister: $showRegister)
                } else {
                    LoginView()
                }
                
                // Switch button
                Button(action: {
                    withAnimation {
                        showRegister.toggle()
                    }
                }) {
                    Text(showRegister ? "กลับไปเข้าสู่ระบบ" : "ยังไม่มีบัญชี? สมัครสมาชิก")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                        .padding(.top, 20)
                }
            }
            .padding()
        }
}

#Preview {
    AuthView()
}
