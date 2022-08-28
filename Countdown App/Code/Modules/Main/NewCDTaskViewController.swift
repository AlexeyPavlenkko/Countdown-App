//
//  NewCDTaskViewController.swift
//  Countdown App
//
//  Created by Алексей Павленко on 27.08.2022.


import UIKit

class NewCDTaskViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var closeButton: UIButton!
    
    @IBOutlet weak var cdtaskNameTextField: UITextField!
    @IBOutlet weak var cdtaskDescriptionTextField: UITextField!
    
    @IBOutlet weak var hourTextField: UITextField!
    @IBOutlet weak var minutesTextField: UITextField!
    @IBOutlet weak var secondsTextField: UITextField!
    
    @IBOutlet weak var nameDescriptionContainerView: UIView!
    
    @IBOutlet weak var startButton: UIButton!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var newTaskLabelTopConstraint: NSLayoutConstraint!
    
    //MARK: - Variables
    private var cdtaskViewModel: CDTaskViewModel!
    private var keyboardOpened: Bool = false
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.cdtaskViewModel = CDTaskViewModel()
        
        self.setupCollectionView()
        self.setupCornerRadiuses()
        self.setupTextFields()
        self.disableButton()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.viewTapped(_:)))
        tapGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGesture)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //MARK: - Actions & objc methods
    
    @IBAction func startButtonPressed(_ sender: UIButton) {
        self.cdtaskViewModel.computeSeconds()
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
    }
    
    @objc func textFieldInputChanged(_ textField: UITextField) {
        guard let text = textField.text else { return }
        
        if textField == cdtaskNameTextField {
            self.cdtaskViewModel.setCDTaskName(to: text)
            
        } else if textField == cdtaskDescriptionTextField {
            self.cdtaskViewModel.setCDTaskDescription(to: text)
            
        } else if textField == hourTextField {
            guard let hours = Int(text) else {return}
            self.cdtaskViewModel.setHours(to: hours)
            
        } else if textField == minutesTextField {
            guard let minutes = Int(text) else {return}
            self.cdtaskViewModel.setMinutes(to: minutes)
            
        } else if textField == secondsTextField {
            guard let seconds = Int(text) else {return}
            self.cdtaskViewModel.setSeconds(to: seconds)
        }
        
        if cdtaskViewModel.isTaskValid() {
            self.enableButton()
        } else {
            self.disableButton()
        }
    }
    
    @objc func viewTapped(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if !Constants.hasTopNotch, !keyboardOpened {
            self.keyboardOpened = true
            self.newTaskLabelTopConstraint.constant -= self.view.frame.height * 0.2
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        self.newTaskLabelTopConstraint.constant = 20
        self.keyboardOpened = false
        self.view.layoutIfNeeded()
    }
    
    //MARK: - Methods
    
    override class func description() -> String {
        return "NewCDTaskViewController"
    }
    
    func enableButton() {
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn) {
            self.startButton.layer.opacity = 1
        } completion: { _ in
            self.startButton.isEnabled = true
        }
    }
    
    func disableButton() {
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn) {
            self.startButton.layer.opacity = 0.25
        } completion: { _ in
            self.startButton.isEnabled = false
        }
    }
    
    private func setupCollectionView() {
        self.collectionView.delegate   = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib(nibName: CDTaskTypeCollectionViewCell.description(), bundle: .main), forCellWithReuseIdentifier: CDTaskTypeCollectionViewCell.description())
    }
    
    private func setupTextFields() {
        [self.hourTextField, self.minutesTextField, self.secondsTextField].forEach { textField in
            textField?.attributedPlaceholder = NSAttributedString(string: "00", attributes: [
                NSAttributedString.Key.font : UIFont.systemFont(ofSize: 54, weight: .bold),
                NSAttributedString.Key.foregroundColor : UIColor.superLightBlueColor
            ])
            textField?.delegate = self
            textField?.addTarget(self, action: #selector(textFieldInputChanged(_:)), for: .editingChanged)
        }
        
        self.cdtaskViewModel.getHours().bind { [weak self] hours in
            self?.hourTextField.text = hours.appendZeros()
        }
        
        self.cdtaskViewModel.getMinutes().bind { [weak self] minutes in
            self?.minutesTextField.text = minutes.appendZeros()
        }
        
        self.cdtaskViewModel.getSeconds().bind { [weak self] seconds in
            self?.secondsTextField.text = seconds.appendZeros()
        }
        
        self.cdtaskNameTextField.attributedPlaceholder = NSAttributedString(string: "Task Name", attributes: [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium),
            NSAttributedString.Key.foregroundColor : UIColor.superLightBlueColor
        ])
        cdtaskNameTextField?.addTarget(self, action: #selector(textFieldInputChanged(_:)), for: .editingChanged)
        
        self.cdtaskDescriptionTextField.attributedPlaceholder = NSAttributedString(string: "Short Description", attributes: [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium),
            NSAttributedString.Key.foregroundColor : UIColor.superLightBlueColor
        ])
        cdtaskDescriptionTextField?.addTarget(self, action: #selector(textFieldInputChanged(_:)), for: .editingChanged)
    }
    
    private func setupCornerRadiuses() {
        self.nameDescriptionContainerView.layer.cornerRadius = 10
        self.startButton.layer.cornerRadius = 10
    }
    
}

//MARK: - UITextFieldDelegate

extension NewCDTaskViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLenght = 2
        
        let currentText: NSString = (textField.text ?? "") as NSString
        let newString: NSString = currentText.replacingCharacters(in: range, with: string) as NSString
        
        guard let text = textField.text else { return false }
        
        if text.count == 2 && text.starts(with: "0") {
            textField.text?.removeFirst()
            textField.text? += string
            self.textFieldInputChanged(textField)
        }
        
        return newString.length <= maxLenght
    }
    
}

//MARK: - UICollectionViewDataSource

extension NewCDTaskViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cdtaskViewModel.getTaskTypes().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CDTaskTypeCollectionViewCell.description(), for: indexPath) as? CDTaskTypeCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let isSelected = self.cdtaskViewModel.getSelectedIndex() == indexPath.row
        let cdtype = self.cdtaskViewModel.getTaskTypes()[indexPath.row]
        
        cell.setupCell(cdtaskType: cdtype, isSelected: isSelected)
        
        return cell
    }
    
}

//MARK: - UICollectionViewDelegateFlowLayout

extension NewCDTaskViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let colums: CGFloat = 3.75
        let width: CGFloat = collectionView.frame.width
        
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let adjustedWidth = width - (flowLayout.minimumLineSpacing * (colums - 1))
        
        return CGSize(width: (adjustedWidth / colums), height: self.collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.cdtaskViewModel.setSelectedIndex(to: indexPath.row)
        collectionView.reloadSections(IndexSet(0..<1))
        if cdtaskViewModel.isTaskValid() {
            self.enableButton()
        }
    }
}
