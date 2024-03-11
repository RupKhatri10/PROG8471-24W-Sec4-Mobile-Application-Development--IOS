//
//  CanadaSceneViewController.swift
//  Rup_Chandra_Khatri_MT_8964748
//
//  Created by user237233 on 3/5/24.
//

import UIKit

class CanadaSceneViewController: UIViewController, UITextFieldDelegate {

    //IBOutlet for image view, text field and button
    @IBOutlet weak var CityImageView: UIImageView!
    @IBOutlet weak var CityInputBox: UITextField!
    @IBOutlet weak var buttonImage: UIButton!
    //default image name
    let defaultImage = "canada"
    //list of city names stored in an array
    let CityImageNames = ["calgary", "halifax", "montreal", "toronto", "vancouver", "winnipeg"]
    override func viewDidLoad() {
            super.viewDidLoad()
        CityImageView.image = UIImage(named: defaultImage)
        buttonImage.addTarget(self, action: #selector(buttonFindMyCity(_:)), for: .touchUpInside)
        CityInputBox.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        CityInputBox.delegate = self
        }
    
    //IBAction for the Find_My_City button
    @IBAction func buttonFindMyCity(_ sender: Any) {
        guard let cityImageName = CityInputBox.text?.lowercased() else {return}
            
        if cityImageName.isEmpty {
            CityImageView.image = UIImage(named: defaultImage)
        }else {
            if CityImageNames.contains(cityImageName) {
                CityImageView.image = UIImage(named: cityImageName)
            }else {
                displayErrorMessage()
            }
        }
    }
    
    //creating the function to display the error message
    func displayErrorMessage() {
            let alert = UIAlertController(title: "Error", message: "City not found!\n Please enter a valid City name", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    
        @objc func textFieldDidChange(_ textField: UITextField) {
           // textField.text = textField.text?.lowercased()
        }
        
        // creating the UITextFieldDelegate method to dismiss the keyboard on return key
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
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
