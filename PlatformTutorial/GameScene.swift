//
//  GameScene.swift
//  PlatformTutorial
//
//  Created by Nanette Lindrupsen  on 23/11/2023.
//

import SpriteKit
import GameplayKit
import CoreMotion

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    var background: SKNode!
    var midground: SKNode!
    var foreground:SKNode!
    
    var hud: SKNode!
    
    var player: SKNode!
    
    var scaleFactor: CGFloat!
    
    var startButton = SKSpriteNode(imageNamed: "TapToStart")
    
    var endOfGamePosition = 0
    
    let motionManager = CMMotionManager()
    
    var xAcceleration: CGFloat = 0.0
    var yAcceleration: CGFloat = 0.0
    
    var scoreLabel: SKLabelNode!
    var flowerLabel: SKLabelNode!
    
    var playersMaxY: Int!
    
    var gameOver = false
    
    var currentMaxY: Int!
    
    
    
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder:aDecoder)
    }
    
    override init(size: CGSize){
        super.init(size: size)
        
        backgroundColor = SKColor.white
        
        let levelData = GameHandler.sharedInstance.levelData
        
        currentMaxY = 80
        GameHandler.sharedInstance.score = 0
        gameOver = false
        
        endOfGamePosition = (levelData?["EndOfLevel"] as AnyObject).integerValue
        
        scaleFactor = self.size.width / 320
        
        background = createBackground()
        addChild(background)
        
        midground = createMidground()
        addChild(midground)
        
        foreground = SKNode()
        addChild(foreground)
        
        hud = SKNode()
        addChild(hud)
        
        startButton.position = CGPoint(x: self.size.width / 2, y: 180)
        hud.addChild(startButton)
        
        // Labels
        let flower = SKSpriteNode(imageNamed: "flower3")
        flower.position = CGPoint(x: 25, y: self.size.height-30)
        hud.addChild(flower)
        
        flowerLabel = SKLabelNode(fontNamed: "AmericanTypewriter-Bold")
        flowerLabel.fontSize = 30
        flowerLabel.fontColor = SKColor.white
        flowerLabel.position = CGPoint(x: 50, y: self.size.height - 40)
        flowerLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        
        flowerLabel.text = " \(GameHandler.sharedInstance.flowers)"
        hud.addChild(flowerLabel)
        
        scoreLabel = SKLabelNode(fontNamed: "AmericanTypewriter-Bold")
        scoreLabel.fontSize = 30
        scoreLabel.fontColor = SKColor.white
        scoreLabel.position = CGPoint(x: self.size.width - 20, y: self.size.height - 40)
        scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
        
        scoreLabel.text = "0"
        hud.addChild(scoreLabel)
        
        
        player = createPlayer()
        foreground.addChild(player)
        
        
        let platforms = levelData?["Platforms"] as! NSDictionary
        let platformPatterns = platforms["Patterns"] as! NSDictionary
        let platformPositions = platforms["Positions"] as! [NSDictionary]
        
        for platformPosition in platformPositions {
        
            let x = (platformPosition["x"] as AnyObject).floatValue
            let y = (platformPosition["y"] as AnyObject).floatValue
            let pattern = platformPosition["pattern"] as! NSString
            
            let platformPattern = platformPatterns[pattern] as! [NSDictionary]
            
            for platformPoint in platformPattern {
                let xValue = (platformPoint["x"] as AnyObject).floatValue
                let yValue = (platformPoint["y"] as AnyObject).floatValue
                let type = PlatformType(rawValue: (platformPoint["type"]! as AnyObject).integerValue)
                let xPosition = CGFloat(xValue! + x!)
                let yPosition = CGFloat(yValue! + y!)
                
                let platformNode = createPlatformAtPosition(position: CGPoint(x: xPosition, y: yPosition), ofType: type!)
                foreground.addChild(platformNode)
            }
            
        }
        
        
        let flowers = levelData?["Flowers"] as! NSDictionary
        let flowerPatterns = flowers["Patterns"] as! NSDictionary
        let flowerPositions = flowers["Positions"] as! [NSDictionary]
        
        for flowerPosition in flowerPositions {
        
            let x = (flowerPosition["x"] as AnyObject).floatValue
            let y = (flowerPosition["y"] as AnyObject).floatValue
            let pattern = flowerPosition["pattern"] as! NSString
            
            let flowerPattern = flowerPatterns[pattern] as! [NSDictionary]
            
            for flowerPoint in flowerPattern {
                let xValue = (flowerPoint["x"] as AnyObject).floatValue
                let yValue = (flowerPoint["y"] as AnyObject).floatValue
                let type = FlowerType(rawValue: (flowerPoint["type"]! as AnyObject).integerValue)
                let xPosition = CGFloat(xValue! + x!)
                let yPosition = CGFloat(yValue! + y!)
                
                let flowerNode = createFlowerAtPosition(position: CGPoint(x: xPosition, y: yPosition), ofType: type!)
                foreground.addChild(flowerNode)
            }
            
        }
        
        
        
//        let platform = createPlatformAtPosition(position: CGPoint(x: 160, y: 320), ofType: PlatformType.normalBrick)
//        foreground.addChild(platform)
        
//        let flower  = createFlowerAtPosition(position: CGPoint(x: 160, y: 220), ofType: FlowerType.specialFlower)
//        foreground.addChild(flower)
        
//        dy stor -> lavere hopp, raskere fall. Under null -> flyr.
        physicsWorld.gravity = CGVector(dx:0, dy: -2)
        physicsWorld.contactDelegate = self
        
        motionManager.accelerometerUpdateInterval = 1/40
        
        if(motionManager.isAccelerometerAvailable){
            motionManager.startAccelerometerUpdates(
                to: OperationQueue.current!,
                withHandler: {(data: CMAccelerometerData?, error: Error?) in
                
                    if let accelerometerData = data {
                        let acceleration = accelerometerData.acceleration
                        self.xAcceleration = (CGFloat(acceleration.x) + (self.xAcceleration * 0.25))
//                        self.xAcceleration = (CGFloat(acceleration.x) * 0.75 + (self.xAcceleration * 0.25))
                        
                    }
               
            })
        }
        
    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        var updateHUD = false
        var otherNode: SKNode!
        
        if contact.bodyA.node != player {
            otherNode = contact.bodyA.node
        } else {
            otherNode = contact.bodyB.node
        }
        
        updateHUD = (otherNode as! GenericNode).collisionWithPlayer(player: player)
        
        if updateHUD {
            flowerLabel.text = " \(GameHandler.sharedInstance.flowers)"
            scoreLabel.text = "\(GameHandler.sharedInstance.score)"
        }
        
//        _ = (otherNode as! GenericNode).collisionWithPlayer(player: player)
    }
    
    override func didSimulatePhysics() {
        // Accelerometer decide x position
        player.physicsBody?.velocity = CGVector(dx: xAcceleration * 400, dy: player.physicsBody!.velocity.dy)
        
        //if hit left corner. reappear at right corner and opposite
        if player.position.x < -20 {
            player.position = CGPoint(x: self.size.width + 20, y: player.position.y)
        } else if (player.position.x > self.size.width + 20) {
            player.position = CGPoint(x: -20, y: player.position.y)
        }
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if player.physicsBody!.isDynamic {
            return
        }
        
        startButton.removeFromParent()
        player.physicsBody?.isDynamic = true //reacts to physics when true
        player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 40))
    }
    
    
    // Called before each frame is rendered
    override func update(_ currentTime: TimeInterval) {
        
        if gameOver {
            return
        }
        
        foreground.enumerateChildNodes(withName: "PLATFORMNODE") { (node, stop) in
            let platform = node as! PlatformNode
            platform.shouldRemoveNode(playerY: self.player.position.y)
        }
        
        foreground.enumerateChildNodes(withName: "FLOWERNODE") { (node, stop) in
            let flower = node as! FlowerNode
            flower.shouldRemoveNode(playerY: self.player.position.y)
        }
       
        
        if player.position.y > 200 {
            background.position = CGPoint(x: 0, y: -((player.position.y - 200) / 4 ))
            midground.position = CGPoint(x: 0, y: -((player.position.y - 200) / 2))
            foreground.position = CGPoint(x: 0, y: -((player.position.y - 200)))
        }
        
        if Int(player.position.y) > currentMaxY {
            GameHandler.sharedInstance.score += Int(player.position.y) - currentMaxY
            currentMaxY = Int(player.position.y)
            
            scoreLabel.text = "\(GameHandler.sharedInstance.score)"
        }
        
        if Int(player.position.y) > endOfGamePosition {
            endGame()
        }
        
        if Int(player.position.y) < currentMaxY - 800 {
            endGame()
        }
        
    }
    
    func endGame() {
        gameOver = true
        GameHandler.sharedInstance.saveGameStats()
        
        let transition = SKTransition.fade(withDuration: 0.5)
        let endGameScene = EndGame(size: self.size)
        self.view?.presentScene(endGameScene, transition: transition)
    }
}
