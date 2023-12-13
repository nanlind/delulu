//
//  PlatformNode.swift
//  PlatformTutorial
//
//  Created by Nanette Lindrupsen  on 23/11/2023.
//

import UIKit
import SpriteKit

class PlatformNode: GenericNode {

    var platformType: PlatformType!
    
    override func collisionWithPlayer(player: SKNode) -> Bool {
        if player.physicsBody?.velocity.dy != nil && (player.physicsBody?.velocity.dy)! < 0 {
            player.physicsBody?.velocity = CGVector(dx: player.physicsBody!.velocity.dx, dy: 250)
            
            if platformType == PlatformType.breakableBrick {
                self.removeFromParent()
            }
        }
        return false
    }
}
