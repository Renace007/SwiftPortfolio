import UIKit
import Photos
import AVFoundation

class hs_HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Properties
    private let tableView = UITableView()
    var hs_bannerTimer: Timer?
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationTitle()
    }
    
    // MARK: - TableView Setup
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.register(BannerCell.self, forCellReuseIdentifier: "BannerCell")
        tableView.register(ActionButtonsCell.self, forCellReuseIdentifier: "ActionButtonsCell")
        tableView.register(RecommendationCell.self, forCellReuseIdentifier: "RecommendationCell")
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: - Navigation Title
    func setupNavigationTitle() {
        let titleLabel = UILabel()
        titleLabel.text = "HairStyle Home ✨"
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        
        let containerView = UIView()
        containerView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
        
        navigationItem.titleView = containerView
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    // MARK: - UITableView DataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4 // Banner, Buttons, Latest, Color
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 // Each section has 1 row
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "BannerCell", for: indexPath) as! BannerCell
            cell.onTap = {
                let vc = BannerDetailViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            }
            cell.setupBanner()
            self.hs_bannerTimer = cell.hs_bannerTimer // Keep timer reference
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ActionButtonsCell", for: indexPath) as! ActionButtonsCell
            cell.styleButtons()

            // Configure import button action
            cell.importButton.addTarget(self, action: #selector(importPhotoTapped), for: .touchUpInside)

            // Configure camera button action
            cell.cameraButton.addTarget(self, action: #selector(takePhotoTapped), for: .touchUpInside)

            return cell
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "RecommendationCell", for: indexPath) as! RecommendationCell
            cell.configure(type: .latest)
            cell.onImageTapped = { [weak self] imageName in
                guard let self = self else { return }
                if let rec = HairRecommendation.all.first(where: { $0.imageName == imageName }) {
                    let detailVC = HairDetailViewController()
                    detailVC.recommendation = rec
                    self.navigationController?.pushViewController(detailVC, animated: true)
                }
            }
            return cell
            
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "RecommendationCell", for: indexPath) as! RecommendationCell
            cell.configure(type: .color)
            cell.onImageTapped = { [weak self] imageName in
                guard let self = self else { return }
                if let rec = HairRecommendation.all.first(where: { $0.imageName == imageName }) {
                    let detailVC = HairDetailViewController()
                    detailVC.recommendation = rec
                    self.navigationController?.pushViewController(detailVC, animated: true)
                }
            }
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
    // MARK: - UITableView Delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0: return 220   // Banner
        case 1: return 80   // Buttons
        case 2, 3: return 180 // Recommendations
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section >= 2 else { return nil }
        
        let header = UIView()
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        
        header.addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: 16),
            label.centerYAnchor.constraint(equalTo: header.centerYAnchor)
        ])
        
        switch section {
        case 2: label.text = "Latest recommendation"
        case 3: label.text = "Hair color is recommended for you"
        default: break
        }
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section >= 2 ? 28 : 0
    }
    
    @objc func importPhotoTapped() {
        print("Import button tapped")
        let status = PHPhotoLibrary.authorizationStatus()
        
        if status == .notDetermined {
            PHPhotoLibrary.requestAuthorization { [weak self] newStatus in
                DispatchQueue.main.async {
                    if #available(iOS 14, *) {
                        if newStatus == .authorized || newStatus == .limited {
                            self?.pushHairStyler(importMode: true)
                        } else {
                            self?.showPermissionAlert(for: "Photo Library")
                        }
                    } else {
                        if newStatus == .authorized {
                            self?.pushHairStyler(importMode: true)
                        } else {
                            self?.showPermissionAlert(for: "Photo Library")
                        }
                    }
                }
            }
        } else {
            if #available(iOS 14, *) {
                if status == .authorized || status == .limited {
                    pushHairStyler(importMode: true)
                } else {
                    showPermissionAlert(for: "Photo Library")
                }
            } else {
                if status == .authorized {
                    pushHairStyler(importMode: true)
                } else {
                    showPermissionAlert(for: "Photo Library")
                }
            }
        }
    }

    @objc func takePhotoTapped() {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        
        if status == .notDetermined {
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                if granted {
                    DispatchQueue.main.async {
                        self?.pushHairStyler(importMode: false)
                    }
                } else {
                    DispatchQueue.main.async {
                        self?.showPermissionAlert(for: "Camera")
                    }
                }
            }
        } else if status == .authorized {
            pushHairStyler(importMode: false)
        } else {
            showPermissionAlert(for: "Camera")
        }
    }
    
    func pushHairStyler(importMode: Bool) {
        print("Pushing HairStylerViewController with importMode: \(importMode)")
        let vc = HairStylerViewController()
        vc.startFromPhotoImport = importMode
        guard let navController = self.navigationController else {
            print("Error: Navigation controller is nil")
            return
        }
        navController.pushViewController(vc, animated: true)
    }

    func showPermissionAlert(for feature: String) {
        let alert = UIAlertController(
            title: "\(feature) Permission Not Enabled",
            message: "Please enable access to the \(feature) in Settings to use this feature.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Open Settings", style: .default, handler: { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url)
            }
        }))
        present(alert, animated: true)
    }
}
