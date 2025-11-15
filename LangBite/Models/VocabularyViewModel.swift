//
//  VocabularyViewModel.swift
//  LangBite
//
//  Created by janechi on 19/11/2568 BE.
//
import Foundation

class VocabularyViewModel: ObservableObject {
    @Published var wordsByCategory: [VocabCategory: [VocabWord]] = [:]

    private let repo = VocabularyRepository()

    init() {
        loadAll()
    }

    func loadAll() {
        for cat in VocabCategory.allCases {
            wordsByCategory[cat] = repo.loadCategory(cat)
        }
    }

    func words(for category: VocabCategory) -> [VocabWord] {
        wordsByCategory[category] ?? []
    }
}
