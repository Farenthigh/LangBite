//
//  DailyWordViewModel.swift
//  LangBite
//
//  Created by janechi on 19/11/2568 BE.
//


import Foundation

class DailyWordViewModel: ObservableObject {
    @Published var today: VocabWord?

    private let repo = VocabularyRepository()

    init() {
        pickWord()
    }

    func pickWord() {
        let all = repo.loadDailyWords()
        guard !all.isEmpty else { return }

        let dayOfYear = Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 0
        today = all[dayOfYear % all.count]
    }
}
