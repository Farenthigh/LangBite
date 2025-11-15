//
//  SpeechManager.swift
//  LangBite
//
//  Created by janechi on 19/11/2568 BE.
//


import AVFoundation
import SwiftUI

class SpeechManager: ObservableObject {
    private let synthesizer = AVSpeechSynthesizer()

    func speak(_ text: String, language: String = "en-US") {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: language)
        utterance.rate = AVSpeechUtteranceDefaultSpeechRate
        synthesizer.speak(utterance)
    }
}
