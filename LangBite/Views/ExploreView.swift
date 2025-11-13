//
//  ExploreView.swift
//  LangBite
//
//  Created by farenthigh on 14/11/2568 BE.
//

import SwiftUI


struct ExploreView: View {
    @EnvironmentObject var vm: LangViewModel
    @EnvironmentObject var fav: FavoritesManager
    
    
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 18) {
                    ForEach(vm.categories) { cat in
                        NavigationLink(value: cat) {
                            PlaylistCard(category: cat)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding()
            }
            .navigationTitle("Vocabulary Playlist")
            .navigationDestination(for: VocabCategory.self) { category in
                CategoryDetailView(category: category)
                    .environmentObject(vm)
                    .environmentObject(fav)
            }
        }
    }
}


struct PlaylistCard: View {
    let category: VocabCategory
    @EnvironmentObject var fav: FavoritesManager
    
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .topTrailing) {
                RoundedRectangle(cornerRadius: 14).fill(Color(UIColor.secondarySystemBackground)).frame(height: 120)
                Button(action: { fav.toggleFavorite(item: category.title) }) {
                    Image(systemName: fav.isFavorite(category.title) ? "heart.fill" : "heart").padding(8).foregroundColor(.red)
                }
                .padding(8)
            }
            Text(category.title).font(.headline).padding(.top, 8)
            Text("\(category.wordsCount) words").font(.caption).foregroundColor(.secondary)
        }
        .padding(10)
        .background(RoundedRectangle(cornerRadius: 16).fill(Color(UIColor.systemBackground)).shadow(radius: 2))
    }
}


struct CategoryDetailView: View {
    let category: VocabCategory
    @EnvironmentObject var vm: LangViewModel
    @EnvironmentObject var fav: FavoritesManager
    
    
    var body: some View {
        List {
            Section {
                ForEach(vm.selectedCategoryWords) { w in
                    NavigationLink(destination: WordDetailView(word: w)) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(w.word).bold()
                                Text(w.translation).font(.caption).foregroundColor(.secondary)
                            }
                            Spacer()
                            Image(systemName: "chevron.right").foregroundColor(.secondary)
                        }
                        .padding(.vertical, 8)
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle(category.title)
        .onAppear { vm.loadWords(for: category) }
    }
}

#Preview {
    ExploreView()
}
