//
//  DetailMemeMeViewController.swift
//  MemeMe1.0
//
//  Created by Abdullah Al-Mahry on 04/12/2018.
//  Copyright © 2018 Udacity. All rights reserved.
//

import UIKit

class DetailMemeMeViewController: UIViewController {

    var meme : Meme?
    @IBOutlet weak var imageView: UIImageView!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.imageView!.image = meme!.memedImage
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
