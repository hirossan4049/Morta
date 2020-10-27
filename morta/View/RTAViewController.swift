//
//  RTAViewController.swift
//  morta
//
//  Created by unkonow on 2020/10/26.
//

import UIKit
import RealmSwift


class RTAViewController: UIViewController {
    
    @IBOutlet weak var clockBackView: UIView!
    @IBOutlet weak var rtaScrollView: UIScrollView!
    
    private var rtaItems:[RTAItem] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .backgroundColor
        self.rtaScrollView.backgroundColor = .backgroundSubColor
        self.rtaScrollView.layer.cornerRadius = 15
        self.clockBackView.backgroundColor = .clockBackgroundColor
        self.clockBackView.layer.cornerRadius = 15
        
        let realm = try! Realm()
        let routines = realm.objects(RoutineItem.self).sorted(byKeyPath: "index", ascending: true)
        
        for item in routines{
            var positionType:RTAItem.PositionType!
            if item.index == 1{
                positionType = .top
            }else if item.index == routines.last?.index{
                positionType = .bottom
            }else{
                positionType = .content
            }
            let view2 = RTAItem(position: positionType)
            view2.titleLabel.text = item.title
            view2.frame = CGRect(x: 0, y: 60*(item.index - 1), width: Int(self.rtaScrollView.bounds.width), height: 60)
            self.rtaScrollView.addSubview(view2)
            rtaItems.append(view2)
        }
        
        rtaScrollView.contentSize = CGSize(width: 30, height: 60 * routines.last!.index)
        
        rtaScrollView.showsHorizontalScrollIndicator = false
        
        nowIndexCenter(index: 9)


    }
    
    @IBAction func exit(){
        rtaItems[0].checkAnimation()
    }
    
    func nowIndexCenter(index: Int){
        //fixme イラン。
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.rtaScrollView.setContentOffset(CGPoint(x: 0, y: 60*(index / 2)), animated: true)
        }
    }
    


}

