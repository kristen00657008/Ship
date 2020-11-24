//
//  Data.swift
//  ShipApp
//
//  Created by User24 on 2020/3/31.
//  Copyright © 2020 User24. All rights reserved.
//

import Foundation
import MapKit

class LocationData: ObservableObject{
    @Published var DestinationLatitude = ""
    @Published var DestinationLongitude = ""
    @Published var DestinationLocation = ""
    @Published var CurrentLatitude = ""
    @Published var CurrentLongitude = ""
    @Published var CurrentLocation = ""
    @Published var DestinationAnnotation = DestinationAnn(coordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0))
    @Published var CurrentAnnotation = CurrentAnn(coordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0))
    @Published var Annotations = [MKPointAnnotation]()
    @Published var centerCoordinate = CLLocationCoordinate2D()
    @Published var satilizeMode = false
    @Published var canStartNavigation = false
    
    @Published var playVideo = true
    @Published var shipState = "stop"
    @Published var canOpenMap = false
}

class DestinationAnn: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
}

class CurrentAnn: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
}
