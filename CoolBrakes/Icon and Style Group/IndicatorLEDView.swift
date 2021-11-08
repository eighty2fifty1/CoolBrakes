//
//  IndicatorLEDView.swift
//  CoolBrakes
//
//  Created by James Ford on 11/8/21.
//

import SwiftUI

struct IndicatorLEDView: View {
    //sensor status 0: not connected, 1: normal operation, 2: timed out for unknown reason, 3: sleeping (commanded or inactivity)
    @State var sensorStatus: Int?
    var sensorColor: [Color] = [.sensorDisconnected, .sensorConnected, .sensorTimeOut, .sensorSleep]
    
    var body: some View {
        GeometryReader { geometry in
            let width = min(geometry.size.width, geometry.size.height)
            let height = width

            
            Circle()
                .fill(sensorColor[sensorStatus ?? 0])
                .frame(width: width * 0.3, height: height, alignment: .center)
        }
    }
}

struct IndicatorLEDView_Previews: PreviewProvider {
    static var previews: some View {
        IndicatorLEDView(sensorStatus: 1)
    }
}
