import MapKit
import SnapKit

class NoteAnnotationView: MKAnnotationView {
    private lazy var icon: NoteIconView = initializeIcon()

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)

        configure()
        configureView()

        addSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        animateSelection(selected: selected)
    }
}

// MARK: - Static

extension NoteAnnotationView {
    static let id = "\(NoteAnnotationView.self)"
}

// MARK: - Life cycle

extension NoteAnnotationView {
    override func layoutSubviews() {
        super.layoutSubviews()
        updateSubviewsConstraints()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        configure()
    }
}

// MARK: - Initializators

extension NoteAnnotationView {
    func initialize(note: NoteAnnotation) {
        icon.initialize(color: note.color, text: String(note.text.prefix(2)))
    }
}

// MARK: - Configurators

extension NoteAnnotationView {
    private func configure() {
        canShowCallout = false
        clusteringIdentifier = "note"
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

extension NoteAnnotationView {
    private func initializeIcon() -> NoteIconView {
        NoteIconView()
    }

    private func addSubviews() {
        addSubview(icon)
    }

    private func updateSubviewsConstraints() {
        icon.snp.updateConstraints { maker in
            maker.left.right.top.bottom.equalToSuperview().inset(10)
        }
    }
}

// MARK: - Animations

extension NoteAnnotationView {
    private func animateSelection(selected: Bool) {
        let backgroundColor = selected ? UIColor.systemPink : .white
        let shadowRadius = selected ? CGFloat(7) : 5
        let transform = selected ? CGAffineTransform(scaleX: 1.5, y: 1.5) : CGAffineTransform.identity

        UIView.animate(withDuration: 0.25) { [weak self] in
            self?.backgroundColor = backgroundColor
            self?.layer.shadowRadius = shadowRadius
        }

        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.3,
                       initialSpringVelocity: 0.3) { [weak self] in
            self?.transform = transform
        }
    }
}
