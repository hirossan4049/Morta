//
//  RTAItem.swift
//  morta
//
//  Created by unkonow on 2020/10/27.
//

import UIKit
import Lottie

class RTAItem: UIView {
    @IBOutlet weak var checkBoxView: UIView!
    @IBOutlet weak var topLineView: UIView!
    @IBOutlet weak var bottomLineView: UIView!
    @IBOutlet weak var titleLabel: UILabel!

    private var nocheckView: UIImageView!
    private var animationView: AnimationView!
    
    private var isChecked = false
    
    var positionType:PositionType!
    
    convenience init(position: PositionType) {
        self.init(frame: CGRect.zero)
        self.positionType = position
        switch positionType {
            case .top:
                topLineView.isHidden = true
                topLineView.backgroundColor = .red
            case .bottom:
                bottomLineView.isHidden = true
            case .content:
                break
            case .alone:
                topLineView.isHidden = true
                bottomLineView.isHidden = true
            case .none:
                break
        }
     }

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        loadNib()
    }
    
    func checkAnimation(){
        if isChecked{
            return
        }
        isChecked = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            self.nocheckView.removeFromSuperview()
        }
        self.animationView.play{ finished in
            if finished{
                print("finished")
            }
        }
    
        
    }
    
    enum PositionType {
        case top
        case content
        case bottom
        case alone
    }
    

    func loadNib() {
        if let view = Bundle(for: type(of: self)).loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)?.first as? UIView {
            view.frame = self.bounds
            
            checkBoxView.backgroundColor = .none
            view.backgroundColor = .none
            animationView = AnimationView(name: "check-animation")
            animationView.frame = CGRect(x: 0, y: 0, width: checkBoxView.bounds.width, height: checkBoxView.bounds.height)
//            animationView.center = checkBoxView.center
//            animationView.loopMode = .loopr
            animationView.loopMode = .playOnce
            animationView.contentMode = .scaleAspectFit
            animationView.animationSpeed = 1.5
//            checkBoxView.addSubview(animationView)
            
            nocheckView = UIImageView(image: UIImage(named: "no-check"))
            nocheckView.frame = CGRect(x: 0, y: 0, width: checkBoxView.bounds.width, height: checkBoxView.bounds.height)
            nocheckView.contentMode = .scaleAspectFill
//            nocheckView.center = checkBoxView.center
            checkBoxView.addSubview(nocheckView)
            checkBoxView.addSubview(animationView)

            self.addSubview(view)
        }
    }

}
