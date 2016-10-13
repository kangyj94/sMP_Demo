package kr.co.bitcube.product.dto; 

public class ProductDto {
	
	//상품마스터
	private String good_Iden_Numb;
	private String good_Name;
	private String vtax_Clas_Code;
	private String sale_Criterion_Type;
	private String stan_Buying_Rate;
	private String stan_Buying_Money;
	private String isDistribute;
	private String isDispPastGood;
	private String insert_Date;
	private String cate_Id;
	private String good_Spec;
	
	//상품공급사
	private String vendorId;
	private String req_Good_Id;
	private String sale_Unit_Pric;
	private String good_St_Spec_Desc;
	private String good_Spec_Desc;
	private String orde_Clas_Code;
	private String deli_Mini_Day;
	private String deli_Mini_Quan;
	private String make_Comp_Name;
	private String original_Img_Path;
	private String isSetImage; 
	private String large_Img_Path;
	private String middle_Img_Path;
	private String small_Img_Path;
	private String good_Same_Word;
	private String good_Desc;
	private String isSetDesc;
	private String issub_Ontract;
	private String good_Clas_Code;
	private String good_Inventory_Cnt;
	private String regist_Date;
	private String ord_Quan;
	private String requ_Deli_Date;
	private String buy_rate;
	private String sale_price;
	private String target_price;
	
	//공급사
	private String vendorNm;
	private String vendorCd;
	private String areaType;
	private String pressentNm;
	private String phoneNum;
	private String insert_User_Nm;
	private String insert_User_Id;
	private String app_Sts;
	private String admin_User_Id;
	private String app_User_Id;
	private String app_Date;
	private String create_Good_Date;
	private String isUse;
	
	//공급사품목변경
	private String fix_Good_Id;
	private String applt_Fix_Code;
	private String price;
	private String apply_Desc;
	private String fix_App_Sts;
	
	//표준카테고리
	private String majo_Code_Name;
	private String full_Cate_Name;
	
	//상품진열
	private String disp_Good_Id;
	private String groupId;
	private String clientId;
	private String branchId;
	private String cont_From_Date;
	private String cont_To_Date;
	private String ref_Good_Seq;
	private String ispast_Sell_Flag;
	private String Final_Good_Sts;
	private String sell_Price;
	private String disp_From_Date;
	private String disp_To_Date;
	private String cust_Good_Iden_Numb;
	private String total_Amout;
	private String stan_Deli_Day;
	
	//조직마스터
	private String borgNms;
	
	//추가된항목
	private String cate_cd;
	private String vendorcd;
	
	//상품실적년도
	private String good_reg_year;
	
	
	//상품변경 이력관련
	private String good_iden_numb_cnt; //상품마스터 히스토리 카운트
	private String branchNm; //사업장명
	private String codeNm; //코드명
	private String flag; //수정일시관련 flag
	private String finalGoodSts;
	private String tranUserNm;
	
	

	private String avgpurcdate;				//상품평균발주접수일
	private String 	avginvoicedate;			//상품평균납기일
	
	private String product_manager;			//상품담당자
	private String product_manager_loginid;	//상품담당자 로그인ID
	private String vendor_priority;			//상품우선순위
	
	//표준규격 상세
	private String goodStSpecDesc1;
	private String goodStSpecDesc2;
	private String goodStSpecDesc3;
	private String goodStSpecDesc4;
	private String goodStSpecDesc5;
	private String goodStSpecDesc6;
	
	//규격상세
	private String goodSpecDesc1;
	private String goodSpecDesc2;
	private String goodSpecDesc3;
	private String goodSpecDesc4;
	private String goodSpecDesc5;
	private String goodSpecDesc6;
	private String goodSpecDesc7;
	private String goodSpecDesc8;
	
	private String desc_yn; // 상세 설명여부
	private String good_clas_name; // 상품유형
	
	
	public String getGood_clas_name() {
		return good_clas_name;
	}

