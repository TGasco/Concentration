//
//  HiScores.swift
//  Concentration
//
//  Created by Thomas Gascoyne on 29/11/2020.
//

import UIKit
import CoreData
class HiScores: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var navBar: UINavigationBar!
    
    @IBOutlet weak var updateTable: UITableView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var hiScores: [Hi_Scores]?
    
    override func viewWillAppear(_ animated: Bool) {
        self.updateTable.isHidden = false
        }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.hiScores?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let singleplayer = UITableViewCell(style: UITableViewCell.CellStyle.default,
                                                      reuseIdentifier: "singleplayer")
        
        let scores = self.hiScores?[indexPath.row]
        
        singleplayer.textLabel?.text = "Score: \(String(scores!.turns))          Time \(String(scores!.timeElapsed))sec"
        return singleplayer
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete") {
            (action, view, completionHandler) in
            
            let itemToRemove = self.hiScores![indexPath.row]
            
            self.context.delete(itemToRemove)
            
            try! self.context.save()
            
            self.fetch_Hi_Scores()
        }
        
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    //Fetch the data from Core Data to display in the tableView
    func fetch_Hi_Scores() {
        do {
            let request = Hi_Scores.fetchRequest() as NSFetchRequest<Hi_Scores>
            //Filtering core data
            
            self.hiScores = try context.fetch(Hi_Scores.fetchRequest())
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
        self.fetch_Hi_Scores()
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
