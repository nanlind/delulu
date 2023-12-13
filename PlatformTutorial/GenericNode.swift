//
//  GenericNode.swift
//  PlatformTutorial
//
//  Created by Nanette Lindrupsen  on 23/11/2023.
//

import UIKit
import SpriteKit


struct CollisionBitMask {
    static let Player: UInt32 = 0x00
    static let Flower: UInt32 = 0x01
    static let Brick: UInt32 = 0x02
}

enum PlatformType: Int {
    case normalBrick = 0
    case breakableBrick = 1
}

class GenericNode: SKNode {
    
    func collisionWithPlayer(player: SKNode) -> Bool {
        return false
    }
    
    func shouldRemoveNode( playerY: CGFloat ) {
        if playerY > self.position.y + 300{
            self.removeFromParent()
        }
    }

}
