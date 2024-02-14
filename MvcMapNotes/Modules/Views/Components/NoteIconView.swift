import UIKit

class NoteIconView: UIView {
    private lazy var colorView = initializeColorView()
    private lazy var textLabel = initializeTextLabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - Life cycle

extension NoteIconView {
    override func layoutSubviews() {
        super.layoutSubviews()
        updateSubviewsConstraints()
    }
}

// MARK: - Initializators

extension NoteIconView {
    func initialize(color: UIColor, text: String, cornerRadius: CGFloat = 20, fontSize: CGFloat = 24) {
        clipsToBounds = true
        layer.cornerRadius = cornerRadius

        colorView.backgroundColor = color

        textLabel.text = String(text.prefix(2))
        textLabel.font = .boldSystemFont(ofSize: fontSize)
    }
}

// MARK: - Subviews

extension NoteIconView {
    private func initializeColorView() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }

    private func initializeTextLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        return label
    }

    private func addSubviews() {
        addSubview(colorView)
        addSubview(textLabel)
    }

    private func updateSubviewsConstraints() {
        colorView.snp.updateConstraints { maker in
            maker.left.right.top.bottom.equalToSuperview()
        }
        textLabel.snp.updateConstraints { maker in
            maker.left.right.top.bottom.equalToSuperview()
        }
    }
}
