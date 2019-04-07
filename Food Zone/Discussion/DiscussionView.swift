import UIKit
import FirebaseDatabase
import Firebase
import IQKeyboardManagerSwift


class DiscussionView: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sendButton: UIButton!
    
    var restaurantName = "Taco Bell"
    var place: String?
    
    
    let mapView = MapView()
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        
        let message = messages[indexPath.row]
        cell.textLabel?.text = message.text
        cell.detailTextLabel?.text = message.timeStamp
        
        return cell
    }
    
    
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sendButton.isEnabled = false
        sendButton.tintColor = UIColor.gray
        
        tableView.delegate = self
        tableView.dataSource = self
        
        textField.delegate = self
        
        self.place = mapView.place
        
        observeMessages()
        
        
    }
    
    var messages = [Message]()
    
    func observeMessages(){
        let ref = Database.database().reference().child(restaurantName).child("messages")
        
        ref.observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String:Any]{
                
                let message = Message()
                
                message.setValuesForKeys(dictionary)
                self.messages.append(message)
                self.tableView.reloadData()
            }
            
        }, withCancel: nil)
    }
    
    
    @IBAction func textDidChange(_ sender: Any) {
        if textField.text!.count == 0 {
            sendButton.isEnabled = false
            sendButton.tintColor = UIColor.gray
        }else if textField.text != nil {
            sendButton.isEnabled = true
            sendButton.tintColor = UIColor.blue
        }
    }
    
    @IBAction func handleSend(_ sender: Any) {
        
        let ref = Database.database().reference().child(restaurantName).child("messages")
        let childRef = ref.childByAutoId()
        //current date
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let formattedDate = format.string(from: date)
        //////////
        let values:[String:Any] = ["text":textField.text!, "timeStamp":formattedDate]
        childRef.updateChildValues(values)
        textField.text = ""
    }
    
    
}
