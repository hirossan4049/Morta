//
//  ResultViewController.swift
//  morta
//
//  Created by unkonow on 2020/11/03.
//

import UIKit

class ResultViewController: UIViewController {

    var delegate: RTAViewController!
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var rankingLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backView.backgroundColor = .backgroundColor
        backView.layer.cornerRadius = 15
    }
    

    @IBAction func eixt(){
        delegate.dismissDialog()
        delegate.dismiss(animated: true, completion: nil)
    }

}
