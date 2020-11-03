//
//  TutorialViewController.swift
//  morta
//
//  Created by unkonow on 2020/11/03.
//

import UIKit
import Lottie

class TutorialViewController: UIViewController {
    @IBOutlet weak var backView: UIView!
    private var backAnimationView: AnimationView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        backView.isHidden = true

        self.backViewChange(name: "blueBackView")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.backViewChange(name: "orangeBackView")
        }
    }
    
    func backViewChange(name:String){
        backView.subviews.forEach{$0.removeFromSuperview()}
        backAnimationView = AnimationView(name: name)
        backAnimationView.frame = self.view.frame
        backAnimationView.loopMode = .loop
        backAnimationView.contentMode = .scaleAspectFit
        backAnimationView.animationSpeed = 0.2
        backAnimationView.play()
        self.backView.addSubview(backAnimationView)
    }
    


}
