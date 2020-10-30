//
//  RTAViewController.swift
//  morta
//
//  Created by unkonow on 2020/10/26.
//

import UIKit
import AudioToolbox
import RealmSwift


class RTAViewController: UIViewController {
    
    @IBOutlet weak var clockBackView: UIView!
    @IBOutlet weak var clockLabel: UILabel!
    @IBOutlet weak var rtaScrollView: UIScrollView!
    @IBOutlet weak var suspensionLabel: UIButton!
    
    @IBOutlet weak var gestureImageView: UIImageView!
    @IBOutlet weak var guestureBackView: UIView!
    
    private var rtaIndex = -1
    private var rtaItems:[RTAItem] = []
    private var isMoving = false
    
    private var gestureType: GestureType = .yet
    private var aramClock: DateComponents!
    private var calendar: Calendar!
    private var elapsedTime: Int = 0



    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .backgroundColor
        self.rtaScrollView.backgroundColor = .backgroundSubColor
        self.rtaScrollView.layer.cornerRadius = 15
        self.clockBackView.backgroundColor = .clockBackgroundColor
        self.clockBackView.layer.cornerRadius = 15
        self.clockLabel.textColor = .textColor
        self.guestureBackView.backgroundColor = .none
        

        calendar = Calendar(identifier: .gregorian)
        aramClock = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date())
        aramClock.minute! -= 10

                        
        
        let realm = try! Realm()
        let routines = realm.objects(RoutineItem.self).sorted(byKeyPath: "index", ascending: true)
        let lastindex = routines.last?.index
        
        for item in routines{
            var positionType:RTAItem.PositionType!
            if item.index == 1{
                positionType = .top
            }else if item.index == lastindex{
                positionType = .bottom
            }else{
                positionType = .content
            }
            let view2 = RTAItem(position: positionType)
            view2.titleLabel.text = item.title
            print(self.rtaScrollView.frame.width )
            view2.frame = CGRect(x: 0, y: 60*(item.index - 1), width: Int(self.rtaScrollView.bounds.width), height: 60)
            self.rtaScrollView.addSubview(view2)
            rtaItems.append(view2)
        }
        
        rtaScrollView.contentSize = CGSize(width: 30, height: 60 * (routines.last?.index ?? 0))
        
        rtaScrollView.showsHorizontalScrollIndicator = false
        
        start()

        
        nowIndexCenter(index: 9)
        


    }
    
    enum GestureType {
        case next
        case back
        case yet
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>,with event: UIEvent?){
        if touchedView(touches: touches, view: guestureBackView){
            isMoving = true
            return
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isMoving{
            let x = touches.first?.location(in: guestureBackView).x
            if x! > 270{
                if x! > UIScreen.main.bounds.size.width - 90{
                    return
                }
                if case .next = gestureType{}else{
                    AudioServicesPlaySystemSound( 1519 )
                }
                gestureImageView.image = UIImage(named: "gestureIconNext")
                gestureType = .next
            }else if x! < 130{
                if x! < 70{
                    return
                }
                if case .back = gestureType{}else{
                    AudioServicesPlaySystemSound( 1519 )
                }
                gestureImageView.image = UIImage(named: "gestureIconBack")
                gestureType = .back
            }
            else{
                gestureImageView.image = UIImage(named: "gestureIcon")
                gestureType = .yet
            }
            gestureImageView.center.x = x!

        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isMoving{
            switch gestureType {
            case .next:
                UIView.animate(withDuration: 0.3, delay: 0.3, options: .curveEaseInOut, animations: {
                    self.gestureImageView.center.x = self.view.center.x
                }, completion: {finished in
                    self.gestureImageView.image = UIImage(named: "gestureIcon")
                    self.isMoving = false
                })
                next()
            case .back:
                UIView.animate(withDuration: 0.3, delay: 0.3, options: .curveEaseInOut, animations: {
                    self.gestureImageView.center.x = self.view.center.x
                }, completion: {finished in
                    self.gestureImageView.image = UIImage(named: "gestureIcon")
                    self.isMoving = false
                })
                back()
            case .yet:
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                    self.gestureImageView.center.x = self.view.center.x
                }, completion: {finished in
                    self.gestureImageView.image = UIImage(named: "gestureIcon")
                    self.isMoving = false
                })
            }

        }
    }
    
    func next(){
        if rtaIndex >= rtaItems.count - 1{
            AudioServicesPlaySystemSound( 1102 )
        }else{
            AudioServicesPlaySystemSound( 1519 )
            self.rtaIndex += 1
            print("rtaindex",self.rtaIndex)
            let rtaItem = rtaItems[self.rtaIndex]
            rtaItem.checkAnimation()
            rtaItem.timerLabel.text = secs2str(elapsedTime)
            rtaItem.timerLabel.isHidden = false
            
            nowIndexCenter(index: self.rtaIndex)
        }

    }
    func back(){
        if rtaIndex < 0{
            AudioServicesPlaySystemSound( 1102 )
        }else{
            AudioServicesPlaySystemSound( 1519 )
            rtaItems[self.rtaIndex].back()
            nowIndexCenter(index: self.rtaIndex)
            self.rtaIndex -= 1
        }
    }
    
    func start(){
        print("=========START============")
        let timer = Timer(timeInterval: 1,
                          target: self,
                          selector: #selector(timeCheck),
                          userInfo: nil,
                          repeats: true)
        RunLoop.main.add(timer, forMode: .default)
    }
    
    func stop(){
        
    }
    
    @objc func timeCheck(){
        let now = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date())
        let diff1 = calendar.dateComponents([.second], from: self.aramClock, to: now)
        elapsedTime = diff1.second!
        clockLabel.text = secs2str(diff1.second!)
    }
    
    func secs2str(_ second: Int) -> String{
        return String(second / 60).leftPadding(toLength: 2, withPad: "0") + ":" +  String(second % 60).leftPadding(toLength: 2, withPad: "0")
    }
    
    func touchedView(touches: Set<UITouch>, view:UIView)->Bool{
        for touch: AnyObject in touches {
            let t: UITouch = touch as! UITouch
            if t.view?.tag == view.tag {
                return true
            } else {
                return false
            }
        }
        return false
    }
    

    
    
    @IBAction func exit(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func nowIndexCenter(index: Int){
        self.rtaScrollView.setContentOffset(CGPoint(x: 0, y: 60*(index / 2)), animated: true)
    }
    


}

