//
//  VocabularyRepository.swift
//  LangBite
//
//  Created by janechi on 19/11/2568 BE.
//
import Foundation

struct VocabularyRepository {
    
    //load all categories
    func loadCategory(_ category: VocabCategory) -> [VocabWord] {
        loadJSON(name: category.fileName)
    }

    //load daily words
    func loadDailyWords() -> [VocabWord] {
        loadJSON(name: "daily")
    }

    //main func for load json from bundle
    private func loadJSON(name: String) -> [VocabWord] {
        print("Trying to load \(name).json")
        guard let url = Bundle.main.url(forResource: name, withExtension: "json") else {
            print("File not found in \(name).json")
            return []
        }
        
        print("found \(name).json")
        
        do {
            let data = try Data(contentsOf: url)
            let decoded = try JSONDecoder().decode([VocabWord].self, from: data)
            print("Decoded \(decoded.count) items from \(name)")
            return decoded
        } catch {
            print("Decode Error in \(name):", error)
            return []
        }
    }
}
