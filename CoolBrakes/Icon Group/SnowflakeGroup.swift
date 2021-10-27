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
            
            ZStack{
            let width = min(geometry.size.width, geometry.size.height)
            let height = width
            
                
            Circle()
                .fill(Color.black)
                .frame(width: width * 0.9, height: height, alignment: .center)
                
            Circle()
                .fill(Color.white)
                .frame(width: width * 0.6, height: height, alignment: .center)

            Image(systemName: "snow")
                .font(.system(size: height * 0.9))
                .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
            }
        }
    }
}

struct SnowflakeGroup_Previews: PreviewProvider {
    static var previews: some View {
        SnowflakeGroup()
    }
}
