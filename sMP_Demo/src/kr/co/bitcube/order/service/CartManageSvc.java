package kr.co.bitcube.order.service;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import kr.co.bitcube.common.utils.CommonUtils;
import kr.co.bitcube.order.dao.CartManageDao;
import kr.co.bitcube.order.dto.CartMasterInfoDto;
import kr.co.bitcube.order.dto.CartProdInfoDto;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;


@Service
public class CartManageSvc {
	
	private Logger logger = Logger.getLogger(getClass());
	
	@Autowired
	private CartManageDao cartManageDao;  
	
	
	/**
	 * 카티 마스터 정보를 조회한다. ( 사업장 기준 ) 
	 * @param params
	 * @param page
	 * @param rows
	 * @return
	 */
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false)
	public CartMasterInfoDto getCartMasterInfo(Map<String, Object> params) {
		// 카트 존제 여부를 조회한다.
		int rowCnt = cartManageDao.selectCateForBranchCnt(params); 
		// 사업장 기준 카트 정보 미존재시 insert
		if (rowCnt == 0 ) 
			cartManageDao.insertCateMasterInfo(params);
				
		CartMasterInfoDto cartMasterInfoDto = null; 
		cartMasterInfoDto = (CartMasterInfoDto)cartManageDao.selectCateMasterInfo(params) ; 
		
		return cartMasterInfoDto;
	}
	
	/**
	 * 장바구니 상품 목록 
	 * @param params
	 * @return
	 */
	public List<CartProdInfoDto> getCartProdInfo(Map<String, Object> params) {
		return (List<CartProdInfoDto>) cartManageDao.selectCartProdInfo(params);
	}
	
	
	/**
	 * 장바구니 상품 삭제 
	 * @param params
	 * @return
	 */
	public void delCartProdInfo(Map<String, Object> params) {
		String[] disp_good_id_array = (String[])params.get("disp_good_id_array");
		for(int i=0; i < disp_good_id_array.length; i++){
			params.put("disp_good_id", disp_good_id_array[i]);
			cartManageDao.deleteCartProdInfo(params);
		}
	}
	
	
	/**
	 * 장바구니 상품 등록
	 * @param paramMap
	 * @throws Exception
	 */
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false)
	public void addProductInCartTransGrid(Map<String, Object> paramMap) throws Exception {
		// 파라미터 정의
		String[] disp_good_id_Array 	= (String[]) paramMap.get("disp_good_id_Array");
		String[] ord_quan_Array 		= (String[]) paramMap.get("ord_quan_Array");
		String groupid  		        = (String) paramMap.get("groupid");
		String clientid			        = (String) paramMap.get("clientid");
		String branchid			        = (String) paramMap.get("branchid");
		String userid			        = (String) paramMap.get("userid");
		
		logger.debug(userid);
		
		// 해당 조직에 장바구니가 존재 여부를 확인	
		Map<String, Object> cartMap = new HashMap<String,Object>();
		cartMap.put("groupid", groupid);
		cartMap.put("clientid", clientid);
		cartMap.put("branchid", branchid);
		cartMap.put("userid", userid);
		
		
		int rowCnt  = cartManageDao.selectCateForBranchCnt(cartMap);
	
		if( rowCnt == 0  ) {										// 미존재
			cartManageDao.insertCateMasterInfo(cartMap);
		}else if (rowCnt > 1 ) { 									// 복수건 존재 
			throw new Exception("장바구니 등록시 문재가 방생하였습니다. 운영자에게 문의 하시기 바랍니다. ");
		}
		
		int arrIdx = 0;
		for(String disp_good_id : disp_good_id_Array) {
			Map<String, Object> cartProdMap = new HashMap<String,Object>();
			cartProdMap.put("groupid"	       , groupid                       );
			cartProdMap.put("clientid"	       , clientid                      );
			cartProdMap.put("branchid"	       , branchid                      );
			cartProdMap.put("userid"	       , userid                        );
			cartProdMap.put("regi_user_id"	   , paramMap.get("userId")        );
			
			cartProdMap.put("disp_good_id"	   , disp_good_id                  );
			cartProdMap.put("ord_quan"   	   , ord_quan_Array[arrIdx]        );
			
			// 장바구니 품목에 기존 진열 상품이 존재하는지 여부를 확인한다.
			int productCntInCart = cartManageDao.selectProdCntInCate(cartProdMap) ;  
			if (productCntInCart == 1 ){	// 기존 상품존재시 수량만 업데이트
				cartManageDao.updateProductOrderQuanInCart(cartProdMap);
			}else if(productCntInCart == 0) {													// 기존 상품 미존재시 상품 등록 
				cartManageDao.insertProductInCart(cartProdMap); 
			}else {
				throw new Exception("장바구니 상품등록시 문재가 발생하였습니다. 운영자에게 문의 하시기 바랍니다. ");
			}
			arrIdx++; 
		}
	}
	
	/**
	 * 장바구니 상품 수량변경  
	 * @param paramMap
	 * @throws Exception
	 */
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false)
	public void editCartProductOrdQuan(Map<String, Object> paramMap) throws Exception {
		cartManageDao.updateCartProductOrdQuan(paramMap);
	}
	
	/**
	 * 장바구니 상품 삭제 
	 * @param paramMap
	 * @throws Exception
	 */
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false)
	public void deleteCartProduct(Map<String, Object> paramMap) throws Exception {
		cartManageDao.deleteCartProduct(paramMap);
	}
	
	/**
	 * 장바구니 마스터 정보를 수정한다 
	 * @param paramMap
	 * @throws Exception
	 */
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false)
	public void updateCartMstInfo(Map<String, Object> paramMap) throws Exception {
		cartManageDao.updateCartMstInfo(paramMap);
		
		/* 
		String[] orde_requ_quan_arr = (String[])paramMap.get("orde_requ_quan_arr");
		String[] disp_good_id_arr = (String[])paramMap.get("disp_good_id_arr");
		
		if(orde_requ_quan_arr != null && orde_requ_quan_arr.length > 0){
			for(int i = 0 ; i < orde_requ_quan_arr.length ; i++){
				paramMap.put("orde_requ_quan"	, orde_requ_quan_arr[i]);
				paramMap.put("disp_good_id"		, disp_good_id_arr[i]);
				cartManageDao.updateCartProd(paramMap);
			}
		}
		*/
	}

	/**
	 * 장바구니의 첨부파일정보을 삭제
	 * @param saveMap
	 */
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false)
	public void delCartAttachFile(Map<String, Object> saveMap) {
		cartManageDao.updateCartAttachFile(saveMap);
	}

	public void updateCartInfo(Map<String, Object> searchParams) {
		this.cartManageDao.updateCartInfo(searchParams);
	}
	
	/*
	 * 장바구니 담기 
	 */
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})	
	public void setCartInfo(Map<String, Object> saveMap) throws Exception{
		int rowCnt  = cartManageDao.selectCateForBranchCnt(saveMap);
		if( rowCnt == 0  ) {										// 미존재
			cartManageDao.insertCateMasterInfo(saveMap);
		}else if (rowCnt > 1 ) { 									// 복수건 존재 
			throw new Exception("장바구니 등록시 문재가 방생하였습니다. 운영자에게 문의 하시기 바랍니다. ");
		}		
		
		String 	repreGoodNumb = CommonUtils.getString(saveMap.get("repreGoodNumb"));
		String[] goodNumbs 	  = (String[])saveMap.get("goodNumbs");
		String[] ordQuans  	  = (String[])saveMap.get("ordQuans");
		String[] vendorIds    = (String[])saveMap.get("vendorIds");
		
		Map<String, Object> params = new HashMap<String, Object>();
		
		params.put("branchid"	, CommonUtils.getString(saveMap.get("branchid")));
		params.put("userid"		, CommonUtils.getString(saveMap.get("userid")));

		if("OPT".equals(CommonUtils.getString(saveMap.get("kind")))){
			if(goodNumbs != null && goodNumbs.length > 0){
				for(int i = 0 ; i < goodNumbs.length ; i++){
					params.put("good_iden_numb"			, goodNumbs[i]);
					params.put("orde_requ_quan"			, ordQuans[i]);
					params.put("vendorid"				, vendorIds[i]);
					params.put("repre_good_iden_numb"	, repreGoodNumb);
					params.put("common_option"			, CommonUtils.getString(saveMap.get("commonOpt")));
					// 장바구니 품목에 기존 진열 상품이 존재하는지 여부를 확인한다.
					int productCntInCart = cartManageDao.selectProdCntInCate(params) ;  
					if (productCntInCart == 1 ){	// 기존 상품존재시 수량만 업데이트
						cartManageDao.deleteCartPdt(params);
						cartManageDao.insertProductInCart(params); 
					}else if(productCntInCart == 0) {													// 기존 상품 미존재시 상품 등록 
						cartManageDao.insertProductInCart(params); 
					}else {
						throw new Exception("장바구니 상품등록시 문재가 발생하였습니다. 운영자에게 문의 하시기 바랍니다. ");
					}
				}
			}
		}else if ("ADD".equals(CommonUtils.getString(saveMap.get("kind")))){
			if(goodNumbs != null && goodNumbs.length > 0){
				Map<String , Object> insertInfoMap = new HashMap<String, Object>();
				for(int i = 0 ; i < goodNumbs.length ; i++){
					insertInfoMap.clear();
					insertInfoMap.put("branchid", CommonUtils.getString(saveMap.get("branchid")));
					insertInfoMap.put("userid", CommonUtils.getString(saveMap.get("userid")));
					insertInfoMap.put("good_iden_numb", goodNumbs[i]);
					insertInfoMap.put("vendorid", vendorIds[i]);
					insertInfoMap.put("orde_requ_quan", ordQuans[i]);
					//대표상품 등록 여부 검사 - 대표상품 기등록시 해당 대표 및 추가상품 삭제
					if(repreGoodNumb.equals(goodNumbs[i]) == false){
						// 장바구니에 담으려는 상품이 대표 추가상품이 아닐때 아래 값을 세팅한다.
						insertInfoMap.put("add_repre_good_iden_numb", repreGoodNumb); // 추가대표상품코드
					}
					
					List<Map<String , Object>> existProdList = cartManageDao.selectExistProdList(insertInfoMap);
					List<Map<String , Object>> existAddProdList = cartManageDao.selectExistAddProdList(insertInfoMap);
					if(existProdList != null && existProdList.size() > 0){ 
						for(Map<String , Object> tempMap : existProdList){
							cartManageDao.deleteCartPdtForAddProd(tempMap);
						} 
					}
					if(existAddProdList != null && existAddProdList.size() > 0){ 
						for(Map<String , Object> tempMap : existAddProdList){
							cartManageDao.deleteCartPdtForAddProd(tempMap);
						} 
					}
					cartManageDao.insertProductInCart(insertInfoMap); 
				}
			}
		}else if("ETC".equals(CommonUtils.getString(saveMap.get("kind")))){
			params.put("good_iden_numb"			, goodNumbs[0]);
			params.put("orde_requ_quan"			, ordQuans[0]);
			params.put("vendorid"				, vendorIds[0]);
			
			// 장바구니 품목에 기존 진열 상품이 존재하는지 여부를 확인한다.
			int productCntInCart = cartManageDao.selectProdCntInCate(params) ;  
			if (productCntInCart == 1 ){	// 기존 상품존재시 수량만 업데이트
//				cartManageDao.updateProductOrderQuanInCart(params);
				cartManageDao.deleteCartPdt(params);
				cartManageDao.insertProductInCart(params); 
			}else if(productCntInCart == 0) {													// 기존 상품 미존재시 상품 등록 
				cartManageDao.insertProductInCart(params); 
			}else {
				throw new Exception("장바구니 상품등록시 문재가 발생하였습니다. 운영자에게 문의 하시기 바랍니다. ");
			}
		}
	}

	public List<Map<String, Object>> getBuyCartInfo(Map<String, Object> searchParams) {
		return cartManageDao.getBuyCartInfo(searchParams);
	}

	public List<Map<String, Object>> deleteCartPdt(Map<String, Object> params) {
		String[] goodIdenNumbs= (String[])params.get("goodIdenNumbs");
		String[] vendorIds    = (String[])params.get("vendorIds");
		
		Map<String, Object> saveMap = new HashMap<String, Object>();
		
		if(goodIdenNumbs != null && goodIdenNumbs.length > 0){
			for(int i = 0 ; i < goodIdenNumbs.length ; i++){
				saveMap.put("good_iden_numb", goodIdenNumbs[i]);
				saveMap.put("vendorid"		, vendorIds[i]);
				saveMap.put("branchid"		, params.get("branchid"));
				saveMap.put("userid"		, params.get("userid"));				
				cartManageDao.deleteCartPdt(saveMap);
			}
		}
		return cartManageDao.getBuyCartInfo(params);
	}

	/** 장바구니 담기에 있어 오류가 있는지 체크. */
	public String setCartInfoBeforeChk(Map<String, Object> params) {
		String rtnMsg = "";
		String branchid = CommonUtils.getString(params.get("branchid"));
		String userid = CommonUtils.getString(params.get("userid"));
		// 추가 상품의 서브 상품을 장바구니에 담기를 했을 경우 못담게 처리.
		String[] goodNumbs 	  = (String[])params.get("goodNumbs");
		String[] vendorIds    = (String[])params.get("vendorIds");

		String kind = CommonUtils.getString(params.get("kind"));
		Map<String, Object> tempParams = new HashMap<String, Object>();
		if( "OPT".equals(kind) == false && goodNumbs != null && goodNumbs.length > 0){
			for(int i = 0 ; i < goodNumbs.length ; i++){
				tempParams.clear();
				tempParams.put("branchid", CommonUtils.getString(branchid));
				tempParams.put("userid", CommonUtils.getString(userid));
				tempParams.put("good_iden_numb", goodNumbs[i]);
				tempParams.put("vendorid", vendorIds[i]);
				Map<String, Object> cartChkMap = cartManageDao.selectCartChkAddProductSubInfo2(tempParams);
				if(cartChkMap != null && "".equals(CommonUtils.getString(cartChkMap.get("ADD_PROD_ID"))) == false){
					// 상위에 추가상품이 존재한다면, 장바구니에 등록할 수 없음.
					String is_mst_yn = CommonUtils.getString(cartChkMap.get("IS_MST_YN"));
					String str = null;
					if("Y".equals(is_mst_yn)){
						str = "대표상품이";
					}else{
						str = "구성상품으로";
					}
					rtnMsg ="이미 추가상품의 "+ str+" 등록되어 있습니다.";
				}
			}
		}
		return rtnMsg;
	}

	public void updateCartPdtOrdQuan(Map<String, Object> params) {
		String branchid = (String)params.get("branchid");
		String userid = (String)params.get("userid");
		String ordQuan = (String)params.get("ordQuan");
		String[] goodIdenNumbs = (String[])params.get("goodIdenNumbs");
		String[] vendorIds = (String[])params.get("vendorIds");
		Map<String, Object> saveMap =  new HashMap<String, Object>();
		saveMap.put("branchid", branchid);
		saveMap.put("userid", userid);
		saveMap.put("ordQuan", ordQuan);
		// 추가 상품 관련하여 복수개의 데이터가 들어올 수 있음.
		for(int i = 0; i < goodIdenNumbs.length; i++){
            saveMap.remove("goodIdenNumb");
            saveMap.remove("vendorId");
            saveMap.put("goodIdenNumb", goodIdenNumbs[i]);
            saveMap.put("vendorId", vendorIds[i]);
            cartManageDao.updateCartPdtOrdQuan(saveMap);
		}
	}
}
