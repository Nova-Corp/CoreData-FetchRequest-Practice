//
//  UserListViewController.swift
//  CoreData-FetchRequest-Practice
//
//  Created by Mac on 26/11/21.
//

import UIKit
import CoreData

class UserListViewController: UITableViewController {
    
    let managedContext: NSManagedObjectContext = {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate?.persistentContainer.viewContext
        return managedContext!
    }()

    var users = [UsersEntity]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUsers()
    }
    
    @IBAction func searchButtonTapped(_ sender: UIBarButtonItem) {
    
    }
    
    func fetchUsers() {
        let userFetchRequest: NSFetchRequest = UsersEntity.fetchRequest()
        if let users = try? managedContext.fetch(userFetchRequest) {
            self.users = users
            tableView.reloadData()
        }
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        let alertController = UIAlertController(title: "Add New Name",
                                                message: "",
                                                preferredStyle: UIAlertController.Style.alert)
        alertController.addTextField { textField -> Void in
            textField.placeholder = "Enter the name"
        }
        let saveAction = UIAlertAction(title: "Save", style: UIAlertAction.Style.default) { [self] alert -> Void in
            let nameTextField = alertController.textFields![0] as UITextField
            let userEntity = UsersEntity(context: managedContext)
            userEntity.name = nameTextField.text
            try? managedContext.save()
            fetchUsers()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default)
        
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        
        present(alertController, animated: true, completion: nil)
    }
}

extension UserListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { users.count }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserListTableViewCell", for: indexPath)
        cell.textLabel?.text = users[indexPath.row].name
        return cell
    }
}
