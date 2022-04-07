//
//  ContentView.swift
//  map
//
//  Created by calatinalper on 3.07.2021.
//

import SwiftUI
import MapKit

struct PlacesToVisit:Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}

struct GDMapView: View {
    @State private var region = MKCoordinateRegion(center:
        CLLocationCoordinate2D(latitude: 42.73245, longitude: 119.6595 ),
                                                   span: MKCoordinateSpan(latitudeDelta: 1.5, longitudeDelta: 1.5))
    
    /**
        经度 纬度
     118.955433  42.285436
      
     118.956806  42.275317

     119.6595 42.73245
     */
    let annotations = [
        PlacesToVisit(name: "a", coordinate: CLLocationCoordinate2D(latitude: 42.285436, longitude: 118.955433)),
        PlacesToVisit(name: "b", coordinate: CLLocationCoordinate2D(latitude: 42.275317, longitude: 118.956806)),
        PlacesToVisit(name: "c", coordinate: CLLocationCoordinate2D(latitude: 42.73245, longitude: 119.6595))
    ]
    
        
    var body: some View {
        Map(coordinateRegion: $region,annotationItems:annotations){
            MapPin(coordinate: $0.coordinate)
            
        }
            .edgesIgnoringSafeArea(.all)
    }
}

struct GDMapView_Previews: PreviewProvider {
    static var previews: some View {
        GDMapView()
    }
}



