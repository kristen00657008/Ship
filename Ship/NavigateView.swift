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
        let CurrentAnnotation = MyAnnotationItem(coordinate: CLLocationCoordinate2D(latitude: Double((self.locationData.CurrentLatitude as NSString).doubleValue), longitude: Double((self.locationData.CurrentLongitude as NSString).doubleValue)),title:"船目前位置")
        
        self.locationData.CurrentAnnotation = CurrentAnnotation
        self.locationData.annotationItems[0] = self.locationData.CurrentAnnotation
    }
    
    func multiThread() {
        Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { timer in
            self.readData()
            if isThread == false{
                timer.invalidate()
            }
        }
    }
    
    private func setRegion(){
        self.locationData.region = MKCoordinateRegion(center: CLLocationCoordinate2D(
                                                        latitude: Double((self.locationData.CurrentLatitude as NSString).doubleValue), longitude: Double((self.locationData.CurrentLongitude as NSString).doubleValue)),
                                                      latitudinalMeters: 1000, longitudinalMeters: 1000 )
    }
    
    var body: some View {
        ZStack{
            Map(coordinateRegion: self.$locationData.region, annotationItems: self.locationData.annotationItems) { annotationItem in
                MapAnnotation(coordinate: annotationItem.coordinate) {
                    VStack {
                        Group {
                            Image(systemName: "mappin.circle.fill")
                                .resizable()
                                .frame(width: 30.0, height: 30.0)
                            Circle()
                                .frame(width: 8.0, height: 8.0)
                        }
                        .foregroundColor(.red)
                        Text(annotationItem.title!)
                    }
                }
            }
            .edgesIgnoringSafeArea(.all)
            .onAppear {
                self.setRegion()
                print(self.locationData.annotationItems)
            }
            
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
                            self.locationData.finish = true
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
