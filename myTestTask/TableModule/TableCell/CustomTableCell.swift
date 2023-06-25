//
//  Cell.swift
//  myTestTask
//
//  Created by Владимир Курганов on 22.06.2023.
//

import UIKit

//MARK: - Constants
fileprivate enum Constants {
    static let labelFontSize: CGFloat = 20.0
    static let labelNumberOfLines = 0
    static let imagCornerRadius: CGFloat = 60.0
    static let labelTopAnchor: CGFloat = 30.0
    static let constraint: CGFloat = 10.0
    static let imageSize: CGFloat = 120
}

//MARK: - CustomCell
final class CustomCell: UITableViewCell {
    
    //MARK: - Properties
    lazy var descriptionLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.numberOfLines = Constants.labelNumberOfLines
        nameLabel.font = .systemFont(ofSize: Constants.labelFontSize)
        nameLabel.textColor = .black
        return nameLabel
    }()
    
    lazy var photoImageView: UIImageView = {
        let photoImageView = UIImageView()
        photoImageView.contentMode = .scaleAspectFill
        photoImageView.layer.cornerRadius = Constants.imagCornerRadius
        photoImageView.layer.masksToBounds = true
        return photoImageView
    }()
    
    //MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Methods
    override func prepareForReuse() {
        super.prepareForReuse()
        descriptionLabel.text = nil
        photoImageView.image = nil
    }
    
    private func setupCell() {
        setupPhotoImageView()
        setupDescriptionLabel()
    }
    
    private func setupDescriptionLabel() {
        addSubview(descriptionLabel)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: Constants.labelTopAnchor),
            descriptionLabel.leftAnchor.constraint(equalTo: photoImageView.rightAnchor, constant: Constants.constraint)
        ])
    }
    
    private func setupPhotoImageView() {
        addSubview(photoImageView)
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            photoImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: Constants.constraint),
            photoImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: Constants.constraint),
            photoImageView.heightAnchor.constraint(equalToConstant: Constants.imageSize),
            photoImageView.widthAnchor.constraint(equalToConstant: Constants.imageSize)
        ])
    }
}
