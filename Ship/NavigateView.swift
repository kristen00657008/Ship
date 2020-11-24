//
//  navigateView.swift
//  ShipApp
//
//  Created by User18 on 2020/11/24.
//  Copyright © 2020 User24. All rights reserved.
//

import SwiftUI
import MapKit
import Firebase

struct navigateView: View {
    @EnvironmentObject var locationData: LocationData
    @State private var disableButton = false
    @State private var isThread = true
    @State private var showAlert = false
    @Environment(\.presentationMode) var presentationMode
    
    func readData(){
        let db = Firestore.firestore()
        
        db.collection("ship").document("gps").getDocument { (document, error) in
            if let document = document, document.exists {
                self.locationData.CurrentLatitude = String(describing: document.data()!["CurrentLatitude"]!)
                self.locationData.CurrentLongitude = String(describing: document.data()!["CurrentLongitude"]!)
                self.locationData.CurrentLocation = "（ \(self.locationData.CurrentLongitude) , \(self.locationData.CurrentLatitude) )"
                
            } else {
                print("Document does not exist")
            }
        }
        let CurrentAnnotation = CurrentAnn(coordinate: CLLocationCoordinate2D(latitude: Double((self.locationData.CurrentLatitude as NSString).doubleValue), longitude: Double((self.locationData.CurrentLongitude as NSString).doubleValue)))
        
        CurrentAnnotation.title = "船目前位置"
        
        
        self.locationData.CurrentAnnotation = CurrentAnnotation
        
    }
    
    func multiThread() {
        Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { timer in
            self.readData()
            if isThread == false{
                timer.invalidate()
            }
        }
    }
    
    var body: some View {
        ZStack{
            MapView()
                .edgesIgnoringSafeArea(.all)
            VStack{
                Spacer()
                HStack(){
                    Spacer()
                    Spacer()
                    Button(action: {
                        self.showAlert = true
                    }) {
                        Image("EndNavigation")
                            .renderingMode(.original)
                            .resizable()
                            .frame(width: 200, height: 130)
                    }
                    .alert(isPresented: $showAlert){ () -> Alert in
                        return Alert(title: Text("確定要結束導航？"), message: Text(""), primaryButton: .default(Text("否"), action: {
                        }), secondaryButton: .default(Text("是"), action: {
                            self.isThread = false
                            self.presentationMode.wrappedValue.dismiss()
                            self.locationData.canStartNavigation = false
                            self.locationData.DestinationLocation = ""
                        }))
                    }
                    Spacer()
                    Button(action: {
                        self.disableButton = true
                        self.multiThread()
                    }) {
                        Image("navigation")
                            .renderingMode(.original)
                            .resizable()
                            .frame(width: 35, height: 35)
                    }
                    .padding(10)
                    .disabled(disableButton)
                }
            }
        }
        .navigationBarItems(trailing:Toggle("衛星模式", isOn: self.$locationData.satilizeMode))
        
    }
}
