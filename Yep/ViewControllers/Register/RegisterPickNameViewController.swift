//
//  RegisterPickNameViewController.swift
//  Yep
//
//  Created by NIX on 15/3/16.
//  Copyright (c) 2015年 Catch Inc. All rights reserved.
//

import UIKit
import Ruler

class RegisterPickNameViewController: BaseViewController {

    @IBOutlet weak var pickNamePromptLabel: UILabel!
    @IBOutlet weak var pickNamePromptLabelTopConstraint: NSLayoutConstraint!

    @IBOutlet weak var promptTermsLabel: UILabel!

    @IBOutlet weak var nameTextField: BorderTextField!
    @IBOutlet weak var nameTextFieldTopConstraint: NSLayoutConstraint!
    
    lazy var nextButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: NSLocalizedString("Next", comment: ""), style: .Plain, target: self, action: "next:")
        return button
        }()

    var isDirty = false {
        willSet {
            nextButton.enabled = newValue
            promptTermsLabel.alpha = newValue ? 1.0 : 0.5
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        animatedOnNavigationBar = false

        navigationItem.titleView = NavigationTitleLabel(title: NSLocalizedString("Sign up", comment: ""))

        navigationItem.rightBarButtonItem = nextButton

        pickNamePromptLabel.text = NSLocalizedString("What's your name?", comment: "")

        let text = NSLocalizedString("By tap Next you agree to our terms.", comment: "")
        let textAttributes: [NSObject: AnyObject] = [
            NSFontAttributeName: UIFont.systemFontOfSize(14),
            NSForegroundColorAttributeName: UIColor.grayColor(),
        ]
        var attributedText = NSMutableAttributedString(string: text, attributes: textAttributes)
        let termsAttributes: [NSObject: AnyObject] = [
            NSForegroundColorAttributeName: UIColor.yepTintColor(),
            NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue,
        ]
        let tapRange = (text as NSString).rangeOfString(NSLocalizedString("terms", comment: ""))
        attributedText.addAttributes(termsAttributes, range: tapRange)

        promptTermsLabel.attributedText = attributedText
        promptTermsLabel.textAlignment = .Center
        promptTermsLabel.alpha = 0.5

        promptTermsLabel.userInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: "tapTerms")
        promptTermsLabel.addGestureRecognizer(tap)

        nameTextField.delegate = self
        nameTextField.addTarget(self, action: "textFieldDidChange:", forControlEvents: .EditingChanged)

        pickNamePromptLabelTopConstraint.constant = Ruler.match(.iPhoneHeights(30, 50, 60, 60))
        nameTextFieldTopConstraint.constant = Ruler.match(.iPhoneHeights(30, 40, 50, 50))
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        nextButton.enabled = false
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        //nameTextField.becomeFirstResponder()
    }

    // MARK: Actions

    func tapTerms() {
        UIApplication.sharedApplication().openURL(NSURL(string: "http://soyep.com/privacy")!)
    }

    func textFieldDidChange(textField: UITextField) {
        isDirty = !textField.text.isEmpty
    }

    func next(sender: UIBarButtonItem) {
        showRegisterPickMobile()
    }

    private func showRegisterPickMobile() {
        let nickname = nameTextField.text.trimming(.WhitespaceAndNewline)
        YepUserDefaults.nickname.value = nickname

        performSegueWithIdentifier("showRegisterPickMobile", sender: nil)
    }
}

extension RegisterPickNameViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if !textField.text.isEmpty {
            showRegisterPickMobile()
        }

        return true
    }
}

