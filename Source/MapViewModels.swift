//
//  MapViewModels.swift
//  ModeledDataSource
//
//  Created by Adam Debono on 11/04/2016.
//  Copyright © 2016 Adam Debono. All rights reserved.
//

import MapKit

public class MapAnnotation: NSObject, MKAnnotation {
	public var coordinate: CLLocationCoordinate2D
	
	public var title: String?
	public var subtitle: String?
	
	public init(coordinate: CLLocationCoordinate2D, title: String? = nil, subtitle: String? = nil) {
		self.coordinate = coordinate
		self.title = title
		self.subtitle = subtitle
	}
	
	public func createAnnotation(mapView mapView: MKMapView) -> MKAnnotationView {
		fatalError("Must be overridden in a subclass")
	}
	
	public func configureAnnotation(mapView mapView: MKMapView) -> MKAnnotationView {
		return self.createAnnotation(mapView: mapView)
	}
}

public class MapOverlay: NSObject, MKOverlay {
	public var coordinate: CLLocationCoordinate2D
	public var boundingMapRect: MKMapRect
	
	init(coordinate: CLLocationCoordinate2D, boundingMapRect: MKMapRect) {
		self.coordinate = coordinate
		self.boundingMapRect = boundingMapRect
	}
	
	public func configureRenderer(mapView mapView: MKMapView) -> MKOverlayRenderer {
		fatalError("Must be overridden in a subclass")
	}
}

// MARK: - Annotations

public class PinMapAnnotation: MapAnnotation {
	static private let reuseIdentifier = "pin"
	
	public override func createAnnotation(mapView mapView: MKMapView) -> MKAnnotationView {
		if let annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(PinMapAnnotation.reuseIdentifier) {
			annotationView.annotation = self
			return annotationView
		} else {
			return MKPinAnnotationView(annotation: self, reuseIdentifier: PinMapAnnotation.reuseIdentifier)
		}
	}
}

// MARK: - Overlays

public class PolygonMapOverlay: MapOverlay {
	
	public var polygon: MKPolygon
	
	public var fillColor: UIColor
	public var strokeColor: UIColor
	public var strokeWidth: CGFloat
	
	convenience public init(polygon: MKPolygon, color: UIColor, strokeWidth: CGFloat = 3) {
		self.init(polygon: polygon, fillColor: color.colorWithAlphaComponent(0.5), strokeColor: color, strokeWidth: strokeWidth)
	}
	
	public init(polygon: MKPolygon, fillColor: UIColor, strokeColor: UIColor, strokeWidth: CGFloat = 3) {
		self.polygon = polygon
		
		self.fillColor = fillColor
		self.strokeColor = strokeColor
		self.strokeWidth = strokeWidth
		
		super.init(coordinate: polygon.coordinate, boundingMapRect: polygon.boundingMapRect)
	}
	
	public override func configureRenderer(mapView mapView: MKMapView) -> MKOverlayRenderer {
		let renderer = MKPolygonRenderer(polygon: self.polygon)
		
		renderer.fillColor = self.fillColor
		renderer.strokeColor = self.strokeColor
		renderer.lineWidth = self.strokeWidth
		
		return renderer
	}
}