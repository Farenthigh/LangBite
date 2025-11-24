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

struct FavoriteItem: Identifiable, Codable {
    var id: Int?              // server ID
    let type: FavoriteType
    let value: String
    let category: String?
    let word: VocabWord?      // nil for playlist
}

// API request for toggling favorite
struct FavoriteToggleReq: Codable {
    let user_id: Int
    let word_id: String
    let type: FavoriteType
    let value: String
    let category: String?
    let word: VocabWord?
}

// API response for toggling favorite
struct FavoriteToggleRes: Codable {
    let data: FavoriteToggleReq?
    let error: String?
    let message: String
}

struct FavoriteMeRequest: Codable{
    let user_id: Int
}

// API response for fetching all favorites
struct FavoriteMeResponse: Codable {
    let data: [FavoriteMeItem]?
    let error: String?
    let message: String
}

struct FavoriteMeItem: Codable {
    let ID: Int
    let user_id: Int
    let word_id: String
    let type: String
    let value: String
    let category: String?
    let word: VocabWordAPI?
}

struct VocabWordAPI: Codable {
    let id: Int
    let word: String
    let meaningThai: String
    let examples: [String]
}

