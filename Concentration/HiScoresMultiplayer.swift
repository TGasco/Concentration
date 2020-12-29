//
//  HiScoresMultiplayer.swift
//  Concentration
//
//  Created by Thomas Gascoyne on 29/11/2020.
//

import UIKit
import CoreData
class HiScoresMultiplayer: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var updateTable: UITableView!
    
    @IBOutlet weak var navBar: UINavigationBar!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var hiScores: [Multiplayer]?
    
    override func viewWillAppear(_ animated: Bool) {
        self.updateTable.isHidden = false
        }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.hiScores?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let multiplayer = UITableViewCell(style: UITableViewCell.CellStyle.default,
                                                      reuseIdentifier: "multiplayer")
        
        let scores = self.hiScores?[indexPath.row]
        
        multiplayer.textLabel?.text = "P1: \(String(scores!.p1Score)) P2: \(String(scores!.p2Score)) Winner: \(scores!.winner ?? "")"
        return multiplayer
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete") {
            (action, view, completionHandler) in
            
            let itemToRemove = self.hiScores![indexPath.row]
            
            self.context.delete(itemToRemove)
            
            try! self.context.save()
            
            self.fetch_Multiplayer()
        }
        
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    //Fetch the data from Core Data to display in the tableView
    func fetch_Multiplayer() {
        do {
            self.hiScores = try context.fetch(Multiplayer.fetchRequest())
            DispatchQueue.main.async {
                self.updateTable.reloadData()
            }
        } catch {

        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateTable.dataSource = self
        updateTable.delegate = self
        self.fetch_Multiplayer()
        // Do any additional setup after loading the view.
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
