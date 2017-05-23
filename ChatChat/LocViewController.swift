//
//  LocViewController.swift
//  ChatChat
//
//  Created by Vansh Badkul on 20/05/17.
//  Copyright © 2017 Razeware LLC. All rights reserved.
//


import UIKit
import Firebase

class LocViewController: UIViewController,GIDSignInUIDelegate {

    @IBOutlet weak var countriesTextField: UITextField!
    @IBOutlet weak var autocompleteContainerView: UIView!
    @IBOutlet weak var lblSelectedCountryName: UILabel!
    
    var autoCompleteViewController: AutoCompleteViewController!
    
    var uid: String? = UserDefaults.standard.value(forKey: "user_id") as? String
    
    var senderDisplayName: String? = UserDefaults.standard.value(forKey: "user_name") as? String
    var email: String? = UserDefaults.standard.value(forKey: "user_email") as? String
    

    let countriesList = countries
    var isFirstLoad: Bool = true
    
    private var channelRefHandle: FIRDatabaseHandle?
    private var channels: [Channel] = []
    
    var channelRef: FIRDatabaseReference = FIRDatabase.database().reference().child("user_profiles")

    @IBOutlet weak var crea: UIButton!
    @IBAction func crea(_ sender: AnyObject) {
    
        if let name = lblSelectedCountryName?.text {
            let newChannelRef = channelRef.child(uid!)
            let channelItem = [
                "name":senderDisplayName,
                "email":email,
                "location": lblSelectedCountryName.text
            ]
            
        newChannelRef.setValue(channelItem)
            
        }
        self.performSegue(withIdentifier: "chatView", sender: nil)

        
        }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if self.isFirstLoad {
            self.isFirstLoad = false
            Autocomplete.setupAutocompleteForViewcontroller(self)
        }
    }
}

extension LocViewController: AutocompleteDelegate {
    func autoCompleteTextField() -> UITextField {
        return self.countriesTextField
    }
    func autoCompleteThreshold(_ textField: UITextField) -> Int {
        return 1
    }
    
    func autoCompleteItemsForSearchTerm(_ term: String) -> [AutocompletableOption] {
        let filteredCountries = self.countriesList.filter { (country) -> Bool in
            return country.lowercased().contains(term.lowercased())
        }
        
        let countriesAndFlags: [AutocompletableOption] = filteredCountries.map { ( country) -> AutocompleteCellData in
            var country = country
            country.replaceSubrange(country.startIndex...country.startIndex, with: String(country.characters[country.startIndex]).capitalized)
            return AutocompleteCellData(text: country, image: UIImage(named: "USA"))
            }.map( { $0 as AutocompletableOption })
        
        return countriesAndFlags
    }
    
    func autoCompleteHeight() -> CGFloat {
        return self.view.frame.height / 3.0
    }
    
    
    func didSelectItem(_ item: AutocompletableOption) {
        self.lblSelectedCountryName.text = item.text
        UserDefaults.standard.setValue(lblSelectedCountryName.text, forKey: "user_location")

    }
}
