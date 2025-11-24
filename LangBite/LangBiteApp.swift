//
//  LangBiteApp.swift
//  LangBite
//
//  Created by farenthigh on 13/11/2568 BE.
//

import SwiftUI
import FirebaseCore
import FirebaseStorage
import FirebaseAuth

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}


@main
struct LangBiteApp: App {
    @StateObject var auth = AuthViewModel()
    @StateObject var fav = FavoritesViewModel()
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        
        WindowGroup {
            if auth.isAuthenticated {
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
