import SwiftUI
import FirebaseFirestore
import Firebase
import MapKit

struct Pollution: Identifiable {
    var id = UUID()
    let coordinate: CLLocationCoordinate2D
}

extension View {
    
    @ViewBuilder func isHidden(_ hidden: Bool, remove: Bool = false) -> some View {
        if hidden {
            if !remove {
                self.hidden()
            }
        } else {
            self
        }
    }
}

struct PollutionList: View {
    
    @EnvironmentObject var locationData: LocationData
    @State private var showMap1 = false
    
    func fetchData() {
        let db = Firestore.firestore()
        db.collection("pollutions").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            
            self.locationData.pollutions = documents.map { queryDocumentSnapshot -> Pollution in
                let data = queryDocumentSnapshot.data()
                print(data)
                let latitude = Double(data["latitude"] as? String ?? "")
                let longitude = Double(data["longitude"] as? String ?? "")
                let PollutionCoordinate : Pollution = Pollution(coordinate: .init(latitude: latitude!, longitude: longitude!))
                
                return PollutionCoordinate
            }
        }
    }
    
    var body: some View {
        NavigationView{
            VStack{
                List(locationData.pollutions) { (pollution)  in
                    //NavigationLink(destination: ){
                    PollutionRow(pollution: pollution)
                    //}
                }
                .onAppear(perform: {
                    if(locationData.finish){
                        fetchData()
                    }
                })
                .isHidden(!locationData.finish)
                
                Button(action: {
                    self.showMap1 = true
                    print("show")
                }) {
                    Text("在地圖上檢視所有污染點")
                        .font(Font.system(size: 35))
                }
                .isHidden(!locationData.finish)
                
                Text("尚未完成巡航")
                    .font(Font.system(size: 50))
                    .isHidden(locationData.finish)
                NavigationLink(destination: PollutionMap(), isActive: self.$showMap1){}
                
            }
        }
    }///body
}


