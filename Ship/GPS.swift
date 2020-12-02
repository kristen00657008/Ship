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
        return
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
            
            self.locationData.CurrentAnnotation = MyAnnotationItem(coordinate: CLLocationCoordinate2D(latitude: Double((self.locationData.CurrentLatitude as NSString).doubleValue), longitude: Double((self.locationData.CurrentLongitude as NSString).doubleValue)),title:"船目前位置")
                        
            self.locationData.annotationItems.append(self.locationData.CurrentAnnotation)
        }
        print("777")
        return
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
                                print("end")
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
                    NavigationLink("", destination: NewMapView(), isActive: self.$showMap)
                    Button(action: {
                        print("123")
                        if(!self.locationData.canOpenMap){
                            print("4146")
                            self.showMapAlert = true
                        }
                        else{
                            print("561")
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
        }/*.sheet(isPresented: $showMap){
         NewMapView()
         //testView()
         //AutoControl()//.environmentObject(self.locationData)
         }*/
        
    }
}

