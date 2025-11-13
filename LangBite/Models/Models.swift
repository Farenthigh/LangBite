//
//  Models.swift
//  LangBite
//
//  Created by farenthigh on 14/11/2568 BE.
//

import SwiftUI

// Models.swift
struct VocabCategory: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let subtitle: String
    let wordsCount: Int
    let coverColor: Color
}


struct VocabWord: Identifiable, Hashable {
    let id = UUID()
    let word: String
    let translation: String
    let examples: [String]
    let audioURL: URL?
}
