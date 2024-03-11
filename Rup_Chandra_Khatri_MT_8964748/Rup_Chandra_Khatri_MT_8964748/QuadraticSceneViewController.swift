//
//  QuadraticSceneViewController.swift
//  Rup_Chandra_Khatri_MT_8964748
//
//  Created by user237233 on 3/5/24.
//

import UIKit

class QuadraticSceneViewController: UIViewController {
    //IBOutlets for text field and text area i.e.display box
    @IBOutlet weak var textOne: UITextField!
    @IBOutlet weak var textTwo: UITextField!
    @IBOutlet weak var textThree: UITextField!
    @IBOutlet weak var displayBox: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //IBAction for the calculate button
    @IBAction func buttonCalculate(_ sender: Any) {
        //take input from the text fields
        guard let aStr = textOne.text, let a = Double(aStr),
                      let bStr = textTwo.text, let b = Double(bStr),
                      let cStr = textThree.text, let c = Double(cStr)
                else {
            //displaying error message
                    displayBox.text = "Invalid input. Please enter valid number."
                    return
                }
                //calculating the discriminant
                let discriminant = b * b - 4 * a * c

                if discriminant > 0 {
                    let root1 = (-b + sqrt(discriminant)) / (2 * a)
                    let root2 = (-b - sqrt(discriminant)) / (2 * a)
                    displayBox.text = "Roots: \(root1), \(root2)"
                } else if discriminant == 0 {
                    let root = -b / (2 * a)
                    displayBox.text = "Root: \(root)"
                } else {
                    //displaying message if the discriminant is in negative
                    displayBox.text = "No results since the discriminant is less than zero"
                }
            }
    
    //IBAction for the clear button
    @IBAction func clearButton(_ sender: Any) {
        textOne.text = ""
        textTwo.text = ""
        textThree.text = ""
        displayBox.text = ""
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
