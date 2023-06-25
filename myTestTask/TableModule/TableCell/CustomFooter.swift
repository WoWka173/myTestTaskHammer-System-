//
//  CustomFooter.swift
//  myTestTask
//
//  Created by Владимир Курганов on 23.06.2023.
//

import UIKit

//MARK: - TableViewCustomFooter
final class TableViewCustomFooter: UIView {
    
    let indicator = UIActivityIndicatorView(style: .medium)
    
    //MARK: - Init
    override init(frame: CGRect) {
        super .init(frame: frame)
        backgroundColor = .white
        setupIndicator()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Methods
    func setupIndicator() {
        addSubview(indicator)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
}