	public void setGood_clas_name(String good_clas_name) {
		this.good_clas_name = good_clas_name;
	}

	public String getDesc_yn() {
		return desc_yn;
	}

	public void setDesc_yn(String desc_yn) {
		this.desc_yn = desc_yn;
	}

	public String getGoodSpecDesc1() {
		return goodSpecDesc1;
	}

	public void setGoodSpecDesc1(String goodSpecDesc1) {
		this.goodSpecDesc1 = goodSpecDesc1;
	}

	public String getGoodSpecDesc2() {
		return goodSpecDesc2;
	}

	public void setGoodSpecDesc2(String goodSpecDesc2) {
		this.goodSpecDesc2 = goodSpecDesc2;
	}

	public String getGoodSpecDesc3() {
		return goodSpecDesc3;
	}

	public void setGoodSpecDesc3(String goodSpecDesc3) {
		this.goodSpecDesc3 = goodSpecDesc3;
	}

	public String getGoodSpecDesc4() {
		return goodSpecDesc4;
	}

	public void setGoodSpecDesc4(String goodSpecDesc4) {
		this.goodSpecDesc4 = goodSpecDesc4;
	}

	public String getGoodSpecDesc5() {
		return goodSpecDesc5;
	}

	public void setGoodSpecDesc5(String goodSpecDesc5) {
		this.goodSpecDesc5 = goodSpecDesc5;
	}

	public String getGoodSpecDesc6() {
		return goodSpecDesc6;
	}

	public void setGoodSpecDesc6(String goodSpecDesc6) {
		this.goodSpecDesc6 = goodSpecDesc6;
	}

	public String getGoodSpecDesc7() {
		return goodSpecDesc7;
	}

	public void setGoodSpecDesc7(String goodSpecDesc7) {
		this.goodSpecDesc7 = goodSpecDesc7;
	}

	public String getGoodSpecDesc8() {
		return goodSpecDesc8;
	}

	public void setGoodSpecDesc8(String goodSpecDesc8) {
		this.goodSpecDesc8 = goodSpecDesc8;
	}

	public String getGoodStSpecDesc1() {
		return goodStSpecDesc1;
	}

	public void setGoodStSpecDesc1(String goodStSpecDesc1) {
		this.goodStSpecDesc1 = goodStSpecDesc1;
	}

	public String getGoodStSpecDesc2() {
		return goodStSpecDesc2;
	}

	public void setGoodStSpecDesc2(String goodStSpecDesc2) {
		this.goodStSpecDesc2 = goodStSpecDesc2;
	}

	public String getGoodStSpecDesc3() {
		return goodStSpecDesc3;
	}

	public void setGoodStSpecDesc3(String goodStSpecDesc3) {
		this.goodStSpecDesc3 = goodStSpecDesc3;
	}

	public String getGoodStSpecDesc4() {
		return goodStSpecDesc4;
	}

	public void setGoodStSpecDesc4(String goodStSpecDesc4) {
		this.goodStSpecDesc4 = goodStSpecDesc4;
	}

	public String getGoodStSpecDesc5() {
		return goodStSpecDesc5;
	}

	public void setGoodStSpecDesc5(String goodStSpecDesc5) {
		this.goodStSpecDesc5 = goodStSpecDesc5;
	}

	public String getGoodStSpecDesc6() {
		return goodStSpecDesc6;
	}

	public void setGoodStSpecDesc6(String goodStSpecDesc6) {
		this.goodStSpecDesc6 = goodStSpecDesc6;
	}

	public String getVendor_priority() {
		return vendor_priority;
	}

	public void setVendor_priority(String vendor_priority) {
		this.vendor_priority = vendor_priority;
	}

	public String getProduct_manager_loginid() {
		return product_manager_loginid;
	}

	public void setProduct_manager_loginid(String product_manager_loginid) {
		this.product_manager_loginid = product_manager_loginid;
	}

	public String getProduct_manager() {
		return product_manager;
	}

