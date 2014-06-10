//
//  ViewController.swift
//  Pick For Me
//
//  Created by Kasey Schindler on 6/6/14.
//  Copyright (c) 2014 Kasey Schindler. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView
    @IBOutlet var addButton: UIButton
    @IBOutlet var resetButton: UIButton
    @IBOutlet var selectButton: UIButton
    
    var items = String[]()
    var editingOption = false
    var editingOptionRow = 0;
    var selectedView: SelectedView
    let tapGesture = UITapGestureRecognizer()
    let kCellIdentifier: String = "Cell"
    
    init(coder aDecoder: NSCoder!) {
        selectedView = SelectedView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), labelString: "")
        super.init(coder: aDecoder)
    }
    
    @IBAction func addItem() {
        var alertController = UIAlertController(title: NSLocalizedString("Add Option", comment: ""), message: nil, preferredStyle: .Alert)
        
        alertController.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .Cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: NSLocalizedString("Add", comment: ""), style: .Default, handler: {(action: UIAlertAction!) in
            // get information from textfield
            let textfield = alertController.textFields[0] as UITextField
            self.addOption(textfield.text)
            
            // this is called when "Return" is pressed too so dismiss alert controller
            alertController.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        alertController.addTextFieldWithConfigurationHandler(configurationTextField)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func configurationTextField(textField: UITextField!) {
        if editingOption {
            textField.text = items[editingOptionRow]
        }
        
        textField.returnKeyType = .Done
        textField.autocapitalizationType = .Words
        textField.becomeFirstResponder()
    }
    
    @IBAction func removeAllItems() {
        
        var indexPaths: NSIndexPath[] = []

        var count = 0
        while count < items.count {
            var indexPath = NSIndexPath(forRow: count, inSection: 0)
            indexPaths += indexPath
            count++
        }
        
        items.removeAll(keepCapacity: true)
        tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: .Fade)
    }
    
    @IBAction func pickRandomItem() {
        var totalOptions = items.count
        
        if totalOptions > 0 {
            let randomNumber = arc4random_uniform(UInt32(items.count)).hashValue
            var selectedOption = items[randomNumber]
            removeAllItems()
            animationSelectedOptionOnScreen(selectedOption)
        }
    }
    
    func animationSelectedOptionOnScreen(selectedString: String) {
        selectedView = SelectedView(frame: CGRect(x: 0, y: view.frame.size.height / 2, width: view.frame.size.width, height: 60), labelString: selectedString)
        
        // add gesture recognizer to selected view
        tapGesture.addTarget(self, action: "screenTapped")
        view.addGestureRecognizer(tapGesture)
        view.addSubview(selectedView)
        
        // animate selection on screen
        UIView.animateWithDuration(1.5, animations: {
            self.selectedView.alpha = 1.0
            var viewFrame = self.selectedView.frame
            viewFrame.origin.y /= 4
            self.selectedView.frame = viewFrame
        })
        
        // disable buttons
        addButton.enabled = false
        resetButton.enabled = false
        selectButton.enabled = false
    }
    
    func screenTapped() {
        // remove tap gesture and selection view
        view.removeGestureRecognizer(tapGesture)
    
        // now animate off screen
        UIView.animateWithDuration(1.5, animations: {
            self.selectedView.alpha = 0
            var viewFrame = self.selectedView.frame
            viewFrame.origin.y *= 4
            self.selectedView.frame = viewFrame
        })
    
        // enable buttons
        addButton.enabled = true
        resetButton.enabled = true
        selectButton.enabled = true
    }
    
    func addOption(optionString: String) {
        items.append(optionString)
        
        var row = items.count - 1
        var indexPath = NSIndexPath(forRow: row, inSection: 0)
        
        if row % 2 == 0 {
            // even
            tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Right)
        } else {
            // odd
            tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Left)
        }
    }
    
    func editOptionAtRow(row: NSInteger) {
        editingOption = true
        var alertController = UIAlertController(title: NSLocalizedString("Edit Option", comment: ""), message: nil, preferredStyle: .Alert)
        
        alertController.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .Cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: NSLocalizedString("Save", comment:""), style: .Default, handler: {(action: UIAlertAction!) in
            // get information from textfield
            let textfield = alertController.textFields[0] as UITextField
            
            //if countElements(textfield.text) > 0 {
                self.items[row] = textfield.text;
                self.tableView.reloadData()
            //}
            
            // this is called when "Return" is pressed too so dismiss alert controller
            alertController.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        alertController.addTextFieldWithConfigurationHandler(configurationTextField)
        
        editingOption = false
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell!  {
        var cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as UITableViewCell
        cell.textLabel.text = items[indexPath.row]
        
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView?) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        self.editOptionAtRow(indexPath.row)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

