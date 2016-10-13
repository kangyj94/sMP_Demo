package kr.co.bitcube.buyController.controller; 

import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import kr.co.bitcube.common.dao.GeneralDao;
import kr.co.bitcube.common.dto.LoginUserDto;
import kr.co.bitcube.common.utils.CommonUtils;
import kr.co.bitcube.common.utils.Constances;
import kr.co.bitcube.common.utils.CustomResponse;
import kr.co.bitcube.product.dao.ProductDao;
import kr.co.bitcube.product.dto.BuyProductDto;
import kr.co.bitcube.product.service.ProductSvc;
import kr.co.bitcube.schedule.ScheduleController;

@Controller
@RequestMapping("buyProduct")
public class BuyProductCtl {
	
	private Logger logger = Logger.getLogger(getClass());
	@Autowired
	private ProductSvc productSvc;
	
	@Autowired
	private ProductDao productDao;
	
	@Autowired
	private GeneralDao generalDao;
	
	/**
	 * 헤더 상품검색 자동완성
	 */
	@RequestMapping("pdtAutoComplete.sys")
	public ModelAndView pdtAutoComplete(
			@RequestParam(value = "srcProductInput", defaultValue = "") String srcProductInput,						// 상품코드
			ModelAndView modelAndView, HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		srcProductInput = new String(srcProductInput.getBytes("iso-8859-1"), "utf-8");
		
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		try {
			
			List<String> resultList = new ArrayList<String>();
			List<BuyProductDto> autoCompList = ScheduleController.autoCompList;
			
			if(autoCompList == null){
				autoCompList = productDao.selectBuyProductSearchList();
			}
			
			if(autoCompList != null && autoCompList.size() > 0){
				for(int i = 0 ; i < autoCompList.size() ; i++){
					
					if(resultList.size() >= 10) break;
					
					String pdtName = CommonUtils.getString(autoCompList.get(i).getGood_name());
					String pdtSame = CommonUtils.getString(autoCompList.get(i).getGood_same_word());
					String pdtSpec = CommonUtils.getString(autoCompList.get(i).getGood_spec());
					
					if(pdtName != null){
						if(pdtName.trim().toLowerCase().indexOf(srcProductInput.trim().toLowerCase()) > -1 
						|| pdtSame.trim().toLowerCase().indexOf(srcProductInput.trim().toLowerCase()) > -1
						|| pdtSpec.trim().toLowerCase().indexOf(srcProductInput.trim().toLowerCase()) > -1){
							
							if(!"".equals(pdtName) ){
								resultList.add(pdtName);
							}
							
							if(!"".equals(pdtSame) ){
								for(int j = 0 ; j < pdtSame.split("‡").length ; j++){
									if(pdtSame.split("‡")[j].trim().toLowerCase().indexOf(srcProductInput.trim().toLowerCase()) > -1){
										resultList.add(pdtSame.split("‡")[j]);
									}
								}
							}
							if(!"".equals(pdtSpec) ){
								resultList.add(pdtSpec);
							}
						}
					}
				}
			}
			
			//리스트 중복 제거
			HashSet<String> distinctObj = new HashSet<String>(resultList);
			resultList = new ArrayList<String>(distinctObj);
			modelAndView.addObject("resultList", resultList);
			
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
	 * 상품검색결과 엑셀다운로드
	 * @param srcCateId
	 * @param prevWord
	 * @param sheetTitle
	 * @param excelFileName
	 * @param colLabels
	 * @param colIds
	 * @param numColIds
	 * @param figureColIds
	 * @param modelAndView
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("productResultListExcel.sys")
	public ModelAndView productResultListExcel(
			@RequestParam(value = "srcCateId"	, defaultValue = "") 	String srcCateId,		
			@RequestParam(value = "prevWord"	, defaultValue = "") 	String prevWord,
			
			@RequestParam(value = "sheetTitle", defaultValue = "") String sheetTitle,
			@RequestParam(value = "excelFileName", defaultValue = "") String excelFileName,
			@RequestParam(value = "colLabels", required = false) String[] colLabels,
			@RequestParam(value = "colIds", required = false) String[] colIds,
			@RequestParam(value = "numColIds", required = false) String[] numColIds,
			@RequestParam(value = "figureColIds", required = false) String[] figureColIds,
			HttpServletRequest request, ModelMap paramMap, ModelAndView modelAndView) throws Exception {
		
		LoginUserDto userInfoDto = CommonUtils.getLoginUserDto(request);
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userInfoDto", userInfoDto);
		params.put("inputWord", "");
		params.put("searchType", "Y");
		params.put("prevWord",    prevWord);
		params.put("srcCateId",   srcCateId);
//		params.put("orderString", " ORDER_CNT DESC");
		String addSql = productSvc.getTotSearchAddSql(params);
		params.put("addSql", addSql);
		List<Object> list = generalDao.selectGernalList("product.selectProductResultListExcel", params);
		
		List<Map<String, Object>> sheetList = new ArrayList<Map<String, Object>>();
		Map<String, Object> map1 = new HashMap<String, Object>();
		map1.put("sheetTitle", sheetTitle);
		map1.put("colLabels", colLabels);
		map1.put("colIds", colIds);
		map1.put("numColIds", numColIds);
		map1.put("figureColIds", figureColIds);
		map1.put("colDataList", list);
		sheetList.add(map1);
		
		modelAndView.setViewName("commonExcelViewResolver");
		modelAndView.addObject("excelFileName", excelFileName);
		modelAndView.addObject("sheetList", sheetList);
		
		return modelAndView;
	}
	
	/**
	 * 상품검색결과  
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping("productResultList.sys")
	public ModelAndView productResultList(
			@RequestParam(value = "inputWord"		, defaultValue = "") 	String inputWord,
			@RequestParam(value = "searchType"		, defaultValue = "") 	String searchType,
			@RequestParam(value = "srcCateId"		, defaultValue = "") 	String srcCateId,		
			@RequestParam(value = "prevWord"		, defaultValue = "") 	String prevWord,			
			@RequestParam(value = "srcGoodName"		, defaultValue = "") 	String srcGoodName,			
			@RequestParam(value = "srcGoodSpec"		, defaultValue = "") 	String srcGoodSpec,			
			@RequestParam(value = "srcGoodIdenNumb"	, defaultValue = "") 	String srcGoodIdenNumb,			
			@RequestParam(value = "srcVendorNm"		, defaultValue = "") 	String srcVendorNm,			
			@RequestParam(value = "srcGoodClasCode"	, defaultValue = "") 	String srcGoodClasCode,			
			@RequestParam(value = "orderString"		, defaultValue = "ASCII_ORDER") 	String orderString,
			@RequestParam(value = "goodtype_yn"		, defaultValue = "Y") 	String goodtype_yn,
			@RequestParam(value = "pIdx"			, defaultValue = "1") 	int pIdx,			
			@RequestParam(value = "pCnt"			, defaultValue = "30")	int pCnt,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		Map<String, Object>       params          = new HashMap<String, Object>();
		Map<String, String>       managerUserInfo = null;
		LoginUserDto              userInfoDto     = CommonUtils.getLoginUserDto(request);
		List<Map<String, Object>> list            = null;
		ModelMap                  daoParam        = new ModelMap();
		String                    borgId          = userInfoDto.getBorgId();
		
		params.put("userInfoDto"	, userInfoDto);
		params.put("inputWord"		, inputWord);
		params.put("searchType"		, searchType);
		params.put("prevWord"		, prevWord);
		params.put("srcCateId"		, srcCateId);
		params.put("srcGoodName"	, srcGoodName);
		params.put("srcGoodSpec"	, srcGoodSpec);
		params.put("srcGoodIdenNumb", srcGoodIdenNumb);
		params.put("srcVendorNm"	, srcVendorNm);
		params.put("srcGoodClasCode", srcGoodClasCode);
		if("ASCII_ORDER".equals(orderString) || "".equals(CommonUtils.getString(orderString))){  //AAA.GOOD_TYPE DESC  검색조건 추가(지정자재 우선순위) BY SUN 20160530
			orderString = "AAA.GOOD_TYPE DESC, ASCII_ORDER ASC, AAA.GOOD_NAME ASC";
			params.put("orderString", orderString);
		}else{
			params.put("orderString","AAA.GOOD_TYPE DESC, " + orderString + " DESC");
		}
		
		logger.debug("params value ["+params+"]");
		
		int records = productSvc.getProductResultListCnt(params); //조회조건에 따른 카운트
		int total   = (int)Math.ceil((float)records / (float)pCnt);
		
		if(records>0) {
			list = productSvc.selectProductSearchResultList(params,pIdx,pCnt); // 조회 조건에 따른 리스트 조회
		}
		
		daoParam.put("branchId", borgId);
		
		managerUserInfo = (Map<String, String>)this.generalDao.selectGernalObject("common.default.selectManagerUserInfo", daoParam); // 고객사 담당자 조회
		
		modelAndView.addObject("inputWord",       inputWord);
		modelAndView.addObject("searchType",      searchType);
		modelAndView.addObject("prevWord",        prevWord);
		modelAndView.addObject("srcGoodName",     srcGoodName	 );
		modelAndView.addObject("srcGoodSpec",     srcGoodSpec	 );
		modelAndView.addObject("srcGoodIdenNumb", srcGoodIdenNumb);
		modelAndView.addObject("srcVendorNm",     srcVendorNm	 );
		modelAndView.addObject("srcGoodClasCode", srcGoodClasCode);
		modelAndView.addObject("pIdx",            pIdx);
		modelAndView.addObject("pCnt",            pCnt);
		modelAndView.addObject("total",           total);
		modelAndView.addObject("records",         records);
		modelAndView.addObject("list",            list);
		modelAndView.addObject("managerUserInfo", managerUserInfo);
		
		modelAndView.setViewName("product/product/buyProductList");
		
		return modelAndView;
	}
	
	/** * 상품팝업 */
	@RequestMapping("getProductDetailInfoPop.sys")
	public ModelAndView getProductDetailInfoPop(
			@RequestParam(value = "goodIdenNumb", required = true) 		String goodIdenNumb,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		LoginUserDto        userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		Map<String, Object> params = new HashMap<String, Object>();
		// 옵션상품일 경우 대표상품의 상품코드를 조회하여 리턴함.
		String tempGoodIdenNumb = productSvc.selectProductAttribute(goodIdenNumb);
		params.put("goodIdenNumb"	, tempGoodIdenNumb);
		params.put("productDetailSearch"	, "true");
		params.put("userInfoDto"	, userInfoDto);
		//----------------조회------------/
		List<Map<String, Object>> list = productSvc.getProductResultList(params,-1,-1);
		modelAndView.setViewName("jsonView");
		modelAndView.addObject("list"		, list);
		modelAndView.addObject("GOOD_IDEN_NUMB" , tempGoodIdenNumb);
		return modelAndView;
	}
	
	/**
	 * 상품검색결과  
	 */
	@RequestMapping("productResultGridList.sys")
	public ModelAndView productResultGridList(
			@RequestParam(value = "inputWord"	, defaultValue = "") 	String inputWord,
			@RequestParam(value = "searchType"	, defaultValue = "") 	String searchType,
			@RequestParam(value = "prevWord"	, defaultValue = "") 	String prevWord,	
			@RequestParam(value = "srcCateId"	, defaultValue = "") 	String srcCateId,	
			@RequestParam(value = "srcGoodName"		, defaultValue = "") 	String srcGoodName,			
			@RequestParam(value = "srcGoodSpec"		, defaultValue = "") 	String srcGoodSpec,			
			@RequestParam(value = "srcGoodIdenNumb"	, defaultValue = "") 	String srcGoodIdenNumb,			
			@RequestParam(value = "srcVendorNm"		, defaultValue = "") 	String srcVendorNm,			
			@RequestParam(value = "srcGoodClasCode"	, defaultValue = "") 	String srcGoodClasCode,			
			@RequestParam(value = "page", defaultValue = "1") int page,
			@RequestParam(value = "rows", defaultValue = "30") int rows,
			@RequestParam(value = "sidx", defaultValue = "GOOD_NAME") String sidx,
			@RequestParam(value = "sord", defaultValue = "ASC") String sord,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("inputWord"	, inputWord);
		params.put("searchType"	, searchType);
		params.put("prevWord"	, prevWord);
		params.put("srcCateId"	, srcCateId);
		params.put( "userInfoDto" , userInfoDto );
		
		params.put("srcGoodName"	, srcGoodName);
		params.put("srcGoodSpec"	, srcGoodSpec);
		params.put("srcGoodIdenNumb", srcGoodIdenNumb);
		params.put("srcVendorNm"	, srcVendorNm);
		params.put("srcGoodClasCode", srcGoodClasCode);		
		
		String orderString = " " +"BB.GOOD_TYPE DESC";
		if( sidx != null && sidx.equals("") ==false ){
			orderString = ", " + sidx + " " + sord + " ";
		}
		params.put("orderString", orderString);
		
		logger.debug("params value ["+params+"]");
		//----------------페이징 세팅------------/
		int records = productSvc.getProductResultGridListCnt(params); //조회조건에 따른 카운트
		int total = (int)Math.ceil((float)records / (float)rows);
		
		//----------------조회------------/
		List<Map<String, Object>> list = null;
		if(records>0) {
			list = productSvc.getProductResultGridList(params,page,rows);
		}
		
		modelAndView.addObject("inputWord"	, inputWord);
		modelAndView.addObject("searchType"	, searchType);
		modelAndView.addObject("prevWord"	, prevWord);
		modelAndView.addObject("page"		, page);
		modelAndView.addObject("total"		, total);
		modelAndView.addObject("records"	, records);
		modelAndView.addObject("list"		, list);
		
		modelAndView.setViewName("jsonView");
		return modelAndView;
	}
	
	@RequestMapping("getChoiceVendorInfo.sys")
	public ModelAndView getChoiceVendorInfo(
			@RequestParam(value = "goodIdenNumb", required = true) String goodIdenNumb,		
			@RequestParam(value = "vendorId"	, required = true) String vendorId,			
			ModelAndView modelAndView, HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		Map<String, Object> resultMap = null;
		try {
			Map<String, Object> params = new HashMap<String, Object>();
			
			params.put("goodIdenNumb", goodIdenNumb);
			params.put("vendorId"	 , vendorId);
			resultMap = productSvc.getChoiceVendorInfo(params);
		} catch(Exception e) {
			logger.error("Exception : "+e);
			custResponse.setSuccess(false);
			custResponse.setMessage("System Excute Error!....");
			custResponse.setMessage(CommonUtils.getErrSubString(e,50));	//Option(To Detail Message)
		}
		modelAndView.addObject("resultMap", resultMap);
		modelAndView.setViewName("jsonView");
		modelAndView.addObject(custResponse);
		return modelAndView;
	}	
	
	
	@RequestMapping("getProductOption.sys")
	public ModelAndView getProductOption(
			@RequestParam(value = "goodIdenNumb", required = true) String goodIdenNumb,		
			@RequestParam(value = "vendorId"	, required = true) String vendorId,			
			ModelAndView modelAndView, HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		Map<String, Object> resultMap = null;
		try {
			Map<String, Object> params = new HashMap<String, Object>();
			
			params.put("goodIdenNumb", goodIdenNumb);
			params.put("vendorId"	 , vendorId);
			resultMap = productSvc.getProductOption(params);
		} catch(Exception e) {
			logger.error("Exception : "+e);
			custResponse.setSuccess(false);
			custResponse.setMessage("System Excute Error!....");
			custResponse.setMessage(CommonUtils.getErrSubString(e,50));	//Option(To Detail Message)
		}
		modelAndView.addObject("resultMap", resultMap);
		modelAndView.setViewName("jsonView");
		modelAndView.addObject(custResponse);
		return modelAndView;
	}	

	@RequestMapping("setUserGood.sys")
	public ModelAndView setUserGood(	
			@RequestParam(value = "goodIdenNumb", required = true) String goodIdenNumb,	
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse customResponse = new CustomResponse(true);
		LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		ModelMap params = new ModelMap();
		params.put( "goodIdenNumb" , goodIdenNumb );
		params.put( "userInfoDto" , userInfoDto );

		try {
			int cnt = generalDao.selectGernalCount("product.selectUserGoodCntByPk", params);
			if( cnt == 0){
				generalDao.insertGernal("product.insertUserGood", params);
			}else{
				customResponse.setSuccess(false);
				customResponse.setMessage("이미 관심상품에 등록된 상품입니다.");
			}
		} catch(Exception e) {
			logger.error("Exception : "+e);
			customResponse.setSuccess(false);
			customResponse.setMessage("시스템 처리 중 에러가 발생하였습니다.");	
		}

		modelAndView.addObject("customResponse", customResponse);
		modelAndView.setViewName("jsonView");
		return modelAndView;
	}	
	
	/**
	 * 관심상품 페이지 호출
	 */
	@RequestMapping("getBuyUserGoodList.sys")
	public ModelAndView buyUserGood(
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		Map<String, Object> params = new HashMap<String, Object>();
		LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		params.put( "userInfoDto" , userInfoDto );
		params.put( "userGoodFlag" , "T");	//관심상품리스트를 가져오기 위한 플래그
		//----------------조회------------/
		List<Map<String, Object>> list = productSvc.getProductResultList(params,-1,0);
		modelAndView.addObject("list"		, list);
		modelAndView.setViewName("product/product/buyUserGood");
		return modelAndView;
	}
}