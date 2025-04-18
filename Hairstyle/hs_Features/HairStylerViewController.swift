import UIKit
import AVFoundation
import Vision

class HairStylerViewController: UIViewController {
    // MARK: - Config
    var startFromPhotoImport: Bool = false
    
    // MARK: - UI Components
    private var previewView: UIView!
    private var styleImageView: UIImageView!
    private var capturePreviewLayer: AVCaptureVideoPreviewLayer?
    private var sizeSlider: UISlider!
    
    // MARK: - Function Modules
    private let faceDetector = FaceAnalyzer()
    private let captureSession = AVCaptureSession()
    private var facePoints: [CGPoint] = []
    
    // MARK: - Hairstyle Assets
    private let hairStyleNames = (1...8).map { "hairstyle_\($0)" }
    private var currentHairStyleIndex = 0
    private var currentHairScale: CGFloat = 1.0
    private var currentHairStyleImage: UIImage?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        loadInitialHairstyle()
        
        if !startFromPhotoImport {
            setupCamera()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("HairStylerViewController viewDidAppear, startFromPhotoImport: \(startFromPhotoImport)")
        if startFromPhotoImport {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.showImagePicker()
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if captureSession.isRunning {
            captureSession.stopRunning()
        }
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        // Preview View
        previewView = UIView(frame: view.bounds)
        previewView.backgroundColor = .black
        view.addSubview(previewView)
        
        // Style Image View (for hairstyle overlay)
        styleImageView = UIImageView(frame: previewView.bounds)
        styleImageView.contentMode = .scaleAspectFit
        styleImageView.isUserInteractionEnabled = true
        previewView.addSubview(styleImageView)
        
        // Pan gesture for dragging hairstyle
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        styleImageView.addGestureRecognizer(panGesture)
        
        // Pinch gesture for scaling hairstyle
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(_:)))
        styleImageView.addGestureRecognizer(pinchGesture)
        
        // Control Container
        let controlContainer = UIView()
        controlContainer.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        controlContainer.layer.cornerRadius = 10
        view.addSubview(controlContainer)
        controlContainer.translatesAutoresizingMaskIntoConstraints = false
        
