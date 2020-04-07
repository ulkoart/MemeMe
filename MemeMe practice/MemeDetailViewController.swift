//
//  MemeDetailViewController.swift
//  MemeMe practice
//
//  Created by user on 07.04.2020.
//  Copyright © 2020 Артем Улько. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    
    @IBOutlet weak var memeImage: UIImageView!
    var meme: Meme!

    override func viewDidLoad() {
        super.viewDidLoad()
        memeImage.image = meme.memedImage
    }
    

}
