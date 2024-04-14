//
//  MapViewController.swift
//  Rup_Chandra_Khatri_FE_8964748
//
//  Created by user237233 on 4/13/24.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var zoomSlider: UISlider!
    
    var locationManager: CLLocationManager!
    var cityLocation: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        setupLocationManager()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Location Manager
        
        func setupLocationManager() {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
        
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let location = locations.last else { return }
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
            mapView.setRegion(region, animated: true)
            locationManager.stopUpdatingLocation()
            
            // Add pin for start point
            let startPin = MKPointAnnotation()
            startPin.coordinate = center
            startPin.title = "Start Point"
            mapView.addAnnotation(startPin)
        }
        
        // MARK: - Add End Point Pin
        
        func addEndPointPin() {
            guard let cityLocation = cityLocation else { return }
            let endPin = MKPointAnnotation()
            endPin.coordinate = cityLocation
            endPin.title = "End Point"
            mapView.addAnnotation(endPin)
            
            // Add polyline between start and end points
            addPolyline()
        }
        
        // MARK: - Add Polyline
        
        func addPolyline() {
            guard let startCoordinate = locationManager.location?.coordinate, let endCoordinate = cityLocation else { return }
            
            let startPlacemark = MKPlacemark(coordinate: startCoordinate)
            let endPlacemark = MKPlacemark(coordinate: endCoordinate)
            
            let directionRequest = MKDirections.Request()
            directionRequest.source = MKMapItem(placemark: startPlacemark)
            directionRequest.destination = MKMapItem(placemark: endPlacemark)
            directionRequest.transportType = .automobile
            
            let directions = MKDirections(request: directionRequest)
            directions.calculate { (response, error) in
                guard let route = response?.routes.first else { return }
                self.mapView.addOverlay(route.polyline)
            }
        }
        
        // MARK: - MapView Delegate
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = .blue
            renderer.lineWidth = 4
            return renderer
        }
    
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        // Map zooms in as slider value increases, and zooms out as slider value decreases
           let currentValue = Double(sender.value)
        let delta = (Float(currentValue) - sender.minimumValue) / (sender.maximumValue - sender.minimumValue) // Calculate a value between 0 and 1 for interpolation
           let minDelta: Double = 0.005 // Minimum delta value to avoid excessive zooming
           let maxDelta: Double = 1.0 // Maximum delta value
        let interpolatedDelta = minDelta + (maxDelta - minDelta) * Double(delta) // Interpolate between min and max delta based on slider value
           let region = MKCoordinateRegion(center: mapView.region.center, span: MKCoordinateSpan(latitudeDelta: interpolatedDelta, longitudeDelta: interpolatedDelta))
           mapView.setRegion(region, animated: true)
    }
    
        
    @IBAction func carButtonTapped(_ sender: Any) {
        calculateRoute(with: .walking)
    }
    
    @IBAction func bicycleButtonTapped(_ sender: Any) {
        calculateRoute(with: .automobile)
    }
    
    
    @IBAction func walkingButtonTapped(_ sender: Any) {
        calculateRoute(with: .walking)
    }
    
    func calculateRoute(with transportType: MKDirectionsTransportType) {
        guard let startCoordinate = locationManager.location?.coordinate, let endCoordinate = cityLocation else { return }
        
        let startPlacemark = MKPlacemark(coordinate: startCoordinate)
        let endPlacemark = MKPlacemark(coordinate: endCoordinate)
        
        let directionRequest = MKDirections.Request()
        directionRequest.source = MKMapItem(placemark: startPlacemark)
        directionRequest.destination = MKMapItem(placemark: endPlacemark)
        directionRequest.transportType = transportType
        
        let directions = MKDirections(request: directionRequest)
        directions.calculate { [weak self] (response, error) in
            guard let self = self else { return }
            if let error = error {
                print("Error calculating route: \(error.localizedDescription)")
                return
            }
            
            guard let route = response?.routes.first else {
                print("No routes found")
                return
            }
            
            print("Route calculated successfully")
            
            // Remove previous route overlays (excluding start and end points)
            let routeOverlays = self.mapView.overlays.filter { !($0 is MKPointAnnotation) }
            self.mapView.removeOverlays(routeOverlays)
            
            // Add new polyline for the selected transport type
            self.mapView.addOverlay(route.polyline)
        }
    }
    
    
    @IBAction func changeCityButtonTapped(_ sender: Any) {
        showCityInputAlert()
    }
    
      // MARK: - Alert Controller
      
      func showCityInputAlert() {
          let alertController = UIAlertController(title: "Enter City Name", message: nil, preferredStyle: .alert)
          
          alertController.addTextField { textField in
              textField.placeholder = "City Name"
          }
          
          let confirmAction = UIAlertAction(title: "OK", style: .default) { _ in
              if let cityName = alertController.textFields?.first?.text {
                  // Geocode city name to get coordinates
                  self.geocodeCity(cityName)
              }
          }
          alertController.addAction(confirmAction)
          
          let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
          alertController.addAction(cancelAction)
          
          present(alertController, animated: true, completion: nil)
      }
      
      // MARK: - Geocode City Name
      
      func geocodeCity(_ cityName: String) {
          let geocoder = CLGeocoder()
              geocoder.geocodeAddressString(cityName) { [weak self] (placemarks, error) in
                  guard let self = self else { return }
                  
                  if let error = error {
                      print("Geocoding error: \(error.localizedDescription)")
                      return
                  }
                  
                  
                              
                  // Remove previous endpoint pin and polyline
                  self.mapView.removeAnnotations(self.mapView.annotations.filter { $0.title == "End Point" })
                  self.mapView.removeOverlays(self.mapView.overlays)
                  
                  if let placemark = placemarks?.first {
                      let cityLocation = placemark.location?.coordinate
                      self.cityLocation = cityLocation
                      self.addEndPointPin()
                      self.addPolyline()
                  }
              }
          }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
