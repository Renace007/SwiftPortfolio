//
//  HairDetailViewController.swift
//  hairstyle
//
//  Created by CRS on 11/4/25.
//

import UIKit

// Create HairRecommendation.swift
struct HairRecommendation {
    let id: String
    let type: String // "latest" or "color"
    let styleName: String
    let imageName: String
    let colorName: String
    let description: String
    
    static let all: [HairRecommendation] = [
        HairRecommendation(
            id: "latest_1",
            type: "latest",
            styleName: "Romantic Wave",
            imageName: "latest_1",
            colorName: "Black",
            description: """
            The Romantic Wave hairstyle features cascading soft curls that frame the face beautifully. This style works best with medium to long hair lengths and requires proper care to maintain its shape.
            
            Hair Care Tips:
            1. Use sulfate-free shampoo to preserve natural oils
            2. Apply argan oil serum to ends daily
            3. Sleep with silk pillowcases to reduce friction
            4. Get trims every 8 weeks to prevent split ends
            5. Use wide-tooth comb on wet hair to prevent breakage
            
            Styling Advice:
            • Blow dry with diffuser attachment for enhanced waves
            • Twist small sections while damp for defined curls
            • Avoid brushing curls when dry to prevent frizz
            • Refresh second-day hair with sea salt spray
            """
        ),
        HairRecommendation(
            id: "latest_2",
            type: "latest",
            styleName: "Blunt Bob",
            imageName: "latest_2",
            colorName: "Brown",
            description: """
            The precision-cut Blunt Bob creates sharp lines that accentuate facial features. This low-maintenance style requires specific techniques to keep its clean shape.
            
            Maintenance Guide:
            - Schedule salon visits every 6 weeks for sharp lines
            - Use flat iron with ceramic plates for smooth finish
            - Apply heat protectant before any thermal styling
            - Try inversion method for faster growth
            - Massage scalp 3x weekly to stimulate follicles
            
            Color Preservation:
            ✓ Use color-depositing conditioners
            ✓ Wash with cool water to prevent fading
            ✓ Limit sun exposure with UV-protectant sprays
            ✓ Avoid chlorine to prevent brassiness
            """
        ),
        HairRecommendation(
            id: "latest_3",
            type: "latest",
            styleName: "Classic Pixie",
            imageName: "latest_3",
            colorName: "Blonde",
            description: """
            The Classic Pixie offers bold, short layers that highlight facial structure. This style requires frequent maintenance but offers maximum versatility.
            
            Styling Products Needed:
            • Texturizing paste for piece-y definition
            • Matte pomade for structured looks
            • Shine serum for formal occasions
            • Dry shampoo for volume at roots
            • Edge control for sleek hairlines
            
            Growth Cycle Management:
            → Transition with gradual trims
            → Consider clip-in extensions during growth
            → Take biotin supplements for strength
            → Use protein treatments monthly
            → Try scalp exfoliation for healthier growth
            """
        ),
        HairRecommendation(
            id: "latest_4",
            type: "latest",
            styleName: "Modern Mullet",
            imageName: "latest_4",
            colorName: "Brown",
            description: """
            The Modern Mullet combines short front with longer back layers for edgy contrast. This statement style needs special attention to maintain its shape.
            
            Daily Routine:
            • Use texturizing spray for lived-in look
            • Brush back layers with boar bristle brush
            • Apply leave-in conditioner to ends
            • Air dry with clips for root lift
            • Refresh with diluted conditioner spray
            
            Cutting Techniques:
            ✓ Point cutting for soft edges
            ✓ Razor cutting for sharp angles
            ✓ Blunt cutting for maximum impact
            ✓ Layer cutting for movement
            ✓ Thinning shears for reduced bulk
            """
        ),
        HairRecommendation(
            id: "latest_5",
            type: "latest",
            styleName: "Layered Flow",
            imageName: "latest_5",
            colorName: "Black",
            description: """
            The Layered Flow creates movement and dimension through strategic cutting. These face-framing layers require specific care to prevent tangling.
            
            Detangling Protocol:
            1. Start from ends and work upward
            2. Use conditioner as detangler
            3. Finger comb before brushing
            4. Section hair when wet
            5. Invest in wet brush for gentle detangling
            
            Volume Enhancement:
            • Blow dry upside down
            • Use root-lifting sprays
            • Try velcro rollers for bounce
            • Tease gently at crown
            • Apply dry shampoo at roots
            """
        ),
        HairRecommendation(
            id: "color_1",
            type: "color",
            styleName: "Bold Curls",
            imageName: "color_1",
            colorName: "Yellow",
            description: """
            Vibrant yellow curls make a dramatic color statement. Maintaining bright fashion colors requires special color-care techniques.
            
            Color Protection:
            - Wash with color-safe shampoo
            - Use gloves when swimming
            - Avoid hot tools when possible
            - Refresh with color conditioners
            - Limit washing to 2x weekly
            
            Curl Definition:
            • Apply styling cream to soaking hair
            • Plop with microfiber towel
            • Diffuse on low heat
            • Scrunch out crunch when dry
            • Pineapple at night for preservation
            """
        ),
        HairRecommendation(
            id: "color_2",
            type: "color",
            styleName: "Sleek Straight",
            imageName: "color_2",
            colorName: "Brown",
            description: """
            Glossy brown straight hair showcases rich color dimensions. Achieving salon-quality smoothness requires proper technique.
            
            Straightening Steps:
            1. Apply thermal protectant
            2. Work in small sections
            3. Use comb-chase method
            4. Keep iron moving constantly
            5. Finish with cool shot
            
            Color Enhancement:
            ✓ Gloss treatments monthly
            ✓ Tone with purple shampoo
            ✓ Use shine sprays
            ✓ Try clear glaze for depth
            ✓ Get professional toning
            """
        ),
        HairRecommendation(
            id: "color_3",
            type: "color",
            styleName: "Balayage Blend",
            imageName: "color_3",
            colorName: "Blonde",
            description: """
            Sun-kissed balayage creates natural-looking dimension. This hand-painted technique requires special maintenance for seamless blending.
            
            Fade Prevention:
            • Use bond-building treatments
            • Get root smudging
            • Schedule gloss treatments
            • Avoid clarifying shampoos
            • Use color-depositing masks
            
            Blonde Care:
            - Purple shampoo 1x weekly
            - Deep condition 2x weekly
            - Olaplex treatments monthly
            - Avoid heat styling when possible
            - Protect from hard water
            """
        ),
        HairRecommendation(
            id: "color_4",
            type: "color",
            styleName: "Ombre Fade",
            imageName: "color_4",
            colorName: "Black",
            description: """
            The dramatic black-to-blonde ombre creates striking contrast. Maintaining clean transition lines requires specific care.
            
            Gradient Care:
            1. Use different products on each section
            2. Apply masks to lightened ends
            3. Protect roots when heat styling
            4. Get toner refresh every 6 weeks
            5. Use bond repair treatments
            
            Damage Prevention:
            • Limit bleaching sessions
            • Space out color processes
            • Use protein treatments
            • Try cold water rinses
            • Get professional trims
            """
        ),
        HairRecommendation(
            id: "color_5",
            type: "color",
            styleName: "Vibrant Red",
            imageName: "color_5",
            colorName: "Red",
            description: """
            Rich red hues require extra maintenance to prevent fading. These pro tips will keep color vibrant longer.
            
            Color Preservation:
            - Wash with sulfate-free formulas
            - Use color-depositing conditioners
            - Rinse with apple cider vinegar
            - Avoid hot showers
            - Wear hats in sunlight
            
            Red-Specific Care:
            • Use green shampoo to neutralize brass
            • Apply gloss treatments monthly
            • Try color-locking serums
            • Get root touch-ups often
            • Avoid chlorine completely
            """
        )
    ]
}

