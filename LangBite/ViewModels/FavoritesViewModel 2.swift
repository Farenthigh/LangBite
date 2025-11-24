////
////  FavoritesViewModel 2.swift
////  LangBite
////
////  Created by farenthigh on 24/11/2568 BE.
////
//
//
//import Foundation
//import Combine
//
//final class FavoritesViewModel: ObservableObject {
//    @Published var favorites: [FavoriteItem] = []
//
//    private let baseURL = "http://127.0.0.1/api/v1"
//    
//    init() {
//        load() // optional local cache
//    }
//    
//    // MARK: - Fetch user favorites
//    func fetchFavorites(userId: Int) async {
//        guard let url = URL(string: "\(baseURL)/favorites/me") else { return }
//        
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        
//        let body = ["user_id": userId]
//        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
//        
//        do {
//            let (data, _) = try await URLSession.shared.data(for: request)
//            let decoder = JSONDecoder()
//            decoder.keyDecodingStrategy = .convertFromSnakeCase
//            let response = try decoder.decode(FavoriteMeResponse.self, from: data)
//            
//            await MainActor.run {
//                if let data = response.data {
//                    // Map API response → FavoriteItem
//                    let items = data.map { fav in
//                        let word = fav.word.map { w in
//                            VocabWord(
//                                id: w.asd, 
//                                word: w.word, 
//                                meaningThai: w.meaningThai, 
//                                examples: w.examples
//                            )
//                        }
//                        return FavoriteItem(
//                            id: fav.ID,
//                            type: fav.type == "word" ? .word : .playlist,
//                            value: fav.value,
//                            category: fav.category,
//                            word: word
//                        )
//                    }
//                    self.favorites = items
//                    self.save()
//                }
//            }
//            
//        } catch {
//            print("Failed to fetch favorites:", error)
//        }
//    }
//    
//    // MARK: - Local cache
//    private func save() {
//        if let data = try? JSONEncoder().encode(favorites) {
//            UserDefaults.standard.set(data, forKey: "favorites")
//        }
//    }
//    
//    private func load() {
//        if let data = UserDefaults.standard.data(forKey: "favorites"),
//           let decoded = try? JSONDecoder().decode([FavoriteItem].self, from: data) {
//            favorites = decoded
//        }
//    }
//    
//    // MARK: - Toggle favorite (your existing method)
//    func toggleFavorite(userId: Int, item: FavoriteItem) async {
//        guard let url = URL(string: "\(baseURL)/favorites/toggle") else { return }
//        
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        
//        guard let word = item.word else { return }
//        let body = FavoriteToggleReq(
//            user_id: userId,
//            word_id: "\(word.id)",
//            type: item.type,
//            value: item.value,
//            category: item.category ?? "",
//            word: word
//        )
//        
//        do {
//            let encoder = JSONEncoder()
//            encoder.keyEncodingStrategy = .convertToSnakeCase
//            request.httpBody = try encoder.encode(body)
//            
//            let (data, _) = try await URLSession.shared.data(for: request)
//            let decoder = JSONDecoder()
//            decoder.keyDecodingStrategy = .convertFromSnakeCase
//            let response = try decoder.decode(FavoriteToggleRes.self, from: data)
//            
//            await MainActor.run {
//                if let idx = favorites.firstIndex(where: { $0.type == item.type && $0.value == item.value }) {
//                    favorites.remove(at: idx)
//                } else {
//                    favorites.append(item)
//                }
//                save()
//            }
//            
//        } catch {
//            print("Failed to toggle favorite:", error)
//        }
//    }
//    
//    // MARK: - Helpers
//    func isWordFavorite(_ word: String) -> Bool {
//        favorites.contains { $0.type == .word && $0.value == word }
//    }
//    
//    func isPlaylistFavorite(_ playlist: String) -> Bool {
//        favorites.contains { $0.type == .playlist && $0.value == playlist }
//    }
//}
