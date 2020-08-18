//
//  AllListsTableViewController.swift
//  checklists
//
//  Created by Sophie Reynolds on 2/4/19.
//  Copyright © 2019 Sophie Reynolds. All rights reserved.
//

import UIKit

class AllListsTableViewController: UITableViewController, AddListViewControllerDelegate {
    
    func addListViewControllerDidCancel(_ controller: AddListTableViewController) {
        navigationController?.popViewController(animated:true)
    }
    
    func addListViewController(_ controller: AddListTableViewController, didFinishAdding item: Checklist) {
        lists.append(item)
        let indexPath = IndexPath(row: lists.count-1, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        navigationController?.popViewController(animated:true)
    }
    
    func addListViewController(_ controller: AddListTableViewController, didFinishEditing item: Checklist) {
        if let index = lists.firstIndex(of: item)
        {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath)
            {
                let label = cell.viewWithTag(10) as! UILabel
                label.text = item.name
            }
        }
        navigationController?.popViewController(animated:true)
    }
    
    var lists = [Checklist]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let list = Checklist()
        list.name = "To Do"
        lists.append(list)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section:Int) -> Int
    {
        return lists.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let list = lists[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Checklist", for : indexPath)
        let label = cell.viewWithTag(10) as! UILabel
        label.text = list.name
    
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyly: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        lists.remove(at: indexPath.row)
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
    
    //MARK:- Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "addList"{
            let controller = segue.destination as! AddListTableViewController
            controller.delegate = self
        } else if segue.identifier == "enterList"{
            let controller = segue.destination as! ChecklistViewController
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell){
                controller.list = lists[indexPath.row]
            }
        } else if segue.identifier == "editList" {
            let controller = segue.destination as! AddListTableViewController
            controller.delegate = self
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell){
                controller.itemToEdit = lists[indexPath.row]
            }
        }
    }
    
}
