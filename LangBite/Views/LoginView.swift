//
//  Login.swift
//  LangBite
//
//  Created by farenthigh on 24/11/2568 BE.
//

import SwiftUI

// กำหนดสีหลักที่ต้องการใช้
let primaryColor = Color.blue

struct LoginView: View {
    // 1. @State ใช้สำหรับเก็บข้อมูลที่เปลี่ยนแปลงได้ใน View
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var errorMessage: String = ""
    @EnvironmentObject var auth: AuthViewModel

    var body: some View {
        // ใช้ NavigationView เพื่อให้สามารถเพิ่ม Navigation Bar ได้
        NavigationView {
            // ใช้ VStack เพื่อจัดเรียงองค์ประกอบในแนวตั้ง
            VStack(spacing: 20) {
                // ส่วนหัว
                Text("ยินดีต้อนรับ")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 20)
                
                // 2. ช่องสำหรับกรอก Email/Username
                VStack(alignment: .leading, spacing: 5) {
                    Text("อีเมล/ชื่อผู้ใช้")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    TextField("ป้อนอีเมลของคุณ", text: $email)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .keyboardType(.emailAddress) // แป้นพิมพ์สำหรับอีเมล
                        .autocapitalization(.none) // ปิดการขึ้นต้นด้วยตัวพิมพ์ใหญ่
                }
                
                // 3. ช่องสำหรับกรอก Password (ใช้ SecureField เพื่อซ่อนรหัสผ่าน)
                VStack(alignment: .leading, spacing: 5) {
                    Text("รหัสผ่าน")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    SecureField("ป้อนรหัสผ่านของคุณ", text: $password)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                }

                // 4. ปุ่ม Login
                Button(action: {
                    Task {
                        do {
                            try await auth.Login(email: email, password: password)
                        } catch {
                            print("Login failed:", error)
                            auth.errorMessage = error.localizedDescription
                        }
                    }
                }) {
                    Text("เข้าสู่ระบบ")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue) // use a defined color for preview
                        .cornerRadius(10)
                }
                .padding(.top, 10)
                
                .font(.subheadline)
                .foregroundColor(primaryColor)
                
                Spacer() // ดันเนื้อหาขึ้นไปด้านบน

            }
            .padding(.horizontal, 30) // ขอบด้านข้าง
            .padding(.top, 50) // ดันเนื้อหาลงมาจากขอบบนเล็กน้อย
//            .alert(errorMessage) {
            // ตั้งชื่อ Navigation Bar
            .navigationTitle("เข้าสู่ระบบ")
            .navigationBarHidden(true) // ซ่อน Navigation Bar (ถ้าต้องการให้ดูสะอาดขึ้น)
        }
    }
}

// Preview สำหรับดูผลลัพธ์ใน Xcode Canvas
#Preview {
    LoginView()
        .environmentObject(AuthViewModel())
}
