//
//  GameElements.swift
//  PlatformTutorial
//
//  Created by Nanette Lindrupsen  on 23/11/2023.
//

import Foundation
import SpriteKit

extension GameScene {
    func createBackground () -> SKNode {
        let backgroundNode = SKNode()
        let spacing = CGFloat(64)
        
        for index in 0 ... 41 {
            let node = SKSpriteNode(imageNamed: String(format: "Background-%02d", index + 1))
//            node.setScale(scaleFactor)
            node.anchorPoint = CGPoint(x: 0.5, y:0)
            node.position = CGPoint(x: self.size.width / 2, y: spacing * CGFloat(index))
            
            backgroundNode.addChild(node)
        }
        return backgroundNode
    }

    func createMidground () -> SKNode {
        let midgroundNode = SKNode()
        var anchor: CGPoint!
        var xPos: CGFloat!
        
        
        for index in 0 ... 9 {
            var name: String
            let randomNumber = arc4random() % 2
            
            if randomNumber > 0 {
                name = "cloudLeft3"
                anchor = CGPoint(x: 0, y: 0.5)
                xPos = 0
            } else {
                name = "cloudRight3"
                anchor = CGPoint( x:1, y:0.5)
                xPos = self.size.width
            }
            
            let cloudNode = SKSpriteNode(imageNamed: name)
            cloudNode.anchorPoint = anchor
            cloudNode.position = CGPoint(x: xPos, y: 500 * CGFloat(index))
            
            midgroundNode.addChild(cloudNode)
        }
        
        return midgroundNode
    }
    
    func createPlayer() -> SKNode {
        let playerNode = SKNode()
        playerNode.position = CGPoint(x: self.size.width / 2, y : 80)
        
        let sprite = SKSpriteNode(imageNamed: "Player5")
        playerNode.addChild(sprite)
        
        playerNode.physicsBody = SKPhysicsBody(circleOfRadius: (sprite.size.width / 2) - 10)
        
        playerNode.physicsBody?.isDynamic = false
        playerNode.physicsBody?.allowsRotation = false
        
        playerNode.physicsBody?.restitution = 1
        playerNode.physicsBody?.friction = 0
        playerNode.physicsBody?.linearDamping = 0
        
        playerNode.physicsBody?.usesPreciseCollisionDetection = true
        
        // The type of object this is for considering collisions
        playerNode.physicsBody?.categoryBitMask = CollisionBitMask.Player
        
        // What category of object this node should collide with
        playerNode.physicsBody?.collisionBitMask = 0
        
        // Which collisions we want to be notified about.
        playerNode.physicsBody?.contactTestBitMask = CollisionBitMask.Flower | CollisionBitMask.Brick
        
        return playerNode
    }
    
    func createPlatformAtPosition( position: CGPoint, ofType type:PlatformType) -> PlatformNode {
        let node = PlatformNode()
        let position = CGPoint(x:position.x * scaleFactor, y: position.y )
        node.position = position
        node.name = "PLATFORMNODE"
        node.platformType = type
        
        var sprite: SKSpriteNode
        
        if type == PlatformType.normalBrick {
            sprite = SKSpriteNode(imageNamed: "Platform6")
        } else {
            sprite = SKSpriteNode(imageNamed: "PlatformBreakable4")
        }
        
        node.addChild(sprite)
        
        node.physicsBody = SKPhysicsBody(rectangleOf: sprite.size)
        node.physicsBody?.isDynamic = false
        node.physicsBody?.categoryBitMask = CollisionBitMask.Brick
        node.physicsBody?.collisionBitMask = 0
        
        return node
    }
    
    
    func createFlowerAtPosition( position: CGPoint, ofType type:FlowerType) -> FlowerNode {
        let node = FlowerNode()
        let position = CGPoint(x:position.x * scaleFactor, y: position.y )
        node.position = position
        node.name = "FLOWERNODE"
        node.flowerType = type
        
        var sprite: SKSpriteNode
        
        if type == FlowerType.normalFlower {
            sprite = SKSpriteNode(imageNamed: "flower6")
        } else {
            sprite = SKSpriteNode(imageNamed: "flowerSpecial6")
        }
        
        node.addChild(sprite)
        
        node.physicsBody = SKPhysicsBody(circleOfRadius: sprite.size.width / 2)
        node.physicsBody?.isDynamic = false
        node.physicsBody?.categoryBitMask = CollisionBitMask.Flower
        node.physicsBody?.collisionBitMask = 0
        
        return node
    }
    
    
    

    
}
