//
//  CollectionViewCell.swift
//  myTestTask
//
//  Created by Владимир Курганов on 22.06.2023.
//

import UIKit

//MARK: - CollectionViewCustomCell
final class BannerCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Properties
    static let identifier = "BannerCollectionViewCell"
    
     var pictureImage: UIImageView = {
       let pictureImage = UIImageView()
         pictureImage.image = UIImage(imageLiteralResourceName: "Баннер")
        pictureImage.layer.cornerRadius = 10
        pictureImage.clipsToBounds = true
        pictureImage.contentMode = .scaleAspectFill
       return pictureImage
    }()
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .white
        setupLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Methods
    private func setupLabel() {
        addSubview(pictureImage)
        pictureImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pictureImage.topAnchor.constraint(equalTo: topAnchor),
            pictureImage.bottomAnchor.constraint(equalTo: bottomAnchor),
            pictureImage.rightAnchor.constraint(equalTo: rightAnchor),
            pictureImage.leftAnchor.constraint(equalTo: leftAnchor)
        ])
    }
}
