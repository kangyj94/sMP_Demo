package kr.co.bitcube.product.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Pattern;

import javax.annotation.Resource;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.ModelMap;
import org.springframework.web.servlet.ModelAndView;

import egovframework.rte.fdl.idgnr.EgovIdGnrService;
import kr.co.bitcube.common.dao.GeneralDao;
import kr.co.bitcube.common.dto.LoginUserDto;
import kr.co.bitcube.common.utils.CommonUtils;
import kr.co.bitcube.common.utils.Constances;
import kr.co.bitcube.product.dao.CategoryDao;
import kr.co.bitcube.product.dao.ProductAppDao;
import kr.co.bitcube.product.dao.ProductManageDao;
import kr.co.bitcube.product.dto.CategoryDto;
import kr.co.bitcube.product.dto.ProductAppGoodDto;
import kr.co.bitcube.product.dto.ProductDispDto;
import kr.co.bitcube.product.dto.ProductMasterDto;
import kr.co.bitcube.product.dto.ProductVendorDto;
import kr.co.bitcube.product.dto.ReqProductDto;

@Service
public class ProductManageSvc {

	private Logger logger = Logger.getLogger(getClass());
	
	@Resource(name="seqMcProductService")
	private EgovIdGnrService seqMcProductService;
	
	@Resource(name="seqMcProductDispGoodService")
	private EgovIdGnrService seqMcProductDispGoodService;
	
	@Resource(name="seqMcProductHistoryService")
	private EgovIdGnrService seqMcProductHistoryService;
	
	
	@Resource(name="seqMcAppProductService")
	private EgovIdGnrService seqMcAppProductService;
	
	@Resource(name="seqMcReqProductService")
	private EgovIdGnrService seqMcReqProductService;
	
	@Resource(name="seqMcGoodFixService")
	private EgovIdGnrService seqMcGoodFixService;
	
	
	
	@Autowired
	private ProductManageDao productManageDao;
	
	@Autowired
	private NewProductBidSvc newProductBidSvc;
	
	@Autowired
	private ProductAppSvc productAppSvc;
	
	@Autowired
	private ProductAppDao productAppDao;
	
	@Autowired
	private CategoryDao categoryDao;
	
	@Autowired private GeneralDao generalDao;
	
	public String getCateId(String good_iden_numb) throws Exception  {
		return productManageDao.selectCateId(good_iden_numb);
	}
	
	public List<ProductMasterDto> getProductDetailInfo(Map<String, Object> params) throws Exception  {
		return productManageDao.selectProductDetailInfo(params);
	}
	
	public List<ProductVendorDto> getGoodVendorListByGoodIdenNum(Map<String, Object> params) {
		return productManageDao.selectGoodVendorListByGoodIdenNum(params);
	}
	
