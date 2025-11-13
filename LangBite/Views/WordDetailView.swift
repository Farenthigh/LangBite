//
//  WordDetailView.swift
//  LangBite
//
//  Created by farenthigh on 14/11/2568 BE.
//

import SwiftUI


struct WordDetailView: View {
    let word: VocabWord
    @StateObject private var player = AudioPlayer()
    @EnvironmentObject var fav: FavoritesManager
    
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                HStack {
                    VStack(alignment: .leading) {
                        Text(word.word).font(.title2).bold()
                        Text(word.translation).font(.subheadline).foregroundColor(.secondary)
                    }
                    Spacer()
                    Button(action: { fav.toggleFavorite(item: word.word) }) {
                        Image(systemName: fav.isFavorite(word.word) ? "heart.fill" : "heart").foregroundColor(.red)
                    }
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 12).fill(Color(UIColor.secondarySystemBackground)).shadow(radius: 4))
                
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Example Sentences").font(.headline)
                    ForEach(word.examples, id: \.self) { ex in
                        Text(ex)
                            .padding(8)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color(UIColor.systemBackground)).shadow(radius: 2))
                    }
                }
                
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle(word.word)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    if let url = Bundle.main.url(forResource: "sample", withExtension: "mp3") {
                        player.playLocal(url: url)
                    }
                }) { Image(systemName: "speaker.wave.2.fill") }
            }
        }
    }
}

//#Preview {
//    WordDetailView()
//}
