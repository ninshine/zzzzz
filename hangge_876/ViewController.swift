//
//  ViewController.swift
//  hangge_876
//
//  Created by hangge on 2016/10/15.
//  Copyright © 2016年 hangge.com. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKScriptMessageHandler{
    
    var theWebView:WKWebView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let path = Bundle.main.path(forResource: "index", ofType: ".html",
                                    inDirectory: "HTML5")
        let url = URL(fileURLWithPath:path!)
        let request = URLRequest(url:url)
        
        //创建供js调用的接口
        let theConfiguration = WKWebViewConfiguration()
        theConfiguration.userContentController.add(self, name: "interOp")
        
        //将浏览器视图全屏(在内容区域全屏,不占用顶端时间条)
        let frame = CGRect(x:0, y:20, width:UIScreen.main.bounds.width,
                           height:UIScreen.main.bounds.height)
        theWebView = WKWebView(frame:frame, configuration: theConfiguration)
        //禁用页面在最顶端时下拉拖动效果
        theWebView!.scrollView.bounces = false
        //加载页面
        theWebView!.load(request)
        self.view.addSubview(theWebView!)
    }
    
    //响应处理js那边的调用
    func userContentController(_ userContentController:WKUserContentController,
                               didReceive message: WKScriptMessage) {
        print(message.body)
        let sentData = message.body as! Dictionary<String,String>
        //判断是确认添加购物车操作
        if(sentData["method"] == "addToCarCheck"){
            //获取商品名称
            let itemName = sentData["name"]!
            let alertController = UIAlertController(title: "系统提示",
                                        message: "确定把\(itemName)添加到购物车吗？",
                                        preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            let okAction = UIAlertAction(title: "确定", style: .default, handler: {
                action in
                print("点击了确定")
                //调用页面里加入购物车js方法
                self.theWebView!.evaluateJavaScript("addToCar('\(itemName)')",
                    completionHandler: nil)
            })
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
