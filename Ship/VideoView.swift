//
//  VideoView.swift
//  ShipApp
//
//  Created by User23 on 2020/8/18.
//  Copyright © 2020 User24. All rights reserved.
//

import SwiftUI

struct VideoView: View {
       let urls = [
            "rtmp://140.121.199.178:1935/liveR",
            "https://video-ssl.itunes.apple.com/itunes-assets/Video118/v4/e5/e4/9a/e5e49a1e-4c65-48b8-bd46-633daa976710/mzvf_2765762855115952106.640x458.h264lc.U.p.m4v",
            "rtmp://140.121.199.178:1935/liveR"
       ]
       @EnvironmentObject var locationData: LocationData
       @State private var urlString = "rtmp://140.121.199.178:1935/liveR"
       
       var body: some View {
           VStack {
            PlayerView(url: urlString)
                
           }
       }
}

