//
//  LearnView.swift
//  LangBite
//
//  Created by farenthigh on 14/11/2568 BE.
//

//
//  LearnView.swift
//

import SwiftUI

struct LearnView: View {
    @StateObject var vm = DailyWordViewModel()
    @EnvironmentObject var fav: FavoritesViewModel
    @EnvironmentObject var auth: AuthViewModel
    @StateObject private var speaker = SpeechManager()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                if let word = vm.today {
                    DailyWordCard(word: word)
                        .environmentObject(speaker)
                        .environmentObject(fav)
                        .environmentObject(auth)
                        .padding()
                        .frame(maxWidth: .infinity)
                    
                    ExampleCard(word: word)
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity)
                } else {
                    Text("No daily word available")
                        .foregroundColor(.secondary)
                        .padding()
                }
                
                Spacer()
            }
            .navigationTitle("Learn")
        }
    }
}

struct DailyWordCard: View {
    let word: VocabWord
    @EnvironmentObject private var fav: FavoritesViewModel
    @EnvironmentObject private var auth: AuthViewModel
    @EnvironmentObject private var speaker: SpeechManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text(word.word ?? "label").font(.title).bold()
                        Button { speaker.speak(word.word ?? "label", language: "en-US") } label: {
                            Image(systemName: "speaker.wave.2.fill").foregroundColor(.blue)
                        }
                    }
                    Text(word.meaningThai ?? "label").foregroundColor(.secondary)
                }
                Spacer()
                Button {
                    Task {
                        guard let userId = auth.currentUser?.ID else { return }
                        let item = FavoriteItem(id: nil, type: .word, value: word.word ?? "label", category: nil, word: word)
                        await fav.toggleFavorite(userId: userId, item: item)
                    }
                } label: {
                    Image(systemName: fav.isWordFavorite(word.word ?? "label") ? "heart.fill" : "heart")
                        .foregroundColor(.red)
                        .font(.title2)
                }
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 16)
                        .fill(Color(UIColor.secondarySystemBackground))
                        .shadow(radius: 4))
    }
}

struct ExampleCard: View {
    let word: VocabWord
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Example Sentences").font(.headline)
            LazyVStack(alignment: .leading, spacing: 12) {
                ForEach(word.examples ?? ["label"], id: \.self) { ex in
                    Text(ex).font(.system(size: 16)).foregroundColor(.primary).fixedSize(horizontal: false, vertical: true)
                }
            }
        }
        .padding(18)
        .background(RoundedRectangle(cornerRadius: 16).fill(Color(.secondarySystemBackground)).shadow(radius: 4))
        .padding(.horizontal)
    }
}

#Preview {
    LearnView()
        .environmentObject(FavoritesViewModel())
        .environmentObject(AuthViewModel()) // provide currentUser if needed
}
