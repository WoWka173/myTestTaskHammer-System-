//
//  BarButtonItem.swift
//  myTestTask
//
//  Created by Владимир Курганов on 23.06.2023.
//

import UIKit

import UIKit

final class BarButtonView: UIView {
    
    private let title = UILabel()
    private let imageView = UIImageView()
    
    init() {
        super.init(frame: .zero)
        configAppearance()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Config Appearance
private extension BarButtonView {
    
    func configAppearance() {
        imageView.image = UIImage(named: "Arrow")
        imageView.contentMode = .scaleAspectFill
        title.text = "Moscow"
        title.textColor = .black
        title.font = UIFont.systemFont(ofSize: 17, weight: .medium)
    }
}

// MARK: - Make Constraints
private extension BarButtonView {
    
    func makeConstraints() {
        addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            title.leadingAnchor.constraint(equalTo: leadingAnchor),
            title.topAnchor.constraint(equalTo: topAnchor),
            title.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.centerYAnchor.constraint(equalTo: title.centerYAnchor),
            imageView.leadingAnchor.constraint(equalTo: title.trailingAnchor, constant: 8),
            imageView.heightAnchor.constraint(equalToConstant: 8),
            imageView.widthAnchor.constraint(equalToConstant: 14),
        ])
    }
}
