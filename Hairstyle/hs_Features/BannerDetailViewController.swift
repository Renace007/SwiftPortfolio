import UIKit
import PhotosUI

// 数据模型
enum HairSection: Int, CaseIterable {
    case hairstyle
    case color
    
    var title: String {
        switch self {
        case .hairstyle: return "Hairstyle Recommendations"
        case .color: return "Hair Color Recommendations"
        }
    }
    
    var imagePrefix: String {
        switch self {
        case .hairstyle: return "hairstyle_"
        case .color: return "colorstyle_"
        }
    }
    
    var itemCount: Int { 8 }
}

class BannerDetailViewController: UIViewController {
    
    private var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        title = "Hairstyle & Hair Color"
        view.backgroundColor = .systemBackground
        configureCollectionView()
    }
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.reuseID)
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.reuseID)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1/2),
                heightDimension: .fractionalHeight(1)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
            
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalWidth(0.6)
            )
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
            
            let headerSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(44)
            )
            let header = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
            section.boundarySupplementaryItems = [header]
            
            return section
        }
        return layout
    }
}
extension BannerDetailViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        HairSection.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let sectionType = HairSection(rawValue: section) else {
            print("Invalid section: \(section)")
            return 0
        }
        return sectionType.itemCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.reuseID, for: indexPath) as? ImageCell else {
            print("Failed to dequeue ImageCell for indexPath: \(indexPath)")
            return UICollectionViewCell() // 返回空单元格
        }
        guard let section = HairSection(rawValue: indexPath.section) else {
            print("Invalid section: \(indexPath.section)")
            return cell
        }
        let imageName = section.imagePrefix + "\(indexPath.item + 1)"
        if let image = UIImage(named: imageName) {
            cell.configure(with: image)
        } else {
            print("Failed to load image: \(imageName)")
            cell.configure(with: nil) // 或者使用占位图片
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader,
              let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: SectionHeader.reuseID,
                for: indexPath
              ) as? SectionHeader else {
            print("Failed to dequeue SectionHeader for indexPath: \(indexPath)")
            return UICollectionReusableView()
        }
        
        if let section = HairSection(rawValue: indexPath.section) {
            header.configure(title: section.title)
        } else {
            print("Invalid section for header: \(indexPath.section)")
            header.configure(title: "unknown")
        }
        return header
    }
}
extension BannerDetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let section = HairSection(rawValue: indexPath.section),
              let image = UIImage(named: "\(section.imagePrefix)\(indexPath.item + 1)") else { return }
        
        let compareVC = CompareViewController(styleImage: image)
        navigationController?.pushViewController(compareVC, animated: true)
    }
}

class CompareViewController: UIViewController {

    private let styleImage: UIImage
    private var userImage: UIImage? {
        didSet {
            uploadHintLabel.isHidden = userImage != nil
            updateUI()
        }
    }
    
    // 发型模式参数
    private var currentScale: CGFloat = 1.0
    private var currentRotation: CGFloat = 0.0
    private var currentAlpha: CGFloat = 0.5
    private var currentPosition: CGPoint = .zero
    
    // UI组件
    private let scrollView = UIScrollView()
    private let userImageView = UIImageView()
    private let styleImageView = UIImageView()
    private let blendedImageView = UIImageView()
    private let uploadHintLabel = UILabel()
    
