package kr.co.bitcube.order.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import kr.co.bitcube.common.dto.UserDto;
import kr.co.bitcube.order.dto.OrderBorgDto;
import kr.co.bitcube.order.dto.OrderDto;
import kr.co.bitcube.order.dto.OrderHistDto;

import org.apache.ibatis.session.RowBounds;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.ui.ModelMap;

@Repository
public class OrderRequestDao {
	private final String statement = "order.orderRequest.";
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	
	public int selectGoodsQuanDiv(Map<String, Object> paramMap) {
		return (Integer) sqlSessionTemplate.selectOne(this.statement+"selectGoodsQuanDiv", paramMap);
	}

	public OrderDto selectOrderSeq(Map<String, Object> paramMap) {
		return (OrderDto) sqlSessionTemplate.selectOne(this.statement+"selectOrderSeq", paramMap);
	}

	public void InsertMrordm(Map<String, Object> saveMap) {
		this.sqlSessionTemplate.insert(statement+"InsertMrordm", saveMap);
	}

	public void InsertMrordt(Map<String, Object> saveMap) {
		this.sqlSessionTemplate.insert(statement+"InsertMrordt", saveMap);
	}

	public void InsertMrpurt(Map<String, Object> saveMap) {
		this.sqlSessionTemplate.insert(statement+"InsertMrpurt", saveMap);
	}

	public OrderBorgDto selectOrderBorgs(Map<String, Object> paramMap) {
		return (OrderBorgDto) sqlSessionTemplate.selectOne(this.statement+"selectOrderBorgs", paramMap);
	}
	
	
	public List<OrderDto> selectOrderGoodsList(Map<String, Object> params) {
		return  sqlSessionTemplate.selectList(this.statement+"selectOrderGoodsList", params);
	}

	public Integer selectOrderListCnt(Map<String, Object> params) {
		return (Integer) sqlSessionTemplate.selectOne(this.statement+"selectOrderListCnt", params);
	}

	
	public List<OrderDto> selectOrderList(Map<String, Object> params, int page, int rows) {
		RowBounds rowBounds = new RowBounds((page-1)*rows, rows);
		return  sqlSessionTemplate.selectList(this.statement+"selectOrderList", params, rowBounds);  
	}

	/**
	 *  주문 상세정보를 조회한다.
	 */
	public OrderDto selectOrderDetail(Map<String, Object> params) {
		return (OrderDto) sqlSessionTemplate.selectOne(this.statement+"selectOrderDetail", params);
	}

	/**
	 * 발주접수 상태의 발주정보를 토대로 출하 및 인수완료가 되었는지 여부 조사. 
	 */
	public int selectOrderIsDeli(Map<String, Object> params) {
		return (Integer) sqlSessionTemplate.selectOne(this.statement+"selectOrderIsDeli", params);
	}

	/**
	 * 주문 히스토리 정보를 조회한다
	 */
	
	public List<OrderHistDto> selectOrderHistList(Map<String, Object> params) {
		return  sqlSessionTemplate.selectList(this.statement+"selectOrderHistList", params);  
	}

	public void updateOrderRequest(Map<String, Object> saveMap) {
		this.sqlSessionTemplate.update(statement+"updateOrderRequest", saveMap);
	}

	public void updateOrderRequestCancel(Map<String, Object> saveMap) {
		this.sqlSessionTemplate.update(statement+"updateOrderRequestCancel", saveMap);
	}
	public void updateOrderRequestPurtCancel(Map<String, Object> saveMap) {
		this.sqlSessionTemplate.update(statement+"updateOrderRequestPurtCancel", saveMap);
	}

	public int selectGoodClasCode(Map<String, Object> paramMap) {
		return (Integer) sqlSessionTemplate.selectOne(this.statement+"selectGoodClasCode", paramMap);
	}

