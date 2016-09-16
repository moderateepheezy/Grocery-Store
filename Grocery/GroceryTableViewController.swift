//
//  GroceryTableViewController.swift
//  Grocery
//
//  Created by SimpuMind on 9/15/16.
//  Copyright © 2016 SimpuMind. All rights reserved.
//

import UIKit
import CoreData

let persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "Grocery")
    container.loadPersistentStores { storeDescription, error in
        if let error = error as NSError? {
            fatalError("Unresolved error \(error), \(error.userInfo)")
        }
    }
    return container
}()


class GroceryTableViewController: UITableViewController {

    var groceries: [Grocery] = []
    
    @IBAction func addAction(_ sender: UIBarButtonItem){
        
        let alertController = UIAlertController(title: "Add Grocery", message: "", preferredStyle: .alert)
        
        alertController.addTextField(configurationHandler: nil)
        alertController.addAction(UIAlertAction(title: "Add", style: .default) { [weak self] action in
            let text = alertController.textFields?.first?.text ?? ""
            self?.create(body: text)
            self?.fetch()
        })
        
        present(alertController, animated: true)
    }
    
    func fetch() {
        let request: NSFetchRequest<Grocery> = Grocery.fetchRequest()
        request.returnsObjectsAsFaults = false
        request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        
        let asyncRequest = NSAsynchronousFetchRequest<Grocery>(fetchRequest: request) { result in
            self.groceries = result.finalResult ?? []
            self.tableView.reloadData()
        }
        
        try! persistentContainer.viewContext.execute(asyncRequest)
    }
    
    func create(body: String) {
        let context = persistentContainer.viewContext
        let grocery = NSEntityDescription.insertNewObject(forEntityName: "Grocery", into: context) as! Grocery
        grocery.item = body
        grocery.createdAt = NSDate()
        
        try! context.save()
    }
    
    func delete(at index: Int) {
        let context = persistentContainer.viewContext
        let grocery = groceries.remove(at: index)
        
        context.delete(grocery)
        
        try! context.save()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetch()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        
        let grocery = groceries[indexPath.row]
        cell.textLabel!.text = grocery.item
         if let grocDate = grocery.createdAt{
             cell.detailTextLabel!.text = String(describing: grocDate)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            delete(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        default:
            break
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groceries.count
    }
}

