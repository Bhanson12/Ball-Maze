//
//  LBTableViewController.swift
//  Ball Maze
//
//  Created by Keifer Francis on 2018-12-02.
//  Copyright © 2018 Braydon Hanson. All rights reserved.
//

import UIKit
import os.log

class LBTableViewController: UITableViewController {
    //MARK: Properties
    
    var scores = [Score]()
    var sortedScores = [Score]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Main Menu", style: .plain, target: self, action: #selector(backButtonPressed))
        
        if let savedScores = loadScores() {
            //scores.append(savedScores)
            scores += savedScores
        }
        else {
            // Load the sample data.
            loadSampleScores()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let removeDups = Array(Set(scores))
        sortedScores = removeDups.sorted(by: { $0.score > $1.score })
        
        while sortedScores.count > 10 {
            sortedScores.removeLast()
        }
        
        saveScores()
    }
    
    @objc func backButtonPressed() {
        
        SFXController.sharedSFX.playBackSound()
        self.navigationController?.popViewController(animated: true)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedScores.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "LBTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? LBTableViewCell
            else {
            fatalError("The dequeued cell is not an instance of ScoreTableViewCell.")
        }
        
        let score = sortedScores[indexPath.row]
        
        cell.userLabel.text = score.user
        cell.scoreLabel.text = String(score.score)
        
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    //MARK: Private Methods
    
    private func loadSampleScores() {
    
        guard let score1 = Score(user: "Bob", score: 1209) else {
            fatalError("Unable to instantiate score1")
        }
        
        guard let score2 = Score(user: "Jeff", score: 121) else {
            fatalError("Unable to instantiate score2")
        }
        
        guard let score3 = Score(user: "Linda", score: 302) else {
            fatalError("Unable to instantiate score3")
        }
        
        scores += [score1, score2, score3]
    }
    
    private func loadScores() -> [Score]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Score.ArchiveURL.path) as? [Score]
    }
    
    private func saveScores() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(sortedScores, toFile: Score.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Score successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save score...", log: OSLog.default, type: .error)
        }
    }
}
