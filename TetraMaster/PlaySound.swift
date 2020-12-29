//
//  PlaySound.swift
//  TetraMaster
//
//  Created by Tim Musil on 29.11.20.
//

import AVFoundation

var audioPlayer: AVAudioPlayer?

func playSound(sound: String, type: String) {
    if let path = Bundle.main.path(forResource: sound, ofType: type) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            audioPlayer?.play()
        } catch {
            print("Error, couldn't find file")
        }
    }
}

var music: AVAudioPlayer!

func playMusic() {
    if let musicURL = Bundle.main.url(forResource: "Title", withExtension: "mp3") {
        if let audioPlayer = try? AVAudioPlayer(contentsOf: musicURL) {
            music = audioPlayer
            music.numberOfLoops = -1
            music.play()
        }
    }
}

func playGameMusic() {
    if let musicURL = Bundle.main.url(forResource: "TetraMaster", withExtension: "mp3") {
        if let audioPlayer = try? AVAudioPlayer(contentsOf: musicURL) {
            music = audioPlayer
            music.numberOfLoops = -1
            music.play()
        }
    }
}



