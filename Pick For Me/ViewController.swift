//
//  ViewController.swift
//  Pick For Me
//
//  Created by Kasey Schindler on 6/6/14.
//  Copyright (c) 2014 Kasey Schindler. All rights reserved.
//

import UIKit
import Foundation

final class ViewController: UIViewController {
    
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var addButton: UIButton!
    @IBOutlet private var resetButton: UIButton!
    @IBOutlet private var selectButton: UIButton!
    
    private var items = [String]()
    private var editingOption = false
    private var editingOptionRow = 0
    private var selectedView = SelectedView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), labelString: "")
    private let tapGesture = UITapGestureRecognizer()
    private let kCellIdentifier: String = "Cell"
    
    @IBAction private func addItem() {
//        let alertController = UIAlertController(title: NSLocalizedString("Add Option", comment: ""), message: nil, preferredStyle: .alert)
//        alertController.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil))
//        alertController.addAction(UIAlertAction(title: NSLocalizedString("Add", comment: ""), style: .default, handler: {(action: UIAlertAction) in
//            // get information from textfield
//            let textfield = alertController.textFields![0] as UITextField
//            self.addOption(optionString: textfield.text!)
//            
//            // this is called when "Return" is pressed too so dismiss alert controller
//            alertController.dismiss(animated: true, completion: nil)
//        }))
//        
//        alertController.addTextField(configurationHandler: configurationTextField)
//        
//        present(alertController, animated: true, completion: nil)
    }
    
    func configurationTextField(textField: UITextField!) {
        if editingOption {
            textField.text = items[editingOptionRow]
        }
        
        textField.returnKeyType = .done
        textField.autocapitalizationType = .words
        textField.becomeFirstResponder()
    }
    
    @IBAction func removeAllItems() {
        var indexPaths = [IndexPath]()

        var count = 0
        while count < items.count {
            let indexPath = IndexPath(row: count, section: 0)
            indexPaths.append(indexPath)
            count += 1
        }
        
        items.removeAll()
        tableView.deleteRows(at: indexPaths, with: .fade)
    }
    
    @IBAction func pickRandomItem() {
        let totalOptions = items.count
        
        if totalOptions > 0 {
            let randomNumber = Int.random(in: 0..<totalOptions)
            let selectedOption = items[randomNumber]
            removeAllItems()
            animationSelectedOptionOnScreen(selectedString: selectedOption)
        }
    }
    
    func animationSelectedOptionOnScreen(selectedString: String) {
        selectedView = SelectedView(frame: CGRect(x: 0, y: view.frame.size.height / 2, width: view.frame.size.width, height: 60), labelString: selectedString)
        
        // add gesture recognizer to selected view
        tapGesture.addTarget(self, action: #selector(screenTapped))
        view.addGestureRecognizer(tapGesture)
        view.addSubview(selectedView)
        
        // animate selection on screen
        UIView.animate(withDuration: 1.5, animations: {
            self.selectedView.alpha = 1.0
            var viewFrame = self.selectedView.frame
            viewFrame.origin.y /= 4
            self.selectedView.frame = viewFrame
        })
        
        // disable buttons
        addButton.isEnabled = false
        resetButton.isEnabled = false
        selectButton.isEnabled = false
    }
    
    @objc func screenTapped() {
        // remove tap gesture and selection view
        view.removeGestureRecognizer(tapGesture)
    
        // now animate off screen
        UIView.animate(withDuration: 1.5, animations: {
            self.selectedView.alpha = 0
            var viewFrame = self.selectedView.frame
            viewFrame.origin.y *= 4
            self.selectedView.frame = viewFrame
        })
    
        // enable buttons
        addButton.isEnabled = true
        resetButton.isEnabled = true
        selectButton.isEnabled = true
    }
    
    func addOption(optionString: String) {
        items.append(optionString)
        
        let row = items.count - 1
        let indexPath = IndexPath(row: row, section: 0)
        
        if row % 2 == 0 {
            // even
            tableView.insertRows(at: [indexPath], with: .right)
        } else {
            // odd
            tableView.insertRows(at: [indexPath], with: .left)
        }
    }
    
    func editOptionAtRow(row: NSInteger) {
        editingOption = true
        let alertController = UIAlertController(title: NSLocalizedString("Edit Option", comment: ""), message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: NSLocalizedString("Save", comment:""), style: .default, handler: {(action: UIAlertAction) in
            // get information from textfield
            let textfield = alertController.textFields![0] as UITextField
            
            self.items[row] = textfield.text!;
            self.tableView.reloadData()
            
            // this is called when "Return" is pressed too so dismiss alert controller
            alertController.dismiss(animated: true, completion: nil)
        }))
        
        alertController.addTextField(configurationHandler: configurationTextField)
        
        editingOption = false
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNeedsStatusBarAppearanceUpdate()
    }
}

// MARK: - UITableView Delegate & Data Source

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kCellIdentifier)! as UITableViewCell
        cell.textLabel!.text = items[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.editOptionAtRow(row: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

