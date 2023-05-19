import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    @Binding var searchText: String
    @Binding var coordinate: CLLocationCoordinate2D?
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        return mapView
    }
    
    func updateUIView(_ mapView: MKMapView, context: Context) {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = searchText
        
        let search = MKLocalSearch(request: searchRequest)
        search.start(completionHandler: {(response, error) in
            guard let response = response,
                  let firstResult = response.mapItems.first else {
                print("Error: \(error?.localizedDescription ?? "Unknown error").")
                return
            }
            
            let matchingItems = response.mapItems
            guard !matchingItems.isEmpty else {
                print("No matches found")
                return
            }
            
            let firstMatch = matchingItems[0]
            let region = MKCoordinateRegion(center: firstMatch.placemark.coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
            mapView.setRegion(region, animated: true)
            coordinate = firstMatch.placemark.coordinate
            mapView.addAnnotation(firstResult.placemark)
        })
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView
        
        init(_ parent: MapView) {
            self.parent = parent
        }
        
        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
            parent.coordinate = mapView.centerCoordinate
        }
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
                    let identifier = "Placemark"
                    var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
                    if annotationView == nil {
                        annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                        annotationView?.canShowCallout = true
                    } else {
                        annotationView?.annotation = annotation
                    }
                    return annotationView
                }
    }
}

struct Map_preview: View {
    @Binding var searchText: String
    @Binding var coordinate: CLLocationCoordinate2D?
    var body: some View {
        MapView(searchText: $searchText, coordinate: $coordinate)
            .edgesIgnoringSafeArea(.all)
    }
}


