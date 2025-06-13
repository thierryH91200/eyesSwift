//
//  EyesView.swift
//  eyesSwift
//
//  Created by Thierry hentic on 13/03/2025.
//


import Cocoa

class EyesView: NSView {
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        let background = NSColor.white
        let colorEye = NSColor.blue
        let pupille = NSColor.black

        let screen = self.bounds
        
        if dirtyRect.intersects(screen) {
            NSColor.clear.set()
            screen.fill()
        }
        
        let mouseLocation = NSEvent.mouseLocation
        let myPoint = convert(window?.convertPoint(fromScreen: mouseLocation) ?? .zero, from: nil)
        
        let lRect1 = NSRect(x: screen.origin.x, y: screen.origin.y, width: screen.width / 2.1, height: screen.height)
        let lRect2 = lRect1.insetBy(dx: lRect1.width * 0.1, dy: lRect1.height * 0.1)
        var lRect3 = NSRect(x: lRect1.origin.x + lRect1.width * 0.3,
                            y: lRect1.origin.y + lRect1.height * 0.3,
                            width: lRect1.width * 0.18, height: lRect1.height * 0.18)
        
        let rRect1 = NSRect(x: screen.width - screen.width / 2.1, y: screen.origin.y,
                            width: screen.width / 2.1, height: screen.height)
        let rRect2 = rRect1.insetBy(dx: rRect1.width * 0.1, dy: rRect1.height * 0.1)
        var rRect3 = NSRect(x: rRect1.origin.x + rRect1.width * 0.3,
                            y: rRect1.origin.y + rRect1.height * 0.3,
                            width: rRect1.width * 0.18, height: rRect1.height * 0.18)
        
        let lPupilRect = lRect1.insetBy(dx: lRect1.width * 0.3, dy: lRect1.height * 0.3)
        let rPupilRect = rRect1.insetBy(dx: rRect1.width * 0.3, dy: rRect1.height * 0.3)
        
        pupille.set()
        if dirtyRect.intersects(lRect1) {
            NSBezierPath(ovalIn: lRect1).fill()
        }
        if dirtyRect.intersects(rRect1) {
            NSBezierPath(ovalIn: rRect1).fill()
        }
        
        background.set()
        NSBezierPath(ovalIn: lRect2).fill()
        NSBezierPath(ovalIn: rRect2).fill()
        
        let lPupilPath = NSBezierPath(ovalIn: lPupilRect)
        let rPupilPath = NSBezierPath(ovalIn: rPupilRect)
        
        if lPupilPath.contains(myPoint) {
            lRect3.origin = NSPoint(x: myPoint.x - lRect3.width / 2.0,
                                    y: myPoint.y - lRect3.height / 2.0)
        } else {
            let point = getOvalPoint(rect: lPupilRect, mousePoint: myPoint)
            lRect3.origin = NSPoint(x: point.x - lRect3.width / 2.0,
                                    y: point.y - lRect3.height / 2.0)
        }
        
        if rPupilPath.contains(myPoint) {
            rRect3.origin = NSPoint(x: myPoint.x - rRect3.width / 2.0,
                                    y: myPoint.y - rRect3.height / 2.0)
        } else {
            let point = getOvalPoint(rect: rPupilRect, mousePoint: myPoint)
            rRect3.origin = NSPoint(x: point.x - rRect3.width / 2.0,
                                    y: point.y - rRect3.height / 2.0)
        }
        
        colorEye.set()
        NSBezierPath(ovalIn: lRect3).fill()
        NSBezierPath(ovalIn: rRect3).fill()
    }
    
    func getOvalPoint(rect: CGRect, mousePoint: NSPoint) -> NSPoint {
        let r1 = rect.width / 2.0
        let r2 = rect.height / 2.0
        let cX = rect.origin.x + r1
        let cY = rect.origin.y + r2
        let a = max(r1, r2)
        let b = min(r1, r2)
        var x: CGFloat = 0
        var y: CGFloat = 0
        
        if mousePoint.x != cX {
            let tanA = (mousePoint.y - cY) / (mousePoint.x - cX)
            if rect.width > rect.height {
                x = sqrt(pow(a, 2) * pow(b, 2) / (pow(b, 2) + pow(tanA, 2) * pow(a, 2)))
            } else {
                x = sqrt(pow(a, 2) * pow(b, 2) / (pow(a, 2) + pow(tanA, 2) * pow(b, 2)))
            }
            if mousePoint.x - cX < 0 {
                x = -x
            }
            y = tanA * x
        } else {
            y = (mousePoint.y - cY > 0) ? r2 : -r2
        }
        
        return NSPoint(x: x + cX, y: y + cY)
    }
}
