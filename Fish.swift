//
//  Fish.swift
//  boids-visualization
//
//  Created by Никита Харсеко on 26/07/2024.
//

import UIKit
import SpriteKit
import GameplayKit

class Fish: SKNode {
    var shape: SKShapeNode = .init()

    var friendFOV: CGFloat = 60
    var barrierFOV: CGFloat = 30

    var separationRadius: CGFloat = 90

    var cohesionEnabled: Bool = true
    var alignmentEnabled: Bool = true
    var separationEnabled: Bool = true
    var avoidEnabled: Bool = true
    var noiseEnabled: Bool = true

    var shade: CGFloat = CGFloat.random(in: 0...1)
    var velocity: CGVector = CGVector(dx: CGFloat.random(in: -1...1),
                                      dy: CGFloat.random(in: -1...1))

    init(position: CGPoint) {
        super.init()

        self.position = position

        // Создаем форму рыбы (треугольник)
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 0, y: 10))
        path.addLine(to: CGPoint(x: -5, y: -5))
        path.addLine(to: CGPoint(x: 5, y: -5))
        path.closeSubpath()

        shape = SKShapeNode(path: path)
        shape.fillColor = SKColor(hue: 0.1, saturation: 1, brightness: 0.8, alpha: 1)
        shape.strokeColor = .clear
        self.addChild(shape)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func applyBehaviors(fishes: [Fish], barriers: [Barrier], sceneSize: CGSize) {
        let fishes = getFishesInFOV(fishes: fishes)
        let barriers = getBarriersInFOV(barriers: barriers)

        let cohesion = cohesion(fishes: fishes)
        let alignment = alignment(fishes: fishes)
        let separation = separation(fishes: fishes)
        let avoid = avoid(barriers: barriers)

        let noise = CGVector(dx: CGFloat.random(in: -0.1...0.1),
                             dy: CGFloat.random(in: -0.1...0.1))

        if cohesionEnabled {
            velocity.dx += cohesion.dx
            velocity.dy += cohesion.dy
        }

        if alignmentEnabled {
            velocity.dx += alignment.dx
            velocity.dy += alignment.dy
        }

        if separationEnabled {
            velocity.dx += separation.dx
            velocity.dy += separation.dy
        }

        if avoidEnabled {
            velocity.dx += avoid.dx
            velocity.dy += avoid.dy
        }

        if noiseEnabled {
            velocity.dx += noise.dx
            velocity.dy += noise.dy
        }

        // Ограничиваем скорость
        let maxSpeed: CGFloat = 1
        let minSpeed: CGFloat = 0.5
        let speed = sqrt(velocity.dx * velocity.dx + velocity.dy * velocity.dy)
        if speed > maxSpeed {
            velocity.dx = (velocity.dx / speed) * maxSpeed
            velocity.dy = (velocity.dy / speed) * maxSpeed
        } else if speed < minSpeed {
            velocity.dx = (velocity.dx / speed) * minSpeed
            velocity.dy = (velocity.dy / speed) * minSpeed
        }

        position.x += velocity.dx
        position.y += velocity.dy

        // Удерживаем внутри экрана
        if position.x < 0 { position.x = sceneSize.width }
        if position.x > sceneSize.width { position.x = 0 }
        if position.y < 0 { position.y = sceneSize.height }
        if position.y > sceneSize.height { position.y = 0 }

        // Поворачиваем боид по направлению движения
        zRotation = atan2(velocity.dy, velocity.dx) - CGFloat.pi / 2

        let shade = shade(fishes: fishes)

        shape.fillColor = SKColor(hue:  cartesianToHue(x: velocity.normalized.dx, y: velocity.normalized.dy),
                                  saturation: 1, //velocity.normalized.magnitude,
                                  brightness: 1, alpha: 1)
    }

    func cartesianToHue(x: Double, y: Double) -> Double {
        // Переводим координаты в полярные координаты
        let theta = atan2(y - 0.5, x - 0.5)

        // Переводим угол в градусы
        let hue = theta * 180 / .pi

        // Нормализуем значение угла в диапазоне от 0 до 1
        var hueNorm = (hue + 360) / 360
        hueNorm = hueNorm.truncatingRemainder(dividingBy: 1) // Убедиться, что значение в диапазоне [0, 1]

        return hueNorm
    }


    private func getFishesInFOV(fishes: [Fish]) -> [Fish] {
        fishes.filter {
            hypot($0.position.x - position.x, $0.position.y - position.y) < friendFOV
        }
    }

    private func getBarriersInFOV(barriers: [Barrier]) -> [Barrier] {
        barriers.filter {
            hypot($0.position.x - position.x, $0.position.y - position.y) < barrierFOV
        }
    }


    private func shade(fishes: [Fish]) -> CGFloat {
        var total: CGFloat = 0
        var count: CGFloat = 0

        for fish in fishes {
            total += fish.shade - shade
            count += 1
        }

        if count > 0 {
            return total / count
        }

        return shade
    }

    private func cohesion(fishes: [Fish]) -> CGVector {
        var position = CGPoint.zero
        var count: CGFloat = 0

        for fish in fishes {
            if fish !== self {
                position = position + fish.position
                count += 1
            }
        }

        if count > 0 {
            position = position / count
            var vector = CGVector(p1: position, p2: self.position)
            vector = vector / vector.magnitude * 0.05
            return vector
        }

        return .zero
    }

    private func alignment(fishes: [Fish]) -> CGVector {
        var alignment = CGVector.zero

        for fish in fishes {
            if fish !== self {
                let distance = distance(position, fish.position)
                var vector = fish.velocity.normalized
                vector = vector / distance
                alignment = alignment + vector
            }
        }
        return alignment
    }

    private func separation(fishes: [Fish]) -> CGVector {
        var separation = CGVector.zero

        for fish in fishes {
            if fish !== self {
                let distance = distance(position, fish.position)
                if distance < separationRadius {
                    var vector = CGVector(p1: position, p2: fish.position).normalized
                    vector = vector / distance
                    separation = separation + vector
                }
            }
        }

        return separation
    }

    private func avoid(barriers: [Barrier]) -> CGVector {
        var separation = CGVector.zero

        for barrier in barriers {
            let distance = distance(position, barrier.position)
            if distance < separationRadius {
                var vector = CGVector(p1: position, p2: barrier.position).normalized
                vector = vector / distance
                separation = separation + vector
            }
        }

        return separation * 5
    }
}
