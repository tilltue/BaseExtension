//
//  RxTableViewCustomReloadDataSource.swift
//  AwesomeBlogs
//
//  Created by wade.hawk on 2017. 8. 21..
//  Copyright © 2017년 wade.hawk. All rights reserved.
//

import Foundation
import RxDataSources
import RxSwift
import RxCocoa

class RxTableViewCustomReloadDataSource<S: SectionModelType>: RxTableViewSectionedReloadDataSource<S> {
    
    var reloadEvent: ((Element,Int,Int,S.Item?, S.Item?) -> Void)? = nil
    var reloadedEvent: (() -> Void)? = nil
    
    override func tableView(_ tableView: UITableView, observedEvent: Event<Element>) {
        Binder(self) { [weak self] dataSource, element in
            let oldCount = dataSource.sectionModels.first?.items.count ?? 0
            let oldFirstItem: S.Item? = dataSource.sectionModels.first?.items.first
            dataSource.setSections(element)
            let count = dataSource.sectionModels.first?.items.count ?? 0
            let newFirstItem: S.Item? = dataSource.sectionModels.first?.items.first
            tableView.reloadData()
            self?.reloadEvent?(element,oldCount,count,oldFirstItem, newFirstItem)
            self?.reloadedEvent?()
        }.on(observedEvent)
    }
}

