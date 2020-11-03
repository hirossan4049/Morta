//
//  ExistsAlertViewController.swift
//  morta
//
//  Created by unkonow on 2020/11/03.
//

import UIKit

class ExistsAlertViewController: UIViewController {
    var delegate: RTAViewController!
    @IBOutlet weak var backView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        backView.backgroundColor = .backgroundColor
        backView.layer.cornerRadius = 15
        
    }
    
    @IBAction func exit(){
        delegate.dismissDialog()
        delegate.dismiss(animated: true, completion: nil)
    }
    

    

}
