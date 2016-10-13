package kr.co.bitcube.order.dao;

import java.util.List;
import java.util.Map;

import kr.co.bitcube.order.dto.OrderDeliDto;
import kr.co.bitcube.order.dto.OrderReturnDto;
import kr.co.bitcube.order.dto.ParticularsTargetBranchsDto;

import org.apache.ibatis.session.RowBounds;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class ReturnOrderDao {
	private final String statement = "order.returnOrder.";
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	/**
	 * 인수내역/반품요청 리스트의 대상 데이터 갯수 리턴
	 * @param params
	 * @return
	 */
	public Integer selectReturnOrderRegistListCnt(Map<String, Object> params) {
		return (Integer) sqlSessionTemplate.selectOne(this.statement+"selectReturnOrderRegistListCnt", params);
	}
	/**
	 * 인수내역/반품요청 리스트의 대상 데이터 리턴
	 * @param params
	 * @return
	 */
	
	public List<OrderDeliDto> selectReturnOrderRegistList(Map<String, Object> params, int page, int rows) {
		RowBounds rowBounds = new RowBounds((page-1)*rows, rows);
		return  sqlSessionTemplate.selectList(this.statement+"selectReturnOrderRegistList", params, rowBounds);  
	}

	/**
	 * 반품요청내역 조회 리스트의 대상 데이터 갯수 리턴
	 * @param params
	 * @return
	 */
	public Integer selectReturnOrderListCnt(Map<String, Object> params) {
		return (Integer) sqlSessionTemplate.selectOne(this.statement+"selectReturnOrderListCnt", params);
	}
	/**
	 * 반품요청내역 조회 리스트의 대상 데이터 리턴
	 * @param params
	 * @return
	 */
	
	public List<OrderReturnDto> selectReturnOrderList(Map<String, Object> params, int page, int rows) {
		RowBounds rowBounds = new RowBounds((page-1)*rows, rows);
		return sqlSessionTemplate.selectList(this.statement+"selectReturnOrderList", params, rowBounds);  
	}
	
	/**
	 * 반품요청내역 상세 정보를 조회한다
	 */
	public OrderReturnDto selectReturnOrderRegistDetail(Map<String, Object> params) {
		return (OrderReturnDto) sqlSessionTemplate.selectOne(statement+"selectReturnOrderRegistDetail", params);
	}
	
	/**
	 * 반품 테이블에 insert 진행
	 */
	public void insertMrarem(Map<String, Object> saveMap) {
		this.sqlSessionTemplate.insert(statement+"insertMrarem", saveMap);
	}
	
	/**
	 * 공급사 반품내역 조회 리스트
	 */
	public Integer selectVenReturnOrderListCnt(Map<String, Object> params) { 
		return (Integer) sqlSessionTemplate.selectOne(this.statement+"selectVenReturnOrderListCnt", params);
	}
	
	public List<OrderReturnDto> selectVenReturnOrderList( Map<String, Object> params, int page, int rows) {
		RowBounds rowBounds = new RowBounds((page-1)*rows, rows);
		return sqlSessionTemplate.selectList(this.statement+"selectVenReturnOrderList", params, rowBounds);  
	}
	
	/**
	 * 반품 테이블 업데이트
	 */
	public void updateMrarem(Map<String, Object> saveMap) {
		sqlSessionTemplate.update(this.statement+"updateMrarem", saveMap);
	}
	public void insertMracptForOrderReturn(Map<String, Object> saveMap) {
		sqlSessionTemplate.insert(this.statement+"insertMracptForOrderReturn", saveMap);
	}
	
	
	public List<ParticularsTargetBranchsDto> getParticularsTargetBranchs(Map<String, Object> params){
		return sqlSessionTemplate.selectList(this.statement+"getParticularsTargetBranchs", params);
	}
	public int selectReceiveCancelCheck(Map<String, Object> saveMap) {
		return (Integer) sqlSessionTemplate.selectOne(this.statement+"selectReceiveCancelCheck", saveMap);
	}
	public int selectReceiveCancelQuan(Map<String, Object> saveMap) {
		return (Integer) sqlSessionTemplate.selectOne(this.statement+"selectReceiveCancelQuan", saveMap);
	}
	public void updateMracptForRcop(Map<String, Object> saveMap) {
		sqlSessionTemplate.update(this.statement+"updateMracptForRcop", saveMap);
	}
	public void deleteMrordtListRcop(Map<String, Object> saveMap) {
		sqlSessionTemplate.delete(this.statement+"deleteMrordtListRcop", saveMap);
	}
	
	
	public List<Map<String, Object>> selectReturnOrderRegistListExcelView(Map<String, Object> params) {
		return sqlSessionTemplate.selectList(this.statement+"selectReturnOrderRegistListExcelView", params);  
	}
	
	
	public List<Map<String, Object>> selectReturnOrderListExcelView(Map<String, Object> params) {
		return sqlSessionTemplate.selectList(this.statement+"selectReturnOrderListExcelView", params);  
	}
	public int selectIsNormTrusGood(Map<String, Object> saveMap) {
		return (Integer) sqlSessionTemplate.selectOne(this.statement+"selectIsNormTrusGood", saveMap);
	}
	
	
	public Map<String, Object> selectStockOrderInfo(Map<String, Object> saveMap) {
		return sqlSessionTemplate.selectOne(this.statement+"selectStockOrderInfo", saveMap);  
	}
	
	public List<Map<String, Object>> selectReturnOrderVendorList(Map<String, Object> saveMap) {
		return sqlSessionTemplate.selectList(this.statement+"selectReturnOrderVendorList", saveMap);
	}
	public Map<String, Object> selectReturnOrderSmsInfo(Map<String, Object> saveMap) {
		return sqlSessionTemplate.selectOne(this.statement+"selectReturnOrderSmsInfo", saveMap);
	}
	
	public Integer selectClientReturnOrderListCntForRece( Map<String, Object> params) {
		return (Integer) sqlSessionTemplate.selectOne(this.statement+"selectClientReturnOrderListCntForRece", params); 
	}
	
	public List<Map<String, Object>> selectClientReturnOrderListForRece( Map<String, Object> params, int page, int rows) {
		RowBounds rowBounds = new RowBounds((page-1)*rows, rows);
		return  sqlSessionTemplate.selectList(this.statement+"selectClientReturnOrderListForRece", params, rowBounds);  
	}
	public List<Map<String, Object>> selectClientReturnOrderListForRece( Map<String, Object> params) {
		return  sqlSessionTemplate.selectList(this.statement+"selectClientReturnOrderListForRece", params);  
	}
	
	
	public Integer selectClientReturnOrderListCntForRetu( Map<String, Object> params) {
		return (Integer) sqlSessionTemplate.selectOne(this.statement+"selectClientReturnOrderListCntForRetu", params); 
	}
	
	public List<Map<String, Object>> selectClientReturnOrderListForRetu( Map<String, Object> params, int page, int rows) {
		RowBounds rowBounds = new RowBounds((page-1)*rows, rows);
		return  sqlSessionTemplate.selectList(this.statement+"selectClientReturnOrderListForRetu", params, rowBounds);  
	}
	public Integer selectReturnOrdStatListCnt(Map<String, Object> params) {
		return (Integer) sqlSessionTemplate.selectOne(this.statement+"selectReturnOrdStatListCnt", params); 
	}
	public List<Map<String, Object>> selectReturnOrdStatList( Map<String, Object> params, int page, int rows) {
		RowBounds rowBounds = new RowBounds((page-1)*rows, rows);
		return  sqlSessionTemplate.selectList(this.statement+"selectReturnOrdStatList", params, rowBounds);  
	}
	public Map<String, Object> selectBuyAddProdOrde(Map<String, Object> tmpMap) {
		return sqlSessionTemplate.selectOne(this.statement+"selectBuyAddProdOrde", tmpMap);  
	}
	public Integer selectReturnOrderRegistListCntNew(Map<String, Object> params) {
		return (Integer) sqlSessionTemplate.selectOne(this.statement+"selectReturnOrderRegistListCntNew", params);
	}
	public List<OrderDeliDto> selectReturnOrderRegistListNew( Map<String, Object> params, int page, int rows) {
		RowBounds rowBounds = new RowBounds((page-1)*rows, rows);
		return  sqlSessionTemplate.selectList(this.statement+"selectReturnOrderRegistListNew", params, rowBounds);  
	}
}
