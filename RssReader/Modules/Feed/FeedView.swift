//
//  FeedView.swift
//  RssReader
//
//  Created by vladislav on 20.09.2020.
//  Copyright © 2020 vladislav. All rights reserved.
//

import UIKit

struct FeedViewConstants {
    static let cellIdentifier = "Cell"
    static let sideOffset = 16
}

public final class FeedView: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var collectionLayout: UICollectionViewFlowLayout! {
        didSet {
            collectionLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loadingLabel: UILabel!
    
    // MARK: - Instantiate
    
    static func instantiate() -> Self {
        UIStoryboard(name: String(describing: Self.self), bundle: nil).instantiateViewController(withIdentifier: String(describing: Self.self)) as! Self
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let presenter = FeedViewPresenter()
        self.presenter = presenter
        presenter.view = self
    }
    
    // MARK: - Properties
    
    public var presenter: FeedPresenter?
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        presenter?.loadData()
    }
    
    fileprivate func setTableView(hidden: Bool) {
        if hidden {
            UIView.animate(withDuration: 0.3, animations: {
                self.collectionView.alpha = 0
            }) { (finished) in
            }
        } else {
            UIView.animate(withDuration: 0.3, animations: {
                self.collectionView.alpha = 1
            }) { (finished) in
            }
        }
    }
}


// MARK: - FeedViewInterface

extension FeedView: FeedViewInterface {
    
    public func update(view state: FeedViewState) {
        switch state {
        case .loaded:
            activityIndicator.stopAnimating()
            setTableView(hidden: false)
            loadingLabel.isHidden = true
            return
        case .empty: return
        case .loading:
            activityIndicator.startAnimating()
            setTableView(hidden: true)
            loadingLabel.isHidden = false
            return
        }
    }
    
    public func updateData() {
        collectionView.reloadData()
    }
    
    public func scrollToItem(_ item: Int) {
        collectionView.scrollToItem(at: IndexPath.init(row: item, section: 0), at: .top, animated: true)
    }
    
    public func openUrl(_ url: URL) {
        UIApplication.shared.open(url)
    }
}

extension FeedView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width - CGFloat(FeedViewConstants.sideOffset*2), height: CGFloat(0)) // fixes bug on launch incorrect cell size
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter?.getNumberOfRows() ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedViewConstants.cellIdentifier, for: indexPath) as? PostCell else {
            return UICollectionViewCell.init()
        }
        guard let item = presenter?.getDataForRow(indexPath.row) else {
            return UICollectionViewCell.init()
        }
        
        cell.titleLabel.text = item.title
        cell.dateLabel.text = item.date
        cell.setWidth(collectionView.bounds.width - CGFloat(FeedViewConstants.sideOffset*2))
        cell.layoutIfNeeded()
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter?.didSelect(row: indexPath.row)
    }
}
