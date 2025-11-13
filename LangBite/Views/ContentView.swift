//
//  ContentView.swift
//  LangBite
//
//  Created by farenthigh on 13/11/2568 BE.
//

import SwiftUI


struct ContentView: View {
    @StateObject private var vm = LangViewModel()
    @StateObject private var fav = FavoritesManager()
    
    
    var body: some View {
        TabView {
            LearnView()
                .tabItem { Image(systemName: "book.fill"); Text("Learn") }
                .environmentObject(vm)
                .environmentObject(fav)
            
            
            ExploreView()
                .tabItem { Image(systemName: "safari"); Text("Explore") }
                .environmentObject(vm)
                .environmentObject(fav)
            
            
            ProfileView()
                .tabItem { Image(systemName: "person.crop.circle"); Text("Profile") }
                .environmentObject(vm)
                .environmentObject(fav)
        }
        .accentColor(.blue)
    }
}

#Preview {
    ContentView()
}
