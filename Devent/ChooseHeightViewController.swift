//
//  ChooseHeightViewController.swift
//  Devent
//
//  Created by Can Ceran on 01/11/15.
//  Copyright © 2015 ES. All rights reserved.
//

import UIKit

class ChooseHeightViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // MARK: PROPOERTIES
    
    private var heightOptionsArray: [String] = []
    
    var selectedHeight: String?
    
    @IBOutlet weak var heightPickerView: UIPickerView!
    
    
    // MARK: ACTIONS
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return heightOptionsArray.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return heightOptionsArray[row]
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedHeight = heightOptionsArray[row]
    }
    
    @IBAction func doneButton(sender: UIBarButtonItem) {
    }
    
    @IBAction func cancelButton(sender: UIBarButtonItem) {
    }
    
    private func initializeHeightOptions() {
        var array: [String] = []
        array.append("Not specified")
        for i in 120...220 {
            array.append("\(i)")
        }
        self.heightOptionsArray = array
    }

    
    // MARK: VC LIFECYCLE 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initializeHeightOptions()
        heightPickerView.dataSource = self
        heightPickerView.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            if identifier == "UnwindToEditProfileFromDoneSegue" {
                if let epvc = segue.destinationViewController as? EditProfileTableViewController {
                    
                    epvc.currentHeight = selectedHeight
                    print("Selected height is \(selectedHeight!) and is passed as \(epvc.currentHeight)")
                    //epvc.heightLabel.text = selectedHeight
                }
            }
        }

    }


}
