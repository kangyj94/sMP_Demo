package kr.co.bitcube.product.service; 

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import kr.co.bitcube.common.dao.GeneralDao;
import kr.co.bitcube.common.dto.LoginUserDto;
import kr.co.bitcube.common.service.CommonSvc;
import kr.co.bitcube.common.utils.CommonUtils;
import kr.co.bitcube.common.utils.Constances;
import kr.co.bitcube.product.dao.ProductDao;
import kr.co.bitcube.product.dto.BuyProductDto;
import kr.co.bitcube.product.dto.ProductDto;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.ModelMap;
import org.springframework.web.servlet.ModelAndView;

import egovframework.rte.fdl.cmmn.exception.FdlException;
import egovframework.rte.fdl.idgnr.EgovIdGnrService;

@Service
public class ProductSvc {
	
	private Logger logger = Logger.getLogger(getClass());
	@Autowired
	private ProductDao productDao;
	
	@Autowired private GeneralDao generalDao;
	
	@Autowired
	private ProductAppSvc productAppSvc;
	
	@Autowired
	private CommonSvc commonSvc;
	
	@Resource(name="seqMcProductService")
	private EgovIdGnrService seqMcProductService;
	
	@Resource(name="seqMcProductHistoryService")
	private EgovIdGnrService seqMcProductHistoryService;
	
	@Resource(name="seqMcAppProductService")
	private EgovIdGnrService seqMcAppProductService;
	
	@Resource(name="seqMcPriceChgHist")
	private EgovIdGnrService seqMcPriceChgHist;
	
	@Resource(name="seqMcGoodDisplay")
	private EgovIdGnrService seqMcGoodDisplay;
	@Resource(name="seqMcGoodDisplayBranch")
	private EgovIdGnrService seqMcGoodDisplayBranch;
	
	
	
	public int getProductListCnt(Map<String, Object> params) {
		return productDao.selectProductListCnt(params);
	}
	
	/**
	 * 운영사 상품 검색 Count 
	 * @param params
	 * @return
	 */
	public int getProductListCntForAdmin(Map<String, Object> params) {
		return productDao.selectProductListCntForAdmin(params);
	}
	
	public List<ProductDto> getProductList(Map<String, Object> params, int page, int rows) {
		return productDao.selectProductList(params, page, rows);
	}
	
