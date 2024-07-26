//
//  GameViewController.swift
//  boids-visualization
//
//  Created by Никита Харсеко on 26/07/2024.
//

import UIKit
import SpriteKit
import GameplayKit


class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        if let view = self.view as! SKView? {
            let scene = GameScene(size: view.bounds.size)
            scene.scaleMode = .resizeFill

            view.presentScene(scene)
            view.ignoresSiblingOrder = true
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
