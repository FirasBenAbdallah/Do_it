//
//  ContentView.swift
//  doit
//
//  Created by FirasBenAbdallah on 13/4/2023.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @State private var searchText: String = ""
    @State private var coordinate: CLLocationCoordinate2D?
    
    var body: some View {
            TabView {
                Acceuil()
                    .tabItem(){
                            Image(systemName: "house")
                            Text("Home")
                    }
                    VStack {
                        TextField("Search", text: $searchText)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                            .padding(.horizontal)
                        MapView(searchText: $searchText, coordinate: $coordinate)
                            .edgesIgnoringSafeArea(.all)
                            .frame(height: 650)
                            .gesture(MagnificationGesture().onChanged { scale in
                                                let mapView = MKMapView()
                                                let delta = 1.0 - scale.magnitude
                                                let span = MKCoordinateSpan(latitudeDelta: mapView.region.span.latitudeDelta * delta, longitudeDelta: mapView.region.span.longitudeDelta * delta)
                                                let region = MKCoordinateRegion(center: mapView.region.center, span: span)
                                                mapView.setRegion(region, animated: true)
                                            })
                    }
                .tabItem(){
                        Image(systemName: "map.circle")
                        Text("Map")
                }
                    
                AddEvent()
                    .tabItem(){
                            Image(systemName: "plus")
                            Text("Add")
                    }
                /*ChatView()
                    .tabItem {
                        Image(systemName: "message")
                        Text("Chat")
                    }*/
                Profile()
                    .tabItem(){
                            Image(systemName: "person.circle")
                            Text("Profile")
                    }
            }
    }
    
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

