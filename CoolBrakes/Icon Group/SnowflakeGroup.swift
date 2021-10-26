//
//  SnowflakeGroup.swift
//  CoolBrakes
//
//  Created by James Ford on 10/27/21.
//

import SwiftUI

struct SnowflakeGroup: View {
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let width = min(geometry.size.width, geometry.size.height)
                let height = width * 1.5
                let middle = width * 0.5
                let spacing = width * 0.030
                let topWidth = width * 0.226
                let topHeight = height * 0.488
                let thickness = width / 16
                let sqrt2 = 1.414
                
                path.addLines([
                    CGPoint(x: middle, y: spacing),
                    CGPoint(x: middle + thickness, y: spacing),
                    CGPoint(x: middle + thickness, y: topHeight / 2 + spacing),
                    CGPoint(x: middle + thickness + width * 0.25, y: spacing * 5),
                    CGPoint(x: {middle + thickness + width * 0.25 + thickness * sqrt2}, y: spacing * 5),
                    CGPoint(x: middle - topWidth , y: topHeight - spacing)

                ])
            }
        }
    }
}

struct SnowflakeGroup_Previews: PreviewProvider {
    static var previews: some View {
        SnowflakeGroup()
    }
}
