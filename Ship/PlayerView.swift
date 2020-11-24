//
//  PlayerView.swift
//  livestreaming
//
//  Created by User23 on 2020/8/17.
//  Copyright © 2020 User23. All rights reserved.
//

import SwiftUI
import MobileVLCKit

struct PlayerView: UIViewRepresentable {
    var url = ""
    @EnvironmentObject var locationData: LocationData
    let mediaPlayer = VLCMediaPlayer()
    func makeUIView(context: Context) -> UIView {

        let controller = UIView()
        mediaPlayer.drawable = controller
        let uri = URL(string: self.url)
        let media = VLCMedia(url: uri!)
        mediaPlayer.media = media
        mediaPlayer.play()
        return controller
    }

    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<PlayerView>) {
        if(mediaPlayer.isPlaying){
            mediaPlayer.stop()
        }
        else{
            mediaPlayer.play()
        }
        
    }
}