	public void setProduct_manager(String product_manager) {
		this.product_manager = product_manager;
	}

	public String getAvginvoicedate() {
		return avginvoicedate;
	}

	public void setAvginvoicedate(String avginvoicedate) {
		this.avginvoicedate = avginvoicedate;
	}

	public String getAvgpurcdate() {
		return avgpurcdate;
	}

	public void setAvgpurcdate(String avgpurcdate) {
		this.avgpurcdate = avgpurcdate;
	}

	public String getTranUserNm() {
		return tranUserNm;
	}

	public void setTranUserNm(String tranUserNm) {
		this.tranUserNm = tranUserNm;
	}

	public String getFinalGoodSts() {
		return finalGoodSts;
	}

	public void setFinalGoodSts(String finalGoodSts) {
		this.finalGoodSts = finalGoodSts;
	}

	public String getFlag() {
		return flag;
	}

	public void setFlag(String flag) {
		this.flag = flag;
	}

	public String getCodeNm() {
		return codeNm;
	}

	public void setCodeNm(String codeNm) {
		this.codeNm = codeNm;
	}

	public String getBranchNm() {
		return branchNm;
	}

	public void setBranchNm(String branchNm) {
		this.branchNm = branchNm;
	}

	public String getGood_iden_numb_cnt() {
		return good_iden_numb_cnt;
	}

	public void setGood_iden_numb_cnt(String good_iden_numb_cnt) {
		this.good_iden_numb_cnt = good_iden_numb_cnt;
	}

	public String getGood_reg_year() {
		return good_reg_year;
	}

	public void setGood_reg_year(String good_reg_year) {
		this.good_reg_year = good_reg_year;
	}

	public String getCate_cd() {
		return cate_cd;
	}

	public void setCate_cd(String cate_cd) {
		this.cate_cd = cate_cd;
	}

	public String getVendorcd() {
		return vendorcd;
	}

	public void setVendorcd(String vendorcd) {
		this.vendorcd = vendorcd;
	}

	public String getGood_Iden_Numb() {
		return good_Iden_Numb;
	}

	public void setGood_Iden_Numb(String good_Iden_Numb) {
		this.good_Iden_Numb = good_Iden_Numb;
	}

	public String getGood_Name() {
		return good_Name;
	}

	public void setGood_Name(String good_Name) {
		this.good_Name = good_Name;
	}

	public String getVtax_Clas_Code() {
		return vtax_Clas_Code;
	}

	public void setVtax_Clas_Code(String vtax_Clas_Code) {
		this.vtax_Clas_Code = vtax_Clas_Code;
	}

	public String getSale_Criterion_Type() {
		return sale_Criterion_Type;
	}

	public void setSale_Criterion_Type(String sale_Criterion_Type) {
		this.sale_Criterion_Type = sale_Criterion_Type;
	}

	public String getStan_Buying_Rate() {
		return stan_Buying_Rate;
	}

	public void setStan_Buying_Rate(String stan_Buying_Rate) {
		this.stan_Buying_Rate = stan_Buying_Rate;
	}

	public String getStan_Buying_Money() {
		return stan_Buying_Money;
	}

	public void setStan_Buying_Money(String stan_Buying_Money) {
		this.stan_Buying_Money = stan_Buying_Money;
	}

	public String getIsDistribute() {
		return isDistribute;
	}

	public void setIsDistribute(String isDistribute) {
		this.isDistribute = isDistribute;
	}

	public String getIsDispPastGood() {
		return isDispPastGood;
	}

	public void setIsDispPastGood(String isDispPastGood) {
		this.isDispPastGood = isDispPastGood;
	}

	public String getInsert_Date() {
		return insert_Date;
	}

	public void setInsert_Date(String insert_Date) {
		this.insert_Date = insert_Date;
	}

	public String getCate_Id() {
		return cate_Id;
	}

	public void setCate_Id(String cate_Id) {
		this.cate_Id = cate_Id;
	}

