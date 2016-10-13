package kr.co.bitcube.product.controller;

import java.io.File;
import java.util.HashMap; 
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import kr.co.bitcube.common.dto.CodesDto;
import kr.co.bitcube.common.dto.LoginUserDto;
import kr.co.bitcube.common.service.CommonSvc;
import kr.co.bitcube.common.utils.CommonUtils;
import kr.co.bitcube.common.utils.Constances;
import kr.co.bitcube.common.utils.CustomResponse;
import kr.co.bitcube.common.utils.ExcelReader;
import kr.co.bitcube.common.utils.MultipartFileUpload;
import kr.co.bitcube.product.dto.ProductDispDto;
import kr.co.bitcube.product.service.ProductManageSvc;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

@Controller
@RequestMapping("productManage")
public class ProductManageCtl {
	private Logger logger = Logger.getLogger(getClass());
	
	@Autowired
	private ProductManageSvc productManageSvc;

	@Autowired
	private CommonSvc commonSvc;
	
	/**
	 * 상품 상세 (등록 , 상세)   
	 * goodIdenNumb 값에 따른 등록 , 상세 상태값 변경 
	 */
	@RequestMapping("productDetail.sys")
	public ModelAndView detail(
			@RequestParam(value = "good_iden_numb", defaultValue = "0") String good_iden_numb,
			@RequestParam(value = "vendorid", defaultValue = "") String vendorid,
			@RequestParam(value = "bidid", defaultValue = "") String bidid,
			@RequestParam(value = "bid_vendorid", defaultValue = "") String bid_vendorid,
			@RequestParam(value = "req_good_id", defaultValue = "") String req_good_id,
			
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		modelAndView.addObject("good_iden_numb", good_iden_numb);
		modelAndView.addObject("cate_id", productManageSvc.getCateId(good_iden_numb));
		modelAndView.addObject("vendorid", vendorid);
		modelAndView.addObject("bid_vendorid", bid_vendorid);
		modelAndView.addObject("bidid", bidid);
		modelAndView.addObject("req_good_id", req_good_id);
		modelAndView.addObject("reqGoodName", productManageSvc.getGoodName(req_good_id));
		
		modelAndView.addObject("deliAreaCodeList"	, commonSvc.getCodeList("DELI_AREA_CODE", 1)	);
		modelAndView.addObject("vTaxTypeCode"		, commonSvc.getCodeList("VTAXTYPECODE", 1)		);
		modelAndView.addObject("orderGoodsType"		, commonSvc.getCodeList("ORDERGOODSTYPE", 1)	);
		modelAndView.addObject("orderUnit"			, commonSvc.getCodeList("ORDERUNIT", 1)			);
		modelAndView.addObject("reqAppSts"			, commonSvc.getCodeList("REQAPPSTATE", 1)			);
		modelAndView.addObject("isdistributeSts"	, commonSvc.getCodeList("ISDISTRIBUTE", 1)			);
		
		
		modelAndView.setViewName("product/product/productAdmDetail");
		return modelAndView;
	}
	
	
	@RequestMapping("getProductDetailInfo.sys")
	public ModelAndView getProductDetailInfo(
			@RequestParam(value = "good_iden_numb", defaultValue = "0") String good_iden_numb,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		
		/*----------------파라미터  세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		
		try{
			params.put("good_iden_numb", good_iden_numb);
			modelAndView.addObject("productDetailInfo", productManageSvc.getProductDetailInfo(params));
		} catch(Exception e) {
			logger.error("Exception : "+e);
			custResponse.setSuccess(false);
			custResponse.setMessage("System Excute Error!....");
			custResponse.setMessage(CommonUtils.getErrSubString(e,50));	//Option(To Detail Message)
		}
		modelAndView.setViewName("jsonView");
		modelAndView.addObject(custResponse);
		return modelAndView;
	}
	
	/**
	 * 상품 마스터 상세  
	 */
	@RequestMapping("getMasterProductListJQGrid.sys")
	public ModelAndView getMasterProductListJQGrid(
			@RequestParam(value = "good_iden_numb", defaultValue = "0") String good_iden_numb,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		/*----------------파라미터  세팅------------*/
		long start = System.currentTimeMillis();
		Map<String, Object> params = new HashMap<String, Object>();
		



		
		
		params.put("good_iden_numb", CommonUtils.stringParseLong(good_iden_numb,0));
		modelAndView.addObject("list", productManageSvc.getProductDetailInfo(params));
		modelAndView.setViewName("jsonView");
		long end = System.currentTimeMillis();
//		
		return modelAndView;
	}

	/**
	 * 카테고리 진열 조직정보를 카테고리 id를 이용하여 조회한다. 
	 */
	@RequestMapping("categoryInfoListByCateIdJQGrid.sys")
	public ModelAndView categoryInfoListByCateIdJQGrid(
			@RequestParam(value = "cate_id", defaultValue = "0") String cate_id,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("cate_id", CommonUtils.stringParseInt(cate_id,0));
		
		modelAndView.addObject("list", productManageSvc.getCategoryInfoListByCateId(params));
		modelAndView.setViewName("jsonView");
		return modelAndView;
	}
	
	/**
	 * 상품 공급사 상세 정보 
	 */
	@RequestMapping("getGoodVendorListByGoodIdenNumJQGrid.sys")
	public ModelAndView getGoodVendorListByGoodIdenNumJQGrid( 
			@RequestParam(value = "sidx", defaultValue = "") String sidx,
			@RequestParam(value = "sord", defaultValue = "") String sord,
			@RequestParam(value = "good_iden_numb", defaultValue = "0") String good_iden_numb,
			@RequestParam(value = "vendorid", defaultValue = "") String vendorid,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		
		/*----------------조회조건 세팅------------*/
		long start = System.currentTimeMillis();
		
		Map<String, Object> params = new HashMap<String, Object>();
		
		params.put("good_iden_numb"	, CommonUtils.stringParseLong(good_iden_numb,0));
		params.put("vendorid"		, vendorid		);
		
		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
		
		modelAndView.setViewName("jsonView");
		modelAndView.addObject("list", productManageSvc.getGoodVendorListByGoodIdenNum(params));
		long end = System.currentTimeMillis();
//		
		return modelAndView;
	}
	
	/**
	 * 상품 공급사 상세 정보 
	 */
	@RequestMapping("getVendorAutionInfoForInsProduct.sys")
	public ModelAndView getVendorAutionInfoForInsProduct(
			@RequestParam(value = "good_iden_numb"	, defaultValue = "0")	String good_iden_numb,
			@RequestParam(value = "bidid"			, defaultValue = "0")	String bidid,
			@RequestParam(value = "bid_vendorid"	, defaultValue = "")	String bid_vendorid,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		try{
			params.put("good_iden_numb"		, good_iden_numb);
			params.put("bidid"				, CommonUtils.stringParseInt(bidid, 0));
			params.put("bid_vendorid"		, bid_vendorid		);
			modelAndView.addObject("addProdVendorInfo", productManageSvc.getVendorAutionInfoForInsProduct(params));
		} catch(Exception e) {
			logger.error("Exception : "+e);
			custResponse.setSuccess(false);
			custResponse.setMessage("System Excute Error!....");
			custResponse.setMessage(CommonUtils.getErrSubString(e,50));	//Option(To Detail Message)
		}
		
		modelAndView.setViewName("jsonView");
		modelAndView.addObject(custResponse);
		return modelAndView;
	}
	
	
	
	/**
	 * 상품 공급사 정보 삭제  
	 */
	@RequestMapping("prodVendorTransGrid.sys")
	public ModelAndView prodVendorTransGrid(
			@RequestParam(value = "oper", required = true) String oper,
			@RequestParam(value = "good_iden_numb", defaultValue = "0") String good_iden_numb,
			@RequestParam(value = "vendorid", defaultValue = "") String vendorid,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		
		/*----------------파라미터  세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		
		try{
			params.put("good_iden_numb", CommonUtils.stringParseLong(good_iden_numb,0));
			params.put("vendorid", vendorid);
			
			logger.debug("prodVendorTransGrid Method parma oper value ["+oper+"]");
			
			if(oper.equals("del")){
				productManageSvc.delProdVendorTransGrid(params);
			}
		} catch(Exception e) {
			logger.error("Exception : "+e);
			custResponse.setSuccess(false);
			custResponse.setMessage("System Excute Error!....");
			custResponse.setMessage(CommonUtils.getErrSubString(e,50));	//Option(To Detail Message)
		}
		modelAndView.setViewName("jsonView");
		modelAndView.addObject(custResponse);
		return modelAndView;
	}
	
	
	/** 상품공급사에 관련한 발주정보가 있는지 확인 */
	@RequestMapping("prodVendorOrdeCntSearch.sys")
	public ModelAndView prodVendorOrdeCntSearch(
			@RequestParam(value = "vendorId", required=true) String vendorId,		// 공급사 ID
			@RequestParam(value = "goodIdenNumb", required=true) String goodIdenNumb,		// 상품 ID
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		Map<String,Object> params = new HashMap<String,Object>();
		params.put("vendorId", vendorId);
		params.put("goodIdenNumb", goodIdenNumb);
		Map<String,Object> orderCnt = productManageSvc.getProdVendorOrdeCntSearch(params);
        modelAndView = new ModelAndView("jsonView");
        modelAndView.addObject("orderCnt", orderCnt);
		return modelAndView;
	}
	
	
	/**
	 * 상품 공급사 정보 삭제  
	 */
	@RequestMapping("prodyctInfoTransGrid.sys")
	public ModelAndView prodyctInfoTransGrid(
			@RequestParam(value = "isModify"		,required = true) String isModify,					// 수정여부 
			@RequestParam(value = "cate_id"			,required = true) String cate_id,
			@RequestParam(value = "good_iden_numb"	,required = true) String good_iden_numb,
			@RequestParam(value = "good_name"		,required = true) String good_name,
			@RequestParam(value = "vtax_clas_code"	,required = true) String vtax_clas_code,			// 과세구분
			@RequestParam(value = "sale_criterion_type",required = true) String sale_criterion_type, 	// 판가산출옵션
			@RequestParam(value = "stan_buying_rate",required = false) String stan_buying_rate,			// 기준매입률
			@RequestParam(value = "stan_buying_money",required = false) String stan_buying_money,		// 기준판매가 
			@RequestParam(value = "isdistribute"	,required = true) String isdistribute,				// 물량배분여부 
			@RequestParam(value = "isdisppastgood"	,required = true) String isdisppastgood,			// 과거상품 진열여부
			@RequestParam(value = "vendorid_array[]",required = false) String[] vendorid_array,			// 공급사id
			@RequestParam(value = "sale_unit_pric_array[]"	,required = false) String[] sale_unit_pric_array    ,			// 매입단가
			@RequestParam(value = "orgsale_unit_pric_array[]"	,required = false) String[] orgsale_unit_pric_array    ,	// 매입단가
			@RequestParam(value = "good_st_spec_desc_array[]"	,required = false) String[] good_st_spec_desc_array    ,	// 표준규격
			@RequestParam(value = "good_spec_desc_array[]"	,required = false) String[] good_spec_desc_array    ,			// 규격
			@RequestParam(value = "orde_clas_code_array[]"	,required = false) String[] orde_clas_code_array    ,			// 단위
			@RequestParam(value = "deli_mini_day_array[]"	,required = false) String[] deli_mini_day_array     ,			// 납품소요일수
			@RequestParam(value = "deli_mini_quan_array[]"	,required = false) String[] deli_mini_quan_array    ,			// 최소구매수량
			@RequestParam(value = "make_comp_name_array[]"	,required = false) String[] make_comp_name_array    ,			// 제조사
			@RequestParam(value = "original_img_path_array[]"	,required = false) String[] original_img_path_array ,		// 대표이미지원본
			@RequestParam(value = "large_img_path_array[]"	,required = false) String[] large_img_path_array    ,			// 이미지
			@RequestParam(value = "middle_img_path_array[]"	,required = false) String[] middle_img_path_array   ,			// 이미지
			@RequestParam(value = "small_img_path_array[]"	,required = false) String[] small_img_path_array    ,			// 이미지
			@RequestParam(value = "good_same_word_array[]"	,required = false) String[] good_same_word_array    ,			// 동의어
			@RequestParam(value = "good_desc_array[]"	,required = false) String[] good_desc_array         ,				// 상품설명
			@RequestParam(value = "issub_ontract_array[]"	,required = false) String[] issub_ontract_array     ,			// 하도급법대상여부
			@RequestParam(value = "good_clas_code_array[]"	,required = false) String[] good_clas_code_array    ,			// 상품구분
			@RequestParam(value = "good_inventory_cnt_array[]"	,required = false) String[] good_inventory_cnt_array,		// good_inventory_cnt
			@RequestParam(value = "bidid_array[]"	,required = false) String[] bidid_array,								// 입찰ID
			@RequestParam(value = "bid_vendorid_array[]"	,required = false) String[] bid_vendorid_array,					// 입찰공급사ID
			@RequestParam(value = "req_good_id_array[]"	,required = false) String[] req_good_id_array,						// 신규품목 요청 
			@RequestParam(value = "distri_rate_array[]"	,required = false) String[] distri_rate_array,						// 물량배분 %
			@RequestParam(value = "good_reg_year_array[]"	,required = false) String[] good_reg_year,						// 상품등록일
			@RequestParam(value = "vendor_priority_array[]"	, defaultValue="0") String[] vendor_priority,					// 상품우선순위
			@RequestParam(value = "the_day_post_array[]"	, defaultValue="0") String[] the_day_post_array,				// 당일발송
			@RequestParam(value = "product_manager"	, required = false) String product_manager,							// 상품담당자
			@RequestParam(value = "is_add_good"	, defaultValue="0") String is_add_good,							// 추가상품여부
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		logger.debug("^^^^^^^^^^^^^^^^^^");
		logger.debug("the_day_post_array : "+the_day_post_array);
		logger.debug("^^^^^^^^^^^^^^^^^^");
		
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		LoginUserDto loginUserDto = null; 
		Map<String, Object> params = new HashMap<String, Object>();
		
		try{
			loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
			
			params.put("isModify",isModify);                        
			params.put("cate_id",cate_id);                          
			params.put("good_iden_numb",CommonUtils.stringParseLong(good_iden_numb,0));            
			params.put("good_name",good_name);                      
			params.put("vtax_clas_code",vtax_clas_code);            
			params.put("sale_criterion_type", sale_criterion_type);  
			params.put("stan_buying_rate",  CommonUtils.stringParseDouble(stan_buying_rate,0));        
			params.put("stan_buying_money",CommonUtils.stringParseDouble(stan_buying_money,0));      
			params.put("isdistribute",isdistribute);         
			params.put("isdisppastgood",isdisppastgood);
			params.put("insert_user_id",loginUserDto.getUserId());
			
			params.put("vendorid_array"			,vendorid_array);
			params.put("sale_unit_pric_array"	,sale_unit_pric_array);
			params.put("orgsale_unit_pric_array",orgsale_unit_pric_array);
			params.put("good_st_spec_desc_array",good_st_spec_desc_array);
			params.put("good_spec_desc_array"	,good_spec_desc_array);
			params.put("orde_clas_code_array"	,orde_clas_code_array);
			params.put("deli_mini_day_array"	,deli_mini_day_array);
			params.put("deli_mini_quan_array"	,deli_mini_quan_array);
			params.put("make_comp_name_array"	,make_comp_name_array);
			params.put("original_img_path_array",original_img_path_array);
			params.put("large_img_path_array"	,large_img_path_array);
			params.put("middle_img_path_array"	,middle_img_path_array);
			params.put("small_img_path_array"	,small_img_path_array);
			params.put("good_same_word_array"	,good_same_word_array);
			params.put("good_desc_array"		,good_desc_array);
			params.put("good_reg_year"			,good_reg_year);
			params.put("vendor_priority"		,vendor_priority);
			params.put("the_day_post"			,the_day_post_array);
			// 상세 설명 추가시 하도급 대상여부 컬럼 값이 사라짐 이에 따라 디폴트 설정으로 추가됨
//			String[] vIssub_ontract_array = null;
//			if(issub_ontract_array != null ){
//				vIssub_ontract_array = new String[issub_ontract_array.length];
//				for (int cnt = 0; cnt < issub_ontract_array.length  ; cnt ++) {
//					vIssub_ontract_array[cnt] = issub_ontract_array[cnt];
//				}
//			}
//			params.put("issub_ontract_array"	,vIssub_ontract_array);
			
			
			params.put("issub_ontract_array"	,issub_ontract_array);
			params.put("good_clas_code_array"	,good_clas_code_array);
			params.put("good_inventory_cnt_array",good_inventory_cnt_array);
			params.put("bidid_array"			, bidid_array );
			params.put("bid_vendorid_array"		, bid_vendorid_array);
			params.put("req_good_id_array"		, req_good_id_array);
			params.put("distri_rate_array"		, distri_rate_array);
			params.put("reqGoodId", req_good_id_array[0]);
			
			//상품담당자
			params.put("product_manager", product_manager);
			params.put("is_add_good", is_add_good);	//추가상품여부
			
			if("".equals(good_iden_numb) || "0".equals(good_iden_numb)){
				if(!"".equals(req_good_id_array[0].trim()) && !"0".equals(req_good_id_array[0].trim())){
					logger.debug(req_good_id_array[0].trim()+"!!!!!!!!!!!!!!");
					int goodIdenNum = productManageSvc.getProductSameCheck(params);
					if (goodIdenNum > 0){
						modelAndView.addObject("masSuccess","이미 등록된 상품입니다.");
					}else{
						modelAndView.addObject("good_iden_numb", productManageSvc.setProductInfo(params , modelAndView));
						modelAndView.addObject("masSuccess","상품이 등록 및 수정 되었습니다.");
					}
				}else{
					modelAndView.addObject("good_iden_numb", productManageSvc.setProductInfo(params , modelAndView));
					modelAndView.addObject("masSuccess","상품이 등록 및 수정 되었습니다.");
				}
			}else{
				modelAndView.addObject("good_iden_numb", productManageSvc.setProductInfo(params , modelAndView));
				modelAndView.addObject("masSuccess","상품이 등록 및 수정 되었습니다.");
			}
			
			
			
		} catch(Exception e) {
			
			logger.error("Exception : "+e);
			custResponse.setSuccess(false);
			custResponse.setMessage("System Excute Error!....");
			custResponse.setMessage(CommonUtils.getErrSubString(e,50));	//Option(To Detail Message)
		}
		modelAndView.setViewName("jsonView");
		modelAndView.addObject(custResponse);
		return modelAndView;
	}
	
	
	/**
	 * 상품 진열 정보를 조회한다.  
	 */
	@RequestMapping("getDisplayGoodListJQGrid.sys")
	public ModelAndView getDisplayGoodListJQGrid(
			@RequestParam(value = "sidx", defaultValue = "DISP_GOOD_ID") 	String sidx,
			@RequestParam(value = "sord", defaultValue = "DESC") 			String sord,
			@RequestParam(value = "good_iden_numb", defaultValue = "0") 	String good_iden_numb,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("good_iden_numb", CommonUtils.stringParseLong(good_iden_numb,0));
		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
		
		modelAndView.setViewName("jsonView");
		modelAndView.addObject("list", productManageSvc.getDisplayGoodList(params));
		
		return modelAndView;
	}
	
	/**
	 * 상품 진열 정보를 삭제  
	 */
	@RequestMapping("prodSalePriceDelTransGrid.sys")
	public ModelAndView prodSalePriceDelTransGrid(
			@RequestParam(value = "disp_good_id", defaultValue = "0") int disp_good_id,
			@RequestParam(value = "disp_good_id_array[]"	,required = false) String[] disp_good_id_array,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		
		/*----------------파라미터  세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		
		LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		try{
			params.put("tranUserId", loginUserDto.getUserId());//변경자ID
			if(disp_good_id != 0) {
				params.put("disp_good_id", disp_good_id);
				productManageSvc.delProdSalePriceDel(params, modelAndView);
			} else if (disp_good_id_array!=null && disp_good_id_array.length>0) {
				productManageSvc.delProdSalePriceArrayDel(disp_good_id_array, modelAndView, params);
			} else {
				custResponse.setSuccess(false);
				custResponse.setMessage("선택된 진열이 존재하지 않습니다.");
			}
		} catch(Exception e) {
			logger.error("Exception : "+e);
			custResponse.setSuccess(false);
			custResponse.setMessage("System Excute Error!....");
			custResponse.setMessage(CommonUtils.getErrSubString(e,50));	//Option(To Detail Message)
		}
		modelAndView.setViewName("jsonView");
		modelAndView.addObject(custResponse);
		return modelAndView;
	}
	
	/**
	 * 상품진열 정보를 저장한다
	 */
	@RequestMapping("displayInsGoodTrans.sys")
	public ModelAndView displayInsGoodTrans(
			@RequestParam(value = "good_iden_numb"      , defaultValue = "0"  ) String good_iden_numb,  
			@RequestParam(value = "areatype"      		, defaultValue = "0"  ) String areatype,  
			@RequestParam(value = "groupid_array[]"     , defaultValue = "0"  ) String[] groupid,            
			@RequestParam(value = "clientid_array[]"    , defaultValue = "0"  ) String[] clientid,           
			@RequestParam(value = "branchid_array[]"    , defaultValue = "0"  ) String[] branchid,
			@RequestParam(value = "vendorid"            , defaultValue = "0"  ) String vendorid,
			@RequestParam(value = "cont_from_date"      , defaultValue = ""   ) String cont_from_date,     
			@RequestParam(value = "cont_to_date"        , defaultValue = ""   ) String cont_to_date,       
			@RequestParam(value = "sell_price"          , defaultValue = ""   ) String sell_price,         
			@RequestParam(value = "sale_unit_pric"      , defaultValue = ""   ) String sale_unit_pric,     
			@RequestParam(value = "cust_good_iden_numb" , defaultValue = ""   ) String cust_good_iden_numb,
			           
			ModelAndView modelAndView, HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		/*----------------저장값 세팅------------*/
		LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		Map<String,Object> saveMap = new HashMap<String,Object>();
		
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		try {
			
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("good_iden_numb", CommonUtils.stringParseLong(good_iden_numb,0));
			params.put("areatype"			, areatype );
			params.put("groupid_array"		, groupid  );
			params.put("clientid_array"		, clientid );
			params.put("branchid_array"		, branchid );
			params.put("vendorid"			, vendorid );
			params.put("cont_from_date"		, cont_from_date );
			params.put("cont_to_date"		, cont_to_date   );
			params.put("sell_price"			, sell_price     );
			params.put("sale_unit_pric"		, sale_unit_pric );
			params.put("cust_good_iden_numb", cust_good_iden_numb );
			params.put("insertUserId", loginUserDto.getUserId());
			
			logger.debug("displayGoodTrans Method params Info \n"+saveMap);
			productManageSvc.insertMcDispGoodTranction(params);
			
			
		} catch(Exception e) {
			
			logger.error("Exception : "+e);
			custResponse.setSuccess(false);
			custResponse.setMessage("System Excute Error!....");
			custResponse.setMessage(CommonUtils.getErrSubString(e,50));	//Option(To Detail Message)
		}
		
		modelAndView.setViewName("jsonView");
		modelAndView.addObject(custResponse);
		return modelAndView;
	}
	
	/**
	 * 상품 진열 정보를 수정 
	 */
	@RequestMapping("displayGoodTrans.sys")
	public ModelAndView displayGoodTrans(
			@RequestParam(value = "disp_good_id"        , defaultValue = "0"  ) String disp_good_id,       
			@RequestParam(value = "good_iden_numb"      , defaultValue = "0"  ) String good_iden_numb,  
			@RequestParam(value = "areatype"      		, defaultValue = "0"  ) String areatype,  
			@RequestParam(value = "groupid"             , defaultValue = "0"  ) String groupid,            
			@RequestParam(value = "clientid"            , defaultValue = "0"  ) String clientid,           
			@RequestParam(value = "branchid"            , defaultValue = "0"  ) String branchid,           
			@RequestParam(value = "cont_from_date"      , defaultValue = ""   ) String cont_from_date,     
			@RequestParam(value = "cont_to_date"        , defaultValue = ""   ) String cont_to_date,       
			@RequestParam(value = "ispast_sell_flag"    , defaultValue = "1"  ) String ispast_sell_flag,   
			@RequestParam(value = "ref_good_seq"        , defaultValue = "0"  ) String ref_good_seq,       
			@RequestParam(value = "sell_price"          , defaultValue = ""   ) String sell_price,         
			@RequestParam(value = "before_price"        , defaultValue = ""   ) String before_price,       
			@RequestParam(value = "sale_unit_pric"      , defaultValue = ""   ) String sale_unit_pric,     
			@RequestParam(value = "cust_good_iden_numb" , defaultValue = ""   ) String cust_good_iden_numb,
			@RequestParam(value = "vendorid"            , defaultValue = ""   ) String vendorid,           
			ModelAndView modelAndView, HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		/*----------------저장값 세팅------------*/
		LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		Map<String,Object> saveMap = new HashMap<String,Object>();
		
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		try {
			
			saveMap.put("disp_good_id"	,CommonUtils.stringParseInt(disp_good_id,0));
			saveMap.put("good_iden_numb",CommonUtils.stringParseLong(good_iden_numb,0));
			saveMap.put("areatype"		,areatype);
			
			if(groupid.length() == 0 ) groupid		= "0";   
			if(clientid.length() == 0 ) clientid	= "0";
			if(branchid.length() == 0 ) branchid	= "0";
			
			saveMap.put("groupid"		,groupid);
			saveMap.put("clientid"		,clientid);
			saveMap.put("branchid"		,branchid);
			
			saveMap.put("cont_from_date",cont_from_date);
			saveMap.put("cont_to_date"	,cont_to_date);
			saveMap.put("ref_good_seq"	,CommonUtils.stringParseInt(ref_good_seq,0));
			saveMap.put("sell_price"	,CommonUtils.stringParseDouble(sell_price,0));
			saveMap.put("before_price"	,CommonUtils.stringParseDouble(before_price,0));
			saveMap.put("sale_unit_pric",CommonUtils.stringParseDouble(sale_unit_pric,0));
			saveMap.put("cust_good_iden_numb",cust_good_iden_numb);
			saveMap.put("vendorid"		,vendorid);
			saveMap.put("ispast_sell_flag", ispast_sell_flag);
			saveMap.put("change_reason", "");
			saveMap.put("insertUserId", loginUserDto.getUserId());
			saveMap.put("tranUserId", loginUserDto.getUserId());
			
			logger.debug("displayGoodTrans Method params Info \n"+saveMap);
			productManageSvc.setMcDispGoodTranction(saveMap, modelAndView);
			
			//productManageSvc.setDispProductAddRow(saveMap, modelAndView);
			
		} catch(Exception e) {
			
			logger.error("Exception : "+e);
			custResponse.setSuccess(false);
			custResponse.setMessage("System Excute Error!....");
			custResponse.setMessage(CommonUtils.getErrSubString(e,50));	//Option(To Detail Message)
		}
		
		modelAndView.setViewName("jsonView");
		modelAndView.addObject(custResponse);
		return modelAndView;
	}
	
	
	/**
	 *  상품 진열에 따른 과거 히스토리 내역을 보여준다. 
	 */
	@RequestMapping("displayGoodHistListJQGrid.sys")
	public ModelAndView displayGoodHistListJQGrid(
			@RequestParam(value = "sidx", defaultValue = "DISP_GOOD_ID") String sidx,
			@RequestParam(value = "sord", defaultValue = "DESC") String sord,
			@RequestParam(value = "disp_good_id", defaultValue = "0") String disp_good_id,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		/*----------------조회조건 세팅------------*/
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("disp_good_id", CommonUtils.stringParseInt(disp_good_id, 0));
		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
		
        /*----------------조회------------*/
		List<ProductDispDto> list = productManageSvc.getDisplayGoodHistList(params);

		modelAndView = new ModelAndView("jsonView");
		modelAndView.setViewName("jsonView");
		modelAndView.addObject("productSalePriceHistDivList", list);
		return modelAndView;
	}
	
	/**
	 * 과거상품 판매여부를 업데이트 한다.  
	 */
	@RequestMapping("displayGoodUpdateTrans.sys")
	public ModelAndView displayGoodUpdateTrans(
			@RequestParam(value = "disp_good_id_array[]") String[] disp_good_id_array,
			@RequestParam(value = "ispast_sell_flag_array[]") String[] ispast_sell_flag_array,
			ModelAndView modelAndView, HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		/*----------------저장값 세팅------------*/
		Map<String,Object> params = new HashMap<String,Object>();
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		try {
			params.put("disp_good_id_array", disp_good_id_array);
			params.put("ispast_sell_flag_array", ispast_sell_flag_array);
			productManageSvc.displayGoodUpdateTrans(params); 
		} catch(Exception e) {
			logger.error("Exception : "+e);
			custResponse.setSuccess(false);
			custResponse.setMessage("System Excute Error!....");
			custResponse.setMessage(CommonUtils.getErrSubString(e,50));	//Option(To Detail Message)
		}
		
		modelAndView.setViewName("jsonView");
		modelAndView.addObject(custResponse);
		return modelAndView;
	}

	/**
	 * 공급사상품등록요청 
	 */
	@RequestMapping("venProductRegist.sys")
	public ModelAndView venProductRegist(
			@RequestParam(value = "req_good_id", defaultValue = "") String req_good_id,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		modelAndView.addObject("req_good_id", req_good_id);
		
		modelAndView.addObject("orderGoodsType"		, commonSvc.getCodeList("ORDERGOODSTYPE", 1)	);
		modelAndView.addObject("orderUnit"			, commonSvc.getCodeList("ORDERUNIT", 1)			);
		modelAndView.addObject("deliAreaCodeList"	, commonSvc.getCodeList("DELI_AREA_CODE", 1)	);
		modelAndView.addObject("reqAppSts"			, commonSvc.getCodeList("REQAPPSTATE", 1)			);
		modelAndView.setViewName("product/product/venProductRegist");
		return modelAndView;
	}
	
	/**
	 * 상품등록요청   
	 */
	@RequestMapping("getReqProductDetailInfoJQGrid.sys")
	public ModelAndView getReqProductDetailInfoJQGrid(
			@RequestParam(value = "req_good_id", defaultValue = "") String req_good_id,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		/*----------------파라미터  세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		
		params.put("req_good_id", CommonUtils.stringParseLong(req_good_id, 0));
		modelAndView.addObject("list", productManageSvc.getReqProductDetailInfo(params));
		modelAndView.setViewName("jsonView");
		return modelAndView;
	}
	
	
	
	@RequestMapping("vendorReqProductInfoTransGrid.sys")
	public ModelAndView vendorReqProductInfoTransGrid(
			@RequestParam(value = "oper", defaultValue = "")         		String oper        ,
			@RequestParam(value = "req_good_id", defaultValue = "")         String req_good_id        , 
			@RequestParam(value = "good_iden_numb", defaultValue = "")      String good_iden_numb     , 
			@RequestParam(value = "vendorid", defaultValue = "")            String vendorid           , 
			@RequestParam(value = "good_name", defaultValue = "")           String good_name          , 
			@RequestParam(value = "sale_unit_pric", defaultValue = "")      String sale_unit_pric     , 
			@RequestParam(value = "good_st_spec_desc", defaultValue = "")   String good_st_spec_desc  , 
			@RequestParam(value = "good_spec_desc", defaultValue = "")      String good_spec_desc     ,
			@RequestParam(value = "orde_clas_code", defaultValue = "")      String orde_clas_code     , 
			@RequestParam(value = "deli_mini_day", defaultValue = "")       String deli_mini_day      , 
			@RequestParam(value = "deli_mini_quan", defaultValue = "")      String deli_mini_quan     , 
			@RequestParam(value = "make_comp_name", defaultValue = "")      String make_comp_name     , 
			@RequestParam(value = "good_same_word", defaultValue = "")      String good_same_word     , 
			@RequestParam(value = "original_img_path", defaultValue = "")   String original_img_path  , 
			@RequestParam(value = "large_img_path", defaultValue = "")      String large_img_path     , 
			@RequestParam(value = "middle_img_path", defaultValue = "")     String middle_img_path    , 
			@RequestParam(value = "small_img_path", defaultValue = "")      String small_img_path     , 
			@RequestParam(value = "good_desc", defaultValue = "")           String good_desc          , 
			@RequestParam(value = "good_clas_code", defaultValue = "")      String good_clas_code     , 
			@RequestParam(value = "good_inventory_cnt", defaultValue = "")  String good_inventory_cnt , 
			@RequestParam(value = "insert_user_id", defaultValue = "")      String insert_user_id     , 
			@RequestParam(value = "app_sts", defaultValue = "")             String app_sts            , 
			@RequestParam(value = "admin_user_id", defaultValue = "")       String admin_user_id      , 
			@RequestParam(value = "create_good_date", defaultValue = "")    String create_good_date   , 
			
			HttpServletRequest request, ModelAndView modelAndView, ModelMap paramMap) throws Exception {
		
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		LoginUserDto loginUserDto = null; 
		Map<String, Object> params = new HashMap<String, Object>();
		
		try{
			loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
			
			params.put("oper"				,	oper			);
			params.put("req_good_id"		,	req_good_id		);
			params.put("good_iden_numb"		,	good_iden_numb	);
			params.put("vendorid"			,	vendorid		);
			params.put("good_name"			,	good_name		);
			params.put("sale_unit_pric"		,	CommonUtils.stringParseDouble(sale_unit_pric,0));
			params.put("good_st_spec_desc"	,	good_st_spec_desc);
			params.put("good_spec_desc"		,	CommonUtils.getSpecUnion(paramMap)	);
			params.put("orde_clas_code"		,	orde_clas_code	);
			params.put("deli_mini_day"		,	deli_mini_day	);
			params.put("deli_mini_quan"		,	CommonUtils.stringParseInt(deli_mini_quan,0));
			params.put("make_comp_name"		,	make_comp_name	);
			params.put("good_same_word"		,	good_same_word	);
			params.put("original_img_path"	,	original_img_path);
			params.put("large_img_path"		,	large_img_path	);
			params.put("middle_img_path"	,	middle_img_path	);
			params.put("small_img_path"		,	small_img_path	);
			params.put("good_desc"			,	good_desc		);
			params.put("good_clas_code"		,	good_clas_code  );
			params.put("good_inventory_cnt"	,	CommonUtils.stringParseLong(good_inventory_cnt,0));
			params.put("insert_user_id"		,	loginUserDto.getUserId()	);
			params.put("app_sts"			,	app_sts						);
			params.put("admin_user_id"		,	admin_user_id				);
			params.put("create_good_date"	,	create_good_date			);
			params.put("paramMap", paramMap);	//규격들
			
			productManageSvc.setVendorReqProductInfoTransGrid(params);
			
			
		} catch(Exception e) {
			
			logger.error("Exception : "+e);
			custResponse.setSuccess(false);
			custResponse.setMessage("System Excute Error!....");
			custResponse.setMessage(CommonUtils.getErrSubString(e,50));	//Option(To Detail Message)
		}
		
		modelAndView.setViewName("jsonView");
		modelAndView.addObject(custResponse);
		return modelAndView;
	}
	
	
	@RequestMapping("adminReqProductInfoTransGrid.sys")
	public ModelAndView adminReqProductInfoTransGrid(
			@RequestParam(value = "oper", defaultValue = "")         		String oper        		,
			@RequestParam(value = "req_good_id", defaultValue = "")         String req_good_id 		, 
			@RequestParam(value = "good_iden_numb", defaultValue = "")      String good_iden_numb   ,
			@RequestParam(value = "cancel_reason", defaultValue = "")       String cancel_reason    ,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		LoginUserDto loginUserDto = null; 
		Map<String, Object> params = new HashMap<String, Object>();
		
		try{
			loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
			
			params.put("oper"				,	oper			);
			params.put("req_good_id"		,	req_good_id		);
			params.put("app_user_id"		, 	loginUserDto.getUserId());
			params.put("good_iden_numb"		,	good_iden_numb	);
			params.put("cancel_reason"		,	cancel_reason	);
			
			productManageSvc.setAdminReqProductInfoTransGrid(params);
			
			
		} catch(Exception e) {
			
			logger.error("Exception : "+e);
			custResponse.setSuccess(false);
			custResponse.setMessage("System Excute Error!....");
			custResponse.setMessage(CommonUtils.getErrSubString(e,50));	//Option(To Detail Message)
		}
		
		modelAndView.setViewName("jsonView");
		modelAndView.addObject(custResponse);
		return modelAndView;
	}
	
	/**
	 * 공급사 상품 상세
	 */
	@RequestMapping("vendorProductDetailInfo.sys")
	public ModelAndView vendorProductDetailInfo(
			@RequestParam(value = "good_iden_numb", defaultValue = "") String good_iden_numb,
			@RequestParam(value = "vendorid", defaultValue = "") String vendorid,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		modelAndView.addObject("good_iden_numb"	, good_iden_numb);
		modelAndView.addObject("vendorid"		, vendorid		);
		modelAndView.setViewName("product/product/venProductDetail");
		return modelAndView;
	}
	
	
	/**
	 * 공급사 상품 상세
	 */
	@RequestMapping("setProductVendorInfoExistSaleUnitPrice.sys")
	public ModelAndView setProductVendorInfoExistSaleUnitPrice(
			@RequestParam(value = "good_iden_numb"     ,defaultValue = "") String good_iden_numb	  ,// 상품코드            
			@RequestParam(value = "vendorid"           ,defaultValue = "") String vendorid      	  ,// 공급사ID            
			@RequestParam(value = "sale_unit_pric"     ,defaultValue = "") String sale_unit_pric	  ,// 매입단가            
			@RequestParam(value = "good_st_spec_desc"  ,defaultValue = "") String good_st_spec_desc	  ,// 규격                
			@RequestParam(value = "good_spec_desc"     ,defaultValue = "") String good_spec_desc	  ,// 규격
			@RequestParam(value = "orde_clas_code"     ,defaultValue = "") String orde_clas_code	  ,// 단위                
			@RequestParam(value = "deli_mini_day"      ,defaultValue = "") String deli_mini_day	    ,// 납품소요일수        
			@RequestParam(value = "deli_mini_quan"     ,defaultValue = "") String deli_mini_quan	  ,// 최소구매수량        
			@RequestParam(value = "make_comp_name"     ,defaultValue = "") String make_comp_name	  ,// 제조사              
			@RequestParam(value = "original_img_path"  ,defaultValue = "") String original_img_path	,// 대표이미지원본      
			@RequestParam(value = "large_img_path"     ,defaultValue = "") String large_img_path	  ,// 대표이미지대        
			@RequestParam(value = "middle_img_path"    ,defaultValue = "") String middle_img_path	  ,// 대표이미지중        
			@RequestParam(value = "small_img_path"     ,defaultValue = "") String small_img_path	  ,// 대표이미지소        
			@RequestParam(value = "good_same_word"     ,defaultValue = "") String good_same_word	  ,// 동의어              
			@RequestParam(value = "isexistgooddesc"    ,defaultValue = "") String isexistgooddesc   ,// 상품설명 등록여부   
			@RequestParam(value = "good_desc"          ,defaultValue = "") String good_desc	        ,// 상품설명            
			@RequestParam(value = "good_clas_code"     ,defaultValue = "") String good_clas_code	  ,// 상품구분            
			@RequestParam(value = "good_inventory_cnt" ,defaultValue = "") String good_inventory_cnt,// 재고수량    
			@RequestParam(value = "the_day_post" ,defaultValue = "") String the_day_post,// 재고수량    
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		LoginUserDto loginUserDto = null; 
		Map<String, Object> params = new HashMap<String, Object>();
		
		try{
			loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
			
			params.put("good_iden_numb"		,	good_iden_numb  );
			params.put("vendorid"			,	vendorid        );
			params.put("sale_unit_pric"		,	sale_unit_pric  );
			params.put("good_st_spec_desc"	,	good_st_spec_desc);
			params.put("good_spec_desc"		,	good_spec_desc  );
			params.put("orde_clas_code"		,	orde_clas_code  );
			params.put("deli_mini_day"		,	deli_mini_day   );
			params.put("deli_mini_quan"		,	deli_mini_quan  );
			params.put("make_comp_name"		,	make_comp_name  );
			params.put("original_img_path"	,	original_img_path);
			params.put("large_img_path"		,	large_img_path  );
			params.put("middle_img_path"	,	middle_img_path );
			params.put("small_img_path"		,	small_img_path  );
			params.put("good_same_word"		,	good_same_word  );
			params.put("isexistgooddesc"	,	isexistgooddesc );
			params.put("good_desc"			,	good_desc       );
			params.put("good_clas_code"		,	good_clas_code  );
			params.put("good_inventory_cnt"	,	CommonUtils.stringParseLong(good_inventory_cnt,0));
			params.put("insert_user_id"     ,   loginUserDto.getUserId());
			params.put("the_day_post"       ,   the_day_post);
			
			productManageSvc.setProductVendorInfoExistSaleUnitPrice(params);
			
		} catch(Exception e) {
			
			logger.error("Exception : "+e);
			custResponse.setSuccess(false);
			custResponse.setMessage("System Excute Error!....");
			custResponse.setMessage(CommonUtils.getErrSubString(e,50));	//Option(To Detail Message)
		}
		
		modelAndView.setViewName("jsonView");
		modelAndView.addObject(custResponse);
		return modelAndView;
	}
	
	/**
	 * 상품 공급사 상세 정보   공급사 사용자 상세 
	 */
	@RequestMapping("getGoodVendorListForVendorJQGrid.sys")
	public ModelAndView getGoodVendorListForVendorJQGrid(
			@RequestParam(value = "sidx", defaultValue = "") String sidx,
			@RequestParam(value = "sord", defaultValue = "") String sord,
			@RequestParam(value = "good_iden_numb", defaultValue = "0") String good_iden_numb,
			@RequestParam(value = "vendorid", defaultValue = "") String vendorid,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		
		params.put("good_iden_numb"	, good_iden_numb);
		params.put("vendorid"		, vendorid		);
		
		modelAndView.setViewName("jsonView");
//		
		modelAndView.addObject("list", productManageSvc.getGoodVendorListForVendor(params));
		return modelAndView;
	}
	
	/**
	 * 상품 공급사 상세 정보   공급사 사용자 상세 
	 */
	@RequestMapping("setFixGoodUnitPriceTrans.sys")
	public ModelAndView setFixUnitPriceTrans(
			@RequestParam(value = "good_iden_numb"   ,defaultValue = "") String good_iden_numb	  ,// 상품코드            
			@RequestParam(value = "vendorid"         ,defaultValue = "") String vendorid      	  ,// 공급사ID
			@RequestParam(value = "applt_fix_code"   ,defaultValue = "") String applt_fix_code    ,// 요청구분
			@RequestParam(value = "apply_desc" 		 ,defaultValue = "") String apply_desc		  ,// 변경사유
			@RequestParam(value = "price" 	         ,defaultValue = "") String price	      	  ,// 변경단가 
			@RequestParam(value = "before_price" 	 ,defaultValue = "") String before_price	  ,// 기존단가 
			
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		LoginUserDto loginUserDto = null; 
		Map<String, Object> params = new HashMap<String, Object>();
		
		try{
			loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
			
			params.put("good_iden_numb"		,	good_iden_numb  			);
			params.put("vendorid"			,	vendorid        			);
			params.put("insert_user_id"		,	loginUserDto.getUserId()  	);
			params.put("applt_fix_code"		,   applt_fix_code				);
			params.put("apply_desc"			,   apply_desc					);
			params.put("price" 				,	CommonUtils.stringParseDouble(price, 0));
			params.put("before_price" 		,	CommonUtils.stringParseDouble(before_price, 0));
			
			productManageSvc.setFixGoodUnitPriceTrans(params , loginUserDto );
			
		} catch(Exception e) {
			
			logger.error("Exception : "+e);
			custResponse.setSuccess(false);
			custResponse.setMessage("System Excute Error!....");
			custResponse.setMessage(CommonUtils.getErrSubString(e,50));	//Option(To Detail Message)
		}
		
		modelAndView.setViewName("jsonView");
		modelAndView.addObject(custResponse);
		return modelAndView;
	}
	
	
	
	/**
	 * 상품 공급사 상세 정보   공급사 사용자 상세 
	 */
	@RequestMapping("setModifyUseState.sys")
	public ModelAndView setModifyUseState(
			@RequestParam(value = "good_iden_numb"   ,defaultValue = "") String good_iden_numb	  ,// 상품코드            
			@RequestParam(value = "vendorid"         ,defaultValue = "") String vendorid      	  ,// 공급사ID
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		LoginUserDto loginUserDto = null; 
		Map<String, Object> params = new HashMap<String, Object>();
		
		try{
			loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
			
			params.put("good_iden_numb"		,	good_iden_numb  			);
			params.put("vendorid"			,	vendorid        			);
			params.put("inser_user_id", loginUserDto.getUserId()); 
			productManageSvc.setModifyUseState(params );
			
		} catch(Exception e) {
			
			logger.error("Exception : "+e);
			custResponse.setSuccess(false);
			custResponse.setMessage("System Excute Error!....");
			custResponse.setMessage(CommonUtils.getErrSubString(e,50));	//Option(To Detail Message)
		}
		
		modelAndView.setViewName("jsonView");
		modelAndView.addObject(custResponse);
		return modelAndView;
	}
	
	
	/**
	 * 상품 상세 (등록 , 상세)   
	 * goodIdenNumb 값에 따른 등록 , 상세 상태값 변경 
	 */
	@RequestMapping("productExcelRegi.sys")
	public ModelAndView productExcelRegi(
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		modelAndView.setViewName("product/product/productAdmXlsRegi");
		return modelAndView;
	}
	
	/**
	 * 상품진열 일괄등록   
	 * goodIdenNumb 값에 따른 등록 , 상세 상태값 변경 
	 */
	@RequestMapping("productDispExcelRegi.sys")
	public ModelAndView productDispExcelRegi(
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		modelAndView.setViewName("product/product/productDispAdmXlsRegi");
		return modelAndView;
	}
	
	/**
	 * 상품진열 일괄종료 
	 */
	@RequestMapping("productNoneDispAdmXls.sys")
	public ModelAndView productNoneDispAdmXls(
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		modelAndView.setViewName("product/product/productNoneDispAdmXls");
		return modelAndView;
	}
	
	
	/**
	 *  상품 기본 정보및 공급사 정보 저장  product/productExcelUpload.sys
	 */
	@RequestMapping("productExcelUpload.sys")
	public ModelAndView productExcelUpload(
			@RequestParam(value = "excelFile", required=true) MultipartFile excelFile,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		modelAndView = new ModelAndView("jsonView");
		LoginUserDto loginUserDto = null;
		
		String excelUploadDirPath = Constances.EXCEL_UPLOAD_PATH;
		File excelUploadDir = new File(excelUploadDirPath);
		MultipartFileUpload multipartFileUpload = null;
		/*----------------------Excel Upload Start------------------------*/
		try {
			if(!excelUploadDir.exists()) excelUploadDir.mkdirs();
			multipartFileUpload = new MultipartFileUpload(excelFile, excelUploadDir);
		} catch(Exception e) {
			logger.error("Exception : "+e);
			custResponse.setSuccess(false);
			custResponse.setMessage("Upload File Save Error!....");
			custResponse.setMessage(CommonUtils.getErrSubString(e,50));	//Option(To Detail Message)
			modelAndView.addObject(custResponse);
			return modelAndView;
		}
		/*--------------------- Excel에서 Data을 뽑아옴------------------------*/
		String[] colNames = { "good_iden_numb"		,"cate_cd"				,"good_name"			,"good_reg_year"        ,"new_busi"
				
				             //,"good_spec"
							,"spec_spec", "spec_pi", "spec_width", "spec_deep", "spec_height"
							, "spec_liter", "spec_ton", "spec_meter", "spec_material", "spec_size"
							, "spec_color", "spec_type", "spec_weight_sum", "spec_weight_real"
				             
				             ,"vtax_clas_code"		,"product_manager"      ,"order_unit"           ,"good_type"
							 ,"vendor_expose"       ,"isdistribute"         ,"stock_mngt"           ,"add_good"             ,"skts_img"            		
							 ,"vendorcd"            ,"isUse"				,"sell_price"           ,"sale_unit_pric"		,"deli_mini_quan"		
							 ,"deli_mini_day"		,"distri_rate"			,"make_comp_name"		,"issub_ontract"        ,"good_inventory_cnt"
							 ,"vendor_priority"};	//엑셀의 Data Fild 와 같아야 함 (DB저장시 mapKey로 쓰임)
		
		ExcelReader excelReader = new ExcelReader(multipartFileUpload.getUploadedFile());
		List<Map<String, Object>> saveList = excelReader.getExcelReadList(0, colNames);
		logger.debug("saveList.size() : "+saveList.size());
		for(Map<String, Object> map : saveList) {
			logger.debug("-------------------------------------------------");
			for(String mapKey : colNames) {
				logger.debug(mapKey + " : " + map.get(mapKey));
			}
		}
		loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		modelAndView.setViewName("jsonView");
		List<Map<String, Object>> list = productManageSvc.validationProdInfo(saveList,loginUserDto);
		logger.debug("list size is the ["+list.size()+"]");

		LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		modelAndView.addObject("list", productManageSvc.uploadProdInfo(list, userInfoDto));
		modelAndView.addObject(custResponse);
		return modelAndView;
	}
	
	/**
	 *  상품진열 일괄등록
	 */
	@RequestMapping("productDispExcelUpload.sys")
	public ModelAndView productDispExcelUpload(
			@RequestParam(value = "excelFile", required=true) MultipartFile excelFile,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		modelAndView = new ModelAndView("jsonView");
		LoginUserDto loginUserDto = null;
		
		String excelUploadDirPath = Constances.EXCEL_UPLOAD_PATH;
		File excelUploadDir = new File(excelUploadDirPath);
		MultipartFileUpload multipartFileUpload = null;
		/*----------------------Excel Upload Start------------------------*/
		try {
			if(!excelUploadDir.exists()) excelUploadDir.mkdirs();
			multipartFileUpload = new MultipartFileUpload(excelFile, excelUploadDir);
		} catch(Exception e) {
			logger.error("Exception : "+e);
			custResponse.setSuccess(false);
			custResponse.setMessage("Upload File Save Error!....");
			custResponse.setMessage(CommonUtils.getErrSubString(e,50));	//Option(To Detail Message)
			modelAndView.addObject(custResponse);
			return modelAndView;
		}
		/*--------------------- Excel에서 Data을 뽑아옴------------------------*/
		String[] colNames = {"good_iden_numb","vendorcd","areatypecd","sell_price"};	//엑셀의 Data Fild 와 같아야 함 (DB저장시 mapKey로 쓰임)
		ExcelReader excelReader = new ExcelReader(multipartFileUpload.getUploadedFile());
		List<Map<String, Object>> saveList = excelReader.getExcelReadList(0, colNames);
		logger.debug("saveList.size() : "+saveList.size());
		for(Map<String, Object> map : saveList) {
			logger.debug("-------------------------------------------------");
			for(String mapKey : colNames) {
				logger.debug(mapKey + " : " + map.get(mapKey));
			}
		}
		
		loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		modelAndView.setViewName("jsonView");
		List<Map<String, Object>> list = productManageSvc.validationProdDispInfo(saveList,loginUserDto);
		logger.debug("list size is the ["+list.size()+"]");
		modelAndView.addObject("list", productManageSvc.uploadProdDispInfo(list,loginUserDto));
		modelAndView.addObject(custResponse);
		return modelAndView;
	}
	
	/**
	 *  상품진열 일괄종료
	 */
	@RequestMapping("productNoneDispExcelUpload.sys")
	public ModelAndView productNoneDispExcelUpload(
			@RequestParam(value = "excelFile", required=true) MultipartFile excelFile,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		modelAndView = new ModelAndView("jsonView");
		LoginUserDto loginUserDto = null;
		
		String excelUploadDirPath = Constances.EXCEL_UPLOAD_PATH;
		File excelUploadDir = new File(excelUploadDirPath);
		MultipartFileUpload multipartFileUpload = null;
		/*----------------------Excel Upload Start------------------------*/
		try {
			if(!excelUploadDir.exists()) excelUploadDir.mkdirs();
			multipartFileUpload = new MultipartFileUpload(excelFile, excelUploadDir);
		} catch(Exception e) {
			logger.error("Exception : "+e);
			custResponse.setSuccess(false);
			custResponse.setMessage("Upload File Save Error!....");
			custResponse.setMessage(CommonUtils.getErrSubString(e,50));	//Option(To Detail Message)
			modelAndView.addObject(custResponse);
			return modelAndView;
		}
		/*--------------------- Excel에서 Data을 뽑아옴------------------------*/
		String[] colNames = {"good_iden_numb","vendorCd"};	//엑셀의 Data Fild 와 같아야 함 (DB저장시 mapKey로 쓰임)
		ExcelReader excelReader = new ExcelReader(multipartFileUpload.getUploadedFile());
		List<Map<String, Object>> saveList = excelReader.getExcelReadList(0, colNames);
		for(Map<String, Object> map : saveList) {
			logger.debug("-------------------------------------------------");
			for(String mapKey : colNames) {
				logger.debug(mapKey + " : " + map.get(mapKey));
			}
		}
		
		loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		modelAndView.setViewName("jsonView");
		List<Map<String, Object>> list = productManageSvc.validationProdNoneDispInfo(saveList,loginUserDto);
		logger.debug("list size is the ["+list.size()+"]");
		modelAndView.addObject("list", productManageSvc.uploadProdNoneDispInfo(list));
		modelAndView.addObject(custResponse);
		return modelAndView;
	}
	

	@RequestMapping("buyProductSearchAdm.sys")
	public ModelAndView buyProductSearchAdm(
			@RequestParam(value = "srcType", defaultValue = "") String srcType,
			@RequestParam(value = "srcCateId", defaultValue = "") String srcCateId,
			@RequestParam(value = "srcFullCateName", defaultValue = "") String srcFullCateName,
			@RequestParam(value = "srcProductInput", defaultValue = "") String srcProductInput, 
			@RequestParam(value = "srcPopularityProduct", defaultValue = "") String srcPopularityProduct, 
			
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		modelAndView.setViewName("jspViewResolver");
		modelAndView.addObject("srcType", srcType);
        modelAndView.addObject("srcProductInput", srcProductInput);
        modelAndView.addObject("srcCateId", srcCateId);
        modelAndView.addObject("srcFullCateName", srcFullCateName);
        modelAndView.addObject("srcPopularityProduct", srcPopularityProduct);
		return new ModelAndView("product/product/buyProductSearchAdm");
	}
	
	
}
