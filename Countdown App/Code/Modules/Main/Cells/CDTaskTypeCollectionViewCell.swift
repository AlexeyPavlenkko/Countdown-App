//
//  CDTaskTypeCollectionViewCell.swift
//  Countdown App
//
//  Created by Алексей Павленко on 27.08.2022.
//

import UIKit

class CDTaskTypeCollectionViewCell: UICollectionViewCell {

    //MARK: - Outlets
    @IBOutlet weak var imageContainerView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var cdtypeName: UILabel!
    
    //MARK: - Variables
    
    //MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        DispatchQueue.main.async {
            self.imageContainerView.layer.cornerRadius = self.imageContainerView.bounds.width / 2
        }
    }

    //MARK: - Methods
    override class func description() -> String {
        return "CDTaskTypeCollectionViewCell"
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.resetCell()
        self.imageView.image = nil
    }
    
    public func setupCell(cdtaskType: CDTaskType, isSelected: Bool) {
        self.cdtypeName.text = cdtaskType.typeName
        
        if isSelected {
            self.imageContainerView.backgroundColor = UIColor.whiteColor
            self.imageView.tintColor = UIColor.darkBlueColor
            self.cdtypeName.textColor = UIColor.whiteColor
            self.imageView.image = UIImage(systemName: cdtaskType.symbolName, withConfiguration: UIImage.SymbolConfiguration(pointSize: 24, weight: .medium))
        } else {
            self.imageView.image = UIImage(systemName: cdtaskType.symbolName, withConfiguration: UIImage.SymbolConfiguration(pointSize: 22, weight: .regular))
            resetCell()
        }
    }
    
    private func resetCell() {
        self.imageContainerView.backgroundColor = UIColor.clear
        self.imageView.tintColor = UIColor.whiteColor
        self.cdtypeName.textColor = UIColor.whiteColor
    }
}
