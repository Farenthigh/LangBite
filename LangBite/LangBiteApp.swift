//
//  LangBiteApp.swift
//  LangBite
//
//  Created by farenthigh on 13/11/2568 BE.
//

import SwiftUI

@main
struct LangBiteApp: App {
    @StateObject var auth = AuthViewModel()
    @StateObject var fav = FavoritesViewModel()
    
    var body: some Scene {
        WindowGroup {
            if auth.isLoggedIn {
                ContentView()
                    .environmentObject(auth)
                    .environmentObject(fav)
                    .task {
                        if let userId = auth.currentUser?.ID {
                            await fav.fetchFavorites(userId: userId)
                        }
                    }
            } else {
                AuthView()
                    .environmentObject(auth)
            }
        }
    }
}
