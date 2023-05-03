
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














/*import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    func makeUIView(context: Context) -> MKMapView {
        MKMapView(frame: .zero)
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        let coordinate = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        uiView.setRegion(region, animated: true)
    }
}

struct Map_preview: View {
    var body: some View {
        MapView()
    }
}


import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    @State private var searchCompleter = MKLocalSearchCompleter()
    @State private var searchResults = [MKLocalSearchCompletion]()

    @State private var searchQuery = ""

    var body: some View {
        VStack {
            TextField("Search", text: $searchQuery, onEditingChanged: { began in
                if began {
                    searchResults.removeAll()
                }
            }, onCommit: {
                searchCompleter.queryFragment = searchQuery
            })
            .textFieldStyle(RoundedBorderTextFieldStyle())
            
            // add the map view here
        }
    }

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        let worldRegion = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
            span: MKCoordinateSpan(latitudeDelta: 180, longitudeDelta: 360))
        mapView.setRegion(worldRegion, animated: false)
        return mapView
    }

    func updateUIView(_ view: MKMapView, context: Context) {
    }
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
    }

    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        // handle error
    }

    func search(for completion: MKLocalSearchCompletion) {
        let searchRequest = MKLocalSearch.Request(completion: completion)
        let search = MKLocalSearch(request: searchRequest)
        search.start { response, error in
            if let response = response {
                // display the search results on the map
                let mapItems = response.mapItems
                // add code to display the results on the map
            } else if let error = error {
                // handle error
            }
        }
    }

}

struct Map_preview: View {
    var body: some View {
        MapView()
            .edgesIgnoringSafeArea(.all)
    }
}

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    @Binding var searchText: String

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView(frame: UIScreen.main.bounds)
        mapView.showsUserLocation = true
        mapView.delegate = context.coordinator
        return mapView
    }

    func updateUIView(_ mapView: MKMapView, context: Context) {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = searchText

        let search = MKLocalSearch(request: searchRequest)
        search.start { (response, error) in
            guard let response = response else { return }
            let matchingItems = response.mapItems
            mapView.removeAnnotations(mapView.annotations)

            for item in matchingItems {
                let annotation = MKPointAnnotation()
                annotation.coordinate = item.placemark.coordinate
                annotation.title = item.name
                mapView.addAnnotation(annotation)
            }
        }
    }
    

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView

        init(_ parent: MapView) {
            self.parent = parent
        }

        func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
            let region = MKCoordinateRegion(center: userLocation.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
            mapView.setRegion(region, animated: true)
        }
    }
}
struct Map_preview: View {
    @State private var searchText: String = ""

       var body: some View {
           VStack {
               TextField("Search", text: $searchText)
                   .padding(.horizontal)

               MapView(searchText: $searchText)
           }
       }
   var body: some View {
        MapView()
            .edgesIgnoringSafeArea(.all)
    }
}*/
