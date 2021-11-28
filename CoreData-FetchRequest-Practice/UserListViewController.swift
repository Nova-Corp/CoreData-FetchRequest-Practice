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
    lazy var searchBar = UISearchBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUsers()
        setupNavigationBar()
    }
    
    func setupNavigationBar() {
        tableView.tableFooterView = UIView()
        searchBar.delegate = self
        let addUserBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"),
                                                   style: .plain,
                                                   target: self,
                                                   action: #selector(addButtonTapped))
        addUserBarButtonItem.tintColor = .link
        let userSearchBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"),
                                                   style: .plain,
                                                   target: self,
                                                   action: #selector(searchButtonTapped))
        userSearchBarButtonItem.tintColor = .link
        let barButtonItems = [addUserBarButtonItem, userSearchBarButtonItem]
        navigationItem.rightBarButtonItems = barButtonItems
    }
    
    @objc func searchButtonTapped(_ sender: UIBarButtonItem) {
        navigationItem.rightBarButtonItems = nil
        navigationItem.titleView = searchBar
        searchBar.showsCancelButton = true
    }
    
    func fetchUsers(name: String? = nil) {
        let userFetchRequest: NSFetchRequest = UsersEntity.fetchRequest()
        if let name = name {
            let predicate = NSPredicate(format: "name contains[c] %@", name)
            userFetchRequest.predicate = predicate
        }
        if let users = try? managedContext.fetch(userFetchRequest) {
            self.users = users
            tableView.reloadData()
        }
    }
    
    @objc func addButtonTapped(_ sender: UIBarButtonItem) {
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

extension UserListViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        navigationItem.titleView = nil
        setupNavigationBar()
        fetchUsers()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchText.isEmpty ? fetchUsers() : fetchUsers(name: searchText)
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
