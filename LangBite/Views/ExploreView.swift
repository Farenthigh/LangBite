//
//  ExploreView.swift
//  LangBite
//
//  Created by farenthigh on 14/11/2568 BE.
//

import SwiftUI


struct ExploreView: View {
    @StateObject var vm = VocabularyViewModel()
    @EnvironmentObject var fav: FavoritesManager
    
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 18) {
                ForEach(VocabCategory.allCases) { cat in
                    NavigationLink(
                        destination: WordListView(
                            words: vm.words(for: cat),
                            title: cat.displayName
                        )
                        .environmentObject(fav)
                    ) {
                        PlaylistCard(
                            category: cat,
                            wordsCount: vm.words(for: cat).count
                        )
                        .environmentObject(fav)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding()
        }
        .navigationTitle("Vocabulary Playlist")
    }
}


struct PlaylistCard: View {
    let category: VocabCategory
    let wordsCount: Int
    @EnvironmentObject var fav: FavoritesManager
    
    
    var body: some View {
        VStack(alignment: .leading) {
            
            ZStack(alignment: .topTrailing) {
                
                Image(category.rawValue)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 148, height: 131)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .clipped()
                
                Button {
                    fav.toggleFavorite(item: category.displayName)
                } label: {
                    Image(systemName: fav.isFavorite(category.displayName) ? "heart.fill" : "heart")
                        .padding(8)
                        .foregroundStyle(.red)
                }
                .padding(8)
            }
            Text(category.displayName)
                .font(.headline)
                .padding(.top, 8)
            Text("\(wordsCount) words")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(UIColor.systemBackground))
                .shadow(radius: 2)
        )
    }
}


struct WordListView: View {
    let words: [VocabWord]
    let title: String
    var body: some View {
        List(words) {
            w in NavigationLink(destination: WordDetailView(word: w)){
                HStack{
                    Text(w.word).bold()
                    Text(w.meaningThai)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 8)
            }
        }
        .navigationTitle(title)
    }
}



#Preview {
    ExploreView()
        .environmentObject(FavoritesManager())
}
