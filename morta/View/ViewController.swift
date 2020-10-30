//
//  ViewController.swift
//  morta
//
//  Created by unkonow on 2020/10/24.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var fragmentView: UIView!
    @IBOutlet weak var tabbar: UIView!
    @IBOutlet weak var homeBtn: UIButton!
    @IBOutlet weak var rankingBtn: UIButton!
    
    private var nowFragmentsType: FragmentsType!
    private var homeVC: HomeViewController!
    private var rankingVC: RankingViewController!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .backgroundColor
        
        tabbar.backgroundColor = .tabbarColor
        tabbar.layer.cornerRadius = 17
        homeBtn.imageView?.frame.size = CGSize(width: 20, height: 20)
        homeVC = storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
        homeVC.delegrate = self
        rankingVC = storyboard?.instantiateViewController(withIdentifier: "RankingViewController") as? RankingViewController
        
        fragmentsChange(type: .home)

    }
    
    enum FragmentsType {
        case home
        case ranking
    }
    
    func fragmentsChange(type: FragmentsType){
        if nowFragmentsType == type{
            return
        }else{
            switch type {
            case .home:
                remove(viewController: rankingVC)
                add(viewController: homeVC)
            case .ranking:
                remove(viewController: homeVC)
                add(viewController: rankingVC)
            default:
                return
            }
            nowFragmentsType = type
        }
    }
    
    @IBAction func home(){
        fragmentsChange(type: .home)
    }
    @IBAction func ranking(){
        fragmentsChange(type: .ranking)
    }
    
    
    
    
    // MARK: - Child VC Operation Methods
    private func add(viewController: UIViewController) {
//        addChild(viewController)
//        view.addSubview(viewController.view)
        fragmentView.addSubview(viewController.view)
//        viewController.view.frame = view.bounds
        viewController.view.frame.size = fragmentView.frame.size
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewController.didMove(toParent: self)
    }

    private func remove(viewController: UIViewController) {
        viewController.willMove(toParent: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParent()
    }


}

