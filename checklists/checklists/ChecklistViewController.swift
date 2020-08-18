//
//  ChecklistViewController.swift
//  checklists
//
//  Created by Sophie Reynolds on 1/18/19.
//  Copyright © 2019 Sophie Reynolds. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController, AddItemViewControllerDelegate {
    
    func addItemViewControllerDidCancel(_ controller: AddItemTableViewController) {
        navigationController?.popViewController(animated:true)
    }
    
    func addItemViewController(_ controller: AddItemTableViewController, didFinishAdding item: ChecklistItem) {
        list.list.append(item)
        let indexPath = IndexPath(row: list.list.count-1, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        navigationController?.popViewController(animated:true)
    }
    
    func addItemViewController(_ controller: AddItemTableViewController, didFinishEditing item: ChecklistItem){
        if let index = list.list.firstIndex(of: item)
        {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath)
            {
                let label = cell.viewWithTag(1000) as! UILabel
                label.text = item.text
            }
        }
        navigationController?.popViewController(animated:true)
    }
    
    var list: Checklist!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = list.name
    }
    
    //MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section:Int) -> Int
    {
        return list.list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let item = list.list[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for : indexPath)
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.text
        let checkmark = cell.viewWithTag(50) as! UILabel
        //this is where we will interact with that label
        if item.checked{
            checkmark.text = "✓"
        } else {
            checkmark.text = ""
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyly: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        list.list.remove(at: indexPath.row)
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
    
    @IBAction func listsBack(_ sender: Any) {
        navigationController?.popViewController(animated:true)
    }
    
    //MARK:- Table View Source
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if let cell = tableView.cellForRow(at: indexPath)
        {
            let item = list.list[indexPath.row]
            item.checked = !item.checked
            let checkmark = cell.viewWithTag(50) as! UILabel
            if item.checked{
               checkmark.text = "✓"
            } else {
                checkmark.text = ""
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK:- Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "AddItem"{
            let controller = segue.destination as! AddItemTableViewController
            controller.delegate = self
        } else if segue.identifier == "EditItem" {
            let controller = segue.destination as! AddItemTableViewController
            controller.delegate = self
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell){
                controller.itemToEdit = list.list[indexPath.row]
            }
        } 
    }
}