// Create HairDetailViewController.swift
import UIKit

class HairDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var recommendation: HairRecommendation?
    private let tableView = UITableView()
    private let imageView = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupTableView()
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DescriptionCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        setupHeader()
        tableView.tableFooterView = createFooterView()
    }

    private func setupHeader() {
        guard let rec = recommendation else { return }

        let header = UIView()

        imageView.image = UIImage(named: rec.imageName)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false

        let styleLabel = UILabel()
        styleLabel.text = rec.styleName
        styleLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        styleLabel.translatesAutoresizingMaskIntoConstraints = false

        let colorLabel = UILabel()
        colorLabel.text = "Color: \(rec.colorName)"
        colorLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        colorLabel.textColor = .darkGray
        colorLabel.translatesAutoresizingMaskIntoConstraints = false

        header.addSubview(imageView)
        header.addSubview(styleLabel)
        header.addSubview(colorLabel)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: header.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: header.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: header.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: header.widthAnchor),

            styleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            styleLabel.centerXAnchor.constraint(equalTo: header.centerXAnchor),

            colorLabel.topAnchor.constraint(equalTo: styleLabel.bottomAnchor, constant: 8),
            colorLabel.centerXAnchor.constraint(equalTo: header.centerXAnchor),
            colorLabel.bottomAnchor.constraint(equalTo: header.bottomAnchor, constant: -10)
        ])

        header.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width + 80)
        tableView.tableHeaderView = header
    }

    private func createFooterView() -> UIView {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackView)

        let colorImageNames = [
            "Grass_green", "Peacock_green", "Gray_blue", "Glamour_purple",
            "Neptune_Red", "Milk_golden", "Naturally_black"
        ]

        for color in colorImageNames {
            let img = UIImage(named: color)
            let colorView = UIImageView(image: img)
            colorView.layer.cornerRadius = 6
            colorView.clipsToBounds = true
            colorView.contentMode = .scaleAspectFill
            colorView.isUserInteractionEnabled = true
            colorView.widthAnchor.constraint(equalToConstant: 80).isActive = true
            colorView.heightAnchor.constraint(equalToConstant: 80).isActive = true
            colorView.accessibilityIdentifier = color
            colorView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(colorTapped(_:))))
            stackView.addArrangedSubview(colorView)
        }

        let restoreButton = UIButton(type: .system)
        restoreButton.setTitle("Restore Default", for: .normal)
        restoreButton.setTitleColor(.systemBlue, for: .normal)
        restoreButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        restoreButton.translatesAutoresizingMaskIntoConstraints = false
        restoreButton.addTarget(self, action: #selector(restoreOriginalImage), for: .touchUpInside)

        let footer = UIView()
        footer.addSubview(scrollView)
        footer.addSubview(restoreButton)

        scrollView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: footer.topAnchor, constant: 16),
            scrollView.leadingAnchor.constraint(equalTo: footer.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: footer.trailingAnchor),
            scrollView.heightAnchor.constraint(equalToConstant: 100),

            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),

            restoreButton.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 12),
            restoreButton.centerXAnchor.constraint(equalTo: footer.centerXAnchor),
            restoreButton.bottomAnchor.constraint(equalTo: footer.bottomAnchor, constant: -20)
        ])

        footer.frame.size = CGSize(width: view.frame.width, height: 160)
        return footer
    }

    @objc private func colorTapped(_ sender: UITapGestureRecognizer) {
        if let view = sender.view, let name = view.accessibilityIdentifier {
            imageView.image = UIImage(named: name)
        }
    }

    @objc private func restoreOriginalImage() {
        if let rec = recommendation {
            imageView.image = UIImage(named: rec.imageName)
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recommendation != nil ? 1 : 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.selectionStyle = .none

        let textView = UITextView()
        textView.text = recommendation?.description
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textColor = .gray
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.isSelectable = false
        textView.textContainerInset = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
        textView.backgroundColor = .clear
        textView.translatesAutoresizingMaskIntoConstraints = false

        cell.contentView.addSubview(textView)

        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
            textView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor),
            textView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor)
        ])

        return cell
    }
}
