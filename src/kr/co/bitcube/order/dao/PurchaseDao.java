package kr.co.bitcube.order.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import kr.co.bitcube.order.dto.OrderDto;
import kr.co.bitcube.order.dto.OrderPurtDto;

import org.apache.ibatis.session.RowBounds;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class PurchaseDao {
	private final String statement = "order.purchase.";
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	
	public List<OrderPurtDto> selectPurchaseForDivOrder( Map<String, Object> params) {
		return  sqlSessionTemplate.selectList(this.statement+"selectPurchaseForDivOrder", params);
	}
	
	
	public List<OrderPurtDto> selectOrderDetailPurchaseList( Map<String, Object> params) {
		return  sqlSessionTemplate.selectList(this.statement+"selectOrderDetailPurchaseList", params);
	}

	public void insertMrpurt(Map<String, Object> saveMap) {
		this.sqlSessionTemplate.insert(statement+"insertMrpurt", saveMap);
	}

	public void updateMrordt(Map<String, Object> saveMap) {
		this.sqlSessionTemplate.update(statement+"updateMrordt", saveMap);
	}

	public Integer selectPurchaseNumber(Map<String, Object> saveMap) {
		return (Integer) sqlSessionTemplate.selectOne(this.statement+"selectPurchaseNumber", saveMap);
	}

	public void updateMrpurt(Map<String, Object> saveMap) {
		this.sqlSessionTemplate.update(statement+"updateMrpurt", saveMap);
	}

	public Integer selectPurcQuan(Map<String, Object> saveMap) {
		return (Integer) sqlSessionTemplate.selectOne(this.statement+"selectPurcQuan", saveMap);
	}

	public void deleteMrpurt(Map<String, Object> saveMap) {
		this.sqlSessionTemplate.delete(statement+"deleteMrpurt", saveMap);
	}

	public Integer selectMrordtPurcQuan(Map<String, Object> saveMap) {
		return (Integer) sqlSessionTemplate.selectOne(this.statement+"selectMrordtPurcQuan", saveMap);
	}

	public int selectPurchaseListCnt(Map<String, Object> params) {
		return (Integer) sqlSessionTemplate.selectOne(this.statement+"selectPurchaseListCnt", params);
	}
	
	public List<OrderPurtDto> selectPurchaseList(Map<String, Object> params, int page, int rows) {
		RowBounds rowBounds = new RowBounds((page-1)*rows, rows);
		return  sqlSessionTemplate.selectList(this.statement+"selectPurchaseList", params, rowBounds);
	}

	
	public HashMap<String, String> selectDivVendorId(Map<String, Object> params) {
		return  sqlSessionTemplate.selectOne(this.statement+"selectDivVendorId", params);
	}

	public int selectPurchasePrintListCnt(Map<String, Object> params) {
		return (Integer) sqlSessionTemplate.selectOne(this.statement+"selectPurchasePrintListCnt", params);
	}

	
	public List<OrderPurtDto> selectPurchasePrintList( Map<String, Object> params, int page, int rows) {
		RowBounds rowBounds = new RowBounds((page-1)*rows, rows);
		return  sqlSessionTemplate.selectList(this.statement+"selectPurchasePrintList", params, rowBounds);
	}

	public Map<String, Object> selectPurchasetResultListCnt(Map<String, Object> params) {
		return (Map<String, Object>) sqlSessionTemplate.selectOne(this.statement+"selectPurchaseResultListCnt", params);
	}

	
	public List<OrderPurtDto> selectPurchaseResultList( Map<String, Object> params, int page, int rows) {
		RowBounds rowBounds = new RowBounds((page-1)*rows, rows);
		return  sqlSessionTemplate.selectList(this.statement+"selectPurchaseResultList", params, rowBounds);
	}

	
	public List<OrderPurtDto> selectPurchaseResultListForPop( Map<String, Object> params) {
		return  sqlSessionTemplate.selectList(this.statement+"selectPurchaseResultList", params);
	}

	public void updateMrordtVendorId(Map<String, Object> saveMap) {
		this.sqlSessionTemplate.update(statement+"updateMrordtVendorId", saveMap);
	}

	
	public List<Map<String, Object>> selectPurchaseExcelList( Map<String, Object> params) {
		return  sqlSessionTemplate.selectList(this.statement+"selectPurchaseExcelList", params);
	}
	
	
	public List<Map<String, Object>> selectPurchaseResultListExcelView( Map<String, Object> params) {
		return  sqlSessionTemplate.selectList(this.statement+"selectPurchaseResultListExcelView", params);
	}
	
	
	public List<Map<String, Object>> selectPurchasePrintListExcelView( Map<String, Object> params) {
		return  sqlSessionTemplate.selectList(this.statement+"selectPurchasePrintListExcelView", params);
	}

	public OrderDto orderStatCheck(Map<String, Object> params) {
		return (OrderDto)sqlSessionTemplate.selectOne(this.statement+"orderStatCheck", params);
	}


	public Map<String, Object> selectMrpurtSmsInfo(Map<String, Object> saveMap) {
		return sqlSessionTemplate.selectOne(this.statement+"selectMrpurtSmsInfo", saveMap);
	}


	public void insertPrePayMrpurt(Map<String, Object> saveMap) throws Exception{
		sqlSessionTemplate.insert(this.statement+"insertPrePayMrpurt", saveMap);
	}
	
	public void updatePrePayMrordt(Map<String, Object> saveMap) throws Exception{
		sqlSessionTemplate.update(this.statement+"updatePrePayMrordt", saveMap);
	}


	public String selectPrePayOrderStatus(Map<String, Object> saveMap) throws Exception{
		return sqlSessionTemplate.selectOne(this.statement+"selectPrePayOrderStatus", saveMap);
	}


	public int selectVenOrderPurchaseCnt(Map<String, Object> params)  throws Exception{
		return sqlSessionTemplate.selectOne(this.statement+"selectVenOrderPurchaseCnt", params);
	}


	public List<Map<String, Object>> selectVenOrderPurchaseList(Map<String, Object> params,int pIdx, int pCnt) throws Exception{
		RowBounds rowBounds = new RowBounds((pIdx-1)*pCnt, pCnt);
		return sqlSessionTemplate.selectList(this.statement+"selectVenOrderPurchaseList", params, rowBounds);
	}


	public String selectOrdPurcStatus(Map<String, Object> saveMap) throws Exception{
		return sqlSessionTemplate.selectOne(this.statement+"selectOrdPurcStatus", saveMap);
	}


	public void updateOrdPurcReceive(Map<String, Object> saveMap) throws Exception{
		sqlSessionTemplate.update(this.statement+"updateOrdPurcReceive", saveMap);
	}


	public void updateMrordtPurcRequQuan(Map<String, Object> saveMap) throws Exception{
		sqlSessionTemplate.update(this.statement+"updateMrordtPurcRequQuan", saveMap);
	}

	public void deleteOrdPurcReceive(Map<String, Object> saveMap) throws Exception{
		sqlSessionTemplate.delete(this.statement+"deleteOrdPurcReceive", saveMap);
	}
	
	public Map<String, Object> selectOrdPurcReceiveRejectSmsInfo(Map<String, Object> saveMap) throws Exception {
		return sqlSessionTemplate.selectOne(this.statement+"selectOrdPurcReceiveRejectSmsInfo", saveMap);
	}


	public int selectVenpurchaseListPrintCnt(Map<String, Object> params) throws Exception{
		return sqlSessionTemplate.selectOne(this.statement+"selectVenpurchaseListPrintCnt", params);
	}


	public List<Map<String, Object>> selectVenpurchaseListPrint(Map<String, Object> params, int page, int rows) throws Exception {
		RowBounds rowBounds = new RowBounds((page-1)*rows, rows);
		return sqlSessionTemplate.selectList(this.statement+"selectVenpurchaseListPrint", params, rowBounds);
	}


	
	/** 발주접수 취소요청 처리 카운트*/
	public int selectVenOrdPurcCancProcListCnt(Map<String, Object> params) {
		return sqlSessionTemplate.selectOne(this.statement+"selectVenOrdPurcCancProcListCnt", params);
	}
	/** 발주접수 취소요청 처리 데이터 조회*/ 
	public List<Map<String, Object>> selectVenOrdPurcCancProcList( Map<String, Object> params, int page, int rows) {
		RowBounds rowBounds = new RowBounds((page-1)*rows, rows);
		return sqlSessionTemplate.selectList(this.statement+"selectVenOrdPurcCancProcList", params, rowBounds);
	}


	/** mrordt 테이블 상태 변경 */
	public int updatePurcCancProcMrordt(Map<String, Object> tranMap) {
		return this.sqlSessionTemplate.update(statement+"updatePurcCancProcMrordt", tranMap);
	}
	/** mrpurt 테이블 상태 변경 */
	public int updatePurcCancProcMrpurt(Map<String, Object> tranMap) {
		return this.sqlSessionTemplate.update(statement+"updatePurcCancProcMrpurt", tranMap);
	}
	/** 주문취소 요청 번호로 주문번호 조회 */
	public Map<String, Object> selectOrdInfoByPurcCancId( Map<String, Object> tranMap) {
		return sqlSessionTemplate.selectOne(this.statement+"venSelectCancReqInfoByCanId", tranMap);
	}
	/** 주문취소 요청 테이블 상태 변경 */
	public int updatePurcCancProc(Map<String, Object> tranMap) {
		return this.sqlSessionTemplate.update(statement+"updatePurcCancProc", tranMap);
	}


	/** 고객사 주문취소요청에 의한 발주테이블 상태 변경 */
	public void updatePurcCancStartMrpurt(Map<String, Object> saveMap) {
		this.sqlSessionTemplate.update(statement+"updatePurcCancStartMrpurt", saveMap);
	}
	/** 고객사 주문취소요청에 의한 발주취소테이블 데이터 생성 */
	public void insertPurcCancStartMrpurtCanc(Map<String, Object> saveMap) {
		this.sqlSessionTemplate.insert(statement+"insertPurcCancStartMrpurtCanc", saveMap);
	}


	/** 공급사 진척도 조회에서 주문취소요청건 정보 조회 */
	public Map<String, Object> venSelectCancReqInfo(Map<String, Object> params) {
		return sqlSessionTemplate.selectOne(this.statement+"venSelectCancReqInfo", params);
	}


	/** 발주접수 전에 추가상품 여부 확인 */
	public Map<String, Object> selectAddProdSearchForPurc(Map<String, Object> saveMap) {
		return sqlSessionTemplate.selectOne(this.statement+"selectAddProdSearchForPurc", saveMap);
	}


	/** 변경 요청 주문의 상품이 추가상품 관련 상품인지 조회  */
	public Map<String, Object> selectIsAddProdCancelAble(Map<String, Object> saveMap) {
		return sqlSessionTemplate.selectOne(this.statement+"selectIsAddProdCancelAble", saveMap);
	}


	
	
	
	/** 운영사 발주접수 */
	public int selectPurchaseListCntNew(Map<String, Object> params) {
		return (Integer) sqlSessionTemplate.selectOne(this.statement+"selectPurchaseListCntNew", params);
	}
	public List<OrderPurtDto> selectPurchaseListNew(Map<String, Object> params, int page, int rows) {
		RowBounds rowBounds = new RowBounds((page-1)*rows, rows);
		return  sqlSessionTemplate.selectList(this.statement+"selectPurchaseListNew", params, rowBounds);
	}


	/**운영사 발주이력 */
	@SuppressWarnings("unchecked")
	public Map<String, Object> selectPurchasetResultListNewCnt( Map<String, Object> params) {
		return (Map<String, Object>) sqlSessionTemplate.selectOne(this.statement+"selectPurchasetResultListNewCnt", params);
	}
	public List<OrderPurtDto> selectPurchaseResultNewList( Map<String, Object> params, int page, int rows) {
		RowBounds rowBounds = new RowBounds((page-1)*rows, rows);
		return  sqlSessionTemplate.selectList(this.statement+"selectPurchaseResultNewList", params, rowBounds);
	}


	public Map<String, Object> selectPrePayForAddProd( Map<String, Object> addProdOrdMap) {
		return sqlSessionTemplate.selectOne(this.statement+"selectPrePayForAddProd", addProdOrdMap);
	}


	public void updateIsPurcPrint(Map<String, String> tmpMap) {
		this.sqlSessionTemplate.update(statement+"updateIsPurcPrint", tmpMap);
	}


	public void updateMrordmIsPurcPrint(String orde_iden_numb) {
		this.sqlSessionTemplate.update(statement+"updateMrordmIsPurcPrint", orde_iden_numb);
	}


}