        // Previous Hairstyle Button
        let prevButton = UIButton(type: .system)
        prevButton.setImage(UIImage(systemName: "arrow.left.circle.fill"), for: .normal)
        prevButton.tintColor = .black
        prevButton.backgroundColor = .white
        prevButton.layer.cornerRadius = 25
        prevButton.addTarget(self, action: #selector(prevStyleTapped), for: .touchUpInside)
        controlContainer.addSubview(prevButton)
        prevButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Next Hairstyle Button
        let nextButton = UIButton(type: .system)
        nextButton.setImage(UIImage(systemName: "arrow.right.circle.fill"), for: .normal)
        nextButton.tintColor = .black
        nextButton.backgroundColor = .white
        nextButton.layer.cornerRadius = 25
        nextButton.addTarget(self, action: #selector(nextStyleTapped), for: .touchUpInside)
        controlContainer.addSubview(nextButton)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Photo Import Button
        let importButton = UIButton(type: .system)
        importButton.setImage(UIImage(systemName: "photo.fill"), for: .normal)
        importButton.tintColor = .black
        importButton.backgroundColor = .white
        importButton.layer.cornerRadius = 25
        importButton.addTarget(self, action: #selector(importPhotoTapped), for: .touchUpInside)
        controlContainer.addSubview(importButton)
        importButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Save Button
        let saveButton = UIButton(type: .system)
        saveButton.setImage(UIImage(systemName: "square.and.arrow.down.fill"), for: .normal)
        saveButton.tintColor = .black
        saveButton.backgroundColor = .white
        saveButton.layer.cornerRadius = 25
        saveButton.addTarget(self, action: #selector(saveImageTapped), for: .touchUpInside)
        controlContainer.addSubview(saveButton)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Size Slider
        sizeSlider = UISlider()
        sizeSlider.minimumValue = 0.5
        sizeSlider.maximumValue = 2.0
        sizeSlider.value = 1.0
        sizeSlider.minimumTrackTintColor = .black
        sizeSlider.maximumTrackTintColor = .gray
        sizeSlider.thumbTintColor = .black
        sizeSlider.backgroundColor = .white
        sizeSlider.layer.cornerRadius = 8
        sizeSlider.addTarget(self, action: #selector(sizeChanged(_:)), for: .valueChanged)
        controlContainer.addSubview(sizeSlider)
        sizeSlider.translatesAutoresizingMaskIntoConstraints = false
        
        // Constraints
        NSLayoutConstraint.activate([
            controlContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            controlContainer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            controlContainer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            controlContainer.heightAnchor.constraint(equalToConstant: 120),
            
            prevButton.topAnchor.constraint(equalTo: controlContainer.topAnchor, constant: 10),
            prevButton.leadingAnchor.constraint(equalTo: controlContainer.leadingAnchor, constant: 20),
            prevButton.widthAnchor.constraint(equalToConstant: 50),
            prevButton.heightAnchor.constraint(equalToConstant: 50),
            
            nextButton.topAnchor.constraint(equalTo: controlContainer.topAnchor, constant: 10),
            nextButton.trailingAnchor.constraint(equalTo: controlContainer.trailingAnchor, constant: -20),
            nextButton.widthAnchor.constraint(equalToConstant: 50),
            nextButton.heightAnchor.constraint(equalToConstant: 50),
            
            importButton.topAnchor.constraint(equalTo: controlContainer.topAnchor, constant: 10),
            importButton.leadingAnchor.constraint(equalTo: prevButton.trailingAnchor, constant: 20),
            importButton.widthAnchor.constraint(equalToConstant: 50),
            importButton.heightAnchor.constraint(equalToConstant: 50),
            
            saveButton.topAnchor.constraint(equalTo: controlContainer.topAnchor, constant: 10),
            saveButton.trailingAnchor.constraint(equalTo: nextButton.leadingAnchor, constant: -20),
            saveButton.widthAnchor.constraint(equalToConstant: 50),
            saveButton.heightAnchor.constraint(equalToConstant: 50),
            
            sizeSlider.topAnchor.constraint(equalTo: prevButton.bottomAnchor, constant: 10),
            sizeSlider.leadingAnchor.constraint(equalTo: controlContainer.leadingAnchor, constant: 20),
            sizeSlider.trailingAnchor.constraint(equalTo: controlContainer.trailingAnchor, constant: -20),
            sizeSlider.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    // MARK: - Hairstyle Management
    private func loadInitialHairstyle() {
        currentHairStyleImage = UIImage(named: hairStyleNames[currentHairStyleIndex])
        updateHairPosition()
    }
    
    @objc private func nextStyleTapped() {
        currentHairStyleIndex = (currentHairStyleIndex + 1) % hairStyleNames.count
        currentHairStyleImage = UIImage(named: hairStyleNames[currentHairStyleIndex])
        updateHairPosition()
    }
    
    @objc private func prevStyleTapped() {
        currentHairStyleIndex = (currentHairStyleIndex - 1 + hairStyleNames.count) % hairStyleNames.count
        currentHairStyleImage = UIImage(named: hairStyleNames[currentHairStyleIndex])
        updateHairPosition()
    }
    
    private func updateHairPosition() {
        guard let styleImage = currentHairStyleImage else { return }
        
        let hairView = UIImageView(image: styleImage)
        hairView.tintColor = .black // Default color since color selection is removed
        hairView.contentMode = .scaleAspectFit
        
        let previewSize = previewView.bounds.size
        let defaultRect = CGRect(x: (previewSize.width - 160) / 2, y: (previewSize.height - 140) / 2, width: 160, height: 140)
        
        let forehead: CGPoint = {
            if facePoints.count >= 5 {
                let subPoints = Array(facePoints.prefix(5))
                let avgX = subPoints.map { $0.x }.reduce(0, +) / CGFloat(subPoints.count)
                let avgY = subPoints.map { $0.y }.reduce(0, +) / CGFloat(subPoints.count)
                return CGPoint(x: avgX, y: avgY)
            } else {
                return CGPoint(x: defaultRect.midX, y: defaultRect.midY)
            }
        }()
        
        let width: CGFloat = 160 * currentHairScale
        let height: CGFloat = 140 * currentHairScale
        let origin = CGPoint(x: forehead.x - width / 2, y: forehead.y - height * 0.9)
        
        hairView.frame = CGRect(origin: origin, size: CGSize(width: width, height: height))
        
        styleImageView.subviews.forEach { $0.removeFromSuperview() }
        styleImageView.addSubview(hairView)
    }
    
    // MARK: - Gestures
    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        guard let hairView = styleImageView.subviews.first as? UIImageView else { return }
        let translation = gesture.translation(in: styleImageView)
        hairView.center = CGPoint(
            x: hairView.center.x + translation.x,
            y: hairView.center.y + translation.y
        )
        gesture.setTranslation(.zero, in: styleImageView)
    }
    
    @objc private func handlePinch(_ gesture: UIPinchGestureRecognizer) {
        currentHairScale *= gesture.scale
        currentHairScale = max(0.5, min(currentHairScale, 2.0))
        gesture.scale = 1.0
        updateHairPosition()
    }
    
    // MARK: - Size Adjustment
    @objc private func sizeChanged(_ slider: UISlider) {
        currentHairScale = CGFloat(slider.value)
        updateHairPosition()
    }
    
    // MARK: - Image Picker
    @objc private func importPhotoTapped() {
        showImagePicker()
    }
    
    private func showImagePicker() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
    }
    
    // MARK: - Save Image
    @objc private func saveImageTapped() {
        UIGraphicsBeginImageContextWithOptions(previewView.bounds.size, false, UIScreen.main.scale)
        previewView.drawHierarchy(in: previewView.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if let image = image {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            let alert = UIAlertController(title: "Saved", message: "Image saved to Photos", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    }
    
    // MARK: - Camera
    private func setupCamera() {
        captureSession.sessionPreset = .high
        
        guard let frontCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front),
              let input = try? AVCaptureDeviceInput(device: frontCamera) else {
            print("Failed to access front camera")
            return
        }
        
        if captureSession.canAddInput(input) {
            captureSession.addInput(input)
        }
        
        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        if captureSession.canAddOutput(videoOutput) {
            captureSession.addOutput(videoOutput)
        }
        
        capturePreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        capturePreviewLayer?.frame = previewView.bounds
        capturePreviewLayer?.videoGravity = .resizeAspectFill
        if let capturePreviewLayer = capturePreviewLayer {
            previewView.layer.insertSublayer(capturePreviewLayer, below: styleImageView.layer)
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession.startRunning()
        }
    }
}

// MARK: - Image Picker Delegate
extension HairStylerViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        processImage(image)
        dismiss(animated: true)
    }
    
    private func processImage(_ image: UIImage) {
        let imageView = UIImageView(image: image)
        imageView.frame = previewView.bounds
        imageView.contentMode = .scaleAspectFit
        previewView.subviews.forEach { if $0 != styleImageView { $0.removeFromSuperview() } }
        previewView.insertSubview(imageView, belowSubview: styleImageView)
        
        faceDetector.detectLandmarks(image: image) { [weak self] points in
            guard let self = self, let points = points else { return }
            DispatchQueue.main.async {
                self.facePoints = points
                self.updateHairPosition()
            }
        }
    }
}

// MARK: - Camera Delegate
extension HairStylerViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        let context = CIContext()
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else { return }
        let uiImage = UIImage(cgImage: cgImage, scale: 1.0, orientation: .leftMirrored)
        
        faceDetector.detectLandmarks(image: uiImage) { [weak self] points in
            guard let self = self, let points = points else { return }
            DispatchQueue.main.async {
                self.facePoints = points
                self.updateHairPosition()
            }
        }
    }
}

// MARK: - Face Analyzer
class FaceAnalyzer {
    func detectLandmarks(image: UIImage, completion: @escaping ([CGPoint]?) -> Void) {
        guard let cgImage = image.cgImage else {
            completion(nil)
            return
        }
        
        let request = VNDetectFaceLandmarksRequest { request, error in
            guard error == nil,
                  let results = request.results as? [VNFaceObservation],
                  let face = results.first,
                  let landmarks = face.landmarks else {
                completion(nil)
                return
            }
            
            let points = self.convertLandmarks(landmarks, for: image.size)
            completion(points)
        }
        
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        try? handler.perform([request])
    }
    
    private func convertLandmarks(_ landmarks: VNFaceLandmarks2D, for size: CGSize) -> [CGPoint] {
        let allPoints = landmarks.allPoints?.normalizedPoints ?? []
        let converted = allPoints.map { CGPoint(x: $0.x * size.width, y: (1 - $0.y) * size.height) }
        return converted
    }
}
