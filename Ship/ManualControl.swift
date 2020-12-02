//
//  ContentView.swift
//  ShipApp
//
//  Created by User24 on 2020/3/24.
//  Copyright © 2020 User24. All rights reserved.
//

import SwiftUI
import FirebaseFirestore


struct ManualControl: View {
    @EnvironmentObject var locationData: LocationData
    @State private var direction: String = "stop"
    @State private var speed: Int = 0
    @State private var angle: Int = 90
    let db: Any
    init(){
        //FirebaseApp.configure()
        db = Firestore.firestore()
    }
    
    func upDate(direction: String, speed: Int, angle: Int){
        
        (db as AnyObject).collection("ship").document("Go").setData([
            "direction": direction,
            "speed" : speed,
            "angle" : angle
         ]) { err in
             if let err = err {
                 print("Error writing document: \(err)")
             } else {
                 print("Document successfully written!")
             }
         }
    }
    
    var body: some View {
        VStack{
            VStack(alignment: .leading){
                Text("方向: \(direction)")
                    .font(Font.system(size: 40))
                    .foregroundColor(Color.red)
                Text("角度: \(angle)")
                    .font(Font.system(size: 40))
                    .foregroundColor(Color.red)
                HStack{
                    Stepper(value: self.$speed, in: 0...50, label: {
                        Text("時速:  \(self.speed)")
                            .font(Font.system(size: 40))
                            .foregroundColor(Color.red)
                        }).frame(width: 300)
                    Button(action:{
                        self.upDate(direction: self.direction , speed: self.speed , angle: self.angle)
                        }){
                            Text("更新")
                    }
                }
            }
            
                        
            HStack{
                Button(action:{
                    self.direction = "forward"
                    self.angle = 115
                    self.upDate(direction: self.direction , speed: self.speed , angle: self.angle)
                    print("direction: \(self.direction), speed: \(self.speed), angle: \(self.angle)")
                }) {
                    Image("direction")
                        .resizable()
                        .renderingMode(.original)
                        .frame(width: 100, height: 100)
                        .rotationEffect(Angle(degrees: 225))
                }.offset(x: 20, y: 20)
                
                Button(action:{
                    self.direction = "forward"
                    self.angle = 90
                    self.upDate(direction: self.direction , speed: self.speed , angle: self.angle)
                    print("direction: \(self.direction), speed: \(self.speed), angle: \(self.angle)")
                }) {
                    Image("direction")
                        .resizable()
                        .renderingMode(.original)
                        .frame(width: 100, height: 100)
                        .rotationEffect(Angle(degrees: 270))
                }
                
                Button(action:{
                    self.direction = "forward"
                    self.angle = 80
                    self.upDate(direction: self.direction , speed: self.speed , angle: self.angle)
                    print("direction: \(self.direction), speed: \(self.speed), angle: \(self.angle)")
                }) {
                    Image("direction")
                        .resizable()
                        .renderingMode(.original)
                        .frame(width: 100, height: 100)
                        .rotationEffect(Angle(degrees: 315))
                }.offset(x: -20, y: 20)
            }
            
            HStack{
                Button(action:{
                    self.direction = "forward"
                    self.angle = 140
                    self.upDate(direction: self.direction , speed: self.speed , angle: self.angle)
                    print("direction: \(self.direction), speed: \(self.speed), angle: \(self.angle)")
                }) {
                    Image("direction")
                        .resizable()
                        .renderingMode(.original)
                        .frame(width: 100, height: 100)
                        .rotationEffect(Angle(degrees: 180))
                }
                
                Button(action:{
                    self.direction = "stop"
                    self.speed = 0
                    self.angle = 90
                    self.upDate(direction: self.direction , speed: self.speed , angle: self.angle)
                    print("direction: \(self.direction), speed: \(self.speed), angle: \(self.angle)")
                }) {
                    Image("stop")
                        .resizable()
                        .renderingMode(.original)
                        .frame(width: 100, height: 100)
                }
                
                Button(action:{
                    self.direction = "forward"
                    self.angle = 70
                    self.upDate(direction: self.direction , speed: self.speed , angle: self.angle)
                    print("direction: \(self.direction), speed: \(self.speed), angle: \(self.angle)")
                }) {
                    Image("direction")
                        .resizable()
                        .renderingMode(.original)
                        .frame(width: 100, height: 100)
                }
            }.frame(width: 300)
            
            HStack{
                Button(action:{
                    self.direction = "back"
                    self.angle = 80
                    self.upDate(direction: self.direction , speed: self.speed , angle: self.angle)
                    
                    print("direction: \(self.direction), speed: \(self.speed), angle: \(self.angle)")
                }) {
                    Image("direction")
                        .resizable()
                        .renderingMode(.original)
                        .frame(width: 100, height: 100)
                        .rotationEffect(Angle(degrees: 135))
                }.offset(x: 20, y: -20)
                
                Button(action:{
                    self.direction = "back"
                    self.angle = 90
                    self.upDate(direction: self.direction , speed: self.speed , angle: self.angle)
                    print("direction: \(self.direction), speed: \(self.speed), angle: \(self.angle)")
                }) {
                    Image("direction")
                        .resizable()
                        .renderingMode(.original)
                        .frame(width: 100, height: 100)
                        .rotationEffect(Angle(degrees: 90))
                }
                
                Button(action:{
                    self.direction = "back"
                    self.angle = 115
                    self.upDate(direction: self.direction , speed: self.speed , angle: self.angle)
                    print("direction: \(self.direction), speed: \(self.speed), angle: \(self.angle)")
                }) {
                    Image("direction")
                        .resizable()
                        .renderingMode(.original)
                        .frame(width: 100, height: 100)
                        .rotationEffect(Angle(degrees: 45))
                }.offset(x: -20, y: -20)
            }
            
        }
       
    }
}

struct ManualControl_Previews: PreviewProvider {
    static var previews: some View {
        ManualControl()
    }
}


