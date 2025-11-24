//
//  ExploreView.swift
//  LangBite
//
//  Created by farenthigh on 14/11/2568 BE.
//

import SwiftUI


struct ExploreView: View {
    @StateObject var vm = VocabularyViewModel()
    @EnvironmentObject var fav: FavoritesViewModel
    
    
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
    @EnvironmentObject var fav: FavoritesViewModel
    
    
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
                    fav.togglePlaylist(category.displayName)
                } label: {
                    Image(systemName: fav.isPlaylistFavorite(category.displayName) ? "heart.fill" : "heart")
                        .foregroundStyle(.red)
                        .padding(8)
                }
            }
            .frame(maxWidth: .infinity)
            
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
    @EnvironmentObject var vm: VocabularyViewModel
    let category: VocabCategory
    
    var body: some View {
        let words = vm.words(for: category)
        
        List(words) { w in
            NavigationLink(destination: WordDetailView(word: w)){
                HStack{
                    VStack(alignment: .leading){
                        Text(w.word).bold()
                        Text(w.meaningThai)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    
                }
                .padding(.vertical, 8)
            }
        }
        .navigationTitle(category.displayName)
    }
}



#Preview {
    ExploreView()
        .environmentObject(FavoritesViewModel())
}
