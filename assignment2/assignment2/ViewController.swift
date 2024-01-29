//
//  ViewController.swift
//  assignment2
//
//  Created by user237233 on 1/23/24.
//

import UIKit

class ViewController: UIViewController {
  
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var firstNameLabel: UILabel!
    
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var lastNameLabel: UILabel!
    
    @IBOutlet weak var country: UITextField!
    @IBOutlet weak var countryLabel: UILabel!
    
    @IBOutlet weak var age: UITextField!
    @IBOutlet weak var ageLabel: UILabel!
    
    @IBOutlet weak var displayBox: UITextView!
    @IBOutlet weak var displayBoxLabel: UILabel!
    
    @IBOutlet weak var addButton: UIButton!
        
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var clearButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
      
    }

    @IBAction func firstNameAction(_ sender: Any) {
        
        
    }
    
    @IBAction func lastNameAction(_ sender: Any) {
        
    }
        
    @IBAction func countryAction(_ sender: Any) {
        
    }
    
    @IBAction func ageAction(_ sender: Any) {
        
    }
    
        
    
    @IBAction func addButton(_ sender: Any) {
        let userDetails = " Full Name: \(firstName.text!) \(lastName.text!)\n Country: \(country.text!)\n Age: \(age.text!)"
        displayBox.text = userDetails
    }
    
    @IBAction func submitButton(_ sender: Any) {
                
        if(firstName.text != "" && lastName.text != "" && country.text != "" && age.text != ""){
            print("\(displayBoxLabel.text = "Sucessfully Submitted!")")
        } else {
            print("\(displayBoxLabel.text = "Complete the missing info!")")
        }
        displayBoxLabel.isHidden = false
    }
    
    @IBAction func clearButton(_ sender: Any) {
        firstName.text = ""
        lastName.text =  ""
        country.text =  ""
        age.text =  ""
        displayBox.text = ""
        displayBoxLabel.isHidden = true
        
    }
}

