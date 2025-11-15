//
//  Word.swift
//  LangBite
//
//  Created by janechi on 19/11/2568 BE.
//

import Foundation

struct VocabWord: Identifiable, Hashable, Codable {
    let id: Int
    let word: String
    let meaningThai: String
    let examples: [String]
}

