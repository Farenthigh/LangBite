//
//  LearnView.swift
//  LangBite
//
//  Created by farenthigh on 14/11/2568 BE.
//

import SwiftUI

struct LearnView: View {
    @StateObject var vm = DailyWordViewModel()
    @EnvironmentObject var fav: FavoritesManager
    @StateObject private var speaker = SpeechManager()
    
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                if let word = vm.today {
                    DailyWordCard(word: word)
                        .environmentObject(speaker)
                        .environmentObject(fav)
                        .padding()
                        .frame(maxWidth: .infinity)
                } else {
                    Text("No daily word available")
                }
                
                if let word = vm.today {
                    ExampleCard(word: word)
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity)
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
    @EnvironmentObject private var speaker: SpeechManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text(word.word).font(.title).bold()
                    HStack {
                        Button {
                            speaker.speak(word.word, language: "en-US")
                        } label: {
                            Image(systemName: "speaker.wave.2.fill")
                                .foregroundColor(.blue)
                        }
                        Text(word.meaningThai).foregroundColor(.secondary)
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
            
            Text("Example Sentences")
                .font(.headline)
            
            LazyVStack(alignment: .leading, spacing: 12) {
                ForEach(word.examples, id: \.self) { ex in
                    Text(ex)
                        .font(.system(size: 16))
                        .foregroundColor(.primary)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.secondarySystemBackground))
                .shadow(radius: 4)
                
        )
        .padding(.horizontal)
    }
}


#Preview {
    LearnView()
        .environmentObject(FavoritesManager())
}

