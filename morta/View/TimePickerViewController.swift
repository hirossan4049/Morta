//
//  TimePickerViewController.swift
//  morta
//
//  Created by unkonow on 2020/11/02.
//

import UIKit
import Loaf

class TimePickerViewController: UIViewController, UIAdaptivePresentationControllerDelegate {
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var pickerView: UIDatePicker!
    
    var deleglate: HomeViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.backView.backgroundColor = .backgroundColor
        self.backView.layer.cornerRadius = 13
        self.view.backgroundColor = .none

        let unixtime: TimeInterval = TimeInterval(UserDefaults.standard.integer(forKey: "ararmTime"))
        let date = Date(timeIntervalSince1970: unixtime)
        self.pickerView.date = date
    }
    
    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        dismiss(animated: true)
        }
    

    @IBAction func done(){
        UserDefaults.standard.set(Int(pickerView.date.timeIntervalSince1970), forKey: "ararmTime")
        self.dismissCalled()
    }
    
    @IBAction func cancel(){
        self.dismissCalled()
    }
    
    func dismissCalled(){
        self.dismiss(animated: true, completion: nil)
        deleglate.viewWillAppear(true)
    }
}