	public String getVendorId() {
		return vendorId;
	}

	public void setVendorId(String vendorId) {
		this.vendorId = vendorId;
	}

	public String getReq_Good_Id() {
		return req_Good_Id;
	}

	public void setReq_Good_Id(String req_Good_Id) {
		this.req_Good_Id = req_Good_Id;
	}

	public String getSale_Unit_Pric() {
		return sale_Unit_Pric;
	}

	public void setSale_Unit_Pric(String sale_Unit_Pric) {
		this.sale_Unit_Pric = sale_Unit_Pric;
	}

	public String getGood_St_Spec_Desc() {
		return good_St_Spec_Desc;
	}

	public void setGood_St_Spec_Desc(String good_St_Spec_Desc) {
		this.good_St_Spec_Desc = good_St_Spec_Desc;
	}

	public String getGood_Spec_Desc() {
		return good_Spec_Desc;
	}

	public void setGood_Spec_Desc(String good_Spec_Desc) {
		this.good_Spec_Desc = good_Spec_Desc;
	}

	public String getOrde_Clas_Code() {
		return orde_Clas_Code;
	}

	public void setOrde_Clas_Code(String orde_Clas_Code) {
		this.orde_Clas_Code = orde_Clas_Code;
	}

	public String getDeli_Mini_Day() {
		return deli_Mini_Day;
	}

	public void setDeli_Mini_Day(String deli_Mini_Day) {
		this.deli_Mini_Day = deli_Mini_Day;
	}

	public String getDeli_Mini_Quan() {
		return deli_Mini_Quan;
	}

	public void setDeli_Mini_Quan(String deli_Mini_Quan) {
		this.deli_Mini_Quan = deli_Mini_Quan;
	}

	public String getMake_Comp_Name() {
		return make_Comp_Name;
	}

	public void setMake_Comp_Name(String make_Comp_Name) {
		this.make_Comp_Name = make_Comp_Name;
	}

	public String getOriginal_Img_Path() {
		return original_Img_Path;
	}

	public void setOriginal_Img_Path(String original_Img_Path) {
		this.original_Img_Path = original_Img_Path;
	}

	public String getIsSetImage() {
		return isSetImage;
	}

	public void setIsSetImage(String isSetImage) {
		this.isSetImage = isSetImage;
	}

	public String getLarge_Img_Path() {
		return large_Img_Path;
	}

	public void setLarge_Img_Path(String large_Img_Path) {
		this.large_Img_Path = large_Img_Path;
	}

	public String getMiddle_Img_Path() {
		return middle_Img_Path;
	}

	public void setMiddle_Img_Path(String middle_Img_Path) {
		this.middle_Img_Path = middle_Img_Path;
	}

	public String getSmall_Img_Path() {
		return small_Img_Path;
	}

	public void setSmall_Img_Path(String small_Img_Path) {
		this.small_Img_Path = small_Img_Path;
	}

	public String getGood_Same_Word() {
		return good_Same_Word;
	}

	public void setGood_Same_Word(String good_Same_Word) {
		this.good_Same_Word = good_Same_Word;
	}

	public String getGood_Desc() {
		return good_Desc;
	}

	public void setGood_Desc(String good_Desc) {
		this.good_Desc = good_Desc;
	}

	public String getIsSetDesc() {
		return isSetDesc;
	}

	public void setIsSetDesc(String isSetDesc) {
		this.isSetDesc = isSetDesc;
	}

	public String getIssub_Ontract() {
		return issub_Ontract;
	}

	public void setIssub_Ontract(String issub_Ontract) {
		this.issub_Ontract = issub_Ontract;
	}

	public String getGood_Clas_Code() {
		return good_Clas_Code;
	}

	public void setGood_Clas_Code(String good_Clas_Code) {
		this.good_Clas_Code = good_Clas_Code;
	}

	public String getGood_Inventory_Cnt() { 
		return good_Inventory_Cnt;
	}

