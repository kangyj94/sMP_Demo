package kr.co.bitcube.product.controller; 

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import kr.co.bitcube.common.dao.GeneralDao;
import kr.co.bitcube.common.dto.LoginUserDto;
import kr.co.bitcube.common.service.CommonSvc;
import kr.co.bitcube.common.utils.CommonUtils;
import kr.co.bitcube.common.utils.Constances;
import kr.co.bitcube.common.utils.CustomResponse;
import kr.co.bitcube.common.utils.ExcelReader;
import kr.co.bitcube.common.utils.MultipartFileUpload;
import kr.co.bitcube.common.utils.RequestUtils;
import kr.co.bitcube.organ.dto.SmpBranchsDto;
import kr.co.bitcube.product.dao.ProductDao;
import kr.co.bitcube.product.dto.BuyProductDto;
import kr.co.bitcube.product.dto.ProductDto;
import kr.co.bitcube.product.service.CategorySvc;
import kr.co.bitcube.product.service.ProductSvc;
import kr.co.bitcube.schedule.ScheduleController;

import org.apache.commons.beanutils.MethodUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.ibatis.session.RowBounds;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import egovframework.rte.fdl.idgnr.EgovIdGnrService;

@Controller
@RequestMapping("product")
public class ProductCtl {
	
	private Logger logger = Logger.getLogger(getClass());
	@Autowired
	private GeneralDao generalDao;
	@Autowired
	private CommonSvc commonSvc;
	@Autowired
	private ProductSvc productSvc;
	
	@Autowired
	private CategorySvc categorySvc;
	
	@Autowired
	private ProductDao productDao;
	
	@Autowired
	private WebApplicationContext context;
	
	@Resource(name="seqMcPriceChgHist")
	private EgovIdGnrService seqMcPriceChgHist;
	
	@Resource(name="seqMcStockChgHist")
	private EgovIdGnrService seqMcStockChgHist;
	
	@Resource(name="seqMcProductService")
	private EgovIdGnrService seqMcProductService;

	@Resource(name="seqMcProductHistoryService")
	private EgovIdGnrService seqMcProductHistoryService;
	
	/*----------------운영사 시작------------*/
	/**
	 * 운영사 상품 조회  
	 */
	@RequestMapping("productAdmList.sys")
	public ModelAndView productAdmList(
			@RequestParam(value = "inputWord", defaultValue="") String inputWord,			
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		modelAndView.addObject( "inputWord" , inputWord);
		modelAndView.addObject("workInfoList", generalDao.selectGernalList("product.selectWorkInfoList1", null));		// 공사유형
		modelAndView.setViewName("product/product/productAdmList");
		return modelAndView;
	}
	
	

	/**
	 * 상품검색결과  
	 */
	@RequestMapping("productResultList.sys")
	public ModelAndView productResultList(
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		modelAndView.setViewName("product/product/productResultList");
		return modelAndView;
	}
	
	/**
	 * 운영사 상품 조회  
	 */
	@RequestMapping("productList.sys")
	public ModelAndView productList(
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		modelAndView.setViewName("product/product/productList");
		modelAndView.addObject("ORDERGOODSTYPE", commonSvc.getCodeList("ORDERGOODSTYPE", 1));
		return modelAndView;
	}
	
	/**
	 * 상품 카테고리 연결
	 */
	@RequestMapping("saveProductCategory.sys")
	public void saveProductCategory(
			@RequestParam(value = "categortId", required=true) String categortId,
			@RequestParam(value = "good_iden_numb", required=true) String good_iden_numb,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		Map<String ,Object> saveMap = new HashMap<String, Object>();
		saveMap.put("categortId", categortId);
		saveMap.put("good_iden_numb", good_iden_numb);
		productSvc.saveProductCategory(saveMap);
	}
	
	
	/**
	 * 운영사 상품 검색 
	 */
	@RequestMapping("productListJQGrid.sys")
	public ModelAndView productListJQGrid(
			@RequestParam(value = "page", defaultValue = "1") int page,
			@RequestParam(value = "rows", defaultValue = "30") int rows,
			@RequestParam(value = "sidx", defaultValue = "good_Name") String sidx,
			@RequestParam(value = "sord", defaultValue = "desc") String sord,
			@RequestParam(value = "srcCateId", defaultValue = "0") String srcCateId,
			@RequestParam(value = "srcGoodIdenNumb", defaultValue = "") String srcGoodIdenNumb,
			@RequestParam(value = "srcGoodName", defaultValue = "") String srcGoodName,
			@RequestParam(value = "srcInsertStartDate", defaultValue = "") String srcInsertStartDate,
			@RequestParam(value = "srcInsertEndDate", defaultValue = "") String srcInsertEndDate,
			@RequestParam(value = "srcGoodSpecDesc", defaultValue = "") String srcGoodSpecDesc,
			@RequestParam(value = "srcGoodSameWord", defaultValue = "") String srcGoodSameWord,
			@RequestParam(value = "srcGoodClasCode", defaultValue = "") String srcGoodClasCode,
			@RequestParam(value = "srcIsUse", defaultValue = "") String srcIsUse,
			@RequestParam(value = "srcGroupId", defaultValue = "0") String srcGroupId,
			@RequestParam(value = "srcClientId", defaultValue = "0") String srcClientId,
			@RequestParam(value = "srcBranchId", defaultValue = "0") String srcBranchId,
			@RequestParam(value = "srcVendorId", defaultValue = "") String srcVendorId,
			@RequestParam(value = "srcProductManager", defaultValue = "") String srcProductManager,				//상품담당자
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		if("0".equals(srcGroupId)  ) {
			srcGroupId = "";
		}
		if("0".equals(srcClientId)){
			srcClientId = "";
		}
		
		if("0".equals(srcBranchId)){
			srcBranchId = "";
		}
		
		//----------------조회조건 세팅------------/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("srcCateId", srcCateId);
		params.put("srcGoodIdenNumb", srcGoodIdenNumb);
		params.put("srcGoodName", srcGoodName);
		params.put("srcInsertStartDate", srcInsertStartDate);
		params.put("srcInsertEndDate", srcInsertEndDate);
		params.put("srcGoodSpecDesc", srcGoodSpecDesc);
		params.put("srcGoodSameWord", srcGoodSameWord);
		params.put("srcGoodClasCode", srcGoodClasCode);
		params.put("srcIsUse", srcIsUse);
		params.put("srcGroupId", srcGroupId);
		params.put("srcClientId", srcClientId);
		params.put("srcBranchId", srcBranchId);
		params.put("srcVendorId", srcVendorId);
		params.put("srcProductManager", srcProductManager);
		String table = "";
		
//		if("good_Iden_Numb".equals(sidx)) {
//			table = "A."; 
//		} else if("good_Name".equals(sidx)) {
//			table = "A.";
//		} else if("majo_Code_Name".equals(sidx)) {
//			table = "C.";
//		} else if("vtax_Clas_Code".equals(sidx)) {
//			table = "A.";
//		} else if("isDistribute".equals(sidx)) {
//			table = "A.";
//		} else if("isDispPastGood".equals(sidx)) {
//			table = "A.";
//		} else if("sale_Unit_Pric".equals(sidx)) {
//			table = "B.";
//		} else if("good_Spec_Desc".equals(sidx)) {
//			table = "B.";
//		} else if("orde_Clas_Code".equals(sidx)) {
//			table = "B.";
//		} else if("original_Img_Path".equals(sidx)) {
//			table = "B.";
//		} else if("good_Desc".equals(sidx)) {
//			table = "B.";
//		} else if("good_Clas_Code".equals(sidx)) {
//			table = "B.";
//		}
		
		String orderString = " " + table + sidx + " " + sord + " ";
		params.put("orderString", orderString);

		
		logger.debug("params value ["+params+"]");
		//----------------페이징 세팅------------/
		int records = productSvc.getProductListCntForAdmin(params); //조회조건에 따른 카운트
		int total = (int)Math.ceil((float)records / (float)rows);
		
		//----------------조회------------/
		List<ProductDto> list = null;
		if(records>0) {
			list = productSvc.getProductListForAdmin(params, page, rows);
//			for(int i=0; i<list.size(); i++){
//				//상품표준 규격
//				String[] tmpGoodStSpecDescArr = new String[] {"","","","","",""};
//				if(list.get(i).getGood_St_Spec_Desc() != null && list.get(i).getGood_St_Spec_Desc() != ""){
//					String[] goodStSpecDescArr = list.get(i).getGood_St_Spec_Desc().split("‡");
//					
//					for(int j=0; j<goodStSpecDescArr.length; j++){
//						tmpGoodStSpecDescArr[j] = goodStSpecDescArr[j];
////						
////						
//					}
//					goodStSpecDescArr = tmpGoodStSpecDescArr;
//					list.get(i).setGoodStSpecDesc1(goodStSpecDescArr[0]);
//					list.get(i).setGoodStSpecDesc2(goodStSpecDescArr[1]);
//					list.get(i).setGoodStSpecDesc3(goodStSpecDescArr[2]);
//					list.get(i).setGoodStSpecDesc4(goodStSpecDescArr[3]);
//					list.get(i).setGoodStSpecDesc5(goodStSpecDescArr[4]);
//					list.get(i).setGoodStSpecDesc6(goodStSpecDescArr[5]);
//				}
//				
//				//상품규격
//				String[] tmpGoodSpecDescArr = new String[] {"","","","","","","",""};
//				if(list.get(i).getGood_Spec_Desc() != null && list.get(i).getGood_Spec_Desc() != ""){
//					String[] goodSpecDescArr = list.get(i).getGood_Spec_Desc().split("‡");
//					for(int j=0; j<goodSpecDescArr.length; j++){
//						tmpGoodSpecDescArr[j] = goodSpecDescArr[j];
////						
////						
//					}
//					goodSpecDescArr = tmpGoodSpecDescArr;
//					list.get(i).setGoodSpecDesc1(goodSpecDescArr[0]);
//					list.get(i).setGoodSpecDesc2(goodSpecDescArr[1]);
//					list.get(i).setGoodSpecDesc3(goodSpecDescArr[2]);
//					list.get(i).setGoodSpecDesc4(goodSpecDescArr[3]);
//					list.get(i).setGoodSpecDesc5(goodSpecDescArr[4]);
//					list.get(i).setGoodSpecDesc6(goodSpecDescArr[5]);
//					list.get(i).setGoodSpecDesc7(goodSpecDescArr[6]);
//					list.get(i).setGoodSpecDesc8(goodSpecDescArr[7]);
//				}
//				
//			}
		}
		
		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("page", page);
		modelAndView.addObject("total", total);
		modelAndView.addObject("records", records);
		modelAndView.addObject("list", list);
		return modelAndView;
	}
	
	
	/**
	 * 운영사 상품 검색 엑셀다운
	 */
	@RequestMapping("productListExcel.sys") 
	public ModelAndView productListExcel(
			@RequestParam(value = "sidx", defaultValue = "good_Name") String sidx,
			@RequestParam(value = "sord", defaultValue = "desc") String sord,
			@RequestParam(value = "srcCateId", defaultValue = "0") String srcCateId,
			@RequestParam(value = "srcGoodIdenNumb", defaultValue = "") String srcGoodIdenNumb,
			@RequestParam(value = "srcGoodName", defaultValue = "") String srcGoodName,
			@RequestParam(value = "srcInsertStartDate", defaultValue = "") String srcInsertStartDate,
			@RequestParam(value = "srcInsertEndDate", defaultValue = "") String srcInsertEndDate,
			@RequestParam(value = "srcGoodSpecDesc", defaultValue = "") String srcGoodSpecDesc,
			@RequestParam(value = "srcGoodSameWord", defaultValue = "") String srcGoodSameWord,
			@RequestParam(value = "srcGoodClasCode", defaultValue = "") String srcGoodClasCode,
			@RequestParam(value = "srcIsUse", defaultValue = "") String srcIsUse,
			@RequestParam(value = "srcGroupId", defaultValue = "0") String srcGroupId,
			@RequestParam(value = "srcClientId", defaultValue = "0") String srcClientId,
			@RequestParam(value = "srcBranchId", defaultValue = "0") String srcBranchId,
			@RequestParam(value = "srcVendorId", defaultValue = "") String srcVendorId,
			@RequestParam(value = "srcProductManager", defaultValue = "") String srcProductManager,
			
			@RequestParam(value = "sheetTitle", defaultValue = "") String sheetTitle,
			@RequestParam(value = "excelFileName", defaultValue = "") String excelFileName,
			@RequestParam(value = "colLabels", required = false) String[] colLabels,
			@RequestParam(value = "colIds", required = false) String[] colIds,
			@RequestParam(value = "numColIds", required = false) String[] numColIds,
			@RequestParam(value = "figureColIds", required = false) String[] figureColIds,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		if("0".equals(srcGroupId)  ) {
			srcGroupId = "";
		}
		if("0".equals(srcClientId)){
			srcClientId = "";
		}
		
		if("0".equals(srcBranchId)){
			srcBranchId = "";
		}
		
		//----------------조회조건 세팅------------/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("srcCateId", srcCateId);
		params.put("srcGoodIdenNumb", srcGoodIdenNumb);
		params.put("srcGoodName", srcGoodName);
		params.put("srcInsertStartDate", srcInsertStartDate);
		params.put("srcInsertEndDate", srcInsertEndDate);
		params.put("srcGoodSpecDesc", srcGoodSpecDesc);
		params.put("srcGoodSameWord", srcGoodSameWord);
		params.put("srcGoodClasCode", srcGoodClasCode);
		params.put("srcIsUse", srcIsUse);
		params.put("srcGroupId", srcGroupId);
		params.put("srcClientId", srcClientId);
		params.put("srcBranchId", srcBranchId);
		params.put("srcVendorId", srcVendorId);
		params.put("srcProductManager", srcProductManager);
		String table = "";
		
		String orderString = " " + table + sidx + " " + sord + " ";
		params.put("orderString", orderString);
		
		logger.debug("params value ["+params+"]");
		
		//----------------조회------------/
		List<ProductDto> list = productSvc.getProductListForAdmin(params, 1, RowBounds.NO_ROW_LIMIT);
		
		List<Map<String, Object>> colDataList = null;
		if(list != null && list.size() > 0){
			Map<String, Object> rtnData = null;
			colDataList = new ArrayList<Map<String, Object>>();

			String result = "";
			for(int i = 0; i < list.size() ; i++){
				try{
					String[] tempGoodStSpecDesc = new String[Constances.PROD_GOOD_ST_SPEC.length]; 
					for(int idx = 0 ; idx < Constances.PROD_GOOD_ST_SPEC.length ; idx++) {
						tempGoodStSpecDesc[idx] = Constances.PROD_GOOD_ST_SPEC[idx];
					}
					
					if(null != list.get(i).getGood_St_Spec_Desc()){
						String[] tempGoodStSpecDescArray =  list.get(i).getGood_St_Spec_Desc().split("‡");
						for(int idx = 0 ; idx < tempGoodStSpecDescArray.length ; idx++) {
							if(tempGoodStSpecDescArray[idx].toString().trim().length()  > 0) {
								result += tempGoodStSpecDesc[idx]+":"+ tempGoodStSpecDescArray[idx] + " ";
							}
						}
					}
					
					if(!"".equals(result)) result = "[" + result + "]";
					
					String[] tempGoodSpecDesc = new String[Constances.PROD_GOOD_SPEC.length]; 
					for(int idx = 0 ; idx < Constances.PROD_GOOD_SPEC.length ; idx++) {
						tempGoodSpecDesc[idx] = Constances.PROD_GOOD_SPEC[idx];
					}
					if(null != list.get(i).getGood_Spec_Desc()){
						String[] tempGoodSpecDescArray = list.get(i).getGood_Spec_Desc().split("‡");
						for(int idx = 0 ; idx < tempGoodSpecDescArray.length ; idx++) {
							if(tempGoodSpecDescArray[idx].toString().trim().length()  > 0) {
								if(idx == 0 ) {
									result += "  "+ tempGoodSpecDescArray[idx] + "  ";
								} else {
									result += tempGoodSpecDesc[idx]+":"+ tempGoodSpecDescArray[idx] + " ";
								}
							}
						}
					}
				}catch(Exception e){
					result="";
				}
				
				rtnData = new HashMap<String, Object>();
				rtnData.put("good_Iden_Numb",list.get(i).getGood_Iden_Numb());
				rtnData.put("cate_cd",list.get(i).getCate_cd());
				rtnData.put("good_Name",list.get(i).getGood_Name());
				rtnData.put("vtax_Clas_Code",list.get(i).getVtax_Clas_Code());
				rtnData.put("sale_Criterion_Type", list.get(i).getSale_Criterion_Type());
				rtnData.put("stan_Buying_Rate", list.get(i).getStan_Buying_Rate());
				rtnData.put("stan_Buying_Money", list.get(i).getStan_Buying_Money());
				rtnData.put("vendorNm",list.get(i).getVendorNm());
				rtnData.put("isDistribute", list.get(i).getIsDistribute());
				rtnData.put("isDispPastGood", list.get(i).getIsDispPastGood());
				rtnData.put("vendorcd", list.get(i).getVendorcd());
				if("1".equals(list.get(i).getIsUse())){
					rtnData.put("isUse", "정상");
				}
				else if("2".equals(list.get(i).getIsUse())){
					rtnData.put("isUse", "대기");
				}
				else{
					rtnData.put("isUse", "종료");
				}
//				rtnData.put("isUse", list.get(i).getIsUse());
				rtnData.put("sell_Price", list.get(i).getSell_Price());
				rtnData.put("sale_Unit_Pric", list.get(i).getSale_Unit_Pric());
				rtnData.put("orde_Clas_Code", list.get(i).getOrde_Clas_Code());
				
				rtnData.put("good_inventory_cnt", list.get(i).getGood_Inventory_Cnt());	//재고
				
				rtnData.put("good_Inventory_Cnt", list.get(i).getGood_Inventory_Cnt());
				rtnData.put("full_Cate_Name", list.get(i).getFull_Cate_Name());
				rtnData.put("isSetImage", list.get(i).getIsSetImage());
				rtnData.put("isSetDesc", list.get(i).getIsSetDesc());
				rtnData.put("deli_Mini_Quan", list.get(i).getDeli_Mini_Quan());
				rtnData.put("deli_Mini_Day", list.get(i).getDeli_Mini_Day());
				rtnData.put("good_Clas_Code", list.get(i).getGood_Clas_Code());
				rtnData.put("good_Same_Word", list.get(i).getGood_Same_Word());
				rtnData.put("excelGood_Spec_Desc", StringUtils.trim(result)); //좌우공백 제거
				rtnData.put("good_reg_year", list.get(i).getGood_reg_year());
				rtnData.put("avgpurcdate", list.get(i).getAvgpurcdate());
				rtnData.put("avginvoicedate", list.get(i).getAvginvoicedate());
				rtnData.put("product_manager", list.get(i).getProduct_manager());
				rtnData.put("product_manager_loginid", list.get(i).getProduct_manager_loginid());
				rtnData.put("isUse2", list.get(i).getIsUse());
				rtnData.put("vendor_priority", list.get(i).getVendor_priority());//상품우선순위
				String[] tmpSameArr = new String[] {"","","","",""};
				if(list.get(i).getGood_Same_Word() != null && list.get(i).getGood_Same_Word() !=""){
					String[] sameArr = list.get(i).getGood_Same_Word().split("‡");
					for(int tmp=0; tmp < (sameArr.length > 5 ? 5:sameArr.length); tmp++){
						tmpSameArr[tmp] = sameArr[tmp];
					}
					sameArr = tmpSameArr;
					rtnData.put("good_Same_Word1", sameArr[0]);
					rtnData.put("good_Same_Word2", sameArr[1]);
					rtnData.put("good_Same_Word3", sameArr[2]);
					rtnData.put("good_Same_Word4", sameArr[3]);
					rtnData.put("good_Same_Word5", sameArr[4]);
				}
				
				String [] tmpStArr = new String [] {"","","","","",""};
				if(list.get(i).getGood_St_Spec_Desc() != null && list.get(i).getGood_St_Spec_Desc() !=""){
					String [] stSpecArr = list.get(i).getGood_St_Spec_Desc().split("‡");
					for(int idx=0; idx<stSpecArr.length; idx++){
						tmpStArr[idx] = stSpecArr[idx];
					}
					stSpecArr = tmpStArr;
					rtnData.put("good_st_spec_desc1", stSpecArr[0]);
					rtnData.put("good_st_spec_desc2", stSpecArr[1]);
					rtnData.put("good_st_spec_desc3", stSpecArr[2]);
					rtnData.put("good_st_spec_desc4", stSpecArr[3]);
					rtnData.put("good_st_spec_desc5", stSpecArr[4]);
					rtnData.put("good_st_spec_desc6", stSpecArr[5]);			
				}
				String[] tmpArr = new String[] {"","","","","","","",""};
				if(list.get(i).getGood_Spec_Desc() != null && list.get(i).getGood_Spec_Desc() !=""){
					String[] specArr = list.get(i).getGood_Spec_Desc().split("‡");
					for(int tmp=0; tmp < (specArr.length > 8 ? 8:specArr.length); tmp++){
						tmpArr[tmp] = specArr[tmp];
					}
					specArr = tmpArr;
					rtnData.put("good_spec_desc1", specArr[0]);
					rtnData.put("good_spec_desc2", specArr[1]);
					rtnData.put("good_spec_desc3", specArr[2]);
					rtnData.put("good_spec_desc4", specArr[3]);
					rtnData.put("good_spec_desc5", specArr[4]);
					rtnData.put("good_spec_desc6", specArr[5]);
					rtnData.put("good_spec_desc7", specArr[6]);
					rtnData.put("good_spec_desc8", specArr[7]);
				}
				colDataList.add(rtnData);
				
				result = "";
			}
		}	

        List<Map<String, Object>> sheetList = new ArrayList<Map<String, Object>>();
        Map<String, Object> map1 = new HashMap<String, Object>();
        map1.put("sheetTitle", sheetTitle);
        map1.put("colLabels", colLabels);
        map1.put("colIds", colIds);
        map1.put("numColIds", numColIds);
        map1.put("figureColIds", figureColIds);
        map1.put("colDataList", colDataList);
        sheetList.add(map1);
        modelAndView.setViewName("commonExcelViewResolver");
        modelAndView.addObject("excelFileName", excelFileName);
        modelAndView.addObject("sheetList", sheetList);
		
//		modelAndView.addObject("sheetTitle", sheetTitle);
//		modelAndView.addObject("excelFileName", excelFileName);
//		modelAndView.addObject("colLabels", colLabels);
//		modelAndView.addObject("colIds", colIds);
//		modelAndView.addObject("numColIds", numColIds);
//		modelAndView.addObject("figureColIds", figureColIds);
//		modelAndView.addObject("colDataList", colDataList);
//		modelAndView.setViewName("commonExcelViewResolver");
		return modelAndView;
	}

	
	/**
	 * 상품 상세 (등록 , 상세)   
	 * goodIdenNumb 값에 따른 등록 , 상세 상태값 변경 
	 */
	@RequestMapping("detail.sys")
	public ModelAndView detail(
			@RequestParam(value = "good_iden_numb", defaultValue = "100") int good_iden_numb,
			@RequestParam(value = "vendorid", defaultValue = "10") int vendorid,
			@RequestParam(value = "bidid", defaultValue = "10") int bidid,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
//		
//		
//		
		modelAndView.addObject("good_iden_numb", good_iden_numb);
		modelAndView.addObject("vendorid", vendorid);
		modelAndView.addObject("bidid", bidid);
		
		modelAndView.setViewName("product/product/detail");
		return modelAndView;
	}
	
