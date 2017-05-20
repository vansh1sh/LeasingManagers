//
//  LocationViewController.swift
//  ChatChat
//
//  Created by Vansh Badkul on 20/05/17.
//  Copyright © 2017 Razeware LLC. All rights reserved.
//

import UIKit
import DropDown

class LocationViewController: UIViewController {
    @IBOutlet weak var chooseArticleButton: UIButton!

    @IBOutlet weak var text: UITextField!

    let chooseArticleDropDown = DropDown()
    let textField = UITextField()

    lazy var dropDowns: [DropDown] = {
        return [
            self.chooseArticleDropDown
            ]
    }()
    
    

    @IBAction func chooseArticle(_ sender: Any) {
        
        chooseArticleDropDown.show()

    }

    
    
    func setupDefaultDropDown() {
        DropDown.setupDefaultAppearance()
        
        dropDowns.forEach {
            $0.cellNib = UINib(nibName: "DropDownCell", bundle: Bundle(for: DropDownCell.self))
            $0.customCellConfiguration = nil
        }
    }
    
    func customizeDropDown(_ sender: AnyObject) {
        let appearance = DropDown.appearance()
        
        appearance.cellHeight = 60
        appearance.backgroundColor = UIColor(white: 1, alpha: 1)
        appearance.selectionBackgroundColor = UIColor(red: 0.6494, green: 0.8155, blue: 1.0, alpha: 0.2)
        //		appearance.separatorColor = UIColor(white: 0.7, alpha: 0.8)
        appearance.cornerRadius = 10
        appearance.shadowColor = UIColor(white: 0.6, alpha: 1)
        appearance.shadowOpacity = 0.9
        appearance.shadowRadius = 25
        appearance.animationduration = 0.25
        appearance.textColor = .darkGray
        //		appearance.textFont = UIFont(name: "Georgia", size: 14)
        
        dropDowns.forEach {
            /*** FOR CUSTOM CELLS ***/
            $0.cellNib = UINib(nibName: "MyCell", bundle: nil)
            
            $0.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
                guard let cell = cell as? MyCell else { return }
                
                // Setup your custom UI components
                cell.suffixLabel.text = "Suffix \(index)"
            }
            /*** ---------------- ***/
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDropDowns()
        dropDowns.forEach { $0.dismissMode = .onTap }
        dropDowns.forEach { $0.direction = .any }
        
        view.addSubview(textField)
        // Do any additional setup after loading the view.
    }
    func setupDropDowns() {
        setupChooseArticleDropDown()
           }
    
    func setupChooseArticleDropDown() {
        chooseArticleDropDown.anchorView = chooseArticleButton
        
        // Will set a custom with instead of anchor view width
        //		dropDown.width = 100
        
        // By default, the dropdown will have its origin on the top left corner of its anchor view
        // So it will come over the anchor view and hide it completely
        // If you want to have the dropdown underneath your anchor view, you can do this:
        chooseArticleDropDown.bottomOffset = CGPoint(x: 0, y: chooseArticleButton.bounds.height)
        
        // You can also use localizationKeysDataSource instead. Check the docs.
        chooseArticleDropDown.dataSource = [
            "iPhone SE | Black | 64G",
            "Samsung S7",
            "Huawei P8 Lite Smartphone 4G",
            "Asus Zenfone Max 4G",
            "Apple Watwh | Sport Edition"
        ]
        
        // Action triggered on selection
        chooseArticleDropDown.selectionAction = { [unowned self] (index, item) in
            //self.chooseArticleButton.setValue(item, for: .normal)
        }
        
        // Action triggered on dropdown cancelation (hide)
        //		dropDown.cancelAction = { [unowned self] in
        //			// You could for example deselect the selected item
        //			self.dropDown.deselectRowAtIndexPath(self.dropDown.indexForSelectedRow)
        //			self.actionButton.setTitle("Canceled", forState: .Normal)
        //		}
        
        // You can manually select a row if needed
        //		dropDown.selectRowAtIndex(3)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
