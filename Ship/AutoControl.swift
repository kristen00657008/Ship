//
//  AutoControl.swift
//  ShipApp
//
//  Created by User24 on 2020/3/30.
//  Copyright © 2020 User24. All rights reserved.
//

import SwiftUI
import MapKit
import Firebase
import FirebaseFirestore

struct AutoControl: View {
    
    @State private var centerCoordinate = CLLocationCoordinate2D()
    @State private var showAlert = false
    @EnvironmentObject var locationData: LocationData
    @Environment(\.presentationMode) var presentationMode
    
    func updateDate() {
        let db = Firestore.firestore()
        db.collection("ship").document("gps").updateData(["DestinationLatitude":  self.locationData.DestinationLatitude ,"DestinationLongitude": self.locationData.DestinationLongitude])
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                MapView()
                    .edgesIgnoringSafeArea(.all)
                Circle()
                    .fill(Color.blue)
                    .opacity(0.3)
                    .frame(width: 32, height: 32)
                VStack {
                    Spacer()
                    HStack{
                        Spacer()
                        Button(action: {
                            self.showAlert = true
                        }) {
                            Image(systemName: "plus")
                        }
                        .padding()
                        .background(Color.black.opacity(0.75))
                        .foregroundColor(.white)
                        .font(.title)
                        .clipShape(Circle())
                        .padding(.trailing)
                        .alert(isPresented: $showAlert){ () -> Alert in
                            return Alert(title: Text("是否將此座標設為目的地"), message: Text(""), primaryButton: .default(Text("否"), action: {
                            }), secondaryButton: .default(Text("是"), action: {
                                
                                let CreateAnnotation = DestinationAnn(coordinate: self.locationData.centerCoordinate)
                                CreateAnnotation.title = "目的地"
                                self.locationData.DestinationAnnotation = CreateAnnotation
                                
                                self.locationData.DestinationLatitude = String(String(CreateAnnotation.coordinate.latitude).prefix(8))
                                self.locationData.DestinationLongitude = String(String(CreateAnnotation.coordinate.longitude).prefix(9))
                                self.locationData.DestinationLocation = "（ \(self.locationData.DestinationLongitude) , \(self.locationData.DestinationLatitude) )"
                                updateDate()
                                self.presentationMode.wrappedValue.dismiss()
                                self.locationData.canStartNavigation = true
                            }))
                        }
                        
                    }
                }
            }
            .navigationBarItems(leading:Toggle("衛星模式", isOn: self.$locationData.satilizeMode)
                                ,trailing: Button(action: {
                                    self.presentationMode.wrappedValue.dismiss()
                                }) {
                                    Image("close")
                                        .renderingMode(.original)
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                })
        }
        
    }
}




