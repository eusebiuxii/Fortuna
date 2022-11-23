//
//  GameOverViewController.swift
//  Assignment1
//
//  Created by Moldovan, Eusebiu on 11/11/2022.
//

import UIKit

class GameOverVC: UIViewController {
    
    var array = [String]()
   
    @IBOutlet weak var totalScoreLabel: UILabel!
    
    
    func toLeaderboard(){
        performSegue(withIdentifier: "toLeaderboard", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        totalScoreLabel.text = "Total Score: "+String(totalPointsGO)
        
     
        array = (UserDefaults.standard.array(forKey: "scores") as? [String] ?? [""])

        
        array.append(String(format: "%03d", totalPointsGO))
        array = array.sorted(by: >)
        UserDefaults.standard.set(array, forKey:"scores")
 
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
