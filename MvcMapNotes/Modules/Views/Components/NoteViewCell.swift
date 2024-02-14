import UIKit

class NoteViewCell: UITableViewCell {
    private lazy var horizontalStack = initializeHorizontalStack()
    private lazy var icon = initializeIcon()
    private lazy var descriptionLabel = initializeDescriptionLabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
        addSubviews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - Static

extension NoteViewCell {
    static let id = "\(NoteViewCell.self)"
}

// MARK: - Life cycle

extension NoteViewCell {
    override func layoutSubviews() {
        super.layoutSubviews()
        updateSubviewsConstraints()
    }
}

// MARK: - Initializators

extension NoteViewCell {
    func initialize(item: NoteItem) {
        icon.initialize(color: item.color, text: item.title, cornerRadius: 40, fontSize: 34)
        descriptionLabel.text = item.title
    }
}

// MARK: - Configurators

extension NoteViewCell {
    func configure() {
        accessoryType = .disclosureIndicator
    }
}

// MARK: - Subviews

extension NoteViewCell {
    private func initializeHorizontalStack() -> UIStackView {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 10
        stack.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 32)
        stack.isLayoutMarginsRelativeArrangement = true
        return stack
    }

    private func initializeIcon() -> NoteIconView {
        let view = NoteIconView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }

    private func initializeDescriptionLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 3
        return label
    }

    private func addSubviews() {
        contentView.addSubview(horizontalStack)
        horizontalStack.addArrangedSubview(icon)
        horizontalStack.addArrangedSubview(descriptionLabel)
    }

    private func updateSubviewsConstraints() {
        horizontalStack.snp.updateConstraints { maker in
            maker.left.right.top.bottom.equalToSuperview()
        }
        icon.snp.updateConstraints { maker in
            maker.top.bottom.equalToSuperview().inset(10)
            maker.width.equalTo(80)
        }
    }
}
