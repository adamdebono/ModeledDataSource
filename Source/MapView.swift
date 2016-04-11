//
//  MapView.swift
//  ModeledDataSource
//
//  Created by Adam Debono on 11/04/2016.
//  Copyright © 2016 Adam Debono. All rights reserved.
//

import MapKit

public class MapViewDelegate: NSObject, MKMapViewDelegate {
	public func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
		guard let annotation = annotation as? MapAnnotation else {
			fatalError("MKAnnotation should be of type MapAnnotation")
		}
		
		return annotation.configureAnnotation(mapView: mapView)
	}
	
	public func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
		guard let overlay = overlay as? MapOverlay else {
			fatalError("MKOverlay should be of type MapOverlay")
		}
		
		return overlay.configureRenderer(mapView: mapView)
	}
}