import Combine
import UIKit

class ApplicationCoordinator: BaseCoordinator<Void, Never> {
    private weak var splitViewController: UISplitViewController?

    init(splitViewController: UISplitViewController) {
        self.splitViewController = splitViewController
    }

    override func run() {
        configureSplitModule()
    }
}

// MARK: - Modules

extension ApplicationCoordinator {
    private func configureSplitModule() {
        splitViewController?.viewControllers = [
            masterModule(),
            detailModule()
        ]
    }

    private func masterModule() -> MasterViewController {
        let controller = MasterModuleFactory().module()

        controller.completion.sink { [weak self] completion in
            guard let splitViewController = self?.splitViewController else {
                return
            }
            switch completion {
            case let .noteSelected(id: id):
                guard let detailViewController = self?.detailViewController() else {
                    return
                }
                splitViewController.show(.secondary)
                detailViewController.selectNote(id: id)
            case .showDetailModule:
                splitViewController.show(.secondary)
            }
        }.store(in: &subscriptions)

        return controller
    }

    private func detailModule() -> DetailViewController {
        let (model, controller) = DetailModuleFactory().module()

        controller.completion.sink { [weak self] completion in
            if case .openNoteDetails(let id) = completion {
                guard let noteDetailsViewController = self?.noteDetailsModule(id: id, detailModel: model) else {
                    return
                }
                controller.present(noteDetailsViewController, animated: true)
            }
        }.store(in: &subscriptions)

        return controller
    }

    private func noteDetailsModule(id: Int, detailModel: DetailModel) -> NoteDetailsViewController? {
        guard let note = Notes.shared.note(id: id) else {
            return nil
        }

        let controller = NoteDetailsModuleFactory().module(note: note)
        controller.noteColor.sink { [weak detailModel] in
            detailModel?.updateNote(id: id, color: $0)
        }.store(in: &subscriptions)
        controller.noteText.sink { [weak detailModel] in
            detailModel?.updateNote(id: id, text: $0)
        }.store(in: &subscriptions)
        controller.completion.sink { [weak detailModel] completion in
            if completion == .closeWithRemoveNote {
                detailModel?.removeNote(model: note)
            } else {
                detailModel?.selectedNote = nil
            }
        }.store(in: &subscriptions)

        return controller
    }
}

// MARK: - Helpers

extension ApplicationCoordinator {
    private func detailViewController() -> DetailViewController? {
        splitViewController?.viewController(for: .secondary) as? DetailViewController
    }
}