    // 发型模式控件
    private let sizeSlider = UISlider()
    private let alphaSlider = UISlider()
    private let rotationSlider = UISlider()
    
    
    init(styleImage: UIImage) {
        self.styleImage = styleImage
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupGestures()
        setupNavigationBar()
        updateUI()
        print("scrollView superview: \(scrollView.superview?.description ?? "nil")")
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        scrollView.delegate = self
        
        // 公共配置
        styleImageView.image = styleImage
        styleImageView.contentMode = .scaleAspectFit
        userImageView.contentMode = .scaleAspectFit
        blendedImageView.contentMode = .scaleAspectFit
        uploadHintLabel.textColor = .secondaryLabel
        uploadHintLabel.textAlignment = .center
        uploadHintLabel.font = .systemFont(ofSize: 16)
        
        // 确保 scrollView 添加到 view
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        // 根据模式配置
        uploadHintLabel.text = "Upload your photo to blend hairstyle"
        scrollView.addSubview(blendedImageView)
        view.addSubview(uploadHintLabel)
        configureHairstyleUI()
        
        // 设置 scrollView 的基本约束
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        // uploadHintLabel 的约束
        uploadHintLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            uploadHintLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            uploadHintLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func configureHairstyleUI() {
        // 发型模式布局
        blendedImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            blendedImageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            blendedImageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            blendedImageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            blendedImageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            blendedImageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        // Slider 配置
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        
        sizeSlider.minimumValue = 0.5
        sizeSlider.maximumValue = 2.0
        sizeSlider.value = 1.0
        alphaSlider.minimumValue = 0
        alphaSlider.maximumValue = 1
        alphaSlider.value = 0.5
        rotationSlider.minimumValue = 0
        rotationSlider.maximumValue = 1
        rotationSlider.value = 0.5
        
        let sliders: [(title: String, slider: UISlider)] = [
            ("Size", sizeSlider),
            ("Alpha", alphaSlider),
            ("Rotation", rotationSlider)
        ]

        for (title, slider) in sliders {
            slider.addTarget(self, action: #selector(sliderChanged), for: .valueChanged)
            stackView.addArrangedSubview(createSliderView(title: title, slider: slider))
        }
        
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    
    
    private func createSliderView(title: String, slider: UISlider) -> UIStackView {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        let label = UILabel()
        label.text = title
        label.font = .systemFont(ofSize: 14)
        stack.addArrangedSubview(label)
        stack.addArrangedSubview(slider)
        return stack
    }
    
    private func setupGestures() {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        pan.delegate = self
        blendedImageView.addGestureRecognizer(pan)
        blendedImageView.isUserInteractionEnabled = true
    }
    
    private func setupNavigationBar() {
        let uploadButton = UIBarButtonItem(
            image: UIImage(systemName: "photo"),
            style: .plain,
            target: self,
            action: #selector(showImagePicker)
        )
        navigationItem.rightBarButtonItem = uploadButton
    }
    
    @objc private func showImagePicker() {
        if #available(iOS 14.0, *) {
            var config = PHPickerConfiguration()
            config.selectionLimit = 1
            config.filter = .images
            let picker = PHPickerViewController(configuration: config)
            picker.delegate = self
            present(picker, animated: true)
        } else {
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.delegate = self
            present(picker, animated: true)
        }
    }
    
    @objc private func sliderChanged() {
        currentScale = CGFloat(sizeSlider.value)
        currentAlpha = CGFloat(alphaSlider.value)
        currentRotation = CGFloat(rotationSlider.value) * .pi * 2
        updateHairstyle()
    }
        
    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: blendedImageView)
        currentPosition.x += translation.x
        currentPosition.y += translation.y
        gesture.setTranslation(.zero, in: blendedImageView)
        updateHairstyle()
    }
    
    private func updateUI() {
        updateHairstyle()
    }
    
    private func updateHairstyle() {
        guard let userImage = userImage else {
            print("No user image available for hairstyle update")
            blendedImageView.image = nil
            return
        }
        
        // 限制最大尺寸为 1000x1000
        let targetSize = CGSize(width: min(userImage.size.width, 1000), height: min(userImage.size.height, 1000))
        guard let resizedUserImage = resizeImage(userImage, targetSize: targetSize),
              let resizedStyleImage = resizeImage(styleImage, targetSize: targetSize) else {
            print("Failed to resize images for hairstyle")
            blendedImageView.image = nil
            return
        }
        
        let renderer = UIGraphicsImageRenderer(size: resizedUserImage.size)
        blendedImageView.image = renderer.image { ctx in
            resizedUserImage.draw(in: CGRect(origin: .zero, size: resizedUserImage.size))
            
            let transform = CGAffineTransform(translationX: currentPosition.x, y: currentPosition.y)
                .rotated(by: currentRotation)
                .scaledBy(x: currentScale, y: currentScale)
            
            ctx.cgContext.concatenate(transform)
            resizedStyleImage.draw(in: CGRect(origin: CGPoint(x: -resizedStyleImage.size.width/2, y: -resizedStyleImage.size.height/2),
                                           size: resizedStyleImage.size),
                                blendMode: .normal,
                                alpha: currentAlpha)
        }
    }
    
    
    
    
    
    private func resizeImage(_ image: UIImage, targetSize: CGSize) -> UIImage? {
        let size = image.size
        let widthRatio = targetSize.width / size.width
        let heightRatio = targetSize.height / size.height
        let scaleFactor = min(widthRatio, heightRatio)
        
        let scaledSize = CGSize(width: size.width * scaleFactor, height: size.height * scaleFactor)
        let renderer = UIGraphicsImageRenderer(size: scaledSize)
        return renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: scaledSize))
        }
    }
}

extension CompareViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                         shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension CompareViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return blendedImageView
    }
}

