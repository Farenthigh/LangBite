//
//  VocabCategory.swift
//  LangBite
//
//  Created by janechi on 19/11/2568 BE.
//


enum VocabCategory: String, CaseIterable, Identifiable {
    case business
    case finance
    case food
    case slang
    case daily_life
    case exam_prep
    case academic_writing
    case emotions

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .business: return "Business"
        case .finance: return "Finance"
        case .food: return "Food"
        case .slang: return "Slang"
        case .daily_life: return "Daily Life"
        case .exam_prep: return "Exam Prep"
        case .academic_writing: return "Academic Writing"
        case .emotions: return "Emotions"
        }
    }

    var fileName: String { rawValue }
}
