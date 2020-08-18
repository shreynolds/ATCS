//
//  FilterTableViewController.swift
//  Tournaments
//
//  Created by Sophie Reynolds on 4/20/19.
//  Copyright © 2019 Sophie Reynolds. All rights reserved.
//

import UIKit

protocol FilterTableDelegate: class {
    func FilterDidCancel(_ controller: FilterTableViewController)
    func FilterTableViewController (_ controller: FilterTableViewController, selected array: [String], info index: [IndexPath])
}

class FilterTableViewController: UITableViewController {

    weak var delegate: FilterTableDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        if days.count != 1{
            days.insert("All Days", at: 0)
        }
        if locations.count != 1{
            locations.insert("All Locations", at: 0)
        }
        teams.insert("All Teams", at: 0)
        tableView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        for index in selected {
            tableView.selectRow(at: index, animated: false, scrollPosition: .none)
            tableView.cellForRow(at: index)?.accessoryType = .checkmark
        }
    }
    
    var days = [String]()
    var locations = [String]()
    var teams = [String]()
    
    var selected = [IndexPath]()

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return days.count
        } else if section == 1{
            return locations.count
        } else {
            return teams.count
        }
    }
    
    override func tableView(_: UITableView, titleForHeaderInSection: Int) -> String?
    {
        if titleForHeaderInSection ==  0
        {
            return "Select Date"
        }
        else if titleForHeaderInSection == 1
        {
            return "Select Location"
        }
        else{
            return "Select Team"
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Info", for: indexPath)
        let label = cell.viewWithTag(25) as! UILabel
        if indexPath.section == 0 {
            label.text = days[indexPath.row]
        }
        else if indexPath.section == 1{
            label.text = locations[indexPath.row]
        }
        else{
            label.text = teams[indexPath.row]
        }
        
        return cell
    }
    
    //https://stackoverflow.com/questions/30274284/swift-selecting-a-cell-in-each-section
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        // Find any selected row in this section
        if let selectedIndexPath = tableView.indexPathsForSelectedRows?.first(where: {
            $0.section == indexPath.section
        }) {
            // Deselect the row
            tableView.deselectRow(at: selectedIndexPath, animated: false)
            // deselectRow doesn't fire the delegate method so need to
            // unset the checkmark here
            tableView.cellForRow(at: selectedIndexPath)?.accessoryType = .none
            selected.removeAll { $0 == selectedIndexPath }
            //https://stackoverflow.com/questions/27878798/remove-specific-array-element-equal-to-string-swift
            print(selected)

        }
        return indexPath
    }
    
    override func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
        // Prevent deselection of a cell
        return nil
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        selected.append(indexPath)
        print(selected)
    }
    
   /* override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            selected.append(indexPath)
        } else {
            tableView.deselectRow(at: indexPath, animated: false)
        }
    }
 */
    
    @IBAction func cancel(_ sender: Any) {
        delegate?.FilterDidCancel(self)
    }
    
    @IBAction func done(_ sender: Any) {
        selected.sort()
        var picked = [String]()
        for selection in selected{
            if selection[0] == 0{
                picked.append(days[selection[1]])
            }
            else if selection[0] == 1{
                picked.append(locations[selection[1]])
            } else {
                picked.append(teams[selection[1]])
            }
        }
        print(picked)
        delegate?.FilterTableViewController(self, selected: picked, info: selected)
    }

}
