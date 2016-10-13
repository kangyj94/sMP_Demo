package kr.co.bitcube.product.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import kr.co.bitcube.common.utils.CommonUtils;
import kr.co.bitcube.product.dao.ProductAppDao;
import kr.co.bitcube.product.dto.ProductAppGoodDto;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.servlet.ModelAndView;

import egovframework.rte.fdl.idgnr.EgovIdGnrService;

@Service
public class ProductAppSvc {

	@Autowired
	private ProductAppDao productAppDao ;
	
	
	@Resource(name="seqMcProductHistoryService")
	private EgovIdGnrService seqMcProductHistoryService;
	
	@Resource(name="seqMcProductDispGoodService")
	private EgovIdGnrService seqMcProductDispGoodService;
	
	/**
	 * 상세 정보를 조회한다.
	 */
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false)
	public List<ProductAppGoodDto> getAppProductDetail(Map<String, Object>params) throws Exception{
		return productAppDao.selectAppProductDetail(params);
	}
	
	/**
	 * (운영사) 단가변경요청승인정보 검색 Count
	 * @param params
	 * @return
	 */
	public int getProductAppListCnt(Map<String, Object> params) {
		return productAppDao.selectProductAppListCnt(params);
	}
	
	/**
	 * (운영사) 단가변경요청승인정보 검색 List
	 * @param params
	 * @return
	 */
	public List<ProductAppGoodDto> getProductAppList(Map<String, Object> params, int page, int rows) {
		return productAppDao.selectProductAppList(params, page, rows);
	}
	
	
	/**
	 * 	상품 승인 처리한다. 
	 */
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})
	public void setProductAppConfirmTransGrid(Map<String, Object> paramMap , ModelAndView modelAndView)throws Exception {
		
		// 승인 상태및 승인유형을 조회한다. 
		List<ProductAppGoodDto> list =  productAppDao.selectAppProductDetail(paramMap);
		ProductAppGoodDto productAppGoodDto  = list.get(0);
		
		if(!productAppGoodDto.getApp_sts_flag().equals("0")) {
			modelAndView.addObject("msg", "상태 확인후 처리하시기 바랍니다.");
		}
		
		// 승인 처리시
		if(((String)paramMap.get("oper")).equals("ok")){
			// 판매단가변경 10
			if(productAppGoodDto.getChn_price_clas().equals("10")){
				this.setDispPriceAppOK(productAppGoodDto.getParams()); 
			}
			
			// 매입단가변경 20
			if(productAppGoodDto.getChn_price_clas().equals("20")){
				this.setUnitPriceAppOk(productAppGoodDto.getParams()); 
			}

			// 종료요청 30 
			if(productAppGoodDto.getChn_price_clas().equals("30")){
				this.setSoldOutProduct(productAppGoodDto.getParams());
			}		
			
			Map<String ,Object> saveMap = productAppGoodDto.getParams();
			saveMap.put("app_userid"	,	paramMap.get("app_userid")	); 
			saveMap.put("app_sts_flag"	,	"1"							);
			productAppDao.updateAppGoodSts(saveMap);
		}else if(((String)paramMap.get("oper")).equals("cancel")){
			// 반려 처리시
			// 1. mcappgoodprice  UPDATE
			Map<String ,Object> saveMap = productAppGoodDto.getParams();
			saveMap.put("app_sts_flag"	,	"2"							);
			saveMap.put("app_userid"	,	paramMap.get("app_userid")	);
			saveMap.put("app_good_id"	,	paramMap.get("app_good_id")	);
			productAppDao.updateAppGoodSts(saveMap);
			
			// 2. mcgoodfix UPDATE 
			if( !productAppGoodDto.getChn_price_clas().equals("10") ){
				saveMap.put("fix_app_sts", "3");
				productAppDao.updateMcGoodFixAppSts(saveMap); 
			}
			
		}
	}
	
	/**
	 *	판매단가변경 승인처리시 
	 */
	public void setDispPriceAppOK(Map<String ,Object> saveMap){
		
		// 진열 SEQ 진열 한다.
		productAppDao.updateSetAbleDispProduct(saveMap);
		// 기존 SEQ 진열을 내린다.
		productAppDao.updateSetUnAbleDispPastProduct(saveMap);
	}
	
	/**
	 *	 매입단가변경 승인처리 
	 */
	public void setUnitPriceAppOk(Map<String ,Object> saveMap) throws Exception{
		saveMap.put("fix_app_sts"	, 	"2"												);
		
		if(!( saveMap.get("price") instanceof Double )){
			saveMap.put("sale_unit_pric",   CommonUtils.stringParseDouble((String)saveMap.get("after_price") , 0 ));
		} else {
			saveMap.put("sale_unit_pric",   (Double)saveMap.get("after_price"));
		}
		
		// 1. mcgoodfix 처리상태 변경 
		if( saveMap.get("fix_good_id") != null  && !((String)saveMap.get("fix_good_id")).equals("") ){	
//			productAppDao.updateMcGoodFixAppStsByApproval(saveMap); 
			productAppDao.updateMcGoodFixAppSts(saveMap); 
		}
		
		// 2.상품공급사 매입단가 변경 
		productAppDao.updateProdVendorUnitPrice(saveMap);
		
		// 2_1.상품 공급사 히스토리 변경 
		saveMap.put("good_hist_id"	, 	seqMcProductHistoryService.getNextIntegerId() 	);
		productAppDao.insertProductVendorHist(saveMap);
		
		// 3.insert mcdispgood 매입단가 변경후 row 정보 저장
		// 4.update mcdispgood 기존 진열 내리기		
		List<ProductAppGoodDto> list =  productAppDao.selectDispIdForInsertNewDispId(saveMap);
		for (ProductAppGoodDto productAppGoodDto : list){
			Map<String ,Object> insDispMap = new HashMap<String, Object>();
			
			
			if( !(saveMap.get("after_price") instanceof Double ))
				insDispMap.put("sale_unit_pric"		, CommonUtils.stringParseDouble((String)saveMap.get("after_price"), 0)  );	//	매입단가
			else 
				insDispMap.put("sale_unit_pric"		, (Double)saveMap.get("after_price"));	//	매입단가
			
			 
			insDispMap.put("new_disp_good_id"	, seqMcProductDispGoodService.getNextStringId()							);	// 	dispSeq
			insDispMap.put("disp_good_id"		, productAppGoodDto.getDisp_good_id()									);	//	PastdispSeq
			productAppDao.insertDispProductInfos(insDispMap) ;
			productAppDao.updateUnDispPlayProdVendor(insDispMap) ;
		}
	}
	
	/**
	 *	종료요청 승인처리  
	 * @throws Exception 
	 */
	public void setSoldOutProduct(Map<String ,Object> saveMap) throws Exception{
		saveMap.put("fix_app_sts"	, 	"2"		);
		
		// 1. mcgoodfix 처리상태 변경 
		if( saveMap.get("fix_good_id") != null  && !((String)saveMap.get("fix_good_id")).equals("") )	
			productAppDao.updateMcGoodFixAppSts(saveMap);
				
		//	2.	상품 진열 해당 공급업체 품목 진열 내리기
//		List<ProductAppGoodDto> list =  productAppDao.selectDispIdForInsertNewDispId(saveMap);
//		for (ProductAppGoodDto productAppGoodDto : list){
//			Map<String ,Object> insDispMap = new HashMap<String, Object>();
//			insDispMap.put("disp_good_id"	,productAppGoodDto.getDisp_good_id());			//	PastdispSeq
//			productAppDao.updateUnDispPlayProdVendor(insDispMap);
//		}

		//	3.	상품공급사 isUse Update 
		saveMap.put("isUse", "0");
		productAppDao.updateProdVendorUseSts(saveMap); 
//		productAppDao.deleteProductVendor(saveMap);
		
		//	4.	상품 history update
		saveMap.put("good_hist_id"	, 	seqMcProductHistoryService.getNextIntegerId() 	);
		productAppDao.insertProductVendorHist(saveMap);
//		productAppDao.insertProductVendorHistForDelete(saveMap);
	}
	
	/**
	 * 공급사 매입가 변경 추이를 제공 차트를 그린다. 
	 */
	public List<Map<String, Object>> getProdVendorUnitPriceChart(Map<String ,Object> paramMap){
		return productAppDao.selectProdVendorUnitPriceChart(paramMap); 
	}
	
	/**
	 * 판가 정보 
	 */
	public List<Map<String, Object>> getprodSellUnitPriceChart(Map<String ,Object> paramMap){
		return productAppDao.selectprodSellUnitPriceChart(paramMap); 
	}
	
	
}
