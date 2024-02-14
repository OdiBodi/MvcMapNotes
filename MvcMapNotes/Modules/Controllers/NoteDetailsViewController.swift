import UIKit
import Combine

class NoteDetailsViewController: BaseCoordinatorModule<NoteDetailsModuleCompletion, Never> {
    private let transitioning = NoteTransitioning()

    private var keyWindowTapGestureRecognizer: UITapGestureRecognizer?

    private var model: NoteDetailsModel?
}

// MARK: - Publishers

extension NoteDetailsViewController {
    var noteColor: AnyPublisher<UIColor, Never> {
        model?.$color.eraseToAnyPublisher() ?? Empty<UIColor, Never>().eraseToAnyPublisher()
    }

    var noteText: AnyPublisher<String, Never> {
        model?.$text.eraseToAnyPublisher() ?? Empty<String, Never>().eraseToAnyPublisher()
    }
}

// MARK: - Life cycle

extension NoteDetailsViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addTapGestureRecognizerToKeyWindow()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeTapGestureRecognizerFromKeyWindow()
    }
}

// MARK: - Initializators

extension NoteDetailsViewController {
    func initialize(model: NoteDetailsModel, view: NoteDetailsView) {
        self.model = model
        self.view = view

        transitioningDelegate = transitioning
        modalPresentationStyle = .custom
    }
}

// MARK: - Gesture recognizers

extension NoteDetailsViewController {
    private func addTapGestureRecognizerToKeyWindow() {
        keyWindowTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onKeyWindowTapped))
        UIApplication.shared.keyWindow?.addGestureRecognizer(keyWindowTapGestureRecognizer!)
    }

    private func removeTapGestureRecognizerFromKeyWindow() {
        guard let gestureRecognizer = keyWindowTapGestureRecognizer else {
            return
        }
        UIApplication.shared.keyWindow?.removeGestureRecognizer(gestureRecognizer)
    }
}

// MARK: - Note

extension NoteDetailsViewController {
    func openNoteColorPicker(color: UIColor) {
        let picker = UIColorPickerViewController()
        picker.delegate = self
        picker.selectedColor = color
        picker.supportsAlpha = false
        present(picker, animated: true)
    }

    func applyNoteText(text: String) {
        model?.text = text
    }

    func removeNote() {
        completionSubject.send(.closeWithRemoveNote)
        dismiss(animated: true)
    }
}

// MARK: - UIColorPickerViewControllerDelegate

extension NoteDetailsViewController: UIColorPickerViewControllerDelegate {
    func colorPickerViewController(_ viewController: UIColorPickerViewController,
                                   didSelect color: UIColor,
                                   continuously: Bool) {
        guard !continuously else {
            return
        }
        model?.color = viewController.selectedColor
    }
}

// MARK: - Callbacks

extension NoteDetailsViewController {
    @objc private func onKeyWindowTapped(gestureRecognizer: UITapGestureRecognizer) {
        completionSubject.send(.close)
        dismiss(animated: true)
    }
}
