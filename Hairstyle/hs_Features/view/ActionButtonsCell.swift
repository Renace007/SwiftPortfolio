//
//  ActionButtonsCell.swift
//  hairstyle
//
//  Created by CRS on 10/4/25.
//

import UIKit

// MARK: - Action Buttons Cell
class ActionButtonsCell: UITableViewCell {
    private let stackView = UIStackView()
    
    // Expose buttons for external use
    let importButton = UIButton()
    let cameraButton = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupButtons()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupButtons() {
        stackView.axis = .horizontal
        stackView.spacing = 24
        stackView.distribution = .equalSpacing
        contentView.addSubview(stackView)
        
        importButton.setImage(UIImage(named: "import_icon"), for: .normal)
        importButton.imageView?.contentMode = .scaleAspectFit
        
        cameraButton.setImage(UIImage(named: "camera_icon"), for: .normal)
        cameraButton.imageView?.contentMode = .scaleAspectFit
        
        stackView.addArrangedSubview(importButton)
        stackView.addArrangedSubview(cameraButton)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            importButton.widthAnchor.constraint(equalToConstant: 128),
            importButton.heightAnchor.constraint(equalToConstant: 72),
            cameraButton.widthAnchor.constraint(equalToConstant: 128),
            cameraButton.heightAnchor.constraint(equalToConstant: 72)
        ])
    }
    
     func styleButtons() {
        guard let importButton = stackView.arrangedSubviews.first as? UIButton,
              let cameraButton = stackView.arrangedSubviews.last as? UIButton else { return }
        importButton.layer.cornerRadius = 16
        cameraButton.layer.cornerRadius = 16
    }
}
