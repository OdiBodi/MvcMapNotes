import MapKit

class NoteClusterAnnotationView: MKAnnotationView {
    private lazy var backgroundView = initializeBackgroundView()
    private lazy var numberLabel = initializeNumberLabel()

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)

        configure()
        configureView()

        addSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

// MARK: - Static

extension NoteClusterAnnotationView {
    static let id = "\(NoteClusterAnnotationView.self)"
}

// MARK: - Life cycle

extension NoteClusterAnnotationView {
    override func layoutSubviews() {
        super.layoutSubviews()
        updateSubviewsConstraints()
    }
}

// MARK: - Initializators

extension NoteClusterAnnotationView {
    func initialize(number: Int) {
        numberLabel.text = "\(number)"
    }
}

// MARK: - Configurators

extension NoteClusterAnnotationView {
    private func configure() {
        canShowCallout = false
    }

    private func configureView() {
        frame = CGRect(x: 0, y: 0, width: 50, height: 50)

        backgroundColor = .white

        layer.cornerRadius = 25
        layer.shadowOpacity = 1
        layer.shadowOffset = .zero
        layer.shadowRadius = 5
        layer.shadowColor = UIColor.systemGray.cgColor
    }
}

// MARK: - Subviews

extension NoteClusterAnnotationView {
    private func initializeBackgroundView() -> UIView {
        let view = UIView()
        view.backgroundColor = .systemYellow
        view.layer.cornerRadius = 20
        return view
    }

    private func initializeNumberLabel() -> UILabel {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 24)
        label.textColor = .label
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.layer.cornerRadius = 20
        return label
    }

    private func addSubviews() {
        addSubview(backgroundView)
        addSubview(numberLabel)
    }

    private func updateSubviewsConstraints() {
        backgroundView.snp.updateConstraints { maker in
            maker.left.right.top.bottom.equalToSuperview().inset(10)
        }
        numberLabel.snp.updateConstraints { maker in
            maker.left.right.top.bottom.equalToSuperview().inset(10)
        }
    }
}
