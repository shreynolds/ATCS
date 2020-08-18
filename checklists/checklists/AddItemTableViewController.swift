//
//  AddItemTableViewController.swift
//  checklists
//
//  Created by Sophie Reynolds on 1/24/19.
//  Copyright © 2019 Sophie Reynolds. All rights reserved.
//

import UIKit

protocol AddItemViewControllerDelegate: class {
    func addItemViewControllerDidCancel( _ controller: AddItemTableViewController)
    func addItemViewController (_ controller: AddItemTableViewController, didFinishAdding item: ChecklistItem)
    func addItemViewController (_ controller: AddItemTableViewController, didFinishEditing item: ChecklistItem)
}

class AddItemTableViewController: UITableViewController, UITextFieldDelegate {
   
    weak var delegate:AddItemViewControllerDelegate?
    var itemToEdit: ChecklistItem?
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let item = itemToEdit{
            title = "Edit Item"
            textField.text = item.text
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
        doneBarButton.isEnabled = false
    }
    
    //MARK:- Actions!
    @IBAction func cancel (){
        delegate?.addItemViewControllerDidCancel (self)
    }
    
    @IBAction func done (){
        if let item = itemToEdit{
            item.text = textField.text!
            delegate?.addItemViewController(self, didFinishEditing:item)
        }
        else {
            let newItem = ChecklistItem()
            newItem.text = textField.text!
            delegate?.addItemViewController(self, didFinishAdding: newItem)
        }
    }
    
    // MARK:- AI TV delegates
    override func tableView(_ tableView:UITableView, willSelectRowAt indexPath: IndexPath) ->IndexPath?{
        return nil
    }
    
    //MARK:- text Field Delegates
    func textField(_ textField:UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text!
        let stringRange = Range(range, in:oldText)!
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        
        if newText.isEmpty{
            doneBarButton.isEnabled = false
        } else {
            doneBarButton.isEnabled = true
        }
        return true
    }
}
