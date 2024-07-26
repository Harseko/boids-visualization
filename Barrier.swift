//
//  Barrier.swift
//  boids-visualization
//
//  Created by Никита Харсеко on 26/07/2024.
//

import SceneKit
import GameplayKit
import UIKit

class Barrier: SKNode {
    init(position: CGPoint) {
        super.init()
        self.position = position
        self.setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup() {
        let shape = SKShapeNode(circleOfRadius: 15)
        shape.fillColor = SKColor(hue: 0.5, saturation: 1, brightness: 0.8, alpha: 1)
        shape.strokeColor = .clear
        self.addChild(shape)
    }
}
