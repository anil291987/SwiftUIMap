//
//  Existing.swift
//  SwiftUIMap Example
//
//  Created by Morris Richman on 4/12/22.
//

import SwiftUI
import SwiftUIMap
import MapKit

struct Existing: View {
    @State var search = false
    @State var zoom = 0.2
    @State var address = "Seattle, Wa"
    @State var loc = CLLocationCoordinate2D(latitude: 47.6062, longitude: -122.3321)
    @State var points = [
        Annotations(title: "Seattle Town Hall",
                    subtitle: "Newly Remodeled",
                    address: "1119 8th Ave, Seattle, WA, 98101, United States",
                    glyphImage: .systemImage("building.columns"),
                    markerTintColor: .systemGray,
                    glyphTintColor: .white,
                    displayPriority: .required),
        Annotations(title: "Space Needle",
                    subtitle: "",
                    address: "400 Broad St Seattle, WA 98109, United States",
                    glyphImage: .systemImage("star.fill"),
                    markerTintColor: .systemPurple,
                    glyphTintColor: .white,
                    displayPriority: .required),
        Annotations(title: "Pike Place Market",
                    subtitle: "",
                    address: "85 Pike St Seattle, WA  98101, United States",
                    glyphImage: .systemImage("cart"),
                    markerTintColor: .systemOrange,
                    glyphTintColor: .white,
                    displayPriority: .required)
    ]
    var body: some View {
        AnnotationMapView(zoom: $zoom, address: $address, points: points) { Title, Subtitle, Address, Cluster  in
            print("tapped \(Title), with subtitle: \(Subtitle), address: \(Address), and cluster: \(Cluster)")
        } deselected: {
            print("deselected annotation")
        } advancedModifiers: {
            let modifiers = MKMapView(frame: .zero)
            modifiers.isPitchEnabled = true
            return modifiers
        }
        .pointsOfInterest(.excludingAll)
        .showCompass(false)
        .showScale(false)
        .showTraffic(false)
        .showBuildings(true)
        .mapType(.standard)
        .camera(MKMapCamera(lookingAtCenter: loc, fromDistance: .pi, pitch: 4, heading: .pi))
        .cameraBoundary(MKMapView.CameraBoundary(coordinateRegion: MKCoordinateRegion(center: loc, span: MKCoordinateSpan(latitudeDelta: 4, longitudeDelta: 4))))
        .cameraZoomRange(MKMapView.CameraZoomRange()
        .overlay(alignment: .topTrailing, content: {
            HStack {
                Button(action: {search = true}) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.primary)
                }
                .padding(2)
                Button(action: {
                    points.append(Annotations(title: "The Northwest School", subtitle: "An Arts School", address: "1415 Summit Ave Seattle, WA, 98122, United States", glyphImage: .systemImage("studentdesk")))
                }) {
                    Image(systemName: "plus")
                        .foregroundColor(.primary)
                }
                .padding(2)
            }
            .background(.white)
            .cornerRadius(10)
            .opacity(0.8)
            .padding()
        })
        .sheet(isPresented: $search) {
            MapSearchView { address in
                zoom = 0.2
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(650), execute: {
                    self.address = address
                })
            }
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct Existing_Previews: PreviewProvider {
    static var previews: some View {
        Existing()
    }
}
