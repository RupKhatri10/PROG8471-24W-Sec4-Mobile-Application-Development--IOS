//
//  Lab2ViewController.swift
//  Rup_Chandra_Khatri_MT_8964748
//
//  Created by user237233 on 3/5/24.
//

import UIKit

class   Lab2ViewController: UIViewController {

    var screenNum:Int = 0;
    var stepValue = 1;
    
   //IBOutlet for label
    @IBOutlet weak var textNum: UILabel!
    
    //IBAction for increase and decrease button respectively
    @IBAction func btnIncrese(_   sender: Any) {
        screenNum += stepValue
        textNum.text = String(screenNum)
        textNum.text = "\(screenNum)"
    }
    
    @IBAction func btnDecrease(_ sender: Any) {
        screenNum -= stepValue
        textNum.text = String(screenNum)
        textNum.text = "\(screenNum)"
    }
    
    //IBAction for step and reset button respectively
    @IBAction func btnStep(_ sender: Any) {
        stepValue = (stepValue == 1) ? 2 : 1
    }
    
    @IBAction func btnReset(_ sender: Any) {
        screenNum = 0;
        textNum.text = "0";
        stepValue = 1;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        screenNum = Int(textNum.text!) ?? 0
        // Do any additional setup after loading the view.
    }


}

