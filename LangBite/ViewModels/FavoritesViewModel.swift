//
//  FavoritesManager.swift
//  LangBite
//
//  Created by farenthigh on 14/11/2568 BE.
//

import Foundation
import Combine

@MainActor
final class FavoritesViewModel: ObservableObject {
    
    @Published var favorites: [FavoriteItem] = []
    private var currentUserId: Int?
    private var auth: AuthViewModel?
    
    private let baseURL = "http://127.0.0.1:3000/api/v1"
    
    // MARK: - Bind AuthViewModel
    func bindAuth(auth: AuthViewModel) {
            self.auth = auth

            // Whenever currentUser changes, fetch or clear favorites
            Task {
                if let userId = auth.currentUser?.ID {
                    await fetchFavorites(userId: userId)
                } else {
                    clear()
                }
            }
        }
    
    // MARK: - Load favorites for specific user (like old loadForUser)
    func loadForUser(userId: Int) async {
        await fetchFavorites(userId: userId)
        print("Favorite : ",favorites)
    }
    
    // MARK: - Fetch favorites from server
    func fetchFavorites(userId: Int) async {
        self.currentUserId = userId
        guard let url = URL(string: "\(baseURL)/favorites/me?user_id=\(currentUserId ?? 0)") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let decoder = JSONDecoder()
            let response = try decoder.decode(FavoriteMeResponse.self, from: data)
            if let items = response.data {
                self.favorites = items.map { fav in
                    // Only store minimal info
                    FavoriteItem(
                        id: fav.ID,
                        type: fav.type == "word" ? .word : .playlist,
                        value: fav.value,
                        category: fav.category,
                        word: nil // do not include full word
                    )
                }
            } else {
                self.favorites = []
            }
        } catch {
            print("Failed to fetch favorites:", error)
            self.favorites = []
        }
    }

    
    // MARK: - Toggle favorite
    func toggleFavorite(userId: Int, item: FavoriteItem) async {
        guard let url = URL(string: "\(baseURL)/favorites/toggle") else { return }
        print("user id : ",userId)
        let word = item.word ?? VocabWord(id: 0, word: item.value, meaningThai: "", examples: [])
        let body = FavoriteToggleReq(
            user_id: userId,
            word_id: "\(word.id)",
            type: item.type,
            value: item.value,
            category: item.category,
            word: word
        )
        print("body : ",body)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONEncoder().encode(body)
            let (_, _) = try await URLSession.shared.data(for: request)
            await self.loadForUser(userId: userId)
        } catch {
            print("Failed to toggle favorite:", error)
        }
    }
    
    // MARK: - Clear all local favorites (use on logout)
    func clear() {
        favorites = []
        currentUserId = nil
    }
    
    // MARK: - Helpers
    func isWordFavorite(_ word: String) -> Bool {
        favorites.contains { $0.type == .word && $0.value == word }
    }
    
    func isPlaylistFavorite(_ playlist: String) -> Bool {
        favorites.contains { $0.type == .playlist && $0.value == playlist }
    }
}
