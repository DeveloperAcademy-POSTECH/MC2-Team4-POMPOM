//
//  ClothViewModel.swift
//  POMPOM
//
//  Created by GOngTAE on 2022/07/04.
//

import Combine
import Foundation

final class ClothViewModel: ObservableObject {
    @Published private(set) var hex: String = "FFFFFF"
    @Published private(set) var mainImageString: String = ""
    @Published private(set) var strokeIamgeString: String = ""
    @Published private(set) var strokeHex: String = "000000"
    @Published private(set) var isEmpty: Bool = true
    let category: ClothCategory
    
    private let clothSubject = CurrentValueSubject<Cloth?, Never>(nil)
    private var cancellables = Set<AnyCancellable>()
    
    init(cloth: Cloth?, category: ClothCategory) {
        self.category = category
        
        let clothSharedPublisher = clothSubject
            .compactMap { $0 }
            .share()
        
        clothSharedPublisher
            .map(\.hex)
            .removeDuplicates()
            .assign(to: \.hex, on: self)
            .store(in: &cancellables)
        
        clothSharedPublisher
            .map(\.hex)
            .removeDuplicates()
            .map { hex in
                // //MARK: 옷 색에 따라 테두리 색을 바꿔주는 map 필요
                if hex == "000000" {
                    return "DADADA"
                } else {
                    return "121212"
                }
            }
            .assign(to: \.strokeHex, on: self)
            .store(in: &cancellables)
        
        clothSharedPublisher
            .map(\.id)
            .removeDuplicates()
            .sink { id in
                if !id.isEmpty && id != " " {
                    self.mainImageString = "\(category)-\(id)B"
                    self.strokeIamgeString = "\(category)-\(id)"
                }
            }
            .store(in: &cancellables)
        
        if let cloth = cloth {
            clothSubject.send(cloth)
        }
    }
}
