//
//  RankingViewController.swift
//  morta
//
//  Created by unkonow on 2020/10/24.
//

import UIKit
import SwiftyMenu
import RealmSwift

class RankingViewController: UIViewController, SwiftyMenuDelegate, UITableViewDelegate, UITableViewDataSource {
    let sortItems: [SwiftyMenuDisplayable] = [SortType.new.rawValue, SortType.rank.rawValue]
    var realm:Realm!
    var rankings: Results<Ranking>!
    private var sortType:SortType = .new

    @IBOutlet private weak var dropDownMenu: SwiftyMenu!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var rankingLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .backgroundColor
        rankingLabel.textColor = .tabbarColor
        
        realm = try! Realm()
        switch sortType {
        case .new:
            rankings = realm.objects(Ranking.self).sorted(byKeyPath: "date", ascending: true)
        case .rank:
            rankings = realm.objects(Ranking.self).sorted(byKeyPath: "time", ascending: true)
        default:break
        }
        
        dropDownMenu.delegate = self
        dropDownMenu.items = sortItems
        dropDownMenu.selectedIndex = 0
        dropDownMenu.placeHolderText = SortType.new.rawValue
        
        tableView.backgroundColor = .backgroundSubColor
        tableView.separatorStyle = .none
        tableView.layer.cornerRadius = 15
        tableView.delegate = self
        tableView.dataSource = self
        let nib = UINib(nibName: "RankingTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "cell")

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    enum SortType:String {
        case new = "新規順"
        case rank = "ランク順"
    }
    
    func swiftyMenu(_ swiftyMenu: SwiftyMenu, didSelectItem item: SwiftyMenuDisplayable, atIndex index: Int) {
        sortType = SortType(rawValue: String(sortItems[index].displayableValue))!
        
        switch sortType {
        case .new:
            rankings = realm.objects(Ranking.self).sorted(byKeyPath: "date", ascending: true)
        case .rank:
            rankings = realm.objects(Ranking.self).sorted(byKeyPath: "time", ascending: true)
        default:break
        }
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rankings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! RankingTableViewCell
        cell.dateLabel.text = date2String(rankings[indexPath.row].date!)
        let (h,m,s) = seconds2HMS(seconds: rankings[indexPath.row].time)
        cell.timeLabel.text = String(h) + "時間" + String(m) + "分" + String(s) + "秒"
        cell.backgroundColor = .backgroundSubColor
        cell.rankView.backgroundColor = .none
        cell.timeLabel.textColor = .textColor
        cell.timeLabel.textColor = .textColor
        let rank = realm.objects(Ranking.self).sorted(byKeyPath: "time", ascending: true).index(of: rankings[indexPath.row])!
        cell.rankView.subviews.forEach({$0.removeFromSuperview()})
        
        if rank < 3{
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: cell.rankView.frame.width, height: cell.rankView.frame.height))
            imageView.image = UIImage(named: "rank\(rank + 1)")
            cell.rankView.addSubview(imageView)
        }else{
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: cell.rankView.frame.width, height: cell.rankView.frame.height))
            label.text = String(rank + 1)
            label.textAlignment = .center
            cell.rankView.addSubview(label)
        }
        
        return cell
    }
    
    func date2String(_ date:Date) -> String{
        let f = DateFormatter()
        f.dateFormat = "MM月dd日"
        return f.string(from: date)
    }
    
    func seconds2HMS(seconds : Int) -> (Int, Int, Int) {
      return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    

}

extension String: SwiftyMenuDisplayable {
    public var retrievableValue: Any {
        return self
    }
    
    public var displayableValue: String {
        return self
    }
    
    public var retrivableValue: Any {
        return self
    }
}
