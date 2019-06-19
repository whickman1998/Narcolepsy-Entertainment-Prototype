//
//  EntertainmentViewController.swift
//  Nudge
//
//  Created by William Hickman on 5/26/19.
//  Copyright © 2019 William Hickman Ent. All rights reserved.
//

import UIKit
import Firebase
import CodableFirebase

class EntertainmentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var mediaList = [Media]()
    var ref: DatabaseReference? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ref = Database.database().reference(withPath: "Media")
        downloadFirebaseData(completion: { (success) -> Void in
            if success {
                self.tableView.reloadData()
            }
        })
        
        self.navigationController?.topViewController?.navigationItem.title = "Entertainment"
    }
    
    //MARK: - Firebase
    
    func downloadFirebaseData(completion: @escaping (_ success: Bool) -> Void) {
        ref?.observeSingleEvent(of: .value, with: { snapshot in
            guard let value = snapshot.value else {
                return
            }
            if let medias = value as? [[String:Any]] {
                print("got medias")
                for value in medias {
                    self.mediaList.append(Media(title: value["title"] as! String, stringAddress: value["stringAddress"] as! String, type: value["type"] as! String, minutes: value["minutes"] as! Int, seconds: value["seconds"] as! Int, genre: value["genre"] as! String))
                }
            }
            else {
                print("error: can't find medias")
            }
            completion(true)
        })
    }
    
    //MARK: - TableView DataSource Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mediaList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Media", for: indexPath) as? MediaCell
        
        let media = mediaList[indexPath.row]
        
        cell!.titleLabel.text = media.title
        var seconds = "0\(media.seconds)"
        if (media.seconds > 9) {
            seconds = String(media.seconds)
        }
        cell!.timeLabel.text = "Length - \(media.minutes):\(seconds)"
        cell!.genreLabel.text = "Genre: \(media.genre)"
        cell!.icon.image = UIImage(named: "\(media.genre).png")
        
        return cell!
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destVC = segue.destination as? MediaViewController {
            let selectedIndexPath = tableView.indexPathForSelectedRow
            destVC.media = mediaList[(selectedIndexPath?.row)!]
        }
    }

}
