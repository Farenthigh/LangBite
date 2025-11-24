//
//  FavoritesManager.swift
//  LangBite
//
//  Created by farenthigh on 14/11/2568 BE.
//

import Foundation
import Combine


final class FavoritesManager: ObservableObject {
    @Published var favorites: [FavoriteItem] = [] {
        didSet {
            save()
        }
    }
    
    init() {
        load()
    }
    
    
    func toggleWord(_ vocab: VocabWord){
        if let idx = favorites.firstIndex(where: { $0.type == .word && $0.value == vocab.word}) {
            favorites.remove(at: idx)
        } else {
            favorites.append(
                FavoriteItem(
                    type: .word,
                    value: vocab.word,
                    category: nil,
                    word: vocab
                )
            )
        }
    }
    
    func togglePlaylist(_ playlist: String){
        if let idx = favorites.firstIndex(where: { $0.type == .playlist && $0.value == playlist}) {
            favorites.remove(at: idx)
        } else {
            favorites.append(
                FavoriteItem(
                    type: .playlist,
                    value: playlist,
                    category: nil,
                    word: nil
                )
            )
        }
    }
    
    func isWordFavorite(_ word: String) -> Bool {
        favorites.contains{$0.type == .word && $0.value == word}
    }
    
    func isPlaylistFavorite(_ playlist: String) -> Bool {
        favorites.contains{$0.type == .playlist && $0.value == playlist}
    }
    
    func remove(_ item: FavoriteItem){
        favorites.removeAll{ $0.id == item.id}
    }
    
    private func save() {
        if let data = try? JSONEncoder().encode(favorites) {
            UserDefaults.standard.set(data, forKey: "favorites")
        }
    }
    
    private func load() {
        if let data = UserDefaults.standard.data(forKey: "favorites"),
           let decoded = try? JSONDecoder().decode( [FavoriteItem].self, from: data){
            favorites = decoded
        }
    }
}

