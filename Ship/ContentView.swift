//
//  ContentView.swift
//  Ship
//
//  Created by User19 on 2020/11/24.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var locationData = LocationData()
    var body: some View {
        TabView {
            /*ManualControl()
             .tabItem {
             Text("手動控制")}*/
            
            GPS(locationData: locationData)
                .tabItem {Text("導航")}
            /*testView()
                .tabItem {Text("test")}*/
            VideoView()
                .tabItem {Text("即時影像")}
            
            PollutionList()
                .tabItem {Text("污染點列表")}
        }.environmentObject(locationData)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
