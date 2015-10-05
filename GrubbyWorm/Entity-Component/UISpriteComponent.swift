//
//  UISpriteComponent.swift
//  GrubbyWorm
//
//  Created by Wayne on 15/9/24.
//  Copyright © 2015年 GAME-CHINA.ORG. All rights reserved.
//

import GameplayKit
import SpriteKit

class UISpriteComponent: GKComponent {
    
    // MARK: Static properties
    
    
    // MARK: Private properties
    
    private var _game: Game
    private var _ui: Entity?
    
    // MARK: Properties
    
    // current scene size
    var sceneSize: CGSize
    
    // all ui elements root node.
    let root: SKNode
    
    // top root node for contain all top elements: score, energy bar, pause button.
    let topRoot: SKNode
    
    // label show current score
    var score: SKLabelNode
    
    // show the worm's current energy
    var energyBar: EnergyBar
    
    // pause button
    var pauseButton: GWButton
    
    // show the worm's mood :)
    var moodBar: MoodBar
    
    // grubby worm logo
    var logo: Logo
    
    // play button
    var playButton: GWButton
    
    // MARK: Initializers
    
    init(game: Game, ui: Entity?) {
        _game = game
        _ui = ui
        sceneSize = _game.scene!.size
        
        root = SKNode()
        topRoot = SKNode()
        topRoot.position = CGPointMake(0, sceneSize.height - Theme.top_bar_board_height)
        
        // base nodes tree
        root.zPosition = 100
        _game.scene?.addChild(root)
        root.addChild(topRoot)
        
        let topBoard = SKSpriteNode(color: Theme.primary_color, size: CGSizeMake(sceneSize.width, Theme.top_bar_board_height))
        topBoard.anchorPoint = CGPointMake(0, 0)
        
        score = SKLabelNode(fontNamed: "Stiff Staff")
        score.text = "0"
        score.verticalAlignmentMode = .Center
        score.position = CGPointMake(Theme.energy_bar_margin / 2, Theme.top_bar_board_height / 2)
        
        energyBar = EnergyBar(width: sceneSize.width)
        
        // pause button
        pauseButton = GWButton(normalTexture: SKTexture(imageNamed: "Spaceship"))
        pauseButton.size = CGSizeMake(30, 30)
        pauseButton.position = CGPointMake(sceneSize.width - Theme.energy_bar_margin / 2, Theme.top_bar_board_height / 2)
        
        topRoot.addChild(topBoard)
        topRoot.addChild(energyBar)
        topRoot.addChild(score)
        topRoot.addChild(pauseButton)
        
        moodBar = MoodBar(width: sceneSize.width)
        moodBar.position = CGPointMake(0, 0)
        moodBar.hidden = true
        root.addChild(moodBar)
        
        logo = Logo()
        root.addChild(logo)
        
        // play button
        playButton = GWButton(normalTexture: SKTexture(imageNamed: "Spaceship"))
        playButton.size = CGSizeMake(100, 100)
        playButton.position = CGPointMake(sceneSize.width / 2, sceneSize.height / 2)
        root.addChild(playButton)
        
        super.init()
        
        // some style and callback
        registerEvent()
    }
    
    func registerEvent() {
        pauseButton.actionTouchUpInside = GWButtonTarget.aBlock({ () -> Void in
            print("click pause")
            self.entity?.componentForClass(GameControlComponent)?.stateMachine?.enterState(UIPlayingState)
        })
    }
    
    func initItems() {
        
//        menu = SKSpriteNode(imageNamed: "Spaceship")
//        menu?.position = CGPointMake(200, 200)
//        menu?.setScale(0.5)
//        root.addChild(menu!)
//        
//        let texture = SKTexture(imageNamed: "Spaceship")
//        let selectedTexture = SKTexture(imageNamed: "Spaceship_h")
//        button = GWButton(normalTexture: texture, selectedTexture: selectedTexture, disabledTexture: texture)
//        button!.position = CGPointMake(300, 200)
//        button!.actionTouchUpInside = GWButtonTarget.aBlock({ () -> Void in
//            print("button click")
//            self.entity?.componentForClass(GameControlComponent)?.stateMachine?.enterState(UIPlayingState)
//        })
//        
//        root.addChild(button!)
    }
    
    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        
    }
    
    func useTitleAppearance() {
        
    }
    
    func usePlayingAppearance() {
        self.moodBar.hidden = false
    }
    
    func usePauseAppearance() {
        
    }
    
    func useGameOverAppearance() {
        
    }
}