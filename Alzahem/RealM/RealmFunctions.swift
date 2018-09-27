
//
//  RealmFunctions.swift
//  ADDY
//
//  Created by ibrahim M. samak on 4/13/17.
//  Copyright © 2017 RamezAdnan. All rights reserved.
//

import Foundation
import RealmSwift

/// Central helper for all local Realm persistence of the shopping cart (`RCart`)
/// and favourites (`RFav`). Every add / remove / update / query for those two
/// models flows through this singleton, which writes to the global `uiRealm`
/// instance created in `AppDelegate`. Items are keyed by their product id
/// `pk_i_id`, with cart quantity stored in `i_amount`.
class RealmFunctions
{
    /// Shared singleton used across the app.
    static var shared = RealmFunctions()
    /// Cached results handle for cart items.
    var lists : Results<RCart>!
    /// Cached results handle for favourite items.
    var lists2 : Results<RFav>!

    // Mark - Delete Cart Item
    /// Removes a single cart line identified by its product id.
    func deleteCartItem(pk_i_id:String)
    {
        let object = GetCartItemDetails(pk_i_id: pk_i_id)
        try! uiRealm.write{
            uiRealm.delete(object)
        }
    }
    
    //Mark - Update i_ammount
    /// Updates the quantity (`i_amount`) of an existing cart line.
    func UpdateAmmout(pk_i_id:String,i_ammount:Int)
    {
        let Predicate = NSPredicate(format: "pk_i_id == %@", pk_i_id)
        let user =  uiRealm.objects(RCart.self).filter(Predicate).first!
        try! uiRealm.write
        {
            user.i_amount = i_ammount
        }
    }
    
    // Mark - Get Cart Item Details
    /// Returns the cart line for a product id (force-unwrapped; assumes it exists).
    func GetCartItemDetails(pk_i_id:String) -> RCart
    {
        let Predicate = NSPredicate(format: "pk_i_id == %@", pk_i_id)
        return uiRealm.objects(RCart.self).filter(Predicate).first!
    }
    
    /// Returns true if a product is already present in the cart.
    func CheckCart(pk_i_id:String) -> Bool
    {
        let Predicate = NSPredicate(format: "pk_i_id == %@", pk_i_id)
        let query = uiRealm.objects(RCart.self).filter(Predicate)
        if(query.count>0)
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    
    // Mark - Get Count of Carts
    /// Sums the quantities of every cart line (used for the tab-bar badge).
    func GetCountofCart() -> Int
    {
        var qty = 0;
        lists = uiRealm.objects(RCart.self)
        for index in 0..<lists.count
        {
            qty = qty + lists[index].i_amount
        }
        return qty
    }
    
    // Mark - Add or Edit Cart user to Realm
    /// Inserts or updates (upsert by primary key) a cart line.
    func AddUserToRealm(newCart:RCart)
    {
        try! uiRealm.write{
            uiRealm.add(newCart, update: true)
        }
    }
    
    //Get All Carts Items
    /// Returns every cart line. (Device-token filtering is currently disabled.)
    func GetMyCartItems(s_devicetoken:String , s_devicetoken2:String) -> Results<RCart>
    {
//        let Predicate = NSPredicate(format: "s_token == %@ OR s_token == %@ ", s_devicetoken , s_devicetoken2)
        lists = uiRealm.objects(RCart.self)
        return lists
    }
    
    // Mark - Delete All user to Realm
    /// Empties the entire cart (e.g. after a successful checkout).
    func deleteAllRealm()
    {
        lists = uiRealm.objects(RCart.self)
        try! uiRealm.write
        {
            uiRealm.delete(lists)
        }
    }
    
    // Mark - Add to favourit
    /// Inserts or updates a favourite item (upsert by primary key).
    func AddFavToRealm(newCart:RFav)
    {
        try! uiRealm.write
        {
            uiRealm.add(newCart, update: true)
        }
    }
    
    /// Returns every favourite item. (Device-token filtering is currently disabled.)
    func GetMyFavItems(s_devicetoken:String,s_devicetoken2:String) -> Results<RFav>
    {
//        let Predicate = NSPredicate(format: "s_token == %@ OR s_token == %@", s_devicetoken,s_devicetoken2)
        lists2 = uiRealm.objects(RFav.self)
        return lists2
    }
    
    /// Returns the favourite entry for a product id (force-unwrapped).
    func GetCartFavetails(pk_i_id:String) -> RFav
    {
        let Predicate = NSPredicate(format: "pk_i_id == %@", pk_i_id)
        return uiRealm.objects(RFav.self).filter(Predicate).first!
    }
    
    /// Removes a single favourite entry by product id.
    func deleteFavItem(pk_i_id:String)
    {
        let object = GetCartFavetails(pk_i_id: pk_i_id)
        try! uiRealm.write
        {
            uiRealm.delete(object)
        }
    }
    
    /// Total quantity across all cart lines (duplicate of `GetCountofCart`).
    func GetCountofQtyCart() -> Int
    {
        var qty = 0;
        lists = uiRealm.objects(RCart.self)
        for index in 0..<lists.count
        {
            qty = qty + lists[index].i_amount
        }
        return qty
    }
    
}

