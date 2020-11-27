//
//  PollutionRow.swift
//  Ship
//
//  Created by User10 on 2020/11/27.
//

import SwiftUI

struct PollutionRow: View {
    
    @EnvironmentObject var locationData: LocationData
    var pollution : Pollution
    var body: some View {
       HStack{
            Text("污染點")
            Spacer()
            VStack{
                Text("經度:\(pollution.coordinate.latitude)")                
                Text("緯度:\(pollution.coordinate.longitude)")
            }
        }
    }
}

