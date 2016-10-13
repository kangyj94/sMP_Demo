package kr.co.bitcube.product.dao;

import java.util.List;
import java.util.Map;

import kr.co.bitcube.product.dto.McBidAuctionDto;
import kr.co.bitcube.product.dto.McBidDto;
import kr.co.bitcube.product.dto.McNewGoodRequestDto;

import org.apache.ibatis.session.RowBounds;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class NewProductBidDao {

	private final String statement = "product.newProductBid.";
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	
	/**
	 * 고객사상품등록요청 리스트의 카운트 조회하는 메소드
	 * @param params
	 * @return
	 */ 
	public int selectNewProductRequestListCnt(Map<String, Object> params) {
		return (Integer) sqlSessionTemplate.selectOne(this.statement+"selectNewProductRequestListCnt", params);
	}
	
	/**
	 * 고객사상품등록요청 리스트를 조회하여 반환하는 메소드
	 * @param params
	 * @param page(페이지번호)
	 * @param rows(페이지 Row 개수)
	 * @return
	 */
	
	public List<McNewGoodRequestDto> selectNewProductRequestList(Map<String, Object> params, int page, int rows) {
		RowBounds rowBounds = new RowBounds((page-1)*rows, rows);
		return  sqlSessionTemplate.selectList(this.statement+"selectNewProductRequestList", params, rowBounds);
	}
	
	/**
	 * 신규품목요청 상세 정보 
	 * @param params
	 * @return
	 */
	public McNewGoodRequestDto selectRequestProductDetailInfo (Map<String, Object> params){
		return (McNewGoodRequestDto) sqlSessionTemplate.selectOne(this.statement+"selectRequestProductDetailInfo", params);
	}
	
	/**
	 * 입찰조회운영사 리스트의 카운트 조회하는 메소드
	 * @param params
	 * @return
	 */ 
	public int selectNewProductBidListCntAdm(Map<String, Object> params) {
		return (Integer) sqlSessionTemplate.selectOne(this.statement+"selectNewProductBidListCntAdm", params);
	}
	
	/**
	 * 입찰조회공급사 리스트의 카운트 조회하는 메소드
	 * @param params
	 * @return
	 */ 
	public int selectNewProductBidListCntVen(Map<String, Object> params) {
		return (Integer) sqlSessionTemplate.selectOne(this.statement+"selectNewProductBidListCntVen", params);
	}
	
	
	/**
	 * 신규품목 요청 (등록)
	 * @param params
	 */
	public void insertNewProductRequest(Map<String, Object> params){
		sqlSessionTemplate.insert(this.statement+"insertNewProductRequest", params);
	}
	
	
	/**
	 * 신규품목 요청 (수정,삭제)
	 * @param params
	 */
	public void updateNewProductRequest(Map<String, Object> params){
		sqlSessionTemplate.update(this.statement+"updateNewProductRequest", params);
	}
	
	
	/**
	 * 히스토리 저장 
	 * @param params
	 */
	public void insertNewProductRequestHistByNewgoodid(Map<String, Object> params){
		sqlSessionTemplate.insert(this.statement+"insertNewProductRequestHistByNewgoodid", params);
	}
	
	
	/**
	 * 기상품 처리  
	 * @param params
	 */
	public void updateExistsProductProcess(Map<String, Object> params){
		sqlSessionTemplate.update(this.statement+"updateExistsProductProcess", params);
	}
	
	
	/**
	 * 입찰조회운영사 리스트를 조회하여 반환하는 메소드
	 * @param params
	 * @param page(페이지번호)
	 * @param rows(페이지 Row 개수)
	 * @return
	 */
	
	public List<McBidDto> selectNewProductBidList(Map<String, Object> params, int page, int rows) {
		RowBounds rowBounds = new RowBounds((page-1)*rows, rows);
		return  sqlSessionTemplate.selectList(this.statement+"selectNewProductBidList", params, rowBounds);
	}
	
	/**
	 * 신규품목 요청 상태 수정 
	 * @param params
	 */
	public void updateNewProductRequestState(Map<String, Object> params){
		sqlSessionTemplate.update(this.statement+"updateNewProductRequestState", params);
	}
	
	/**
	 * 상품입찰 공고
	 * @param params
	 */
	public void insertBid(Map<String, Object> params) {
		sqlSessionTemplate.insert(this.statement+"insertBid", params);
	}
	
	/**
	 * 히스토리 저장 (상품입찰공고)
	 * @param params
	 */
	public void insertBidHist(Map<String, Object> params) {
		sqlSessionTemplate.insert(this.statement+"insertBidHist", params);
	}
	
	/**
	 * 상품입찰 공급사정보
	 * @param saveMap
	 */
	public void insertBidAuction(Map<String, Object> saveMap) {
		sqlSessionTemplate.insert(this.statement+"insertBidAuction", saveMap);
	}
	
	/**
	 * 히스토리 저장 (상품입찰 공급사정보)
	 * @param saveMap
	 */
	public void insertBidAuctionHist(Map<String, Object> saveMap) {
		sqlSessionTemplate.insert(this.statement+"insertBidAuctionHist", saveMap);
	}
	
	/**
	 * 상품입찰공고사 상세 정보 
	 * @param params
	 * @return
	 */
	
	public List<McBidAuctionDto> selectBidAuctionDetailInfo (Map<String, Object> params) {
		return  sqlSessionTemplate.selectList(this.statement+"selectBidAuctionDetailInfo", params);
	}
	
	/**
	 * 상품입찰공고 상세 정보 
	 * @param params
	 * @return
	 */
	public McBidDto selectBidProductDetailInfo (Map<String, Object> params) {
		return (McBidDto) sqlSessionTemplate.selectOne(this.statement+"selectBidProductDetailInfo", params);
	}
	
	/**
	 * 상품입찰공급사정보 리스트의 카운트 조회하는 메소드
	 * @param params
	 * @return
	 */ 
	public int selectNewProductBidAuctionListCnt(Map<String, Object> params) {
		return (Integer) sqlSessionTemplate.selectOne(this.statement+"selectNewProductBidAuctionListCnt", params);
	}
	
	/**
	 * 상품입찰공급사정보 리스트를 조회하여 반환하는 메소드
	 * @param params
	 * @return
	 */
	
	public List<McBidAuctionDto> selectNewProductBidAuctionList(Map<String, Object> params) {
		return  sqlSessionTemplate.selectList(this.statement+"selectNewProductBidAuctionList", params);
	}
	
	/**
	 * 상품입찰공급사정보 상세 정보 
	 * @param params
	 * @return
	 */
	public McBidAuctionDto selectBidAuctionProductDetailInfo (Map<String, Object> params){
		return (McBidAuctionDto) sqlSessionTemplate.selectOne(this.statement+"selectBidAuctionProductDetailInfo", params);
	}
	
	/**
	 * 상품입찰공급사정보 수정 
	 * @param params
	 */
	public void updateBidAuction(Map<String, Object> params){
		sqlSessionTemplate.update(this.statement+"updateBidAuction", params);
	}
	
	/**
	 * 상품입찰공급사정보 상태 수정 
	 * @param params
	 */
	public void updateBidAuctionState(Map<String, Object> params){
		sqlSessionTemplate.update(this.statement+"updateBidAuctionState", params);
	}
	
	/**
	 * 상품입찰공고 상태 수정 
	 * @param params
	 */
	public void updateBidState(Map<String, Object> params){
		sqlSessionTemplate.update(this.statement+"updateBidState", params);
	}
	

	/**
	 * mcbidauction 에 등록상품 코드 등록 
	 */
	public int updateRegistratGoodIdenNumb(Map<String, Object> params){
		return sqlSessionTemplate.update(this.statement+"updateRegistratGoodIdenNumb", params);
	}
	
	/**
	 * mcbid 및 mcnewgoodrequest 에 상품등록 여부를 확인   
	 */
	public McBidDto selectReqAndBidInfo (Map<String, Object> params){
		return (McBidDto) sqlSessionTemplate.selectOne(this.statement+"selectReqAndBidInfo", params);
	}
	
	/**
	 * 상품 등록후 입찰 상품에 품목을 등록한다. 
	 */
	public int updateBidGoodIdenNumb(Map<String, Object> params){
		return sqlSessionTemplate.update(this.statement+"updateBidGoodIdenNumb", params);
	}
	
	/**
	 * 신규품목요청에 입찰 통해 상품등록 및 상태값 변경  
	 */
	public int updateNewProdGoodIdenNumb(Map<String, Object> params){
		return sqlSessionTemplate.update(this.statement+"updateNewProdGoodIdenNumb", params);
	}
	
}
