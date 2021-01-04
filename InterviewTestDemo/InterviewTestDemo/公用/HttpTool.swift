//
//  HttpTool.swift
//  InterviewTestDemo
//
//  Created by NewApple on 2021/1/4.
//

import UIKit
import SwiftyJSON
class HttpTool {
    static let instance = HttpTool()
    var urlSession = URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: OperationQueue())

    class func defaultJsonErrorHandler(error: NSError) -> () {
        DispatchQueue.main.async {
//            topViewController()?.hideHud()
        }
      let alert = UIAlertController(title: "数据错误",
          message: "数据解析错误，请重试。若重试后问题仍存在，请联系开发商。 错误信息: \(error.localizedDescription)",
        preferredStyle: UIAlertController.Style.alert)
      alert.addAction(UIAlertAction(title: "OK",
                                    style: UIAlertAction.Style.default,
          handler: nil))
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    class func defaultErrorHandler(error: NSError, response: HTTPURLResponse?) -> () {
       DispatchQueue.main.async {
//           topViewController()?.hideHud()
        }
      if let _ = response {
        print("Error: \(error.localizedDescription) url:\(String(describing: response?.url?.description))")
//        topViewController()?.showHid(str: "网络请求失败,错误代码\(error.code)")

        } else {
        print("defaultErrorHandler: error: \(error.localizedDescription)")
//        topViewController()?.showHid(str: "网络不给力，请检查网络设置.")
      }
    }

    func postJson(endpoint: String,postData: NSDictionary,onSuccess:@escaping (JSON) -> ()){
        postJsonForJson(endpoint: kHostName+endpoint, postData: postData, onSuccess:{obj in
            onSuccess(JSON(obj))
        })
    }
    func getJson(endpoint: String,onSuccess:@escaping (AnyObject) -> (),onNetworkError:@escaping (NSError, HTTPURLResponse?) -> () = HttpTool.defaultErrorHandler,
                 onError:@escaping (NSError) -> () = HttpTool.defaultJsonErrorHandler){
        let request = requestFrom(str: endpoint)
       request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-type")
        requestForJson(request: request as URLRequest, onSuccess: onSuccess, onNetworkError: onNetworkError, onError: onError)
    }
    func postJsonForJson(endpoint: String,postData: AnyObject,onSuccess:@escaping (AnyObject) -> (),onNetworkError:@escaping (NSError, HTTPURLResponse?) -> () = HttpTool.defaultErrorHandler,
                         onError:@escaping (NSError) -> () = HttpTool.defaultJsonErrorHandler) {
        let request = requestFrom(str: endpoint, method: "POST")
       request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-type")
       do {
        request.httpBody = try JSONSerialization.data(withJSONObject: postData, options: [])
       } catch _ as NSError {
        request.httpBody = nil
       }
        requestForJson(request: request as URLRequest, onSuccess: onSuccess, onNetworkError: onNetworkError, onError: onError)
     }

    func requestFrom(str: String, method: String = "GET") -> NSMutableURLRequest {
        let request = NSMutableURLRequest(url: URL(string: str)!)
        request.httpMethod = method
        return request
    }

    func requestForJson(request: URLRequest,
                        onSuccess:@escaping (AnyObject) -> (),
                        onNetworkError:@escaping (NSError, HTTPURLResponse?) -> () = HttpTool.defaultErrorHandler,
                        onError:@escaping (NSError) -> () = HttpTool.defaultJsonErrorHandler) {

        self.requestForData(request: request,
           onSuccess: {
             data in
            self.readJsonData(data: data!, onSuccess: onSuccess, onError: onError)
           },
           onError: onNetworkError
       )
     }
    func requestForData(request: URLRequest,onSuccess:@escaping (Data?) -> (),onError:@escaping (NSError,HTTPURLResponse?) -> ()) {
        let task = urlSession.dataTask(with: request) { (data, response, error) in
            if let err = error {
                if let resp = response {//http error
                    
                }else{//网络连接错误
                    
                }
                 print("err:\(err),response:\(String(describing: response))")
                onError(err as NSError,response as? HTTPURLResponse ?? nil)
            }else{
                if let resp = response as? HTTPURLResponse {
                    let statusCode = resp.statusCode
                    OperationQueue.main.addOperation {
                        switch statusCode {
                        case 200 ..< 300://成功
                            onSuccess(data)
                        default://error
                            let httpError = NSError(domain: "HTTP Error", code: statusCode, userInfo: nil)
                           onError(httpError,resp)
                          print("response:\(response)")
                        }
                    }
                }
            }
        }
            task.resume()
    }
    func readJsonData(data: Data,
                      onSuccess:@escaping (AnyObject) -> (),
                      onError:@escaping (NSError) -> () = HttpTool.defaultJsonErrorHandler) {
      let rootObject: AnyObject?
      do {
        rootObject = try JSONSerialization.jsonObject(with: data as Data, options: .allowFragments) as AnyObject
        onSuccess(rootObject!)
      } catch let error as NSError {
        print(error.localizedDescription)
        rootObject = nil
        let stringify = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
        print("Error data: \(stringify)")
        OperationQueue.main.addOperation {
          onError(error)
        }
      }
    }

}
