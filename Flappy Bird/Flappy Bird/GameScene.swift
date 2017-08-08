//
//  GameScene.swift
//  Flappy Bird
//
//  Created by Frascella Claudio on 5/5/17.
//  Copyright © 2017 frascella. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {

    var gameOver = false
    var score = 0
    var level = 1
    let multiplier = 10
    
    var bird = SKSpriteNode()
    var background = SKSpriteNode()
    var scoreLabel = SKLabelNode()
    var gameOverLabel = SKLabelNode()
    
    var timer = Timer()
    
    enum ColliderType: UInt32 {
        case Bird = 1
        case Object = 2
        case Gap = 4
    }

    func makePipes() {
        
        //------pipes
        
        //compute gap height of the pipes
        let gapHeight = bird.size.height * 3//CGFloat(4 - (level / multiplier))
        
        //configure pipe animation
        let movePipes = SKAction.move(by: CGVector(dx: -2 * self.frame.width, dy: 0), duration: TimeInterval(self.frame.width / CGFloat(100 - level + 1)))
        
        //randomize length of pipes
        let movementAmount = arc4random() % UInt32(self.frame.height / 2)
        
        //distance allowance
        let pipeOffset = CGFloat(movementAmount) - self.frame.height / 4
        
        //TESTING ONLy randomize length of pipes
        //let movementAmount2 = arc4random() % UInt32(self.frame.width / 2)
        //let pipeOffset2 = CGFloat(movementAmount2) - self.frame.width / 4
        let pipeOffset2 = CGFloat(0)
        
        //pipe image
        let pipeTexture1 = SKTexture(imageNamed: "pipe1.png")
        let pipe1 = SKSpriteNode(texture: pipeTexture1)
        pipe1.position = CGPoint(x: self.frame.midX + self.frame.width + pipeOffset2, y: self.frame.midY + pipeTexture1.size().height / 2 + gapHeight + pipeOffset)
        pipe1.zPosition = -1
        pipe1.run(movePipes)
        
        
        //define physics body
        pipe1.physicsBody = SKPhysicsBody(rectangleOf: pipeTexture1.size())
        //give gravity
        pipe1.physicsBody!.isDynamic = false
        
        //cause collision notif with <pipe1>
        pipe1.physicsBody!.contactTestBitMask = ColliderType.Object.rawValue
        //defines which categories the <pipe1> belongs to
        pipe1.physicsBody!.categoryBitMask = ColliderType.Object.rawValue
        //defines which category of physics bodies can collide with <pipe1>
        pipe1.physicsBody!.collisionBitMask = ColliderType.Object.rawValue
        
        self.addChild(pipe1)
        
        
        //replicate with pipe2
        let pipeTexture2 = SKTexture(imageNamed: "pipe2.png")
        let pipe2 = SKSpriteNode(texture: pipeTexture2)
        pipe2.position = CGPoint(x: self.frame.midX + self.frame.width + pipeOffset2, y: self.frame.midY - pipeTexture2.size().height / 2 - gapHeight + pipeOffset)
        pipe2.zPosition = -1
        pipe2.run(movePipes)
        
        pipe2.physicsBody = SKPhysicsBody(rectangleOf: pipeTexture2.size())
        pipe2.physicsBody!.isDynamic = false
        
        pipe2.physicsBody!.contactTestBitMask = ColliderType.Object.rawValue
        pipe2.physicsBody!.categoryBitMask = ColliderType.Object.rawValue
        pipe2.physicsBody!.collisionBitMask = ColliderType.Object.rawValue
        
        self.addChild(pipe2)
        
        
        //- gap for scoring
        let gap = SKNode()
        gap.position =   CGPoint(x: self.frame.midX + self.frame.width + pipeOffset2, y: self.frame.midY + pipeOffset)
        gap.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: pipeTexture1.size().width, height: gapHeight))
        gap.physicsBody!.isDynamic = false
        gap.run(movePipes)
        
        gap.physicsBody!.contactTestBitMask = ColliderType.Bird.rawValue
        gap.physicsBody!.categoryBitMask = ColliderType.Gap.rawValue
        gap.physicsBody!.collisionBitMask = ColliderType.Gap.rawValue
        
        self.addChild(gap)
        
    }

    //detect collision
    func didBegin(_ contact: SKPhysicsContact) {
        
        if gameOver == false {
        
        if contact.bodyA.categoryBitMask == ColliderType.Gap.rawValue || contact.bodyB.categoryBitMask == ColliderType.Gap.rawValue {
            score += 1
            level = score%multiplier == 0 ? (level + 1) : level
            scoreLabel.text = "\(String(score))"
            
        
        } else {
            timer.invalidate()
            
            self.speed = 0
            gameOver = true
            gameOverLabel.fontName = "Helvetica"
            gameOverLabel.fontSize = 30
            gameOverLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
            gameOverLabel.text = "Game Over! Tap to play again."
            self.addChild(gameOverLabel)
        }
        
        }
    }
    
    // like viewDiDLoad
    override func didMove(to view: SKView) {
        
        self.physicsWorld.contactDelegate = self
        
        setupGame()
        
    }
    
    func setupGame() {
        
        //timer for spawning pipes
        timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.makePipes), userInfo: nil, repeats: true)
        
        //------background
        let bgTexture = SKTexture(imageNamed: "bg.png")
        
        // setup animation
        // make 3 backgrounds that shift one after the other
        let moveBGAnimation = SKAction.move(by: CGVector(dx: -bgTexture.size().width, dy: 0), duration: 7)
        let shiftBGAnimation = SKAction.move(by: CGVector(dx: bgTexture.size().width, dy: 0), duration: 0)
        let makeBGMoveForever = SKAction.repeatForever(SKAction.sequence([moveBGAnimation, shiftBGAnimation]))
        
        var i:CGFloat = 0
        while i < 3 {
            
            background = SKSpriteNode(texture: bgTexture)
            background.position = CGPoint(x: bgTexture.size().width * i, y: self.frame.midY)
            background.size.height = self.frame.height
            
            //apply animation
            background.run(makeBGMoveForever)
            
            //3d position
            background.zPosition = -2
            
            //add to view
            self.addChild(background)
            
            i += 1
        }
        
        //------bird
        let birdTexture = SKTexture(imageNamed: "flappy1.png")
        let birdTexture2 = SKTexture(imageNamed: "flappy2.png")
        
        let animation = SKAction.animate(with: [birdTexture, birdTexture2], timePerFrame: 0.1)
        let makeBirdFlapForever = SKAction.repeatForever(animation)
        
        bird = SKSpriteNode(texture: birdTexture)
        bird.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        
        bird.run(makeBirdFlapForever)
        
        bird.physicsBody = SKPhysicsBody(circleOfRadius: birdTexture.size().height / 2)
        bird.physicsBody!.isDynamic = false
        
        bird.physicsBody!.contactTestBitMask = ColliderType.Object.rawValue
        bird.physicsBody!.categoryBitMask = ColliderType.Bird.rawValue
        bird.physicsBody!.collisionBitMask = ColliderType.Bird.rawValue
        
        self.addChild(bird)
        
        
        //------ground (invisible)
        let ground = SKNode()
        
        ground.position = CGPoint(x: self.frame.midX, y: -self.frame.height / 2)
        ground.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.width, height: 1))
        ground.physicsBody!.isDynamic = false
        
        //adding them will make bird disappear from thr screen
        //ground.physicsBody!.contactTestBitMask = ColliderType.Object.rawValue
        //ground.physicsBody!.categoryBitMask = ColliderType.Object.rawValue
        //ground.physicsBody!.collisionBitMask = ColliderType.Object.rawValue
        
        self.addChild(ground)
        
        
        //------score label
        scoreLabel.fontName = "Helvetica"
        scoreLabel.fontSize = 60
        scoreLabel.text = "0"
        scoreLabel.position = CGPoint(x: self.frame.midX, y: self.frame.height / 2 - 70)
        self.addChild(scoreLabel)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        if gameOver == false {
            bird.physicsBody!.isDynamic = true
            
            //speed
            bird.physicsBody!.velocity = CGVector(dx: 0, dy: 0)
            
            //impulse movement
            bird.physicsBody!.applyImpulse(CGVector(dx: 0, dy: 70))
        } else {
            gameOver = false
            score = 0
            level = 1
            self.speed = 1
            self.removeAllChildren()
            setupGame()
        }
        
        
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
