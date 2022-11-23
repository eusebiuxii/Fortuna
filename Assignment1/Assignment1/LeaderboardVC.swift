//
//  LeaderboardVC.swift
//  Assignment1
//
//  Created by Moldovan, Eusebiu on 11/11/2022.
//

import UIKit
    

class LeaderboardVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var array = UserDefaults.standard.array(forKey: "scores") as? [String]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath)
        var content = UIListContentConfiguration.cell()
        content.text = String(indexPath.row+1) + ". " + (array?[indexPath.row])!
        cell.contentConfiguration = content
        
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
