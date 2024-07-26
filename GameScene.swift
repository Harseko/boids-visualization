//
//  GameScene.swift
//  boids-visualization
//
//  Created by Никита Харсеко on 26/07/2024.
//

import SpriteKit
import GameplayKit


class GameScene: SKScene {
    var fishes: [Fish] = []
    var barriers: [Barrier] = []

    override func didMove(to view: SKView) {
        setupCircle()
        setupBoids()
    }

    func setupCircle() {
        barriers = []
        let count = CGFloat(Int(self.size.width / 40))
        for x in stride(from: 0, to: count, by: 1) {
            let dir = (CGFloat(x) / count) * CGFloat.pi * 2
            barriers.append(
                Barrier(position: CGPoint(
                    x: self.size.width * 0.5 + cos(dir) * self.size.width * 0.35,
                    y: self.size.height * 0.5 + sin(dir) * self.size.width * 0.35
                ))
            )
        }
        barriers.forEach { addChild($0) }
    }

    func setupBoids() {
        for _ in 0..<100 {
            let fish = Fish(
                position: CGPoint(x: CGFloat.random(in: 0...size.width),
                                  y: CGFloat.random(in: 0...size.height)))
            addChild(fish)
            fishes.append(fish)
        }
    }

    override func update(_ currentTime: TimeInterval) {
        self.backgroundColor = SKColor.black

        fishes.forEach {
            $0.applyBehaviors(fishes: fishes, barriers: barriers, sceneSize: scene?.size ?? .zero)
        }
    }

}
