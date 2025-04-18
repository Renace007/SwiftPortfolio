//
//  RecommendationCell.swift
//  hairstyle
//
//  Created by CRS on 10/4/25.
//

import UIKit

// MARK: - Recommendation Cell
class RecommendationCell: UITableViewCell {
    enum RecommendationType {
        case latest
        case color
    }
    var onImageTapped: ((String) -> Void)?
    private let scrollView = UIScrollView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupScrollView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(type: RecommendationType) {
        let images = (1...5).map { "\(type == .latest ? "latest" : "color")_\($0)" }
        var x: CGFloat = 16
        
        images.forEach { imageName in
            guard let image = UIImage(named: imageName) else { return }
            
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = 16
            imageView.frame = CGRect(x: x, y: 0, width: 120, height: 160)
            
            // Add tap support
            imageView.isUserInteractionEnabled = true
            imageView.accessibilityIdentifier = imageName
            let tap = UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:)))
            imageView.addGestureRecognizer(tap)
            
            scrollView.addSubview(imageView)
            x += 136
        }
        
        scrollView.contentSize = CGSize(width: x, height: 160)
        
        print("ScrollView frame width: \(scrollView.frame.width)")
        print("Content size width: \(scrollView.contentSize.width)")
    }
    
    @objc private func imageTapped(_ sender: UITapGestureRecognizer) {
        if let view = sender.view, let id = view.accessibilityIdentifier {
            onImageTapped?(id)
        }
    }
    
    private func setupScrollView() {
        scrollView.alwaysBounceHorizontal = true
        scrollView.isScrollEnabled = true
        scrollView.isUserInteractionEnabled = true
        
        scrollView.showsHorizontalScrollIndicator = false
        contentView.addSubview(scrollView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            scrollView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            scrollView.heightAnchor.constraint(equalToConstant: 160)
        ])
    }
}
