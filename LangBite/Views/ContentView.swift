//
//  ContentView.swift
//  LangBite
//
//  Created by farenthigh on 13/11/2568 BE.
//

import SwiftUI


struct ContentView: View {
    @EnvironmentObject var auth: AuthViewModel
    @StateObject private var fav = FavoritesViewModel()
    @StateObject private var vocabVM = VocabularyViewModel()
    var body: some View {
        TabView {
            LearnView()
                .tabItem {
                    Image(systemName: "book.fill")
                    Text("Learn")
                }
            
            NavigationStack {
                ExploreView()
            }
            .tabItem {
                Image(systemName: "safari")
                Text("Explore")
            }
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person.crop.circle")
                    Text("Profile")
                }
            
        }
        .onChange(of: auth.currentUser?.ID) {
            Task {
                print("User ID Change")
                if auth.currentUser != nil {
                    await fav.loadForUser(userId: auth.currentUser?.ID ?? 0)
                } else {
                    fav.clear()
                }
            }
        }
        .accentColor(.blue)
        .environmentObject(fav)
        .environmentObject(vocabVM)
    }
}

#Preview {
    ContentView().environmentObject(AuthViewModel())
}
