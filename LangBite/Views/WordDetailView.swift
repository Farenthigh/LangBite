//
//  WordDetailView.swift
//  LangBite
//
//  Created by farenthigh on 14/11/2568 BE.
//

import SwiftUI

struct WordDetailView: View {
    let word: VocabWord
    @StateObject private var speaker = SpeechManager()
    @EnvironmentObject var fav: FavoritesViewModel
    @EnvironmentObject var auth: AuthViewModel
    
    var body: some View {
        let wordText = word.word ?? ""
        let meaningThai = word.meaningThai ?? ""
        ScrollView {
            VStack(spacing: 20) {
                
                // MARK: - Top Card
                VStack(alignment: .leading, spacing: 8) {
                    HStack(alignment: .center) {
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text(wordText)
                                    .font(.largeTitle)
                                    .bold()
                                
                                // Speaker button
                                Button {
                                    speaker.speak(wordText, language: "en-US")
                                } label: {
                                    Image(systemName: "speaker.wave.2.fill")
                                        .foregroundColor(.blue)
                                }
                            }
                            
                            Text(meaningThai)
                                .font(.title3)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        // Favorite button
                        Button {
                            Task {
                                guard let userId = auth.currentUser?.ID else { return }
                                
                                let item = FavoriteItem(
                                    id: nil,
                                    type: .word,
                                    value: wordText,
                                    category: nil,
                                    word: word
                                )
                                
                                await fav.toggleFavorite(userId: userId, item: item)
                            }
                        } label: {
                            Image(systemName: fav.isWordFavorite(wordText) ? "heart.fill" : "heart")
                                .foregroundColor(.red)
                                .font(.title2)
                        }
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(UIColor.secondarySystemBackground))
                        .shadow(radius: 4)
                )
                
                // MARK: - Example Sentences
                VStack(alignment: .leading, spacing: 12) {
                    Text("Example Sentences")
                        .font(.headline)
                    
                    ForEach(word.examples ?? [""], id: \.self) { example in
                        Text(example)
                            .font(.body)
                            .padding(.vertical, 4)
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(UIColor.secondarySystemBackground))
                        .shadow(radius: 3)
                )
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle(wordText)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            // Optional: Fetch latest favorites if needed
            if let userId = auth.currentUser?.ID {
                await fav.fetchFavorites(userId: userId)
            }
        }
    }
}

// MARK: - Preview
#Preview {
    WordDetailView(word: VocabWord(
        id: 1,
        word: "intense",
        meaningThai: "เข้มข้น รุนแรง",
        examples: [
            "The heat is intense today.",
            "The competition was intense."
        ]
    ))
    .environmentObject(FavoritesViewModel())
    .environmentObject(AuthViewModel()) // provide currentUser in your preview if needed
}


#Preview {
    WordDetailView(word: VocabWord(
        id: 1,
        word: "therefore",
        meaningThai: "ดังนั้น",
        examples: [
            "The data was incomplete; therefore, the conclusion is uncertain.",
            "The results were consistent, therefore supporting the hypothesis."
        ]
    ))
    .environmentObject(FavoritesViewModel())
}
