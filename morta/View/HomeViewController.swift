//
//  HomeViewController.swift
//  morta
//
//  Created by unkonow on 2020/10/24.
//

import UIKit
import RealmSwift
import Loaf
import LSDialogViewController


class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var delegrate: UIViewController!
    
    private var routine:Results<RoutineItem>!
    private var realm:Realm!
    private var timeLimitTextField: UITextField!
    private var datePicker: UIDatePicker!

    @IBOutlet weak var routineView: UITableView!
    
    @IBOutlet weak var aleartLabel: UILabel!
    @IBOutlet weak var getupLabel: UILabel!
    @IBOutlet weak var homeLabel: UILabel!
    @IBOutlet weak var routineLabel: UILabel!

    @IBOutlet weak var aleartSwitch: UISwitch!

    override func viewDidLoad() {
        super.viewDidLoad()
        realm = try! Realm()
            
//        try! realm.write({
//            realm.deleteAll()
//        })
//
//        for i in 1...10{
//            let item = RoutineItem()
//            item.title = "hey!" + String(i)
//            item.index = i
//            try! realm.write({
//                realm.add(item)
//            })
//        }
        

        routine = realm.objects(RoutineItem.self)
        
        self.view.backgroundColor = .backgroundColor
        
        self.routineView.backgroundColor = .white
        self.routineView.layer.cornerRadius = 13
        
        aleartLabel.textColor = .tabbarColor
        getupLabel.textColor = .tabbarColor
        homeLabel.textColor = .tabbarColor
        routineLabel.textColor = .textColor
        routineView.backgroundColor = .backgroundSubColor
        
        let nib = UINib(nibName: "RoutineTableViewCell", bundle: nil)
        routineView.register(nib, forCellReuseIdentifier: "cell")
        routineView.delegate = self
        routineView.dataSource = self
        routineView.allowsSelection = false
        routineView.separatorStyle = .none
        
        let footerCell: UITableViewCell = routineView.dequeueReusableCell(withIdentifier: "tableFooterCell")!
        let footerView: UIView = footerCell.contentView
        routineView.tableFooterView = footerView
        
        let headerCell: UITableViewCell = routineView.dequeueReusableCell(withIdentifier: "tableHeaderCell")!
        let headerView: UIView = headerCell.contentView
        routineView.tableHeaderView = headerView

        let isSwitch = UserDefaults.standard.bool(forKey: "isAleartSwitch")
        switchChange(bool: isSwitch)
        
        routineView.isEditing = true
        
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        (self.view.viewWithTag(2525))?.removeFromSuperview()
        
        var aramTime = UserDefaults.standard.integer(forKey: "ararmTime")
        if aramTime == nil {
            let calendar = Calendar(identifier: .gregorian)
            var aramClock = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date())
            aramClock.minute! = 0
            aramClock.hour! = 6
            UserDefaults.standard.set(calendar.date(from: aramClock)?.timeIntervalSince1970, forKey: "ararmTime")
            aramTime = Int(calendar.date(from: aramClock)!.timeIntervalSince1970)
        }
        let calendar = Calendar.current
        let date = Date(timeIntervalSince1970: TimeInterval(aramTime))
        let hour = calendar.component(.hour, from: date)
        let min  = calendar.component(.minute, from: date)
        aleartLabel.text = String(hour).leftPadding(toLength: 2, withPad: "0") + ":" + String(min).leftPadding(toLength: 2, withPad: "0")
        
        var isSuspension = UserDefaults.standard.bool(forKey: "isSuspension")
        if isSuspension == nil{
            isSuspension = false
        }
        
        let now = calendar.dateComponents([.hour, .minute, .second], from: Date())
        if now.hour! > hour{
            // FIXME: まだ
        }else{
            
        }
        
        
    }
    

    
    @IBAction func edit(){
        let vc = storyboard?.instantiateViewController(withIdentifier: "TimePickerViewController") as! TimePickerViewController
//        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .overFullScreen
        vc.deleglate = self
        
        let backView = UIView()
        backView.frame = CGRect(x: 0, y: -100, width: self.view.frame.width, height: 10000)
        backView.backgroundColor = UIColor(hex: "000000", alpha: 0.3)
        backView.tag = 2525
        self.view.addSubview(backView)
        
        self.present(vc, animated: true, completion: nil)
//        self.presentDialogViewController(vc, animationParttern: .slideBottomBottom, completion: { () -> Void in })
    }
    
    @IBAction func resume(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "RTAViewController") as? RTAViewController
        vc?.modalPresentationStyle = .overFullScreen
        self.present(vc!, animated: true, completion: nil)
    }

    
    @IBAction func create(){
//        delegrate.performSegue(withIdentifier: "toCreate", sender: nil)
        let vc = storyboard?.instantiateViewController(withIdentifier: "CreateViewController") as? CreateViewController
        vc?.delegrate = self
        vc?.mode = .create
        self.present(vc!, animated: true, completion: nil)
    }
    
    @IBAction func switchChanged(_ sender: UISwitch) {
        switchChange(bool: sender.isOn)
    }
    
    func switchChange(bool:Bool){
        aleartSwitch.isOn = bool
        UserDefaults.standard.set(bool, forKey: "isAleartSwitch")
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.routine.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = routineView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! RoutineTableViewCell
        cell.indexPath = indexPath
        cell.indexLabel.text = String(indexPath.row + 1) + "."
        cell.titleLabel.text = self.routine.filter("index == \(indexPath.row + 1)")[0].title
        cell.editBtn.addTarget(self,action: #selector(self.cellClicked(_ :)),for: .touchUpInside)
        cell.editBtn.tag = indexPath.row + 1
        return cell
    }
    
    @objc func cellClicked(_ sender: UIButton){
        print(sender.tag)
        let vc = storyboard?.instantiateViewController(withIdentifier: "CreateViewController") as? CreateViewController
        vc?.delegrate = self
        vc?.mode = .edit
        vc?.routineItem = self.routine.filter("index == \(sender.tag)")[0]
        self.present(vc!, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if sourceIndexPath == destinationIndexPath{
            return
        }
        try! realm.write {
            let sourceObject = self.routine.filter("index == \(sourceIndexPath.row + 1)")[0]
            let destinationObject = self.routine.filter("index == \(destinationIndexPath.row + 1)")[0]
            
            print(sourceObject)
            print(destinationObject)

            let destinationObjectOrder = destinationObject.index

            if sourceIndexPath.row < destinationIndexPath.row {
                // up2down
                print(sourceIndexPath.row...destinationIndexPath.row )
                for index in sourceIndexPath.row...destinationIndexPath.row {
                    let object = self.routine.filter("index == \(index + 1)")[0]
                    object.index -= 1
                }
                
            } else {
                // down2up
                for index in (destinationIndexPath.row..<sourceIndexPath.row).reversed() {
                    let object = self.routine.filter("index == \(index + 1)")
                    print(index,object)
                    object[0].index += 1
                }
            }
            sourceObject.index = destinationObjectOrder
            tableView.reloadData()
        }
        
    }
    
    
    

    
}
