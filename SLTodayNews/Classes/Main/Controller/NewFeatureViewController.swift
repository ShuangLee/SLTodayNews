//
//  NewFeatureViewController.swift
//  SLTodayNews
//
//  Created by 浮生若梦 on 2016/11/10.
//  Copyright © 2016年 Ls. All rights reserved.
//

import UIKit
private let pageCount = 4
private let newFeatureReuseIdentifier = "newFeatureReuseIdentifier"
class NewFeatureViewController: BaseViewController {

    private lazy var collectionView: UICollectionView = {
        let clv = UICollectionView(frame: CGRect.zero, collectionViewLayout: NewfeatureLayout())
        // 设置collectionView的属性
        clv.showsHorizontalScrollIndicator = false
        clv.bounces = false
        clv.isPagingEnabled = true
        clv.delegate = self
        clv.dataSource = self
        // 🈲️禁止将 AutoresizingMask 转换为 Constraints
        clv.translatesAutoresizingMaskIntoConstraints = false
        
        //注册cell
        clv.register(NewfeatureCell.self, forCellWithReuseIdentifier: newFeatureReuseIdentifier)
        
        return clv
    }()
    
    fileprivate lazy var pageControl: UIPageControl = {
        let pcl = UIPageControl()
        pcl.numberOfPages = pageCount
        pcl.currentPage = 0
        // 🈲️禁止将 AutoresizingMask 转换为 Constraints
        pcl.translatesAutoresizingMaskIntoConstraints = false
        
        return pcl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        view.addSubview(pageControl)
        
        //设置约束
        let leftConstraint = NSLayoutConstraint(item: collectionView, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: .left, multiplier: 1.0, constant: 0)
        let rightConstraint = NSLayoutConstraint(item: collectionView, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: .right, multiplier: 1.0, constant: 0)
        let topConstraint = NSLayoutConstraint(item: collectionView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: .top, multiplier: 1.0, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: collectionView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: 0)
        view.addConstraints([leftConstraint,rightConstraint,topConstraint,bottomConstraint])
        
        let heightContraint = NSLayoutConstraint(item: pageControl, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0.0, constant: 20)
        pageControl.addConstraint(heightContraint)
        
        let left1Constraint = NSLayoutConstraint(item: pageControl, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: .left, multiplier: 1.0, constant: 0)
        let right1Constraint = NSLayoutConstraint(item: pageControl, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: .right, multiplier: 1.0, constant: 0)
        let bottom1Constraint = NSLayoutConstraint(item: pageControl, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: -30)
        view.addConstraints([left1Constraint,right1Constraint,bottom1Constraint])
    }
    
    //MARK: - 隐藏状态栏
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

extension NewFeatureViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    @available(iOS 6.0, *)
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pageCount
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 1.获取cell
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: newFeatureReuseIdentifier, for: indexPath) as! NewfeatureCell
        
        // 2.设置cell的数据
        cell.imageIndex = indexPath.item
        
        // 3.返回cell
        return cell
    }
    
    // 完全显示一个cell之后调用
    // 参数中的 cell & indexPath 是之前消失的 cell，而不是当前显示的 cell 的
    public func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        // 传递给我们的是上一页的索引
        //        print(indexPath)
        
        // 1.拿到当前显示的cell对应的索引
        let path = collectionView.indexPathsForVisibleItems.last! as NSIndexPath
        // 设置pagecontrol的页码
        pageControl.currentPage = path.item
        //print(path)

        if path.item == (pageCount - 1)
        {
            // 2.拿到当前索引对应的cell
            let cell = collectionView.cellForItem(at: path as IndexPath) as! NewfeatureCell
            // 3.让cell执行按钮动画
            cell.startBtnAnimation()
        }
    }
}


// 如果当前类需要监听按钮的点击方法, 那么当前类不能是私有的private
class NewfeatureCell: UICollectionViewCell
{
    /// 保存图片的索引
    fileprivate var imageIndex:Int? {
        didSet{
            if imageIndex != pageCount - 1 {
                startButton.isHidden = true
            }
            
            var placeholderImageName: String?
            switch UIScreen.main.bounds.size.height {
            case 480:
                placeholderImageName = "guide_35_\(imageIndex! + 1)"
            case 568:
                placeholderImageName = "guide_40_\(imageIndex! + 1)"
            case 667:
                //由于这里没有4.7寸 5.5寸图片 全部使用4.0寸
                //placeholderImageName = "guide_47_\(imageIndex! + 1)"
                placeholderImageName = "guide_40_\(imageIndex! + 1)"
            default:
                //placeholderImageName = "guide_55_\(imageIndex! + 1)"
                placeholderImageName = "guide_40_\(imageIndex! + 1)"
            }
            
            //print(placeholderImageName!)
            iconView.image = UIImage(named: placeholderImageName!)
        }
    }
    
    /**
     让按钮做动画
     */
    func startBtnAnimation()
    {
        startButton.isHidden = false
        
        // 执行动画
        startButton.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        startButton.isUserInteractionEnabled = false
        
        UIView.animate(withDuration: 2, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 10, options: UIViewAnimationOptions(rawValue: 0), animations: { () -> Void in
            // 清空形变
            self.startButton.transform = CGAffineTransform.identity
            }, completion: { (_) -> Void in
                self.startButton.isUserInteractionEnabled = true
        })
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 1.初始化UI
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func customBtnClick()
    {
        // 去主页
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: NewFeatureViewControllerDidFinishedGuide), object: true)
    }
    
    private func setupUI(){
        // 1.添加子控件到contentView上
        iconView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(iconView)
        contentView.addSubview(startButton)
        
        // 2.布局子控件的位置
        let leftConstraint = NSLayoutConstraint(item: iconView, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: contentView, attribute: .left, multiplier: 1.0, constant: 0)
        let rightConstraint = NSLayoutConstraint(item: iconView, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: contentView, attribute: .right, multiplier: 1.0, constant: 0)
        let topConstraint = NSLayoutConstraint(item: iconView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: contentView, attribute: .top, multiplier: 1.0, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: iconView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: contentView, attribute: .bottom, multiplier: 1.0, constant: 0)
        contentView.addConstraints([leftConstraint,rightConstraint,topConstraint,bottomConstraint])
        
        
        let centerConstraint = NSLayoutConstraint(item: startButton, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: contentView, attribute: .centerX, multiplier: 1.0, constant: 0)
        let bottom1Constraint = NSLayoutConstraint(item: startButton, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: contentView, attribute: .bottom, multiplier: 1.0, constant: -100)
        contentView.addConstraints([centerConstraint,bottom1Constraint])
    }
    
    // MARK: - 懒加载
    private lazy var iconView = UIImageView()
    private lazy var startButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setBackgroundImage(UIImage(named: "icon_next"), for: UIControlState.normal)
        
        btn.isHidden = true
        btn.addTarget(self, action: #selector(NewfeatureCell.customBtnClick), for: UIControlEvents.touchUpInside)
        return btn
    }()
}

/// 自定义布局
class NewfeatureLayout: UICollectionViewFlowLayout {
    // 准备布局
    override func prepare() {
        // 1.设置layout布局
        itemSize = UIScreen.main.bounds.size
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
        scrollDirection = UICollectionViewScrollDirection.horizontal
    }
}
