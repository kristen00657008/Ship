//
//  TabView.swift
//  ShipApp
//
//  Created by User24 on 2020/3/30.
//  Copyright © 2020 User24. All rights reserved.
//

import SwiftUI

struct AppView: View {
    
    @StateObject var locationData: LocationData
    var body: some View {
        TabView {
            ManualControl()
                .tabItem {
                    Text("手動控制")}
            
            GPS()
                .tabItem {
                    Text("導航")}
                
            VideoView()
                .tabItem {
                    Text("即時影像")}
        }.environmentObject(locationData)
            
    }
}


struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView()
    }
}
