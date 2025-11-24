//
//  MainTabView.swift
//  LangBite
//
//  Created by farenthigh on 24/11/2568 BE.
//

import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    var body: some View {
        if authViewModel.isLoggedIn {
            // 1. ถ้าล็อคอินแล้ว: แสดงหน้าหลักของแอปฯ (Main App Dashboard)
            ContentView()
        } else {
            // 2. ถ้ายังไม่ได้ล็อคอิน: แสดงหน้าจอการเข้าสู่ระบบ
            AuthView()
        }
    }
}

#Preview {
    MainTabView()
        .environmentObject(AuthViewModel())
}
