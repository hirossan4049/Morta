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
            deleteBtn.isEnabled  = false
            deleteBtn.tintColor = .darkGray
            deleteBtn.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
//            deleteBtnConstraint.constant = 0
        case .edit:
            navigationBarItem.title = "ルーティーン編集"
            deleteBtn.isEnabled = true
            deleteBtn.tintColor = .red
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
        let alert: UIAlertController = UIAlertController(title: "消去", message: "ルーティーンを消去してもいいですか？", preferredStyle:  UIAlertController.Style.alert)
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
            (action: UIAlertAction!) -> Void in
        let realm = try! Realm()

        let routineItemIndex = self.routineItem.index
        try! realm.write{
            realm.delete(self.routineItem)
        }
        
        let routine = realm.objects(RoutineItem.self)
        print(routine)

        guard let routineLast = routine.sorted(byKeyPath: "index", ascending: true).last else {
            self.deletedDialogDismiss()
            return
        }
        
            if (routineLast.index + 1) == routineItemIndex{
                self.deletedDialogDismiss()
                return
            }else{
                try! realm.write({
                    for index in routineItemIndex...routineLast.index - 1{
                        routine[index - 1].index -= 1
                    }
                })
            }
        
        self.dismiss(animated: true, completion: nil)
        (self.delegrate as! HomeViewController).routineView.reloadData()
        Loaf("消去しました！", state: .success, sender: self.delegrate).show(.short)

        })
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler:{
            (action: UIAlertAction!) -> Void in
        })
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
        

    }
    
    func deletedDialogDismiss(){
        self.dismiss(animated: true, completion: nil)
        (self.delegrate as! HomeViewController).routineView.reloadData()
        Loaf("消去しました！", state: .success, sender: self.delegrate).show(.short)
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
                if textField.text == routineItem.title{
                    self.dismiss(animated: true, completion: nil)
                    return
                }
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
