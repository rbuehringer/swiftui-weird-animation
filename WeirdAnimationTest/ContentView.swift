//
//  ContentView.swift
//  WeirdAnimationTest
//
//  Created by Bühringer, Raphael on 19.02.20.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        self.createView()
    }
    
    /**
     Create View with three animated layers.
     */
    private func createView() -> some View {
        return Group {
            ZStack {
                WeirdAnimation(30, .red, 0.3, 0.0)
                WeirdAnimation(30, .green, 0.3, 20.0)
                WeirdAnimation(30, .blue, 0.3, 40.0)
            }
        }
    }
}

struct WeirdAnimation: View {
    // This var is for the rotation animation.
    @State private var rotationEffect: Double = 0.0
    
    // Number of elements to be generated.
    private let customElements: Int
    // ColorEnum tells what color should be used.
    private let colorEnum: ColorEnum?
    // Shape opacity.
    private let opacity: CGFloat
    // Rotation offset for the whole view.
    private let rotationOffset: Double
    
    public init(_ customElements: Int = 10, _ colorEnum: ColorEnum? = nil, _ opacity: CGFloat = 1.0, _ rotationOffset: Double = 0.0) {
        self.customElements = customElements
        self.colorEnum = colorEnum
        self.opacity = opacity
        self.rotationOffset = rotationOffset
    }
    
    /**
     Create view with roattion effect and start playing animation on view appeared.
     */
    var body: some View {
        self.createView()
            .rotationEffect(Angle(degrees: self.rotationOffset))
            .onAppear() {
                withAnimation(Animation.linear.speed(0.00075)) {
                    self.rotationEffect = 360.0
                }
        }
    }
    
    /**
     Create individual custom shapes. Loop through customElements amount.
     */
    private func createView() -> some View {
        return Group {
            ZStack {
                ForEach(0..<self.customElements) { index in
                    self.createElement(index)
                }
            }
        }
    }
    
    /**
     Create custom shape element.
     Here you can change the color behaviour and the style of each custom shape element.
     */
    private func createElement(_ index: Int) -> some View {
        let color: UIColor = self.colorEnum == nil ? UIColor.customColor(CGFloat.random(), CGFloat.random(), CGFloat.random(), self.opacity) : UIColor.customColor(self.colorEnum!, self.opacity)
        
        return Group {
            CustomShape()
                .fill(Color(color))
                .frame(width: 50, height: 150)
                .rotationEffect(Angle(degrees: Double(index) * (360 / Double(self.customElements))) * self.rotationEffect)
        }
    }
}

/**
 Custom Shape definition.
 */
struct CustomShape: Shape {
    func path(in rect: CGRect) -> Path {
        var linePath = Path()
        var arcPath: Path = Path()
        // Draw a triangle
        linePath.move(to: CGPoint(x: rect.midX, y: rect.midY)) // Top of the triangle.
        linePath.addLine(to: CGPoint(x: rect.midX + rect.width, y: rect.midY + rect.height)) // Right side of the triangle.
        linePath.addLine(to: CGPoint(x: rect.midX - rect.width, y: rect.midY + rect.height)) // Left side of the triangle.
        
        // Draw semicircle.
        arcPath.addArc(center: CGPoint(x: rect.midX, y: rect.midY + rect.height), radius: rect.width, startAngle: Angle(degrees: 0.0), endAngle: Angle(degrees: 180.0), clockwise: false)
        
        // Add semicircle to triangle.
        linePath.addLine(to: CGPoint(x: rect.midX, y: rect.midY))
        linePath.addPath(arcPath)
        return linePath
    }
}

/**
 Different color helper for testing this animation.
 */
extension UIColor {
    static func customColor(_ red: CGFloat = 0.0, _ green: CGFloat = 0.0, _ blue: CGFloat = 0.0, _ alpha: CGFloat = 1.0) -> UIColor {
        return UIColor(red: red,
                       green: green,
                       blue:  blue,
                       alpha: alpha)
    }
    
    static func customColor(_ colorEnum: ColorEnum, _ alpha: CGFloat = 1.0) -> UIColor {
        return UIColor(red:  colorEnum == .red ? 1.0 : 0.0,
                       green: colorEnum == .green ? 1.0 : 0.0,
                       blue:  colorEnum == .blue ? 1.0 : 0.0,
                       alpha: alpha)
    }
    
    static func customColor(_ index: Int, _ modulus: Int, _ alpha: CGFloat = 1.0) -> UIColor {
        let res: Int = index % modulus
        let gradient: ColorEnum = res == 0 ? .red : res == 1 ? .green : .blue
        return UIColor.customColor(gradient)
    }
}

/**
 Random CGFloat generator between 0 and 1.
 */
extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

/**
 Custom color enum.
 */
enum ColorEnum {
    case red
    case green
    case blue
}
