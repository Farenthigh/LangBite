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
    @EnvironmentObject var fav: FavoritesManager
    
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                
                // TOP CARD
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            HStack{
                                Text(word.word)
                                    .font(.largeTitle)
                                    .bold()
                                Button {
                                    speaker.speak(word.word, language: "en-US")
                                } label: {
                                    Image(systemName: "speaker.wave.2.fill")
                                        .foregroundColor(.blue)
                                }
                            }
                                
                            Text(word.meaningThai)
                                .font(.title3)
                                .foregroundColor(.secondary)
                            
                        }
                        
                        Spacer()
                        
                        Button {
                            fav.toggleWord(word)
                        } label: {
                            Image(systemName: fav.isWordFavorite(word.word) ? "heart.fill" : "heart")
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
                
                
                // EXAMPLE SENTENCES
                VStack(alignment: .leading, spacing: 12) {
                    Text("Example Sentences")
                        .font(.headline)
                    
                    ForEach(word.examples, id: \.self) { example in
                        VStack(alignment: .leading, spacing: 6){
                            Text(example).font(.body)
                        }
                    }
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 12)
                    .fill(Color(UIColor.systemBackground))
                    .shadow(radius: 3))
                
                Spacer()
            }
            .padding()
            
        }
    }
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
    .environmentObject(FavoritesManager())
}
