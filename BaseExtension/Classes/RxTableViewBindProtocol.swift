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

public protocol RxTableCellViewModel: IdentifiableType, Equatable {
    var cellIdentifier: String { get }
    var canEdit: Bool { get set }
}

extension RxTableCellViewModel {
    var canEdit: Bool {
        get { return false }
        set { }
    }
}

public struct RxTableViewBindProperty<ModelType: RxTableCellViewModel> {
    public var cellNibSet = [String]()
    public var bindViewModels = BehaviorRelay<[AnimatableSectionModel<String,ModelType>]>(value: [])
    public var selectedCell = PublishSubject<(IndexPath,ModelType)>()
    public var deletedCell = PublishSubject<(IndexPath,ModelType)>()
    public var reloaded = PublishSubject<Void>()
    public var insideCellEvent = PublishSubject<Any>()
    public init() {
        
    }
}

public protocol RxTableViewBindProtocol: class {
    associatedtype ModelType: RxTableCellViewModel
    var bindProperty: RxTableViewBindProperty<ModelType> { get set }
    var disposeBag: DisposeBag { get set }
    func bindDataSource(tableView: UITableView)
    func createDataSource(tableView: UITableView) -> RxTableViewCustomReloadDataSource<SectionModelType>
}

extension RxTableViewBindProtocol {
    
    public typealias SectionModelType = AnimatableSectionModel<String,ModelType>
    
    public func bindDataSource(tableView: UITableView) {
        register(tableView: tableView, nibNameSet: self.bindProperty.cellNibSet)
        let dataSource = createDataSource(tableView: tableView)
        dataSource.canEditRowAtIndexPath = { [weak self] (ds, IndexPath) -> Bool in
            guard let bindViewModels = self?.bindProperty.bindViewModels else { return false }
            return bindViewModels.value[IndexPath.section].items[IndexPath.row].canEdit
        }
        dataSource.reloadedEvent = { [weak self] in
            guard let property = self?.bindProperty else { return }
            property.reloaded.on(.next(()))
        }
        self.bindProperty.bindViewModels.asObservable().bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        tableView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
            guard let property = self?.bindProperty else { return }
            guard let sectionModel = (property.bindViewModels.value.filter{ $0.model == "section\(indexPath.section)" }.first) else { return }
            property.selectedCell.on(.next((indexPath, sectionModel.items[indexPath.row])))
        }).disposed(by: disposeBag)
        tableView.rx.itemDeleted.subscribe(onNext: { [weak self] indexPath in
            guard let property = self?.bindProperty else { return }
            guard let sectionModel = (property.bindViewModels.value.filter{ $0.model == "section\(indexPath.section)" }.first) else { return }
            property.deletedCell.on(.next((indexPath, sectionModel.items[indexPath.row])))
        }).disposed(by: disposeBag)
    }
    
    private func cellViewModel(at indexPath: IndexPath) -> ModelType? {
        let bindViewModels = self.bindProperty.bindViewModels.value
        guard indexPath.section < bindViewModels.count else { return nil }
        guard indexPath.row < bindViewModels[indexPath.section].items.count else { return nil }
        return bindViewModels[indexPath.section].items[indexPath.row]
    }
    
    private func register(tableView: UITableView, nibNameSet: [String]) {
        for nibName in nibNameSet {
            let nib = UINib(nibName: nibName, bundle: nil)
            tableView.register(nib, forCellReuseIdentifier: nibName)
        }
    }
}
