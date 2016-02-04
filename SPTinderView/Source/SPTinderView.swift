//
//  SPTinderView.swift
//  SPTinderView
//
//  Created by Suraj Pathak on 3/2/16.
//  Copyright © 2016 Suraj Pathak. All rights reserved.
//

import UIKit

/**
 *  Protocol that feeds the necessary data for SPTinderView
 */
public protocol SPTinderViewDataSource {
    func numberOfItemsInTinderView(view: SPTinderView) -> Int
    func numberOfVisibleCellsInTinderView(view: SPTinderView) -> Int
    func tinderView(view: SPTinderView, cellAtIndex: Int) -> SPTinderViewCell?
}

/**
 *  `SPTinderViewDelegate` tells the object conforming it about the actions about the cells in `SPTinderView`
 */
public protocol SPTinderViewDelegate {
    func tinderView(view: SPTinderView, didMoveCellAtIndex: Int, towards: SPTinderViewCellMovement)
}

/// `SPTinderView` is view that mimics the behavior of shuffling cards of a deck left or right, as seen in the popular dating app *Tinder*.
public class SPTinderView: UIView {
    
    // Cache
    private var cache: NSCache = NSCache()
    
    var dataSource: SPTinderViewDataSource? {
        didSet {
            
        }
    }
    
    var delegate: SPTinderViewDelegate?
    var currentIndex: Int = 0
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setUpFirstSetOfCells()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func awakeFromNib() {
        setUpFirstSetOfCells()
    }
    
    public override func layoutSubviews() {
        
    }
    
    public func reloadData() {
        
    }
    
    private func setUpFirstSetOfCells() {
        guard let _dataSource = dataSource else { return }
        let count = _dataSource.numberOfItemsInTinderView(self)
        let visibleCount = _dataSource.numberOfVisibleCellsInTinderView(self)
        for var index = currentIndex; index < min(visibleCount, count - index); index++ {
            if let cell = _dataSource.tinderView(self, cellAtIndex: index) {
                self.insertSubview(cell, atIndex: 0)
                cell.center = positionForCellAtIndex(index)
            }
        }
    }
    
    private func positionForCellAtIndex(index: Int) -> CGPoint {
        var _center = center
        _center.y = center.y + CGFloat((index - currentIndex) * 2)
        
        return _center
    }
    
    private func animateCellReposition() {
        
    }
    
    private func animateRemovalForCell(cell: SPTinderViewCell) {
        UIView.animateWithDuration(0.2, animations: {
            cell.alpha = 0.0
            }, completion: { finished in
                cell.removeFromSuperview()
        })
    }
    
    // MARK: Cache and Recycle
    private func setUpCache() {
        guard let _dataSource = dataSource else { return }
        let count = _dataSource.numberOfVisibleCellsInTinderView(self)
        print("\(count)")
    }
    
    private func recycleCell(cell: SPTinderViewCell) {
        
    }
    
    public func registerNib(nib: UINib?, forCellReuseIdentifier identifier: String) {
        guard let _nib = nib else { return }
        if let cell = _nib.instantiateWithOwner(self, options: nil).first as? SPTinderViewCell {
            cache.setObject(cell, forKey: identifier)
        }
    }
    
    public func registerClass(cellClass: AnyClass?, forCellReuseIdentifier identifier: String) {
        if let cell = cellClass where cell is SPTinderViewCell.Type {
            cache.setObject(cell, forKey: identifier)
        }
    }
    
    public func dequeueReusableCellWithIdentifier(identifier: String) -> SPTinderViewCell? {
        return cache.objectForKey(identifier) as? SPTinderViewCell
    }
}
