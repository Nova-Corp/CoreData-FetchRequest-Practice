//
//  UserListViewController.swift
//  CoreData-FetchRequest-Practice
//
//  Created by Mac on 26/11/21.
//

import UIKit
import CoreData

class UserListViewController: UITableViewController {

    var users = [UsersEntity]()
    
    @IBAction func searchButtonTapped(_ sender: UIBarButtonItem) {
    
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
    
    }
}

extension UserListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { users.count }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserListTableViewCell", for: indexPath)
        cell.textLabel?.text = users[indexPath.row].name as? String
        return cell
    }
}
