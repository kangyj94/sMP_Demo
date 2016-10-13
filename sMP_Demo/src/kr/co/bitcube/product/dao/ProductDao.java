package kr.co.bitcube.product.dao; 

import java.util.List;
import java.util.Map;

import kr.co.bitcube.product.dto.BuyProductDto;
import kr.co.bitcube.product.dto.ProductDto;

import org.apache.ibatis.session.RowBounds;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class ProductDao {
	
	private final String statement = "product.";
	
	
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;  // id(Sequence) 생성을 위해 추가
	
	public int selectProductListCnt(Map<String, Object> params) {
		return (Integer) sqlSessionTemplate.selectOne(this.statement+"selectProductListCnt", params);
	}
	
	/**
	 * 운영사 상품 검색 Count 
	 * @param params
	 * @return
	 */
	public int selectProductListCntForAdmin(Map<String, Object> params) {
		return (Integer) sqlSessionTemplate.selectOne(this.statement+"selectProductListCntForAdmin", params);
	}
	
	
	public List<ProductDto> selectProductList(Map<String, Object> params, int page, int rows) {
		RowBounds rowBounds = new RowBounds((page-1)*rows, rows);
		return  sqlSessionTemplate.selectList(this.statement+"selectProductList", params, rowBounds);
	}
	
	/**
	 * 운영사 상품 검색 List 
	 * @param params
	 * @param page
	 * @param rows
	 * @return
	 */
	
	public List<ProductDto>selectProductListForAdmin(Map<String, Object> params, int page, int rows) {
		RowBounds rowBounds = new RowBounds((page-1)*rows, rows);
		return  sqlSessionTemplate.selectList(this.statement+"selectProductListListForAdmin", params, rowBounds);
	}
	
	public ProductDto selectProductInfo(Map<String, Object> params) throws Exception {
		ProductDto productDto = (ProductDto)this.sqlSessionTemplate.selectOne(statement+"selectProductInfo", params);
		return productDto;
	}
	
	public void insertGood(Map<String, Object> saveMap) {
		sqlSessionTemplate.insert(this.statement+"insertGood", saveMap);
	}
	
	public void insertGoodHist(Map<String, Object> saveMap) {
		sqlSessionTemplate.insert(this.statement+"insertGoodHist", saveMap);
	}
	
	public void updateGood(Map<String, Object> saveMap) {
		sqlSessionTemplate.update(this.statement+"updateGood", saveMap);
	}
	
	
	public List<ProductDto> selectGoodVendorList(Map<String, Object> params) {
		return  sqlSessionTemplate.selectList(this.statement+"selectGoodVendorList", params);
	}
	
	
	public List<ProductDto> selectSaleUnitPricList(Map<String, Object> params) {
		return  sqlSessionTemplate.selectList(this.statement+"selectSaleUnitPricList", params);
	}
	
	public ProductDto selectGoodVendorDetailInfo(Map<String, Object> params) {
		return (ProductDto) sqlSessionTemplate.selectOne(this.statement + "selectGoodVendorList", params);
	}
	
	public ProductDto selectVendorDetailInfo(Map<String, Object> params) {
		return (ProductDto) sqlSessionTemplate.selectOne(this.statement + "selectVendorDetailInfo", params);
	}
	
	public void insertGoodVendor(Map<String, Object> saveMap) {
		sqlSessionTemplate.insert(this.statement+"insertGoodVendor", saveMap);
	}
	
	public void insertGoodVendorHist(Map<String, Object> saveMap) {
		sqlSessionTemplate.insert(this.statement+"insertGoodVendorHist", saveMap);
	}
	
	public void updateGoodVendor(Map<String, Object> saveMap) {
		sqlSessionTemplate.update(this.statement+"updateGoodVendor", saveMap);
	}
	
	public void deleteGoodVendor(Map<String, Object> saveMap) {
		sqlSessionTemplate.update(this.statement+"deleteGoodVendor", saveMap);
	}
	
	public int selectDisplayGoodListCnt(Map<String, Object> params) {
		return (Integer) sqlSessionTemplate.selectOne(this.statement+"selectDisplayGoodListCnt", params);
	}
	
	public int selectDispProductListCnt(Map<String, Object> params) {
		return (Integer) sqlSessionTemplate.selectOne(this.statement+"selectDispProductListCnt", params);
	}
	
	
	public List<ProductDto> selectDisplayGoodList(Map<String, Object> params, int page, int rows) {
		RowBounds rowBounds = new RowBounds((page-1)*rows, rows);
		return  sqlSessionTemplate.selectList(this.statement+"selectDisplayGoodList", params, rowBounds);
	}
	
	
	public List<ProductDto> selectDisplayGoodHistList(Map<String, Object> params) {
		return  sqlSessionTemplate.selectList(this.statement+"selectDisplayGoodHistList", params);
	}
	
	public void insertDisplayGood(Map<String, Object> saveMap) {
		sqlSessionTemplate.insert(this.statement+"insertDisplayGood", saveMap);
	}
	
	public void insertAppGoodPrice(Map<String, Object> saveMap) {
		sqlSessionTemplate.insert(this.statement+"insertAppGoodPrice", saveMap);
	}
	
	public void updateAppGoodPrice(Map<String, Object> saveMap) {
		sqlSessionTemplate.update(this.statement+"updateAppGoodPrice", saveMap);
	}
	
	public void updateRefDisplayGood(Map<String, Object> saveMap) {
		sqlSessionTemplate.update(this.statement+"updateRefDisplayGood", saveMap);
	}
	
	public void updateDisplayGood(Map<String, Object> saveMap) {
		sqlSessionTemplate.update(this.statement+"updateDisplayGood", saveMap);
	}
	
	/**
	 * 과거상품 진열 여부 수정 
	 */
	public void updatedisplayGoodUpdateTrans(Map<String, Object> saveMap) {
		sqlSessionTemplate.update(this.statement+"updatedisplayGoodUpdateTrans", saveMap);
	}
	
	public int selectProductRequestDiscontinuanceListCnt(Map<String, Object> params) {
		return (Integer) sqlSessionTemplate.selectOne(this.statement+"selectProductRequestDiscontinuanceListCnt", params);
	}
	
	
	public List<ProductDto> selectProductRequestDiscontinuanceList(Map<String, Object> params, int page, int rows) {
		RowBounds rowBounds = new RowBounds((page-1)*rows, rows);
		return  sqlSessionTemplate.selectList(this.statement+"selectProductRequestDiscontinuanceList", params, rowBounds);
	}
	
	public void updateGoodFix(Map<String, Object> saveMap) {
		sqlSessionTemplate.update(this.statement+"updateGoodFix", saveMap);
	}
	
	public void insertAppGoodPrice2(Map<String, Object> saveMap) {
		sqlSessionTemplate.insert(this.statement+"insertAppGoodPrice2", saveMap);
	}
	
	public void insertPriceChgHist(Map<String, Object> saveMap) {
		sqlSessionTemplate.insert(this.statement+"insertPriceChgHist", saveMap);
	}
	
	public void updateGoodVendorForPrice(Map<String, Object> saveMap) {
		sqlSessionTemplate.update(this.statement+"updateGoodVendorForPrice", saveMap);
	}
	
	public int selectBuyProductSearchCnt(Map<String, Object> params) {
		return (Integer) sqlSessionTemplate.selectOne(this.statement+"selectBuyProductSearchCnt", params);
	}
	
	/**
	 * (고객사) 상품검색 Count 조회 Test 비트큐브 임상건 2014-05-15
	 * @param params
	 * @return
	 */
	public int selectBuyProductSearchCntPriority(Map<String, Object> params) {
		return (Integer) sqlSessionTemplate.selectOne(this.statement+"selectBuyProductSearchCntPriority", params);
	}
	
	
	public List<BuyProductDto> selectBuyProductSearchList(Map<String, Object> params, int page, int rows) {
		RowBounds rowBounds = new RowBounds((page-1)*rows, rows);
		return  sqlSessionTemplate.selectList(this.statement+"selectBuyProductSearchList", params, rowBounds);
	}
	
	/**
	 * (고객사) 상품검색 조회 Test 비트큐브 임상건 2014-05-15
	 * @param params
	 * @param page
	 * @param rows
	 * @return
	 */
	public List<BuyProductDto> selectBuyProductSearchListPriority(Map<String, Object> params, int page, int rows) {
		RowBounds rowBounds = new RowBounds((page-1)*rows, rows);
		return  sqlSessionTemplate.selectList(this.statement+"selectBuyProductSearchListPriority", params, rowBounds);
	}
		
	/**
	 * (고객사) 상품별 공급사 List 비트큐브 임상건 2014-05-19
	 * @param params
	 * @param page
	 * @param rows
	 * @return
	 */
	public List<BuyProductDto> selectBuyProductListTemp(Map<String, Object> params) {
		//RowBounds rowBounds = new RowBounds((page-1)*rows, rows);
		return  sqlSessionTemplate.selectList(this.statement+"selectBuyProductListTemp", params);
	}
	
	
	public List<ProductDto> selectCommonProductSearchListByVendor(Map<String, Object> params) {
		return  sqlSessionTemplate.selectList(this.statement+"selectCommonProductSearchListByVendor", params);
	}
	
	
	public List<ProductDto> selectChoiceProductListInfoByVendor (Map<String, Object> params) {
		return  sqlSessionTemplate.selectList(this.statement+"selectChoiceProductListInfoByVendor", params);
	}
	
	/**
	 * (공급사) 상품 검색 Count
	 * @param params
	 * @return
	 */
	public int selectVenProductListCnt(Map<String, Object> params) {
		return (Integer) sqlSessionTemplate.selectOne(this.statement+"selectVenProductListCnt", params);
	}
	
	/**
	 * (공급사) 상품 검색 List
	 * @param params
	 * @return
	 */
	
	public List<ProductDto> selectVenProductList(Map<String, Object> params, int page, int rows) {
		RowBounds rowBounds = new RowBounds((page-1)*rows, rows);
		return  sqlSessionTemplate.selectList(this.statement+"selectVenProductList", params, rowBounds);
	}
	
	/**
	 * (공급사) 상품요청등록 검색 Count
	 * @param params
	 * @return
	 */
	public int selectProductRequestRegistListCnt(Map<String, Object> params) {
		return (Integer) sqlSessionTemplate.selectOne(this.statement+"selectProductRequestRegistListCnt", params);
	}
	
	/**
	 * (공급사) 상품요청등록 검색 List
	 * @param params
	 * @return
	 */
	
	public List<ProductDto> selectProductRequestRegistList(Map<String, Object> params, int page, int rows) {
		RowBounds rowBounds = new RowBounds((page-1)*rows, rows);
		return  sqlSessionTemplate.selectList(this.statement+"selectProductRequestRegistList", params, rowBounds);
	}

	/**
	 * 관심상품 count 를 구한다. 
	 * @param params
	 * @return
	 */ 
	public int selectInterestProductCnt(Map<String, Object> params) {
		return (Integer) sqlSessionTemplate.selectOne(this.statement+"selectInterestProductCnt", params);
	}
	
	/**
	 * 관심상품 등록 
	 * @param saveMap
	 */
	public void insertInterestProduct(Map<String, Object> saveMap) {
		sqlSessionTemplate.insert(this.statement+"insertInterestProduct", saveMap);
	}
	
	/**
	 * 
	 */
	public void deleteInterestProduct(Map<String, Object> saveMap) {
		sqlSessionTemplate.insert(this.statement+"deleteInterestProduct", saveMap);
	}
	/**
	 * (고객사) 관심품목 Count 조회
	 * @param params
	 * @return
	 */
	public int selectBuyWishListCnt(Map<String, Object> params) {
		return (Integer) sqlSessionTemplate.selectOne(this.statement+"selectBuyWishListCnt", params);
//		return (Integer) sqlSessionTemplate.selectOne(this.statement+"selectBuyWishListCnt2", params);
	}
	
	/**
	 * (고객사) 관심품목 조회
	 * @param params
	 * @param page
	 * @param rows
	 * @return
	 */
	
	public List<BuyProductDto> selectBuyWishList(Map<String, Object> params, int page, int rows) {
		RowBounds rowBounds = new RowBounds((page-1)*rows, rows);
		return  sqlSessionTemplate.selectList(this.statement+"selectBuyWishList", params, rowBounds);
		/**
		 * 관심상품 등록후 진열정보가 바뀌게 되면 
		 */
	}
	
	/**
	 * (고객사) 상품 상세 조회 
	 */
	public BuyProductDto selectProductDetailInfoForBuyer(Map<String, Object> params) {
		return (BuyProductDto)sqlSessionTemplate.selectOne(this.statement+"selectProductDetailInfoForBuyer", params);
	}
	
	/**
	 * (고객사) 과거 상품 가격정보 조회 
	 */
	
	public List<BuyProductDto>  selectPastProductPriceInfo(Map<String, Object> params) {
		return sqlSessionTemplate.selectList(this.statement+"selectPastProductPriceInfo", params);
	}

	/** 물류센터 수탁상품 재고 조회*/
	public int selectCenStockCntSearchCountRow(Map<String, Object> params) {
		return (Integer) sqlSessionTemplate.selectOne(this.statement+"selectCenStockCntSearchCountRow", params);
	}
	/** 물류센터 수탁상품 재고 조회 */
	
	public List<ProductDto> selectCenStockCntSearchList( Map<String, Object> params, int page, int rows) {
		RowBounds rowBounds = new RowBounds((page-1)*rows, rows);
		return  sqlSessionTemplate.selectList(this.statement+"selectCenStockCntSearchList", params, rowBounds);
	}
	/** 물류센터 수탁상품 재고 조회 - 상세*/
	public int selectCenStockCntSearchPopCountRow(Map<String, Object> params) {
		return (Integer) sqlSessionTemplate.selectOne(this.statement+"selectCenStockCntSearchPopCountRow", params);
	}
	/** 물류센터 수탁상품 재고 조회 - 상세*/
	
	public List<ProductDto> selectCenStockCntSearchPopList( Map<String, Object> params, int page, int rows) {
		RowBounds rowBounds = new RowBounds((page-1)*rows, rows);
		return  sqlSessionTemplate.selectList(this.statement+"selectCenStockCntSearchPopList", params, rowBounds);
	}
	
	/**
	 * 고객사 진열 상품 검색 Count(운영사가)
	 */
	@Deprecated
	public int selectBuyProductSearchByAdmCnt(Map<String, Object> params) {
		return (Integer) sqlSessionTemplate.selectOne(this.statement+"selectBuyProductSearchByAdmCnt", params);
	}
	
	/**
	 * 고객사 진열 상품 검색 List (운영사가)
	 */
	
	@Deprecated
	public List<BuyProductDto> selectBuyProductSearchByAdmList(Map<String, Object> params, int page, int rows) {
		RowBounds rowBounds = new RowBounds((page-1)*rows, rows);
		return  sqlSessionTemplate.selectList(this.statement+"selectBuyProductSearchByAdmList", params, rowBounds);
	}

	public void updateProductCategory(Map<String, Object> saveMap) {
		sqlSessionTemplate.update(this.statement+"updateProductCategory", saveMap);
	}

	public List<BuyProductDto> selectBuyProductSearchList() {
		return  sqlSessionTemplate.selectList(this.statement+"selectAutoCompList");
	}
	
	
	/**
	 * 통합검색 Count 
	 * @param params
	 * @return
	 */
	public int getProductResultListCnt(Map<String, Object> params) {
//		return (Integer) sqlSessionTemplate.selectOne(this.statement+"selectProductListCntForAdmin", params);
		return (Integer) sqlSessionTemplate.selectOne(this.statement+"getProductResultListCnt", params);
	}
	public int getProductResultGridListCnt(Map<String, Object> params) {
		return (Integer) sqlSessionTemplate.selectOne(this.statement+"getProductResultGridListCnt", params);
	}
	
	
	/**
	 * 통합검색 List 
	 * @param params
	 * @param page
	 * @param rows
	 * @return
	 */
	
	public List<Map<String, Object>> getProductResultList(Map<String, Object> params,int pIdx,int pCnt) {
		RowBounds rowBounds = new RowBounds((pIdx-1)*pCnt, pCnt);
		if(pIdx == -1){
			return  sqlSessionTemplate.selectList(this.statement+"getProductResultList", params);	
		}else{
			return  sqlSessionTemplate.selectList(this.statement+"getProductResultList", params, rowBounds);
		}
	}
	public List<Map<String, Object>> selectProductSearchResultList(Map<String, Object> params,int pIdx,int pCnt) {
		RowBounds rowBounds = new RowBounds((pIdx-1)*pCnt, pCnt);
		return  sqlSessionTemplate.selectList(this.statement+"selectProductSearchResultList", params, rowBounds);
	}
	public List<Map<String, Object>> selectProductSearchResultVendorList(Map<String, Object> params) {
		return  sqlSessionTemplate.selectList(this.statement+"selectProductSearchResultVendorList", params);
	}
	
	public List<Map<String, Object>> getProductResultGridList(Map<String, Object> params,int pIdx,int pCnt) {
		RowBounds rowBounds = new RowBounds((pIdx-1)*pCnt, pCnt);
		return  sqlSessionTemplate.selectList(this.statement+"getProductResultGridList", params, rowBounds);
	}
	
	public List<Map<String, Object>> getProductResultInfo(Map<String, Object> params) {
		return  sqlSessionTemplate.selectList(this.statement+"getProductResultInfo", params);
	}
	
	public List<Map<String, Object>> getSideCateList(Map<String, Object> params) {
		return  sqlSessionTemplate.selectList(this.statement+"selectSideCateList", params);
	}
	
	public Map<String, Object> getChoiceVendorInfo(Map<String, Object> params) {
		return  sqlSessionTemplate.selectOne(this.statement+"selectChoiceVendorInfo", params);
	}

	public List<Map<String, Object>> getCommonOption(Map<String, Object> params) {
		return  sqlSessionTemplate.selectList(this.statement+"getCommonOption", params);
	}

	public List<Map<String, Object>> getAddOption(Map<String, Object> params) {
		return  sqlSessionTemplate.selectList(this.statement+"getAddOption", params);
	}
	public List<Map<String, Object>> selectUserGoodByUserInfo(Map<String, Object> params) {
		return  sqlSessionTemplate.selectList(this.statement+"selectUserGoodByUserInfo", params);
	}

	public List<Map<String, Object>> getProductResultOne(Map<String, Object> params) {
		return  sqlSessionTemplate.selectList(this.statement+"getProductResultOne", params);
	}

	/** 공급사 추가상품 상품 상세 정보 조회 */
	public List<Map<String, Object>> selectVenProductDetailInfoPop( Map<String, Object> params) {
		return  sqlSessionTemplate.selectList(this.statement+"selectVenProductDetailInfoPop", params);
	}

	/** 상품속성 조회 */
	public Map<String, Object> selectProductAttribute(String goodIdenNumb) {
		return sqlSessionTemplate.selectOne(this.statement+"selectProductAttribute", goodIdenNumb);
	}

	/** 공급사 역주문 관련 쿼리 시작 */
	public int selectVenOrdReqSrcPdtListCnt(Map<String, Object> params) {
		return (Integer) sqlSessionTemplate.selectOne(this.statement+"selectVenOrdReqSrcPdtListCnt", params);
	}
	public List<Map<String, Object>> selectVenOrdReqSrcPdtList( Map<String, Object> params, int page, int rows) {
		RowBounds rowBounds = new RowBounds((page-1)*rows, rows);
		return  sqlSessionTemplate.selectList(this.statement+"selectVenOrdReqSrcPdtList", params, rowBounds);
	}
	public List<Map<String, Object>> selectVenOrdReqSrcPdtInfo(Map<String, Object> params) {
		return  sqlSessionTemplate.selectList(this.statement+"selectVenOrdReqSrcPdtInfo", params);
	}
	public List<Map<String, Object>> selectVenOrdReqSrcPdtList( Map<String, Object> params) {
		return  sqlSessionTemplate.selectList(this.statement+"selectVenOrdReqSrcPdtList", params);
	}
	/* 공급사 역주문 관련 쿼리 끝 */

	
	
	
	
	/** 운영사 옵션 정보 조회 */
	public int selectAdmProdOptListCnt(Map<String, Object> params) {
		return (Integer) sqlSessionTemplate.selectOne(this.statement+"getOptionPdtList_count", params);
	}

	public List<Map<String, Object>> selectAdmProdOptList( Map<String, Object> params) {
		return  sqlSessionTemplate.selectList(this.statement+"getOptionPdtList", params);
	}

	
	/** 운영사 추가상품 조회 */
	public int selectAddPdtListCnt(Map<String, Object> params) {
		return (Integer) sqlSessionTemplate.selectOne(this.statement+"getAddPdtList_count", params);
	}
	public List<Map<String, Object>> selectAddPdtList(Map<String, Object> params) {
		return  sqlSessionTemplate.selectList(this.statement+"getAddPdtList", params);
	}

	
	
	/***************************		상품 진열 관련 부분 (상품조회 리스트에서 )  ***************/
	public void deleteMcgooddispaly(Map<String, String> params) {
		sqlSessionTemplate.delete(this.statement+"deleteMcgooddispaly", params);
	}

	public void deleteMcgoodDisplayBranch(Map<String, String> params) {
		sqlSessionTemplate.delete(this.statement+"deleteMcgoodDisplayBranch",params );
	}

	public void insertMcgooddispaly(Map<String, String> params) {
		sqlSessionTemplate.insert(this.statement+"insertMcgooddispaly", params);
	}

	public void insertMcgoodDisplayBranch(Map<String, String> params) {
		sqlSessionTemplate.insert(this.statement+"insertMcgoodDisplayBranch", params);
	}
	/***************************		상품 진열 관련 부분 (상품조회 리스트에서 )  ***************/
	
	
}