//
//  NewMapView.swift
//  Ship
//
//  Created by User19 on 2020/12/2.
//

import SwiftUI
import MapKit
import Firebase
import FirebaseFirestore

struct NewMapView: View {
    
    @EnvironmentObject var locationData: LocationData
    @Environment(\.presentationMode) var presentationMode
    @State private var showAlert = false
    private func setRegion(){
        self.locationData.region = MKCoordinateRegion(center: CLLocationCoordinate2D(
                                                        latitude: Double((self.locationData.CurrentLatitude as NSString).doubleValue), longitude: Double((self.locationData.CurrentLongitude as NSString).doubleValue)),
                                                      latitudinalMeters: 1000, longitudinalMeters: 1000 )
        /*self.locationData.annotationItems  = [
            MyAnnotationItem(coordinate: CLLocationCoordinate2D(latitude: Double((self.locationData.CurrentLatitude as NSString).doubleValue), longitude: Double((self.locationData.CurrentLongitude as NSString).doubleValue)),title:"船目前位置")
        ]*/
    }
    
    func updateData() {
        let db = Firestore.firestore()
        db.collection("ship").document("gps").updateData(["DestinationLatitude":  self.locationData.DestinationLatitude ,"DestinationLongitude": self.locationData.DestinationLongitude])
    }
    
   
    
    @ViewBuilder var body: some View {
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
                            
                            //self.locationData.DestinationLatitude = String("25.154710")
                            //self.locationData.DestinationLongitude = String("121.780206")
                            print(self.$locationData.region.center.latitude.wrappedValue)
                            print(self.$locationData.region.center.longitude.wrappedValue)
                            self.locationData.DestinationLatitude = String(String(self.$locationData.region.center.latitude.wrappedValue).prefix(8))
                            self.locationData.DestinationLongitude = String(String(self.$locationData.region.center.longitude.wrappedValue).prefix(9))
                            self.locationData.DestinationLocation = "（ \(self.locationData.DestinationLongitude) , \(self.locationData.DestinationLatitude) )"
                            self.locationData.DestinationAnnotation = MyAnnotationItem(coordinate: CLLocationCoordinate2D(latitude: Double((self.locationData.DestinationLatitude as NSString).doubleValue), longitude: Double((self.locationData.DestinationLongitude as NSString).doubleValue)),title:"目的地")
                            updateData()
                            if(self.locationData.firstAdd){
                                self.locationData.annotationItems.append(self.locationData.DestinationAnnotation)
                                self.locationData.firstAdd = false
                                print("first")
                            }
                            else{
                                self.locationData.annotationItems[1] = self.locationData.DestinationAnnotation
                                print("not first")
                            }
                            //self.presentationMode.wrappedValue.dismiss()
                            self.locationData.canStartNavigation = true
                        }))
                    }
                    
                }
            }
        }
        
        //.navigationBarItems(leading:Toggle("衛星模式", isOn: self.$locationData.satilizeMode))
        
        
        
    }
}

extension Map {
    func mapStyle(_ mapType: MKMapType) -> some View {
        MKMapView.appearance().mapType = .satellite
        return self
    }
}