	public int selectPastOrderSaleUnitPrice(Map<String, Object> paramMap) {
		return (Integer) sqlSessionTemplate.selectOne(this.statement+"selectPastOrderSaleUnitPrice", paramMap);
	}
	public int selectOrderSaleUnitPrice(Map<String, Object> paramMap) {
		return (Integer) sqlSessionTemplate.selectOne(this.statement+"selectOrderSaleUnitPrice", paramMap);
	}

	
	public List<OrderDto> selectOrderProgressPopList(Map<String, Object> params) {
		return  sqlSessionTemplate.selectList(this.statement+"selectOrderList", params);  
	}

	public int selectPrePay(Map<String, Object> paramMap) {
		return (Integer) sqlSessionTemplate.selectOne(this.statement+"selectPrePay", paramMap);
	}

	public void updateOrderRequestReceive(Map<String, Object> saveMap) {
		this.sqlSessionTemplate.update(statement+"updateOrderRequestReceive", saveMap);
	}

	/** 일반주문에 상품속성이 수탁이나 지정상품 주문일 경우 재고수량 차감 */
	public void updateGoodsStockQuan(Map<String, Object> saveMap) {
		this.sqlSessionTemplate.update(statement+"updateGoodsStockQuan", saveMap);
	}

	/** 현재 재고 수량 조회 */
	public int selectGoodsStockQuan(Map<String, Object> paramMap) {
		return (Integer) sqlSessionTemplate.selectOne(this.statement+"selectGoodsStockQuan", paramMap);
	}

	public void insertMcGoodsVenderHist(Map<String, Object> saveMap) {
		this.sqlSessionTemplate.insert(statement+"insertMcGoodsVenderHist", saveMap);
	}

	
	public List<OrderDto> selectForChkStockQuan(Map<String, Object> paramMap) {
		return  sqlSessionTemplate.selectList(this.statement+"selectForChkStockQuan", paramMap);  
	}

	
	public List<OrderDto> selectGoodsVendorAndDivRate( Map<String, Object> paramMap) {
		return  sqlSessionTemplate.selectList(this.statement+"selectGoodsVendorAndDivRate", paramMap);  
	}

	public Integer selectPurchaseNumber(Map<String, Object> paramMap) {
		return (Integer) sqlSessionTemplate.selectOne(this.statement+"selectPurchaseNumber", paramMap);
	}

	public void InsertMrpurtAutoDivRate(Map<String, Object> saveMap) {
		this.sqlSessionTemplate.insert(statement+"InsertMrpurtAutoDivRate", saveMap);
	}

	public int selectOrderSaleUnitPriceCen(Map<String, Object> saveMap) {
		return (Integer) sqlSessionTemplate.selectOne(this.statement+"selectOrderSaleUnitPriceCen", saveMap);
	}

	public void cenInsertMrordt(Map<String, Object> saveMap) {
		this.sqlSessionTemplate.insert(statement+"cenInsertMrordt", saveMap);
	}

	public void cenInsertMrpurt(Map<String, Object> saveMap) {
		this.sqlSessionTemplate.insert(statement+"cenInsertMrpurt", saveMap);
	}

	
	public HashMap<String, String> selectPastOrderDeliRequDate(Map<String, Object> paramMap) {
		return sqlSessionTemplate.selectOne(this.statement+"selectPastOrderDeliRequDate", paramMap);
	}

	
	public Map<String, Integer> selectOrderResultSearchCnt(Map<String, Object> params) {
		String srcOrderStatusFlag = "".equals((String)params.get("srcOrderStatusFlag")) ? "0" : (String)params.get("srcOrderStatusFlag");
		String srcOrderDateFlag = "".equals((String) params.get("srcOrderDateFlag")) ? "0" : (String)params.get("srcOrderDateFlag");
		if(Integer.parseInt(srcOrderStatusFlag) >= 70 || Integer.parseInt(srcOrderDateFlag) >= 4) {
			return sqlSessionTemplate.selectOne(this.statement+"selectOrderResultSearchCnt2", params);
		} else {
			return sqlSessionTemplate.selectOne(this.statement+"selectOrderResultSearchCnt", params);
		}
	}

	
	public List<OrderDto> selectOrderResultSearchList( Map<String, Object> params, int page, int rows) {
		RowBounds rowBounds = new RowBounds((page-1)*rows, rows);
		String srcOrderStatusFlag = "".equals((String)params.get("srcOrderStatusFlag")) ? "0" : (String)params.get("srcOrderStatusFlag");
		String srcOrderDateFlag = "".equals((String) params.get("srcOrderDateFlag")) ? "0" : (String)params.get("srcOrderDateFlag");
		if(Integer.parseInt(srcOrderStatusFlag) >= 70 || Integer.parseInt(srcOrderDateFlag) >= 4) {
			return  sqlSessionTemplate.selectList(this.statement+"selectOrderResultSearchList2", params, rowBounds);
		} else {
			return  sqlSessionTemplate.selectList(this.statement+"selectOrderResultSearchList", params, rowBounds);
		}
	}

