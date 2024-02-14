import UIKit
import Combine

class NoteDetailsView: UIView {
    private lazy var verticalStack = initializeVerticalStack()
    private lazy var colorView = initializeColorView()
    private lazy var descriptionText = initializeDescriptionText()
    private lazy var removeButton = initializeRemoveButton()

    private var initialFrame = CGRect.zero

    private var subscriptions = Set<AnyCancellable>()

    private weak var controller: NoteDetailsViewController?

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        subscribeOnNotificationCenter()
        addSubviews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    deinit {
        unsubscribeFromNotificationCenter()
    }
}

// MARK: - Life cycle

extension NoteDetailsView {
    override func layoutSubviews() {
        super.layoutSubviews()
        updateSubviewsContraints()
    }
}

// MARK: - Initializators

extension NoteDetailsView {
    func initialize(model: NoteDetailsModel, controller: NoteDetailsViewController) {
        self.controller = controller
        subscribeOnModel(model)
    }
}

// MARK: - Configurators

extension NoteDetailsView {
    func configure() {
        backgroundColor = .systemBackground
        clipsToBounds = true
        layer.cornerRadius = 25
        isUserInteractionEnabled = true
    }
}

// MARK: - Subscriptions

extension NoteDetailsView {
    private func subscribeOnNotificationCenter() {
        let center = NotificationCenter.default
        center.addObserver(self,
                           selector: #selector(onKeyboardWillShow),
                           name: UIResponder.keyboardWillShowNotification,
                           object: nil)
        center.addObserver(self,
                           selector: #selector(onKeyboardWillHide),
                           name: UIResponder.keyboardWillHideNotification,
                           object: nil)
    }

    private func unsubscribeFromNotificationCenter() {
        NotificationCenter.default.removeObserver(self)
    }

    private func subscribeOnModel(_ model: NoteDetailsModel) {
        model.$color.sink { [weak self] color in
            self?.colorView.backgroundColor = color
        }.store(in: &subscriptions)

        model.$text.sink { [weak self] text in
            self?.descriptionText.text = text
        }.store(in: &subscriptions)
    }
}

// MARK: - Subviews

extension NoteDetailsView {
    private func initializeVerticalStack() -> UIStackView {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.spacing = 16
        return view
    }

    private func initializeColorView() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.backgroundColor = .systemGray6

        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onColorViewTapped))
        view.addGestureRecognizer(gestureRecognizer)

        return view
    }

    private func initializeDescriptionText() -> UITextView {
        let view = UITextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.backgroundColor = .systemGray6
        view.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        view.font = .systemFont(ofSize: 20)
        view.inputAccessoryView = initializeTextToolbar()
        return view
    }

    private func initializeRemoveButton() -> UIButton {
        let button = UIButton(configuration: .filled())
        button.setTitle("Remove", for: .normal)
        button.addTarget(self, action: #selector(onRemoveButtonTapped), for: .touchUpInside)
        return button
    }

    private func initializeTextToolbar() -> UIToolbar {
        let flexibleButtonItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                             target: self,
                                             action: #selector(onDoneButtonItemTapped))
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        toolbar.items = [flexibleButtonItem, doneButtonItem]
        return toolbar
    }

    private func addSubviews() {
        addSubview(verticalStack)
        verticalStack.addArrangedSubview(colorView)
        verticalStack.addArrangedSubview(descriptionText)
        verticalStack.addArrangedSubview(removeButton)
    }

    private func updateSubviewsContraints() {
        verticalStack.snp.updateConstraints { maker in
            maker.left.right.top.bottom.equalToSuperview().inset(16)
        }
        colorView.snp.updateConstraints { maker in
            maker.height.equalToSuperview().dividedBy(4)
        }
        removeButton.snp.updateConstraints { maker in
            maker.height.equalTo(50)
        }
    }
}

// MARK: - Callbacks

extension NoteDetailsView {
    @objc private func onKeyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }

        if initialFrame == .zero {
            initialFrame = frame
        }
        frame.origin.y = frame.height - keyboardFrame.height - 10

        setNeedsLayout()
    }

    @objc private func onKeyboardWillHide(notification: NSNotification) {
        frame = initialFrame
        setNeedsLayout()
    }

    @objc private func onColorViewTapped() {
        let color = colorView.backgroundColor ?? .white
        controller?.openNoteColorPicker(color: color)
    }

    @objc private func onDoneButtonItemTapped() {
        descriptionText.resignFirstResponder()
        controller?.applyNoteText(text: descriptionText.text)
    }

    @objc private func onRemoveButtonTapped() {
        controller?.removeNote()
    }
}
