//
//  ViewController.swift
//  Lab_8_WeatherApp
//
//  Created by user237233 on 3/26/24.
//

import UIKit
import CoreLocation

struct WeatherData: Decodable {
    let name: String
    let weather: [Weather]
    let main: Main
    let wind: Wind
}

struct Weather: Decodable {
    let description: String
    let icon: String
}

struct Main: Decodable {
    let temp: Double
    let humidity: Int
}

struct Wind: Decodable {
    let speed: Double
}

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    
    let locationManager = CLLocationManager()
    let apiKey = "8fa7ab4ca2bcb7051feb684dc3965f8e"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
   
        locationManager.stopUpdatingLocation()
  
        fetchWeatherData(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
    }
    
    func fetchWeatherData(latitude: Double, longitude: Double) {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)&units=metric"
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching weather data: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else { return }
            
            do {
                let weatherData = try JSONDecoder().decode(WeatherData.self, from: data)
                
                DispatchQueue.main.async {
                    self.updateUI(with: weatherData)
                }
            } catch {
                print("Error decoding weather data: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    func updateUI(with weatherData: WeatherData) {
        cityLabel.text = weatherData.name
        weatherDescriptionLabel.text = weatherData.weather.first?.description ?? "N/A"
        if let iconURL = URL(string: "https://openweathermap.org/img/wn/\(weatherData.weather.first?.icon ?? "01d")@2x.png") {
            weatherIconImageView.load(url: iconURL)
        }
        temperatureLabel.text = "\(weatherData.main.temp)°C"
        humidityLabel.text = "\(weatherData.main.humidity)%"
        windSpeedLabel.text = "\(weatherData.wind.speed) m/s"
    }
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self?.image = image
                }
            }
        }
    }
}
