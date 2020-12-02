//
//  MapView.swift
//  ShipApp
//
//  Created by User24 on 2020/3/31.
//  Copyright © 2020 User24. All rights reserved.
//

/*import Foundation
import SwiftUI
import MapKit
import Firebase
import UIKit
import FirebaseFirestore


struct MapView: UIViewRepresentable {
    @EnvironmentObject var locationData: LocationData
    
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
            
            let CurrentAnnotation = MyAnnotationItem(coordinate: CLLocationCoordinate2D(latitude: Double((self.locationData.CurrentLatitude as NSString).doubleValue), longitude: Double((self.locationData.CurrentLongitude as NSString).doubleValue)),title:"船目前位置")
            
            self.locationData.CurrentAnnotation = CurrentAnnotation
            
            self.locationData.CurrentAnnotation = CurrentAnnotation
        }
        
    }
    
    func makeUIView(context: UIViewRepresentableContext<MapView>) -> MKMapView {
        let mapView = MKMapView()
        let currentLocation = CLLocationCoordinate2D(latitude: Double((self.locationData.CurrentLatitude as NSString).doubleValue), longitude: Double((self.locationData.CurrentLongitude as NSString).doubleValue))
        mapView.region =  MKCoordinateRegion(center: currentLocation, latitudinalMeters: 500, longitudinalMeters: 500)
        mapView.delegate = context.coordinator
        self.readData()
        
        //mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotation(self.locationData.CurrentAnnotation)
        //mapView.addAnnotation(self.locationData.DestinationAnnotation)
        return mapView
    }
    
    func updateUIView(_ uiview: MKMapView, context: UIViewRepresentableContext<MapView>) {
        
       /* if(self.locationData.satilizeMode){
            uiview.mapType = .satellite
        }
        else{
            uiview.mapType = .standard
        }*/
        
    }
    
    class MapViewCoordinator: NSObject, MKMapViewDelegate {
        var parent: MapView
        
        init(_ control: MapView) {
            self.parent = control
        }
        
        /*func mapView(_ mapView: MKMapView, viewFor
            annotation: MKAnnotation) -> MKAnnotationView?{
            //Custom View for Annotation
            let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "customView")
            //annotationView.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
            //annotationView.canShowCallout = true
            //Your custom image icon
            
            //annotationView.image = UIImage(named: "ship")
            return annotationView
        }*/
        
        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
            parent.locationData.centerCoordinate = mapView.centerCoordinate
        }
    }
    
    func makeCoordinator() -> MapViewCoordinator{
        MapViewCoordinator(self)
    }
}



/*struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}*/
*/
