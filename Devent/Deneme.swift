//
//  Deneme.swift
//  Devent
//
//  Created by Erman Sefer on 29/10/15.
//  Copyright © 2015 ES. All rights reserved.
//

import UIKit

class Deneme: UIViewController {

    @IBOutlet weak var denemetext: UITextField!
    
    var groupId: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(groupId)
        denemetext.text = groupId

        // Do any additional setup after loading the view.
    }


}
