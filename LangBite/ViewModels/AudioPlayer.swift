//
//  AudioPlayer.swift
//  LangBite
//
//  Created by farenthigh on 14/11/2568 BE.
//

import Foundation
import AVFoundation


final class AudioPlayer: ObservableObject {
    private var player: AVAudioPlayer?
    
    
    func playLocal(url: URL) {
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.prepareToPlay()
            player?.play()
        } catch {
            print("Audio play error:\(error)")
        }
    }
    
    
    func stop() {
        player?.stop()
    }
}
