//
//  SugarTriggerEntity.swift
//  GrubbyWorm
//
//  Created by Wayne on 15/10/12.
//  Copyright © 2015年 GAME-CHINA.ORG. All rights reserved.
//

import GameplayKit

class SugarTriggerEntity: TriggerEntity {
    
    init(location: Location, style: TriggerSugarStyle) {
        super.init(location: location)
        
        energy = 10
        
        let display = TriggerSpriteComponent(type: .Sugar, style: style)
        addComponent(display)
    }
    
    override func fired() {
        super.fired()
    }
    
    func showTip() {
        
    }
    
    func hideTip() {
        
    }
    
    func sugarStyle() -> TriggerSugarStyle {
        if let style = componentForClass(TriggerSpriteComponent)?.style {
            return style
        }
        
        return .Maltose
    }
}
