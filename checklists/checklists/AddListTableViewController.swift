//
//  AddListTableViewController.swift
//  checklists
//
//  Created by Sophie Reynolds on 2/4/19.
//  Copyright © 2019 Sophie Reynolds. All rights reserved.
//

import UIKit

protocol AddListViewControllerDelegate: class {
    func addListViewControllerDidCancel( _ controller: AddListTableViewController)
    func addListViewController (_ controller: AddListTableViewController, didFinishAdding item: Checklist)
    func addListViewController (_ controller: AddListTableViewController, didFinishEditing item: Checklist)
}

class AddListTableViewController: UITableViewController, UITextFieldDelegate {
    
    weak var delegate:AddListViewControllerDelegate?
    var itemToEdit: Checklist!

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let item = itemToEdit{
            title = "Edit List"
            textField.text = item.name
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
        doneBarButton.isEnabled = false
    }

    @IBAction func cancel(_ sender: Any) {
        delegate?.addListViewControllerDidCancel(self)
    }
    
    @IBAction func done(_ sender: Any) {
        if let item = itemToEdit{
            item.name = textField.text!
            delegate?.addListViewController(self, didFinishEditing:item)
        }
        else{
            let newList = Checklist()
            newList.name = textField.text!
            newList.list = []
            delegate?.addListViewController(self, didFinishAdding: newList)
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
