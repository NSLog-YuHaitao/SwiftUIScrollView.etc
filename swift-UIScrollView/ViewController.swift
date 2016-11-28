//
//  ViewController.swift
//  swift-UIScrollView
//
//  Created by 尊驾 on 16/11/28.
//  Copyright © 2016年 尊驾. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIScrollViewDelegate {

    let SCRRENW = UIScreen.main.bounds.size.width
    let SCRRENH = UIScreen.main.bounds.size.height
    
    var dataArr : NSMutableArray = NSMutableArray.init()
    var scrollView :UIScrollView = UIScrollView.init()
    var page : UIPageControl = UIPageControl.init()
    var timer : Timer!
    var tapGR : UITapGestureRecognizer = UITapGestureRecognizer.init()
    var bigPic : UIImageView = UIImageView.init()
    var flag : Bool = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white//设置背景色
        self.automaticallyAdjustsScrollViewInsets = false//不允许自动适配位置
        self.navigationItem.title = "轮播图"//设置控制器标题
        self.navigationController?.navigationBar.isTranslucent = false
        
        self.initNavItem()//更改导航栏上item
        self.initData()//初始化数据
        self.createScrollView()//创建轮播图
        self.addPicture()//添加轮播图图片
        self.addTimer()//添加定时器
        self.createbigPic()
    }
    //MARK: 导航栏item
    func initNavItem() -> Void {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "继续", style: UIBarButtonItemStyle.plain, target: self, action: #selector(leftItemClick))
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "暂停", style: UIBarButtonItemStyle.plain, target: self, action: #selector(rightItemClick))
    }
    
    //MARK: 创建时间控制器
    func addTimer() -> Void {
        timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(timerEvent), userInfo: nil, repeats: true)
        //多线程 UI IOS程序默认只有一个主线程，处理UI的只有主线程。如果拖动第二个UI，则第一个UI事件则会失效。
        RunLoop.current.add(timer, forMode: RunLoopMode.commonModes)
    }
    
    //MARK: 定时器继续
    func leftItemClick() -> Void {
        self.addTimer()
    }
    
    //MARK: 定时器暂停
    func rightItemClick() -> Void {
        timer.invalidate()
    }
    
    
    //MARK: 初始化函数
    func initData() -> Void {
        for i in 0...3 {
            let picName : NSString = NSString.init(string: "\(i+1).jpg")
            dataArr.add(picName)
        }
    }
    
    //MARK: 创建scrollView
    func createScrollView() -> Void {
        scrollView = UIScrollView.init(frame: CGRect.init(x: 0, y: 0, width: SCRRENW, height: 200))//初始化
        scrollView.contentSize = CGSize.init(width:CGFloat(dataArr.count) * SCRRENW, height: 0)//滚动的大小
        scrollView.backgroundColor = UIColor.white//背景色
        scrollView.showsHorizontalScrollIndicator = false//去除水平滚动条
        scrollView.isPagingEnabled = true//单页
        scrollView.delegate = self//代理方法
        self.view.addSubview(scrollView)//添加到主视图上
        
        let sheight : CGFloat = scrollView.frame.size.height
        let sorigin : CGFloat = scrollView.frame.origin.y
        
        //初始化点控制
        page = UIPageControl.init(frame: CGRect.init(x:SCRRENW/2 - 50, y: sorigin + sheight - 20 , width: 100, height: 15))
        page.numberOfPages = dataArr.count//点控制数量
        page.currentPage = 0//当前所在页面
        page.pageIndicatorTintColor = UIColor.red//未选中颜色
        page.currentPageIndicatorTintColor = UIColor.green//当前选中颜色
        self.view.addSubview(page)//添加到主视图
    }
    
    //MARK: 添加轮播图图片
    func addPicture() -> Void {
        for i in 0...dataArr.count-1 {
            let imageV : UIImageView = UIImageView.init(frame: CGRect.init(x: CGFloat(i)*SCRRENW, y: 0, width: SCRRENW, height: 200))
            imageV.isUserInteractionEnabled = true
            tapGR = UITapGestureRecognizer.init(target: self, action: #selector(tapGREvent(tapGR:)))
            imageV.addGestureRecognizer(tapGR)
            imageV.image = UIImage.init(named: dataArr[i] as! String)
            scrollView.addSubview(imageV)
        }
    }
    
    //MARK: 创建图片浏览视图
    func createbigPic() -> Void {
        bigPic.frame = CGRect.init(x: 0, y: 0, width: SCRRENW, height: SCRRENH)
        bigPic.backgroundColor = UIColor.white
        bigPic.contentMode =  UIViewContentMode.scaleAspectFit
        
    
        bigPic.isUserInteractionEnabled = true
        let smallTapGR = UITapGestureRecognizer.init(target: self, action: #selector(smallPic(tapGR:)))
        bigPic.addGestureRecognizer(smallTapGR)
    }
    
    //MARK: 轮播图点击单独显示视图
    func tapGREvent(tapGR : UITapGestureRecognizer) -> Void {
        bigPic.image = (tapGR.view as! UIImageView).image
        self.view.addSubview(bigPic)
        if flag {
            timer.invalidate()//暂停
            flag = false
            self.navigationController?.isNavigationBarHidden = true //隐藏导航栏
            self.navigationController?.navigationBar.isTranslucent = true
        }
    }
    
    //MARK: 恢复最初视图模式
    func smallPic(tapGR:UITapGestureRecognizer) -> Void {
        bigPic.removeFromSuperview()
        self.addTimer()//继续
        flag = true
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    //MARK: 实现轮播图首尾相连的显示
    func timerEvent() -> Void {
        let index : Int = Int (scrollView.contentOffset.x/SCRRENW)
        //print(index)
        if index >= 3 {
            page.currentPage = 0
            scrollView.contentOffset = CGPoint.init(x: 0, y: 0)
        }else{
            page.currentPage = index + 1
            scrollView.contentOffset = CGPoint.init(x: CGFloat(CGFloat(index+1)*SCRRENW), y: 0)
        }
    }
    
    //MARK: 实现UIScrollView代理方法
    func scrollViewDidScroll(_ scrollView: UIScrollView){
        let index : Int = Int (scrollView.contentOffset.x/SCRRENW)
        page.currentPage = index
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