	public List<Map<String, Object>> selectOrderResultSearchListExcel( Map<String, Object> params) {
		String srcOrderStatusFlag = "".equals((String)params.get("srcOrderStatusFlag")) ? "0" : (String)params.get("srcOrderStatusFlag");
		String srcOrderDateFlag = "".equals((String) params.get("srcOrderDateFlag")) ? "0" : (String)params.get("srcOrderDateFlag");
		if(Integer.parseInt(srcOrderStatusFlag) >= 70 || Integer.parseInt(srcOrderDateFlag) >= 4) {
			return  sqlSessionTemplate.selectList(this.statement+"selectOrderResultSearchListExcel2", params);
		} else {
			return  sqlSessionTemplate.selectList(this.statement+"selectOrderResultSearchListExcel", params);
		}
	}

	
	public List<UserDto> selectSupervisorUserInfo(Map<String, Object> searchMap) {
		return sqlSessionTemplate.selectList(this.statement+"selectSupervisorUserInfo", searchMap);
	}

	public void approvalInsertMrordt(Map<String, Object> saveMap) {
		this.sqlSessionTemplate.insert(statement+"approvalInsertMrordt", saveMap);
	}

	public OrderDto selectOrderApprovalInfo(Map<String, Object> saveMap) {
		return (OrderDto) sqlSessionTemplate.selectOne(this.statement+"selectOrderApprovalInfo", saveMap);
	}

	public void updateApprovalMrordt(Map<String, Object> saveMap) {
		this.sqlSessionTemplate.update(statement+"updateApprovalMrordt", saveMap);
	}

	public void updateRejectMrordt(Map<String, Object> saveMap) {
		this.sqlSessionTemplate.update(statement+"updateRejectMrordt", saveMap);
	}

	public Integer selectOrderGoodsCnt(Map<String, Object> params) {
		return (Integer) sqlSessionTemplate.selectOne(this.statement+"selectOrderGoodsCnt", params);
	}

	public Integer selectVenOrderListProgressCnt(Map<String, Object> params) {
		return (Integer) sqlSessionTemplate.selectOne(this.statement+"selectVenOrderListProgressCnt", params);
	}

	
	public List<OrderDto> selectVenOrderListProgress( Map<String, Object> params, int page, int rows) {
		RowBounds rowBounds = new RowBounds((page-1)*rows, rows);
		return  sqlSessionTemplate.selectList(this.statement+"selectVenOrderListProgress", params, rowBounds);  
	}

	
	public List<Map<String, Object>> selectOrderListExcel( Map<String, Object> params) {
		return  sqlSessionTemplate.selectList(this.statement+"selectOrderListExcel", params);
	}

	
	public List<Map<String, Object>> selectWorkInfoNms(String userId) {
		return  sqlSessionTemplate.selectList(this.statement+"selectWorkInfoNms", userId);
	}

	
	public List<UserDto> selectUserInfoListByBranchIdInVendorOrderRequest( Map<String, Object> searchMap) {
		return sqlSessionTemplate.selectList(this.statement+"selectUserInfoListByBranchIdInVendorOrderRequest", searchMap);
	}

	
	public Map<String, Integer> selectOrderListIncludeTotalSumCnt( Map<String, Object> params) {
		return sqlSessionTemplate.selectOne(this.statement+"selectOrderListIncludeTotalSumCnt", params);
	} 

	
	public List<OrderDto> selectOrderListIncludeTotalSum( Map<String, Object> params, int page, int rows) {
		RowBounds rowBounds = new RowBounds((page-1)*rows, rows);
		return  sqlSessionTemplate.selectList(this.statement+"selectOrderListIncludeTotalSum", params,rowBounds);
	}
	public List<OrderDto> selectOrderListIncludeTotalSum( Map<String, Object> params) {
		return  sqlSessionTemplate.selectList(this.statement+"selectOrderListIncludeTotalSum", params);
	}

