//  Created by Alexander Skorulis on 7/2/2023.

import Foundation
import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    @State var region: MKCoordinateRegion
    @Binding var homeLocation: CLLocationCoordinate2D?

    static let defaultRadius: CLLocationAccuracy = 50
    
    init(homeLocation: Binding<CLLocationCoordinate2D?>) {
        _homeLocation = homeLocation
        if let loc = homeLocation.wrappedValue {
            region = .init(center: loc, span: .init(latitudeDelta: 0.005, longitudeDelta: 0.005))
        } else {
            region = .init(center: .init(), span: .init(latitudeDelta: 20, longitudeDelta: 20))
        }
    }

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        
        if let homeLocation {
            let circle = MKCircle(center: homeLocation, radius: Self.defaultRadius)
            mapView.addOverlay(circle)
            context.coordinator.currentOverlay = circle
            mapView.region = .init(center: homeLocation, span: .init(latitudeDelta: 0.05, longitudeDelta: 0.05))
        }
        mapView.region = region
        mapView.addGestureRecognizer(context.coordinator.gRecognizer!)

        return mapView
    }

    func updateUIView(_ view: MKMapView, context: Context) {
        if let existing = context.coordinator.currentOverlay {
            view.removeOverlay(existing)
        }
        
        if let loc = homeLocation {
            let circle = MKCircle(center: loc, radius: Self.defaultRadius)
            view.addOverlay(circle, level: .aboveLabels)
            context.coordinator.currentOverlay = circle
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    class Coordinator: NSObject, MKMapViewDelegate, UIGestureRecognizerDelegate {
        var parent: MapView

        var gRecognizer: UITapGestureRecognizer?
        var currentOverlay: MKCircle?

        init(_ parent: MapView) {
            self.parent = parent
            super.init()
            self.gRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapHandler))
            self.gRecognizer?.delegate = self
        }

        @objc func tapHandler(_ gesture: UITapGestureRecognizer) {
            // position on the screen, CGPoint
            guard let view = gesture.view, let mapView = view as? MKMapView else { return }
            let location = gesture.location(in: mapView)
            // position on the map, CLLocationCoordinate2D
            let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
            DispatchQueue.main.async {
                self.parent.homeLocation = coordinate
            }
        }
        
        func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
            DispatchQueue.main.async {
                self.parent.region = mapView.region
            }
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if overlay is MKCircle {
                let circle = MKCircleRenderer(overlay: overlay)
                circle.strokeColor = UIColor.red
                circle.fillColor = UIColor(red: 255, green: 0, blue: 0, alpha: 0.1)
                circle.lineWidth = 1
                return circle
            } else {
                return MKPolylineRenderer()
            }
        }
        
    }
}

