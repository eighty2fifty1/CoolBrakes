//
//  TruckIconView.swift
//  CoolBrakes
//
//  Created by James Ford on 12/7/21.
//

import SwiftUI

struct TruckIconView: View {
    let truckColor: Color
    let dually: Bool
    let quadCab: Bool
    let sunroof: Bool
    let gooseneck: Bool
    let trailerColor: Color
    var windowColor: Color {
        if truckColor == .black {
            return .blue
        }
        
        return .black
    }
    let truckWidth: CGFloat = 150
    let truckLength: CGFloat = 350
    let cornerX: CGFloat = 20
    let cornerY: CGFloat = 10
    
    var body: some View {
        ZStack{
            VStack {
                //hood
                RoundedRectangle(cornerRadius: 25.0)
                    .size(width: truckWidth, height: 60)
                    .position(CGPoint(x: cornerX + 10, y: cornerY))
                    .foregroundColor(truckColor)
                    .frame(width: 100, height: 25, alignment: .center)
                //body
                Rectangle()
                    .size(width: truckWidth, height: truckLength)
                    .position(x: cornerX + 10, y: cornerY + 30)
                    .foregroundColor(truckColor)
                    .frame(width: 100, height: 100, alignment: .center)
            }
            //driver front window
            Rectangle()
                .size(width: 15, height: 40)
                .position(x: cornerX + 15, y: cornerY + 130)
                .foregroundColor(windowColor)
                .frame(width: 100, height: 100, alignment: .center)
            
            //passenger front window
            Rectangle()
                .size(width: 15, height: 40)
                .position(x: cornerX + 140, y: cornerY + 130)
                .foregroundColor(windowColor)
                .frame(width: 100, height: 100, alignment: .center)
            
            //driver front window triangle
            GeometryReader { geometry in
                        Path { path in
                            path.addLines([
                                CGPoint(x: cornerX + 5, y: cornerY + 120),
                                CGPoint(x: cornerX + 5, y: cornerY + 80),
                                CGPoint(x: cornerX + 20, y: cornerY + 120),
                                CGPoint(x: cornerX + 5, y: cornerY + 120)
                            ])
                        }
                    }
            .position(x: 10, y: 10)
            .foregroundColor(windowColor)
            .frame(width: 100, height: 100, alignment: .center)
            
            //passenger front window triangle
            GeometryReader { geometry in
                        Path { path in
                            path.addLines([
                                CGPoint(x: cornerX + 5, y: cornerY + 120),
                                CGPoint(x: cornerX + 20, y: cornerY + 80),
                                CGPoint(x: cornerX + 20, y: cornerY + 120),
                                CGPoint(x: cornerX + 5, y: cornerY + 120)
                            ])
                        }
                    }
            .position(x: 135, y: 10)
            .foregroundColor(windowColor)
            .frame(width: 100, height: 100, alignment: .center)
            
            //windshield
            GeometryReader { geometry in
                        Path { path in
                            path.addLines([
                                CGPoint(x: cornerX + 10, y: cornerY + 80),
                                CGPoint(x: cornerX + 140, y: cornerY + 80),
                                CGPoint(x: cornerX + 125, y: cornerY + 120),
                                CGPoint(x: cornerX + 25, y: cornerY + 120),
                                CGPoint(x: cornerX + 10, y: cornerY + 80)
                            ])
                        }
                    }
            .position(x: 10, y: 10)
            .foregroundColor(windowColor)
            .frame(width: 100, height: 100, alignment: .center)
            
            if quadCab {
                //driver rear window
                Rectangle()
                    .size(width: 15, height: 40)
                    .position(x: cornerX + 15, y: cornerY + 185)
                    .foregroundColor(windowColor)
                    .frame(width: 100, height: 100, alignment: .center)
                
                //passenger rear window
                Rectangle()
                    .size(width: 15, height: 40)
                    .position(x: cornerX + 140, y: cornerY + 185)
                    .foregroundColor(windowColor)
                    .frame(width: 100, height: 100, alignment: .center)
                
                //short bed
                Rectangle()
                    .size(width: 130, height: 150)
                    .position(x: cornerX + 20, y: cornerY + 240)
                    .foregroundColor(.black)
                    .frame(width: 100, height: 100, alignment: .center)
                
                if sunroof {
                    //sunroof, only on quad cab
                    Rectangle()
                        .size(width: 80, height: 40)
                        .position(x: cornerX + 45, y: cornerY + 150)
                        .foregroundColor(.black)
                        .frame(width: 100, height: 100, alignment: .center)
                }
            }
            
            else {
                //long bed
                Rectangle()
                    .size(width: 130, height: 200)
                    .position(x: cornerX + 20, y: cornerY + 190)
                    .foregroundColor(.black)
                    .frame(width: 100, height: 100, alignment: .center)
            }
            
            if dually {
                //left fender flare
                GeometryReader { geometry in
                            Path { path in
                                path.addLines([
                                    CGPoint(x: cornerX, y: cornerY + 250),
                                    CGPoint(x: cornerX - 20, y: cornerY + 310),
                                    CGPoint(x: cornerX - 20, y: cornerY + 370),
                                    CGPoint(x: cornerX, y: cornerY + 390),
                                    CGPoint(x: cornerX, y: cornerY + 250)
                                ])
                            }
                        }
                .position(x: 10, y: 0)
                .foregroundColor(truckColor)
                .frame(width: 100, height: 100, alignment: .center)
                
                //right fender flare
                GeometryReader { geometry in
                            Path { path in
                                path.addLines([
                                    CGPoint(x: cornerX + 150, y: cornerY + 250),
                                    CGPoint(x: cornerX + 170, y: cornerY + 310),
                                    CGPoint(x: cornerX + 170, y: cornerY + 370),
                                    CGPoint(x: cornerX + 150, y: cornerY + 390),
                                    CGPoint(x: cornerX + 150, y: cornerY + 250)
                                ])
                            }
                        }
                .position(x: 10, y: 0)
                .foregroundColor(truckColor)
                .frame(width: 100, height: 100, alignment: .center)
            }
            if gooseneck {
                GeometryReader { geometry in
                            Path { path in
                                path.addLines([
                                    CGPoint(x: cornerX + 50, y: cornerY + 310),
                                    CGPoint(x: cornerX + 100, y: cornerY + 310),
                                    CGPoint(x: cornerX + 170, y: cornerY + 390),
                                    CGPoint(x: cornerX + 170, y: cornerY + 720),
                                    CGPoint(x: cornerX - 20, y: cornerY + 720),
                                    CGPoint(x: cornerX - 20, y: cornerY + 390),
                                    CGPoint(x: cornerX + 50, y: cornerY + 310)
                                ])
                            }
                        }
                .position(x: 10, y: 0)
                .foregroundColor(trailerColor)
                .frame(width: 100, height: 100, alignment: .center)
            }
            
            else {
                GeometryReader { geometry in
                            Path { path in
                                path.addLines([
                                    CGPoint(x: cornerX + 65, y: cornerY + 396),
                                    CGPoint(x: cornerX + 85, y: cornerY + 396),
                                    CGPoint(x: cornerX + 85, y: cornerY + 410),
                                    CGPoint(x: cornerX + 170, y: cornerY + 410),
                                    CGPoint(x: cornerX + 170, y: cornerY + 720),
                                    CGPoint(x: cornerX - 20, y: cornerY + 720),
                                    CGPoint(x: cornerX - 20, y: cornerY + 410),
                                    CGPoint(x: cornerX + 65, y: cornerY + 410),
                                    CGPoint(x: cornerX + 65, y: cornerY + 396)
                                ])
                            }
                        }
                .position(x: 10, y: 0)
                .foregroundColor(trailerColor)
                .frame(width: 100, height: 100, alignment: .center)
            }
        }
        .frame(width: 210, height: 700, alignment: .top)
    }
}

struct TruckIconView_Previews: PreviewProvider {
    static var previews: some View {
        TruckIconView(truckColor: .red, dually: true, quadCab: true, sunroof: true, gooseneck: true, trailerColor: .gray)
        
        TruckIconView(truckColor: .black, dually: true, quadCab: false, sunroof: true, gooseneck: false, trailerColor: .gray)
    }
}
