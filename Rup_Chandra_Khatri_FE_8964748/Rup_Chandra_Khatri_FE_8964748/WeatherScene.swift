//
//  WeatherScene.swift
//  Rup_Chandra_Khatri_FE_8964748
//
//  Created by user237233 on 4/12/24.
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

class WeatherScene: UIViewController, CLLocationManagerDelegate {
    
    var cityName: String?
    
    // MARK: - IBOutlets
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherTypeLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    
    // MARK: - Properties
    private let apiKey = "8fa7ab4ca2bcb7051feb684dc3965f8e"
    private let baseURL = "https://api.openweathermap.org/data/2.5/weather"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchWeatherData(for: "Toronto") // Default city
        
        if let cityName = cityName {
            fetchWeatherData(for: cityName)
            } else {
                print("City name is nil")
            }
    }
    
    // MARK: - Fetch Weather Data
    
    private func fetchWeatherData(for city: String) {
        guard let url = URL(string: "\(baseURL)?q=\(city)&appid=\(apiKey)&units=metric") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error fetching weather data: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                let weatherData = try JSONDecoder().decode(WeatherData.self, from: data)
                DispatchQueue.main.async {
                    self.updateUI(with: weatherData)
                }
            } catch {
                print("Error decoding weather data: \(error.localizedDescription)")
            }
        }
        
        task.resume()
    }
    
    // MARK: - Update UI

    private func updateUI(with weatherData: WeatherData) {
        cityNameLabel.text = weatherData.name
        temperatureLabel.text = "\(Int(weatherData.main.temp))°C"
        weatherTypeLabel.text = weatherData.weather.first?.description
        humidityLabel.text = "\(weatherData.main.humidity)%"
        windSpeedLabel.text =  "\(weatherData.wind.speed) m/s"
        
        // Construct URL for weather icon
        if let iconCode = weatherData.weather.first?.icon {
            let iconURL = URL(string: "https://openweathermap.org/img/wn/\(iconCode)@2x.png")
            
            // Download icon image asynchronously
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: iconURL!) {
                    DispatchQueue.main.async {
                        self.weatherImageView.image = UIImage(data: data)
                    }
                }
            }
        }
    }

    
    // MARK: - Bar Button Action
    
    @IBAction func searchButtonTapped(_ sender: UIBarButtonItem) {
        showCityInputAlert()
    }
    
    // MARK: - Alert Controller
    
    private func showCityInputAlert() {
        let alertController = UIAlertController(title: "Enter City Name", message: "to know that city's weather", preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = "City Name"
        }
        
        let confirmAction = UIAlertAction(title: "OK", style: .default) { _ in
            if let cityName = alertController.textFields?.first?.text {
                self.fetchWeatherData(for: cityName)
            }
        }
        alertController.addAction(confirmAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
}
