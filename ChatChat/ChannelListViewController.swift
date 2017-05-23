/*
 * Copyright (c) 2015 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit
import Firebase
import GoogleSignIn


enum Section: Int {
  case createNewChannelSection = 0
  case currentChannelsSection
}

class ChannelListViewController: UITableViewController , GIDSignInUIDelegate{


    
  var senderDisplayName: String? = UserDefaults.standard.value(forKey: "user_name") as? String
    var userlocation: String? = UserDefaults.standard.value(forKey: "user_location") as? String
    
    
    var newChannelTextField: UITextField?
    var checkUser="Vansh"
    let a = 2
  
  private var channelRefHandle: FIRDatabaseHandle?
  private var channels: [Channel] = []

    var channelRef: FIRDatabaseReference = FIRDatabase.database().reference().child("channels")

    @IBAction func logout(_ sender: Any) {
        GIDSignIn.sharedInstance().signOut()
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
        

    }
    
    

  // MARK: View Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = userlocation

    UINavigationBar.appearance().barTintColor = UIColor.init(red: 14/255, green: 34/255, blue: 59/255, alpha: 2.0)
    


    
    if userlocation=="449 Palo Verde Road, Gainesville, FL"{
        channelRef = FIRDatabase.database().reference().child("channels1")
    }
    if userlocation=="6731 Thompson Street, Gainesville, FL"{
        channelRef = FIRDatabase.database().reference().child("channels2")
    }
    if userlocation=="8771 Thomas Boulevard, Orlando, FL"{
        channelRef = FIRDatabase.database().reference().child("channels3")
    }
    if userlocation=="1234 Verano Place, Orlando, FL"{
        channelRef = FIRDatabase.database().reference().child("channels4")
    }
    observeChannels()
  }
  
  deinit {
    if let refHandle = channelRefHandle {
      channelRef.removeObserver(withHandle: refHandle)
    }
  }
  
  // MARK :Actions
  
  @IBAction func createChannel(_ sender: AnyObject) {
    if let name = newChannelTextField?.text {
      let newChannelRef = channelRef.childByAutoId()
      let channelItem = [
        "name": name
      ]
        if !(name.isEmpty){
        let alert = UIAlertController(title: "Success", message: "Discussion thread created", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        
            newChannelTextField?.text=""
        }
        
        if name.isEmpty{
            let alert = UIAlertController(title: "Failed", message: "Title could not be empty, try again.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
      newChannelRef.setValue(channelItem)
    }    
  }
  
  // MARK: Firebase related methods

  private func observeChannels() {
    // We can use the observe method to listen for new
    // channels being written to the Firebase DB
    channelRefHandle = channelRef.observe(.childAdded, with: { (snapshot) -> Void in
      let channelData = snapshot.value as! Dictionary<String, AnyObject>
      let id = snapshot.key
      if let name = channelData["name"] as! String!, name.characters.count > 0 {
        self.channels.append(Channel(id: id, name: name))
        self.tableView.reloadData()
        
      } else {
        
        print("Error! Could not decode channel data")
       

      }
    })
  }
  
  // MARK: Navigation
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    super.prepare(for: segue, sender: sender)
    
    if let channel = sender as? Channel {
      let chatVc = segue.destination as! ChatViewController
      
      chatVc.senderDisplayName = senderDisplayName
      chatVc.channel = channel
      chatVc.channelRef = channelRef.child(channel.id)
    }
  }
  
  // MARK: UITableViewDataSource
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let currentSection: Section = Section(rawValue: section) {
      switch currentSection {
      case .createNewChannelSection:
        return 1
      case .currentChannelsSection:
        return channels.count
      }
    } else {
      return 0
    }
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let reuseIdentifier = (indexPath as NSIndexPath).section == Section.createNewChannelSection.rawValue ? "NewChannel" : "ExistingChannel"
    let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)

    if (indexPath as NSIndexPath).section == Section.createNewChannelSection.rawValue {
      if let createNewChannelCell = cell as? CreateChannelCell {
        newChannelTextField = createNewChannelCell.newChannelNameField
      }
    } else if (indexPath as NSIndexPath).section == Section.currentChannelsSection.rawValue {
      cell.textLabel?.text = channels[(indexPath as NSIndexPath).row].name
    }
    
    return cell
  }

  // MARK: UITableViewDelegate
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if (indexPath as NSIndexPath).section == Section.currentChannelsSection.rawValue {
      let channel = channels[(indexPath as NSIndexPath).row]
      self.performSegue(withIdentifier: "ShowChannel", sender: channel)
    }
  }
  
}
