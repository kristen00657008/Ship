//
//  ShipApp.swift
//  Ship
//
//  Created by User19 on 2020/11/24.
//

import SwiftUI

@main
struct ShipApp: App {
    
    @StateObject var locationData = LocationData()
    var body: some Scene {
        WindowGroup {
            TabView {
                /*ManualControl()
                 .tabItem {
                 Text("手動控制")}*/
                 
                GPS(locationData: locationData)
                 .tabItem {
                 Text("導航")}
                 
                 /*VideoView()
                 .tabItem {
                 Text("即時影像")}*/
            }.environmentObject(locationData)
        }
    }
}
