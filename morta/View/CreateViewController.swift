//
//  CreateViewController.swift
//  morta
//
//  Created by unkonow on 2020/10/24.
//

import UIKit
import Loaf
import RealmSwift

class CreateViewController: UIViewController {
    var delegrate: UIViewController!
    var mode: ModeType!
    
    var routineItem:RoutineItem!
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var navigationBarItem: UINavigationItem!
    @IBOutlet weak var deleteBtn: UIButton!
//    @IBOutlet weak var deleteBtnConstraint: NSLayoutConstraint!


    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch mode {
        case .create:
            navigationBarItem.title = "ルーティーン作成"
            deleteBtn.isHidden = true
            deleteBtn.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
//            deleteBtnConstraint.constant = 0
        case .edit:
            navigationBarItem.title = "ルーティーン編集"
            deleteBtn.isHidden = false
//            deleteBtnConstraint.constant = 32
            textField.text = routineItem.title
            
        case .none: break
        }

        self.textField.becomeFirstResponder()
    }
    
    enum ModeType{
        case create
        case edit
    }
    
    @IBAction func delete(){
        
    }
    
    @IBAction func cancel(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func done(){
        if textField.text == ""{
            Loaf("1文字以上入力してください",state: .error, location: .top, sender: self).show(.custom(0.8))
        }else{
            var sucsessMsg = ""
            switch mode {
            case .create:
                create()
                sucsessMsg = "追加しました！"
            case .edit:
                update()
                sucsessMsg = "アップデートしました！"
            default:
                break
            }
            self.dismiss(animated: true, completion: nil)
            (delegrate as! HomeViewController).routineView.reloadData()
            Loaf(sucsessMsg, state: .success, sender: delegrate).show(.short)
        }
    }
    
    func update(){
        let realm = try! Realm()
        try! realm.write({
            routineItem.title = textField.text!
        })
    }
    func create(){
        let realm = try! Realm()
        let lastIndex = realm.objects(RoutineItem.self).sorted(byKeyPath: "index", ascending: true).last?.index
        let ri = RoutineItem()
        ri.title = textField.text!
        ri.index = (lastIndex ?? 0) + 1
        try! realm.write({
            realm.add(ri)
        })
    }


}
