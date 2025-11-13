//
//  FavoritesManager.swift
//  LangBite
//
//  Created by farenthigh on 14/11/2568 BE.
//

import Foundation
import Combine


final class FavoritesManager: ObservableObject {
    @Published var favorites: [String] = [] {
        didSet {
            UserDefaults.standard.set(favorites, forKey: "favorites")
        }
    }
    
    
    init() {
        favorites = UserDefaults.standard.stringArray(forKey: "favorites") ?? []
    }
    
    
    func toggleFavorite(item: String) {
        if favorites.contains(item) {
            favorites.removeAll { $0 == item }
        } else {
            favorites.append(item)
        }
    }
    
    
    func isFavorite(_ item: String) -> Bool {
        favorites.contains(item)
    }
}
