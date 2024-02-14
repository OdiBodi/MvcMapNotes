import UIKit
import Combine

class MasterView: UIView {
    private lazy var tableView = initializeTableView()

    private var notesDataSource: NotesDataSource?

    private var subscriptions = Set<AnyCancellable>()

    private weak var controller: MasterViewController?

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        addSubviews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - Life cycle

extension MasterView {
    override func layoutSubviews() {
        super.layoutSubviews()
        updateSubviewsConstraints()
    }
}

// MARK: - Initializators

extension MasterView {
    func initialize(model: MasterModel, controller: MasterViewController) {
        self.controller = controller

        model.notesUpdated.sink { [weak self] in
            guard !(self?.isHidden ?? false) else {
                return
            }
            var snapshot = NSDiffableDataSourceSnapshot<NoteSection, NoteItem>()
            snapshot.appendSections([.main])
            snapshot.appendItems($0.map { NoteItem(id: $0.id, color: $0.color, title: $0.text) })
            self?.notesDataSource?.apply(snapshot, animatingDifferences: true)
        }.store(in: &subscriptions)
    }

    private func initializeNotesDataSource(for tableView: UITableView) -> NotesDataSource {
        notesDataSource = NotesDataSource(tableView: tableView) { tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: NoteViewCell.id, for: indexPath) as! NoteViewCell
            cell.initialize(item: item)
            return cell
        }

        notesDataSource!.needToRemoveNote = { [weak self] in
            self?.controller?.removeNote(id: $0)
        }

        return notesDataSource!
    }
}

// MARK: - Configurators

extension MasterView {
    private func configure() {
        backgroundColor = .systemBackground
    }
}

// MARK: - Subviews

extension MasterView {
    private func initializeTableView() -> UITableView {
        let view = UITableView(frame: .zero, style: .plain)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.allowsMultipleSelection = false
        view.register(NoteViewCell.self, forCellReuseIdentifier: NoteViewCell.id)
        view.delegate = self
        view.dataSource = initializeNotesDataSource(for: view)
        view.separatorInset = UIEdgeInsets(top: 0, left: 100, bottom: 0, right: 0)
        return view
    }

    private func addSubviews() {
        addSubview(tableView)
    }

    private func updateSubviewsConstraints() {
        tableView.snp.updateConstraints { maker in
            maker.left.top.right.equalToSuperview()
            maker.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
        }
    }
}

// MARK: - UITableViewDelegate

extension MasterView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        guard let item = notesDataSource?.itemIdentifier(for: indexPath) else {
            return
        }

        controller?.selectNote(id: item.id)
    }
}
