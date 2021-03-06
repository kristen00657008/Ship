import SwiftUI
import MapKit

struct PollutionMap: View {
    @EnvironmentObject var locationData: LocationData
    @Environment(\.presentationMode) var presentationMode
    @State private var userTrackingMode: MapUserTrackingMode = .follow
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 25.41561, longitude: 121.65421),
        span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
    )
    
    var body: some View {
        ZStack{
            Map(coordinateRegion: $region, annotationItems: locationData.pollutions) { pollutions in
                MapPin(coordinate: pollutions.coordinate, tint: .green)
            }
            .edgesIgnoringSafeArea(.all)
            
        }
        
    }
}
