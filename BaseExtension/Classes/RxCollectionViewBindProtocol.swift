//
//  RxCollectionViewBindProtocol.swift
//  BaseExtension
//
//  Created by wade.hawk on 17/11/2018.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

public protocol RxCellViewModel: IdentifiableType, Equatable {
    var cellIdentifier: String { get }
}

public struct RxDataSourceBindProperty<ModelType: RxCellViewModel> {
    public var cellNibSet = [String]()
    public var bindViewModels = BehaviorRelay<[AnimatableSectionModel<String,ModelType>]>(value: [])
    public var selectedCell = PublishSubject<(IndexPath,ModelType)>()
    public var deletedCell = PublishSubject<(IndexPath,ModelType)>()
    public var reloaded = PublishSubject<Void>()
    public var insideCellEvent = PublishSubject<Any>()
    public init() {
        
    }
}

public protocol RxCollectionViewBindProtocol: class {
    associatedtype ModelType: RxCellViewModel
    var bindProperty: RxDataSourceBindProperty<ModelType> { get set }
    var disposeBag: DisposeBag { get set }
    func createDataSource(collectionView: UICollectionView) -> RxCollectionViewCustomReloadDataSource<SectionModelType>
}

extension RxCollectionViewBindProtocol {
    
    public typealias SectionModelType = AnimatableSectionModel<String,ModelType>
    
    public func bindDataSource(collectionView: UICollectionView) {
        register(collectionView: collectionView, nibNameSet: self.bindProperty.cellNibSet)
        let dataSource = createDataSource(collectionView: collectionView)
        dataSource.reloadedEvent = { [weak self] in
            guard let property = self?.bindProperty else { return }
            property.reloaded.on(.next(()))
        }
        self.bindProperty.bindViewModels.asObservable().bind(to: collectionView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        collectionView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
            guard let property = self?.bindProperty else { return }
            guard let sectionModel = (property.bindViewModels.value.filter{ $0.model == "section\(indexPath.section)" }.first) else { return }
            property.selectedCell.on(.next((indexPath, sectionModel.items[indexPath.row])))
        }).disposed(by: disposeBag)
    }
    
    private func cellViewModel(at indexPath: IndexPath) -> ModelType? {
        let bindViewModels = self.bindProperty.bindViewModels.value
        guard indexPath.section < bindViewModels.count else { return nil }
        guard indexPath.row < bindViewModels[indexPath.section].items.count else { return nil }
        return bindViewModels[indexPath.section].items[indexPath.row]
    }
    
    private func register(collectionView: UICollectionView, nibNameSet: [String]) {
        for nibName in nibNameSet {
            let nib = UINib(nibName: nibName, bundle: nil)
            collectionView.register(nib, forCellWithReuseIdentifier: nibName)
        }
    }
}