	public void cenInsertMrordm(Map<String, Object> saveMap) {
		this.sqlSessionTemplate.insert(statement+"cenInsertMrordm", saveMap);
	}

	
	public Map<String, Object> selectGoodsStockInfo(Map<String, Object> paramMap) {
		return sqlSessionTemplate.selectOne(this.statement+"selectGoodsStockInfo", paramMap);
	}

	
	public Map<String, Object> selectGoodsStockInfoByOrde( Map<String, Object> saveMap) {
		return sqlSessionTemplate.selectOne(this.statement+"selectGoodsStockInfoByOrde", saveMap);
	}

	public int selectProductMiniQuantity(String disp_good_id) {
		return sqlSessionTemplate.selectOne(this.statement+"selectProductMiniQuantity", disp_good_id);
	}

	public String orderStatCheck(Map<String, Object> params) {
		return (String)sqlSessionTemplate.selectOne(this.statement+"orderStatCheck", params);
	}


	public int selectVenOrderProgressListCnt(Map<String, Object> params) throws Exception {
		return sqlSessionTemplate.selectOne(this.statement+"selectVenOrderProgressListCnt", params);
	}

	public List<Map<String, Object>> selectVenOrderProgressList(Map<String, Object> params, int page, int rows) throws Exception {
		RowBounds rowBounds = new RowBounds((page-1)*rows, rows);
		return sqlSessionTemplate.selectList(this.statement+"selectVenOrderProgressList", params, rowBounds);
	}

	public List<Map<String, Object>> selectVenOrderProgressDeliList(Map<String, Object> deliMap) throws Exception {
		return sqlSessionTemplate.selectList(this.statement+"selectVenOrderProgressDeliList", deliMap);
	}
	
	/** 공급사 주무이력조회 데이터 조회 */
	public Integer selectVenOrderHistListCnt(Map<String, Object> params) {
		return (Integer) sqlSessionTemplate.selectOne(this.statement+"selectVenOrderHistListCnt", params);
	}
	/** 공급사 주무이력조회 */
	public List<Map<String, Object>> selectVenOrderHistList( Map<String, Object> params, int page, int rows) {
		RowBounds rowBounds = new RowBounds((page-1)*rows, rows);
		return  sqlSessionTemplate.selectList(this.statement+"selectVenOrderHistList", params, rowBounds);  
	}

	public String getIsOrderLimit(String branchid) {
		return sqlSessionTemplate.selectOne(this.statement+"getIsOrderLimit", branchid);
	}
	
	public Map<String, Object> getPrepayBranchStatus(String branchid) {
		return sqlSessionTemplate.selectOne(this.statement+"getPrepayBranchStatus", branchid);
	}
	
	public int getIsDirectorCount(String userid) {
		return sqlSessionTemplate.selectOne(this.statement+"getIsDirectorCount", userid);
	}

	public void deleteCartInfo(Map<String, Object> params) {
		sqlSessionTemplate.delete(this.statement+"deleteCartInfo", params);
	}

	public Map<String, Object> getDispPastRate(Map<String, Object> params) {
		return sqlSessionTemplate.selectOne(this.statement+"getDispPastRate", params);
	}

