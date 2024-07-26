//
//  Extensions.swift
//  boids-visualization
//
//  Created by Никита Харсеко on 26/07/2024.
//

import SceneKit

extension CGVector {
    var magnitude: CGFloat {
        return sqrt(dx*dx + dy*dy)
    }

    var normalized: CGVector {
        let mag = magnitude
        return mag > 0 ? self / mag : .zero
    }

    static func +(lhs: CGVector, rhs: CGVector) -> CGVector {
        return CGVector(dx: lhs.dx + rhs.dx, dy: lhs.dy + rhs.dy)
    }

    static func -(lhs: CGVector, rhs: CGVector) -> CGVector {
        return CGVector(dx: lhs.dx - rhs.dx, dy: lhs.dy - rhs.dy)
    }

    static func /(lhs: CGVector, rhs: CGVector) -> CGVector {
        return CGVector(dx: lhs.dx / rhs.dx, dy: lhs.dy / rhs.dy)
    }



    static func +(lhs: CGVector, rhs: CGFloat) -> CGVector {
        return CGVector(dx: lhs.dx + rhs, dy: lhs.dy + rhs)
    }

    static func -(lhs: CGVector, rhs: CGFloat) -> CGVector {
        return CGVector(dx: lhs.dx - rhs, dy: lhs.dy - rhs)
    }

    static func /(lhs: CGVector, rhs: CGFloat) -> CGVector {
        return CGVector(dx: lhs.dx / rhs, dy: lhs.dy / rhs)
    }

    static func *(lhs: CGVector, rhs: CGFloat) -> CGVector {
        return CGVector(dx: lhs.dx * rhs, dy: lhs.dy * rhs)
    }


    init(p1: CGPoint, p2: CGPoint) {
        self.init(dx: p1.x - p2.x, dy: p1.y - p2.y)
    }
}

extension CGPoint {
    static func +(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }

    static func -(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }

    static func /(lhs: CGPoint, rhs: CGFloat) -> CGPoint {
        return CGPoint(x: lhs.x / rhs, y: lhs.y / rhs)
    }

    var magnitude: CGFloat {
        return sqrt(x*x + y*y)
    }

    var normalized: CGPoint {
        let mag = magnitude
        return mag > 0 ? self / mag : .zero
    }
}

func distance(_ p1: CGPoint, _ p2: CGPoint) -> CGFloat {
    return hypot(p1.x - p2.x, p1.y - p2.y)
}
