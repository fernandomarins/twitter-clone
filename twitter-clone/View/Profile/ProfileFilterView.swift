//
//  ProfileFilterView.swift
//  twitter-clone
//
//  Created by Fernando Marins on 05/05/22.
//

import UIKit

protocol ProfileFilterDelegate: AnyObject {
    func filterView(_ view: ProfileFilterView, didSelect index: Int)
}

class ProfileFilterView: UIView {
    
    // MARK: - Properties
    
    private let reuseIdentifier = "profileFilterCell"
    
    weak var delegate: ProfileFilterDelegate?
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        
        return collectionView
    }()
    
    private let underLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .twitterBlue
        return view
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // making sure the first cell is selected
        let selectedIndex = IndexPath(row: 0, section: 0)
        collectionView.selectItem(at: selectedIndex, animated: true, scrollPosition: .left)
        
        collectionView.register(ProfileFilterCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        addSubview(collectionView)
        collectionView.addConstraintsToFillView(self)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addSubview(underLineView)
        underLineView.anchor(
            left: leftAnchor,
            bottom: bottomAnchor,
            width: frame.width / 3,
            height: 2
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ProfileFilterView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ProfileFilterCell
        
        let option = ProfileFilterOptions(rawValue: indexPath.row)
        cell.option = option
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // using all cases is only possible  because we added the CaseIterabable protocol
        return ProfileFilterOptions.allCases.count
    }
    
}

extension ProfileFilterView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // getting the select cell
        let cell = collectionView.cellForItem(at: indexPath)

        // getting the select cell's x position
        let xPosition = cell?.frame.origin.x ?? 0
        UIView.animate(withDuration: 0.3) { [weak self] in
            // changing the underline view's origin to be like the cell so the animation can work
            self?.underLineView.frame.origin.x = xPosition
        }
        delegate?.filterView(self, didSelect: indexPath.row)
    }
}

extension ProfileFilterView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // we divide the width by 3 because we got 3 items
        let count = CGFloat(ProfileFilterOptions.allCases.count)
        return CGSize(width: frame.width / count, height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        // we set the space between the items
        return 0
    }
}


