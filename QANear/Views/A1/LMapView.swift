//
//  MapView.swift
//  QANear
//
//  Created by zzr on 2021/11/26.
//

import SwiftUI
import MapKit

struct LMapView: UIViewRepresentable {
  var coordinate: CLLocationCoordinate2D
  
  func makeUIView(context: Context) -> MKMapView {
    MKMapView(frame: .zero)
  }
  
  func updateUIView(_ view: MKMapView, context: Context) {
    let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    let region = MKCoordinateRegion(center: coordinate, span: span)
    view.setRegion(region, animated: true)
    view.removeAnnotations(view.annotations)
    
    let annotation = MKPointAnnotation()
    annotation.coordinate = coordinate
    view.addAnnotation(annotation)
  }
}

struct LMapView_Previews: PreviewProvider {
    static var previews: some View {
        LMapView(coordinate: CLLocationCoordinate2DMake(35.682117, 139.774669))
    }
}
