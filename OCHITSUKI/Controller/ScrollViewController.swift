//
//  ScrollViewController.swift
//  OCHITSUKI
//
//  Created by Yoshitaka on 2020/10/18.
//  Copyright © 2020 Yoshitaka. All rights reserved.
//

import UIKit

class ScrollViewController: UIViewController {
    
    let numberOfPages = 5
    let colors: [UIColor] = [.yellow, .gray, .red, .blue, .brown]
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSV()
        
        
        scrollView.isPagingEnabled = true
        
    }
    
    
    func createLabel(contentsView: UIView) -> UILabel {
        
        // labelを作る
        let label = UILabel()
        
        // labelの座標をcontentsViewの中心にする
        let labelX = contentsView.center.x
        let labelY = contentsView.center.y
        label.frame = CGRect(x: labelX, y: labelY, width: 95, height: 50)
        
        label.text = "Label"
        return label
    }
    
    func createPages(page: Int) -> UIView {
         let pageView = UIView()
         let pageSize = scrollView.frame.size
         let positionX = pageSize.width * CGFloat(page)
         let position = CGPoint(x: positionX, y: 0)
         pageView.frame = CGRect(origin: position, size: pageSize)
         pageView.backgroundColor = colors[page]
         
         return pageView
     }
    
    
    
    func createContentsView() -> UIView {
        
        let mainBoundSize: CGSize = UIScreen.main.bounds.size
        let contentsWidth = scrollView.frame.width * CGFloat(numberOfPages)
        print(mainBoundSize,contentsWidth)
        // contentsViewを作る
        let contentsView = UIView()
        contentsView.frame = CGRect(x: 0, y: 0, width: contentsWidth, height: 1200)
        
        // contentsViewにlabelを配置させる
        let label = createLabel(contentsView: contentsView)
        contentsView.addSubview(label)
        
        for i in 0 ..< numberOfPages {
                let pageView = createPages(page: i)
                contentsView.addSubview(pageView)
            }
        
        return contentsView
    }
    
 
    
    func configureSV() {
        
        // scrollViewにcontentsViewを配置させる
        let subView = createContentsView()
        scrollView.addSubview(subView)
        
        // scrollViewにcontentsViewのサイズを教える
        scrollView.contentSize = subView.frame.size
    }
    
    
    
}
