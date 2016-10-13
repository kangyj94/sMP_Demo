package kr.co.bitcube.order.dao;

import java.util.List;
import java.util.Map;

import kr.co.bitcube.order.dto.CartMasterInfoDto;
import kr.co.bitcube.order.dto.CartProdInfoDto;







import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class CartManageDao {
	
	private final String statement = "order.cart.";

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;  // id(Sequence) 생성을 위해 추가
	
	/**
	 * 사용자 조직 카트 정보 count 조회 
	 * 1: 존재 , 0: 미존재 
	 * @param params
	 * @return
	 */
	public int selectCateForBranchCnt(Map<String, Object> params) {
		return (Integer)sqlSessionTemplate.selectOne(this.statement+"selectIsExistsCateForBranck", params);
	}
	/**
	 * 카테고리 마스터 insert 
	 * @param saveMap
	 */
	public void insertCateMasterInfo(Map<String, Object> saveMap) {
		sqlSessionTemplate.insert(this.statement+"insertCateMasterInfo", saveMap);
	}
	
	/**
	 * 사용자 조직기준 카트 정보 조회
	 * @param params
	 * @return
	 */
	public CartMasterInfoDto selectCateMasterInfo(Map<String, Object> params)   {
		return (CartMasterInfoDto)sqlSessionTemplate.selectOne(this.statement+"selectCateMasterInfo", params);
	}
	
	public List<CartProdInfoDto> selectCartProdInfo (Map<String, Object> params)   {
		return sqlSessionTemplate.selectList(this.statement+"selectCartProdInfo", params);
	}
	
	/**
	 * 장바구니 상품 삭제 
	 * @param params
	 * @return
	 */
	public void deleteCartProdInfo(Map<String, Object> params){
		sqlSessionTemplate.delete(this.statement+"deleteCartProdInfo", params);
	}
	
	
	public int selectProdCntInCate(Map<String, Object> params) {
		return (Integer)sqlSessionTemplate.selectOne(this.statement+"selectProdCntInCate", params);
	}
	
	public void updateProductOrderQuanInCart (Map<String, Object> saveMap) {
		sqlSessionTemplate.update(this.statement+"updateProductOrderQuanInCart", saveMap);
	}
	
	public  void insertProductInCart(Map<String, Object> saveMap) {
		sqlSessionTemplate.insert(this.statement+"insertProductInCart", saveMap);
	}
	
	public void updateCartProductOrdQuan(Map<String, Object> saveMap){
		sqlSessionTemplate.update(this.statement+"editCartProductOrdQuan", saveMap);
	}
	
	public void deleteCartProduct(Map<String, Object> saveMap){
		sqlSessionTemplate.delete(this.statement+"deleteCartProduct", saveMap);
	}
	
	public void updateCartMstInfo(Map<String, Object> saveMap){
		sqlSessionTemplate.update(this.statement+"updateCartMstInfo", saveMap);
	}
	public void updateCartAttachFile(Map<String, Object> saveMap) {
		sqlSessionTemplate.update(this.statement+"updateCartAttachFile", saveMap);
	}
	public void updateCartInfo(Map<String, Object> searchParams) {
		sqlSessionTemplate.update(this.statement+"updateCartInfo", searchParams);
	}
	public void updateCartProd(Map<String, Object> searchParams) {
		sqlSessionTemplate.update(this.statement+"updateCartProd", searchParams);
	}
	public List<Map<String, Object>> getBuyCartInfo (Map<String, Object> params)   {
		return sqlSessionTemplate.selectList(this.statement+"getBuyCartInfo", params);
	}	
	public void deleteAddProduct(Map<String, Object> params) {
		sqlSessionTemplate.delete(this.statement+"deleteAddProduct", params);
	}
	public void deleteCartPdt(Map<String, Object> saveMap) {
		sqlSessionTemplate.delete(this.statement+"deleteCartPdt", saveMap);
	}
	
	
	/** 기존 상품 조회 */
	public List<Map<String, Object>> selectExistProdList( Map<String, Object> params) {
		return sqlSessionTemplate.selectList(this.statement+"selectExistProdList", params);
	}
	/** 추가 상품 조회 */
	public List<Map<String, Object>> selectExistAddProdList( Map<String, Object> params) {
		return sqlSessionTemplate.selectList(this.statement+"selectExistAddProdList", params);
	}
	/** 추가 상품 관련 삭제 */
	public void deleteCartPdtForAddProd(Map<String, Object> tempMap) {
		sqlSessionTemplate.delete(this.statement+"deleteCartPdtForAddProd", tempMap);
	}
	
	/** 추가상품의 서브 상품으로 등록이 되어있는지 조회 */
	public Map<String, Object> selectCartChkAddProductSubInfo( Map<String, Object> params) {
		return sqlSessionTemplate.selectOne(this.statement+"selectCartChkAddProductSubInfo", params);
	}
	public Map<String, Object> selectCartChkAddProductSubInfo2( Map<String, Object> params) {
		return sqlSessionTemplate.selectOne(this.statement+"selectCartChkAddProductSubInfo2", params);
	}
	
	
	/** 고객사 주문수량 저장 */
	public void updateCartPdtOrdQuan(Map<String, Object> params) {
		sqlSessionTemplate.update(this.statement+"updateCartPdtOrdQuan", params);
	}
	
}