	/** 주문 전에 상품의 속성정보를 조회함 */
	public Map<String, Object> selectGoodInfoForOrder(Map<String, Object> params) {
		return sqlSessionTemplate.selectOne(this.statement+"selectGoodInfoForOrder", params);
	}

	public Integer selectAppovalProcListCnt(Map<String, Object> params) {
		return (Integer) sqlSessionTemplate.selectOne(this.statement+"selectAppovalProcListCnt", params);
	}

	public List<Map<String,Object>> selectAppovalProcList(Map<String, Object> params, int page, int rows) {
		RowBounds rowBounds = new RowBounds((page-1)*rows, rows);
		return  sqlSessionTemplate.selectList(this.statement+"selectAppovalProcList", params, rowBounds);  
	}

	/** 감독관 사용자의 주문 승인, 반려 */
	public void updateDirectOrdProc(Map<String, Object> procDataMap) {
		this.sqlSessionTemplate.update(statement+"updateDirectOrdProc", procDataMap);
	}

	public Map<String,Object> selectDirectOrdApprPurcRequQan(Map<String, Object> procDataMap) {
		return sqlSessionTemplate.selectOne(this.statement+"selectDirectOrdApprPurcRequQan", procDataMap);
	}

	public void updateMrordtForOrderRequest(Map<String, Object> params) {
		this.sqlSessionTemplate.update(statement+"updateMrordtForOrderRequest",params);
	}

	public Map<String,Object> selectMrordtInfo(Map<String, Object> procDataMap) {
		return sqlSessionTemplate.selectOne(this.statement+"selectMrordtInfo", procDataMap);
	}

	public Map<String,Object> selectBuyBorgInfo(String branchid) {
		return sqlSessionTemplate.selectOne(this.statement+"selectBuyBorgInfo", branchid);
	}

	/** 취소할 추가상품 정보를 조회함. */
	@SuppressWarnings("unchecked")
	public Map<String, Object> selectCancelAddProdInfo( Map<String, Object> saveMap) {
		return (Map<String, Object>) sqlSessionTemplate.selectOne(this.statement+"selectCancelAddProdInfo", saveMap);
	}

	public Map<String, Object> selectApprovalOrdForAddProd( Map<String, Object> addProdOrdMap) {
		return sqlSessionTemplate.selectOne(this.statement+"selectApprovalOrdForAddProd", addProdOrdMap);
	}

	public Map<String, Object> selectDirectOrdProcStatValid(Map<String, Object> procDataMap) {
		return sqlSessionTemplate.selectOne(this.statement+"selectDirectOrdProcStatValid", procDataMap);
	}

	public Map<String, Object> getAmouInfo(String branchid) {
		return sqlSessionTemplate.selectOne(this.statement+"getAmouInfo", branchid);
	}

	@SuppressWarnings("unchecked")
	public Map<String, Integer> selectOrderResultSearchJQGridAdmCnt( ModelMap modelMap) {
		return (Map<String, Integer>) sqlSessionTemplate.selectOne(this.statement+"orderResultSearchJQGridAdmCount", modelMap);
	}

	public List<Map<String, Object>> selectOrderResultSearchJQGridAdmList( ModelMap modelMap) {
		RowBounds    rowBounds = (RowBounds) modelMap.get("rowBounds");
		return  sqlSessionTemplate.selectList(this.statement+"orderResultSearchJQGridAdmList", modelMap, rowBounds);  
	}

	
	
	
	public Integer selectVODListCnt(Map<String, Object> params) {
		return (Integer) sqlSessionTemplate.selectOne(this.statement+"selectVODListCnt", params);
	}

	public List<Map<String, Object>> selectVODList(Map<String, Object> params, int page, int rows) {
		RowBounds rowBounds = new RowBounds((page-1)*rows, rows);
		return  sqlSessionTemplate.selectList(this.statement+"selectVODList", params, rowBounds);  
	}

	public List<Map<String, Object>> selectOrderCancelUser(Map<String, Object> addProdInfo)  throws Exception{
		return sqlSessionTemplate.selectList(this.statement+"selectOrderCancelUser", addProdInfo);
	}
}
