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
    
    //MARK: - Variables
    var cdtaskViewModel: CDTaskViewModel!
    
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.cdtaskViewModel = CDTaskViewModel()
        
        
        self.collectionView.delegate   = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib(nibName: CDTaskTypeCollectionViewCell.description(), bundle: .main), forCellWithReuseIdentifier: CDTaskTypeCollectionViewCell.description())
    }
    //MARK: - Actions & objc methods
    
    @IBAction func startButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
    }
    
    //MARK: - Methods
    
    
}

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
        collectionView.reloadData()
    }
}
