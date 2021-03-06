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
    private var routines: Results<RoutineItem>!
    
    private var gestureType: GestureType = .yet
    private var aramClock: DateComponents!
    private var calendar: Calendar!
    private var elapsedTime: String = ""
    private var timer: Timer!
    
    var isDEMO: Bool = false
    private var startDate: DateComponents!


    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .backgroundColor
        self.rtaScrollView.backgroundColor = .backgroundSubColor
        self.rtaScrollView.layer.cornerRadius = 15
        self.clockBackView.backgroundColor = .clockBackgroundColor
        self.clockBackView.layer.cornerRadius = 15
        self.clockLabel.textColor = .textColor
        self.guestureBackView.backgroundColor = .none
        

        calendar = Calendar.current
        let aramTime = UserDefaults.standard.integer(forKey: "ararmTime")
        let date = Date(timeIntervalSince1970: TimeInterval(aramTime))
        aramClock = Calendar.current.dateComponents(in: TimeZone.current, from: date)
        
        clockLabel.text = "Loading..."
        
        startDate = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date())

        
        let realm = try! Realm()
        routines = realm.objects(RoutineItem.self).sorted(byKeyPath: "index", ascending: true)
        let lastindex = routines.last?.index
        
        let today = calendar.component(.day, from: Date())
        let lastdate = realm.objects(Ranking.self).sorted(byKeyPath: "date", ascending: true).last?.date
        if lastdate != nil{
            let lastday = calendar.component(.day, from:lastdate!)
            if lastday == today{
                let vc = storyboard?.instantiateViewController(withIdentifier: "ExistsAlertViewController") as! ExistsAlertViewController
                vc.modalPresentationStyle = .overFullScreen
                vc.delegate = self
                self.presentDialogViewController(vc, animationPattern: .fadeInOut, completion: { () -> Void in })
            }
        }
        
        for item in routines{
            var positionType:RTAItem.PositionType!
            if item.index == 1{
                if item.index == lastindex{
                    positionType = .alone
                }else{
                    positionType = .top
                }
            }else if item.index == lastindex{
                positionType = .bottom
            }else{
                positionType = .content
            }
            let view2 = RTAItem(position: positionType)
            view2.titleLabel.text = item.title
            view2.frame = CGRect(x: 0, y: 60*(item.index - 1), width: Int(self.rtaScrollView.frame.width - 30), height: 60)
            self.rtaScrollView.addSubview(view2)
            rtaItems.append(view2)
        }
        
        rtaScrollView.contentSize = CGSize(width: 30, height: 60 * (routines.last?.index ?? 0))
        
        rtaScrollView.showsHorizontalScrollIndicator = false
        
        start()
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
            let scWidth = UIScreen.main.bounds.size.width
            if x! > scWidth - 130{
                if x! > scWidth - 100{
                    return
                }
                if case .next = gestureType{}else{
                    AudioServicesPlaySystemSound( 1519 )
                    gestureType = .next
                    gestureImageView.image = UIImage(named: "gestureIconNext")
                }
            }else if x! < 130{
                if x! < 70{
                    return
                }
                if case .back = gestureType{}else{
                    AudioServicesPlaySystemSound( 1519 )
                    gestureType = .back
                    gestureImageView.image = UIImage(named: "gestureIconBack")
                }
            }
            else{
                if case .yet = gestureType{}else{
                    gestureImageView.image = UIImage(named: "gestureIcon")
                    gestureType = .yet
                }
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
            rtaItem.timerLabel.text = elapsedTime
            rtaItem.timerLabel.isHidden = false
            
            if rtaIndex == (routines.last!.index - 1){
                print("LAST")
                end()
            }
            
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
        timer = Timer(timeInterval: 1,
                          target: self,
                          selector: #selector(timeCheck),
                          userInfo: nil,
                          repeats: true)
        RunLoop.main.add(timer, forMode: .default)
    }
    
    func stop(){
        
    }
    
    func end(){
        if isDEMO{
            let vc = storyboard?.instantiateViewController(withIdentifier: "ResultViewController") as! ResultViewController
            vc.modalPresentationStyle = .overFullScreen
            vc.delegate = self
            self.presentDialogViewController(vc, animationPattern: .fadeInOut, completion: { () -> Void in })
            vc.timeLabel.text = elapsedTime
            vc.rankingLabel.text = "デモ"
        }else{
            let realm = try! Realm()
            let ranking = Ranking()
            ranking.date = Date()
            routines.forEach{ranking.routineList.append($0)}
            var now = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date())
            now.year = aramClock.year
            now.month = aramClock.month
            now.day = aramClock.day
            let diff = calendar.dateComponents([.second], from: self.aramClock, to: now)
            ranking.time = Int(diff.second!)
            try! realm.write({
                realm.add(ranking)
            })
            let rank = realm.objects(Ranking.self).filter("time < \(ranking.time)").count + 1

            let vc = storyboard?.instantiateViewController(withIdentifier: "ResultViewController") as! ResultViewController
            vc.modalPresentationStyle = .overFullScreen
            vc.delegate = self
            self.presentDialogViewController(vc, animationPattern: .fadeInOut, completion: { () -> Void in })
            vc.timeLabel.text = elapsedTime
            vc.rankingLabel.text = String(rank) + "位"
        }
    }
    
    func dismissDialog(){
        dismissDialogViewController(.fadeInOut)
    }
    
    @objc func timeCheck(){
        if isDEMO{
            let now = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date())
            let diff = calendar.dateComponents([.hour,.minute,.second], from: startDate, to: now)
            clockLabel.text = String(diff.hour!).leftPadding(toLength: 2, withPad: "0") + ":" + String(diff.minute!).leftPadding(toLength: 2, withPad: "0") + ":" + String(diff.second!).leftPadding(toLength: 2, withPad: "0")
            elapsedTime = clockLabel.text!
        }else{
            var now = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date())
            now.year = aramClock.year
            now.month = aramClock.month
            now.day = aramClock.day

            let diff = calendar.dateComponents([.hour,.minute,.second], from: self.aramClock, to: now)
            clockLabel.text = String(diff.hour!).leftPadding(toLength: 2, withPad: "0") + ":" + String(diff.minute!).leftPadding(toLength: 2, withPad: "0") + ":" + String(diff.second!).leftPadding(toLength: 2, withPad: "0")
            elapsedTime = clockLabel.text!
        }
    }
    
    func secs2str(_ second: Int) -> String{
        return String(second / 60).leftPadding(toLength: 2, withPad: "0") + ":" + String(second % 60).leftPadding(toLength: 2, withPad: "0")
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
        self.timer.invalidate()
    }
    
    func nowIndexCenter(index: Int){
        self.rtaScrollView.setContentOffset(CGPoint(x: 0, y: 60*(index / 2)), animated: true)
    }
    


}