	public void setGood_Inventory_Cnt(String good_Inventory_Cnt) {
		this.good_Inventory_Cnt = good_Inventory_Cnt;
	}

	public String getRegist_Date() {
		return regist_Date;
	}

	public void setRegist_Date(String regist_Date) {
		this.regist_Date = regist_Date;
	}

	public String getOrd_Quan() {
		return ord_Quan;
	}

	public void setOrd_Quan(String ord_Quan) {
		this.ord_Quan = ord_Quan;
	}
	
	public String getRequ_Deli_Date() {
		return requ_Deli_Date;
	}

	public void setRequ_Deli_Date(String requ_Deli_Date) {
		this.requ_Deli_Date = requ_Deli_Date;
	}

	public String getVendorNm() {
		return vendorNm;
	}

	public void setVendorNm(String vendorNm) {
		this.vendorNm = vendorNm;
	}

	public String getVendorCd() {
		return vendorCd;
	}

	public void setVendorCd(String vendorCd) {
		this.vendorCd = vendorCd;
	}

	public String getAreaType() {
		return areaType;
	}

	public void setAreaType(String areaType) {
		this.areaType = areaType;
	}

	public String getPressentNm() {
		return pressentNm;
	}

	public void setPressentNm(String pressentNm) {
		this.pressentNm = pressentNm;
	}

	public String getPhoneNum() {
		return phoneNum;
	}

	public void setPhoneNum(String phoneNum) {
		this.phoneNum = phoneNum;
	}
	
	public String getInsert_User_Nm() {
		return insert_User_Nm;
	}

	public void setInsert_User_Nm(String insert_User_Nm) {
		this.insert_User_Nm = insert_User_Nm;
	}

	public String getInsert_User_Id() {
		return insert_User_Id;
	}

	public void setInsert_User_Id(String insert_User_Id) {
		this.insert_User_Id = insert_User_Id;
	}

	public String getApp_Sts() {
		return app_Sts;
	}

	public void setApp_Sts(String app_Sts) {
		this.app_Sts = app_Sts;
	}

	public String getAdmin_User_Id() {
		return admin_User_Id;
	}

	public void setAdmin_User_Id(String admin_User_Id) {
		this.admin_User_Id = admin_User_Id;
	}

	public String getApp_User_Id() {
		return app_User_Id;
	}

	public void setApp_User_Id(String app_User_Id) {
		this.app_User_Id = app_User_Id;
	}

	public String getApp_Date() {
		return app_Date;
	}

	public void setApp_Date(String app_Date) {
		this.app_Date = app_Date;
	}

	public String getCreate_Good_Date() {
		return create_Good_Date;
	}

	public void setCreate_Good_Date(String create_Good_Date) {
		this.create_Good_Date = create_Good_Date;
	}

	public String getIsUse() {
		return isUse;
	}

	public void setIsUse(String isUse) {
		this.isUse = isUse;
	}

	public String getFix_Good_Id() {
		return fix_Good_Id;
	}

	public void setFix_Good_Id(String fix_Good_Id) {
		this.fix_Good_Id = fix_Good_Id;
	}

	public String getApplt_Fix_Code() {
		return applt_Fix_Code;
	}

	public void setApplt_Fix_Code(String applt_Fix_Code) {
		this.applt_Fix_Code = applt_Fix_Code;
	}

	public String getPrice() {
		return price;
	}

	public void setPrice(String price) {
		this.price = price;
	}

	public String getApply_Desc() {
		return apply_Desc;
	}

	public void setApply_Desc(String apply_Desc) {
		this.apply_Desc = apply_Desc;
	}

	public String getFix_App_Sts() {
		return fix_App_Sts;
	}

	public void setFix_App_Sts(String fix_App_Sts) {
		this.fix_App_Sts = fix_App_Sts;
	}

	public String getMajo_Code_Name() {
		return majo_Code_Name;
	}

