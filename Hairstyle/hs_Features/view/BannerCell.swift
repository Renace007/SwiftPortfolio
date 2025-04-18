//
//  BannerCell.swift
//  hairstyle
//
//  Created by CRS on 10/4/25.
//

import UIKit

// MARK: - Banner Cell
class BannerCell: UITableViewCell {
    var hs_bannerScrollView: UIScrollView!
    var hs_bannerTimer: Timer?
    private let bannerImages = ["banner1", "banner2", "banner3"].compactMap { UIImage(named: $0) }
    var onTap: (() -> Void)?
    
    func setupBanner() {
        hs_bannerScrollView = UIScrollView()
        hs_bannerScrollView.isPagingEnabled = true
        hs_bannerScrollView.showsHorizontalScrollIndicator = false
        contentView.addSubview(hs_bannerScrollView)
        
        hs_bannerScrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hs_bannerScrollView.topAnchor.constraint(equalTo: contentView.topAnchor),
            hs_bannerScrollView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            hs_bannerScrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            hs_bannerScrollView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        hs_bannerScrollView.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: hs_bannerScrollView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: hs_bannerScrollView.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: hs_bannerScrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: hs_bannerScrollView.trailingAnchor),
            stackView.heightAnchor.constraint(equalTo: hs_bannerScrollView.heightAnchor)
        ])
        
        bannerImages.forEach { image in
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            stackView.addArrangedSubview(imageView)
            imageView.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        hs_bannerScrollView.addGestureRecognizer(tap)
        
        startAutoScroll()
    }
    
    @objc private func handleTap() {
        onTap?()
    }
    
    private func startAutoScroll() {
        hs_bannerTimer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            let page = Int(self.hs_bannerScrollView.contentOffset.x / self.contentView.bounds.width)
            let nextPage = (page + 1) % self.bannerImages.count
            let offset = CGPoint(x: CGFloat(nextPage) * self.contentView.bounds.width, y: 0)
            self.hs_bannerScrollView.setContentOffset(offset, animated: true)
        }
    }
}