	/**
	 * 상세 코드 정보 Init 
	 */
	@RequestMapping("initDetailCodeInfo.sys")
	public ModelAndView initDetailCodeInfo(
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		
		try{
			modelAndView.addObject("deliAreaCodeList"	, commonSvc.getCodeList("DELI_AREA_CODE", 1)	);
			modelAndView.addObject("vTaxTypeCode"		, commonSvc.getCodeList("VTAXTYPECODE", 1)		);
			modelAndView.addObject("orderGoodsType"		, commonSvc.getCodeList("ORDERGOODSTYPE", 1)	);
			modelAndView.addObject("orderUnit"			, commonSvc.getCodeList("ORDERUNIT", 1)			);
			modelAndView.addObject("reqAppSts"			, commonSvc.getCodeList("REQAPPSTATE", 1)			);
			modelAndView.addObject("isdistributeSts"	, commonSvc.getCodeList("ISDISTRIBUTE", 1)			);
			
			
			
			
			
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
	
	
	
	
	
	@RequestMapping("productDetail.sys")
	public ModelAndView productDetail(
			@RequestParam(value = "goodIdenNumb", defaultValue = "0") String goodIdenNumb,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		if("".equals(goodIdenNumb)) {	//추가
		} else {	//수정
			Map<String, ProductDto> map = this.productSvc.getProductDetailInfo(goodIdenNumb);
			ProductDto detailInfo = map.get("detailInfo");
			modelAndView.addObject("detailInfo", detailInfo);
		}
		
		modelAndView.setViewName("product/product/productDetail");
		modelAndView.addObject("deliAreaCodeList", commonSvc.getCodeList("DELI_AREA_CODE", 1));	//권역유형
		return modelAndView;
	}
	
	@RequestMapping("goodTrans.sys")
	public ModelAndView goodTrans(
			@RequestParam(value = "good_Iden_Numb", defaultValue = "0") String goodIdenNumb,
			@RequestParam(value = "good_Name", defaultValue = "") String goodName,
			@RequestParam(value = "vtax_Clas_Code", defaultValue = "") String vtaxClasCode,
			@RequestParam(value = "sale_Criterion_Type", defaultValue = "") String saleCriterionType,
			@RequestParam(value = "stan_Buying_Rate", defaultValue = "0.00") String stanBuyingRate,
			@RequestParam(value = "stan_Buying_Money", defaultValue = "0") String stanBuyingMoney,
			@RequestParam(value = "isDistribute", defaultValue = "") String isDistribute,
			@RequestParam(value = "isDisppastGood", defaultValue = "") String isDisppastGood,
			@RequestParam(value = "cate_Id", defaultValue = "0") String cate_Id,
			ModelAndView modelAndView, HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		/*----------------저장값 세팅------------*/
		LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		Map<String,Object> saveMap = new HashMap<String,Object>();
		saveMap.put("goodName", goodName);
		saveMap.put("vtaxClasCode", vtaxClasCode);
		saveMap.put("saleCriterionType", saleCriterionType);
		saveMap.put("stanBuyingRate", CommonUtils.stringParseDouble(stanBuyingRate, 0.0));
		saveMap.put("stanBuyingMoney", CommonUtils.stringParseInt(stanBuyingMoney, 0));
		saveMap.put("isDistribute", isDistribute);
		saveMap.put("isDisppastGood", isDisppastGood);
		saveMap.put("cate_Id", CommonUtils.stringParseInt(cate_Id, 0));
		saveMap.put("insertUserId", loginUserDto.getUserId());
		
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		 
		try {
			if("".equals(goodIdenNumb)) {	//추가
				goodIdenNumb = productSvc.regGood(saveMap);
				modelAndView.addObject("msg", "등록 되었습니다.");
				modelAndView.addObject("good_Iden_Numb", goodIdenNumb);
			} else {	//수정
				saveMap.put("goodIdenNumb", CommonUtils.stringParseInt(goodIdenNumb, 0));
				productSvc.modGood(saveMap);
				modelAndView.addObject("msg", "수정 되었습니다.");
				modelAndView.addObject("good_Iden_Numb", goodIdenNumb);
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
	
	@RequestMapping("goodVendorListJQGrid.sys")
	public ModelAndView goodVendorListJQGrid(
			@RequestParam(value = "sidx", defaultValue = "VENDORNM") String sidx,
			@RequestParam(value = "sord", defaultValue = "ASC") String sord,
			@RequestParam(value = "srcGoodIdenNumb", defaultValue = "0") String srcGoodIdenNumb,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("srcGoodIdenNumb", srcGoodIdenNumb);
		String table = "";
		if("vendorNm".equals(sidx)) {
			table = "B."; 
		} else if("areaType".equals(sidx)) {
			table = "B.";
		} else if("regist_Date".equals(sidx)) {
			table = "A.";
		} else if("pressentNm".equals(sidx)) {
			table = "B.";
		}
		String orderString = " " + table + sidx + " " + sord + " ";
		params.put("orderString", orderString);
		
		List<ProductDto> list = null;
		if(!"".equals(srcGoodIdenNumb)) {
	        /*----------------조회------------*/
        	list = productSvc.getGoodVendorList(params);
        }
		
		modelAndView.setViewName("jsonView");
		modelAndView.addObject("list2", list);
		return modelAndView;
	}
	
	@RequestMapping("getSaleUnitPricList.sys")
	public ModelAndView getSaleUnitPricList(
			@RequestParam(value = "good_Iden_Numb", defaultValue = "0") String goodIdenNumb,
			@RequestParam(value = "vendorId", defaultValue = "") String vendorId,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("goodIdenNumb", CommonUtils.stringParseInt(goodIdenNumb, 0));
		params.put("vendorId", vendorId);
		
		/*----------------조회------------*/
		List<ProductDto> list = null;
    	list = productSvc.getSaleUnitPricList(params);
		
		modelAndView.setViewName("jsonView");
		modelAndView.addObject("vendorList", list);
		return modelAndView;
	}
	
	@RequestMapping("goodVendorDetail.sys")
	public ModelAndView goodVendorDetail(
			@RequestParam(value = "srcVendorId", defaultValue = "") String srcVendorId,
			@RequestParam(value = "srcGoodIdenNumb", defaultValue = "0") String srcGoodIdenNumb,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("srcVendorId", srcVendorId);
		params.put("srcGoodIdenNumb", srcGoodIdenNumb);
		
		ProductDto detailInfo = productSvc.getGoodVendorDetailInfo(params);
		
		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("detailInfo", detailInfo);
		
		return modelAndView;
	}
	
	@RequestMapping("vendorDetail.sys")
	public ModelAndView vendorDetail(
			@RequestParam(value = "srcVendorId", defaultValue = "") String srcVendorId,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("srcVendorId", srcVendorId);
		
		ProductDto detailInfo = productSvc.getVendorDetailInfo(params);
		
		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("detailInfo", detailInfo);
		
		return modelAndView;
	}
	
	@RequestMapping("goodVendorTrans.sys")
	public ModelAndView goodVendorTrans(
			@RequestParam(value = "oper", required = true) String oper,
			@RequestParam(value = "good_Iden_Numb", defaultValue = "0") String goodIdenNumb,
			@RequestParam(value = "vendorId", defaultValue = "") String vendorId,
			@RequestParam(value = "sale_Unit_Pric", defaultValue = "0.0") String saleUnitPric,
			@RequestParam(value = "good_Spec_Desc", defaultValue = "") String goodSpecDesc,
			@RequestParam(value = "orde_Clas_Code", defaultValue = "") String ordeClasCode,
			@RequestParam(value = "deli_Mini_Day", defaultValue = "0") String deliMiniDay,
			@RequestParam(value = "deli_Mini_Quan", defaultValue = "0") String deliMiniQuan,
			@RequestParam(value = "make_Comp_Name", defaultValue = "") String makeCompName,
			@RequestParam(value = "original_Img_Path", defaultValue = "") String originalImgPath,
			@RequestParam(value = "large_Img_Path", defaultValue = "") String largeImgPath,
			@RequestParam(value = "middle_Img_Path", defaultValue = "") String middleImgPath,
			@RequestParam(value = "small_Img_Path", defaultValue = "") String smallImgPath,
			@RequestParam(value = "good_Same_Word", defaultValue = "") String goodSameWord,
			@RequestParam(value = "good_Desc", defaultValue = "") String goodDesc,
			@RequestParam(value = "issub_Ontract", defaultValue = "") String issubOntract,
			@RequestParam(value = "good_Clas_Code", defaultValue = "") String goodClasCode,
			@RequestParam(value = "good_Inventory_Cnt", defaultValue = "0") String goodInventoryCnt,
			ModelAndView modelAndView, HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		/*----------------저장값 세팅------------*/
		Map<String,Object> saveMap = new HashMap<String,Object>();
		saveMap.put("goodIdenNumb", CommonUtils.stringParseInt(goodIdenNumb, 0));
		saveMap.put("vendorId", vendorId);
		saveMap.put("saleUnitPric", CommonUtils.stringParseDouble(saleUnitPric, 0.0));
		saveMap.put("goodSpecDesc", goodSpecDesc);
		saveMap.put("ordeClasCode", ordeClasCode);
		saveMap.put("deliMiniDay", CommonUtils.stringParseInt(deliMiniDay, 0));
		saveMap.put("deliMiniQuan", CommonUtils.stringParseInt(deliMiniQuan, 0));
		saveMap.put("makeCompName", makeCompName);
		saveMap.put("originalImgPath", originalImgPath);
		saveMap.put("largeImgPath", largeImgPath);
		saveMap.put("middleImgPath", middleImgPath);
		saveMap.put("smallImgPath", smallImgPath);
		saveMap.put("goodSameWord", goodSameWord);
		saveMap.put("goodDesc", goodDesc);
		saveMap.put("issubOntract", issubOntract);
		saveMap.put("goodClasCode", goodClasCode);
		saveMap.put("goodInventoryCnt", CommonUtils.stringParseInt(goodInventoryCnt, 0));
		
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		try {
			if("add".equals(oper)) {	//추가
				productSvc.regGoodVendor(saveMap);
				modelAndView.addObject("msg", "등록 되었습니다.");
			} else if("edit".equals(oper)) {	//수정
				productSvc.modGoodVendor(saveMap);
				modelAndView.addObject("msg", "수정 되었습니다.");
			} else if("del".equals(oper)) {
				productSvc.delGoodVendor(saveMap);
				modelAndView.addObject("msg", "삭제 되었습니다.");
			}
		} catch(Exception e) {
			logger.error("Exception : "+e);
			custResponse.setSuccess(false);
			custResponse.setMessage("System Excute Error!....");
			custResponse.setMessage(CommonUtils.getErrSubString(e,50));	//Option(To Detail Message)
		}
		
		modelAndView.setViewName("jsonView");
		modelAndView.addObject(custResponse);
		modelAndView.addObject("oper", oper);
		modelAndView.addObject("good_Iden_Numb", goodIdenNumb);
		return modelAndView;
	}
	
	@RequestMapping("displayGoodListJQGrid.sys")
	public ModelAndView displayGoodListJQGrid(
			@RequestParam(value = "page", defaultValue = "1") int page,
			@RequestParam(value = "rows", defaultValue = "30") int rows,
			@RequestParam(value = "sidx", defaultValue = "DISP_GOOD_ID") String sidx,
			@RequestParam(value = "sord", defaultValue = "DESC") String sord,
			@RequestParam(value = "goodIdenNumb", defaultValue = "0") String goodIdenNumb,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("goodIdenNumb", goodIdenNumb);
		params.put("finalGoodSts", "1");
		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
		
		List<ProductDto> list = null;
		int records = 0;
		int total = 0;
		if(!"".equals(goodIdenNumb)) {
			/*----------------페이징 세팅------------*/
	        records = productSvc.getDisplayGoodListCnt(params);
	        total = (int)Math.ceil((float)records / (float)rows);
	        
	        /*----------------조회------------*/
	        if(records>0) {
	        	list = productSvc.getDisplayGoodList(params, page, rows);
	        }
        }
		modelAndView = new ModelAndView("jsonView");
		modelAndView.setViewName("jsonView");
		modelAndView.addObject("page", page);
		modelAndView.addObject("total", total);
		modelAndView.addObject("records", records);
		modelAndView.addObject("list3", list);

		return modelAndView;
	}
	
	@RequestMapping("displayGoodHistListJQGrid.sys")
	public ModelAndView displayGoodHistListJQGrid(
			@RequestParam(value = "sidx", defaultValue = "DISP_GOOD_ID") String sidx,
			@RequestParam(value = "sord", defaultValue = "DESC") String sord,
			@RequestParam(value = "goodIdenNumb", defaultValue = "0") String goodIdenNumb,
			@RequestParam(value = "groupId", defaultValue = "0") String groupId,
			@RequestParam(value = "clientId", defaultValue = "0") String clientId,
			@RequestParam(value = "branchId", defaultValue = "0") String branchId,
			@RequestParam(value = "vendorId", defaultValue = "") String vendorId,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		/*----------------조회조건 세팅------------*/
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("goodIdenNumb", CommonUtils.stringParseInt(goodIdenNumb, 0));
		params.put("groupId", groupId);
		params.put("clientId", clientId);
		params.put("branchId", branchId);
		params.put("vendorId", vendorId);
		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
		
        /*----------------조회------------*/
		List<ProductDto> list = productSvc.getDisplayGoodHistList(params);

		modelAndView = new ModelAndView("jsonView");
		modelAndView.setViewName("jsonView");
		modelAndView.addObject("productSalePriceHistDivList", list);
		return modelAndView;
	}
	
	@RequestMapping("displayGoodTrans.sys")
	public ModelAndView displayGoodTrans(
			@RequestParam(value = "oper", defaultValue = "") String oper,
			@RequestParam(value = "disp_Good_Id", defaultValue = "0") String dispGoodId,
			@RequestParam(value = "good_Iden_Numb", defaultValue = "0") String goodIdenNumb,
			@RequestParam(value = "groupId", defaultValue = "0") String groupId,
			@RequestParam(value = "clientId", defaultValue = "0") String clientId,
			@RequestParam(value = "branchId", defaultValue = "0") String branchId,
			@RequestParam(value = "cont_From_Date", defaultValue = "") String contFromDate,
			@RequestParam(value = "cont_To_Date", defaultValue = "") String contToDate,
			@RequestParam(value = "ispast_Sell_Flag", defaultValue = "1") String ispastSellFlag,
			@RequestParam(value = "ref_Good_Seq", defaultValue = "0") String refGoodSeq,
			@RequestParam(value = "sell_Price", defaultValue = "0.0") String sellPrice,
			@RequestParam(value = "before_Price", defaultValue = "0.0") String beforePrice,
			@RequestParam(value = "sale_Unit_Pric", defaultValue = "0.0") String saleUnitPric,
			@RequestParam(value = "cust_Good_Iden_Numb", defaultValue = "") String custGoodIdenNumb,
			@RequestParam(value = "vendorId", defaultValue = "") String vendorId,
			ModelAndView modelAndView, HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		//boolean prodApprovalFlag = Constances.PROD_APPROVAL_FLAG;
		
		/*----------------저장값 세팅------------*/
		LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		Map<String,Object> saveMap = new HashMap<String,Object>();
		saveMap.put("oper", oper);
		saveMap.put("dispGoodId", CommonUtils.stringParseInt(dispGoodId, 0));
		saveMap.put("goodIdenNumb", CommonUtils.stringParseInt(goodIdenNumb, 0));
		saveMap.put("groupId", groupId);
		saveMap.put("clientId", clientId);
		saveMap.put("branchId", branchId);
		saveMap.put("contFromDate", contFromDate);
		saveMap.put("contToDate", contToDate);
		saveMap.put("refGoodSeq", CommonUtils.stringParseInt(refGoodSeq, 0));
		saveMap.put("sellPrice", CommonUtils.stringParseDouble(sellPrice, 0.0));
		saveMap.put("beforePrice", CommonUtils.stringParseDouble(beforePrice, 0.0));
		saveMap.put("saleUnitPric", CommonUtils.stringParseDouble(saleUnitPric, 0.0));
		saveMap.put("custGoodIdenNumb", custGoodIdenNumb);
		saveMap.put("vendorId", vendorId);
		String changeReason = "";
		if("add".equals(oper)) {
			ispastSellFlag = "1";
			changeReason = "판매단가등록";
		} else if("edit".equals(oper)) {
			changeReason = "판매단가변경";
		}
		saveMap.put("ispastSellFlag", ispastSellFlag);
		saveMap.put("changeReason", changeReason);
		saveMap.put("registerUserid", loginUserDto.getUserId());
		
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		try {
			productSvc.setDispProductAddRow(saveMap, modelAndView);
			
//			if("add".equals(oper)) {	//추가
//				int records = productSvc.getDispProductListCnt(saveMap);
//				
//				if(records>0) {
//					modelAndView.addObject("msg", "이미 등록된 판가정보입니다.");
//				} else {
//					productSvc.regDisplayGoodAppGoodPrice(saveMap);
//					
//					if(!prodApprovalFlag) {
//						productSvc.appDisplayGoodAppGoodPrice(saveMap);
//					}
//					modelAndView.addObject("msg", "등록 되었습니다.");
//				}
//			} else if("edit".equals(oper)) {	//수정
//				//productSvc.regDisplayGoodAppGoodPrice(saveMap);
//				if(!prodApprovalFlag) {
//					//productSvc.modDisplayGoodAppGoodPrice(saveMap);
//				}
//				modelAndView.addObject("msg", "수정 되었습니다.");
//			}
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
	
	
	@RequestMapping("displayGoodUpdateTrans.sys")
	public ModelAndView displayGoodUpdateTrans(
			@RequestParam(value = "dispGoodIdArray[]") String[] dispGoodIdArray,
			@RequestParam(value = "ispastSellFlagArray[]") String[] ispastSellFlagArray,
			ModelAndView modelAndView, HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		/*----------------저장값 세팅------------*/
		Map<String,Object> params = new HashMap<String,Object>();
		params.put("dispGoodIdArray", dispGoodIdArray);
		params.put("ispastSellFlagArray", ispastSellFlagArray);
		
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		try {
			productSvc.displayGoodUpdateTrans(params); 
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
	
	@RequestMapping("productRegist.sys")
	public ModelAndView productRegist(
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		modelAndView.setViewName("product/product/productAdmReg");
		modelAndView.addObject("deliAreaCodeList"	, commonSvc.getCodeList("DELI_AREA_CODE", 1)	);
		modelAndView.addObject("vTaxTypeCode"		, commonSvc.getCodeList("VTAXTYPECODE", 1)		);
		modelAndView.addObject("orderGoodsType"		, commonSvc.getCodeList("ORDERGOODSTYPE", 1)	);
		modelAndView.addObject("orderUnit"			, commonSvc.getCodeList("ORDERUNIT", 1)			);
		modelAndView.addObject("reqAppSts"			, commonSvc.getCodeList("REQAPPSTATE", 1)			);
		modelAndView.addObject("isdistributeSts"	, commonSvc.getCodeList("ISDISTRIBUTE", 1)			);
		return modelAndView;
	}
	
	@RequestMapping("productRequestRegistList.sys")
	public ModelAndView productRequestRegistList(
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		return new ModelAndView("product/product/productRequestRegistList");
	}
	
	@RequestMapping("productRequestRegistDetail.sys")
	public ModelAndView productRequestRegistDetail(
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		return new ModelAndView("product/product/productRequestRegistDetail");
	}
	
	@RequestMapping("productRequestDiscontinuanceList.sys")
	public ModelAndView productRequestDiscontinuanceList(
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		return new ModelAndView("product/product/productRequestDiscontinuanceList");
	}
	
	/**
	 * 상품종료요청 검색
	 */
	@RequestMapping("productRequestDiscontinuanceListJQGrid.sys")
	public ModelAndView productRequestDiscontinuanceListJQGrid(
			@RequestParam(value = "page", defaultValue = "1") int page,
			@RequestParam(value = "rows", defaultValue = "30") int rows,
			@RequestParam(value = "sidx", defaultValue = "fix_Good_Id") String sidx,
			@RequestParam(value = "sord", defaultValue = "desc") String sord,
			@RequestParam(value = "srcVendorId", defaultValue = "") String srcVendorId,
			@RequestParam(value = "srcGoodName", defaultValue = "") String srcGoodName,
			@RequestParam(value = "srcInsertStartDate", defaultValue = "") String srcInsertStartDate,
			@RequestParam(value = "srcInsertEndDate", defaultValue = "") String srcInsertEndDate,
			@RequestParam(value = "srcAppltFixCode", defaultValue = "") String srcAppltFixCode,
			@RequestParam(value = "srcFixAppSts", defaultValue = "") String srcFixAppSts,
			@RequestParam(value = "goodFixDate", required=true) String goodFixDate,
			@RequestParam(value = "goodClasCode", required=true) String goodClasCode,
			@RequestParam(value = "srcProductManager", defaultValue = "") String srcProductManager,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		//----------------조회조건 세팅------------/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("srcVendorId", srcVendorId);
		params.put("srcGoodName", srcGoodName);
		params.put("srcInsertStartDate", srcInsertStartDate);
		params.put("srcInsertEndDate", srcInsertEndDate);
		params.put("srcAppltFixCode", srcAppltFixCode);
		params.put("srcFixAppSts", srcFixAppSts);
		params.put("goodFixDate", goodFixDate);
		params.put("goodClasCode", goodClasCode);
		params.put("srcProductManager", srcProductManager);
		
		logger.debug("params value ["+params+"]");
		//----------------페이징 세팅------------/
		int records = productSvc.getProductRequestDiscontinuanceListCnt(params); //조회조건에 따른 카운트
        int total = (int)Math.ceil((float)records / (float)rows);
        
        String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
        
        //----------------조회------------/
        List<ProductDto> list = null;
        if(records>0) {
        	list = productSvc.getProductRequestDiscontinuanceList(params, page, rows);
        }
        
		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("page", page);
		modelAndView.addObject("total", total);
		modelAndView.addObject("records", records);
		modelAndView.addObject("list", list);
		return modelAndView;
	}
	
	/**
	 * 상품종료요청 검색 엑셀다운
	 */
	@RequestMapping("productRequestDiscontinuanceListExcel.sys")
	public ModelAndView productRequestDiscontinuanceListExcel(
			@RequestParam(value = "sidx", defaultValue = "fix_Good_Id") String sidx,
			@RequestParam(value = "sord", defaultValue = "desc") String sord,
			@RequestParam(value = "srcVendorId", defaultValue = "") String srcVendorId,
			@RequestParam(value = "srcGoodName", defaultValue = "") String srcGoodName,
			@RequestParam(value = "srcInsertStartDate", defaultValue = "") String srcInsertStartDate,
			@RequestParam(value = "srcInsertEndDate", defaultValue = "") String srcInsertEndDate,
			@RequestParam(value = "srcAppltFixCode", defaultValue = "") String srcAppltFixCode,
			@RequestParam(value = "srcFixAppSts", defaultValue = "") String srcFixAppSts,
			@RequestParam(value = "goodFixDate", defaultValue = "") String goodFixDate,
			@RequestParam(value = "goodClasCode", defaultValue = "") String goodClasCode,
			@RequestParam(value = "srcProductManager", defaultValue = "") String srcProductManager,
			
			@RequestParam(value = "sheetTitle", defaultValue = "") String sheetTitle,
			@RequestParam(value = "excelFileName", defaultValue = "") String excelFileName,
			@RequestParam(value = "colLabels", required = false) String[] colLabels,
			@RequestParam(value = "colIds", required = false) String[] colIds,
			@RequestParam(value = "numColIds", required = false) String[] numColIds,	
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		//----------------조회조건 세팅------------/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("srcVendorId", srcVendorId);
		params.put("srcGoodName", srcGoodName);
		params.put("srcInsertStartDate", srcInsertStartDate);
		params.put("srcInsertEndDate", srcInsertEndDate);
		params.put("srcAppltFixCode", srcAppltFixCode);
		params.put("srcFixAppSts", srcFixAppSts);
		params.put("goodFixDate", goodFixDate);
		params.put("goodClasCode", goodClasCode);
		params.put("srcProductManager", srcProductManager);
		
		logger.debug("params value ["+params+"]");
		//----------------페이징 세팅------------/
		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
		
		//----------------조회------------/
		List<ProductDto> list = productSvc.getProductRequestDiscontinuanceList(params, 1, RowBounds.NO_ROW_LIMIT);
		
		List<Map<String, Object>> colDataList = null;
		if(list != null && list.size() > 0){
			Map<String, Object> rtnData = null;
			colDataList = new ArrayList<Map<String, Object>>();
			for(int i = 0; i < list.size() ; i++){
				
				String app_Sts = "";
				if("0".equals(list.get(i).getFix_App_Sts()))		app_Sts = "요청";
				else if("1".equals(list.get(i).getFix_App_Sts()))	app_Sts = "확인_품의요청";
				else if("2".equals(list.get(i).getFix_App_Sts()))	app_Sts = "승인_처리완료+";
				else if("3".equals(list.get(i).getFix_App_Sts()))	app_Sts = "반려";
				String applt_Fix_Code = "";
				if("20".equals(list.get(i).getApplt_Fix_Code() ) )		applt_Fix_Code = "매입단가변경";
				else if("30".equals(list.get(i).getApplt_Fix_Code() ) )	applt_Fix_Code = "종료요청";
			
				rtnData = new HashMap<String, Object>();
				rtnData.put("fix_Good_Id",		list.get(i).getFix_Good_Id());
				rtnData.put("good_Name",		list.get(i).getGood_Name());
				rtnData.put("good_Iden_Numb",	list.get(i).getGood_Iden_Numb());
				rtnData.put("sale_Unit_Pric",	list.get(i).getSale_Unit_Pric());
				rtnData.put("price",			list.get(i).getPrice());
				
				rtnData.put("target_price", list.get(i).getTarget_price());
				rtnData.put("sale_price", list.get(i).getSale_price());
				rtnData.put("sell_Price", list.get(i).getSell_Price());
				rtnData.put("buy_rate", list.get(i).getBuy_rate());
				
				rtnData.put("apply_Desc",		list.get(i).getApply_Desc());
				rtnData.put("app_Sts",			app_Sts);
				rtnData.put("insert_User_Nm",	list.get(i).getInsert_User_Nm());
				rtnData.put("insert_Date",		list.get(i).getInsert_Date());
				rtnData.put("vendorId",			list.get(i).getVendorId());
				rtnData.put("good_Clas_Code",	list.get(i).getGood_Clas_Code());
				rtnData.put("vendorNm",			list.get(i).getVendorNm());
				rtnData.put("app_User_Id",		list.get(i).getApp_User_Id());
				rtnData.put("app_Date",			list.get(i).getApp_Date());
				rtnData.put("applt_Fix_Code",		applt_Fix_Code);
				rtnData.put("product_manager",		list.get(i).getProduct_manager());
				colDataList.add(rtnData);
			}
		}			
		
        List<Map<String, Object>> sheetList = new ArrayList<Map<String, Object>>();
        Map<String, Object> map1 = new HashMap<String, Object>();
        map1.put("sheetTitle", sheetTitle);
        map1.put("colLabels", colLabels);
        map1.put("colIds", colIds);
        map1.put("numColIds", numColIds);
//        map1.put("figureColIds", figureColIds);
        map1.put("colDataList", colDataList);
        sheetList.add(map1);
        modelAndView.setViewName("commonExcelViewResolver");
        modelAndView.addObject("excelFileName", excelFileName);
        modelAndView.addObject("sheetList", sheetList);
		
//		modelAndView.addObject("sheetTitle", sheetTitle);
//		modelAndView.addObject("excelFileName", excelFileName);
//		modelAndView.addObject("colLabels", colLabels);
//		modelAndView.addObject("colIds", colIds);
//		modelAndView.addObject("numColIds", numColIds);
//		modelAndView.addObject("colDataList", colDataList);
//		modelAndView.setViewName("commonExcelViewResolver");
		return modelAndView;			
	}
	
	/**
	 * 공급사품목변경 상태값 변경
	 */
	@RequestMapping("productRequestDiscontinuanceStatusTransGrid.sys")
	public ModelAndView productRequestDiscontinuanceStatusTransGrid(
			@RequestParam(value = "fix_good_id_array[]", required=true) String[] fix_good_id_array, //요청Seq
			@RequestParam(value = "good_iden_numb_array[]", required=true) String[] good_iden_numb_array, //상품코드
			@RequestParam(value = "vendorid_array[]", required=true) String[] vendorid_array, //공급사Id
			@RequestParam(value = "applt_fix_code_array[]", required=true) String[] applt_fix_code_array, //변경구분
			@RequestParam(value = "sale_unit_pric_array[]", required=true) String[] sale_unit_pric_array, //기존단가
			@RequestParam(value = "price_array[]", required=true) String[] price_array, //변경요청매입단가
			@RequestParam(value = "apply_desc_array[]", required=true) String[] apply_desc_array, //요청사유
			@RequestParam(value = "insert_user_id_array[]", required=true) String[] insert_user_id_array, //등록자Id
			@RequestParam(value = "insert_date_array[]", required=true) String[] insert_date_array, //등록일d
			@RequestParam(value = "target_price_array[]", required=true) String[] target_price_array, //변경예정판매가
			@RequestParam(value = "cancel_reason", defaultValue = "") String cancelReason, //반려(취소)사유
			@RequestParam(value = "fix_app_sts", defaultValue = "") String fixAppSts, //처리상태
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		/*----------------저장값 세팅----------*/
		LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		Map<String,Object> saveMap = new HashMap<String,Object>();
		saveMap.put("fix_good_id_array", fix_good_id_array);
		saveMap.put("good_iden_numb_array", good_iden_numb_array);
		saveMap.put("vendorid_array", vendorid_array);
		saveMap.put("applt_fix_code_array", applt_fix_code_array);
		saveMap.put("sale_unit_pric_array", sale_unit_pric_array);
		saveMap.put("price_array", price_array);
		saveMap.put("apply_desc_array", apply_desc_array);
		saveMap.put("insert_user_id_array", insert_user_id_array);
		saveMap.put("insert_date_array", insert_date_array);
		saveMap.put("target_price_array", target_price_array);
		saveMap.put("cancelReason", "[공급사요청] "+cancelReason);
		saveMap.put("fixAppSts", fixAppSts);
		saveMap.put("appUserId", loginUserDto.getUserId());
		saveMap.put("userInfoDto", loginUserDto);
		
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		try {
			productSvc.productRequestDiscontinuanceStatusTrans(saveMap); 
		} catch(Exception e) {
			logger.error("Exception : "+e);
			custResponse.setSuccess(false);
			custResponse.setMessage("System Excute Error!....");
			custResponse.setMessage(CommonUtils.getErrSubString(e,50));	//Option(To Detail Message)
		}
		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject(custResponse);
		return modelAndView;
	}
	
	/**
	 * 공급사 상품 조회  
	 */
	@RequestMapping("productVenList.sys")
	public ModelAndView venProductList(
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		modelAndView.setViewName("product/product/productVenList");
		return modelAndView;
	}
	
	/**
	 * 공급사 상품 변경요청 조회
	 */
	@RequestMapping("productVenReqList.sys")
	public ModelAndView productVenReqList(
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		modelAndView.setViewName("product/product/productVenReqList");
		return modelAndView;
	}
	
	/**
	 * 공급사 상품 검색 
	 */
	@RequestMapping("venProductListJQGrid.sys")
	public ModelAndView venProductListJQGrid(
			@RequestParam(value = "page", defaultValue = "1") int page,
			@RequestParam(value = "rows", defaultValue = "30") int rows,
			@RequestParam(value = "sidx", defaultValue = "good_Name") String sidx,
			@RequestParam(value = "sord", defaultValue = "desc") String sord,
			@RequestParam(value = "srcGoodIdenNumb", defaultValue = "") String srcGoodIdenNumb,
			@RequestParam(value = "srcGoodName", defaultValue = "") String srcGoodName,
			@RequestParam(value = "srcRegistStartDate", defaultValue = "") String srcRegistStartDate,
			@RequestParam(value = "srcRegistEndDate", defaultValue = "") String srcRegistEndDate,
			@RequestParam(value = "srcGoodSpecDesc", defaultValue = "") String srcGoodSpecDesc,
			@RequestParam(value = "srcGoodSameWord", defaultValue = "") String srcGoodSameWord,
			@RequestParam(value = "srcGoodClasCode", defaultValue = "") String srcGoodClasCode,
			@RequestParam(value = "srcVendorId", defaultValue = "") String srcVendorId,
			@RequestParam(value = "srcIsUse", defaultValue = "") String srcIsUse,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		
		try{
			//----------------조회조건 세팅------------/
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("srcGoodIdenNumb", srcGoodIdenNumb);
			params.put("srcGoodName", srcGoodName);
			params.put("srcRegistStartDate", srcRegistStartDate);
			params.put("srcRegistEndDate", srcRegistEndDate);
			params.put("srcGoodSpecDesc", srcGoodSpecDesc);
			params.put("srcGoodSameWord", srcGoodSameWord);
			params.put("srcGoodClasCode", srcGoodClasCode);
			params.put("srcVendorId", srcVendorId);
			params.put("srcIsUse", srcIsUse);
			logger.info("공급사 상품조회 파라미터: "+params);
			logger.debug("params value ["+params+"]");
			//----------------페이징 세팅------------/
			int records = productSvc.getVenProductListCnt(params); //조회조건에 따른 카운트
			int total = (int)Math.ceil((float)records / (float)rows);
			logger.info("공급사 상품조회 갯수: "+records);
			String orderString = " " + sidx + " " + sord + " ";
			params.put("orderString", orderString);
			
			//----------------조회------------/
			List<ProductDto> list = null;
			if(records>0) {
				list = productSvc.getVenProductList(params, page, rows);
				logger.info("공급사 상품조회 리스트 갯수: "+list .size());
				for(int i=0; i<list.size(); i++){
					//상품표준 규격
					String[] tmpGoodStSpecDescArr = new String[] {"","","","","",""};
					if(list.get(i).getGood_St_Spec_Desc() != null && list.get(i).getGood_St_Spec_Desc() != ""){
						String[] goodStSpecDescArr = list.get(i).getGood_St_Spec_Desc().split("‡");
						
						for(int j=0; j<goodStSpecDescArr.length; j++){
							tmpGoodStSpecDescArr[j] = goodStSpecDescArr[j];
//							
//							
						}
						goodStSpecDescArr = tmpGoodStSpecDescArr;
						list.get(i).setGoodStSpecDesc1(goodStSpecDescArr[0]);
						list.get(i).setGoodStSpecDesc2(goodStSpecDescArr[1]);
						list.get(i).setGoodStSpecDesc3(goodStSpecDescArr[2]);
						list.get(i).setGoodStSpecDesc4(goodStSpecDescArr[3]);
						list.get(i).setGoodStSpecDesc5(goodStSpecDescArr[4]);
						list.get(i).setGoodStSpecDesc6(goodStSpecDescArr[5]);
					}
					
					//상품규격
					String[] tmpGoodSpecDescArr = new String[] {"","","","","","","",""};
					if(list.get(i).getGood_Spec_Desc() != null && list.get(i).getGood_Spec_Desc() != ""){
						String[] goodSpecDescArr = list.get(i).getGood_Spec_Desc().split("‡");
						for(int j=0; j<goodSpecDescArr.length; j++){
							tmpGoodSpecDescArr[j] = goodSpecDescArr[j];
//							
//							
						}
						goodSpecDescArr = tmpGoodSpecDescArr;
						list.get(i).setGoodSpecDesc1(goodSpecDescArr[0]);
						list.get(i).setGoodSpecDesc2(goodSpecDescArr[1]);
						list.get(i).setGoodSpecDesc3(goodSpecDescArr[2]);
						list.get(i).setGoodSpecDesc4(goodSpecDescArr[3]);
						list.get(i).setGoodSpecDesc5(goodSpecDescArr[4]);
						list.get(i).setGoodSpecDesc6(goodSpecDescArr[5]);
						list.get(i).setGoodSpecDesc7(goodSpecDescArr[6]);
						list.get(i).setGoodSpecDesc8(goodSpecDescArr[7]);
					}
					
				}
			}
			
			modelAndView = new ModelAndView("jsonView");
			modelAndView.addObject("page", page);
			modelAndView.addObject("total", total);
			modelAndView.addObject("records", records);
			modelAndView.addObject("list", list);
			
			
		} catch(Exception e) {
			logger.error("Exception : "+e);
			custResponse.setSuccess(false);
			custResponse.setMessage("System Excute Error!....");
			custResponse.setMessage(CommonUtils.getErrSubString(e,50));	//Option(To Detail Message)
		}
		
		
		modelAndView.addObject(custResponse);
		return modelAndView;
	}
	
	
	
	
	/**
	 * 공급사 상품 검색 
	 */
	@RequestMapping("venProductListJQGrid2.sys")
	public ModelAndView venProductListJQGrid2(
			@RequestParam(value = "page", defaultValue = "1") int page,
			@RequestParam(value = "rows", defaultValue = "30") int rows,
			@RequestParam(value = "sidx", defaultValue = "good_Name") String sidx,
			@RequestParam(value = "sord", defaultValue = "desc") String sord,
			@RequestParam(value = "srcGoodIdenNumb", defaultValue = "") String srcGoodIdenNumb,
			@RequestParam(value = "srcGoodName", defaultValue = "") String srcGoodName,
			@RequestParam(value = "srcRegistStartDate", defaultValue = "") String srcRegistStartDate,
			@RequestParam(value = "srcRegistEndDate", defaultValue = "") String srcRegistEndDate,
			@RequestParam(value = "srcGoodSpecDesc", defaultValue = "") String srcGoodSpecDesc,
			@RequestParam(value = "srcGoodSameWord", defaultValue = "") String srcGoodSameWord,
			@RequestParam(value = "srcGoodClasCode", defaultValue = "") String srcGoodClasCode,
			@RequestParam(value = "srcVendorId", defaultValue = "") String srcVendorId,
			@RequestParam(value = "srcIsUse", defaultValue = "") String srcIsUse,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		
		try{
			//----------------조회조건 세팅------------/
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("srcGoodIdenNumb", srcGoodIdenNumb);
			params.put("srcGoodName", srcGoodName);
			params.put("srcRegistStartDate", srcRegistStartDate);
			params.put("srcRegistEndDate", srcRegistEndDate);
			params.put("srcGoodSpecDesc", srcGoodSpecDesc);
			params.put("srcGoodSameWord", srcGoodSameWord);
			params.put("srcGoodClasCode", srcGoodClasCode);
			params.put("srcVendorId", srcVendorId);
			params.put("srcIsUse", srcIsUse);
			logger.info("공급사 상품조회 파라미터: "+params);
			logger.debug("params value ["+params+"]");
			//----------------페이징 세팅------------/
			int records = productSvc.getVenProductListCnt(params); //조회조건에 따른 카운트
			int total = (int)Math.ceil((float)records / (float)rows);
			logger.info("공급사 상품조회 갯수: "+records);
			String orderString = " " + sidx + " " + sord + " ";
			params.put("orderString", orderString);
			
			//----------------조회------------/
			List<ProductDto> list = null;
			if(records>0) {
				list = productSvc.getVenProductList(params, page, rows);
				logger.info("공급사 상품조회 리스트 갯수: "+list .size());
				
				/*jameskang
				*/
			}
			
			modelAndView = new ModelAndView("jsonView");
			modelAndView.addObject("page", page);
			modelAndView.addObject("total", total);
			modelAndView.addObject("records", records);
			modelAndView.addObject("list", list);
			
			
		} catch(Exception e) {
			logger.error("Exception : "+e);
			custResponse.setSuccess(false);
			custResponse.setMessage("System Excute Error!....");
			custResponse.setMessage(CommonUtils.getErrSubString(e,50));	//Option(To Detail Message)
		}
		
		
		modelAndView.addObject(custResponse);
		return modelAndView;
	}
	
	
	
	/**
	 * 공급사 상품등록요청 검색 
	 */
	@RequestMapping("productRequestRegistListJQGrid.sys")
	public ModelAndView productRequestRegistListJQGrid(
			@RequestParam(value = "page", defaultValue = "1") int page,
			@RequestParam(value = "rows", defaultValue = "30") int rows,
			@RequestParam(value = "sidx", defaultValue = "good_Name") String sidx,
			@RequestParam(value = "sord", defaultValue = "desc") String sord,
			@RequestParam(value = "srcVendorId", defaultValue = "") String srcVendorId,
			@RequestParam(value = "srcGoodName", defaultValue = "") String srcGoodName,
			@RequestParam(value = "srcInsertStartDate", defaultValue = "") String srcInsertStartDate,
			@RequestParam(value = "srcInsertEndDate", defaultValue = "") String srcInsertEndDate,
			@RequestParam(value = "srcGoodSpecDesc", defaultValue = "") String srcGoodSpecDesc,
			@RequestParam(value = "srcAdminUserId", defaultValue = "") String srcAdminUserId,
			@RequestParam(value = "srcAppSts", defaultValue = "") String srcAppSts,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		//----------------조회조건 세팅------------/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("srcVendorId", srcVendorId);
		params.put("srcGoodName", srcGoodName);
		params.put("srcInsertStartDate", srcInsertStartDate);
		params.put("srcInsertEndDate", srcInsertEndDate);
		params.put("srcGoodSpecDesc", srcGoodSpecDesc);
		params.put("srcAdminUserId", srcAdminUserId);
		params.put("srcAppSts", srcAppSts);
		
		logger.debug("params value ["+params+"]");
		//----------------페이징 세팅------------/
		int records = productSvc.getProductRequestRegistListCnt(params); //조회조건에 따른 카운트
        int total = (int)Math.ceil((float)records / (float)rows);
        
        String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
        
        //----------------조회------------/
        List<ProductDto> list = null;
        if(records>0) {
        	list = productSvc.getProductRequestRegistList(params, page, rows);
        }
        
		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("page", page);
		modelAndView.addObject("total", total);
		modelAndView.addObject("records", records);
		modelAndView.addObject("list", list);
		return modelAndView;
	}
	
	/**
	 * 공급사 상품등록요청 검색 엑셀 다운
	 */
	@RequestMapping("productRequestRegistListExcel.sys")
	public ModelAndView productRequestRegistListExcel(
			@RequestParam(value = "sidx", defaultValue = "good_Name") String sidx,
			@RequestParam(value = "sord", defaultValue = "desc") String sord,
			@RequestParam(value = "srcVendorId", defaultValue = "") String srcVendorId,
			@RequestParam(value = "srcGoodName", defaultValue = "") String srcGoodName,
			@RequestParam(value = "srcInsertStartDate", defaultValue = "") String srcInsertStartDate,
			@RequestParam(value = "srcInsertEndDate", defaultValue = "") String srcInsertEndDate,
			@RequestParam(value = "srcGoodSpecDesc", defaultValue = "") String srcGoodSpecDesc,
			@RequestParam(value = "srcAdminUserId", defaultValue = "") String srcAdminUserId,
			@RequestParam(value = "srcAppSts", defaultValue = "") String srcAppSts,
			
			@RequestParam(value = "sheetTitle", defaultValue = "") String sheetTitle,
			@RequestParam(value = "excelFileName", defaultValue = "") String excelFileName,
			@RequestParam(value = "colLabels", required = false) String[] colLabels,
			@RequestParam(value = "colIds", required = false) String[] colIds,
			@RequestParam(value = "numColIds", required = false) String[] numColIds,	
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		//----------------조회조건 세팅------------/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("srcVendorId", srcVendorId);
		params.put("srcGoodName", srcGoodName);
		params.put("srcInsertStartDate", srcInsertStartDate);
		params.put("srcInsertEndDate", srcInsertEndDate);
		params.put("srcGoodSpecDesc", srcGoodSpecDesc);
		params.put("srcAdminUserId", srcAdminUserId);
		params.put("srcAppSts", srcAppSts);
		params.put("isExcel", 1);
		
		logger.debug("params value ["+params+"]");
		
		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
		
		//----------------조회------------/
		List<ProductDto> list = productSvc.getProductRequestRegistList(params, 1, RowBounds.NO_ROW_LIMIT);
		
		List<Map<String, Object>> colDataList = null;
		if(list != null && list.size() > 0){
			Map<String, Object> rtnData = null;
			colDataList = new ArrayList<Map<String, Object>>();
			
			for(int i = 0; i < list.size() ; i++){
				rtnData = new HashMap<String, Object>();
				
				rtnData.put("req_Good_Id"	, list.get(i).getReq_Good_Id());
				rtnData.put("good_Name"     , list.get(i).getGood_Name());
				rtnData.put("vendorNm"     , list.get(i).getVendorNm());
				rtnData.put("good_Spec_Desc", list.get(i).getGood_Spec_Desc());
				rtnData.put("good_Iden_Numb", list.get(i).getGood_Iden_Numb());
				rtnData.put("sale_Unit_Pric", list.get(i).getSale_Unit_Pric());
				rtnData.put("orde_Clas_Code", list.get(i).getOrde_Clas_Code());
				rtnData.put("deli_Mini_Day" , list.get(i).getDeli_Mini_Day());
				rtnData.put("deli_Mini_Quan", list.get(i).getDeli_Mini_Quan());
				rtnData.put("make_Comp_Name", list.get(i).getMake_Comp_Name());
				rtnData.put("app_Sts"       , list.get(i).getApp_Sts());
				rtnData.put("insert_Date"   , list.get(i).getInsert_Date());
				colDataList.add(rtnData);
			}
		}
		
        List<Map<String, Object>> sheetList = new ArrayList<Map<String, Object>>();
        Map<String, Object> map1 = new HashMap<String, Object>();
        map1.put("sheetTitle", sheetTitle);
        map1.put("colLabels", colLabels);
        map1.put("colIds", colIds);
        map1.put("numColIds", numColIds);
//        map1.put("figureColIds", figureColIds);
        map1.put("colDataList", colDataList);
        sheetList.add(map1);
        modelAndView.setViewName("commonExcelViewResolver");
        modelAndView.addObject("excelFileName", excelFileName);
        modelAndView.addObject("sheetList", sheetList);
		
//		modelAndView.addObject("sheetTitle", sheetTitle);
//		modelAndView.addObject("excelFileName", excelFileName);
//		modelAndView.addObject("colLabels", colLabels);
//		modelAndView.addObject("colIds", colIds);
//		modelAndView.addObject("numColIds", numColIds);
//		modelAndView.addObject("colDataList", colDataList);
//		modelAndView.setViewName("commonExcelViewResolver");
		return modelAndView;			
	}
	
	@RequestMapping("venProductDetail.sys")
	public ModelAndView venProductDetail(
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		return new ModelAndView("product/product/venProductDetail");
	}
	
	@RequestMapping("venProductRegist.sys")
	public ModelAndView venProductRegist(
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		modelAndView.addObject("orderGoodsType"		, commonSvc.getCodeList("ORDERGOODSTYPE", 1)	);
		modelAndView.addObject("orderUnit"			, commonSvc.getCodeList("ORDERUNIT", 1)			);
		modelAndView.addObject("deliAreaCodeList"	, commonSvc.getCodeList("DELI_AREA_CODE", 1)	);
		modelAndView.addObject("reqAppSts"			, commonSvc.getCodeList("REQAPPSTATE", 1)			);		
		modelAndView.setViewName("product/product/venProductRegist");
		return modelAndView;
	}
	
	@RequestMapping("venProductRequestRegistList.sys")
	public ModelAndView venProductRequestRegistList(
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		return new ModelAndView("product/product/productRequestRegistList");
	}
	
	@RequestMapping("venProductRequestDiscontinuanceList.sys")
	public ModelAndView venProductRequestDiscontinuanceList(
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		return new ModelAndView("product/product/productRequestDiscontinuanceList");
	}
	
	
	
	/*----------------공급사 끝------------*/
	
	/*----------------고객사 시작------------*/
	@RequestMapping("buyProductSearch.sys")
	public ModelAndView buyProductSearch(
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
		return new ModelAndView("product/product/buyProductSearch");
	}
	
	//고객사 상품검색 테스트 페이지 비트큐브 임상건 2014-05-15
	@RequestMapping("buyProductSearchPriority.sys")
	public ModelAndView buyProductSearchPriority(
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
		return new ModelAndView("product/product/buyProductSearchPriority");
	}
	
	
	@RequestMapping("buyProductListJQGrid.sys")
	public ModelAndView buyProductRequestRegistList(
			@RequestParam(value = "page"	            , defaultValue = "1") 	int page,
			@RequestParam(value = "rows"	            , defaultValue = "30") 	int rows,
			@RequestParam(value = "sidx"	            , defaultValue = "") 	String sidx,
			@RequestParam(value = "sord"	            , defaultValue = "") 	String sord,
			@RequestParam(value = "srcCateId"			, defaultValue = "0") String srcCateId,
			@RequestParam(value = "srcGoodName"			, defaultValue = "") String srcGoodName,
			@RequestParam(value = "srcGoodIdenNumb"		, defaultValue = "") String srcGoodIdenNumb,
			@RequestParam(value = "srcCustGoodIdenNumb"	, defaultValue = "") String srcCustGoodIdenNumb, 
			@RequestParam(value = "srcGoodSpecDesc"		, defaultValue = "") String srcGoodSpecDesc,
			@RequestParam(value = "srcGoodSameWord"		, defaultValue = "") String srcGoodSameWord,
			@RequestParam(value = "srcPopularityProduct", defaultValue = "") String srcPopularityProduct,
			@RequestParam(value = "srcVendorNm", defaultValue = "") String srcVendorNm,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		
		logger.debug("page                 value ["+page                +"]");
		logger.debug("rows                 value ["+rows                +"]");
		logger.debug("sidx                 value ["+sidx                +"]");
		logger.debug("sord                 value ["+sord                +"]");
		logger.debug("srcCateId            value ["+srcCateId           +"]");
		logger.debug("srcGoodName          value ["+srcGoodName         +"]");
		logger.debug("srcGoodIdenNumb      value ["+srcGoodIdenNumb     +"]");
		logger.debug("srcCustGoodIdenNumb  value ["+srcCustGoodIdenNumb +"]");
		logger.debug("srcGoodSpecDesc      value ["+srcGoodSpecDesc     +"]");
		logger.debug("srcGoodSameWord      value ["+srcGoodSameWord     +"]");
		logger.debug("srcPopularityProduct value ["+srcPopularityProduct+"]");
		
		
		LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("groupid"  			, loginUserDto.getGroupId() );
		params.put("clientid" 			, loginUserDto.getClientId() ); 
		params.put("branchid" 			, loginUserDto.getBorgId()); 
		params.put("srcCateId"				, CommonUtils.stringParseInt(srcCateId, 0)); 
		params.put("srcGoodName"			, srcGoodName			); 
		params.put("srcGoodIdenNumb"		, srcGoodIdenNumb		); 
		params.put("srcCustGoodIdenNumb"	, srcCustGoodIdenNumb); 
		params.put("srcGoodSpecDesc"		, srcGoodSpecDesc		); 
		params.put("srcGoodSameWord"		, srcGoodSameWord		); 
		params.put("srcAreaType"			, loginUserDto.getAreaType());
		params.put("srcVendorNm"			, srcVendorNm);
		
		
		String orderString = "";
		
		if(srcPopularityProduct.equals("check")){
			orderString = " order_cnt desc ";
		}else {
			if(sidx.length() > 0 ){
				orderString = " " + sidx + " " + sord + " ";
			}
		}
		params.put("orderString", orderString);
		
		/*----------------페이징 세팅------------*/
		
		int records = productSvc.getBuyProductSearchCnt(params); //조회조건에 따른 카운트
        int total = (int)Math.ceil((float)records / (float)rows);
		
        /*----------------조회------------*/
        List<BuyProductDto> list = null;  
        if(records>0) {
        	list = productSvc.getBuyProductSearchList(params, page, rows);
        }
        
        modelAndView.setViewName("jsonView");
        
		modelAndView.addObject("page"	, page);
		modelAndView.addObject("total"	, total);
		modelAndView.addObject("records", records);
		modelAndView.addObject("list"	, list);
		return modelAndView;
	}
	
	@RequestMapping("buyProductListJQGridPriority.sys") //고객사 상품검색 테스트 페이지 비트큐브 임상건 2014-05-15
	public ModelAndView buyProductListJQGridPriority(
			@RequestParam(value = "page"	            , defaultValue = "1") 	int page,
			@RequestParam(value = "rows"	            , defaultValue = "30") 	int rows,
			@RequestParam(value = "sidx"	            , defaultValue = "") 	String sidx,
			@RequestParam(value = "sord"	            , defaultValue = "") 	String sord,
			@RequestParam(value = "srcCateId"			, defaultValue = "0") String srcCateId,
			@RequestParam(value = "srcGoodName"			, defaultValue = "") String srcGoodName,
			@RequestParam(value = "srcGoodIdenNumb"		, defaultValue = "") String srcGoodIdenNumb,
			@RequestParam(value = "srcCustGoodIdenNumb"	, defaultValue = "") String srcCustGoodIdenNumb, 
			@RequestParam(value = "srcGoodSpecDesc"		, defaultValue = "") String srcGoodSpecDesc,
			@RequestParam(value = "srcGoodSameWord"		, defaultValue = "") String srcGoodSameWord,
			@RequestParam(value = "srcPopularityProduct", defaultValue = "") String srcPopularityProduct,
			@RequestParam(value = "srcVendorNm", defaultValue = "") String srcVendorNm,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		
		logger.debug("page                 value ["+page                +"]");
		logger.debug("rows                 value ["+rows                +"]");
		logger.debug("sidx                 value ["+sidx                +"]");
		logger.debug("sord                 value ["+sord                +"]");
		logger.debug("srcCateId            value ["+srcCateId           +"]");
		logger.debug("srcGoodName          value ["+srcGoodName         +"]");
		logger.debug("srcGoodIdenNumb      value ["+srcGoodIdenNumb     +"]");
		logger.debug("srcCustGoodIdenNumb  value ["+srcCustGoodIdenNumb +"]");
		logger.debug("srcGoodSpecDesc      value ["+srcGoodSpecDesc     +"]");
		logger.debug("srcGoodSameWord      value ["+srcGoodSameWord     +"]");
		logger.debug("srcPopularityProduct value ["+srcPopularityProduct+"]");
		
		
		LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("groupid"  			, loginUserDto.getGroupId() );
		params.put("clientid" 			, loginUserDto.getClientId() );
		params.put("branchid" 			, loginUserDto.getBorgId()); 
		params.put("srcCateId"				, CommonUtils.stringParseInt(srcCateId, 0)); 
		params.put("srcGoodName"			, srcGoodName			); 
		params.put("srcGoodIdenNumb"		, srcGoodIdenNumb		); 
		params.put("srcCustGoodIdenNumb"	, srcCustGoodIdenNumb); 
		params.put("srcGoodSpecDesc"		, srcGoodSpecDesc		); 
		params.put("srcGoodSameWord"		, srcGoodSameWord		); 
		params.put("srcAreaType"			, loginUserDto.getAreaType());
		params.put("srcVendorNm"			, srcVendorNm);
		
		String orderString = "";
		
		if(srcPopularityProduct.equals("check")){
			orderString = "";//" order_cnt desc ";
		}else {
			if(sidx.length() > 0 ){
				orderString = " " + sidx + " " + sord + " ";
			}
		}
		params.put("orderString", orderString);
		
		/*----------------페이징 세팅------------*/
		
		int records = productSvc.getBuyProductSearchCntPriority(params); //조회조건에 따른 카운트
        int total = (int)Math.ceil((float)records / (float)rows);
		
        /*----------------조회------------*/
        List<BuyProductDto> list = null;
        List<BuyProductDto> tmplist = null;
        if(records>0) {
        	list = productSvc.getBuyProductSearchListPriority(params, page, rows);
        	
        	//상품에 대한 상품공급사의 모든 정보를 불러와서 JqGrid에 임시 컬럼에 담는다. 2014-05-19 비트큐브 임상건        	
        	if(list != null && list.size() > 0){
	        	for(int i = 0; i < list.size() ; i++){
	        		String tmpGood_iden_numb =  list.get(i).getGood_iden_numb();
	        		Map<String, Object> tempparams = new HashMap<String, Object>();
	        		tempparams.put("tmpGoodIdenNumb" , tmpGood_iden_numb );
	        		
	        		tmplist = productSvc.getBuyProductListTemp(tempparams);
	        		
	        		if(tmplist != null && tmplist.size() > 0){
	        			String tmpBorgNm = "";
	                	String tmpVendorId = "";
	                	String tmpGoodStSpecDesc = "";	                	
						String tmpGoodSpecDesc = "";
						String tmpSmallImgPath = "";
						String tmpOrdeClasCode = "";
						String tmpGoodSameWord = "";
						String tmpDeliMiniQuan = "";
						String tmpDeliMiniDay  = "";
						String tmpOrderCnt = "";
						String tmpGoodInventoryCnt = "";
						String tmpGoodClasCode = "";
						String tmpOriginalImgPath = "";
						String tmpDispGoodId = "";
	                	
	    	        	for(int j = 0; j < tmplist.size() ; j++){
	    	        		tmpBorgNm += tmplist.get(j).getBorgnm() + "|";
	    	        		tmpVendorId += tmplist.get(j).getVendorid() + "|";
	    	        		tmpGoodStSpecDesc += tmplist.get(j).getGood_st_spec_desc() + "|";
	    	        		
	    	        		tmpGoodSpecDesc += tmplist.get(j).getGood_spec_desc() + "|";
							tmpSmallImgPath += tmplist.get(j).getSmall_img_path() + "|";
							tmpOrdeClasCode += tmplist.get(j).getOrde_clas_code() + "|";
							tmpGoodSameWord += tmplist.get(j).getGood_same_word() + "|";
							tmpDeliMiniQuan += tmplist.get(j).getDeli_mini_quan() + "|";
							tmpDeliMiniDay  += tmplist.get(j).getDeli_mini_day() + "|";
							tmpOrderCnt += tmplist.get(j).getOrder_cnt() + "|";
							tmpGoodInventoryCnt += tmplist.get(j).getGood_inventory_cnt() + "|";
							tmpGoodClasCode += tmplist.get(j).getGood_clas_code() + "|";
							tmpOriginalImgPath += tmplist.get(j).getOriginal_img_path() + "|";
							tmpDispGoodId += tmplist.get(j).getDisp_good_id() + "|";
	    	        	}
	    	        	list.get(i).setTmpborgnm(tmpBorgNm);	    	        	
	    	        	list.get(i).setTmpvendorid(tmpVendorId);
	    	        	list.get(i).setTmpgood_st_spec_desc(tmpGoodStSpecDesc);
	    	        	
	    	        	list.get(i).setTmpgood_spec_desc(tmpGoodSpecDesc);
	    	        	list.get(i).setTmpsmall_img_path(tmpSmallImgPath);
	    	        	list.get(i).setTmporde_clas_code(tmpOrdeClasCode);
	    	        	list.get(i).setTmpgood_same_word(tmpGoodSameWord);
	    	        	list.get(i).setTmpdeli_mini_quan(tmpDeliMiniQuan);
	    	        	list.get(i).setTmpdeli_mini_day(tmpDeliMiniDay);
	    	        	list.get(i).setTmporder_cnt(tmpOrderCnt);
	    	        	list.get(i).setTmpgood_inventory_cnt(tmpGoodInventoryCnt);
	    	        	list.get(i).setTmpgood_clas_code(tmpGoodClasCode);
	    	        	list.get(i).setTmporiginal_img_path(tmpOriginalImgPath);
	    	        	list.get(i).setTmpdisp_good_id(tmpDispGoodId);
	    	        	tmplist = null;
	        		}
	        		//logger.debug("tmpBorgNm : " + tmpBorgNm + "			");
	        		
	        		
	        	}	        		        	
        	}
        	//상품에 대한 상품공급사의 모든 정보를 불러와서 JqGrid에 임시 컬럼에 담는다. 2014-05-19 비트큐브 임상건
        }
        
        modelAndView.setViewName("jsonView");
        
		modelAndView.addObject("page"	, page);
		modelAndView.addObject("total"	, total);
		modelAndView.addObject("records", records);
		modelAndView.addObject("list"	, list);
		return modelAndView;
	}
	
	@RequestMapping("buyProductListAdmJQGrid.sys")
	public ModelAndView buyProductListAdmJQGrid(
			@RequestParam(value = "page"	            , defaultValue = "1") 	int page,
			@RequestParam(value = "rows"	            , defaultValue = "30") 	int rows,
			@RequestParam(value = "sidx"	            , defaultValue = "") 	String sidx,
			@RequestParam(value = "sord"	            , defaultValue = "") 	String sord,
			@RequestParam(value = "srcCateId"			, defaultValue = "0") String srcCateId,
			@RequestParam(value = "srcGoodName"			, defaultValue = "") String srcGoodName,
			@RequestParam(value = "srcGoodIdenNumb"		, defaultValue = "") String srcGoodIdenNumb,
			@RequestParam(value = "srcCustGoodIdenNumb"	, defaultValue = "") String srcCustGoodIdenNumb, 
			@RequestParam(value = "srcGoodSpecDesc"		, defaultValue = "") String srcGoodSpecDesc,
			@RequestParam(value = "srcGoodSameWord"		, defaultValue = "") String srcGoodSameWord,
			@RequestParam(value = "srcPopularityProduct", defaultValue = "") String srcPopularityProduct,
			@RequestParam(value = "_groupId", defaultValue = "") String _groupId,
			@RequestParam(value = "_clientId", defaultValue = "") String _clientId,
			@RequestParam(value = "_branchId", defaultValue = "") String _branchId,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
//		LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("groupid"  			, _groupId );
		params.put("clientid" 			, _clientId ); 
		params.put("branchid" 			, _branchId); 
		params.put("srcCateId"				, CommonUtils.stringParseInt(srcCateId, 0)); 
		params.put("srcGoodName"			, srcGoodName			); 
		params.put("srcGoodIdenNumb"		, srcGoodIdenNumb		); 
		params.put("srcCustGoodIdenNumb"	, srcCustGoodIdenNumb); 
		params.put("srcGoodSpecDesc"		, srcGoodSpecDesc		); 
		params.put("srcGoodSameWord"		, srcGoodSameWord		); 
		SmpBranchsDto smpBranchsDto = commonSvc.getBranchInfoByBorgId(_branchId);
		params.put("srcAreaType"			, smpBranchsDto.getAreaType());
		
		String orderString = "";
		
		if(srcPopularityProduct.equals("check")){
			orderString = " order_cnt desc ";
		}else {
			if(sidx.length() > 0 ){
				orderString = " " + sidx + " " + sord + " ";
			}
		}
		params.put("orderString", orderString);
		
		/*----------------페이징 세팅------------*/
		
		int records = productSvc.getBuyProductSearchCnt(params); //조회조건에 따른 카운트
        int total = (int)Math.ceil((float)records / (float)rows);
		
        /*----------------조회------------*/
        List<BuyProductDto> list = null;  
        if(records>0) {
        	list = productSvc.getBuyProductSearchList(params, page, rows);
        }
        
        modelAndView.setViewName("jsonView");
        
		modelAndView.addObject("page"	, page);
		modelAndView.addObject("total"	, total);
		modelAndView.addObject("records", records);
		modelAndView.addObject("list"	, list);
		return modelAndView;
	}
	
	/**
	 * 고객사 상품조회 엑셀 다운로드 
	 */
	@RequestMapping("buyProductListExcel.sys")
	public ModelAndView buyProductListExcel(
			@RequestParam(value = "sidx"	            , defaultValue = "") 	String sidx,
			@RequestParam(value = "sord"	            , defaultValue = "") 	String sord,
			@RequestParam(value = "srcCateId"			, defaultValue = "0") String srcCateId,
			@RequestParam(value = "srcGoodName"			, defaultValue = "") String srcGoodName,
			@RequestParam(value = "srcGoodIdenNumb"		, defaultValue = "") String srcGoodIdenNumb,
			@RequestParam(value = "srcCustGoodIdenNumb"	, defaultValue = "") String srcCustGoodIdenNumb, 
			@RequestParam(value = "srcGoodSpecDesc"		, defaultValue = "") String srcGoodSpecDesc,
			@RequestParam(value = "srcGoodSameWord"		, defaultValue = "") String srcGoodSameWord,
			@RequestParam(value = "srcPopularityProduct", defaultValue = "") String srcPopularityProduct,
			@RequestParam(value = "srcGoodClasCode", defaultValue = "") String srcGoodClasCode,//상품구분
			
			@RequestParam(value = "sheetTitle"			, defaultValue = "") String sheetTitle,
			@RequestParam(value = "excelFileName"		, defaultValue = "") String excelFileName,
			@RequestParam(value = "colLabels"			, required = false) String[] colLabels,
			@RequestParam(value = "colIds"				, required = false) String[] colIds,
			@RequestParam(value = "numColIds"			, required = false) String[] numColIds,	
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("groupid"  				, loginUserDto.getGroupId() );
		params.put("clientid" 				, loginUserDto.getClientId() ); 
		params.put("branchid" 				, loginUserDto.getBorgId()); 
		params.put("srcCateId"				, CommonUtils.stringParseInt(srcCateId, 0)); 
		params.put("srcGoodName"			, srcGoodName			); 
		params.put("srcGoodIdenNumb"		, srcGoodIdenNumb		); 
		params.put("srcCustGoodIdenNumb"	, srcCustGoodIdenNumb); 
		params.put("srcGoodSpecDesc"		, srcGoodSpecDesc		); 
		params.put("srcGoodSameWord"		, srcGoodSameWord		); 
		params.put("srcAreaType"			, loginUserDto.getAreaType());
		params.put("srcGoodClasCode"		, srcGoodClasCode);
		
		
		String orderString = "";
		
		if(srcPopularityProduct.equals("check")){
			orderString = " order_cnt desc ";
		}else {
			if(sidx.length() > 0 ){
				orderString = " " + sidx + " " + sord + " ";
			}
		}
		params.put("orderString", orderString);
		
		/*----------------조회------------*/
		List<BuyProductDto> list = productSvc.getBuyProductSearchList(params, 1, RowBounds.NO_ROW_LIMIT);
		
		List<Map<String, Object>> colDataList = null;
		if(list != null && list.size() > 0){
			Map<String, Object> rtnData = null;
			colDataList = new ArrayList<Map<String, Object>>();
			for(int i = 0; i < list.size() ; i++){
				String result ="";
				String[] goodStSpecDescArr = {"","","","","",""};
				String[] goodSpecDescArr = {"","","","","","","",""};
				try{
					String[] tempGoodStSpecDesc = new String[Constances.PROD_GOOD_ST_SPEC.length]; 
					for(int idx = 0 ; idx < Constances.PROD_GOOD_ST_SPEC.length ; idx++) {
						tempGoodStSpecDesc[idx] = Constances.PROD_GOOD_ST_SPEC[idx];
					}
					if(null != list.get(i).getGood_st_spec_desc()){
						String[] tempGoodStSpecDescArray =  list.get(i).getGood_st_spec_desc().split("‡");
						for(int idx = 0 ; idx < tempGoodStSpecDescArray.length ; idx++) {
							if(tempGoodStSpecDescArray[idx].toString().trim().length()  > 0) {
								result += tempGoodStSpecDesc[idx]+":"+ tempGoodStSpecDescArray[idx] + " ";
							}
						}
					}
					if(!"".equals(result)) result = "[" + result + "]";
					String[] tempGoodSpecDesc = new String[Constances.PROD_GOOD_SPEC.length]; 
					for(int idx = 0 ; idx < Constances.PROD_GOOD_SPEC.length ; idx++) {
						tempGoodSpecDesc[idx] = Constances.PROD_GOOD_SPEC[idx];
					}
					if(null != list.get(i).getGood_spec_desc()){
						String[] tempGoodSpecDescArray = list.get(i).getGood_spec_desc().split("‡");
						for(int idx = 0 ; idx < tempGoodSpecDescArray.length ; idx++) {
							if(tempGoodSpecDescArray[idx].toString().trim().length()  > 0) {
								if(idx == 0 ) {
									result += "  "+ tempGoodSpecDescArray[idx] + "  ";
								} else {
									result += tempGoodSpecDesc[idx]+":"+ tempGoodSpecDescArray[idx] + " ";
								}
							}
						}
					}
					if("10".equals((list.get(i).getGood_clas_code()))){
						list.get(i).setGood_clas_code("일반");
					}else if("20".equals((list.get(i).getGood_clas_code()))){
						list.get(i).setGood_clas_code("지정");
					}else if("30".equals((list.get(i).getGood_clas_code()))){
						list.get(i).setGood_clas_code("수탁");
					}else if("40".equals((list.get(i).getGood_clas_code()))){
						list.get(i).setGood_clas_code("사급형 지입");
					}else if("50".equals((list.get(i).getGood_clas_code()))){
						list.get(i).setGood_clas_code("사급");
					}
					
					//상품표준 규격
					String[] tmpGoodStSpecDescArr = new String[] {"","","","","",""};
					if(list.get(i).getGood_st_spec_desc() != null && list.get(i).getGood_st_spec_desc() != ""){
						goodStSpecDescArr = list.get(i).getGood_st_spec_desc().split("‡");
						
						for(int j=0; j<goodStSpecDescArr.length; j++){
							tmpGoodStSpecDescArr[j] = goodStSpecDescArr[j];
						}
						goodStSpecDescArr = tmpGoodStSpecDescArr;
					}
					
					//상품규격
					String[] tmpGoodSpecDescArr = new String[] {"","","","","","","",""};
					if(list.get(i).getGood_spec_desc() != null && list.get(i).getGood_spec_desc() != ""){
						goodSpecDescArr = list.get(i).getGood_spec_desc().split("‡");
						for(int j=0; j<goodSpecDescArr.length; j++){
							tmpGoodSpecDescArr[j] = goodSpecDescArr[j];
						}
						goodSpecDescArr = tmpGoodSpecDescArr;
					}
				}catch(Exception e){
					result="";
				}
				rtnData = new HashMap<String, Object>();
				rtnData.put("good_name", list.get(i).getGood_name());
				rtnData.put("good_spec_desc", result);
				rtnData.put("good_iden_numb", list.get(i).getGood_iden_numb());
				rtnData.put("borgnm", list.get(i).getBorgnm());
				rtnData.put("orde_clas_code", list.get(i).getOrde_clas_code());
				rtnData.put("sell_price", list.get(i).getSell_price());
				rtnData.put("ord_quan", list.get(i).getOrd_quan());
				rtnData.put("total_amout", list.get(i).getTotal_amout());
				rtnData.put("good_clas_code", list.get(i).getGood_clas_code());
				rtnData.put("good_inventory_cnt", list.get(i).getGood_inventory_cnt());
				rtnData.put("product_manager", list.get(i).getProduct_manager());
				//표준규격
				rtnData.put("good_st_spec_desc1", goodStSpecDescArr[0]);
				rtnData.put("good_st_spec_desc2", goodStSpecDescArr[1]);
				rtnData.put("good_st_spec_desc3", goodStSpecDescArr[2]);
				rtnData.put("good_st_spec_desc4", goodStSpecDescArr[3]);
				rtnData.put("good_st_spec_desc5", goodStSpecDescArr[4]);
				rtnData.put("good_st_spec_desc6", goodStSpecDescArr[5]);
				
				//규격
				rtnData.put("good_spec_desc1", goodSpecDescArr[0]);
				rtnData.put("good_spec_desc2", goodSpecDescArr[1]);
				rtnData.put("good_spec_desc3", goodSpecDescArr[2]);
				rtnData.put("good_spec_desc4", goodSpecDescArr[3]);
				rtnData.put("good_spec_desc5", goodSpecDescArr[4]);
				rtnData.put("good_spec_desc6", goodSpecDescArr[5]);
				rtnData.put("good_spec_desc7", goodSpecDescArr[6]);
				rtnData.put("good_spec_desc8", goodSpecDescArr[7]);
				
				colDataList.add(rtnData);
			}
		}			
		
        List<Map<String, Object>> sheetList = new ArrayList<Map<String, Object>>();
        Map<String, Object> map1 = new HashMap<String, Object>();
        map1.put("sheetTitle", sheetTitle);
        map1.put("colLabels", colLabels);
        map1.put("colIds", colIds);
        map1.put("numColIds", numColIds);
//        map1.put("figureColIds", figureColIds);
        map1.put("colDataList", colDataList);
        sheetList.add(map1);
        modelAndView.setViewName("commonExcelViewResolver");
        modelAndView.addObject("excelFileName", excelFileName);
        modelAndView.addObject("sheetList", sheetList);
		
//		modelAndView.addObject("sheetTitle", sheetTitle);
//		modelAndView.addObject("excelFileName", excelFileName);
//		modelAndView.addObject("colLabels", colLabels);
//		modelAndView.addObject("colIds", colIds);
//		modelAndView.addObject("numColIds", numColIds);
//		modelAndView.addObject("colDataList", colDataList);
//		modelAndView.setViewName("commonExcelViewResolver");
		return modelAndView;			
	}
	
	@RequestMapping("buyProductListByAdmJQGrid.sys")
	public ModelAndView buyProductListByAdmJQGrid(
			@RequestParam(value = "page", defaultValue = "1") int page,
			@RequestParam(value = "rows", defaultValue = "30") int rows,
			@RequestParam(value = "sidx", defaultValue = "") String sidx,
			@RequestParam(value = "sord", defaultValue = "") String sord,
			@RequestParam(value = "srcCateId", defaultValue = "") String srcCateId,
			@RequestParam(value = "groupid", defaultValue = "0") String groupid,
			@RequestParam(value = "clientid", defaultValue = "0") String clientid,
			@RequestParam(value = "branchid", defaultValue = "0") String branchid,
			@RequestParam(value = "vendorid", defaultValue = "") String vendorid,
			@RequestParam(value = "srcProductName", defaultValue = "") String srcProductName,
			@RequestParam(value = "srcGoodSpecDesc", defaultValue = "") String srcGoodSpecDesc ,
			@RequestParam(value = "srcProductCode", defaultValue = "") String srcProductCode ,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		//LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		
		/*----------------조회조건 세팅------------*/
//		Map<String, Object> params = new HashMap<String, Object>();
//		params.put("groupid"  		, groupid );
//		params.put("clientid" 		, clientid ); 
//		params.put("branchid" 		, branchid); 
//		params.put("srcProductName"	, srcProductName);
//		params.put("srcProductCode"	, srcProductCode);
//		params.put("srcCateId"		, CommonUtils.stringParseInt(srcCateId, 0));
//		String orderString = " " + sidx + " " + sord + " ";
//		params.put("orderString", orderString);
//		/*----------------페이징 세팅------------*/
//		
//		logger.debug("params value ["+params+"]");
//		
//		int records = productSvc.getBuyProductSearchByAdmCnt(params); //조회조건에 따른 카운트
//        int total = (int)Math.ceil((float)records / (float)rows);
//		
//        /*----------------조회------------*/
//        List<BuyProductDto> list = null;  
//        if(records>0) {
//        	list = productSvc.getBuyProductSearchByAmdList(params, page, rows);
//        }
//        
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("groupid"  			, groupid );
		params.put("clientid" 			, clientid ); 
		params.put("branchid" 			, branchid); 
		params.put("vendorid" 			, vendorid);
		params.put("srcCateId"				, CommonUtils.stringParseInt(srcCateId, 0)); 
		params.put("srcGoodName"			, srcProductName			); 
		params.put("srcGoodIdenNumb"		, srcProductCode		); 
		params.put("srcGoodSpecDesc"		, srcGoodSpecDesc		); 
		
		
		LoginUserDto lud = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
	    boolean isVen = lud.getSvcTypeCd().equals("VEN") ? true : false;
	    if(isVen){ // 2013-05-02 공급사는 수탁상품 조회 못하게 막기 
			params.put("srcIsCen"		, "true"); 
	    }
//		params.put("srcGoodSameWord"		, srcGoodSameWord		); 
//		params.put("srcAreaType"			, loginUserDto.getAreaType());
		
		
		String orderString = "";
		
//		if(srcPopularityProduct.equals("check")){
//			orderString = " order_cnt desc ";
//		}else {
			if(sidx.length() > 0 ){
				orderString = " " + sidx + " " + sord + " ";
			}
//		}
		params.put("orderString", orderString);
		
		/*----------------페이징 세팅------------*/
		
		int records = productSvc.getBuyProductSearchCnt(params); //조회조건에 따른 카운트
        int total = (int)Math.ceil((float)records / (float)rows);
		
        /*----------------조회------------*/
        List<BuyProductDto> list = null;  
        if(records>0) {
        	list = productSvc.getBuyProductSearchList(params, page, rows);
        }
        
        modelAndView.setViewName("jsonView");
        
		modelAndView.addObject("page", page);
		modelAndView.addObject("total", total);
		modelAndView.addObject("records", records);
		modelAndView.addObject("list", list);
		return modelAndView;
	}
	
	
	/**
	 * 관심상품 페이지로 이동하는 메소드
	 */
	@RequestMapping("buyWishList.sys")
	public ModelAndView getBuyWishList(
			@RequestParam(value = "srcType", defaultValue = "") String srcType,
			@RequestParam(value = "srcCateId", defaultValue = "") String srcCateId,
			@RequestParam(value = "srcProductInput", defaultValue = "") String srcProductInput, 
			HttpServletRequest req, ModelAndView mav) throws Exception{
		
		mav.addObject("srcType", srcType);
		mav.addObject("srcProductInput", srcProductInput);
        mav.addObject("srcCateId", srcCateId);
		mav.setViewName("product/product/buyWishList");
		return mav;
	}
	
	/**
	 * 관심상품 DB조회후 리턴시켜주는 메소드
	 */
	@RequestMapping("buyWishListJQGrid.sys")
	public ModelAndView buyWishListJQGrid(
			@RequestParam(value = "page", defaultValue = "1") int page,
			@RequestParam(value = "rows", defaultValue = "30") int rows,
			@RequestParam(value = "sidx", defaultValue = "") String sidx,
			@RequestParam(value = "sord", defaultValue = "") String sord,
			@RequestParam(value = "srcType", defaultValue = "") String srcType,
			@RequestParam(value = "srcCateId", defaultValue = "") String srcCateId,
			@RequestParam(value = "srcProductInput", defaultValue = "") String srcProductInput, 
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		/*----------------조회조건 세팅------------*/
		LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("groupid" , loginUserDto.getGroupId());
		params.put("clientid" , loginUserDto.getClientId());
		params.put("branchid" , loginUserDto.getBorgId());
		params.put("srcType", srcType);
		params.put("srcProductInput", srcProductInput);
		params.put("srcCateId", srcCateId);
		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
		
		/*----------------페이징 세팅------------*/
		int records = productSvc.getBuyWishListCnt(params); //조회조건에 따른 카운트
		int total = (int)Math.ceil((float)records / (float)rows);
		
		/*----------------조회------------*/
		List<BuyProductDto> list = null;
		if(records>0) list = productSvc.getBuyWishList(params, page, rows);
		
		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("page", page);
		modelAndView.addObject("total", total);
		modelAndView.addObject("records", records);
		modelAndView.addObject("list", list);
		return modelAndView;
	}
	/*----------------고객사 끝------------*/
	
	
	@RequestMapping("getCommonProductSearchListByVendor.sys")
	public ModelAndView commonProductSearchListByVendorJQGrid(
			@RequestParam(value = "sidx", defaultValue = "") String sidx,
			@RequestParam(value = "sord", defaultValue = "") String sord,
			@RequestParam(value = "schGoodName", defaultValue = "") String schGoodName,
			@RequestParam(value = "schGoodSpecName", defaultValue = "") String schGoodSpecName,
			@RequestParam(value = "schGroupId", defaultValue = "")  String schGroupId,             
			@RequestParam(value = "schClientId", defaultValue = "") String schClientId,
			@RequestParam(value = "schBranchId", defaultValue = "") String schBranchId,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("schVendorId" , loginUserDto.getBorgId()); 
		params.put("schGoodName", schGoodName);
		params.put("schGoodSpecName", schGoodSpecName);
		params.put("schGroupId" , schGroupId );
		params.put("schClientId", schClientId);
		params.put("schBranchId", schBranchId);
		
		params.put("orderString", " " + sidx + " " + sord + " ");
		/*----------------페이징 세팅------------*/
		
		logger.debug("params value ["+params+"]");
		
		/*----------------조회------------*/
        List<ProductDto> list = null;  
        list = productSvc.getCommonProductSearchListByVendor(params);
        
        modelAndView.setViewName("jsonView");
		modelAndView.addObject("list", list);
		return modelAndView;
	}
	
	@RequestMapping("getChoiceProductListInfoByVendor.sys")
	public ModelAndView getChoiceProductListInfoByVendor(
			@RequestParam(value = "disp_good_ids[]", required = false) String[] disp_good_ids,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		/*----------------조회조건 세팅------------*/
		String disp_good_ids_Parmas = "( ";
		
		for(int idx=0 ; idx < disp_good_ids.length ; idx++) {
			if(disp_good_ids_Parmas.equals("( "))
				disp_good_ids_Parmas += "'"+disp_good_ids[idx]+"'";
			else 
				disp_good_ids_Parmas += ",'"+disp_good_ids[idx]+"'";
		}
		disp_good_ids_Parmas +=  " )";

		logger.debug("disp_good_ids_Parmas value ["+disp_good_ids_Parmas+"]");
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("disp_good_ids_Parmas", disp_good_ids_Parmas);
        List<ProductDto> list = null;  
        list = productSvc.getChoiceProductListInfoByVendor(params);
        
        modelAndView.setViewName("jsonView");
		modelAndView.addObject("list", list);
		return modelAndView;
	}
	
	/**
	 * 관심 상품 등록 
	 * @param disp_good_id_array
	 * @param request
	 * @param modelAndView
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("addInterestProductTransGrid.sys")
	public ModelAndView addInterestProductTransGrid(
			@RequestParam(value = "disp_good_id_array[]", required = false) String[] disp_good_id_array,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		
		/*----------------조회조건 세팅------------*/
		LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		Map<String, Object> params = new HashMap<String, Object>();
		
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		try {
			params.put("groupId"  			, loginUserDto.getGroupId()	);
			params.put("clientId"  			, loginUserDto.getClientId());
			params.put("branchId"  			, loginUserDto.getBorgId()	);
			params.put("disp_good_id_array"	, disp_good_id_array);
			params.put("userId"				, loginUserDto.getUserId()	);
			
			productSvc.addInterestProduct(params); 
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
	 * 관심 상품 삭제 
	 * @param disp_good_id_array
	 * @param request
	 * @param modelAndView
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("delInterestProductTransGrid.sys")
	public ModelAndView delInterestProductTransGrid(
			@RequestParam(value = "disp_good_id_array[]", required = false) String[] disp_good_id_array,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		/*----------------조회조건 세팅------------*/
		LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		Map<String, Object> params = new HashMap<String, Object>();
		
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		try {
			params.put("groupId"  			, loginUserDto.getGroupId()	);
			params.put("clientId"  			, loginUserDto.getClientId());
			params.put("branchId"  			, loginUserDto.getBorgId()	);
			params.put("disp_good_id_array"	, disp_good_id_array);
			params.put("userId"				, loginUserDto.getUserId()	);
			
			productSvc.delInterestProduct(params); 
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
	 * (고객사) 상품 팝업 상세 이동 
	 * @param disp_good_id_array
	 * @param request
	 * @param modelAndView
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("goProductDetailForBuyer.sys")
	public ModelAndView goProductDetailForBuyer(
			@RequestParam(value = "disp_good_id", required = false) String disp_good_id,
			@RequestParam(value = "isEdit", defaultValue = "Y") String isEdit,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception{
		
		modelAndView.addObject("disp_good_id",disp_good_id);
		modelAndView.addObject("isEdit",isEdit);
		modelAndView.setViewName("jspViewResolver");
		modelAndView.setViewName("product/product/buyProductDetail");
		return modelAndView;
	}
	
	/**
	 * (고객사) 상품 팝업 상세 정보 조회
	 * @param disp_good_id_array
	 * @param request
	 * @param modelAndView
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("getProductDetailForBuyer.sys")
	public ModelAndView getProductDetailForBuyer(
			@RequestParam(value = "disp_good_id", required = false) String disp_good_id,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception{
		
		/*----------------조회조건 세팅------------*/
		LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		Map<String, Object> params = new HashMap<String, Object>();
		
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		try {
			params.put("groupId"  			, loginUserDto.getGroupId()		);
			params.put("clientId"  			, loginUserDto.getClientId()	);
			params.put("branchId"  			, loginUserDto.getBorgId()		);
			params.put("disp_good_id"		, disp_good_id					);
			params.put("userId"				, loginUserDto.getUserId()		);
			
			modelAndView.addObject("productDetailInfo",productSvc.getProductDetailInfoForBuyer(params));
		}catch(Exception e) {
			
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
	 * (고객사) 과거 상품 상세 정보 조회
	 * @param disp_good_id
	 * @param request
	 * @param modelAndView
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("getPastProductDetailForBuyer.sys")
	public ModelAndView getPastProductDetailForBuyer(
			@RequestParam(value = "disp_good_id", required = false) String disp_good_id,
			@RequestParam(value = "comp_branchid", required = false , defaultValue = "") String comp_branchid,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception{
		
		/*----------------조회조건 세팅------------*/
		LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		Map<String, Object> params = new HashMap<String, Object>();
		
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		try {
			params.put("groupId"  			, loginUserDto.getGroupId()		);
			params.put("clientId"  			, loginUserDto.getClientId()	);
			params.put("branchId"  			, loginUserDto.getBorgId()		);
			params.put("disp_good_id"		, disp_good_id					);
			params.put("comp_branchid"		, comp_branchid					);
			params.put("userId"				, loginUserDto.getUserId()		);
			
			modelAndView.addObject("pastProductDetailInfo" ,productSvc.getProductDetailInfoForBuyer(params));
			modelAndView.addObject("pastProductPriceInfo"  ,productSvc.getPastProductPriceInfo(params));
			
		}catch(Exception e) {
			
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
	 * (운영사) 상품 팝업 공통  어드민  
	 * @param isMultiSel
	 * @param request
	 * @param modelAndView
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("initProdSearchForAdm.sys")
	public ModelAndView initProdSearchForAdm(
			@RequestParam(value = "isMultiSel", required = false , defaultValue = "0") String isMultiSel,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception{
		modelAndView.addObject("isMultiSel",isMultiSel);
		//modelAndView.setViewName("jspViewResolver");
		
		modelAndView.addObject("standCategoryDto"	, categorySvc.getStandardCategoryList());
		modelAndView.setViewName("common/product/prodSearchForAdmSingle");
		
		return modelAndView;
	}
	
	/**
	 * (운영사) 주문상품 팝업   
	 */
	@RequestMapping("prodSearchForAdmOrde.sys")
	public ModelAndView initProdSearchForAdm(
			@RequestParam(value = "groupId", defaultValue = "0") String groupId,
			@RequestParam(value = "clientId", defaultValue = "0") String clientId,
			@RequestParam(value = "branchId", defaultValue = "0") String branchId,
			@RequestParam(value = "branchNms", defaultValue = "0") String branchNms,
			@RequestParam(value = "vendorid", defaultValue = "") String vendorid,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception{
		
		modelAndView.setViewName("jspViewResolver");
		
		logger.debug("groupId value ["+groupId+"]");
		logger.debug("clientId value ["+clientId+"]");
		logger.debug("branchId value ["+branchId+"]");
		
		modelAndView.addObject("groupId", groupId);
		modelAndView.addObject("clientId", clientId);
		modelAndView.addObject("branchId", branchId);
		modelAndView.addObject("branchNms", branchNms);
		modelAndView.addObject("vendorid", vendorid);
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("groupId" 	, groupId );
		params.put("clientId" 	, clientId);
		params.put("branchId" 	, branchId);
		
		modelAndView.addObject("buyerCategoryDto"	, categorySvc.getBuyerDisplayCategoryInfoListJQ(params)	);
		modelAndView.setViewName("common/product/dispProdSearchForAdmOrder");
		return modelAndView;
	}
	
	
	/** 수탁상품 재고 조회  */
	@RequestMapping("cenStockCntSearch.sys")
	public ModelAndView productStockCntSearch( HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		modelAndView.setViewName("product/product/cenStockCntSearch");
		return modelAndView;
	}
	/** 수탁상품 재고 조회  */
	@RequestMapping("cenStockCntSearchJQGrid.sys")
	public ModelAndView getCenStockCntSearchJQGrid(
			@RequestParam(value = "srcGoodNm", defaultValue = "") String srcGoodNm,										// 상품명
			@RequestParam(value = "srcGoodIdenNumb", defaultValue = "") String srcGoodIdenNumb,						// 상품코드
			@RequestParam(value = "srcGoodRegiDateStart", defaultValue = "") String srcGoodRegiDateStart,				// 등록일 조회 시작일
			@RequestParam(value = "srcGoodRegiDateEnd", defaultValue = "") String srcGoodRegiDateEnd,					// 등록일 조회 종료일 
			@RequestParam(value = "srcVendorId", defaultValue = "") String srcVendorId,										// 공급사코드
			@RequestParam(value = "srcExistStock", defaultValue = "") String srcExistStock,										// 재고 존재 여부 
			@RequestParam(value = "page",defaultValue = "1") int page,
			@RequestParam(value = "rows", defaultValue = "30") int rows,
			@RequestParam(value = "sidx", defaultValue = "") String sidx, 															// 정렬할 칼럼 명
			@RequestParam(value = "sord", defaultValue = "") String sord,															// 정렬 조건
			HttpServletRequest req, ModelAndView mav) throws Exception{
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("srcGoodNm", srcGoodNm);
		params.put("srcGoodIdenNumb", srcGoodIdenNumb);
		params.put("srcGoodRegiDateStart", srcGoodRegiDateStart);
		params.put("srcGoodRegiDateEnd", srcGoodRegiDateEnd);
		params.put("srcVendorId", srcVendorId);
		params.put("srcExistStock", srcExistStock);
		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
        int records = productSvc.getCenStockCntSearchCountRow(params);
        int total = (int)Math.ceil((float)records / (float)rows);
        List<ProductDto> list = null;
        if(records>0)  list  = productSvc.getCenStockCntSearchList(params, page, rows);
		mav= new ModelAndView("jsonView");
		mav.addObject("page", page);
		mav.addObject("total", total);
		mav.addObject("records", records);
		mav.addObject("list", list);
		return mav;
	}
	/** 수탁상품 재고 조회 - 상세  */
	@RequestMapping("cenStockCntSearchPop.sys")
	public ModelAndView cenStockCntSearchPop( 
			@RequestParam(value = "good_iden_numb", required = true) String good_iden_numb,
			@RequestParam(value = "vendorid", required = true) String vendorid,						
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		modelAndView.setViewName("product/product/cenStockCntSearchPop");
		modelAndView.addObject("good_iden_numb", good_iden_numb);
		modelAndView.addObject("vendorid", vendorid);
		return modelAndView;
	}
	/** 수탁상품 재고 조회 - 상세 */
	@RequestMapping("cenStockCntSearchPopJQGrid.sys")
	public ModelAndView getCenStockCntSearchPopJQGrid(
			@RequestParam(value = "srcGoodIdenNumb", defaultValue = "") String srcGoodIdenNumb,						// 상품코드
			@RequestParam(value = "srcVendorId", defaultValue = "") String srcVendorId,										// 공급사코드
			@RequestParam(value = "page",defaultValue = "1") int page,
			@RequestParam(value = "rows", defaultValue = "30") int rows,
			@RequestParam(value = "sidx", defaultValue = "") String sidx, 															// 정렬할 칼럼 명
			@RequestParam(value = "sord", defaultValue = "") String sord,															// 정렬 조건
			HttpServletRequest req, ModelAndView mav) throws Exception{
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("srcGoodIdenNumb", srcGoodIdenNumb);
		params.put("srcVendorId", srcVendorId);
		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
        int records = productSvc.getCenStockCntSearchPopCountRow(params);
        int total = (int)Math.ceil((float)records / (float)rows);
        List<ProductDto> list = null;
        if(records>0)  list  = productSvc.getCenStockCntSearchPopList(params, page, rows);
		mav= new ModelAndView("jsonView");
		mav.addObject("page", page);
		mav.addObject("total", total);
		mav.addObject("records", records);
		mav.addObject("list", list);
		return mav;
	}
	
	
	
	/**
	 * 물류센터 상품 조회  
	 */
	@RequestMapping("productSearchForCenter.sys")
	public ModelAndView productSearchForCenter(
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		modelAndView.setViewName("common/product/prodSearchForCenter");
		return modelAndView;
	}
	
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
			
//			logger.debug("-------------------------------------------------------------");
//			for(BuyProductDto buyProductDto : autoCompList) {
//				logger.debug("jameskang getGood_name : "+CommonUtils.getString(buyProductDto.getGood_name()));
//			}
//			logger.debug("-------------------------------------------------------------");
			
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
								logger.debug("jameskang same pdtName : "+pdtName);
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

//			for(String string : resultList) {
//				logger.debug("jameskang string : "+string);
//			}
			
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
	 * 운영사 상품 검색 
	 */
	@RequestMapping("productResultListJQGrid.sys")
	public ModelAndView productResultListJQGrid(
			@RequestParam(value = "page"		, defaultValue = "1") int page,
			@RequestParam(value = "rows"		, defaultValue = "30") int rows,
			@RequestParam(value = "sidx"		, defaultValue = "good_Name") String sidx,
			@RequestParam(value = "sord"		, defaultValue = "desc") String sord,
			@RequestParam(value = "inputWord"	, defaultValue = "") String inputWord,
			@RequestParam(value = "searchType"	, defaultValue = "") String searchType,
			@RequestParam(value = "prevWord"	, defaultValue = "") String prevWord,

			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		//----------------조회조건 세팅------------/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("inputWord"	, inputWord);
		params.put("searchType"	, searchType);
		params.put("prevWord"	, prevWord);
		
		String orderString = " " +  sidx + " " + sord + " ";
		params.put("orderString", orderString);

		
		logger.debug("params value ["+params+"]");
		//----------------페이징 세팅------------/
		int records = productSvc.getProductResultListCnt(params); //조회조건에 따른 카운트
		int total = (int)Math.ceil((float)records / (float)rows);
		
		//----------------조회------------/
		List<ProductDto> list = null;
		if(records>0) {
//			list = productSvc.getProductResultList(params, page, rows);
		}
		
		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("page", page);
		modelAndView.addObject("total", total);
		modelAndView.addObject("records", records);
		modelAndView.addObject("list", list);
		return modelAndView;
	}
	
	/*************************************************
	 * 고도화 추가된 사항들(운영사)
	 *************************************************/

	/**
	 * 상품 등록/수정 화면
	 */
	@RequestMapping("popProductAdm.sys")
	public ModelAndView popProductAdm(HttpServletRequest request, ModelMap paramMap, ModelAndView modelAndView) throws Exception {
		
		if (paramMap.get("good_iden_numb") != null && StringUtils.isNotEmpty(paramMap.get("good_iden_numb").toString())) {
			String good_iden_numb = CommonUtils.getString(generalDao.selectGernalObject("product.selectMasterGoodIdenNumb", paramMap));
			if(!"".equals(good_iden_numb)) {
				paramMap.put("good_iden_numb", good_iden_numb);
			}
		}
		
		modelAndView.setViewName("product/product/popProductAdm");
		modelAndView.addObject("vTaxTypeCode"		, commonSvc.getCodeList("VTAXTYPECODE", 1)		);		// 과세구분
		modelAndView.addObject("productManager"		, generalDao.selectGernalList("product.selectProductManager", paramMap)); // 상품담당자
		modelAndView.addObject("orderUnit"			, commonSvc.getCodeList("ORDERUNIT", 1)		);			// 주문단위
		modelAndView.addObject("orderGoodsType"		, commonSvc.getCodeList("ORDERGOODSTYPE", 1)	);		// 상품구분
		modelAndView.addObject("isdistributeSts"	, commonSvc.getCodeList("ISDISTRIBUTE", 1)			);  // 물량배분
		modelAndView.addObject("deliAreaCodeList"	, commonSvc.getCodeList("DELI_AREA_CODE", 1)	);
		modelAndView.addObject("reqAppSts"			, commonSvc.getCodeList("REQAPPSTATE", 1)			);
		if (paramMap.get("good_iden_numb") != null && StringUtils.isNotEmpty(paramMap.get("good_iden_numb").toString())) {
			modelAndView.addObject("good"			    , generalDao.selectGernalObject("product.selectProduct", paramMap));
		} else if (paramMap.get("req_good_id") != null && StringUtils.isNotEmpty(paramMap.get("req_good_id").toString())) {
			modelAndView.addObject("good"			    , generalDao.selectGernalObject("product.selectProductForReq", paramMap));
		} else if (paramMap.get("bidid") != null && StringUtils.isNotEmpty(paramMap.get("bidid").toString())) {
			modelAndView.addObject("good"			    , generalDao.selectGernalObject("product.selectProductForBid", paramMap));
		}
		return modelAndView;
	}
	/**
	 * 상품 단가변경 요청 상세
	 */
	@RequestMapping("popProductAdmDis.sys")
	public ModelAndView popProductAdmDis(HttpServletRequest request, ModelMap paramMap, ModelAndView modelAndView) throws Exception {
		
		if (paramMap.get("good_iden_numb") != null && StringUtils.isNotEmpty(paramMap.get("good_iden_numb").toString())) {
			String good_iden_numb = CommonUtils.getString(generalDao.selectGernalObject("product.selectMasterGoodIdenNumb", paramMap));
			if(!"".equals(good_iden_numb)) {
				paramMap.put("good_iden_numb", good_iden_numb);
			}
		}
		
		modelAndView.setViewName("product/product/popProductAdmDis");
		modelAndView.addObject("vTaxTypeCode"		, commonSvc.getCodeList("VTAXTYPECODE", 1)		);		// 과세구분
		modelAndView.addObject("productManager"		, generalDao.selectGernalList("product.selectProductManager", paramMap)); // 상품담당자
		modelAndView.addObject("orderUnit"			, commonSvc.getCodeList("ORDERUNIT", 1)		);			// 주문단위
		modelAndView.addObject("orderGoodsType"		, commonSvc.getCodeList("ORDERGOODSTYPE", 1)	);		// 상품구분
		modelAndView.addObject("isdistributeSts"	, commonSvc.getCodeList("ISDISTRIBUTE", 1)			);  // 물량배분
		modelAndView.addObject("deliAreaCodeList"	, commonSvc.getCodeList("DELI_AREA_CODE", 1)	);
		modelAndView.addObject("reqAppSts"			, commonSvc.getCodeList("REQAPPSTATE", 1)			);
		modelAndView.addObject("good"			    , generalDao.selectGernalObject("product.selectProduct", paramMap));
		return modelAndView;
	}
	
	/**
	 * 상품일괄수정 화면
	 */
	@RequestMapping("popMultiProductAdm.sys")
	public ModelAndView popMultiProductAdm(HttpServletRequest request, ModelMap paramMap, ModelAndView modelAndView) throws Exception {

		modelAndView.addObject("productManager"		, generalDao.selectGernalList("product.selectProductManager", paramMap)); // 상품담당자
		modelAndView.addObject("vTaxTypeCode"		, commonSvc.getCodeList("VTAXTYPECODE", 1));	// 과세구분
		modelAndView.addObject("orderUnit"			, commonSvc.getCodeList("ORDERUNIT", 1));		// 주문단위
		modelAndView.addObject("orderGoodsType"		, commonSvc.getCodeList("ORDERGOODSTYPE", 1));	// 상품구분
		modelAndView.addObject("isdistributeSts"	, commonSvc.getCodeList("ISDISTRIBUTE", 1));  	// 물량배분
		modelAndView.addObject("deliAreaCodeList"	, commonSvc.getCodeList("DELI_AREA_CODE", 1));
		modelAndView.addObject("reqAppSts"			, commonSvc.getCodeList("REQAPPSTATE", 1));
		modelAndView.addObject("goodIdenNumb"		, paramMap.get("goodIdenNumb"));
		modelAndView.addObject("vendorId"			, paramMap.get("vendorId"));
		
		modelAndView.setViewName("product/product/popMultiProductAdm");
		return modelAndView;
	}
	
	/**
	 * 진열관리 조회 화면
	 */
	@RequestMapping("popDisplayMngt.sys")
	public ModelAndView popDisplayMngt(HttpServletRequest request, ModelMap paramMap, ModelAndView modelAndView) throws Exception {
		
		modelAndView.setViewName("product/product/popDisplayMngt");
		logger.info(paramMap);;
		modelAndView.addObject("deliAreaList", generalDao.selectGernalList("product.selectDeliAreaList", paramMap));		// 권역
		modelAndView.addObject("workInfoList1", generalDao.selectGernalList("product.selectWorkInfoList1", paramMap));		// 공사유형
		modelAndView.addObject("workInfoList2", generalDao.selectGernalList("product.selectWorkInfoList2", paramMap));		// 공사유형
		modelAndView.addObject("branchList",    generalDao.selectGernalList("product.selectBranchList", paramMap));		    // 사업장
		return modelAndView;
	}
	
	/**
	 * 상품리스트에서 진열관리 조회 화면
	 */
	@RequestMapping("popMultiDispMngt.sys")
	public ModelAndView popMultiDispMngt(HttpServletRequest request, ModelMap paramMap, ModelAndView modelAndView) throws Exception {
		modelAndView.setViewName("product/product/popMultiDispMngt");
		modelAndView.addObject("deliAreaList", commonSvc.getCodeList("DELI_AREA_CODE", 1));		// 권역
		modelAndView.addObject("workInfoList1", generalDao.selectGernalList("product.selectWorkInfoList1", paramMap));		// 공사유형
		return modelAndView;
	}
	
	/**
	 * 상품리스트에서 진열 정보 저장 처리 
	 */
	@RequestMapping("saveDispMngt.sys")
	public ModelAndView saveDispMngt(HttpServletRequest request, ModelMap paramMap, ModelAndView modelAndView) throws Exception {
		CustomResponse custResponse = new CustomResponse(true);
		LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		try{
            productSvc.setDispMngtInfo(paramMap,loginUserDto);
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
	 * 상품기본정보 저장 처리 
	 */
	@RequestMapping("saveGood.sys")
	public ModelAndView saveGood(HttpServletRequest request, ModelMap paramMap, ModelAndView modelAndView) throws Exception {
		RequestUtils.bind(request, paramMap);
		CustomResponse custResponse = new CustomResponse(true);

		paramMap.put("good_spec"			, paramMap.get("good_spec"		) == null ? "" : ((String)paramMap.get("good_spec")).replace("\"","＂") ); 
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
		paramMap.put("spec_weight_real"	, paramMap.get("spec_weight_real") == null ? "" : ((String)paramMap.get("spec_weight_real")).replace("\"","＂") ); 
		

		if (StringUtils.isEmpty(paramMap.get("good_iden_numb").toString())) {
			// 등록 처리
			Object object = context.getBean("seqMcProductService");
			String id = (String) MethodUtils.invokeMethod(object, "getNextStringId",null);
			paramMap.put("good_iden_numb", id);	//id생성
			custResponse.setNewIdx(id);
			generalDao.insertGernal("product.insertGood", paramMap);
		} else {
			// 수정 처리
			generalDao.updateGernal("product.updateGood", paramMap);
			generalDao.deleteGernal("product.deleteAddGood", paramMap);
		}
		generalDao.updateGernal("product.mergeMcGoodSpec", paramMap);

		// 이력 등록 
		Object object = context.getBean("seqMcProductHistoryService");
		String id = (String) MethodUtils.invokeMethod(object, "getNextStringId",null);
		paramMap.put("good_hist_id", id);	//id생성
		generalDao.insertGernal("product.insertGoodHist", paramMap);
		
		String [] add_good_iden_numb = request.getParameterValues("add_good_iden_numb");
		String [] vendorid = request.getParameterValues("vendorid");
		
		if (paramMap.get("add_good") != null && paramMap.get("add_good").toString().equals("Y") && vendorid != null) {
			object = context.getBean("seqMcAddProduct");
			for (int i=0; i<vendorid.length;i++) {
				id = (String) MethodUtils.invokeMethod(object, "getNextStringId",null);
				paramMap.put("add_good_id", id);	//id생성
				paramMap.put("add_good_iden_numb", add_good_iden_numb[i]);
				paramMap.put("vendorid", vendorid[i]);
				generalDao.insertGernal("product.insertAddGood", paramMap);
			}
		}

		modelAndView.setViewName("jsonView");
		modelAndView.addObject(custResponse);
		return modelAndView;
	}
	
	/**
	 * 상품일괄수정
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping("modMultiGood.sys")
	public ModelAndView modMultiGood(HttpServletRequest request, ModelMap paramMap, ModelAndView modelAndView) throws Exception {
		RequestUtils.bind(request, paramMap);
		CustomResponse custResponse = new CustomResponse(true);
		
		List<Object> list = (List<Object>)paramMap.get("good_iden_numbs");
		
		for(int i = 0 ; i < list.size() ; i++){
			paramMap.put("good_iden_numb", list.get(i));
			generalDao.updateGernal("product.updateMultiGood", paramMap);
			
			if(!"".equals(CommonUtils.getString(paramMap.get("good_spec")))){
				generalDao.updateGernal("product.mergeMcGoodSpec", paramMap);
			}
			
			// 이력 등록 
			Object object = context.getBean("seqMcProductHistoryService");
			String id = (String) MethodUtils.invokeMethod(object, "getNextStringId",null);
			paramMap.put("good_hist_id", id);	//id생성
			generalDao.insertGernal("product.insertGoodHist", paramMap);
		}
		
		modelAndView.setViewName("jsonView");
		modelAndView.addObject(custResponse);
		return modelAndView;
	}
	
	/**
	 * 상품공급사 저장 처리 
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	@RequestMapping("saveVendor.sys")
	public ModelAndView saveVendor(HttpServletRequest request, ModelMap paramMap, ModelAndView modelAndView) throws Exception {
		RequestUtils.bind(request, paramMap);
		CustomResponse custResponse = new CustomResponse(true);
		
		if(((String)paramMap.get("ISNEW")).equals("A")) {
			generalDao.insertGernal("product.insertGoodVendor", paramMap);
			if (StringUtils.isNotEmpty(paramMap.get("req_good_id").toString())) {
				LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
				paramMap.put("app_user_id", loginUserDto.getUserId());
				generalDao.insertGernal("product.manage.updateRegistReqProductByAdmin", paramMap);
			}
			if (paramMap.get("repre_good").toString().equals("Y")) {
				generalDao.insertGernal("product.insertGoodVendorForOption2", paramMap);
			}
		} else {
			
			/************ 옵션상품 대표가격이 변경이 되면 옵션가격 및 옵션가격히스토리에 반영 *****************/
			try {
				String repre_good = CommonUtils.getString(paramMap.get("repre_good"));
				if("Y".equals(repre_good)) {	//옵션상품
					Object priceChangeFlagObj = generalDao.selectGernalObject("product.selectGoodVendorPriceChangeFlag", paramMap);	//가격변경여부확인
					Map priceChangeFlagMap = (Map) priceChangeFlagObj;
					logger.debug("priceChangeFlagMap : "+priceChangeFlagMap);
					
					int isSellPriceChg = (int) priceChangeFlagMap.get("IS_SELL_PRICE_CHG");
					int isSaleUnitPricChg = (int) priceChangeFlagMap.get("IS_SALE_UNIT_PRIC_CHG");
					int isSellAddChg = (int) priceChangeFlagMap.get("IS_SELL_ADD_CHG");
					int isSaleAddChg = (int) priceChangeFlagMap.get("IS_SALE_ADD_CHG");
					if(isSellPriceChg>0 || isSellAddChg>0) {
						paramMap.put("sell_sale_type", "SALE");
						List optList = generalDao.selectGernalList("product.selectGoodVendorOptList", paramMap);
						if(optList!=null && optList.size()>0) {
							for(Object optObj:optList) {
								Map<String, Object> histMap = (Map<String, Object>) optObj;
								histMap.put("sell_sale_type", "SALE");
								if(isSellPriceChg>0) histMap.put("chg_reason", "기본금액 판매가 변경에 의한 옵션판매가 변경");
								else if(isSellAddChg>0) histMap.put("chg_reason", "추가금액 판매가 변경에 의한 옵션판매가 변경");
								
								Object object = context.getBean("seqMcPriceChgHist");
								String id = (String) MethodUtils.invokeMethod(object, "getNextStringId",null);
								histMap.put("price_chg_hist_id", id);	//id생성
								histMap.put("userInfoDto", paramMap.get("userInfoDto"));
								generalDao.insertGernal("product.insertPriceChgHistByMasterChg", histMap);
							}
						}
					}
					if(isSaleUnitPricChg>0 || isSaleAddChg>0) {
						paramMap.put("sell_sale_type", "BUY");
						List optList = generalDao.selectGernalList("product.selectGoodVendorOptList", paramMap);
						if(optList!=null && optList.size()>0) {
							for(Object optObj:optList) {
								Map<String, Object> histMap = (Map<String, Object>) optObj;
								histMap.put("sell_sale_type", "BUY");
								if(isSaleUnitPricChg>0) histMap.put("chg_reason", "기본금액 매입가 변경에 의한 옵션매입가 변경");
								else if(isSaleAddChg>0) histMap.put("chg_reason", "추가금액 매입가 변경에 의한 옵션매입가 변경");
								
								Object object = context.getBean("seqMcPriceChgHist");
								String id = (String) MethodUtils.invokeMethod(object, "getNextStringId",null);
								histMap.put("price_chg_hist_id", id);	//id생성
								histMap.put("userInfoDto", paramMap.get("userInfoDto"));
								generalDao.insertGernal("product.insertPriceChgHistByMasterChg", histMap);
							}
						}
					}
				} 
			} catch (Exception ex) {
				logger.error("옵션가격 히스토리 저장 시 에러 : "+ex);
			}
			/*******************************************************************************/
			
			generalDao.updateGernal("product.updateGoodVendor", paramMap);
			generalDao.updateGernal("product.updateGoodVendorForOptionByGoodVendorChg", paramMap);	//옵션가격변경
		}

		// 이력 등록 
		Object object = context.getBean("seqMcProductHistoryService");
		String id = (String) MethodUtils.invokeMethod(object, "getNextStringId",null);
		paramMap.put("good_hist_id", id);	//id생성
		generalDao.insertGernal("product.insertGoodVendorHist", paramMap);

		modelAndView.setViewName("jsonView");
		modelAndView.addObject(custResponse);
		return modelAndView;
	}
	/**
	 * 기준매익율변경 저장
	 * @param request
	 * @param paramMap
	 * @param modelAndView
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("updateVendorBuyRate.sys")
	public ModelAndView updateVendorBuyRate(HttpServletRequest request, ModelMap paramMap, ModelAndView modelAndView) throws Exception {
		CustomResponse custResponse = new CustomResponse(true);
		generalDao.insertGernal("product.updateVendorBuyRate", paramMap);
		
		// 이력 등록 
		Object object = context.getBean("seqMcProductHistoryService");
		String id = (String) MethodUtils.invokeMethod(object, "getNextStringId",null);
		paramMap.put("good_hist_id", id);	//id생성
		generalDao.insertGernal("product.insertGoodVendorHist", paramMap);
		
		modelAndView.setViewName("jsonView");
		modelAndView.addObject(custResponse);
		return modelAndView;
	}
	
	
	/**
	 * 가격 변경 처리 
	 */
	@RequestMapping("savePrice.sys")
	public ModelAndView savePrice(HttpServletRequest request, ModelMap paramMap, ModelAndView modelAndView) throws Exception {
		RequestUtils.bind(request, paramMap);
		CustomResponse custResponse = new CustomResponse(true);
		
		String sellPrice = CommonUtils.getString(paramMap.get("sellPrice"));
		if(!"".equals(sellPrice)) {	//기준매익율에 따른 판매가 변경
			String chg_reason = CommonUtils.getString(paramMap.get("chg_reason"));
			chg_reason += ", 기준매익율에 따른 판매가 변경";
			paramMap.put("chg_reason", chg_reason);
			paramMap.put("sellPrice", sellPrice);
		}
		
		Object object = context.getBean("seqMcPriceChgHist");
		String id = (String) MethodUtils.invokeMethod(object, "getNextStringId",null);
		paramMap.put("price_chg_hist_id", id);	//id생성
		generalDao.insertGernal("product.insertPriceChgHist", paramMap);
		generalDao.updateGernal("product.updateGoodVendorForPrice", paramMap);
		
		modelAndView.setViewName("jsonView");
		modelAndView.addObject(custResponse);
		return modelAndView;
	}
	
	/**
	 * 재고 변경 처리 
	 */
	@RequestMapping("saveStock.sys")
	public ModelAndView saveStock(HttpServletRequest request, ModelMap paramMap, ModelAndView modelAndView) throws Exception {
		RequestUtils.bind(request, paramMap);
		CustomResponse custResponse = new CustomResponse(true);

		Object object = context.getBean("seqMcStockChgHist");
		String id = (String) MethodUtils.invokeMethod(object, "getNextStringId",null);
		paramMap.put("stock_chg_hist_id", id);	//id생성
		generalDao.insertGernal("product.insertStockChgHist", paramMap);
		generalDao.updateGernal("product.updateGoodVendorForStock", paramMap);		

		modelAndView.setViewName("jsonView");
		modelAndView.addObject(custResponse);
		return modelAndView;
	}
	
	/**
	 * 진열 정보 저장 처리 
	 */
	@RequestMapping("saveMngt.sys")
	public ModelAndView saveMngt(HttpServletRequest request, ModelMap paramMap, ModelAndView modelAndView) throws Exception {
		RequestUtils.bind(request, paramMap);
		CustomResponse custResponse = new CustomResponse(true);
		
		String [] good_display_id = request.getParameterValues("good_display_id");
		String [] display_type_cd = request.getParameterValues("display_type_cd");
		String [] display_type = request.getParameterValues("display_type");
		String [] del_yn = request.getParameterValues("del_yn");

		if (good_display_id != null) {
			Object object = context.getBean("seqMcGoodDisplay");
			for (int i=0; i<good_display_id.length;i++) {
				paramMap.put("good_display_id", good_display_id[i]);
				paramMap.put("display_type_cd", display_type_cd[i]);
				paramMap.put("display_type", display_type[i]);
				if (good_display_id[i].equals("")) {
					if (del_yn[i].equals("Y")) {
						continue; // PK가 없고 삭제 처리가 되어있으면 Skip 처리 : 저장 없음. 
					}
					String id = (String) MethodUtils.invokeMethod(object, "getNextStringId",null);
					paramMap.put("good_display_id", id);	//id생성
					generalDao.insertGernal("product.insertGoodDisplay", paramMap);
					logger.debug("insert GoodDisplay:" + id);
				} else if (del_yn[i].equals("Y")) {
					generalDao.deleteGernal("product.deleteGoodDisplay", paramMap);
					logger.debug("delete GoodDisplay:" + good_display_id[i]);
				}
			}
		}
		
		String [] good_display_branch_id = request.getParameterValues("good_display_branch_id");
		String [] branchid = request.getParameterValues("branchid");
		String [] del_b_yn = request.getParameterValues("del_b_yn");
		
		if (good_display_branch_id != null) {
			Object object = context.getBean("seqMcGoodDisplayBranch");
			for (int i=0; i<good_display_branch_id.length;i++) {
				paramMap.put("good_display_branch_id", good_display_branch_id[i]);
				paramMap.put("branchid", branchid[i]);
				if (good_display_branch_id[i].equals("")) {
					if (del_b_yn[i].equals("Y")) {
						continue; // PK가 없고 삭제 처리가 되어있으면 Skip 처리 : 저장 없음. 
					}
					String id = (String) MethodUtils.invokeMethod(object, "getNextStringId",null);
					paramMap.put("good_display_branch_id", id);	//id생성
					generalDao.insertGernal("product.insertGoodDisplayBranch", paramMap);
				} else if (del_b_yn[i].equals("Y")) {
					generalDao.deleteGernal("product.deleteGoodDisplayBranch", paramMap);
				}
			}
		}
		
		modelAndView.setViewName("jsonView");
		modelAndView.addObject(custResponse);
		return modelAndView;
	}
	
	/**
	 * 공급사 삭제
	 */
	@RequestMapping("delVendor.sys")
	public ModelAndView delVendor(HttpServletRequest request, ModelMap paramMap, ModelAndView modelAndView) throws Exception {
		RequestUtils.bind(request, paramMap);
		CustomResponse custResponse = new CustomResponse(true);

		generalDao.deleteGernal("product.deleteGoodVendorForNew", paramMap);
		if (paramMap.get("repre_good").toString().equals("Y")) {
			generalDao.deleteGernal("product.deleteGoodVendorForOption2", paramMap);
		}

		modelAndView.setViewName("jsonView");
		modelAndView.addObject(custResponse);
		return modelAndView;
	}
	
	/**
	 * 공급사 상태 변경
	 */
	@RequestMapping("chgVendor.sys")
	public ModelAndView chgVendor(HttpServletRequest request, ModelMap paramMap, ModelAndView modelAndView) throws Exception {
		RequestUtils.bind(request, paramMap);
		CustomResponse custResponse = new CustomResponse(true);

		generalDao.updateGernal("product.updateGoodVendorForUse", paramMap);

		modelAndView.setViewName("jsonView");
		modelAndView.addObject(custResponse);
		return modelAndView;
	}
	
	/**
	 * 공통옵션 저장 
	 */
	@RequestMapping("saveCommon.sys")
	public ModelAndView saveCommon(HttpServletRequest request, ModelMap paramMap, ModelAndView modelAndView) throws Exception {
		RequestUtils.bind(request, paramMap);
		CustomResponse custResponse = new CustomResponse(true);

		String [] GOOD_COMMON_OPTION_ID = request.getParameterValues("GOOD_COMMON_OPTION_ID");
		String [] OPTION_VALUE = request.getParameterValues("OPTION_VALUE");
		String [] OPTION_NAME = request.getParameterValues("OPTION_NAME");
		
		Object object = context.getBean("seqMcGoodCommonOption");
		for (int i=0; i<GOOD_COMMON_OPTION_ID.length;i++) {
			paramMap.put("GOOD_COMMON_OPTION_ID", GOOD_COMMON_OPTION_ID[i]);
			paramMap.put("OPTION_TYPE", i+1);
			paramMap.put("OPTION_VALUE", OPTION_VALUE[i]);
			paramMap.put("OPTION_NAME", OPTION_NAME[i]);
			
			if (GOOD_COMMON_OPTION_ID[i].equals("")) {
				String id = (String) MethodUtils.invokeMethod(object, "getNextStringId",null);
				paramMap.put("GOOD_COMMON_OPTION_ID", id);	//id생성
				generalDao.insertGernal("product.insertGoodCommonOption", paramMap);
			} else {
				generalDao.updateGernal("product.updateGoodCommonOption", paramMap);
			}
		}

		modelAndView.setViewName("jsonView");
		modelAndView.addObject(custResponse);
		return modelAndView;
	}
	
	/**
	 * 규격옵션 추가
	 */
	@RequestMapping("saveOptions.sys")
	public ModelAndView saveOptions(HttpServletRequest request, ModelMap paramMap, ModelAndView modelAndView) throws Exception {
		RequestUtils.bind(request, paramMap);
		CustomResponse custResponse = new CustomResponse(true);

		String [] good_iden_numb = request.getParameterValues("good_iden_numb");
		String [] pims = request.getParameterValues("pims");
		
//		paramMap.put("good_iden_numb", paramMap.get("repre_good_iden_numb"));
		
		if (good_iden_numb != null) {
			for (int i=0; i<good_iden_numb.length;i++) {
				paramMap.put("good_iden_numb", good_iden_numb[i]);
				paramMap.put("pims", pims[i]);
				String tmp_repre_good_iden_numb = CommonUtils.getString(generalDao.selectGernalObject("product.selectMcgoodRepreGoodIdenNumb", paramMap));
				if("".equals(tmp_repre_good_iden_numb)) {	//옵션상품추가
					generalDao.updateGernal("product.updateGoodForOptionJoinRepreGood", paramMap);
				}
				generalDao.updateGernal("product.updateGoodForOption", paramMap);
				generalDao.deleteGernal("product.deleteGoodVendorForOption", paramMap);
				generalDao.insertGernal("product.insertGoodVendorForOption", paramMap);
			}
		}

		modelAndView.setViewName("jsonView");
		modelAndView.addObject(custResponse);
		return modelAndView;
	}
	
	/**
	 * 규격옵션 등록/수정
	 */
	@RequestMapping("saveOption.sys")
	public ModelAndView saveOption(HttpServletRequest request, ModelMap paramMap, ModelAndView modelAndView) throws Exception {
		RequestUtils.bind(request, paramMap);
		CustomResponse custResponse = new CustomResponse(true);

		if (StringUtils.isEmpty(paramMap.get("good_iden_numb").toString())) {
			Object object = context.getBean("seqMcProductService");
			String id = (String) MethodUtils.invokeMethod(object, "getNextStringId",null);
			paramMap.put("good_iden_numb", id);	//id생성
			custResponse.setNewIdx(id);
			generalDao.insertGernal("product.insertGoodForOption", paramMap);
			generalDao.insertGernal("product.insertGoodVendorForOption", paramMap);
			custResponse.setNewIdx(id);
		} else {
			generalDao.updateGernal("product.updateGoodForOption", paramMap);
			generalDao.deleteGernal("product.deleteGoodVendorForOption", paramMap);
			generalDao.insertGernal("product.insertGoodVendorForOption", paramMap);
		}

		modelAndView.setViewName("jsonView");
		modelAndView.addObject(custResponse);
		return modelAndView;
	}
	
	/**
	 * 규격옵션 수정
	 */
	@RequestMapping("updOption.sys")
	public ModelAndView updOption(HttpServletRequest request, ModelMap paramMap, ModelAndView modelAndView) throws Exception {
		RequestUtils.bind(request, paramMap);
		CustomResponse custResponse = new CustomResponse(true);

		String [] good_iden_numb = request.getParameterValues("good_iden_numb");
		String [] good_spec = request.getParameterValues("good_spec");
		String [] pims = request.getParameterValues("pims");
		
		if (good_iden_numb != null) {
			for (int i=0; i<good_iden_numb.length;i++) {
				logger.info(good_iden_numb[i]);
				paramMap.put("good_iden_numb", good_iden_numb[i]);
				paramMap.put("good_spec", good_spec[i]);
				paramMap.put("pims", pims[i]);

				generalDao.updateGernal("product.updateGoodForOption", paramMap);
				generalDao.deleteGernal("product.deleteGoodVendorForOption", paramMap);
				generalDao.insertGernal("product.insertGoodVendorForOption", paramMap);
			}
		}

		modelAndView.setViewName("jsonView");
		modelAndView.addObject(custResponse);
		return modelAndView;
	}
	
	/**
	 * 규격옵션 삭제
	 */
	@RequestMapping("delOption.sys")
	public ModelAndView delOption(HttpServletRequest request, ModelMap paramMap, ModelAndView modelAndView) throws Exception {
		RequestUtils.bind(request, paramMap);
		CustomResponse custResponse = new CustomResponse(true);

		String [] good_iden_numb = request.getParameterValues("good_iden_numb");
		
		if (good_iden_numb != null) {
			for (int i=0; i<good_iden_numb.length;i++) {
				logger.info(good_iden_numb[i]);
				paramMap.put("good_iden_numb", good_iden_numb[i]);

				generalDao.updateGernal("product.deleteGoodForOption", paramMap);
				generalDao.deleteGernal("product.deleteGoodVendorForOption", paramMap);
			}
		}

		modelAndView.setViewName("jsonView");
		modelAndView.addObject(custResponse);
		return modelAndView;
	}
	
	/**
	 * Main전시상품 저장 
	 */
	@RequestMapping("saveMainDispGood.sys")
	public ModelAndView saveMainDispGood(HttpServletRequest request, ModelMap paramMap, ModelAndView modelAndView) throws Exception {
		RequestUtils.bind(request, paramMap);
		CustomResponse custResponse = new CustomResponse(true);

		generalDao.insertGernal("product.insertMainDispGood", paramMap);

		modelAndView.setViewName("jsonView");
		modelAndView.addObject(custResponse);
		return modelAndView;
	}
	
	
	/**
	 *  규격옵션 일괄등록
	 */
	@RequestMapping("optionExcelUpload.sys")
	public ModelAndView optionExcelUpload(@RequestParam(value = "excelFile", required=true) MultipartFile excelFile, HttpServletRequest request, ModelMap paramMap, ModelAndView modelAndView) throws Exception {
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		modelAndView = new ModelAndView("jsonView");

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
		String[] colNames = { "good_iden_numb"		,"good_spec"		, "pims"};	//엑셀의 Data Field 와 같아야 함 (DB저장시 mapKey로 쓰임)
		
		ExcelReader excelReader = new ExcelReader(multipartFileUpload.getUploadedFile());
		List<Map<String, Object>> saveList = excelReader.getExcelReadList(0, colNames);
		logger.debug("saveList.size() : "+saveList.size());
		paramMap.put("repre_good_iden_numb", paramMap.get("good_iden_numb"));
		int i=0;
		for(Map<String, Object> map : saveList) {
			if (i++ == 0) continue;
			paramMap.putAll(map);
			logger.debug("-------------------------------------------------" + paramMap.toString());
			if (StringUtils.isEmpty(paramMap.get("good_iden_numb").toString())) {
				paramMap.put("good_iden_numb", seqMcProductService.getNextStringId());	//id생성
				generalDao.updateGernal("product.insertGoodForOption", paramMap);
				generalDao.insertGernal("product.insertGoodVendorForOption", paramMap);
			} else {
				generalDao.updateGernal("product.updateGoodForOption", paramMap);
				generalDao.deleteGernal("product.deleteGoodVendorForOption", paramMap);
				generalDao.insertGernal("product.insertGoodVendorForOption", paramMap);
			}
		}

		modelAndView.setViewName("jsonView");
		modelAndView.addObject(custResponse);
		return modelAndView;
	}
	
	
	/**
	 *  규격옵션 가격(재고) 일괄등록
	 */
	@RequestMapping("optionPriceExcelUpload.sys")
	public ModelAndView optionPriceExcelUpload(@RequestParam(value = "excelFile", required=true) MultipartFile excelFile, HttpServletRequest request, ModelMap paramMap, ModelAndView modelAndView) throws Exception {
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		modelAndView = new ModelAndView("jsonView");

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
		String[] colNames = { "good_iden_numb"		,"good_spec"			,"vendorid"				,"vendornm"				
				             ,"sell_price"          ,"sale_unit_pric"       ,"chgStock"	            ,"chg_reason"};	//엑셀의 Data Field 와 같아야 함 (DB저장시 mapKey로 쓰임)
		
		ExcelReader excelReader = new ExcelReader(multipartFileUpload.getUploadedFile());
		List<Map<String, Object>> saveList = excelReader.getExcelReadList2(0, colNames);
		logger.debug("saveList.size() : "+saveList.size());
		for(Map<String, Object> map : saveList) {
//			logger.debug("-------------------------------------------------" + map.toString());
			paramMap.putAll(map);
			paramMap.put("price_chg_hist_id", seqMcPriceChgHist.getNextStringId());	//id생성
			paramMap.put("sell_sale_type", "SALE");
			generalDao.insertGernal("product.insertPriceChgHist2", paramMap);
			paramMap.put("price_chg_hist_id", seqMcPriceChgHist.getNextStringId());	//id생성
			paramMap.put("sell_sale_type", "BUY");
			generalDao.insertGernal("product.insertPriceChgHist2", paramMap);
			paramMap.put("stock_chg_hist_id", seqMcStockChgHist.getNextStringId());	//id생성
			generalDao.insertGernal("product.insertStockChgHist", paramMap);
			generalDao.updateGernal("product.updateGoodVendorForOption", paramMap);
			
		}

		modelAndView.setViewName("jsonView");
		modelAndView.addObject(custResponse);
		return modelAndView;
	}
	
	/*************************************************
	 * 고도화 추가된 사항들(공급사)
	 *************************************************/

	@SuppressWarnings({ "unchecked", "rawtypes" })
	/**
	 * 상품 등록/수정 화면
	 */
	@RequestMapping("popProductVen.sys")
	public ModelAndView popProductVen(HttpServletRequest request, ModelMap paramMap, ModelAndView modelAndView) throws Exception {

		LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		paramMap.put("vendorid", loginUserDto.getBorgId());
		
		modelAndView.setViewName("product/product/popProductVen");
		Map good = (Map) generalDao.selectGernalObject("product.selectProductForVen", paramMap);
		modelAndView.addObject("good", good);
		Map<String,Object> good_spec = (Map<String, Object>) generalDao.selectGernalObject("product.selectProductSpec", paramMap);
		modelAndView.addObject("good_spec", good_spec);
		
		if (good.get("REPRE_GOOD").toString().equals("Y")) {
			modelAndView.addObject("common", generalDao.selectGernalList("product.selectCommonOptionList", paramMap));
			modelAndView.addObject("option", generalDao.selectGernalList("product.selectSpecOptionVendorList", paramMap));
		}
		
		return modelAndView;
	}

	/**
	 * 신규상품등록요청
	 */
	@RequestMapping("popProductVenReg.sys")
	public ModelAndView popProductVenReg(HttpServletRequest request, ModelMap paramMap, ModelAndView modelAndView) throws Exception {

		modelAndView.addObject("orderUnit"			, commonSvc.getCodeList("ORDERUNIT", 1)		);			// 주문단위
		modelAndView.addObject("orderGoodsType"		, commonSvc.getCodeList("ORDERGOODSTYPE", 1)	);		// 상품구분
		modelAndView.addObject("reqAppSts"			, commonSvc.getCodeList("REQAPPSTATE", 1)			);	// 처리상태
		modelAndView.addObject("deliAreaCodeList"	, commonSvc.getCodeList("DELI_AREA_CODE", 1)	);		// 권역 

		LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		paramMap.put("vendorid", loginUserDto.getBorgId());
		modelAndView.addObject("ven", generalDao.selectGernalObject("product.selectVendor", paramMap));
		
		if (paramMap.get("req_good_id") != null) {
			modelAndView.addObject("good", generalDao.selectGernalObject("product.selectProductForReq", paramMap));
			modelAndView.addObject("good_spec", generalDao.selectGernalObject("product.selectMcGoodRequestSpec", paramMap));
		}
		
		modelAndView.setViewName("product/product/popProductVenReg");
		return modelAndView;
	}
	
	/**
	 * 상품공급사 저장 처리 
	 */
	@RequestMapping("saveVen.sys")
	public ModelAndView saveVen(HttpServletRequest request, ModelMap paramMap, ModelAndView modelAndView) throws Exception {
		
		LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		paramMap.put("VENDORID", loginUserDto.getBorgId());
		CustomResponse custResponse = new CustomResponse(true);
		
		
		paramMap.put("GOOD_SPEC"			, paramMap.get("GOOD_SPEC"	) == null ? "" : ((String)paramMap.get("GOOD_SPEC")).replace("\"","＂") ); 
		paramMap.put("good_spec"			, paramMap.get("good_spec"		) == null ? "" : ((String)paramMap.get("good_spec")).replace("\"","＂") ); 
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
		paramMap.put("spec_weight_real"	, paramMap.get("spec_weight_real") == null ? "" : ((String)paramMap.get("spec_weight_real")).replace("\"","＂") ); 
		
		/*------------상품공급사 반영-------------*/
		generalDao.updateGernal("product.updateGoodVendorForVen", paramMap);
		paramMap.put("good_hist_id",seqMcProductHistoryService.getNextIntegerId());
		generalDao.insertGernal("product.insertGoodVendorForVenHistory", paramMap);
		
		/*------------상품기본 반영-------------*/
		generalDao.updateGernal("product.updateMcGoodForVen", paramMap);
		generalDao.updateGernal("product.mergeMcGoodSpec", paramMap);
		generalDao.insertGernal("product.insertMcGoodForVenHistory", paramMap);

		modelAndView.setViewName("jsonView");
		modelAndView.addObject(custResponse);
		return modelAndView;
	}

	/**
	 * 공급사 
	 * 입찰관리
	 */
	@RequestMapping("bidList.sys")
	public ModelAndView bidList(HttpServletRequest request, ModelMap paramMap, ModelAndView modelAndView) throws Exception {

		modelAndView.setViewName("product/product/bidList");
		return modelAndView;
	}

	/**
	 * 공급사 
	 * 재고관리
	 */
	@RequestMapping("stockProductVenList.sys")
	public ModelAndView stockProductVenList(HttpServletRequest request, ModelMap paramMap, ModelAndView modelAndView) throws Exception {
		modelAndView.setViewName("product/product/stockProductVenList");
		
		return modelAndView;
	}
	
	/**
	 * <pre>
	 * 공급사 재고 관리 리스트를 조회하는 메소드
	 * 
	 * ~. paramMap구조
	 *   !. srcGoodName (검색조건 상품명)
	 *   !. srcGoodIdenNumb (검색조건 상품코드)
	 *   !. srcGoodType (검색조건 상품구분)
	 *   !. srcGoodSpecDesc (검색조건 규격)
	 *   !. srcRepreGood (검색조건 상품유형)
	 *   !. srcIsUse (검색조건 정상여부)
	 *   !. page (조회 페이지)
	 *   !. rows (페이지당 건수)
	 * </pre>
	 * 
	 * @param request
	 * @param paramMap
	 * @param modelAndView
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping("selectProductListForVen.sys")
	public ModelAndView selectProductListForVen(HttpServletRequest request, ModelMap paramMap, ModelAndView modelAndView) throws Exception {
		CustomResponse      custResponse = new CustomResponse(true);
		Map<String, Object> productList  = null;
		List<?>             list         = null;
		Integer             pageMax      = null;
		Integer             record       = null;
		String              page         = null;
		String              rows         = null;
		String              stockTotal   = null;
		
		try{
			productList  = this.productSvc.selectProductListForVen(paramMap); // 공급사 재고관리 리스트를 조회하여 반환
			list         = (List<?>)productList.get("list");
			pageMax      = (Integer)productList.get("pageMax");
			record       = (Integer)productList.get("record");
			stockTotal   = (String)productList.get("stockTotal");
			page         = (String)paramMap.get("page");
			rows         = (String)paramMap.get("rows");
		}
		catch(Exception e) {
			this.logger.error("Exception : "+e);
			
			custResponse.setSuccess(false);
			custResponse.setMessage("System Excute Error!....");
			custResponse.setMessage(CommonUtils.getErrSubString(e, 50));//Option(To Detail Message)
		}
		
		modelAndView.setViewName("jsonView");
		modelAndView.addObject("list",         list);
		modelAndView.addObject("page",         page);
		modelAndView.addObject("rows",         rows);
		modelAndView.addObject("total",        pageMax);
		modelAndView.addObject("records",      record);
		modelAndView.addObject("custResponse", custResponse);
		modelAndView.addObject("stockTotal",   stockTotal);
		
		return modelAndView;
	}
	
	/**
	 * 운영사 상품조회/재고상품 메뉴 엑셀 리스트 출력 
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping("productListExcelAdm.sys")
	public ModelAndView productListExcelAdm(
			@RequestParam(value = "sheetTitle", defaultValue = "") String sheetTitle,
			@RequestParam(value = "excelFileName", defaultValue = "") String excelFileName,
			@RequestParam(value = "colLabels", required = false) String[] colLabels,
			@RequestParam(value = "colIds", required = false) String[] colIds,
			@RequestParam(value = "numColIds", required = false) String[] numColIds,
			@RequestParam(value = "figureColIds", required = false) String[] figureColIds,
			@RequestParam(value = "sidx", defaultValue = "codeTypeId") String sidx,
			@RequestParam(value = "sord", defaultValue = "desc") String sord,
			HttpServletRequest request, ModelMap paramMap, ModelAndView modelAndView) throws Exception {
		
		
		String orderString = " " + sidx + " " + sord + " ";	//그리드의 순서를 맞추기 위해(별의미 없음!!) 
		paramMap.put("orderString", orderString);
		paramMap.put("isExcel", "1");
		List<Object> list = generalDao.selectGernalList("product.selectProductList", paramMap);
		for(Object obj : list){
			try {
				((HashMap<String, Object>)obj).put("VENDOR_SELL_RATE", CommonUtils.getString(((HashMap<String, Object>)obj).get("VENDOR_SELL_RATE")) + "%");
			} catch (Exception e) {
				logger.debug("productListExcelAdm method (VENDOR_SELL_RATE value) orccured exception.");
			}
		}
		
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
	 * 운영사 카테고리.동의어 일괄 엑셀 리스트 출력 
	 */
	@RequestMapping("productModifyExcelAdm.sys")
	public ModelAndView productModifyExcelAdm(
			@RequestParam(value = "sheetTitle", required = false) String sheetTitle,
			@RequestParam(value = "excelFileName", defaultValue = "") String excelFileName,
			@RequestParam(value = "colLabels", required = false) String[] colLabels,
			@RequestParam(value = "colIds", required = false) String[] colIds,
			@RequestParam(value = "numColIds", required = false) String[] numColIds,
			@RequestParam(value = "figureColIds", required = false) String[] figureColIds,
			@RequestParam(value = "sidx", defaultValue = "codeTypeId") String sidx,
			@RequestParam(value = "sord", defaultValue = "desc") String sord,
			HttpServletRequest request, ModelMap paramMap, ModelAndView modelAndView) throws Exception {
		
		
		String orderString = " " + sidx + " " + sord + " ";	//그리드의 순서를 맞추기 위해(별의미 없음!!) 
		paramMap.put("orderString", orderString);
		List<Object> list = generalDao.selectGernalList("product.selectProductModifyExcelList", paramMap);
		List<Object> catelist = generalDao.selectGernalList("product.selectProductCategoryExcelList", paramMap);
		
		List<Map<String, Object>> sheetList = new ArrayList<Map<String, Object>>();
		Map<String, Object> map1 = new HashMap<String, Object>();
//		map1.put("sheetTitle", sheetTitle);
		map1.put("colLabels", colLabels);
		map1.put("colIds", colIds);
		map1.put("numColIds", numColIds);
		map1.put("figureColIds", figureColIds);
		map1.put("colDataList", list);
		sheetList.add(map1);
		
		String[] colLabels2 = {"카테고리코드","카테고리명"};
		String[] colIds2 = {"CATE_CD","MAJO_CODE_NAME"};
		Map<String, Object> map2 = new HashMap<String, Object>();
		map2.put("sheetTitle", "카테고리코드_참조용");
		map2.put("colLabels", colLabels2);
		map2.put("colIds", colIds2);
		map2.put("numColIds", numColIds);
		map2.put("figureColIds", figureColIds);
		map2.put("colDataList", catelist);
		sheetList.add(map2);
		
		modelAndView.setViewName("commonExcelViewResolver");
		modelAndView.addObject("excelFileName", excelFileName);
		modelAndView.addObject("sheetList", sheetList);
		
		return modelAndView;
	}
	
	/**
	 *  상품 기본 정보및 공급사 정보 저장  product/productExcelUpload.sys
	 */
	@RequestMapping("productModifyExcelUpload.sys")
	public ModelAndView productModifyExcelUpload(
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
		String[] colNames = { "good_iden_numb","good_name","good_spec","cate_cd","good_same_word"};	//엑셀의 Data Fild 와 같아야 함 (DB저장시 mapKey로 쓰임)
		
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
		productSvc.updateProductModifyExcelUpload(saveList,loginUserDto);
		modelAndView.addObject(custResponse);
		return modelAndView;
	}
	
	
	/**
	 * 공급사 상품조회/재고상품 메뉴 엑셀 리스트 출력 
	 */
	@RequestMapping("productListExcelVen.sys")
	public ModelAndView productListExcelVen(
			@RequestParam(value = "sheetTitle", defaultValue = "") String sheetTitle,
			@RequestParam(value = "excelFileName", defaultValue = "") String excelFileName,
			@RequestParam(value = "colLabels", required = false) String[] colLabels,
			@RequestParam(value = "colIds", required = false) String[] colIds,
			@RequestParam(value = "numColIds", required = false) String[] numColIds,
			@RequestParam(value = "figureColIds", required = false) String[] figureColIds,
			@RequestParam(value = "sidx", defaultValue = "codeTypeId") String sidx,
			@RequestParam(value = "sord", defaultValue = "desc") String sord,
			HttpServletRequest request, ModelMap paramMap, ModelAndView modelAndView) throws Exception {
		
		LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		paramMap.put("srcVendorId", loginUserDto.getBorgId());
		
//		String orderString = " " + sidx + " " + sord + " ";	//그리드의 순서를 맞추기 위해(별의미 없음!!)
//		paramMap.put("orderString", orderString);
		List<Object> list = generalDao.selectGernalList("product.selectProductListForVen", paramMap);
		
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
	 *  공급사 재고수량 일괄등록
	 */
	@RequestMapping("stockExcelUpload.sys")
	public ModelAndView stockExcelUpload(@RequestParam(value = "excelFile", required=true) MultipartFile excelFile, HttpServletRequest request, ModelMap paramMap, ModelAndView modelAndView) throws Exception {
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		modelAndView = new ModelAndView("jsonView");

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
		String[] colNames = { "good_iden_numb"	   ,"good_type_nm"		   ,"repre_good_nm"			,"good_name"				
				             ,"good_spec"          ,"sale_unit_pric"       ,"inventory_cnt"         ,"chgStock"	            ,"chg_reason"};	//엑셀의 Data Field 와 같아야 함 (DB저장시 mapKey로 쓰임)
		
		ExcelReader excelReader = new ExcelReader(multipartFileUpload.getUploadedFile());
		List<Map<String, Object>> saveList = excelReader.getExcelReadList2(0, colNames);
		logger.debug("saveList.size() : "+saveList.size());

		LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		paramMap.put("vendorid", loginUserDto.getBorgId());
		
		for(Map<String, Object> map : saveList) {
//			logger.debug("-------------------------------------------------" + map.toString());
			paramMap.putAll(map);
			if (paramMap.get("chgStock").equals("") || paramMap.get("chg_reason").equals("")) continue;
			
			logger.info(paramMap.toString());
			paramMap.put("stock_chg_hist_id", seqMcStockChgHist.getNextStringId());	//id생성
			generalDao.insertGernal("product.insertStockChgHist", paramMap);
			generalDao.updateGernal("product.updateGoodVendorForOption", paramMap);
		}

		modelAndView.setViewName("jsonView");
		modelAndView.addObject(custResponse);
		return modelAndView;
	}
	
	/**
	 * 운영사 상품관리 상품조회(그리드)
	 * @param page
	 * @param rows
	 * @param sidx
	 * @param sord
	 * @param request
	 * @param modelAndView
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping("selectProductAdmList.sys")
	public ModelAndView selectProductAdmList(
			@RequestParam(value = "page", defaultValue = "1") int page,
			@RequestParam(value = "rows", defaultValue = "0") int rows,
			@RequestParam(value = "sidx", defaultValue = "") String sidx,
			@RequestParam(value = "sord", defaultValue = "") String sord,
			HttpServletRequest request, ModelAndView modelAndView, ModelMap paramMap) throws Exception {
		
		CustomResponse custResponse = new CustomResponse(true);
		try{
			String addSql = "";
			String prevWord = CommonUtils.getString(paramMap.get("prevWord"));
			String srcWord[] = prevWord.split("‡");
			if(srcWord!=null && srcWord.length>0) {
				for(int i = 0 ; i < srcWord.length ; i++) {
//					logger.debug("jameskang srcWord["+i+"] : "+srcWord[i]);
					if(srcWord[i].startsWith("＋")){
						addSql = " "+addSql + " AND (A.GOOD_NAME LIKE '%"+srcWord[i].replace("＋", "")+"%' OR B.GOOD_SAME_WORD LIKE '%"+srcWord[i].replace("＋", "")+"%' OR A.GOOD_SPEC LIKE '%"+srcWord[i].replace("＋", "")+"%')";
					} else if(srcWord[i].startsWith("－")){
						addSql = " "+addSql + " AND (A.GOOD_NAME NOT LIKE '%"+srcWord[i].replace("－", "")+"%' AND B.GOOD_SAME_WORD NOT LIKE '%"+srcWord[i].replace("－", "")+"%' AND A.GOOD_SPEC NOT LIKE '%"+srcWord[i].replace("－", "")+"%')";
					} else {
						addSql = " "+addSql + " AND (A.GOOD_NAME  LIKE '%"+srcWord[i]+"%' OR B.GOOD_SAME_WORD LIKE '%"+srcWord[i]+"%' OR A.GOOD_SPEC LIKE '%"+srcWord[i]+"%')";
					}
//					logger.debug("jameskang addSql : "+addSql);
				}
				paramMap.put("addSql", addSql);
			}
			
			String queryId = "product.selectProductList";
			int offset = (page-1)*rows;
			paramMap.put("rowBounds", new RowBounds(offset, rows));
			if(!"".equals(sidx)) {
				String orderString = " " + sidx + " " + sord + " ";
				paramMap.put("orderString", orderString);
			}
	
			int records = 0;
			int total = 0;
			if(rows>0 && rows!=10000) {
				records = generalDao.selectGernalCount(queryId+"_count", paramMap);
				total = (int)Math.ceil((float)records / (float)rows);
			}
			List<Object> list = generalDao.selectGernalList(queryId, paramMap);
			
			if(list != null && list.size() > 0){
				for(Object obj : list){
					try {
						((Map<String, Object>)obj).put("VENDOR_SELL_RATE",  CommonUtils.getString(((Map<String, Object>)obj).get("VENDOR_SELL_RATE"))  );
					} catch (Exception e) {
						logger.error("ProductCtl class, selectProductAdmList method orccured Exception : VENDOR_SELL_RATE value casting error.");
					}
				}
			}
			
			modelAndView.addObject("page", page);
			modelAndView.addObject("total", total);
			modelAndView.addObject("records", records);
			modelAndView.addObject("list", list);
		} catch(Exception e) {
			logger.error("Exception : "+e);
			custResponse.setSuccess(false);
			custResponse.setMessage("System Excute Error!....");
			custResponse.setMessage(CommonUtils.getErrSubString(e,50));	//Option(To Detail Message)
		}
		modelAndView.setViewName("jsonView");
		modelAndView.addObject("custResponse",custResponse);
		return modelAndView;
	}
	
	/**
	 * 운영사 재고 상품 리스트를 조회하는 메소드
	 * 
	 * @param request
	 * @param paramMap
	 * @param modelAndView
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping("selectProductList.sys")
	public ModelAndView selectProductList(HttpServletRequest request, ModelMap paramMap, ModelAndView modelAndView) throws Exception {
		Map<String, Object> productList  = null;
		Map<String, Object> userdata     = new HashMap<String,Object>();
		List<?>             list         = null;
		Integer             pageMax      = null;
		Integer             record       = null;
		String              page         = null;
		String              rows         = null;
		String              stockTotal   = null;
		String              orderString  = null;
		String              sidx         = (String)paramMap.get("sidx");
		String              sord         = (String)paramMap.get("sord");
		StringBuffer        stringBuffer = new StringBuffer();
		
		stringBuffer.append(sidx).append(" ").append(sord);
		
		orderString = stringBuffer.toString();
		
		paramMap.put("orderString", orderString);
		
		productList  = this.productSvc.selectProductList(paramMap); // 공급사 재고관리 리스트를 조회하여 반환
		list         = (List<?>)productList.get("list");
		pageMax      = (Integer)productList.get("pageMax");
		record       = (Integer)productList.get("record");
		stockTotal   = (String)productList.get("stockTotal");
		page         = (String)paramMap.get("page");
		rows         = (String)paramMap.get("rows");
		
		userdata.put("stockTotal", stockTotal);
		
		modelAndView.setViewName("jsonView");
		modelAndView.addObject("list",     list);
		modelAndView.addObject("page",     page);
		modelAndView.addObject("rows",     rows);
		modelAndView.addObject("total",    pageMax);
		modelAndView.addObject("records",  record);
		modelAndView.addObject("userdata", userdata);
		
		return modelAndView;
	}
	
	
	/** * 운영사 일괄등록양식엑셀다운 */
	@SuppressWarnings("unchecked")
	@RequestMapping("allFormGoodExcelList.sys")
	public ModelAndView allFormGoodExcelList(
			@RequestParam(value = "sheetTitle", defaultValue = "") String sheetTitle,
			@RequestParam(value = "excelFileName", defaultValue = "") String excelFileName,
			@RequestParam(value = "colLabels", required = false) String[] colLabels,
			@RequestParam(value = "colIds", required = false) String[] colIds,
			@RequestParam(value = "numColIds", required = false) String[] numColIds,
			@RequestParam(value = "figureColIds", required = false) String[] figureColIds,
			@RequestParam(value = "sidx", defaultValue = "codeTypeId") String sidx,
			@RequestParam(value = "sord", defaultValue = "desc") String sord,
			HttpServletRequest request, ModelMap paramMap, ModelAndView modelAndView) throws Exception {
		List<Object> list = generalDao.selectGernalList("product.selectExportExcelProductInfo", paramMap);
		for(Object obj : list){
			try {
				((HashMap<String, Object>)obj).put("VENDOR_SELL_RATE", CommonUtils.getString(((HashMap<String, Object>)obj).get("VENDOR_SELL_RATE")) + "%");
			} catch (Exception e) {
				logger.debug("productListExcelAdm method (VENDOR_SELL_RATE value) orccured exception.");
			}
		}
		
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
}