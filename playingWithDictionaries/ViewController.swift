//
//  ViewController.swift
//  playingWithDictionaries
//
//  Created by Johann Kerr on 9/16/16.
//  Copyright © 2016 Johann Kerr. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var decodeButton: UIButton!
    @IBOutlet weak var encodeButton: UIButton!
    @IBOutlet weak var offsetButton: UIButton!
    
    @IBOutlet weak var msgTextField: UITextField!
    
    @IBOutlet weak var blurWindow: UIVisualEffectView!
    @IBOutlet weak var displayMessage: UILabel!
    
    var code = [String : String]()
    var alphabet = [String]()
    var newAlphabetDict = [String : String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        alphabet = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
        
        code = [
            "a" : "🐶",
            "b" : "🐱",
            "c" : "🐭",
            "d" : "🐹",
            "e" : "🐰",
            "f" : "🐻",
            "g" : "🐼",
            "h" : "🐨", // 🐨🐰🐮🐮🐸
            "i" : "🐯",
            "j" : "🦁",
            "k" : "🦁",
            "l" : "🐮",
            "m" : "🐽",
            "n" : "🐙",
            "o" : "🐸",
            "p" : "🐵",
            "q" : "🙈",
            "r" : "🙉",
            "s" : "🙊",
            "t" : "🐒",
            "u" : "🐔",
            "v" : "🐧",
            "w" : "🐦",
            "x" : "🐤",
            "y" : "🐣",
            "z" : "🐺"
        ]
        
        msgTextField.becomeFirstResponder()
        blurWindow.isHidden = true
        blurWindow.layer.cornerRadius = 5
        blurWindow.layer.masksToBounds = true
        
        decodeButton.isEnabled = false
        encodeButton.isEnabled = false
        offsetButton.isEnabled = false
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        msgTextField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
    }
    
    
    @IBAction func encodeBtn(_ sender: UIButton) {
        
        if let message = msgTextField.text {
            
            let newMsg = encodeMsg(message: message)
            
            let alert = UIAlertController(title: "Encrypted Message :", message: newMsg, preferredStyle: .alert)
            
            let action = UIAlertAction(title: "OK", style: .default , handler: {action in
                self.clearTextField()})
            
            alert.addAction(action)
            
            present(alert, animated: true, completion: nil)
            
        }
        
    }
    
    func clearTextField() {
        msgTextField.text = ""
    }
    
    func textField(_ shouldChangeCharactersIntextField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let oldText: NSString = msgTextField.text! as NSString
        let newText: NSString = oldText.replacingCharacters(in: range, with: string) as NSString
        
        encodeButton.isEnabled = (newText.length > 0)
        decodeButton.isEnabled = (newText.length > 0)
        offsetButton.isEnabled = (newText.length > 0)
        return true
    }
    
    
    
    @IBAction func decodeBtn(_ sender: UIButton) {
        
        blurWindow.isHidden = false
        blurWindow.alpha = 1.0
        _ = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.update), userInfo: nil, repeats: false)
        print(msgTextField.text)
        
        let message = decodeMsg(message: msgTextField.text)
        displayMessage.text = message
        
    }
    
    @IBAction func offsetBtn(_ sender: UIButton) {
        
        blurWindow.isHidden = false
        blurWindow.alpha = 1.0
        _ = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.update), userInfo: nil, repeats: false)
        _ = offset(offsetBy: Int(msgTextField.text!)!)
//        displayMessage.text = "New dictionary created."
        clearTextField()
        print(newAlphabetDict.sorted(by: < ))
        
    }
    
    
    func update() {
        UIView.animate(withDuration: 3.0, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {self.blurWindow.alpha = 0.0}, completion: {action in self.clearTextField()})
    }
    
    func decodeMsg(message: String?) -> String {
        var newMessage = ""
        
        if let unwrappedMessage = message {
            for char in unwrappedMessage.lowercased().characters {
                if char == " " {
                    newMessage += " "
                }
                for (key,value) in code {
                    if value == "\(char)" {
                        newMessage += key
                    }
                }
                
            }
        }
        return newMessage
        
    }
    //🐯 🐹🐸🐙🐒 🐔🐙🐹🐰🙉🙊🐒🐶🐙🐹
    
    func encodeMsg(message: String?) -> String {
        var newMessage = ""
        
        if let unwrappedMessage = message {
            for char in unwrappedMessage.lowercased().characters {
                if char == " " {
                    newMessage += " "
                }
                for (key,value) in code {
                    if key == "\(char)" {
                        newMessage += value
                    }
                }
                
            }
        }
        return newMessage
    }
    
    func offset(offsetBy: Int) -> [String : String] {
        
        var offsetDictionary = [String:String]()
        var startOnLetter = alphabet.startIndex + (offsetBy % alphabet.count)
        var indexOfFirstLetter = 0

        for x in alphabet {
            
            if startOnLetter <= (alphabet.count - 1) {
                
                offsetDictionary[x] = alphabet[startOnLetter]
                startOnLetter += 1
                
            } else {
                
                if indexOfFirstLetter <= offsetBy {
                    offsetDictionary[x] = alphabet[indexOfFirstLetter]
                    indexOfFirstLetter += 1
                }
                
            }
        }
        displayMessage.text = "New dictionary created."
        newAlphabetDict = offsetDictionary
        return newAlphabetDict
    }
    
    
}