	public List<ProductVendorDto> getVendorAutionInfoForInsProduct(Map<String, Object> params) {
		return productManageDao.selectVendorAutionInfoForInsProduct(params);
	}
	
	
	/**
	 * 공급사정보 삭제  
	 */
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})
	public void delProdVendorTransGrid(Map<String, Object> paramMap) {
		productManageDao.deleteProdVendor(paramMap);
	}
	
	/**
	 * 상품 정보 (Master + ProductVendor)를 저장한다.
	 */
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})
	public long setProductInfo(Map<String, Object> paramMap , ModelAndView modelAndView)throws Exception {
		
		/*
		 * 상품 정보(Master)를 처리한다.  
		 */
		if(((String)paramMap.get("isModify")).equals("1")){
			// 등록및 수정 여부를 확인한다.
			if( (Long)paramMap.get("good_iden_numb") == 0 ){
				paramMap.put("good_iden_numb", getGood_iden_numbSequence());
				this.insertProductMstInfomation(paramMap);
			}else{
				this.updateProductMstInfo(paramMap);
			}
			paramMap.put("good_hist_id" , this.getHist_Good_iden_numbSequence());
			this.insertProductMstHistInfoByGood_iden_numb(paramMap);
		}
		
		/*
		 * 상품 정보(prodVendor)를 처리한다.  
		 */
		int idx = 0 ;
		String getYear = CommonUtils.getCurrentDate().substring(0, 4);
		if(paramMap.get("vendorid_array") != null && ((String[])paramMap.get("vendorid_array")).length > 0 ){
			for(String vendorid : (String[])paramMap.get("vendorid_array") ){
				
				Map<String, Object> saveMap = new HashMap<String, Object>();
				
				saveMap.put("good_iden_numb"	,paramMap.get("good_iden_numb"));
				saveMap.put("vendorid"			,vendorid );
				saveMap.put("req_good_id"	    , ((String[])paramMap.get("req_good_id_array"))[idx]);
				saveMap.put("sale_unit_pric"	,CommonUtils.stringParseLong((((String[])paramMap.get("sale_unit_pric_array"))[idx]),0) );
				saveMap.put("orgsale_unit_pric"	,CommonUtils.stringParseLong((((String[])paramMap.get("orgsale_unit_pric_array"))[idx]),0) );
				
				saveMap.put("good_st_spec_desc"	,((String[])paramMap.get("good_st_spec_desc_array"))[idx] );
				saveMap.put("good_spec_desc"	,((String[])paramMap.get("good_spec_desc_array"))[idx] );
				saveMap.put("orde_clas_code"	,((String[])paramMap.get("orde_clas_code_array"))[idx] );
				saveMap.put("deli_mini_day"		,CommonUtils.stringParseDouble((((String[])paramMap.get("deli_mini_day_array"))[idx]),0));
				saveMap.put("deli_mini_quan"	,CommonUtils.stringParseDouble((((String[])paramMap.get("deli_mini_quan_array"))[idx]),0));
				saveMap.put("make_comp_name"	,((String[])paramMap.get("make_comp_name_array"))[idx] );
				saveMap.put("original_img_path"	,((String[])paramMap.get("original_img_path_array"))[idx] );
				saveMap.put("large_img_path"	,((String[])paramMap.get("large_img_path_array"))[idx] );
				saveMap.put("middle_img_path"	,((String[])paramMap.get("middle_img_path_array"))[idx] );
				saveMap.put("small_img_path"	,((String[])paramMap.get("small_img_path_array"))[idx] );
				saveMap.put("good_same_word"	,((String[])paramMap.get("good_same_word_array"))[idx] );
				saveMap.put("good_desc"			,((String[])paramMap.get("good_desc_array"))[idx] );
				saveMap.put("issub_ontract"		,((String[])paramMap.get("issub_ontract_array"))[idx] );
				saveMap.put("good_clas_code"	,((String[])paramMap.get("good_clas_code_array"))[idx] );
				saveMap.put("good_inventory_cnt",CommonUtils.stringParseDouble((((String[])paramMap.get("good_inventory_cnt_array"))[idx]),0));
				saveMap.put("distri_rate"		,CommonUtils.stringParseInt((((String[])paramMap.get("distri_rate_array"))[idx]),0));
				saveMap.put("inser_user_id"     ,paramMap.get("insert_user_id")  );
				saveMap.put("good_reg_year"     ,((String[])paramMap.get("good_reg_year"))[idx]);
				saveMap.put("vendor_priority"   ,((String[])paramMap.get("vendor_priority"))[idx]);
				saveMap.put("the_day_post"   ,((String[])paramMap.get("the_day_post"))[idx]);
				
				if(this.getProductVendorCount(saveMap) == 0){
					// Insert
					insertProductVendorInfo(saveMap);
					
					// 입찰 상품등록인 경우 아래 로직 처리 
					String bidId 		= ((String[])paramMap.get("bidid_array"))[idx];
					String bid_vendor 	= ((String[])paramMap.get("bid_vendorid_array"))[idx];
					if( !bidId.equals("") ){
						Map<String, Object> saveBidMap = new HashMap<String, Object>();
						
						saveBidMap.put("bidid"			, bidId);
						saveBidMap.put("bid_vendor"		, bid_vendor);
						saveBidMap.put("good_iden_numb"	, paramMap.get("good_iden_numb"));
						
						newProductBidSvc.bidAuctionRegistratTrans(saveBidMap);
					}
					
					// 신규품목 요청
					String req_good_id 	= ((String[])paramMap.get("req_good_id_array"))[idx];
					if(!req_good_id.equals("")){
						Map<String, Object> saveReqGoodMap = new HashMap<String, Object>();
						
						saveReqGoodMap.put("req_good_id"	, req_good_id							);
						saveReqGoodMap.put("app_user_id"	, (String)paramMap.get("insert_user_id"));
						saveReqGoodMap.put("good_iden_numb"	, paramMap.get("good_iden_numb")		);
						
						productManageDao.updateRegistReqProductByAdmin(saveReqGoodMap);
						
					}
					
				}else{
					
					// Update
					updateProductVendorInfo(saveMap);
					
					// 매입가 변경에 따른 승인여부 확인 처리 
					if(! ((Long)saveMap.get("sale_unit_pric") == (Long)saveMap.get("orgsale_unit_pric")) ){
						
						// 승인여부 확인 
						if(Constances.PROD_APPROVAL_FLAG){
							
							// 이미 단가정보 변경 승인 정보가 있는지 여부를 확인한다. 
							boolean isAbleData = true;
//							if(selectAppProductByVendorId(saveMap).getUnitpriceappflag().equals("Y")){
//								modelAndView.addObject("msg", "매입단가 변경에 따른 승인 요청이 들어온 데이터 입니다.\n확인후 매입단가를 변경하시기 바랍니다.");
//								isAbleData = false; 
//							}
							
							if(this.selectIsExsitsProdVendorApp(saveMap).getProdvendorAppFlag().equals("Y")){
								modelAndView.addObject("msg", "매입 단가 변경이 불가 합니다.\n풀목 공급사 승인요청 중인 정보입니다. \n확인후 이용하시기 바랍니다.");
								isAbleData = false; 
							}
							
							
							if(isAbleData){
								Map<String, Object> appMap = new HashMap<String, Object>();
								String appProdSequence = seqMcAppProductService.getNextStringId();
								appMap.put("app_good_id"    , CommonUtils.stringParseInt(appProdSequence, 0));  /* 단가변경SEQ   */ 
								appMap.put("chn_price_clas" , "20");   											/* 단가변경타입  */   
								appMap.put("good_iden_numb" , (Long)paramMap.get("good_iden_numb"));   			/* 상품코드      */ 
								appMap.put("fix_good_id"    , null);   											/* 요청SEQ  */    
								appMap.put("disp_good_id"   , null);   											/* 진열SEQ  */    
								appMap.put("before_price"   , (Long)saveMap.get("orgsale_unit_pric"));          /* 기존단가      */ 
								appMap.put("after_price"    , (Long)saveMap.get("sale_unit_pric"));   	        /* 변경단가      */ 
								appMap.put("change_reason"  , "운영자 공급사 매입가 변경 ");   							/* 변경사유      */ 
								appMap.put("app_sts_flag"   , "0");   											/* 승인상태      */ 
								appMap.put("register_userid", (String)paramMap.get("insert_user_id"));   		/* 등록자ID  */    
								appMap.put("register_date"  , CommonUtils.getCurrentDate().replaceAll("-", "") );	/* 등록일자      */ 
								appMap.put("confirm_userid" , (String)paramMap.get("insert_user_id"));   		/* 확인자ID  */    
								appMap.put("confirm_date"   , CommonUtils.getCurrentDate().replaceAll("-", "")  );	/* 확인일자      */ 
								appMap.put("vendorid"       , saveMap.get("vendorid"));   						/* 공급사ID  */    
								
								insertAppProdVendorUnitPrice(appMap);
							}
						}else {
							// 승인이 없을시 바로 판매 단가 변경 
							updateProductVendorUnitPric(saveMap);
						}
					}
				}
				
				// History Update 
				saveMap.put("good_hist_id" , this.getHist_Good_iden_numbSequence());
				this.insertProductVendorHistInfoBySeq(saveMap);
				idx ++; 
			}
		}
		return (Long)paramMap.get("good_iden_numb");
	}
	
	/**
	 * 상품 Sequence 정보를 조회한다.  
	 */
	public long getGood_iden_numbSequence() throws Exception{
		return seqMcProductService.getNextLongId();
	}
	
	/**
	 * 상품 History Sequence 정보를 조회한다.  
	 */
	public int getHist_Good_iden_numbSequence() throws Exception{
		return seqMcProductHistoryService.getNextIntegerId();
	}
	
	/**
	 * 상품 Master Info 저장   
	 */
	public void insertProductMstInfomation(Map<String, Object> paramMap) {
		productManageDao.insertProductMstInfomation(paramMap);
	}
	
	/**
	 * 상품 Master Info 수정 
	 */
	public void updateProductMstInfo(Map<String, Object> paramMap) {
		productManageDao.updateProductMstInfo(paramMap);
	}
	
	/**
	 *  상품 Master Info 히스토리 저장 
	 */
	public void insertProductMstHistInfoByGood_iden_numb(Map<String, Object> paramMap) {
		productManageDao.insertProductMstHistInfoByGood_iden_numb(paramMap);
	}
	
	/**
	 * 상품 seq 공급사 id 기준 상품 count 트를 반환한다.  
	 */
	public int getProductVendorCount(Map<String, Object> paramMap){
		return productManageDao.selectProductVendorCount(paramMap);
	}
	
	/**
	 * 상품 공급사 정보를 저장한다. 
	 */
	public void insertProductVendorInfo(Map<String, Object> paramMap){
		productManageDao.insertProductVendorInfo(paramMap);
	}
	
	/**
	 * 상품 공급사 정보를 수정한다.  
	 */
	public void updateProductVendorInfo(Map<String, Object> paramMap){
		productManageDao.updateProductVendorInfo(paramMap);
	}
	
	/**
	 * 상품 공급사 정보를 수정한다.  
	 */
	public void updateProductVendorUnitPric(Map<String, Object> paramMap){
		productManageDao.updateProductVendorUnitPric(paramMap);
	}
	
	public void insertAppProdVendorUnitPrice(Map<String, Object> paramMap){
		productManageDao.insertAppProdVendorUnitPrice(paramMap);
	}
	
	/**
	 * 히스토리를 저장한다.  
	 */
	public void insertProductVendorHistInfoBySeq(Map<String, Object> paramMap){
		productManageDao.insertProductVendorHistInfoBySeq(paramMap);
	}
	
	/**
	 * 상품 진열 조직 List 를 조회한다. 
	 */
	public List<ProductDispDto> getDisplayGoodList(Map<String, Object> params) {
		return productManageDao.selectDisplayGoodList(params);
	}
	
	/**
	 * 삼품진열 삭제 
	 */
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})
	public void delProdSalePriceDel(Map<String, Object> paramMap ,ModelAndView modelAndView) {
		
		// 판매가 변경 승인요청 조회 있는지 여부
		Boolean isAbleProcess = true;
		ProductDispDto productDispDto = this.selectIsExsitsDispProductApp(paramMap);
		if(productDispDto.getDispAppFlag().equals("Y")){
			modelAndView.addObject("msg", "판매가 승인 요청중인 정보입니다.\n확인후 이용하시기 바랍니다.");
			isAbleProcess = false;
		}
		if(!isAbleProcess) return; 
		
		paramMap.put("final_good_sts", "0");
		logger.debug("tranUserId : "+paramMap.get("tranUserId"));
		productManageDao.deleteProdSalePriceDel(paramMap);
	}
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})
	public void delProdSalePriceArrayDel(String[] disp_good_id_array, ModelAndView modelAndView, Map<String, Object> params) {
		for(String disp_good_id:disp_good_id_array) {
			// 판매가 변경 승인요청 조회 있는지 여부
			Boolean isAbleProcess = true;
			Map<String, Object> paramMap = new HashMap<String, Object>();
			paramMap.put("disp_good_id", disp_good_id);
			paramMap.put("tranUserId", params.get("tranUserId").toString());
			ProductDispDto productDispDto = this.selectIsExsitsDispProductApp(paramMap);
			if(productDispDto.getDispAppFlag().equals("Y")){
				modelAndView.addObject("msg", "판매가 승인 요청중인 정보입니다.\n확인후 이용하시기 바랍니다.");
				isAbleProcess = false;
			}
			if(!isAbleProcess) return; 
			paramMap.put("final_good_sts", "0");
			productManageDao.deleteProdSalePriceDel(paramMap);
		}
	}
	
	/********************************************************************************************************************************/
	
	/**
	 *  판가정보를 등록 처리 한다. 
	 */
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})
	public void insertMcDispGoodTranction(Map<String, Object> saveMap) throws Exception {
		
		String[] groupid_array = (String[])saveMap.get("groupid_array");
		
		if(groupid_array.length > 0 ){
			// 복수 조직 진열 정보 등록 
			
			int arryIdx = 0 ; 
			for(String groupid : (String[])saveMap.get("groupid_array")){
				Map<String,Object> dispSaveMap = new HashMap<String,Object>();
				
				dispSaveMap.put("good_iden_numb"	 , saveMap.get("good_iden_numb") 	);
				dispSaveMap.put("areatype"			 , saveMap.get("areatype") 			);
				dispSaveMap.put("groupid"			 , groupid							);
				dispSaveMap.put("clientid"			 , ((String[])saveMap.get("clientid_array"))[arryIdx]);
				dispSaveMap.put("branchid"			 , ((String[])saveMap.get("branchid_array"))[arryIdx]);
				dispSaveMap.put("cont_from_date"	 , saveMap.get("cont_from_date")	);
				dispSaveMap.put("cont_to_date"		 , saveMap.get("cont_to_date")		);
				dispSaveMap.put("ispast_sell_flag"	 , "1"								);
				dispSaveMap.put("sell_price"		 , CommonUtils.stringParseDouble((String)saveMap.get("sell_price")    , 0));
				dispSaveMap.put("sale_unit_pric"	 , CommonUtils.stringParseDouble((String)saveMap.get("sale_unit_pric"), 0));
				dispSaveMap.put("cust_good_iden_numb", saveMap.get("cust_good_iden_numb")						);
				dispSaveMap.put("vendorid"			 , saveMap.get("vendorid")									);
				dispSaveMap.put("ref_good_seq"		 , 0														);
				dispSaveMap.put("insertUserId"		 , saveMap.get("insertUserId"));
				
				registMcDispGoodProcessExceptApp(dispSaveMap);
				arryIdx++; 
			}
		}else{
			// 단일 조직 진열 정보
			
			Map<String,Object> dispSaveMap = new HashMap<String,Object>();
			
			dispSaveMap.put("good_iden_numb"	 , saveMap.get("good_iden_numb") 	);
			dispSaveMap.put("areatype"			 , saveMap.get("areatype") 			);
			dispSaveMap.put("groupid"			 , 0	);
			dispSaveMap.put("clientid"			 , 0	);
			dispSaveMap.put("branchid"			 , 0	);
			dispSaveMap.put("cont_from_date"	 , saveMap.get("cont_from_date")	);
			dispSaveMap.put("cont_to_date"		 , saveMap.get("cont_to_date")		);
			dispSaveMap.put("ispast_sell_flag"	 , "1"								);
			dispSaveMap.put("sell_price"		 , CommonUtils.stringParseDouble((String)saveMap.get("sell_price"), 0));
			dispSaveMap.put("sale_unit_pric"	 , CommonUtils.stringParseDouble((String)saveMap.get("sale_unit_pric"), 0));
			dispSaveMap.put("cust_good_iden_numb", saveMap.get("cust_good_iden_numb")						);
			dispSaveMap.put("vendorid"			 , saveMap.get("vendorid")									);
			dispSaveMap.put("ref_good_seq"		 , 0														);
			dispSaveMap.put("insertUserId"		 , saveMap.get("insertUserId"));
			
			registMcDispGoodProcessExceptApp(dispSaveMap);
			
		}
	}
	
	/**
	 * 판가정보 변경에 따른 처리 Process disp_from_date disp_to_date
	 */
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})
	public void setMcDispGoodTranction(Map<String, Object> saveMap, ModelAndView modelAndView) throws Exception {
		
		// 등록인경우 
		if(((Integer)saveMap.get("disp_good_id")).intValue() == 0 ) {	
			//추가
			registMcDispGoodProcessExceptApp(saveMap);
		}else{
			//수정 
			
			// 고객사 상품 코드 UPDATE 
			setMcDispGoodCustGoodIdenNumb(saveMap);
			
			//기존 단가와 차이가 있는지 확인한다. -- 차이가 있을시
			if((Double)saveMap.get("sell_price")  != (Double)saveMap.get("before_price")){
				
				
				if(Constances.PROD_APPROVAL_FLAG){	// 승인여부 존재시
					
					Boolean isAbleProcess = true; 
					
					// 판매가 변경 승인요청 조회 있는지 여부 
					ProductDispDto productDispDto = this.selectIsExsitsDispProductApp(saveMap);
					if(productDispDto.getDispAppFlag().equals("Y")){
						modelAndView.addObject("msg", "판매가 승인 요청중인 정보입니다.\n확인후 이용하시기 바랍니다.");
						isAbleProcess = false;
					}
					// 종료요청 승인정보 여부 
					productDispDto = this.selectIsExsitsProdVendorApp(saveMap);
					if(productDispDto.getProdvendorAppFlag().equals("Y")){
						modelAndView.addObject("msg", "풀목 공급사 승인요청 중인 정보입니다. \n확인후 이용하시기 바랍니다.");
						isAbleProcess = false;
					}
						
					if(!isAbleProcess)	return;
						
					registMcDispGoodProcessIncludeApp(saveMap);
						 
				}else {
					registMcDispGoodProcessExceptApp( saveMap);
				}
			}
		}
	}
	
	// 판가 승인 조회 
	public ProductDispDto selectIsExsitsDispProductApp(Map<String, Object> params) {
		return productManageDao.selectIsExsistDispproductApp(params);
	}
	
	// 매입가 변경 및 종료 요청 승인 조회 
	public ProductDispDto selectIsExsitsProdVendorApp(Map<String, Object> params) {
		return productManageDao.selectIsExsistProdVendorApp(params);
	}
	
	
	
	// 승인없이 진열 수정 
	public void registMcDispGoodProcessExceptApp(Map<String, Object> saveMap)throws Exception{
		// 승인 시퀀스
		int dispGoodSequence = seqMcProductDispGoodService.getNextIntegerId();
		saveMap.put("disp_good_id", dispGoodSequence);
		saveMap.put("final_good_sts", "1");
		saveMap.put("disp_from_date", CommonUtils.getCurrentDate() );
		productManageDao.insertDisplayGood(saveMap);
		
		if(((Integer)saveMap.get("ref_good_seq")).intValue() != 0 ) {	//추가
			productManageDao.updateRefDisplayGood(saveMap);
		}
	}
	
	// 승인있이 상품 수정 
	public void registMcDispGoodProcessIncludeApp(Map<String, Object> saveMap)throws Exception{
		
		int dispGoodSequence = seqMcProductDispGoodService.getNextIntegerId();
		saveMap.put("disp_good_id", dispGoodSequence);
		saveMap.put("final_good_sts", "9");
		productManageDao.insertDisplayGood(saveMap);
		
		// 승인 시퀀스
		String appProdSequence = seqMcAppProductService.getNextStringId();
		saveMap.put("app_good_id", CommonUtils.stringParseInt(appProdSequence, 0));
		productManageDao.insertAppGoodPrice(saveMap);
	}
	
	
	// 고객사 상품 코드를 업데이트 한다. 
	public void setMcDispGoodCustGoodIdenNumb(Map<String, Object> saveMap){
		productManageDao.updateMcDispGoodCustGoodIdenNumb(saveMap);
	}
	
	
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})
	@Deprecated
	public void setDispProductAddRow(Map<String, Object> saveMap, ModelAndView modelAndView) throws Exception {
		
		if(((String)saveMap.get("oper")).equals("del")){
			
			saveMap.put("final_good_sts","0");
			this.delDisplayGoodAppGoodPrice(saveMap);
			
		}else {
			// 추가및 수정 
//			if(((Integer)saveMap.get("disp_good_id")).intValue() == 0 ) {	//추가
				//   0.   이미 등록된 상품 여부 확인  
				ProductDispDto productDispDto = this.selectDispAppProduct(saveMap);
				boolean isAbleData = true; 
				
//				if(productDispDto.getPriceappflag().equals("Y") ){
//					modelAndView.addObject("msg", "판매가 승인 요청중인 정보입니다.");
//					isAbleData = false;
//				}
//				
//				if(productDispDto.getDiscontappflag().equals("Y")){   
//					modelAndView.addObject("msg", "공급사 종료 요청중인 판가 입니다.");
//					isAbleData = false;
//				}
				
				if(!isAbleData)	return;
				
				String dispGoodSequence = seqMcProductDispGoodService.getNextStringId();
				saveMap.put("disp_good_id", CommonUtils.stringParseInt(dispGoodSequence, 0));
				productManageDao.insertDisplayGood(saveMap);
				
				//
				if(!Constances.PROD_APPROVAL_FLAG) {
					// 승인 시퀀스
					String appProdSequence = seqMcAppProductService.getNextStringId();
					saveMap.put("app_good_id", CommonUtils.stringParseInt(appProdSequence, 0));
					productManageDao.insertAppGoodPrice(saveMap);
					
				}else{
					// 2. 
					productManageDao.updateDisplayGood(saveMap);
					
					// 3.
					if((Integer)saveMap.get("ref_good_seq") != 0) {
						productManageDao.updateRefDisplayGood(saveMap);
					}
					
				}
					
				
				
				
					
					
				//	this.regDisplayGoodAppGoodPrice(saveMap); // 상품등록 
					//	this.appDisplayGoodAppGoodPrice(saveMap); // 승인정보 update 
				
//			} 
//			else{	//수정
//				ProductDispDto productDispDto = this.getDispProductListCnt(saveMap) ;
//				boolean isAbleData = true; 
//				
//				if(productDispDto.getPriceappflag().equals("Y") ){
//					modelAndView.addObject("msg", "판매가 승인 요청중인 정보입니다.");
//					isAbleData = false;
//				}
//				if(productDispDto.getDiscontappflag().equals("Y")){   
//					modelAndView.addObject("msg", "공급사 종료 요청중인 판가 입니다.");
//					isAbleData = false;
//				}
//				
//				if(isAbleData){
//					this.regDisplayGoodAppGoodPrice(saveMap);
//					
//					if(!Constances.PROD_APPROVAL_FLAG) 
//						this.appDisplayGoodAppGoodPrice(saveMap);
//				}
//			}
		}
	}
	
	
	
	/**
	 * 상품 진열 중복 체크 ( 상품코드 , 공급사 , 그룹 , 법인 , 사업장 , final_good_sts )
	 */
	@Deprecated
	public ProductDispDto selectDispAppProduct(Map<String, Object> params) {
		return productManageDao.selectDispAppProduct(params);
	}
	
	/**
	 * 상품 진열 중복 체크 ( 상품코드 , 공급사 , 그룹 , 법인 , 사업장 , final_good_sts )
	 */
	@Deprecated
	public ProductDispDto selectAppProductByVendorId (Map<String, Object> params) {
		return productManageDao.selectAppProductByVendorId(params);
	}
	
	
	
	/**
	 * Step 1 . 상품 진열 저장  
	 * Step 2 . 상품 승인 저장
	 */
	public void regDisplayGoodAppGoodPrice(Map<String, Object> saveMap) throws Exception {
		// 상품 진열 시퀀스 
		String dispGoodSequence = seqMcProductDispGoodService.getNextStringId();
		saveMap.put("disp_good_id", CommonUtils.stringParseInt(dispGoodSequence, 0));
		
		// 승인 시퀀스
		String appProdSequence = seqMcAppProductService.getNextStringId();
		saveMap.put("app_good_id", CommonUtils.stringParseInt(appProdSequence, 0));
		productManageDao.insertDisplayGood(saveMap);
		productManageDao.insertAppGoodPrice(saveMap);
		
		saveMap.put("prodSequence", dispGoodSequence);
		saveMap.put("appProdSequence", appProdSequence);
	}
	
	/**
	 * 수정
	 */
	public void appDisplayGoodAppGoodPrice(Map<String, Object> saveMap) throws Exception {
		productManageDao.updateAppGoodPrice(saveMap);
		if((Integer)saveMap.get("ref_good_seq") != 0) {
			productManageDao.updateRefDisplayGood(saveMap);
		}
		productManageDao.updateDisplayGood(saveMap);
	}
	
	/**
	 * 카테고리 진열 조직정보를 카테고리 id를 이용하여 조회한다. 
	 */
	public List<CategoryDto> getCategoryInfoListByCateId(Map<String, Object> params) {
		return productManageDao.selectCategoryInfoListByCateId(params);
	}
	
	/**
	 * 상품진열정보를 삭제한다 (update 미진열상태로)  
	 */
	public void delDisplayGoodAppGoodPrice(Map<String, Object> params){
		productManageDao.delDisplayGoodAppGoodPrice(params);
	}
	
	/**
	 * 상품진열에 따른 과거상품 진열 이력을 조회한다.  
	 */
	public List<ProductDispDto> getDisplayGoodHistList(Map<String, Object> params) {
		return productManageDao.selectDisplayGoodHistList(params);
	}
	
	/**
	 * (운영사)가격진열 과거상품 진열여부 수정 
	 */
	public void displayGoodUpdateTrans(Map<String, Object> params){
		String[] disp_good_id_array = (String[])params.get("disp_good_id_array");
		int arrIndex = 0 ; 
		for(String disp_good_id:disp_good_id_array) {
			String ispast_sell_flag = ((String[])params.get("ispast_sell_flag_array"))[arrIndex];
			Map<String, Object> saveMap = new HashMap<String,Object>();
			saveMap.put("disp_good_id"		, disp_good_id);
			saveMap.put("ispast_sell_flag"	, ispast_sell_flag);
			productManageDao.updatedisplayGoodUpdateTrans(saveMap);
			arrIndex++;
		}
	}
	
	/**
	 * 신규품목 요청 상세 조회 
	 */
	public List<ReqProductDto> getReqProductDetailInfo(Map<String, Object> params){
		return productManageDao.selectReqProductDetailInfo(params);
	}
	
	/**
	 * 고객사상품등록요청 등록 Service  
	 */
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})
	public void setVendorReqProductInfoTransGrid (Map<String, Object> params)throws Exception {
		ModelMap paramMap = (ModelMap) params.get("paramMap");	//규격들
		
		paramMap.put("spec_spec"			, paramMap.get("spec_spec"		) == null ? "" : ((String)paramMap.get("spec_spec")).replace("\"","＂") ); 
		paramMap.put("spec_pi"				, paramMap.get("spec_pi"			) == null ? "" : ((String)paramMap.get("spec_pi")).replace("\"","＂") ); 
		paramMap.put("spec_width"			, paramMap.get("spec_width"		) == null ? "" : ((String)paramMap.get("spec_width")).replace("\"","＂") ); 
		paramMap.put("spec_deep"			, paramMap.get("spec_deep"		) == null ? "" : ((String)paramMap.get("spec_deep")).replace("\"","＂") ); 
		paramMap.put("spec_height"			, paramMap.get("spec_height"	) == null ? "" : ((String)paramMap.get("spec_height")).replace("\"","＂") ); 
		paramMap.put("spec_liter"				, paramMap.get("spec_liter"		) == null ? "" : ((String)paramMap.get("spec_liter")).replace("\"","＂") ); 
		paramMap.put("spec_ton"				, paramMap.get("spec_ton"		) == null ? "" : ((String)paramMap.get("spec_ton")).replace("\"","＂") ); 
		paramMap.put("spec_meter"			, paramMap.get("spec_meter"		) == null ? "" : ((String)paramMap.get("spec_meter")).replace("\"","＂") ); 
		paramMap.put("spec_material"		, paramMap.get("spec_material"	) == null ? "" : ((String)paramMap.get("spec_material")).replace("\"","＂") ); 
		paramMap.put("spec_size"				, paramMap.get("spec_size"		) == null ? "" : ((String)paramMap.get("spec_size")).replace("\"","＂") ); 
		paramMap.put("spec_weight_sum"	, paramMap.get("spec_weight_sum"	) == null ? "" : ((String)paramMap.get("spec_weight_sum")).replace("\"","＂") ); 
		paramMap.put("spec_color"			, paramMap.get("spec_color"		) == null ? "" : ((String)paramMap.get("spec_color")).replace("\"","＂") ); 
		paramMap.put("spec_type"			, paramMap.get("spec_type"		) == null ? "" : ((String)paramMap.get("spec_type")).replace("\"","＂") ); 
		paramMap.put("spec_weight_real"	, paramMap.get("spec_weight_real"	) == null ? "" : ((String)paramMap.get("spec_weight_real")).replace("\"","＂") ); 
		
		params.put("good_spec_desc", ((String)params.get("good_spec_desc")).replace("\"","＂") ); 
		params.put("good_st_spec_desc", ((String)params.get("good_st_spec_desc")).replace("\"","＂") ); 
		
		
		if(((String)params.get("oper")).equals("ins")){
			String req_good_id = seqMcReqProductService.getNextStringId();
			params.put("req_good_id", req_good_id);
			productManageDao.insertVendorReqProductInfoMation(params);
			
			paramMap.put("req_good_id", req_good_id);
			System.out.println("jameskang paramMap : "+paramMap);
			generalDao.insertGernal("product.manage.insertMcgoodRequestSpec", paramMap);
		}else if(((String)params.get("oper")).equals("upd")){
			productManageDao.updateVendorReqProductInfoMation(params);
			
			paramMap.put("req_good_id", params.get("req_good_id"));
			generalDao.updateGernal("product.manage.updateMcgoodRequestSpec", paramMap);
		}else if(((String)params.get("oper")).equals("del")){
			productManageDao.deleteVendorReqProductInfoMation(params);
			generalDao.updateGernal("product.manage.deleteMcgoodRequestSpec", params);
		}
	}
	
	
	/**
	 * 고객사상품등록요청 운영사 처리   
	 */
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})
	public void setAdminReqProductInfoTransGrid(Map<String, Object> params)throws Exception {
		
		if(((String)params.get("oper")).equals("appCancel")){
			params.put("app_sts", "3");
			productManageDao.updateReqProductAppSts(params);
		}
	}
	
	/**
	 * 신규품목 요청상품을 상품공급사에 등록한다. 
	 * @param params
	 * @throws Exception
	 */
	public void setRegistReqProductInfo(Map<String, Object> params)throws Exception {
		params.put("app_sts", "2");
		productManageDao.updateRegistReqProductByAdmin(params);
	}

	
	/**
	 * 공급사 상품 정보를 변경한다. 판가 금액 X    
	 */
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})
	public void setProductVendorInfoExistSaleUnitPrice(Map<String, Object> saveMap)throws Exception {
		
		// Update
		this.updateProductVendorInfo(saveMap);
		saveMap.put("good_hist_id" , this.getHist_Good_iden_numbSequence());
		this.insertProductVendorHistInfoBySeq(saveMap);
	}
	
	/**
	 * 공급사 상세 품목 정보 
	 */
	public List<ProductVendorDto> getGoodVendorListForVendor(Map<String, Object> params) {
		return productManageDao.selectGoodVendorListForVendor(params);
	}
	
	/**
	 * 단가변경요청     
	 */
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})
	public void setFixGoodUnitPriceTrans(Map<String, Object> saveMap , LoginUserDto loginUserDto)throws Exception {
		
		if(loginUserDto.getSvcTypeCd().equals("VEN")){
			saveMap.put("fix_good_id", seqMcGoodFixService.getNextStringId());
			saveMap.put("fix_app_sts", "0");
			
			// insert  mcgoodFix 
			productManageDao.insertFixGoodUnitPriceTrans(saveMap);
			
		}else if(loginUserDto.getSvcTypeCd().equals("ADM")) {
			
			//	1. 승인여부 확인 
			if(Constances.PROD_APPROVAL_FLAG){
				// insert mcappgoodprice
				Map<String, Object> appMap = new HashMap<String, Object>();
				appMap.put("app_good_id"    , seqMcAppProductService.getNextIntegerId());       /* 단가변경SEQ */ 
				appMap.put("chn_price_clas" , saveMap.get("applt_fix_code"));   				/* 단가변경타입  */   
				appMap.put("good_iden_numb" , saveMap.get("good_iden_numb"));   				/* 상품코드      */ 
				appMap.put("fix_good_id"    , null);   											/* 요청SEQ  */    
				appMap.put("disp_good_id"   , null);   											/* 진열SEQ  */    
				appMap.put("before_price"   , saveMap.get("before_price"));          			/* 기존단가      */ 
				appMap.put("after_price"    , saveMap.get("price"));   	        				/* 변경단가      */ 
				appMap.put("change_reason"  , "");   											/* 변경사유      */ 
				appMap.put("app_sts_flag"   , "0");   											/* 승인상태      */ 
				appMap.put("register_userid", loginUserDto.getUserId());   						/* 등록자ID  */    
				appMap.put("register_date"  , CommonUtils.getCurrentDate().replaceAll("\\-", ""));/* 등록일자      */ 
				appMap.put("confirm_userid" , loginUserDto.getUserId());   						/* 확인자ID  */    
				appMap.put("confirm_date"   , CommonUtils.getCurrentDate().replaceAll("\\-", ""));/* 확인일자      */ 
				appMap.put("vendorid"       , saveMap.get("vendorid"));   						/* 공급사ID  */    
				
				insertAppProdVendorUnitPrice(appMap);
			}else {
				saveMap.put("insetUserId", loginUserDto.getUserId());//상품히스토리에 등록자 아이디
				
				
				Map<String, Object> mcGoodFixMap = new HashMap<String, Object>();
				mcGoodFixMap.put("fix_good_id", seqMcGoodFixService.getNextStringId());	//요청SEQ
				// 매입가 변경시 
				if( ((String)saveMap.get("applt_fix_code")).equals("20") ){
					logger.debug("productAppSvc.setSoldOutProduct applt_fix_code ParamVal["+(String)saveMap.get("applt_fix_code")+"] HashMap Params Value ["+saveMap+"]");
					saveMap.put("after_price", saveMap.get("price"));
					productAppSvc.setUnitPriceAppOk(saveMap);

				}
				
				// 종료요청시 
				if( ((String)saveMap.get("applt_fix_code")).equals("30") ){
					// 승인이 없을시 
					logger.debug("productAppSvc.setSoldOutProduct applt_fix_code ParamVal["+(String)saveMap.get("applt_fix_code")+"] HashMap Params Value ["+saveMap+"]");
					saveMap.put("after_price", saveMap.get("price"));
					productAppSvc.setSoldOutProduct(saveMap);
				}
				
				//운영사에서 매입단가 변경 및 종료시 mcgoodfix 테이블에 정보 입력
				mcGoodFixMap.put("good_iden_numb", saveMap.get("good_iden_numb"));
				mcGoodFixMap.put("vendorid", saveMap.get("vendorid"));
				mcGoodFixMap.put("applt_fix_code", saveMap.get("applt_fix_code"));
				mcGoodFixMap.put("price", saveMap.get("price"));
				mcGoodFixMap.put("apply_desc", saveMap.get("apply_desc"));
				mcGoodFixMap.put("fix_app_sts", "2");
				mcGoodFixMap.put("insert_user_id", saveMap.get("insert_user_id"));
				mcGoodFixMap.put("before_price", saveMap.get("before_price"));
				mcGoodFixMap.put("app_user_id", saveMap.get("insert_user_id"));
				productManageDao.insertFixGoodUnitPriceTrans(mcGoodFixMap);
			}
		}
	}
	
	/**
	 * 종료 취소 
	 */
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})
	public void setModifyUseState(Map<String, Object> saveMap)throws Exception {
		
		saveMap.put("isUse" , "1");
		productManageDao.updateModifyUseState(saveMap);
		
		saveMap.put("good_hist_id" , this.getHist_Good_iden_numbSequence());
		this.insertProductVendorHistInfoBySeq(saveMap);
	}
	
	/**
	 * 엑셀 일괄 등록시 입력한 값이 올바른지 확인한다. 
	 */
	public List<Map<String, Object>> validationProdInfo(List<Map<String, Object>> saveList , LoginUserDto loginUserDto ) throws Exception {
		List<Map<String, Object>> rtnList =  new ArrayList<Map<String, Object>>();
			for(int idx = 0 ; idx < saveList.size(); idx ++ ) {
				logger.debug("\n\n\n Validation Count No.["+idx+"]");
				if(idx==0) {
					continue;
				}
				Map<String, Object> saveMap =  saveList.get(idx);
				String valRlt = ""; 
				// 상품코드가 있고, 카테고리 code가 있고, 상품명이 있고, 과세구분여부가 있고, 판가산출옵션이 있을때 아래 내용 실행
				// 결론 : 상품코드가 있는 데이터(상품마스터 update)
				if(	((String)saveMap.get("good_iden_numb")).trim().length() != 0 
						&& ((String)saveMap.get("cate_cd")).trim().length() != 0 
						&& ((String)saveMap.get("good_name")).trim().length() != 0  
						&& ((String)saveMap.get("vtax_clas_code")).trim().length() != 0 
//						&& ((String)saveMap.get("sale_criterion_type")).trim().length() != 0 
				) {
					
					if( ((String)saveMap.get("good_iden_numb")).trim().length() > 0  && !Pattern.matches("^[0-9]*$", (String)saveMap.get("good_iden_numb")))			valRlt += "\n상품코드는 숫자만 입력 하셔야 합니다."; 
					if(((String)saveMap.get("cate_cd")).trim().length() ==  0 )					valRlt += "\n카테고리는 필수 입력 값입니다";
					if(((String)saveMap.get("good_name")).trim().length() == 0 )	valRlt += "\n상품명은 입력 하셔야 합니다.";
					if( !( ((String)saveMap.get("vtax_clas_code")).trim().equals("10") ||  ((String)saveMap.get("vtax_clas_code")).trim().equals("20") ||  ((String)saveMap.get("vtax_clas_code")).trim().equals("30")))valRlt += "\n과세구분코드값이 잘못 되었습니다. ";
//					if( !(((String)saveMap.get("sale_criterion_type")).equals("10")|| ((String)saveMap.get("sale_criterion_type")).equals("20"))) valRlt += "\n판매가 산출옵션  코드값이 잘못되었습니다.";
//					if(((String)saveMap.get("sale_criterion_type")).equals("10") &&   !Pattern.matches("^[0-9]+(.[0-9]{1,2})?$", (String)saveMap.get("stan_buying_rate"))) valRlt += "\n판매가 산출옵션을 기준매익로 선택시 매익율은 필수 입니다.";
//					if(((String)saveMap.get("sale_criterion_type")).equals("20") &&   !Pattern.matches("^[0-9]*$", (String)saveMap.get("stan_buying_money"))) valRlt += "\n판매가 산출옵션을 절대매익가로  선택시 매입가는 필수 입니다. ";
//					if(!(((String)saveMap.get("isdisppastgood")).trim().equals("0") ||  ((String)saveMap.get("isdisppastgood")).trim().equals("1") )) valRlt += "\n과거상품 주문 여부를 입력 하시기 바랍니다";
					if(!( ((String)saveMap.get("isdistribute")).trim().equals("0") ||  ((String)saveMap.get("isdistribute")).trim().equals("1") ||  ((String)saveMap.get("isdistribute")).trim().equals("2") )) valRlt += "\n물량배분 여부를 입력 하시기 바랍니다";
					if( ((String)saveMap.get("good_reg_year")).trim().length() > 0 && !Pattern.matches("^[0-9]*$", (String)saveMap.get("good_reg_year")))			valRlt += "\n상품실적년도는 숫자만 입력 하셔야 합니다.";
					if(((String)saveMap.get("product_manager")).trim().length() == 0) valRlt += "\n상품담당자의 로그인 아이디를 입력 하셔야 합니다.";
				}
				
				// 공급사 코드가 있을때 (상품공급사 update)
				if(((String)saveMap.get("vendorcd")).trim().length() > 0 ) {
					if(!Pattern.matches("^[0-9]*$", (String)saveMap.get("isUse"))) valRlt += "\n상품 정상 여부에 코드값을 넣어 주세요. ";
					if(!Pattern.matches("^[0-9]*$", (String)saveMap.get("deli_mini_quan"))) valRlt += "\n최소 주문수량은 필수 값입니다. ";
					if(!Pattern.matches("^[0-9]*$", (String)saveMap.get("deli_mini_day"))) valRlt += "\n주문소요일은 필수 값입니다";
					//상품우선순위
					if((((String)saveMap.get("vendor_priority")).trim().length() > 0) && (!Pattern.matches("^[0-9]*$", (String)saveMap.get("vendor_priority")))) valRlt += "\n상품 우선 순위는 숫자 값만 넣어 주세요. ";
				}
					
				// 상품 코드 콘솔에 출력해보기
				if(idx == saveList.size()){ logger.debug("\n\n\n last good_iden_num value ["+(String)saveMap.get("good_iden_numb")+"]") ; }
				
				saveMap.put("good_iden_numb", CommonUtils.stringParseLong(  (String)saveMap.get("good_iden_numb")  , 0));
				saveMap.put("insert_user_id"	, loginUserDto.getUserId());
				
				// 카테고리 코드가 있는 경우 유효한 카테고리인지 유효성 체크 부분
				if(valRlt.length()==0 && ((String)saveMap.get("cate_cd")).trim().length() != 0){
					List<CategoryDto> CategoryDtoList =  categoryDao.selectOneCategoryByCateCd(saveMap);
					if(CategoryDtoList.isEmpty()){
						valRlt += "유효한 카테고리 코드가 아닙니다.";
					}else {
						saveMap.put("cate_id", Integer.parseInt(CategoryDtoList.get(0).getCate_Id()) );
					}
				}
				
				if(valRlt.length()==0 && ((String)saveMap.get("vendorcd")).length() > 0 ){
					String vendorid = this.getVendorCountById(saveMap);
					if(vendorid != null && vendorid.length() == 0) 	valRlt += "유효하지 않은 공급사 입니다.";
					saveMap.put("vendorid", vendorid);
				}
				
//				double getSellPrice = CommonUtils.stringParseDouble(productManageDao.selectMcGoodVendorsByGoodIdenNumByExcelUpload(saveMap), 0);
//				double getSaleUnitPrice = CommonUtils.stringParseDouble((String)saveMap.get("sale_unit_pric"), 0);//매입단가 
//				double getSellPrice = CommonUtils.stringParseDouble(productManageDao.selectDisplayGoodByGoodIdenNumByExcelUpload(saveMap), 0);//진열의 판매단가를 가져옴
				
				saveMap.put("valRlt", valRlt);
				rtnList.add(saveMap);
			}
		return rtnList;
	}

	
	/**
	 *  일괄 업로드 처리 한다. 
	 */
	public List<Map<String, Object>> uploadProdInfo (List<Map<String, Object>> saveList, LoginUserDto userInfoDto){
		List<Map<String, Object>> rtnList = new ArrayList<Map<String, Object>>();
		long ref_good_iden_numb = 0; 
		for(int idx = 0 ; idx < saveList.size(); idx ++ ) {
			Map<String, Object> saveMap =  saveList.get(idx);
			try {
				if(((String)saveMap.get("valRlt")).trim().equals("") )	{
					logger.debug("\n\n\n uploadProcess Count No.["+idx+"]");
					saveMap.put("userInfoDto", userInfoDto);
					saveMap.put("insetUserId", userInfoDto.getUserId());
					saveMap = uploadProCess(saveMap , ref_good_iden_numb );
					ref_good_iden_numb = (long)saveMap.get("good_iden_numb");
					saveMap.put("valRlt", "성공적으로 저장하였습니다!");
				}
			} catch (Exception e) {
				
				saveMap.put("rtnError", "등록시 Error 발생!");
			}
			rtnList.add(saveMap);
		}
		return rtnList;
	}
	
	/**
	 *  일괄 업로드 처리 프로세스 
	 */
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})
	public Map<String, Object> uploadProCess(Map<String, Object> saveMap ,long ref_good_iden_num) throws Exception{
		if(((String)saveMap.get("valRlt")).length() > 0 ) return saveMap;
		String rtnError = "";
		// 카테고리 Code 값이 있고, 상품명이 있고, 과세구분이 있고, 판가산출옵션이 세팅되어있다면 아래 내용을 실행한다.
		if(	((String)saveMap.get("cate_cd")).trim().length() != 0 && ((String)saveMap.get("good_name")).trim().length() != 0  && ((String)saveMap.get("vtax_clas_code")).trim().length() != 0 && ((String)saveMap.get("product_manager")).trim().length() != 0){
			//상품담당자 LOGINID로 USERID 받아오기
			String productUserId = productManageDao.selectUserId(saveMap);
			saveMap.put("product_manager", productUserId);
			saveMap.put("repre_good", "N"); // 단품이라 N
			saveMap.put("good_hist_id"	, 	seqMcProductHistoryService.getNextIntegerId() 	);
			saveMap.put("good_spec", CommonUtils.getSpecUnion(saveMap));	//규격조합
			
			if(((long)saveMap.get("good_iden_numb")) != 0 ){
				//상품코드가 있다면 수정을 실행한다.
				productManageDao.updateGood(saveMap);
			}else{
				//상품코드가 없다면 insert를 실행한다.
				saveMap.put("good_iden_numb", getGood_iden_numbSequence());
				productManageDao.insertGood(saveMap);
			}
			generalDao.updateGernal("product.mergeMcGoodSpec", saveMap);
		}
		// 상품 공급사
		if(((String)saveMap.get("vendorcd")).length() > 0 ){
			if(	((long)saveMap.get("good_iden_numb")) == 0	){
				saveMap.put("good_iden_numb", ref_good_iden_num);
			}
			if(	((long)saveMap.get("good_iden_numb"))== 0 	){
				rtnError = "상품 정보 확인후 이용하시기 바랍니다.";
			}
			if(!rtnError.equals("")) {
				saveMap.put("rtnError", rtnError);
				return saveMap; 
			}
			//상품공급사 정보를 가져온다.
			ProductVendorDto vendorDto=  (ProductVendorDto) this.getGoodVendorListByGoodIdenNumByExcelUpload(saveMap);
			if(vendorDto == null ){
				saveMap.put("vendor_priority", 0);
				this.insertProductVendorInfo(saveMap);	// 등록 
				
				// 상품 공급사 히스토리 등록 
				saveMap.put("good_hist_id"	, 	seqMcProductHistoryService.getNextIntegerId() 	);
				productAppDao.insertProductVendorHist(saveMap);
			}else {
				//  존재여부 확인  상품공급사및 매입가 정보
				// TODO : 상품공급사 테이블 수정 쿼리 엑셀 업로드 전용으로 수정
				productAppDao.updateProdVendorUnitPriceByExcelUpload(saveMap);
				// after_price 가 null 인데 매입가로 Update시키는 부분이 있어 매입금액 집어넣음. 2013-04-22 
				saveMap.put("after_price", CommonUtils.stringParseDouble((String)saveMap.get("sale_unit_pric"), 0));
				// 2_1.상품 공급사 히스토리 변경 
				saveMap.put("good_hist_id"	, 	seqMcProductHistoryService.getNextIntegerId() 	);
				productAppDao.insertProductVendorHist(saveMap);
				// 3.insert mcdispgood 매입단가 변경후 row 정보 저장
				// 4.update mcdispgood 기존 진열 내리기		
				List<ProductAppGoodDto> list =  productAppDao.selectDispIdForInsertNewDispId(saveMap);
//				
				if(vendorDto.getSale_unit_pric() != CommonUtils.stringParseLong((String)saveMap.get("sale_unit_pric"), 0)){
					for (ProductAppGoodDto productAppGoodDto : list){
						Map<String ,Object> insDispMap = new HashMap<String, Object>();
						if( !(saveMap.get("after_price") instanceof Double )){
							insDispMap.put("sale_unit_pric"		, CommonUtils.stringParseDouble((String)saveMap.get("after_price"), 0));	//	매입단가
						} else {
							insDispMap.put("sale_unit_pric"		, (Double)saveMap.get("after_price"));	//	매입단가
						}
						insDispMap.put("new_disp_good_id"	, seqMcProductDispGoodService.getNextStringId()							);	// 	dispSeq
						insDispMap.put("disp_good_id"		, productAppGoodDto.getDisp_good_id()									);	//	PastdispSeq
						// 새로운 진열정보를 select 후 insert 한다.
//						productAppDao.insertDispProductInfos(insDispMap) ;
						// 기존의 진열정보의 최종 사용여부를 0 으로 수정한다.(사용안함을 의미)
//						productAppDao.updateUnDispPlayProdVendor(insDispMap) ;
					}
				}
			}
		}
		return saveMap;
	}
	private ProductVendorDto getGoodVendorListByGoodIdenNumByExcelUpload( Map<String, Object> saveMap) {
		return productManageDao.selectGoodVendorListByGoodIdenNumByExcelUpload(saveMap);
	}

	/**
	 * 상품 seq 공급사 id 기준 상품 count 트를 반환한다.  
	 */
	public int getCateCountByCate_id(Map<String, Object> paramMap){
		return productManageDao.selectCateCountByCate_id(paramMap);
	}
	
	public String getVendorCountById(Map<String, Object> paramMap){
		return productManageDao.selectVendorCountById(paramMap);
	}

	/** 발주테이블을 조회하여 상품공급사 정보가 있는지 확인 */
	public Map<String, Object> getProdVendorOrdeCntSearch( Map<String, Object> params) {
		return (Map<String, Object>)productManageDao.selectProdVendorOrdeCntSearch(params);
	}

	public List<Map<String, Object>> validationProdDispInfo(List<Map<String, Object>> saveList, LoginUserDto loginUserDto) {
		List<Map<String, Object>> rtnList =  new ArrayList<Map<String, Object>>();
		if(saveList != null && saveList.size() > 0){
			for(int i = 1 ; i < saveList.size() ; i++){
				Map<String, Object> saveMap =  saveList.get(i);
				String[] areaTypeCdArray = saveList.get(i).get("areatypecd").toString().split(",");
				for(int j=0; j<areaTypeCdArray.length; j++){
					Map<String, Object> rtnMap = new HashMap<String, Object>();
					String valRlt = "";

					//상품코드가 유효한 상품코드인지 확인
					String goodName = productManageDao.selectMcGoodNameForProdDips(saveMap);
					if(goodName == null || goodName.isEmpty()){
						valRlt += "["+saveMap.get("good_iden_numb")+"] 유효하지 않은 상품코드입니다. ";
					}else{
						rtnMap.put("good_name", goodName);
						rtnMap.put("good_iden_numb", saveMap.get("good_iden_numb"));
					}
					
					//공급사 코드로 공급사 아이디 가져오기
					Map<String, Object> params = new HashMap<String,Object>();
					params.put("vendorcd"		, saveMap.get("vendorcd"));
					saveMap.put("vendorid"		, this.getVendorCountById(params));
					rtnMap.put("vendorid"		, this.getVendorCountById(params));
					
					//상품공급사가 유효한 공급사인지 확인
					Map<String, String> vendorMap = productManageDao.selectSmpVendorNmForProdDisp(saveMap);
					if(vendorMap == null || vendorMap.isEmpty()){
						valRlt += "["+params.get("vendorcd")+"] 유효하지 않거나 종료된 공급사의 공급사코드입니다. ";
					}else{
						rtnMap.put("vendornm"		, vendorMap.get("VENDORNM"));
						rtnMap.put("sale_unit_pric", vendorMap.get("SALE_UNIT_PRIC"));
					}
					
					//등록하려는 권역이 유효한지 확인
					String areatype = productManageDao.selectAreaCodeByNameForProdDisp2(areaTypeCdArray[j]);
					if(areatype == null || areatype.isEmpty()){
						valRlt += "["+saveMap.get("areatype")+"] 유효하지 않은 권역코드입니다. ";
					}else{
						rtnMap.put("areatypenm", areatype);
						rtnMap.put("areatypecd", areaTypeCdArray[j]);
					}
					//상품매입가
					double getSaleUnitPrice = CommonUtils.stringParseDouble(productManageDao.selectMcGoodVendorsByGoodIdenNumByExcelUpload(saveMap), 0);
					
					//상품판매단가
					double getSellPrice = CommonUtils.stringParseDouble((String)saveMap.get("sell_price"), 0);

					if(getSellPrice < getSaleUnitPrice){
						valRlt += "매입가는 판매가보다 클 수 없습니다.";
					}
					rtnMap.put("sell_price", saveMap.get("sell_price"));
					rtnMap.put("vendorcd", params.get("vendorcd"));
					rtnMap.put("valRlt", valRlt);
					rtnList.add(rtnMap);
				}
			}
		}
		return rtnList;
	}

	public Object uploadProdDispInfo(List<Map<String, Object>> list, LoginUserDto loginUserDto) {
		List<Map<String, Object>> rtnList = new ArrayList<Map<String, Object>>();
		
		for(int idx = 0 ; idx < list.size(); idx ++ ) {
			Map<String, Object> saveMap =  list.get(idx);
			saveMap.put("valRlt", saveMap.get("valRlt"));
			try {
				if(((String)saveMap.get("valRlt")).trim().equals("") )	{
					int dispGoodSequence = seqMcProductDispGoodService.getNextIntegerId();
					saveMap.put("disp_good_id", dispGoodSequence);
					saveMap.put("userid", loginUserDto.getUserId());
//					productManageDao.updateMcDispalyGoodForProdDisp(saveMap);
					productManageDao.updateMcDisplayGoodStatus2(saveMap);	//기존진열정보를 미사용으로
					productManageDao.insertMcDisplay(saveMap);	//신규진열정보를 추가함
					saveMap.put("valRlt", "성공적으로 저장하였습니다!");
				}
			} catch (Exception e) {
				
				saveMap.put("rtnError", "등록시 Error 발생!");
			}
			rtnList.add(saveMap);
		}
		return rtnList;
	}

	public List<Map<String, Object>> validationProdNoneDispInfo(List<Map<String, Object>> saveList, LoginUserDto loginUserDto) {
		List<Map<String, Object>> rtnList =  new ArrayList<Map<String, Object>>();
		
		if(saveList != null && saveList.size() > 0){
			for(int i = 1 ; i < saveList.size() ; i++){
				Map<String, Object> saveMap =  saveList.get(i);
				String valRlt = "";
				
				//상품코드가 유효한 상품코드인지 확인
				String goodName = productManageDao.selectMcGoodNameForProdDips(saveMap);
				if(goodName == null || goodName.isEmpty()){
					valRlt += "["+saveMap.get("good_iden_numb")+"] 유효하지 않은 상품코드입니다. ";
				}else{
					saveMap.put("good_name", goodName);
				}

				//공급사 코드로 공급사 아이디 가져오기
				String vendorCd = saveMap.get("vendorCd")==null ? "" : ((String)saveMap.get("vendorCd")).trim();
				Map<String, Object> params = new HashMap<String,Object>();
				params.put("vendorcd"	, vendorCd);
				if(!"".equals(vendorCd)) {
					saveMap.put("vendorId"	, this.getVendorCountById(params));
				}
				saveMap.put("vendorcd", params.get("vendorcd"));
				saveMap.put("valRlt", valRlt);
				rtnList.add(saveMap);
			}
		}
		return rtnList;
	}

	public Object uploadProdNoneDispInfo(List<Map<String, Object>> list) {
		List<Map<String, Object>> rtnList = new ArrayList<Map<String, Object>>();
		
		for(int idx = 0 ; idx < list.size(); idx ++ ) {
			Map<String, Object> saveMap =  list.get(idx);
			saveMap.put("rtnError", saveMap.get("valRlt"));
			try {
				if(((String)saveMap.get("valRlt")).trim().equals("") )	{
					productManageDao.updateMcDispalyGoodForNoneProdDisp(saveMap);
					saveMap.put("rtnError", "성공적으로 저장하였습니다!");
				}
			} catch (Exception e) {
				
				saveMap.put("rtnError", "등록시 Error 발생!");
			}
			rtnList.add(saveMap);
		}
		return rtnList;
	}
	
	/***
	 * 운영사에서 상품등록 요청시 같은 상
	 * @param params
	 * @return
	 */
	public int getProductSameCheck(Map<String, Object> params) {
		return productManageDao.selectProductSameCheck(params);
	}
	
	/**
	 * 운영사 상품등록 페이지 에서 상품명 받아 오기
	 * @param goodIdenNumb
	 * @return
	 */
	public String getGoodName(String goodIdenNumb) {
		return productManageDao.selectGoodName(goodIdenNumb);
	}

}