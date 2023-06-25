//
//  CategoryCell.swift
//  myTestTask
//
//  Created by Владимир Курганов on 24.06.2023.
//

import UIKit

final class CategoryCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "CategoryCollectionViewCell"
    
    let categoryLabel: UILabel = {
        let categoryLabel = UILabel()
        categoryLabel.textAlignment = .center
        categoryLabel.textColor = UIColor(red: 0.99,
                                                green: 0.23,
                                                blue: 0.41,
                                                alpha: 0.4)
        categoryLabel.font = UIFont.boldSystemFont(ofSize: 13)
        return categoryLabel
    }()
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        style()
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Methods
    func configure(categoryFood food: String) {
        categoryLabel.text = food
    }
    
    private func style() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 15
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor(red: 0.992,
                                                      green: 0.227,
                                                      blue: 0.412,
                                                      alpha: 1).cgColor
    }
    
    
    private func setupCell() {
        addSubview(categoryLabel)
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            categoryLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            categoryLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            categoryLabel.widthAnchor.constraint(equalToConstant: 70)
        ])
    }
}
