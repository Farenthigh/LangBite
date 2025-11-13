//
//  LearnView.swift
//  LangBite
//
//  Created by farenthigh on 14/11/2568 BE.
//

import SwiftUI


struct LearnView: View {
    @EnvironmentObject var vm: LangViewModel
    @EnvironmentObject var fav: FavoritesManager
    @StateObject private var player = AudioPlayer()
    
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                if let word = vm.dailyWord {
                    DailyWordCard(word: word)
                        .padding()
                } else {
                    Text("No daily word available")
                }
                
                
                if let word = vm.dailyWord {
                    ExampleCard(word: word)
                        .padding(.horizontal)
                }
                
                
                Spacer()
            }
            .navigationTitle("Learn")
        }
    }
}


struct DailyWordCard: View {
    let word: VocabWord
    @EnvironmentObject private var fav: FavoritesManager
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                VStack(alignment: .leading) {
                    Text(word.word).font(.title).bold()
                    HStack {
                        Image(systemName: "speaker.wave.2.fill").foregroundColor(.blue)
                        Text(word.translation).foregroundColor(.secondary)
                    }
                }
                Spacer()
                Button(action: { fav.toggleFavorite(item: word.word) }) {
                    Image(systemName: fav.isFavorite(word.word) ? "heart.fill" : "heart").foregroundColor(.red)
                }
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 16).fill(Color(UIColor.secondarySystemBackground)).shadow(radius: 4))
    }
}


struct ExampleCard: View {
    let word: VocabWord
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Example Sentences").font(.headline)
            ForEach(word.examples, id: \.self) { ex in
                VStack(alignment: .leading, spacing: 6) {
                    Text(ex).font(.body)
                }
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).fill(Color(UIColor.systemBackground)).shadow(radius: 3))
    }
}

#Preview {
    LearnView()
}

