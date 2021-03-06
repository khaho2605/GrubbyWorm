//
//  TriggerSpriteComponent.swift
//  GrubbyWorm
//
//  Created by Wayne on 15/10/7.
//  Copyright © 2015年 GAME-CHINA.ORG. All rights reserved.
//

import GameplayKit
import SpriteKit

// MARK: Trigger Type

enum TriggerType {
    case Sugar
    case Candy
    case Grubby
}

// MARK: Trigger Sugar Style

enum TriggerSugarStyle: UInt32 {
    case Maltose
    case Praline
    case Fondant
    case Crispy
    case Chocolate
    
    private static let _count: TriggerSugarStyle.RawValue = {
        // find the maximum enum value
        var maxValue: UInt32 = 0
        while let _ = TriggerSugarStyle(rawValue: ++maxValue) { }
        return maxValue
    }()
    
    static func randomStyle() -> TriggerSugarStyle {
        // pick and return a new value
        let rand = arc4random_uniform(_count)
        return TriggerSugarStyle(rawValue: rand)!
    }
    
    func color() -> SKColor {
        switch self {
        case .Maltose:
            return Theme.sugar_color_maltose
        case .Praline:
            return Theme.sugar_color_praline
        case .Fondant:
            return Theme.sugar_color_fondant
        case .Crispy:
            return Theme.sugar_color_crispy
        case .Chocolate:
            return Theme.sugar_color_chocolate
        }
    }
}

class TriggerSpriteComponent: GKComponent {
    
    static let triggerSize = CGSizeMake(36, 36)
    
    // MARK: Properties
    
    var root: SKNode
    var type: TriggerType
    var style: TriggerSugarStyle?
    
    // MARK: Initializers

    init(type: TriggerType = .Sugar, style: TriggerSugarStyle = .Maltose) {
        root = SKNode()
        self.type = type
        
        if type == .Sugar {
            self.style = style
        }
        
        super.init()
        
        giveBirth()
    }
    
    private func giveBirth() {
        switch type {
        case .Sugar, .Candy:
            sugarBorn({ (Void) -> () in
                self.renderDisplay()
            })
            break
        case .Grubby:
            renderDisplay()
            break
        }
    }
    
    private func renderDisplay() {
        
        let size = TriggerSpriteComponent.triggerSize
        
        switch type {
        case .Sugar:
            let display = SKSpriteNode(imageNamed: "cuit_star")
            display.size = size
            display.name = Constant.trigger_display_name
            
            renderSugarStyle(display)
            sugarRotate(display)
            grubbyShake(display)
            
            root.addChild(display)
            break
        case .Candy:
            let display = SKSpriteNode(imageNamed: "sugar_mixin")
            display.size = size
            display.name = Constant.trigger_display_name
            display.setScale(0.93)
            
            sugarRotate(display)
            grubbyShake(display)
            
            root.addChild(display)
            break
        case .Grubby:
            let display = SKSpriteNode(imageNamed: "bb")
            display.size = size
            display.name = Constant.trigger_display_name
            display.setScale(0.8)
            display.position = CGPointMake(0, -8)
            
            grubbyShake(display)
            grubbySmell(display)
            
            root.addChild(display)
            break
        }
    }
    
    private func renderSugarStyle(display: SKSpriteNode) {
        if let style = style {
            switch style {
            case .Maltose:
                display.color = Theme.sugar_color_maltose
                display.colorBlendFactor = 1
                
                break
            case .Praline:
                display.color = Theme.sugar_color_praline
                display.colorBlendFactor = 1
                
                break
            case .Fondant:
                display.color = Theme.sugar_color_fondant
                display.colorBlendFactor = 1
                
                break
            case .Crispy:
                display.color = Theme.sugar_color_crispy
                display.colorBlendFactor = 1
                
                break
            case .Chocolate:
                display.color = Theme.sugar_color_chocolate
                display.colorBlendFactor = 1
                
                break
            }
        }
    }
    
    private func sugarRotate(display: SKSpriteNode) {
        let action = SKAction.rotateByAngle(5, duration: 15.0)
        display.runAction(SKAction.repeatActionForever(action))
    }
    
    private func grubbyShake(display: SKSpriteNode) {
        display.setScale(0.84)
        let action = SKAction.scaleXBy(0.115, y: 0.075, duration: 4.6, delay: 0, usingSpringWithDamping: 0.1, initialSpringVelocity: 0.3)
        
        display.runAction(SKAction.repeatActionForever(action))
    }
    
    private func grubbySmell(display: SKSpriteNode) {
        let smell = SKSpriteNode(imageNamed: "smell")
        smell.size = display.size
        smell.position = CGPointMake(0, 15)
        smell.zPosition = 1
        smell.setScale(0.45)
        root.addChild(smell)
        
        let fadeOut = SKAction.fadeOutWithDuration(2.6)
        let moveUp = SKAction.moveBy(CGVectorMake(0, 5), duration: 4.6)

        let action = SKAction.sequence([SKAction.group([fadeOut, moveUp]), SKAction.runBlock({ () -> Void in
            smell.position = CGPointMake(0, 15)
            smell.alpha = 1
        })])
        
        smell.runAction(SKAction.repeatActionForever(action))
    }
    
    private func sugarBorn(handler: (Void -> ())) {
        let born = SKSpriteNode(imageNamed: "born")
        born.size = TriggerSpriteComponent.triggerSize
        born.color = Theme.born_color
        born.colorBlendFactor = 1
        born.setScale(0.35)
        root.addChild(born)
        
        let scale = SKAction.scaleXTo(0.65, y: 0.65,
            duration: 1.5, delay: 0,
            usingSpringWithDamping: 0.2, initialSpringVelocity: 0)
        
        born.runAction(scale) { () -> Void in
            born.removeFromParent()

            if let entity = self.entity as? TriggerEntity {
                entity.born = true
                handler()
            }
        }
    }
    
    func showEatMe() {
        if let display = root.childNodeWithName(Constant.trigger_display_name) {
            if display.actionForKey(Constant.action_key_eat_me) != nil {
                return
            }
            
            let changeWhite = SKAction.colorizeWithColor(SKColor.whiteColor(), colorBlendFactor: 1, duration: 0.2)
            let changeBack = SKAction.colorizeWithColor(style!.color(), colorBlendFactor: 1, duration: 0.5)
            
            let action = SKAction.sequence([changeWhite, changeBack])
            display.runAction(SKAction.repeatActionForever(action), withKey: Constant.action_key_eat_me)
        }
    }
    
    func hideEatMe() {
        if let display = root.childNodeWithName(Constant.trigger_display_name) as? SKSpriteNode {
            display.removeActionForKey(Constant.action_key_eat_me)
            
            display.color = style!.color()
        }
    }
}
