//
//  MyApi.swift
//  
//
//  Created by ibra on 10/12/16.
//  Copyright © 2016 ibra. All rights reserved.
//

import Foundation
import Alamofire

class MyApi
{
    static let api = MyApi()
    
    static public var apiMainURL = "https://app.alzahem-industries.com/api/" as String
    static public var PhotoURL = "" as String
    
    enum userType :String {
        case customer   = "customer"
        case contractor = "contractor"
        case handyman   = "handyman"
    }
    
    func PostEditUser(userId:String,file:Data, completion:((DataResponse<Any>,Error?)->Void)!) {
        let headers: HTTPHeaders =
            [
                "Accept": "application/json",
                "Customer-Language" :  MyTools.tools.getMyLang()
            ]
        
        Alamofire.upload(
            multipartFormData:
            {
                multipartFormData in
                
                multipartFormData.append(file, withName: "file",fileName: "img.png", mimeType: "image/png")
        },
            to: String(format:"%@%@",MyApi.apiMainURL,"updateAvatar?user_id="+userId),
            headers:headers,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        if(response.result.isSuccess)
                        {
                            completion(response,nil)
                        }
                        else
                        {
                            completion(response,response.result.error)
                        }
                    }
                case .failure(_): break
                }
        })
    }
    
    
    func PostSignUpNewUser(name:String,email:String ,mobile:String , password :String , type:String,is_24:String , company_name:String,category_id:[Int] , profile_image:Data , civil_id:String,images:[UIImage] ,completion:((DataResponse<Any>,Error?)->Void)!)
    {
        
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Customer-Language" :  MyTools.tools.getMyLang()
        ]
        
        Alamofire.upload(
            multipartFormData:
            {
                multipartFormData in
                
                var myData = category_id.withUnsafeBufferPointer {Data(buffer: $0)}
                
                multipartFormData.append(profile_image, withName: "profile_image",fileName: "img.png", mimeType: "image/png")
                
                multipartFormData.append(name.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "name")
                
                multipartFormData.append(email.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "email")
                
                multipartFormData.append(mobile.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "mobile")
                
                multipartFormData.append(password.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "password")
                
                multipartFormData.append(type.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "type")
                
                if(type == "contractor" || type == "handyman")
                {
                    multipartFormData.append(myData, withName: "category_id")
                    
                    for index in 0..<images.count
                    {
                        let image = UIImageJPEGRepresentation(images[index], 0.8) as? Data
                        let name = "images["+String(index)+"]"
                        multipartFormData.append(image!, withName: name,fileName: "img.png", mimeType: "image/png")
                    }
                }
                if(type == "contractor")
                {
                    multipartFormData.append(company_name.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "company_name")
                    multipartFormData.append(civil_id.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "civil_id")
                }
                if(type == "handyman")
                {
                    multipartFormData.append(is_24.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "is_24")
                }
        },
            to: String(format:"%@%@",MyApi.apiMainURL,"user"),
            headers:headers,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        if(response.result.isSuccess)
                        {
                            completion(response,nil)
                        }
                        else
                        {
                            completion(response,response.result.error)
                        }
                    }
                case .failure(_): break
                }
        })
    }
    
    
    func PostUpdateUser(name:String,email:String ,mobile:String ,is_24:String , company_name:String,category_id:[Int] , profile_image:Data ,images:[Data],completion:((DataResponse<Any>,Error?)->Void)!)
    {
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Authorization" :  MyTools.tools.getMyToken(),
            "Customer-Language" :  MyTools.tools.getMyLang()
        ]
        
        Alamofire.upload(
            multipartFormData:
            {
                multipartFormData in
                
                var myData = category_id.withUnsafeBufferPointer {Data(buffer: $0)}
                
                multipartFormData.append(profile_image, withName: "profile_image",fileName: "img.png", mimeType: "image/png")
                
                multipartFormData.append(name.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "name")
                
                multipartFormData.append(email.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "email")
                
                multipartFormData.append(mobile.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "mobile")
                
                multipartFormData.append(company_name.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "company_name")
                
                multipartFormData.append(myData, withName: "category_id")
                
                multipartFormData.append(images[0], withName: "images[0]",fileName: "img.png", mimeType: "image/png")
                
                multipartFormData.append(is_24.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "is_24")
                
        },
            to: String(format:"%@%@",MyApi.apiMainURL,"user/update"),
            headers:headers,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        if(response.result.isSuccess)
                        {
                            completion(response,nil)
                        }
                        else
                        {
                            completion(response,response.result.error)
                        }
                    }
                case .failure(_): break
                }
        })
    }
    
    func Postlogout(completion:((DataResponse<Any>,Error?)->Void)!)
    {
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Customer-Language" :  MyTools.tools.getMyLang(),
            "Authorization" :  MyTools.tools.getMyToken(),
            ]
        
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"user/logout"), method: .post,encoding: JSONEncoding.default , headers:headers).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    
    func PostUserUpdate(first_name:String ,last_name:String ,phone:String, email:String ,completion:((DataResponse<Any>,Error?)->Void)!)
    {
        
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Customer-Language" :  MyTools.tools.getMyLang()
        ]
        let userId = MyTools.tools.getMyId()
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"update_profile?id="+userId), method: .post,
                          parameters:["first_name":first_name , "last_name":last_name , "phone":phone ,"email":email ],encoding: JSONEncoding.default , headers:headers).responseJSON { response in
                            if(response.result.isSuccess)
                            {
                                completion(response,nil)
                            }
                            else
                            {
                                completion(response,response.result.error)
                            }
        }
    }
    
    
    func PostLoginUser(username:String ,pass:String ,completion:((DataResponse<Any>,Error?)->Void)!)
    {
        
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Customer-Language" :  MyTools.tools.getMyLang()
        ]
        
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"login"), method: .post,
                          parameters:["username":username , "pass":pass],encoding: JSONEncoding.default , headers:headers).responseJSON { response in
                            if(response.result.isSuccess)
                            {
                                completion(response,nil)
                            }
                            else
                            {
                                completion(response,response.result.error)
                            }
        }
    }
    
    //offer/CustomerResponse
    func postAcceptorRejectBbCustomer(job_id:Int,offer_id:Int ,status:String ,completion:((DataResponse<Any>,Error?)->Void)!)
    {
        
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Customer-Language" :  MyTools.tools.getMyLang(),
            "Authorization" :  MyTools.tools.getMyToken(),
            
            ]
        
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"offer/CustomerResponse"), method: .post,
                          parameters:["job_id":job_id , "offer_id":offer_id , "status":status],encoding: JSONEncoding.default , headers:headers).responseJSON { response in
                            if(response.result.isSuccess)
                            {
                                completion(response,nil)
                            }
                            else
                            {
                                completion(response,response.result.error)
                            }
        }
    }
    
    
    func PostRate(provider_id:Int ,rate:Int ,completion:((DataResponse<Any>,Error?)->Void)!)
    {
        
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Customer-Language" :  MyTools.tools.getMyLang(),
            "Authorization" :  MyTools.tools.getMyToken(),
            
            ]
        
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"offer/rate"), method: .post,
                          parameters:["provider_id":provider_id , "rate":rate],encoding: JSONEncoding.default , headers:headers).responseJSON { response in
                            if(response.result.isSuccess)
                            {
                                completion(response,nil)
                            }
                            else
                            {
                                completion(response,response.result.error)
                            }
        }
    }
    
    
    func PostMakeOffer(job_id:Int ,budget:Int ,completion:((DataResponse<Any>,Error?)->Void)!)
    {
        
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Customer-Language" :  MyTools.tools.getMyLang(),
            "Authorization" :  MyTools.tools.getMyToken(),
            
            ]
        
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"offer"), method: .post,
                          parameters:["job_id":job_id , "budget":budget],encoding: JSONEncoding.default , headers:headers).responseJSON { response in
                            if(response.result.isSuccess)
                            {
                                completion(response,nil)
                            }
                            else
                            {
                                completion(response,response.result.error)
                            }
        }
    }
    
    
    
    func PostChangePassword(old_password:String , password:String ,completion:((DataResponse<Any>,Error?)->Void)!)
    {
        
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Authorization" :  MyTools.tools.getMyToken(),
            "Customer-Language" :  MyTools.tools.getMyLang()
        ]
        
        
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"changePassword"), method: .post,
                          parameters:["old_password":old_password , "password":password],encoding: JSONEncoding.default,headers:headers).responseJSON { response in
                            if(response.result.isSuccess)
                            {
                                completion(response,nil)
                            }
                            else
                            {
                                completion(response,response.result.error)
                            }
        }
    }
    
    func PostForgetPassword(email:String,completion:((DataResponse<Any>,Error?)->Void)!)
    {
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Customer-Language" :  MyTools.tools.getMyLang()
        ]
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"ForgotPassword?email="+email), method: .get,encoding: JSONEncoding.default,headers:headers).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    
    
    func PostCheckCode(activecode:String,completion:((DataResponse<Any>,Error?)->Void)!)
    {
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Customer-Language" :  MyTools.tools.getMyLang(),
            "Customer-Id" : MyTools.tools.getMyId(),
            "Customer-Token" : MyTools.tools.getMyToken()
        ]
        
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"account-verification"), method: .post,parameters:["activecode":activecode],encoding: JSONEncoding.default,headers:headers).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    
    
    func PostRequestNewCode(code:String , mobile:String,completion:((DataResponse<Any>,Error?)->Void)!)
    {
        
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Customer-Language" :  MyTools.tools.getMyLang()
        ]
        
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"user/requestNewCode"), method: .post,parameters:["code":code , "mobile":mobile],encoding: JSONEncoding.default,headers:headers).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    
    
    func PostupdatePassword(password:String ,password_confirmation:String ,completion:((DataResponse<Any>,Error?)->Void)!)
    {
        
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Authorization" :  MyTools.tools.getMyToken(),
            "Customer-Language" :  MyTools.tools.getMyLang()
        ]
        
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"user/password"), method: .post,parameters:["password":password , "password_confirmation":password_confirmation],encoding: JSONEncoding.default,headers:headers).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    
    
    
    func PostSendToken(token:String ,type:String ,completion:((DataResponse<Any>,Error?)->Void)!)
    {
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Customer-Language" :  MyTools.tools.getMyLang()
        ]
        
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"user/token"), method: .post,parameters:["type":type , "token":token],encoding: JSONEncoding.default,headers:headers).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    
    
    func PostContact(name:String ,email:String , message:String, mobile:String ,completion:((DataResponse<Any>,Error?)->Void)!)
    {
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Customer-Language" :  MyTools.tools.getMyLang()
        ]
        
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"contact"), method: .post,parameters:["name":name , "email":email , "message":message , "mobile":mobile],encoding: JSONEncoding.default,headers:headers).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    
    
    func GetUserProfile(completion:((DataResponse<Any>,Error?)->Void)!)
    {
        let headers: HTTPHeaders = [
            "Accep": "application/json",
            "Authorization" :  MyTools.tools.getMyToken(),
            "Customer-Language" :  MyTools.tools.getMyLang()
        ]
        
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"user"), method: .get,encoding: JSONEncoding.default , headers:headers).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    
    
    func GetUserProfile(userId:String, completion:((DataResponse<Any>,Error?)->Void)!)
    {
        let headers: HTTPHeaders = [
            "Accep": "application/json",
            "Customer-Language" :  MyTools.tools.getMyLang()
        ]
        
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"customer/"+userId), method: .get,encoding: JSONEncoding.default , headers:headers).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    
    
    func GetCategories(completion:((DataResponse<Any>,Error?)->Void)!)
    {
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Customer-Language" :  MyTools.tools.getMyLang()
        ]
        
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"categories"), method: .get,encoding: JSONEncoding.default ,headers:headers).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    
    
    func GetOrders(page:String,consumer_id:String, completion:((DataResponse<Any>,Error?)->Void)!)
    {
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Customer-Language" :  MyTools.tools.getMyLang()
        ]
        
        let language =  MyTools.tools.getMyLang()
        let currency = MyTools.tools.getMyCurrency()
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"orders?page="+page+"&consumer_id="+consumer_id+"&currency="+currency+"&language="+language), method: .get,encoding: JSONEncoding.default ,headers:headers).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    
    func GetOrderDetails(OrderID:String,completion:((DataResponse<Any>,Error?)->Void)!)
    {
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Customer-Language" :  MyTools.tools.getMyLang(),
            "Customer-Currency": MyTools.tools.getMyCurrency()
        ]
        let consumer_id = MyTools.tools.getMyId()
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"order/"+OrderID+"?consumer_id="+consumer_id), method: .get,encoding: JSONEncoding.default ,headers:headers).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    
    func GetTerms(completion:((DataResponse<Any>,Error?)->Void)!)
    {
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Customer-Language" :  MyTools.tools.getMyLang()
        ]
        
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"about"), method: .get,encoding: JSONEncoding.default,headers:headers).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    
    func GetCities(completion:((DataResponse<Any>,Error?)->Void)!)
    {
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Customer-Language" :  MyTools.tools.getMyLang(),
            "Customer-Currency": MyTools.tools.getMyCurrency()
        ]
        
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"governorate"), method: .get,encoding: JSONEncoding.default,headers:headers).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    
    

    func GetCurrencies(completion:((DataResponse<Any>,Error?)->Void)!)
    {
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Customer-Language" :  MyTools.tools.getMyLang()
        ]
        
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"currencies"), method: .get,encoding: JSONEncoding.default,headers:headers).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    
    func GetAdvs(completion:((DataResponse<Any>,Error?)->Void)!)
    {
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"sponsored"), method: .get,encoding: JSONEncoding.default).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    
    
    func GetConfig(completion:((DataResponse<Any>,Error?)->Void)!)
    {
        
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Customer-Language" :  MyTools.tools.getMyLang()
        ]
        
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"getconfig"), method: .get,encoding: JSONEncoding.default , headers:headers).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    
    
    func GetAbout(completion:((DataResponse<Any>,Error?)->Void)!)
    {
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Customer-Language" :  MyTools.tools.getMyLang()
        ]
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"about"), method: .get,encoding: JSONEncoding.default,headers:headers).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    
    
    func GetPrivacy(completion:((DataResponse<Any>,Error?)->Void)!)
    {
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Customer-Language" :  MyTools.tools.getMyLang()
        ]
        
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"privacy"), method: .get,encoding: JSONEncoding.default,headers:headers).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    func GetAds(completion:((DataResponse<Any>,Error?)->Void)!)
    {
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"ad"), method: .get,encoding: JSONEncoding.default).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    

    func GetSingleProducts(id:String,completion:((DataResponse<Any>,Error?)->Void)!)
    {
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Customer-Language" :  MyTools.tools.getMyLang(),
            "Customer-Currency" :  MyTools.tools.getMyCurrency()
        ]
        
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"product/"+id), method: .get,encoding: JSONEncoding.default , headers:headers).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    
    func GetProductsByName(page:String,product_name:String,completion:((DataResponse<Any>,Error?)->Void)!)
    {
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Customer-Language" :  MyTools.tools.getMyLang(),
            "Customer-Currency" :  MyTools.tools.getMyCurrency()
        ]
        
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"products?page="+page+"&product_name="+product_name), method: .get,encoding: JSONEncoding.default , headers:headers).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    
    
    func GetProductsByCateogryId(page:String,category:String,completion:((DataResponse<Any>,Error?)->Void)!)
    {
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Customer-Language" :  MyTools.tools.getMyLang(),
            "Customer-Currency" :  MyTools.tools.getMyCurrency()
        ]
        
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"products?page="+page+"&category="+category), method: .get,encoding: JSONEncoding.default , headers:headers).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    
    
    func GetProducts(page:String,completion:((DataResponse<Any>,Error?)->Void)!)
    {
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Customer-Language" :  MyTools.tools.getMyLang(),
            "Customer-Currency" :  MyTools.tools.getMyCurrency()
        ]
        
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"products?page="+page), method: .get,encoding: JSONEncoding.default , headers:headers).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    
    func RemoveFav(user_id:String,product_id:String,completion:((DataResponse<Any>,Error?)->Void)!)
    {
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Customer-Language" :  MyTools.tools.getMyLang(),
            "Customer-Currency" :  MyTools.tools.getMyCurrency()
        ]
        
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"remove_favorite?user_id="+user_id+"&product_id="+product_id), method: .get,encoding: JSONEncoding.default , headers:headers).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    
    
    func AddFav(user_id:String,product_id:String,completion:((DataResponse<Any>,Error?)->Void)!)
    {
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Customer-Language" :  MyTools.tools.getMyLang(),
            "Customer-Currency" :  MyTools.tools.getMyCurrency()
        ]
        
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"add_favorite?user_id="+user_id+"&product_id="+product_id), method: .get,encoding: JSONEncoding.default , headers:headers).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    
    
    
    func GetFav(user_id:String,completion:((DataResponse<Any>,Error?)->Void)!)
    {
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Customer-Language" :  MyTools.tools.getMyLang(),
            "Customer-Currency" :  MyTools.tools.getMyCurrency()
        ]
        
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"favorites?user_id="+user_id), method: .get,encoding: JSONEncoding.default , headers:headers).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    
    
    func GetSubCategory(id:String,completion:((DataResponse<Any>,Error?)->Void)!)
    {
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Customer-Language" :  MyTools.tools.getMyLang()
        ]
        
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"category/sub/"+id), method: .get,encoding: JSONEncoding.default , headers:headers).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    
    func GetHome(completion:((DataResponse<Any>,Error?)->Void)!)
    {
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Customer-Language" :  MyTools.tools.getMyLang(),
            "Customer-Currency" :  MyTools.tools.getMyCurrency()
        ]
        
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"home"), method: .post,encoding: JSONEncoding.default , headers:headers).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    
    
    func PostNewUser(email:String,username:String , first_name :String , last_name:String,password:String,shipping:NSDictionary ,completion:((DataResponse<Any>,Error?)->Void)!)
    {
        let Lang =  MyTools.tools.getMyLang()
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Customer-Language" : Lang,
            ]
        
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"register"), method: .post,
                          parameters:["email":email , "username":username , "first_name":first_name ,"last_name":last_name , "password":password, "shipping":shipping ],encoding: JSONEncoding.default , headers:headers).responseJSON { response in
                            if(response.result.isSuccess)
                            {
                                completion(response,nil)
                            }
                            else
                            {
                                completion(response,response.result.error)
                            }
        }
        
        
    }
    
    func PostCheckCart(line_items:[NSDictionary],completion:((DataResponse<Any>,Error?)->Void)!)
    {
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Customer-Language" :  MyTools.tools.getMyLang()
        ]
        
        let param = ["line_items":line_items ] as [String : Any]
        
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"check_cart"), method: .post,
                          parameters:param ,encoding: JSONEncoding.default , headers:headers).responseJSON { response in
                            if(response.result.isSuccess)
                            {
                                completion(response,nil)
                            }
                            else
                            {
                                completion(response,response.result.error)
                            }
        }
    }
    
    func PostPurchase(user_id:String,user_comments:String , total :String , payment_method:String,payment_method_title:String,line_items:[NSDictionary],shipping:NSDictionary ,completion:((DataResponse<Any>,Error?)->Void)!)
    {
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Customer-Language" :  MyTools.tools.getMyLang(),
            "Customer-Currency" : MyTools.tools.getMyCurrency()
            ]
        
        let param = ["user_id":user_id , "user_comments":user_comments ,
                     "total":total ,"payment_method":payment_method ,
                     "payment_method_title":payment_method_title,
                     "line_items":line_items , "shipping":shipping] as [String : Any]
        
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"product_purchase"), method: .post,
                          parameters:param ,encoding: JSONEncoding.default , headers:headers).responseJSON { response in
                            if(response.result.isSuccess)
                            {
                                completion(response,nil)
                            }
                            else
                            {
                                completion(response,response.result.error)
                            }
        }
        
        
    }
    
}