	public void setMajo_Code_Name(String majo_Code_Name) {
		this.majo_Code_Name = majo_Code_Name;
	}

	public String getFull_Cate_Name() {
		return full_Cate_Name;
	}

	public void setFull_Cate_Name(String full_Cate_Name) {
		this.full_Cate_Name = full_Cate_Name;
	}

	public String getDisp_Good_Id() {
		return disp_Good_Id;
	}

	public void setDisp_Good_Id(String disp_Good_Id) {
		this.disp_Good_Id = disp_Good_Id;
	}

	public String getGroupId() {
		return groupId;
	}

	public void setGroupId(String groupId) {
		this.groupId = groupId;
	}

	public String getClientId() {
		return clientId;
	}

	public void setClientId(String clientId) {
		this.clientId = clientId;
	}

	public String getBranchId() {
		return branchId;
	}

	public void setBranchId(String branchId) {
		this.branchId = branchId;
	}

	public String getCont_From_Date() {
		return cont_From_Date;
	}

	public void setCont_From_Date(String cont_From_Date) {
		this.cont_From_Date = cont_From_Date;
	}

	public String getCont_To_Date() {
		return cont_To_Date;
	}

	public void setCont_To_Date(String cont_To_Date) {
		this.cont_To_Date = cont_To_Date;
	}

	public String getRef_Good_Seq() {
		return ref_Good_Seq;
	}

	public void setRef_Good_Seq(String ref_Good_Seq) {
		this.ref_Good_Seq = ref_Good_Seq;
	}

	public String getIspast_Sell_Flag() {
		return ispast_Sell_Flag;
	}

	public void setIspast_Sell_Flag(String ispast_Sell_Flag) {
		this.ispast_Sell_Flag = ispast_Sell_Flag;
	}

	public String getFinal_Good_Sts() {
		return Final_Good_Sts;
	}

	public void setFinal_Good_Sts(String final_Good_Sts) {
		Final_Good_Sts = final_Good_Sts;
	}

	public String getSell_Price() {
		return sell_Price;
	}

	public void setSell_Price(String sell_Price) {
		this.sell_Price = sell_Price;
	}

	public String getDisp_From_Date() {
		return disp_From_Date;
	}

	public void setDisp_From_Date(String disp_From_Date) {
		this.disp_From_Date = disp_From_Date;
	}

	public String getDisp_To_Date() {
		return disp_To_Date;
	}

	public void setDisp_To_Date(String disp_To_Date) {
		this.disp_To_Date = disp_To_Date;
	}

	public String getCust_Good_Iden_Numb() {
		return cust_Good_Iden_Numb;
	}

	public void setCust_Good_Iden_Numb(String cust_Good_Iden_Numb) {
		this.cust_Good_Iden_Numb = cust_Good_Iden_Numb;
	}

	public String getTotal_Amout() {
		return total_Amout;
	}

	public void setTotal_Amout(String total_Amout) {
		this.total_Amout = total_Amout;
	}

	public String getStan_Deli_Day() {
		return stan_Deli_Day;
	}

	public void setStan_Deli_Day(String stan_Deli_Day) {
		this.stan_Deli_Day = stan_Deli_Day;
	}

	public String getBorgNms() {
		return borgNms;
	}

	public void setBorgNms(String borgNms) {
		this.borgNms = borgNms;
	}

	public String getGood_Spec() {
		return good_Spec;
	}

	public void setGood_Spec(String good_Spec) {
		this.good_Spec = good_Spec;
	}

	public String getBuy_rate() {
		return buy_rate;
	}

	public void setBuy_rate(String buy_rate) {
		this.buy_rate = buy_rate;
	}

	public String getSale_price() {
		return sale_price;
	}

	public void setSale_price(String sale_price) {
		this.sale_price = sale_price;
	}

	public String getTarget_price() {
		return target_price;
	}

	public void setTarget_price(String target_price) {
		this.target_price = target_price;
	}

}