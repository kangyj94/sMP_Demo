package kr.co.bitcube.product.dao;

import java.util.List;
import java.util.Map;

import kr.co.bitcube.product.dto.ProductAppGoodDto;

import org.apache.ibatis.session.RowBounds;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class ProductAppDao {
	private final String statement = "product.app.";
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;  // id(Sequence) 생성을 위해 추가
	
	/**
	 *  승인 상세 데이터 
	 */
	
	public List<ProductAppGoodDto> selectAppProductDetail(Map<String, Object> params) throws Exception {
		return this.sqlSessionTemplate.selectList(statement+"selectAppProductDetail", params);
	}
	
	/**
	 * (운영사) 단가변경요청승인정보 검색 Count
	 * @param params
	 * @return
	 */
	public int selectProductAppListCnt(Map<String, Object> params) {
		return (Integer) sqlSessionTemplate.selectOne(this.statement+"selectProductAppListCnt", params);
	}
	
	/**
	 * (운영사) 단가변경요청승인정보 검색 List
	 * @param params
	 * @return
	 */
	
	public List<ProductAppGoodDto> selectProductAppList(Map<String, Object> params, int page, int rows) {
		RowBounds rowBounds = new RowBounds((page-1)*rows, rows);
		return  sqlSessionTemplate.selectList(this.statement+"selectProductAppList", params, rowBounds);
	}
	
	
	/**
	 * good_iden_numb , vendorid 기준 진열 조직 정보를 리턴한다.  
	 */
	
	public List<ProductAppGoodDto> selectDispIdForInsertNewDispId(Map<String, Object> params) throws Exception {
		return this.sqlSessionTemplate.selectList(statement+"selectDispIdForInsertNewDispId", params);
	}
	
	/**
	 *  최신상품을 진열한다. 
	 */
	public int updateSetAbleDispProduct(Map<String, Object> saveMap){
		return sqlSessionTemplate.update(this.statement+"updateSetAbleDispProduct", saveMap);
	}
	
	/**
	 *  최신진열 상품 이외에 과거 상품 진열 정보를 내린다.  
	 */
	public int updateSetUnAbleDispPastProduct(Map<String, Object> saveMap){
		return sqlSessionTemplate.update(this.statement+"updateSetUnAbleDispPastProduct", saveMap);
	}
	
	/**
	 *  공급사 품목 변경 테이블 sts 상태를 '2' 로 업데이트 한다.   
	 */
	public int updateMcGoodFixAppSts(Map<String, Object> saveMap){
		return sqlSessionTemplate.update(this.statement+"updateMcGoodFixAppSts", saveMap);
	}
	
	/**
	 * 상품공급사 매입단가 변경
	 */
	public int updateProdVendorUnitPrice(Map<String, Object> saveMap){
		return sqlSessionTemplate.update(this.statement+"updateProdVendorUnitPrice", saveMap);
	}

	/**
	 * 상품 공급사 히스토리 변경 
	 */
	public void insertProductVendorHist(Map<String, Object> saveMap){
		sqlSessionTemplate.insert(this.statement+"insertProductVendorHist", saveMap);
	}
	
	/**
	 *	 매입가 변경에 따른 새로운 진열정보 insert 
	 */
	public void insertDispProductInfos(Map<String, Object> saveMap){
		 sqlSessionTemplate.insert(this.statement+"insertDispProductInfos", saveMap);
	}
	
	/**
	 *	매입가 변경에 따른 과거 진열 정보 update 진열 0  
	 */
	public int updateUnDispPlayProdVendor(Map<String, Object> saveMap){
		return sqlSessionTemplate.update(this.statement+"updateUnDispPlayProdVendor", saveMap);
	}
	
	/**
	 *	 상품 공급사 삭제시 히스토리를 생성한다.  
	 */
	@Deprecated
	public void insertProductVendorHistForDelete(Map<String, Object> saveMap){
		 sqlSessionTemplate.insert(this.statement+"insertProductVendorHistForDelete", saveMap);
	}
	
	/**
	 * 종료요청 공급사 상품을 삭제 처리한다. 
	 */
	@Deprecated
	public void deleteProductVendor(Map<String, Object> saveMap){
		sqlSessionTemplate.delete(this.statement+"deleteProductVendor", saveMap);
	}
	public int updateProdVendorUseSts(Map<String, Object> saveMap){
		return sqlSessionTemplate.delete(this.statement+"updateProdVendorUseSts", saveMap);
	}
	
	
	/**
	 *	 단가변경 승인 요청정보를 update 한다. 
	 */
	public int updateAppGoodSts(Map<String, Object> saveMap){
		return sqlSessionTemplate.delete(this.statement+"updateAppGoodSts", saveMap);
	}
	
	/**
	 * 6개월 기간별 공급사 변화 추이를 반영한다. 
	 */
	
	public List<Map<String, Object>> selectProdVendorUnitPriceChart(Map<String, Object> params){
		return  sqlSessionTemplate.selectList(this.statement+"selectProdVendorUnitPriceChart", params); 
	}
	
	
	/**
	 * 6개월 기간별 공급사 변화 추이를 반영한다. 
	 */
	
	public List<Map<String, Object>> selectprodSellUnitPriceChart(Map<String, Object> params){
		return  sqlSessionTemplate.selectList(this.statement+"selectprodSellUnitPriceChart", params); 
	}

	public void updateMcGoodFixAppStsByApproval(Map<String, Object> saveMap) {
		sqlSessionTemplate.update(this.statement+"updateMcGoodFixAppStsByApproval", saveMap);
	}

	public void updateProdVendorUnitPriceByExcelUpload( Map<String, Object> saveMap) {
		sqlSessionTemplate.update(this.statement+"updateProdVendorUnitPriceByExcelUpload", saveMap);
	}

	
	public Map<String, String> selectMcgoodVendorInfoByExcelUpload(Map<String, Object> saveMap) {
		return sqlSessionTemplate.selectOne(this.statement+"selectMcgoodVendorInfoByExcelUpload", saveMap); 
	}
}
