//
//  FlowerNode.swift
//  PlatformTutorial
//
//  Created by Nanette Lindrupsen  on 23/11/2023.
//

import UIKit
import SpriteKit

enum FlowerType:Int {
    case normalFlower = 0
    case specialFlower = 1
}

class FlowerNode: GenericNode {
    var flowerType: FlowerType!
    
    override func collisionWithPlayer(player: SKNode) -> Bool {
        player.physicsBody?.velocity = CGVector(dx: player.physicsBody!.velocity.dx, dy: 400)

        GameHandler.sharedInstance.score += (flowerType == FlowerType.normalFlower ? 20 : 100)
        GameHandler.sharedInstance.flowers += 1
//        GameHandler.sharedInstance.flowers += (flowerType == FlowerType.normalFlower ? 1 : 5)
        
        self.removeFromParent()
        
        return true
        
    }
}
