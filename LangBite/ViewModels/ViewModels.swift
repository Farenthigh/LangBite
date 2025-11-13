//
//  ViewModels.swift
//  LangBite
//
//  Created by farenthigh on 14/11/2568 BE.
//

import Foundation
import SwiftUI


final class LangViewModel: ObservableObject {
    @Published var categories: [VocabCategory] = []
    @Published var selectedCategoryWords: [VocabWord] = []
    @Published var dailyWord: VocabWord?
    
    
    init() {
        loadMockData()
    }
    
    
    func loadMockData() {
        categories = [
            VocabCategory(title: "Daily Life", subtitle: "ชีวิตประจำวัน", wordsCount: 250, coverColor: .white),
            VocabCategory(title: "Slang", subtitle: "สแลง", wordsCount: 250, coverColor: .white),
            VocabCategory(title: "Emotions", subtitle: "อารมณ์", wordsCount: 250, coverColor: .white),
            VocabCategory(title: "Food", subtitle: "อาหาร", wordsCount: 250, coverColor: .white),
            VocabCategory(title: "Exam Prep", subtitle: "เตรียมสอบ", wordsCount: 250, coverColor: .white),
            VocabCategory(title: "Finance", subtitle: "การเงิน", wordsCount: 250, coverColor: .white)
        ]
        
        
        selectedCategoryWords = [
            VocabWord(word: "Grocery", translation: "ของชำ", examples: [
                "The customer passes through the check-out point with bottles of drink along with the groceries.",
                "Such a grocer could sell alcoholic liquor, but he also had to stock groceries."], audioURL: nil),
            VocabWord(word: "Serendipity", translation: "การมีโชคในการค้นพบบางสิ่งโดยบังเอิญ", examples: [
                "Finding a great coffee shop on my way to the meeting was a moment of serendipity.",
                "There is a real element of serendipity in archaeology."], audioURL: nil)
        ]
        
        
        dailyWord = selectedCategoryWords.first
    }
    
    
    func loadWords(for category: VocabCategory) {
        // TODO: Replace with network fetch per category
        selectedCategoryWords = [
            VocabWord(word: "Grocery", translation: "ของชำ", examples: [
                "The customer passes through the check-out point with bottles of drink along with the groceries."], audioURL: nil),
            VocabWord(word: "Market", translation: "ตลาด", examples: ["We bought fresh fruit at the market."], audioURL: nil)
        ]
    }
}
