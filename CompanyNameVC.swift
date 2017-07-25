//
//  CompanyNameVC.swift
//  Reindeer
//
//  Created by shiliuhua on 17/2/17.
//  Copyright © 2017年 shiliuhua. All rights reserved.
//

import UIKit
import JVFloatLabeledTextField
import SVProgressHUD

class CompanyNameVC: BaseViewVC,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {

    @IBOutlet var textFieldBgView: UIView!
    
    @IBOutlet var companyTextField: JVFloatLabeledTextField!
    
    @IBOutlet var tableView: UITableView!
    
    //返回传数据闭包
    var returnClosure:((CompanyNameList?,_ companyName:String) -> Void)?
    
    var companyArray:[Any] = []
    
    var companyListModel:CompanyNameList?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
     textFieldBgView.layer.cornerRadius = 30
     textFieldBgView.layer.masksToBounds = true
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
        tableView.tableFooterView = UIView()
        companyTextField.delegate = self
        
        let rightNavBtn = UIBarButtonItem(title: "完成", style: .plain, target: self, action: #selector(doneBtnClick))
        
        self.navigationItem.rightBarButtonItem = rightNavBtn
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.5, execute: {
            self.companyTextField.becomeFirstResponder()
        })
        
        
    }
    //完成
    func doneBtnClick() -> Void {
          print("点击完成")
        if companyTextField.text == nil || companyTextField.text == "" {
            SVProgressHUD.showInfo(withStatus: "请输入公司名称")
            return
        }
        
        //判断列表中是否存在输入的公司(若存在则取出model)
        for companyModel in self.companyArray {
            let model:CompanyNameList = companyModel as! CompanyNameList
            if model.name == companyTextField.text {
                self.companyListModel = model
            }
        }
        
        if (returnClosure != nil) {
            returnClosure!(self.companyListModel,companyTextField.text!)
        }
        
        _ = self.navigationController?.popViewController(animated: true)
        
        
    }
    
    //获取公司列表
    func getCompanyList(string:String) -> Void {
        getCompanyName(dic: ["name":string,"no":1,"size":100], actionHandler: {(companyBassClassModel) in
            self.companyArray = companyBassClassModel.list!
            self.tableView.reloadData()
        }, fail: {
            
        })
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        print("textFiled.text = \(textField.text)")
        //将companyListModel置为nil
        self.companyListModel = nil
        getCompanyList(string: textField.text!)
        
        return true
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let companyListModel:CompanyNameList = companyArray[indexPath.row] as! CompanyNameList
        
        companyTextField.text = companyListModel.name
        self.companyListModel = companyListModel
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return companyArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        let companyListModel:CompanyNameList = companyArray[indexPath.row] as! CompanyNameList
        cell?.textLabel?.text = companyListModel.name
        
        return cell!
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
