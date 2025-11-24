//
//  LangBiteApp.swift
//  LangBite
//
//  Created by farenthigh on 13/11/2568 BE.
//

import SwiftUI

@main
struct LangBiteApp: App {
    @StateObject private var authVM = AuthViewModel()
    @StateObject private var favVM = FavoritesViewModel()
    @StateObject private var vocabVM = VocabularyViewModel()
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(authVM)
                .environmentObject(favVM)
                .environmentObject(vocabVM)
        }
    }
}