	/**
	 * 운영사 상품 검색 List
	 * @param params
	 * @param page
	 * @param rows
	 * @return
	 */
	public List<ProductDto> getProductListForAdmin(Map<String, Object> params, int page, int rows) {
		return productDao.selectProductListForAdmin(params, page, rows);
	}
	
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false)
	public Map<String, ProductDto> getProductDetailInfo(String goodIdenNumb) throws Exception{
		Map<String, ProductDto> map = new HashMap<String, ProductDto>();
		Map<String, Object> params = new HashMap<String, Object>();
		
		params.put("goodIdenNumb", goodIdenNumb);
		ProductDto detailInfo = this.productDao.selectProductInfo(params);
		map.put("detailInfo", detailInfo);
		return map;
	}
	
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false)
	public String regGood(Map<String, Object> saveMap) throws Exception {
		String prodSequence = seqMcProductService.getNextStringId();
		String prodHistorySequence = seqMcProductHistoryService.getNextStringId();
		saveMap.put("goodIdenNumb", CommonUtils.stringParseInt(prodSequence, 0));
		saveMap.put("goodHistId", CommonUtils.stringParseInt(prodHistorySequence,0));
		productDao.insertGood(saveMap);
		productDao.insertGoodHist(saveMap);
		return prodSequence; 
	}
	
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false)
	public void modGood(Map<String, Object> saveMap) throws Exception {
		String prodHistorySequence = seqMcProductHistoryService.getNextStringId();
		saveMap.put("goodHistId", CommonUtils.stringParseInt(prodHistorySequence, 0));
		productDao.updateGood(saveMap);
		productDao.insertGoodHist(saveMap);
	}
	
	public List<ProductDto> getGoodVendorList(Map<String, Object> params) {
		return productDao.selectGoodVendorList(params);
	}
	
	public List<ProductDto> getSaleUnitPricList(Map<String, Object> params) {
		return productDao.selectSaleUnitPricList(params);
	}
	
	public ProductDto getGoodVendorDetailInfo(Map<String, Object> params) {
		return productDao.selectGoodVendorDetailInfo(params);
	}
	
	public ProductDto getVendorDetailInfo(Map<String, Object> params) {
		return productDao.selectVendorDetailInfo(params);
	}
	
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false)
	public void regGoodVendor(Map<String, Object> saveMap) throws Exception {
		String prodHistorySequence = seqMcProductHistoryService.getNextStringId();
		saveMap.put("goodHistId", CommonUtils.stringParseInt(prodHistorySequence, 0));
		productDao.insertGoodVendor(saveMap);
		productDao.insertGoodVendorHist(saveMap);
	}
	
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false)
	public void modGoodVendor(Map<String, Object> saveMap) throws Exception {
		String prodHistorySequence = seqMcProductHistoryService.getNextStringId();
		saveMap.put("goodHistId", CommonUtils.stringParseInt(prodHistorySequence, 0));
		productDao.updateGoodVendor(saveMap);
		productDao.insertGoodVendorHist(saveMap);
	}
	
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false)
	public void delGoodVendor(Map<String, Object> saveMap) throws Exception {
		String prodHistorySequence = seqMcProductHistoryService.getNextStringId();
		saveMap.put("goodHistId", CommonUtils.stringParseInt(prodHistorySequence, 0));
		productDao.deleteGoodVendor(saveMap);
		productDao.insertGoodVendorHist(saveMap);
	}
	
	public int getDisplayGoodListCnt(Map<String, Object> params) {
		return productDao.selectDisplayGoodListCnt(params);
	}
	
	/**
	 * 상품 진열 중복 체크 ( 상품코드 , 공급사 , 그룹 , 법인 , 사업장 , final_good_sts )
	 * @param params
	 * @return
	 */
	public int getDispProductListCnt(Map<String, Object> params) {
		return productDao.selectDispProductListCnt(params);
	}
	
	public List<ProductDto> getDisplayGoodList(Map<String, Object> params, int page, int rows) {
		return productDao.selectDisplayGoodList(params, page, rows);
	}
	
	public List<ProductDto> getDisplayGoodHistList(Map<String, Object> params) {
		return productDao.selectDisplayGoodHistList(params);
	}
	
	/**
	 * 판가정보 변경에 따른 처리 Process 
	 * @param params
	 * @param modelAndView
	 * @throws Exception
	 */
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false)
	public void setDispProductAddRow(Map<String, Object> saveMap, ModelAndView modelAndView) throws Exception {
		if("add".equals((String)saveMap.get("oper"))) {	//추가
			int records = this.getDispProductListCnt(saveMap);
			if(records>0) {
				modelAndView.addObject("msg", "이미 등록된 판가정보입니다.");
			} else {
				this.regDisplayGoodAppGoodPrice(saveMap);
//				if(!Constances.PROD_APPROVAL_FLAG) {
//					this.appDisplayGoodAppGoodPrice(saveMap);
//				}
				modelAndView.addObject("msg", "등록 되었습니다.");
			}
		} else if("edit".equals((String)saveMap.get("oper"))) {	//수정
			this.regDisplayGoodAppGoodPrice(saveMap);
			if(!Constances.PROD_APPROVAL_FLAG) {
				this.appDisplayGoodAppGoodPrice(saveMap);
			}
			modelAndView.addObject("msg", "수정 되었습니다.");
		}
	}
	
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false)
	public void regDisplayGoodAppGoodPrice(Map<String, Object> saveMap) throws Exception {
		String prodSequence = seqMcProductService.getNextStringId();
		saveMap.put("dispGoodId", CommonUtils.stringParseInt(prodSequence, 0));
		String appProdSequence = seqMcAppProductService.getNextStringId();
		saveMap.put("appGoodId", CommonUtils.stringParseInt(appProdSequence, 0));
		productDao.insertDisplayGood(saveMap);
		productDao.insertAppGoodPrice(saveMap);
		
		saveMap.put("prodSequence", prodSequence);
		saveMap.put("appProdSequence", appProdSequence);
	}
	
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false)
	public void appDisplayGoodAppGoodPrice(Map<String, Object> saveMap) throws Exception {
		productDao.updateAppGoodPrice(saveMap);
		if((Integer)saveMap.get("refGoodSeq") != 0) {
			productDao.updateRefDisplayGood(saveMap);
		}
		productDao.updateDisplayGood(saveMap);
	}
	
	/**
	 * (운영사)가격진열 과거상품 진열여부 수정 
	 * @param params
	 */
	public void displayGoodUpdateTrans(Map<String, Object> params){
		String[] dispGoodIdArray = (String[])params.get("dispGoodIdArray");
		int arrIndex = 0 ; 
		for(String dispGoodId:dispGoodIdArray) {
			String ispastSellFlag = ((String[])params.get("ispastSellFlagArray"))[arrIndex];
			Map<String, Object> saveMap = new HashMap<String,Object>();
			saveMap.put("dispGoodId", dispGoodId);
			saveMap.put("ispastSellFlag", ispastSellFlag);
			productDao.updatedisplayGoodUpdateTrans(saveMap);
			arrIndex++;
		}
	}
	
	/**
	 * (운영사) 상품종료요청 검색 Count
	 * @param params
	 * @return
	 */
	public int getProductRequestDiscontinuanceListCnt(Map<String, Object> params) {
		return productDao.selectProductRequestDiscontinuanceListCnt(params);
	}
	
	/**
	 * (운영사) 상품종료요청 검색 List
	 * @param params
	 * @return
	 */
	public List<ProductDto> getProductRequestDiscontinuanceList(Map<String, Object> params, int page, int rows) {
		return productDao.selectProductRequestDiscontinuanceList(params, page, rows);
	}
	
	/**
	 * (운영사) 공급사품목변경 상태값 변경
	 * @param saveMap
	 * @return
	 */
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})
	public void productRequestDiscontinuanceStatusTrans(Map<String, Object> saveMap) throws Exception {
		String[] fix_good_id_array= (String[]) saveMap.get("fix_good_id_array");
		String[] good_iden_numb_array= (String[]) saveMap.get("good_iden_numb_array");
		String[] vendorid_array= (String[]) saveMap.get("vendorid_array");
		String[] applt_fix_code_array= (String[]) saveMap.get("applt_fix_code_array");
		String[] price_array= (String[]) saveMap.get("price_array");
		String[] sale_unit_pric_array= (String[]) saveMap.get("sale_unit_pric_array");
		String[] apply_desc_array= (String[]) saveMap.get("apply_desc_array");
		String[] insert_user_id_array= (String[]) saveMap.get("insert_user_id_array");
		String[] insert_date_array= (String[]) saveMap.get("insert_date_array");
		String[] target_price_array= (String[]) saveMap.get("target_price_array");
		
		int cnt = 0;
		for(String fix_good_id: fix_good_id_array) {
			saveMap.put("fixGoodId", fix_good_id);
			logger.debug("saveMap1 value ["+saveMap+"]");
			productDao.updateGoodFix(saveMap);
			if("1".equals((String)saveMap.get("fixAppSts"))) {
				//확인+품의요청+
				String appProdSequence = seqMcAppProductService.getNextStringId();
				saveMap.put("appGoodId", CommonUtils.stringParseInt(appProdSequence, 0));
				saveMap.put("chnPriceClas", applt_fix_code_array[cnt]);
				saveMap.put("goodIdenNumb", good_iden_numb_array[cnt]);
				saveMap.put("dispGoodId", "");
				saveMap.put("beforePrice", sale_unit_pric_array[cnt]);
				saveMap.put("afterPrice", price_array[cnt]);
				saveMap.put("changeReason", apply_desc_array[cnt]);
				saveMap.put("appStsFlag", "0");
				saveMap.put("registerUserid", insert_user_id_array[cnt]);
				saveMap.put("registerDate", insert_date_array[cnt]);
				saveMap.put("vendorId", vendorid_array[cnt]);
				
				logger.debug("saveMap2 value ["+saveMap+"]");
				productDao.insertAppGoodPrice2(saveMap);//123
			} else if("2".equals((String)saveMap.get("fixAppSts"))) {
				saveMap.put("fix_good_id", fix_good_id);
				saveMap.put("good_iden_numb", good_iden_numb_array[cnt]);
				saveMap.put("vendorid", vendorid_array[cnt]);
				
				//승인+처리완료+
				if("20".equals(applt_fix_code_array[cnt])) {
					//단가변경요청
					String price_chg_hist_id = seqMcPriceChgHist.getNextStringId();
					saveMap.put("price_chg_hist_id", price_chg_hist_id);	//id생성
					saveMap.put("sell_sale_type", "BUY");
					saveMap.put("sellPrice", target_price_array[cnt]);
					saveMap.put("chgprice", price_array[cnt]);
					saveMap.put("chg_reason", "[공급사요청] "+apply_desc_array[cnt]);
					saveMap.put("good_iden_numb", good_iden_numb_array[cnt]);
					saveMap.put("vendorid", vendorid_array[cnt]);
					productDao.insertPriceChgHist(saveMap);
					productDao.updateGoodVendorForPrice(saveMap);
				} else if("30".equals(applt_fix_code_array[cnt])) {
					//종료요청
					logger.info("=======================================================");
					logger.debug("saveMap4 value ["+saveMap+"]");
					
					String price_chg_hist_id = seqMcPriceChgHist.getNextStringId();
					saveMap.put("price_chg_hist_id", price_chg_hist_id);	//id생성
					saveMap.put("sell_sale_type", "BUY");
					saveMap.put("chgprice", "0");
					saveMap.put("chg_reason", apply_desc_array[cnt]);
					saveMap.put("good_iden_numb", good_iden_numb_array[cnt]);
					saveMap.put("vendorid", vendorid_array[cnt]);
					productDao.insertPriceChgHist(saveMap);
					
					price_chg_hist_id = seqMcPriceChgHist.getNextStringId();
					saveMap.put("price_chg_hist_id", price_chg_hist_id);	//id생성
					saveMap.put("sell_sale_type", "SALE");
					saveMap.put("chgprice", "0");
					saveMap.put("chg_reason", apply_desc_array[cnt]);
					saveMap.put("good_iden_numb", good_iden_numb_array[cnt]);
					saveMap.put("vendorid", vendorid_array[cnt]);
					productDao.insertPriceChgHist(saveMap);
					
					productAppSvc.setSoldOutProduct(saveMap);
				}
			}
			cnt++;
		}
	}
	
	/**
	 * (고객사) 상품검색 Count 조회
	 * @param params
	 * @return
	 */
	public int getBuyProductSearchCnt(Map<String, Object> params) {
		return productDao.selectBuyProductSearchCnt(params);
	}
	
	/**
	 * (고객사) 상품검색 Count 조회 Test 비트큐브 임상건 2014-05-15
	 * @param params
	 * @return
	 */
	public int getBuyProductSearchCntPriority(Map<String, Object> params) {
		return productDao.selectBuyProductSearchCntPriority(params);
	}
	
	/**
	 * (고객사) 상품검색 조회
	 * @param params
	 * @param page
	 * @param rows
	 * @return
	 */
	public List<BuyProductDto> getBuyProductSearchList(Map<String, Object> params, int page, int rows) {
		return (List<BuyProductDto>) productDao.selectBuyProductSearchList(params, page, rows);
	}
	
	/**
	 * (고객사) 상품검색 조회 Test 비트큐브 임상건 2014-05-15
	 * @param params
	 * @param page
	 * @param rows
	 * @return
	 */
	public List<BuyProductDto> getBuyProductSearchListPriority(Map<String, Object> params, int page, int rows) {		
		return (List<BuyProductDto>) productDao.selectBuyProductSearchListPriority(params, page, rows);
	}
	
	/**
	 * (고객사) 상품별 공급사 List 비트큐브 임상건 2014-05-19
	 * @param params
	 * @param page
	 * @param rows
	 * @return
	 */
	public List<BuyProductDto> getBuyProductListTemp(Map<String, Object> params) {		
		return (List<BuyProductDto>) productDao.selectBuyProductListTemp(params);
	}

	/**
	 * (공급사) 상품검색 조회
	 * @param params
	 * @param page
	 * @param rows
	 * @return
	 */
	public List<ProductDto> getCommonProductSearchListByVendor(Map<String, Object> params) {
		return (List<ProductDto>) productDao.selectCommonProductSearchListByVendor(params);
	}
	
	/**
	 * (공급사) 상품 선택후 상세 
	 */
	public List<ProductDto>  getChoiceProductListInfoByVendor (Map<String, Object> params) {
		return (List<ProductDto>) productDao.selectChoiceProductListInfoByVendor(params);
	}
	
	/**
	 * (공급사) 상품 검색 Count
	 * @param params
	 * @return
	 */
	public int getVenProductListCnt(Map<String, Object> params) {
		return productDao.selectVenProductListCnt(params);
	}
	
	/**
	 * (공급사) 상품 검색 List
	 * @param params
	 * @return
	 */
	public List<ProductDto> getVenProductList(Map<String, Object> params, int page, int rows) {
		return productDao.selectVenProductList(params, page, rows);
	}
	
	/**
	 * (공급사) 상품등록요청 검색 Count
	 * @param params
	 * @return
	 */
	public int getProductRequestRegistListCnt(Map<String, Object> params) {
		return productDao.selectProductRequestRegistListCnt(params);
	}
	
	/**
	 * (공급사) 상품등록요청 검색 List
	 * @param params
	 * @return
	 */
	public List<ProductDto> getProductRequestRegistList(Map<String, Object> params, int page, int rows) {
		return productDao.selectProductRequestRegistList(params, page, rows);
	}
	
	/**
	 * (고객사) 관심품목 등록
	 * @param params
	 * @return
	 */
	public void addInterestProduct(Map<String, Object> params){
		String[] disp_good_id_array = (String[])params.get("disp_good_id_array");
		for(String disp_good_id : disp_good_id_array) {
			Map<String, Object> saveMap = new HashMap<String,Object>();
			saveMap.put("disp_good_id"	, disp_good_id				);
			saveMap.put("groupId"	, (String)params.get("groupId")	);
			saveMap.put("clientId"	, (String)params.get("clientId"));
			saveMap.put("branchId"	, (String)params.get("branchId"));
			saveMap.put("userId"	, (String)params.get("userId")	);
			
			int rowCnt = productDao.selectInterestProductCnt(saveMap);
			if(rowCnt== 0) {
				productDao.insertInterestProduct(saveMap);
			}
		}
	}
	
	/**
	 * (고객사) 관심품목 삭제
	 * @param params
	 * @return
	 */
	public void delInterestProduct(Map<String, Object> params){
		String[] disp_good_id_array = (String[])params.get("disp_good_id_array");
		for(String disp_good_id : disp_good_id_array) {
			Map<String, Object> saveMap = new HashMap<String,Object>();
			saveMap.put("disp_good_id"	, disp_good_id				);
			saveMap.put("groupId"	, (String)params.get("groupId")	);
			saveMap.put("clientId"	, (String)params.get("clientId"));
			saveMap.put("branchId"	, (String)params.get("branchId"));
			saveMap.put("userId"	, (String)params.get("userId")	);
			
			productDao.deleteInterestProduct(saveMap);
		}
	}
	
	
	/**
	 * (고객사) 관심품목 Count 조회
	 * @param params
	 * @return
	 */
	public int getBuyWishListCnt(Map<String, Object> params) {
		return productDao.selectBuyWishListCnt(params);
	}
	
	/**
	 * (고객사) 관심품목 조회
	 * @param params
	 * @param page
	 * @param rows
	 * @return
	 */
	public List<BuyProductDto> getBuyWishList(Map<String, Object> params, int page, int rows) {
		return (List<BuyProductDto>) productDao.selectBuyWishList(params, page, rows);
	}
	
	/**
	 * (고객사) 상품상세 조회 
	 * @param params
	 * @return
	 */
	public BuyProductDto getProductDetailInfoForBuyer(Map<String, Object> params){
		return (BuyProductDto) productDao.selectProductDetailInfoForBuyer(params);
	}
	
	/**
	 * (고객사) 과거 상품가격 정보 조회 
	 * @param params
	 * @return
	 */
	public List<BuyProductDto> getPastProductPriceInfo(Map<String, Object> params){
		return (List<BuyProductDto>) productDao.selectPastProductPriceInfo(params);
	}

	/** 물류센터 수탁상품 재고 조회*/
	public int getCenStockCntSearchCountRow(Map<String, Object> params) {
		return productDao.selectCenStockCntSearchCountRow(params);
	}
	/** 물류센터 수탁상품 재고 조회*/
	public List<ProductDto> getCenStockCntSearchList( Map<String, Object> params, int page, int rows) {
		return (List<ProductDto>) productDao.selectCenStockCntSearchList(params,page,rows);
	}
	/** 물류센터 수탁상품 재고 조회 - 상세 */
	public int getCenStockCntSearchPopCountRow(Map<String, Object> params) {
		return productDao.selectCenStockCntSearchPopCountRow(params);
	}
	/** 물류센터 수탁상품 재고 조회 - 상세 */
	public List<ProductDto> getCenStockCntSearchPopList( Map<String, Object> params, int page, int rows) {
		List<ProductDto> returnList = new ArrayList<ProductDto>();
		List<ProductDto> resultList =  productDao.selectCenStockCntSearchPopList(params,page,rows);
		ProductDto tempPd = null;
		int cnt = 0;
		String tempGoodInventory = null;
		for(ProductDto pd : resultList){
			if(cnt > 0){
				if(!tempGoodInventory.equals(pd.getGood_Inventory_Cnt())){
					tempPd = new ProductDto();
					tempPd.setGood_Name(pd.getGood_Name());
					tempPd.setVendorNm(pd.getVendorNm());
					tempPd.setGood_Inventory_Cnt(pd.getGood_Inventory_Cnt());
					tempPd.setRegist_Date(pd.getRegist_Date());
					returnList.add(tempPd);
				}
			}else{
				returnList.add(pd);
			}
			tempGoodInventory = pd.getGood_Inventory_Cnt();
			cnt++;
		}
		return returnList;
	}
	
	/**
	 * (고객사) 상품검색 Count 조회 운영사가
	 * @param params
	 * @return
	 */
	@Deprecated
	public int getBuyProductSearchByAdmCnt(Map<String, Object> params) {
		return productDao.selectBuyProductSearchByAdmCnt(params);
	}
	
	/**
	 * (고객사) 상품검색 조회 운영사가
	 * @param params
	 * @param page
	 * @param rows
	 * @return
	 */
	@Deprecated
	public List<BuyProductDto> getBuyProductSearchByAmdList(Map<String, Object> params, int page, int rows) {
		return (List<BuyProductDto>) productDao.selectBuyProductSearchByAdmList(params, page, rows);
	}

	public void saveProductCategory(Map<String, Object> saveMap) {
		productDao.updateProductCategory(saveMap);
	}
	
	/**
	 * 통합검색 카운트
	 * @param params
	 * @return
	 */
	public int getProductResultListCnt(Map<String, Object> params) {
		String addSql = this.getTotSearchAddSql(params);
		params.put("addSql", addSql);
		return productDao.getProductResultListCnt(params);
	}
	public int getProductResultGridListCnt(Map<String, Object> params) {
		String addSql = this.getTotSearchAddSql(params);
		params.put("addSql", addSql);
		return productDao.getProductResultGridListCnt(params);
	}
	
	
	/**
	 * 통합검색 List
	 * @param params
	 * @param page
	 * @param rows
	 * @return
	 */
	public List<Map<String, Object>> getProductResultList(Map<String, Object> params,int pIdx,int pCnt) {
		params.put("addSql", this.getTotSearchAddSql(params));
		String userGoodFlag = CommonUtils.getString(params.get("userGoodFlag"));	//관심상품리스트를 가져오기 위한 플래그
		List<Map<String, Object>> list = null;
		if("T".equals(userGoodFlag)) {
			list = productDao.selectUserGoodByUserInfo(params);
		} else {
			list = productDao.getProductResultList(params,pIdx,pCnt);
		}
		
		if(list != null && list.size() > 0){
			for(int i = 0 ; i < list.size() ; i++){
				if("Y".equals(list.get(i).get("VENDOR_EXPOSE").toString()) ){
					params.put("goodIdenNumb", list.get(i).get("GOOD_IDEN_NUMB").toString());
					params.put("vendorId"	 , null);
					list.get(i).put("info", productDao.getProductResultInfo(params));
				} else {
					params.put("goodIdenNumb", list.get(i).get("GOOD_IDEN_NUMB").toString());
					List<Map<String, Object>> info = productDao.getProductResultOne(params);
					params.put("goodIdenNumb"	, info.get(0).get("GOOD_IDEN_NUMB"));
					params.put("vendorId"		, info.get(0).get("VENDORID"));
					list.get(i).put("info", productDao.getProductResultInfo(params));
				}
			}
		}
		return list;
	}
	public List<Map<String, Object>> selectProductSearchResultList(Map<String, Object> params,int pIdx,int pCnt) {
		params.put("addSql", this.getTotSearchAddSql(params));
		List<Map<String, Object>> list = productDao.selectProductSearchResultList(params,pIdx,pCnt);
		for(Map<String, Object> tmpMap : list) {
			List<Map<String,Object>> vendorList = new ArrayList<Map<String,Object>>();
			Map<String,Object> vendorMap = new HashMap<String,Object>();
			vendorMap.put("VENDORID",			tmpMap.get("VENDORID"));
			vendorMap.put("VENDORNM",			tmpMap.get("VENDORNM"));
			vendorMap.put("IMG_PATH",			tmpMap.get("IMG_PATH"));
			vendorMap.put("DELI_MINI_DAY",		tmpMap.get("DELI_MINI_DAY"));
			vendorMap.put("MAKE_COMP_NAME",		tmpMap.get("MAKE_COMP_NAME"));
			vendorMap.put("SELL_PRICE",			tmpMap.get("SELL_PRICE"));
			vendorMap.put("DELI_MINI_QUAN",		tmpMap.get("DELI_MINI_QUAN"));
			vendorMap.put("GOOD_INVENTORY_CNT",	tmpMap.get("GOOD_INVENTORY_CNT"));
			vendorMap.put("LARGE_IMG_PATH",		tmpMap.get("LARGE_IMG_PATH"));
			vendorList.add(vendorMap);
			int vendorCnt = (int) tmpMap.get("VENDORCNT");
			String vendorExpose = CommonUtils.getString(tmpMap.get("VENDOR_EXPOSE"));
			if(vendorCnt>1 && "Y".equals(vendorExpose)) {
				params.put("good_iden_numb", tmpMap.get("GOOD_IDEN_NUMB"));
				params.put("vendorid", tmpMap.get("VENDORID"));
				List<Map<String,Object>> tmpVendorList = productDao.selectProductSearchResultVendorList(params);
				for(Map<String,Object> tmpMap2 : tmpVendorList) {
					vendorList.add(tmpMap2);
				}
			}
			tmpMap.put("info", vendorList);
		}
		return list;
	}
	
	
	public List<Map<String, Object>> getProductResultGridList(Map<String, Object> params,int pIdx,int pCnt) {
		params.put("addSql", this.getTotSearchAddSql(params));
		List<Map<String, Object>> list = productDao.getProductResultGridList(params,pIdx,pCnt);
		return list;
	}
	
	public Map<String, Object> getChoiceVendorInfo(Map<String, Object> params) {
		return productDao.getChoiceVendorInfo(params);
	}

	public List<Map<String, Object>> getSideCateList(String branchId) {
		Map<String, Object> daoParam = new HashMap<String, Object>();
		
		daoParam.put("branchId", branchId);
		
		return productDao.getSideCateList(daoParam);
	}
	
	/**
	 * <pre>
	 * 상품 검색 조건 쿼리 중 검색 내용을 반환하는 메소드
	 * 
	 * ~. param map 구조
	 *   !. stringBuffer (StringBuffer, 쿼리를 담을 객체)
	 *   !. srcWordInfo (String, 검색단어)
	 *   !. prefix (String, 검색 조건 prefix 문자열, [WHERE, AND])
	 *   !. isPlus (Boolean, 검색 포함여부, true : 검색포함, false : 검색 미포함)
	 * </pre>
	 * 
	 * @param param
	 * @return StringBuffer
	 */
	private StringBuffer getTotSearchAddSqlBase(Map<String, Object> param){
		StringBuffer stringBuffer        = (StringBuffer)param.get("stringBuffer");
		String       srcWordInfo         = (String)param.get("srcWordInfo");
		String       prefix              = (String)param.get("prefix");
		boolean      isPlus              = (Boolean)param.get("isPlus");
		boolean      isSrcWordInfoNumber = false;
		
		if(isPlus){
			srcWordInfo = srcWordInfo.replace("＋", "");
		}
		else{
			srcWordInfo = srcWordInfo.replace("－", "");
		}
		
		isSrcWordInfoNumber = CommonUtils.CheckNumber(srcWordInfo); // 숫자여부 판단
		
		this.logger.debug("isSrcWordInfoNumber : " + isSrcWordInfoNumber);
		
		stringBuffer.append(" ").append(prefix).append(" ( ");
		stringBuffer.append(	"B.GOOD_SAME_WORD ");
		
		if(isPlus == false){
			stringBuffer.append(	"NOT ");
		}
		
		stringBuffer.append(		"LIKE '%").append(srcWordInfo).append("%' ");
		if(isPlus == false){
			stringBuffer.append(	"AND ");
		} else {
			stringBuffer.append(	"OR ");
		}
		stringBuffer.append(	"A.GOOD_NAME ");
		
		if(isPlus == false){
			stringBuffer.append(	"NOT ");
		}
		
		stringBuffer.append(		"LIKE '%").append(srcWordInfo).append("%' ");
		if(isPlus == false){
			stringBuffer.append(	"AND ");
		} else {
			stringBuffer.append(	"OR ");
		}
		stringBuffer.append(	"A.GOOD_SPEC ");

		if(isPlus == false){
			stringBuffer.append(	"NOT ");
		}
		
		stringBuffer.append(		"LIKE '%").append(srcWordInfo).append("%' ");
		
		if(isSrcWordInfoNumber){
			if(isPlus == false){
				stringBuffer.append(	"AND ");
			} else {
				stringBuffer.append(	"OR ");
			}
			stringBuffer.append(	"A.GOOD_IDEN_NUMB ");

			if(isPlus == false){
				stringBuffer.append(	"!");
			}
			
			stringBuffer.append(		"= '").append(srcWordInfo).append("' ");
		}
		
		if(isPlus == false){
			stringBuffer.append(	"AND ");
		} else {
			stringBuffer.append(	"OR ");
		}
		stringBuffer.append(	"C.VENDORNM ");

		if(isPlus == false){
			stringBuffer.append(	"NOT ");
		}
		
		stringBuffer.append(		"LIKE '%").append(srcWordInfo).append("%' ");
		stringBuffer.append(")");
		
		return stringBuffer;
	}
	
	/**
	 * <pre>
	 * 상품 검색 조건 쿼리를 반화하는 메소드
	 * 
	 * ~. params 구조
	 *   !. inputWord
	 *   !. searchType
	 *   !. prevWord
	 * </pre>
	 * 
	 * @param params
	 * @return String
	 */
	public String getTotSearchAddSql (Map<String, Object> params){
		String              inputWord     = CommonUtils.getString(params.get("inputWord"));
		String              searchType    = CommonUtils.getString(params.get("searchType"));
		String              prevWord      = CommonUtils.getString(params.get("prevWord"));
		String              srcWord[]     = null;
		String              addSql        = "";
		String              prefix        = "WHERE";
		String              srcWordInfo   = null;
		StringBuffer        stringBuffer  = new StringBuffer();
		Map<String, Object> sqlParam      = new HashMap<String, Object>();
		int                 srcWordLength = 0;
		int                 i             = 0;
		boolean             isPlusSearch  = false;
		boolean             isMinusSearch = false;
		
		if("Y".equals(searchType)){
			srcWord       = prevWord.split("‡");
			srcWordLength = srcWord.length;
			
			for(i = 0 ; i < srcWordLength; i++){
				srcWordInfo   = srcWord[i];
				isPlusSearch  = srcWordInfo.startsWith("＋");
				isMinusSearch = srcWordInfo.startsWith("－");
				
				if(i != 0){
					prefix = "AND"; 
				}
				
				sqlParam.clear();
				sqlParam.put("stringBuffer", stringBuffer);
				sqlParam.put("srcWordInfo",  srcWordInfo);
				sqlParam.put("prefix",       prefix);
				
				if(isPlusSearch){ //추가어
					sqlParam.put("isPlus", true);
					
					stringBuffer = this.getTotSearchAddSqlBase(sqlParam);
				}
				else if(isMinusSearch){	//제외어
					sqlParam.put("isPlus", false);
					
					stringBuffer = this.getTotSearchAddSqlBase(sqlParam);
				}
			}
		}
		else{
			if("".equals(inputWord)){
				inputWord = prevWord;
			}
			
			sqlParam.put("stringBuffer", stringBuffer);
			sqlParam.put("srcWordInfo",  inputWord);
			sqlParam.put("prefix",       prefix);
			sqlParam.put("isPlus", true);
			
			stringBuffer = this.getTotSearchAddSqlBase(sqlParam);
		}
		
		addSql = stringBuffer.toString();
		
		return addSql;
	}

	public Map<String, Object> getProductOption(Map<String, Object> params) {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		//상품 공통옵션 조회
		List<Map<String, Object>> commonOptList = productDao.getCommonOption(params);
		//옵션상품 조회
//		List<Map<String, Object>> addOptList = productDao.getAddOption(params);
		resultMap.put("commonOptList", commonOptList);
//		resultMap.put("addOptList"	 , addOptList);
		return resultMap;
	}
	



	/** 공급사 추가상품 상품 상세 정보 조회 */
	public List<Map<String, Object>> selectVenProductDetailInfoPop( Map<String, Object> params) {
		return productDao.selectVenProductDetailInfoPop(params);
	}

	/** 옵션상품의 경우 대표 상품 코드를 리턴함 */
	public String selectProductAttribute(String goodIdenNumb) throws Exception {
		Map<String, Object> tempProductInfo =  productDao.selectProductAttribute(goodIdenNumb);
		String tempGoodIdenNumb = CommonUtils.getString(""+tempProductInfo.get("GOOD_IDEN_NUMB"));
		if("".equals(tempGoodIdenNumb)){
			throw new Exception("대표 옵션 정보 없음.");
		}
		return tempGoodIdenNumb;
	}

	
	/** 공급사 역주문 상품조회 카운트 */
	public int venOrdReqSrcPdtListCnt(Map<String, Object> params) {
		return productDao.selectVenOrdReqSrcPdtListCnt(params);
	}
	/** 공급사 역주문 상품조회 */
	public List<Map<String, Object>> venOrdReqSrcPdtList( Map<String, Object> params, int page, int rows) {
		List<Map<String, Object>> list = null;
		list = productDao.selectVenOrdReqSrcPdtList(params,page,rows);
		if(list != null && list.size() > 0){
			for(int i = 0 ; i < list.size() ; i++){
                params.put("goodIdenNumb", list.get(i).get("GOOD_IDEN_NUMB").toString());
                params.put("vendorId"	 , null);
                list.get(i).put("info", productDao.selectVenOrdReqSrcPdtInfo(params));
			}
		}
		return list;
	}

	/** 공급사 역주문 옵션 상품조회 */
	public List<Map<String, Object>> venOrdReqSrcPdtList( Map<String, Object> params) {
        String[] goodNumbs = (String[])params.get("goodNumbs");
        String[] ordQuans = (String[])params.get("ordQuans");
        String repreGoodNumb = (String)params.get("repreGoodNumb");
        List<String> tempGoodNumbList = new ArrayList<String>();		// 쿼리용
        List<Map<String,Object>> tempPdtOrdQuans = new ArrayList<Map<String,Object>>();		// 상품과 주문갯수 마추기용도
        for(int i = 0; i < goodNumbs.length ; i++){
            tempGoodNumbList.add(goodNumbs[i]);
            Map<String, Object> tmpMap = new HashMap<String,Object>();
            tmpMap.put("goodIdenNumb", goodNumbs[i]);
            tmpMap.put("ordQuan", ordQuans[i]);
            tempPdtOrdQuans.add(tmpMap);
        }
        params.put("goodIdenNumbers", tempGoodNumbList);
		
		
		List<Map<String, Object>> list = null;
		list = productDao.selectVenOrdReqSrcPdtList(params);
		if(list != null && list.size() > 0){
			for(int i = 0 ; i < list.size() ; i++){
                params.put("goodIdenNumb", list.get(i).get("GOOD_IDEN_NUMB").toString());
                params.put("vendorId"	 , null);
                List<Map<String, Object>> tempList = productDao.selectVenOrdReqSrcPdtInfo(params);
                list.get(i).put("info", tempList);
                // 사용자가 선택한 공통 옵션
                list.get(i).put("GOOD_SPEC",  CommonUtils.getString(list.get(i).get("GOOD_SPEC")) + " "+  CommonUtils.getString(params.get("commonOpt")) +" "+tempList.get(0).get("OPT_GOOD_SPEC"));
                // 사용자가 입력한 주문수량
                for(Map<String, Object> tempPdtOrdQuansMap : tempPdtOrdQuans){
                	if(list.get(i).get("GOOD_IDEN_NUMB").toString().equals( CommonUtils.getString(tempPdtOrdQuansMap.get("goodIdenNumb")) )){
                		list.get(i).put("OPT_ORD_QUAN", CommonUtils.getString(tempPdtOrdQuansMap.get("ordQuan")) );
                	}
                }
                // 상품의 대표 옵션 상품코드
                list.get(i).put("REPRE_GOOD_IDEN_NUMB", CommonUtils.getString(repreGoodNumb) );
			}
		}
		return list;
	}

	
	/** 어드민 주문 상품 옵션 정보 조회 */ 
	public int getAdmProdOptListCnt(Map<String, Object> params) {
		return productDao.selectAdmProdOptListCnt(params);
	}
	public List<Map<String, Object>> getAdmProdOptList( Map<String, Object> params) {
		return productDao.selectAdmProdOptList(params);
	}

	
	/** 어드민 추가상품 정보 조회 */ 
	public int getAddPdtListCnt(Map<String, Object> params) {
		return productDao.selectAddPdtListCnt(params);
	}

	public List<Map<String, Object>> getAddPdtList(Map<String, Object> params) {
		return productDao.selectAddPdtList(params);
	}
	
	/**
	 * 공급사 재고관리 리스트를 조회하여 반환하는 메소드
	 * 
	 * @param params
	 * @return Map
	 * @throws Exception
	 */
	public Map<String, Object> selectProductListForVen(ModelMap params) throws Exception{
		Map<String, Object> result     = new HashMap<String, Object>();
		String              stockTotal = null;
		
		result     = this.commonSvc.getJqGridList("product.selectProductListForVen_count", "product.selectProductListForVen", params);
		stockTotal = (String)this.generalDao.selectGernalObject("product.selectProductListForVenStockTotal", params);
		stockTotal = CommonUtils.nvl(stockTotal, "0");
		stockTotal = CommonUtils.getDecimalAmount(stockTotal);
		
		result.put("stockTotal", stockTotal);
		
		return result;
	}
	
	/**
	 * 운영사 재고상품 리스트를 조회하여 반환하는 메소드
	 * 
	 * @param params
	 * @return Map
	 * @throws Exception
	 */
	public Map<String, Object> selectProductList(ModelMap params) throws Exception{
		Map<String, Object> result     = new HashMap<String, Object>();
		String              stockTotal = null;
		
		result     = this.commonSvc.getJqGridList("product.selectProductListForStockAdmCnt", "product.selectProductListForStockAdmList", params);
		stockTotal = (String)this.generalDao.selectGernalObject("product.selectProductListForStockAdmTotal", params);
		stockTotal = CommonUtils.nvl(stockTotal, "0");
		stockTotal = CommonUtils.getDecimalAmount(stockTotal);
		
		result.put("stockTotal", stockTotal);
		
		return result;
	}

	/** 운영사 - 상품관리 리스트에서 진열 정보 저장 
	 * @throws Exception */
	@SuppressWarnings("unchecked")
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})
	public void setDispMngtInfo(ModelMap paramMap, LoginUserDto loginUserDto) throws Exception {
		List<String> deliValArr = (List<String>)paramMap.get("deliValArr");
		List<String> workValArr = (List<String>)paramMap.get("workValArr");
		List<String> branchValArr = (List<String>)paramMap.get("branchValArr");
		List<String> gin_ven_arr = (List<String>)paramMap.get("gin_ven_arr");
		Map<String, String> params = null;
		Map<String, String> saveMap = null;
		String insert_user_id = loginUserDto.getUserId();
		
		if(gin_ven_arr != null && gin_ven_arr.size() > 0 ){
			for(String tmp_gin_ven : gin_ven_arr){
				params = new HashMap<String , String>();
				params.put("good_iden_numb",tmp_gin_ven.split("_")[0]);
				params.put("vendorid",tmp_gin_ven.split("_")[1]);
                params.put("insert_user_id", insert_user_id);					// 등록자
				this.productDao.deleteMcgooddispaly(params);			// 상품진열 테이블에 키로 삭제
				this.productDao.deleteMcgoodDisplayBranch(params);	// 상품진열 사업장 테이블에 key 로 삭제
				
                if(deliValArr != null && deliValArr.size() > 0 ){
                    for(String deliVal : deliValArr){
                    	saveMap = new HashMap<String, String>(params);
                    	saveMap.put("good_display_id", seqMcGoodDisplay.getNextStringId());// pk 값
                    	saveMap.put("display_type", "10");								// 권역정보를 뜻함.
                    	saveMap.put("display_type_cd", deliVal);							// 권역 코드값
                    	this.productDao.insertMcgooddispaly(saveMap);					// 상품진열 테이블에 insert
                    }
                }
                if(workValArr != null && workValArr.size() > 0 ){
                    for(String workVal : workValArr){
                    	saveMap = new HashMap<String, String>(params);
                    	saveMap.put("good_display_id", seqMcGoodDisplay.getNextStringId());// pk 값
                    	saveMap.put("display_type", "20");								// 공사유형정보를 뜻함.
                    	saveMap.put("display_type_cd", workVal);						// 공사유형 코드값
                    	this.productDao.insertMcgooddispaly(saveMap);				// 상품진열 테이블에 insert
                    }
                }
                if(branchValArr != null && branchValArr.size() > 0 ){
                    for(String branchVal : branchValArr){
                    	saveMap = new HashMap<String, String>(params);
                    	saveMap.put("good_display_branch_id", seqMcGoodDisplayBranch.getNextStringId());// pk값
                    	saveMap.put("branchid", branchVal);							// 공사유형 코드값
                    	this.productDao.insertMcgoodDisplayBranch(saveMap);	// 상품진열 사업장 테이블에 insert
                    }
                }
			}
		}
	}

	@Transactional(propagation=Propagation.REQUIRED, readOnly=false)
	public void updateProductModifyExcelUpload(List<Map<String, Object>> saveList, LoginUserDto loginUserDto) {
		for(Map<String, Object> saveMap : saveList) {
			try{
				String cate_cd = CommonUtils.getString(saveMap.get("cate_cd")).trim();
				if(!"".equals(cate_cd)) {
					saveMap.put("loginUserDto", loginUserDto);
					generalDao.updateGernal("product.updateProductModifyExcelUpload", saveMap);
					saveMap.put("good_hist_id",seqMcProductHistoryService.getNextIntegerId());
					generalDao.insertGernal("product.insertMcGoodHistNew", saveMap);
				}
				
				String good_same_word = CommonUtils.getString(saveMap.get("good_same_word")).trim();
				if(!"".equals(good_same_word)) {
					good_same_word = (good_same_word.replaceAll(",", "‡")).trim();
					saveMap.put("good_same_word", good_same_word);
					generalDao.updateGernal("product.updateProductVendorModifyExcelUpload", saveMap);
					List<Object> vendorList = generalDao.selectGernalList("product.selectProductVendorModifyExcelUpload", saveMap);
					for(Object obj : vendorList) {
						@SuppressWarnings("unchecked")
						Map<String,Object> paramMap = (Map<String, Object>) obj;
						paramMap.put("loginUserDto", loginUserDto);
						paramMap.put("good_same_word", good_same_word);
						paramMap.put("good_hist_id",seqMcProductHistoryService.getNextIntegerId());
						generalDao.insertGernal("product.insertMcGoodVendorHistNew", paramMap);
					}
				}
			} catch(Exception e) {
				logger.error("상품일괄 수정 시 에러발생 : "+saveMap);
			}
		}
	}
}
