//
//  ExploreView.swift
//  LangBite
//
//  Created by farenthigh on 14/11/2568 BE.
//

import SwiftUI

// MARK: - ExploreView

struct ExploreView: View {
    @StateObject var vm = VocabularyViewModel()
    @EnvironmentObject var fav: FavoritesViewModel
    @EnvironmentObject var auth: AuthViewModel
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 18) {
                ForEach(VocabCategory.allCases) { cat in
                    NavigationLink(
                        destination: WordListView(category: cat)
                            .environmentObject(vm)
                            .environmentObject(fav)
                            .environmentObject(auth)
                    ) {
                        PlaylistCard(
                            category: cat,
                            wordsCount: vm.words(for: cat).count
                        )
                        .environmentObject(fav)
                        .environmentObject(auth)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding()
        }
        .navigationTitle("Vocabulary Playlist")
        .task {
            // Fetch favorites when Explore opens
            if let userId = auth.currentUser?.ID {
                await fav.fetchFavorites(userId: userId)
            }
        }
    }
}

// MARK: - PlaylistCard

struct PlaylistCard: View {
    let category: VocabCategory
    let wordsCount: Int
    @EnvironmentObject var fav: FavoritesViewModel
    @EnvironmentObject var auth: AuthViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Image(category.rawValue)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 148, height: 148)
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
            
            HStack {
                Text(category.displayName)
                    .font(.headline)
                
                Spacer()
                
                Button {
                    Task {
                        guard let userId = auth.currentUser?.ID else { return }
                        let item = FavoriteItem(id: nil, type: .playlist, value: category.displayName, category: nil, word: nil)
                        await fav.toggleFavorite(userId: userId, item: item)
                    }
                } label: {
                    Image(systemName: fav.isPlaylistFavorite(category.displayName) ? "heart.fill" : "heart")
                        .foregroundColor(.red)
                        .padding(8)
                }
            }
            .frame(maxWidth: .infinity)
            
            Text("\(wordsCount) words")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(UIColor.systemBackground))
                .shadow(radius: 2)
        )
    }
}

// MARK: - WordListView

struct WordListView: View {
    @EnvironmentObject var vm: VocabularyViewModel
    @EnvironmentObject var fav: FavoritesViewModel
    @EnvironmentObject var auth: AuthViewModel
    let category: VocabCategory
    
    var body: some View {
        let words = vm.words(for: category)
        
        List(words) { w in
            HStack {
                VStack(alignment: .leading) {
                    Text(w.word ?? "label").bold()
                    Text(w.meaningThai ?? "label")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Button {
                    Task {
                        guard let userId = auth.currentUser?.ID else { return }
                        let item = FavoriteItem(id: nil, type: .word, value: w.word ?? "label", category: nil, word: w)
                        await fav.toggleFavorite(userId: userId, item: item)
                    }
                } label: {
                    Image(systemName: fav.isWordFavorite(w.word ?? "label") ? "heart.fill" : "heart")
                        .foregroundColor(.red)
                        .font(.title3)
                }
            }
            .padding(.vertical, 4)
            .contentShape(Rectangle()) // ensures full row clickable
            .background(
                NavigationLink(destination: WordDetailView(word: w).environmentObject(fav).environmentObject(auth)) {
                    EmptyView()
                }
                .opacity(0)
            )
        }
        .navigationTitle(category.displayName)
    }
}



// MARK: - Preview

#Preview {
    NavigationStack {
        ExploreView()
            .environmentObject(FavoritesViewModel())
            .environmentObject(AuthViewModel())
    }
}
