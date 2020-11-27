//
//  GPS.swift
//  ShipApp
//
//  Created by User24 on 2020/3/31.
//  Copyright © 2020 User24. All rights reserved.
//

import SwiftUI
import MapKit
import Firebase
import FirebaseFirestore

struct GPS: View {
    
    @State var showMap = false
    @State var showNavigate = false
    @ObservedObject var locationData: LocationData
    @State private var showAlert: Bool = false
    @State private var showMapAlert: Bool = false    
    @State private var first: Bool = true
    func initFirebase(){
        FirebaseApp.configure()
    }
    func readData(){
        let db = Firestore.firestore()
        (db as AnyObject).collection("ship").document("gps").getDocument { (document, error) in
            if let document = document, document.exists {
                self.locationData.CurrentLatitude = String(describing: document.data()!["CurrentLatitude"]!)
                self.locationData.CurrentLongitude = String(describing: document.data()!["CurrentLongitude"]!)
                self.locationData.CurrentLocation = "（ \(self.locationData.CurrentLongitude) , \(self.locationData.CurrentLatitude) )"
                print(document.data()!["CurrentLatitude"]!)
                print("Current latitude:\(self.locationData.CurrentLatitude)"  )
                print("Current longitude:\(self.locationData.CurrentLongitude)"  )
            } else {
                print("Document does not exist")
            }
            
            let CurrentAnnotation = CurrentAnn(coordinate: CLLocationCoordinate2D(latitude: Double((self.locationData.CurrentLatitude as NSString).doubleValue), longitude: Double((self.locationData.CurrentLongitude as NSString).doubleValue)))
            
            CurrentAnnotation.title = "船目前位置"
            
            self.locationData.CurrentAnnotation = CurrentAnnotation
        }
    }
    
    func startNavigation() {
        let db = Firestore.firestore()
        self.locationData.shipState = "start"
        db.collection("ship").document("move").updateData(["State": self.locationData.shipState])
    }
    
    var body: some View {
        NavigationView{
            VStack{
                HStack{
                    VStack(alignment: .leading){
                        HStack{
                            Text("你的位置")
                            TextField("( , )" , text: $locationData.CurrentLocation)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(width: 230)
                                .disabled(true)
                            Button(action: {
                                if(first){
                                    initFirebase()
                                    first = false
                                }
                                self.readData()
                                locationData.canOpenMap = true
                            }) {
                                Image("refresh")
                                    .renderingMode(.original)
                                    .resizable()
                                    .frame(width: 30, height: 30)
                            }
                        }
                        HStack{
                            Text("目的地    ")
                            TextField("( , )" , text: $locationData.DestinationLocation)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(width: 230)
                                .disabled(true)
                        }
                    }
                    
                }.frame(width: 350)
                HStack(alignment: .center){
                    Text("選擇目的地: ")
                    Button(action: {
                        if(!self.locationData.canOpenMap){
                            self.showMapAlert = true
                        }
                        else{
                            self.showMap = true
                        }
                        
                    }) {
                        Image("map")
                            .renderingMode(.original)
                            .resizable()
                            .frame(width: 50, height: 50)
                    }
                    .alert(isPresented:self.$showMapAlert) {
                        Alert(title: Text("請先重新整理你的位置"), dismissButton: .default(Text("OK")))
                    }
                    .sheet(isPresented: $showMap){
                        AutoControl().environmentObject(self.locationData)
                    }
                    NavigationLink(destination: navigateView(), isActive: self.$showNavigate){
                        Button(action: {
                            if(!self.locationData.canStartNavigation){
                                self.showAlert = true
                            }
                            else{
                                print("開始導航")
                                startNavigation()
                                self.showNavigate = true
                            }
                            
                        }) {
                            Text("開始導航")
                        }
                        .alert(isPresented:self.$showAlert) {
                            Alert(title: Text("請先選擇目的地"), dismissButton: .default(Text("OK")))
                        }
                    }
                    
                }
                Spacer()
            }
        }
        
    }
}

