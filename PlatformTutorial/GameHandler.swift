//
//  GameHandler.swift
//  PlatformTutorial
//
//  Created by Nanette Lindrupsen  on 27/11/2023.
//

import Foundation

class GameHandler {
    var score: Int
    var highScore: Int
    var flowers: Int
    
    var levelData: NSDictionary!
    
    class var sharedInstance: GameHandler {
        struct Singleton {
            static let instance = GameHandler()
        }
        return Singleton.instance
    }
    
    init(){
        score = 0
        highScore = 0
        flowers = 0
        
        let userDefaults = UserDefaults.standard
        
//        userDefaults.removeObject(forKey: "highScore")
        userDefaults.removeObject(forKey: "flowers")
        
        highScore = userDefaults.integer(forKey: "highScore")
//        flowers = userDefaults.integer(forKey: "flowers")
        
        
        // load level data
        if let path = Bundle.main.path(forResource: "Level01", ofType: "plist") {
            if let level = NSDictionary(contentsOfFile: path) {
                levelData = level
            }
        }
    }

    func saveGameStats() {
        highScore = max(score, highScore)
        
        let userDefaults = UserDefaults.standard
    
        userDefaults.set(highScore, forKey: "highScore")
        userDefaults.set(0, forKey: "flowers")
        userDefaults.synchronize()
    }
    
    
}
