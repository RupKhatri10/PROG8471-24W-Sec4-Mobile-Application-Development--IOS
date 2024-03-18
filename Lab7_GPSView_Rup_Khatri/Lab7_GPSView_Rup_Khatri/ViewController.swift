//
//  ViewController.swift
//  Lab7_GPSView_Rup_Khatri
//
//  Created by user237233 on 3/17/24.
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    
    @IBOutlet weak var startTrip: UIButton!
    @IBOutlet weak var stopTrip: UIButton!
    
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var maxSpeedLabel: UILabel!
    @IBOutlet weak var averageSpeedLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var accelerationLabel: UILabel!
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var bottomView: UIView!
    
    let locationManager: CLLocationManager = CLLocationManager()
    var tripStartDate: Date?
    var PreviousSpeed: CLLocationSpeed = 0
    var MaxSpeed: CLLocationSpeed = 0
    var TotalSpeed: CLLocationSpeed = 0
    var tripDistance: CLLocationDistance = 0
    var MaxAcceleration: Double = 0
    var previousLocation: CLLocation?
    let recentSpeed: CLLocationSpeed = 115 / 3.6
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
    }
    
    @IBAction func startTrip(_ sender: Any) {
        tripStartDate = Date()
        locationManager.startUpdatingLocation()
        bottomView.backgroundColor = .green
        mapView.showsUserLocation = true
        resetTripValues()
        
    }
    
    @IBAction func stopTrip(_ sender: Any) {
        locationManager.stopUpdatingLocation()
        topView.backgroundColor = UIColor.lightGray
        bottomView.backgroundColor = .gray
        resetTripValues()
        mapView.showsUserLocation = false
    }
    
    func resetTripValues() {
        tripStartDate = nil
        PreviousSpeed = 0
        MaxSpeed = 0
        TotalSpeed = 0
        tripDistance = 0
        MaxAcceleration = 0
        previousLocation = nil
        
        speedLabel.text = "0 km/h"
        maxSpeedLabel.text = "0 km/h"
        averageSpeedLabel.text = "0 km/h"
        distanceLabel.text = "0.00 km"
        accelerationLabel.text = "0.00 m/s^2"
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        let currentSpeed = location.speed
        speedLabel.text = "\(Int(currentSpeed * 3.6)) km/h"
        
        if currentSpeed > MaxSpeed {
            MaxSpeed = currentSpeed
            maxSpeedLabel.text = "\(Int (MaxSpeed * 3.6)) km/h"
        }
        
        if let previousLocation = previousLocation {
            let timeElapsed = location.timestamp.timeIntervalSince(previousLocation.timestamp)
            let distance = location.distance(from: previousLocation)
            tripDistance += distance
            distanceLabel.text = "\(String(format: "%.2f", tripDistance / 1000)) km"
            
            
            let currentAcceleration = abs(currentSpeed - PreviousSpeed) / timeElapsed
            if currentAcceleration > MaxAcceleration {
                MaxAcceleration = currentAcceleration
                accelerationLabel.text = "\(String(format: "%.2f", MaxAcceleration)) m/s^2"
            }
            TotalSpeed += currentSpeed
            let averageSpeed = TotalSpeed / Double(locations.count)
            averageSpeedLabel.text = "\(String(format: "%.2f", averageSpeed * 3.6)) km/h"
            
        }
        
        PreviousSpeed = currentSpeed
        updateMapLocation(location: location)
        previousLocation = location
        
        
        if currentSpeed > recentSpeed {
            topView.backgroundColor = UIColor.red
        } else {
            topView.backgroundColor = UIColor.white
        }
    }
        func updateMapLocation(location: CLLocation) {
            let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
            mapView.setRegion(region, animated: true)
        }
        
}

