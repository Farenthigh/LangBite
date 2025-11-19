//
//  ContentView.swift
//  LangBite
//
//  Created by farenthigh on 13/11/2568 BE.
//

import SwiftUI


struct ContentView: View {
    @StateObject private var fav = FavoritesManager()
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
        .accentColor(.blue)
        .environmentObject(fav)
    }
}

#Preview {
    ContentView()
}
