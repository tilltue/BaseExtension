//
//  RxTableViewBindProtocol.swift
//  BaseExtension
//
//  Created by wade.hawk on 2017. 12. 9..
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

protocol RxTableCellViewModel: IdentifiableType, Equatable {
    var cellIdentifier: String { get }
    var canEdit: Bool { get set }
}

extension RxTableCellViewModel {
    var canEdit: Bool {
        get { return false }
        set { }
    }
}

struct RxTableViewBindProperty<ModelType: RxTableCellViewModel> {
    var cellNibSet = [String]()
    var bindViewModels = BehaviorSubject<[AnimatableSectionModel<String,ModelType>]>(value: [])
    var selectedCell = PublishSubject<(IndexPath,ModelType)>()
    var reloaded = PublishSubject<Void>()
    var insideCellEvent = PublishSubject<Any>()
    var cellViewModels: [AnimatableSectionModel<String,ModelType>] {
        get {
            do {
                return try self.bindViewModels.value()
            }catch { return [] }
        }
    }
}

protocol RxTableViewBindProtocol: class {
    associatedtype ModelType: RxTableCellViewModel
    var bindProperty: RxTableViewBindProperty<ModelType> { get set }
    var disposeBag: DisposeBag { get set }
    func bindDataSource(tableView: UITableView)
    func createDataSource(tableView: UITableView) -> RxTableViewCustomReloadDataSource<SectionModelType>
}

extension RxTableViewBindProtocol {
    
    typealias SectionModelType = AnimatableSectionModel<String,ModelType>
    
    func bindDataSource(tableView: UITableView) {
        register(tableView: tableView, nibNameSet: self.bindProperty.cellNibSet)
        let dataSource = createDataSource(tableView: tableView)
        dataSource.canEditRowAtIndexPath = { [weak self] (ds, IndexPath) -> Bool in
            guard let property = self?.bindProperty else { return false }
            return property.cellViewModels[IndexPath.section].items[IndexPath.row].canEdit
        }
        dataSource.reloadedEvent = { [weak self] in
            guard let property = self?.bindProperty else { return }
            property.reloaded.on(.next(()))
        }
        self.bindProperty.bindViewModels.asObserver().bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        tableView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
            guard let property = self?.bindProperty else { return }
            guard let sectionModel = (property.cellViewModels.filter{ $0.model == "section\(indexPath.section)" }.first) else { return }
            property.selectedCell.on(.next((indexPath, sectionModel.items[indexPath.row])))
        }).disposed(by: disposeBag)
        tableView.rx.itemDeleted.subscribe(onNext: { [weak self] indexPath in
            guard let property = self?.bindProperty else { return }
            var fetchViewModels = property.cellViewModels[indexPath.section]
            fetchViewModels.items.remove(at: indexPath.row)
            property.bindViewModels.on(.next([fetchViewModels]))
        }).disposed(by: disposeBag)
    }
    
    private func cellViewModel(at indexPath: IndexPath) -> ModelType? {
        let cellViewModels = self.bindProperty.cellViewModels
        guard indexPath.section < cellViewModels.count else { return nil }
        guard indexPath.row < cellViewModels[indexPath.section].items.count else { return nil }
        return cellViewModels[indexPath.section].items[indexPath.row]
    }
    
    private func register(tableView: UITableView, nibNameSet: [String]) {
        for nibName in nibNameSet {
            let nib = UINib(nibName: nibName, bundle: nil)
            tableView.register(nib, forCellReuseIdentifier: nibName)
        }
    }
}