@available(iOS 14.0, *)
extension CompareViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        // 确保选中结果存在且能加载图片
        guard let result = results.first,
              result.itemProvider.canLoadObject(ofClass: UIImage.self) else {
            showAlert(title: "Error", message: "Unable to load selected image")
            return
        }
        
        // 显示加载指示器
        let loadingIndicator = UIActivityIndicatorView(style: .large)
        view.addSubview(loadingIndicator)
        loadingIndicator.center = view.center
        loadingIndicator.startAnimating()
        
        // 异步加载图片
        result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (object, error) in
            DispatchQueue.main.async {
                loadingIndicator.stopAnimating()
                loadingIndicator.removeFromSuperview()
                
                if let error = error {
                    self?.showAlert(title: "Loading Failed", message: error.localizedDescription)
                    return
                }
                
                guard let image = object as? UIImage else {
                    self?.showAlert(title: "Invalid Format", message: "Unsupported image format")
                    return
                }
                
                // 根据模式处理图片
                self?.handleHairstyleImage(image)
            }
        }
    }
    
    private func handleHairstyleImage(_ image: UIImage) {
        // 重置发型参数
        currentScale = 1.0
        currentRotation = 0.0
        currentAlpha = 0.5
        currentPosition = .zero
        
        // 更新界面
        userImage = image
        sizeSlider.value = 1.0
        alphaSlider.value = 0.5
        rotationSlider.value = 0.5
        
        // 自动进入编辑模式
        UIView.animate(withDuration: 0.3) {
            self.blendedImageView.alpha = 1.0
            self.updateHairstyle()
        }
    }
    
    // Removed handleColorImage(_:) as only hairstyle mode is supported.
}

// 警报扩展
extension CompareViewController {
    fileprivate func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
    
    @objc fileprivate func imageSaveCompletion(_ image: UIImage,
                                            didFinishSavingWithError error: Error?,
                                            contextInfo: UnsafeRawPointer) {
        if let error = error {
            showAlert(title: "Save Failed", message: error.localizedDescription)
        } else {
            showAlert(title: "Saved Successfully", message: "The image has been saved to Photos")
        }
    }
}

// 接上文 CompareViewController 扩展

// MARK: - 图片裁剪控制器
class ImageCropViewController: UIViewController {
    var image: UIImage
    weak var delegate: ImageCropDelegate?
    
    private let imageView = UIImageView()
    private let cropAreaView = UIView()
    
    init(image: UIImage) {
        self.image = image
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
        
    }
    
    private func setupUI() {
        view.backgroundColor = .black
        
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        
        cropAreaView.layer.borderColor = UIColor.white.cgColor
        cropAreaView.layer.borderWidth = 2
        cropAreaView.backgroundColor = .clear
        
        view.addSubview(imageView)
        view.addSubview(cropAreaView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // 初始裁剪区域
        updateCropArea(size: CGSize(width: 200, height: 200))
    }
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(cancel)
        )
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(done)
        )
    }
    
    private func updateCropArea(size: CGSize) {
        cropAreaView.frame = CGRect(
            x: view.bounds.midX - size.width/2,
            y: view.bounds.midY - size.height/2,
            width: size.width,
            height: size.height
        )
    }
    
    @objc private func cancel() {
        dismiss(animated: true)
    }
    
    @objc private func done() {
        guard let croppedImage = cropImage() else {
            dismiss(animated: true)
            return
        }
        
        delegate?.imageCropController(self, didFinishCroppingImage: croppedImage)
        dismiss(animated: true)
    }
    
    private func cropImage() -> UIImage? {
        let cropRect = cropAreaView.frame
        let imageScale = min(
            imageView.bounds.width / image.size.width,
            imageView.bounds.height / image.size.height
        )
        
        let scaledCropRect = CGRect(
            x: cropRect.origin.x / imageScale,
            y: cropRect.origin.y / imageScale,
            width: cropRect.size.width / imageScale,
            height: cropRect.size.height / imageScale
        )
        
        // 检查裁剪区域是否有效
        guard scaledCropRect.minX >= 0,
              scaledCropRect.minY >= 0,
              scaledCropRect.maxX <= image.size.width,
              scaledCropRect.maxY <= image.size.height else {
            showAlert(title: "Crop Failed", message: "Crop area is out of image bounds")
            return nil
        }
        
        guard let cgImage = image.cgImage?.cropping(to: scaledCropRect) else {
            showAlert(title: "Crop Failed", message: "Unable to process image")
            return nil
        }
        
        return UIImage(cgImage: cgImage, scale: image.scale, orientation: image.imageOrientation)
    }

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - 协议定义
protocol ImageCropDelegate: AnyObject {
    func imageCropController(_ controller: ImageCropViewController, didFinishCroppingImage image: UIImage)
}

// MARK: - UI组件
class ImageCell: UICollectionViewCell {
    static let reuseID = "ImageCell"
    
    private let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.layer.masksToBounds = true
        
        contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func configure(with image: UIImage?) {
        imageView.image = image
    }
}

class SectionHeader: UICollectionReusableView {
    static let reuseID = "SectionHeader"
    private let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        let fontDescriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .title3)
        label.font = UIFont.systemFont(ofSize: fontDescriptor.pointSize, weight: .bold)
        label.textColor = .label
        
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func configure(title: String) {
        label.text = title
    }
}




extension CompareViewController: ImageCropDelegate {
    func imageCropController(_ controller: ImageCropViewController, didFinishCroppingImage image: UIImage) {
        userImage = image
        updateUI()
    }
}


extension CompareViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        if let image = info[.originalImage] as? UIImage {
            self.userImage = image
            self.updateUI()
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

