//
//  ViewController.swift
//  Rup_Chandra_Khatri_FE_8964748
//
//  Created by user237233 on 4/5/24.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    

    @IBOutlet weak var homeButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func homeButton(_ sender: Any) {
        
    }
    
    
    @IBAction func pressMeButtonTapped(_ sender: Any) {
        showCityInputAlert()
    }
    
    private func showCityInputAlert() {
        let alertController = UIAlertController(title: "Where would you like to go", message: "Enter your destination", preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = "City Name"
        }
        
        let confirmAction = UIAlertAction(title: "OK", style: .default) { _ in
            if let cityName = alertController.textFields?.first?.text {
                // Pass the cityName to WeatherViewController
                self.navigateToWeatherViewController(with: cityName)
            }
        }
        alertController.addAction(confirmAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }

    private func navigateToWeatherViewController(with cityName: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil) // Assuming "Main" is the name of your storyboard
        if let weatherVC = storyboard.instantiateViewController(withIdentifier: "WeatherScene") as? WeatherScene {
            weatherVC.cityName = cityName
            navigationController?.pushViewController(weatherVC, animated: true)
        }
    }

    
}

