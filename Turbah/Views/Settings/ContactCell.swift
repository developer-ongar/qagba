//
//  ContactCell.swift
//  Qagba
//
//  Created by Ongar.dev on 20/01/2023.
//  Copyright © 2023 MMQ. All rights reserved.
//

import UIKit

class ContactCell: UITableViewCell {

    static let id = "contactCell"
    
    private var stack = UIStackView()
    var iconImageView = UIImageView()
    var infoLabel = UILabel()
    
    private func setupUI() {
        separatorInset.left = 60
        
        NSLayoutConstraint.activate([
            iconImageView.widthAnchor.constraint(equalToConstant: 30),
            iconImageView.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fillProportionally
        stack.spacing = 15
        stack.addArrangedSubview(iconImageView)
        stack.addArrangedSubview(infoLabel)
        contentView.addSubview(stack)
        stack.fillSuperview(padding: UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15))
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

}
