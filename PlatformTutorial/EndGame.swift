//
//  EndGame.swift
//  PlatformTutorial
//
//  Created by Nanette Lindrupsen  on 28/11/2023.
//

import Foundation
import SpriteKit

class EndGame: SKScene {

    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(size: CGSize) {
        super.init(size: size)


        let flower = SKSpriteNode(imageNamed: "flower3")
        flower.position = CGPoint(x: self.size.width/2, y: 525)
        addChild(flower)
        
        let tryAgainLabel = SKLabelNode(fontNamed: "CourierNewPS-BoldMT")
        tryAgainLabel.fontSize = 16
        tryAgainLabel.fontColor = SKColor.white
        tryAgainLabel.position = CGPoint(x: self.size.width / 2, y: 50)
        tryAgainLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        
        tryAgainLabel.text = "Trykk for å spille igjen"
        addChild(tryAgainLabel)
        
        if(GameHandler.sharedInstance.highScore == GameHandler.sharedInstance.score){
            
            let tryAgainLabel = SKLabelNode(fontNamed: "CourierNewPS-BoldMT")
            tryAgainLabel.fontSize = 25
            tryAgainLabel.fontColor = SKColor.white
            tryAgainLabel.position = CGPoint(x: self.size.width / 2, y: 650)
            tryAgainLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
            
            tryAgainLabel.text = "Hurra! Ny highscore!🎉"
            addChild(tryAgainLabel)
        }
        
        
        placeText(text: "Highscore", alignmentLeft: true, yPos: 0)
        placeText(text: "\(GameHandler.sharedInstance.highScore)p", alignmentLeft: false, yPos: 0)
        
        placeText(text: "Your score", alignmentLeft: true, yPos: 1)
        placeText(text: "\(GameHandler.sharedInstance.score)p", alignmentLeft: false, yPos: 1)
        
        placeText(text: "Blomster", alignmentLeft: true, yPos: 2)
        placeText(text: "\(GameHandler.sharedInstance.flowers)stk", alignmentLeft: false, yPos: 2)
        
        func placeText(text: String, alignmentLeft: Bool, yPos: CGFloat){
            let scoreFontSize = CGFloat(20)
            let scorePosition = CGPoint(x: self.size.width / 2, y: 400)
            let font = alignmentLeft ? "CourierNewPS-BoldMT" : "Courier"
            
            let newText = SKLabelNode(fontNamed: font)
            newText.fontSize = scoreFontSize
            newText.fontColor = SKColor.white
            if alignmentLeft {
                newText.position = CGPoint(x: 50, y: scorePosition.y - scoreFontSize * yPos)
            } else {
                newText.position = CGPoint(x: scorePosition.x, y: scorePosition.y - scoreFontSize * yPos)
            }
            
            newText.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
            
            newText.text = text
            addChild(newText)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let transition = SKTransition.fade(withDuration: 0.5)
        let gameScene = GameScene(size: self.size)
        self.view?.presentScene(gameScene, transition: transition)
    }
    
    
    
}
