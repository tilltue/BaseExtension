//
//  RxCollectionViewCustomReloadDataSource.swift
//  BaseExtension
//
//  Created by wade.hawk on 17/11/2018.
//

import Foundation
import RxDataSources
import RxSwift
import RxCocoa

open class RxCollectionViewCustomReloadDataSource<S: SectionModelType>: RxCollectionViewSectionedReloadDataSource<S> {
    
    public var reloadEvent: ((Element,Int,Int,S.Item?, S.Item?) -> Void)? = nil
    public var reloadedEvent: (() -> Void)? = nil
    
    override open func collectionView(_ collectionView: UICollectionView, observedEvent: Event<[S]>) {
        Binder(self) { [weak self] dataSource, element in
            let oldCount = dataSource.sectionModels.first?.items.count ?? 0
            let oldFirstItem: S.Item? = dataSource.sectionModels.first?.items.first
            dataSource.setSections(element)
            let count = dataSource.sectionModels.first?.items.count ?? 0
            let newFirstItem: S.Item? = dataSource.sectionModels.first?.items.first
            collectionView.reloadData()
            self?.reloadEvent?(element, oldCount, count, oldFirstItem, newFirstItem)
            self?.reloadedEvent?()
        }.on(observedEvent)
    }
}

