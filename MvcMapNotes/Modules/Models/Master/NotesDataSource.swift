import UIKit

class NotesDataSource: UITableViewDiffableDataSource<NoteSection, NoteItem> {
    var needToRemoveNote: ((Int) -> Void)?

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }

    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        super.tableView(tableView, commit: editingStyle, forRowAt: indexPath)
        if editingStyle == .delete {
            let item = snapshot().itemIdentifiers[indexPath.item]
            needToRemoveNote?(item.id)
        }
    }
}
