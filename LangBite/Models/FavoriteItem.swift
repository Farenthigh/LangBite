//
//  FavoriteItem.swift
//  LangBite
//
//  Created by janechi on 20/11/2568 BE.
//

import Foundation

enum FavoriteType: String, Codable {
    case word
    case playlist
}

struct FavoriteItem: Identifiable, Codable, Hashable {
    var id = UUID()
    let type: FavoriteType
    let value: String
    let category: String?
    let word: VocabWord?
}
