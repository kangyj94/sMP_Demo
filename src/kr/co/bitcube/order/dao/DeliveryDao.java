package kr.co.bitcube.order.dao;

import java.util.List;
import java.util.Map;

import kr.co.bitcube.order.dto.OrderDeliDto;
import kr.co.bitcube.order.dto.OrderDto;
import kr.co.bitcube.order.dto.OrderReceiveDto;

import org.apache.ibatis.session.RowBounds;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class DeliveryDao {
	private final String statement = "order.delivery.";
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	
	public List<OrderDeliDto> selectDeliveryListForOrderDetail( Map<String, Object> params) {
		return  sqlSessionTemplate.selectList(this.statement+"selectDeliveryListForOrderDetail", params);
	}

	public void updateMracpt(Map<String, Object> saveMap) {
		this.sqlSessionTemplate.update(statement+"updateMracpt", saveMap);
	}
	
	public void InsertMrordtHist(Map<String, Object> saveMap) {
		this.sqlSessionTemplate.insert(statement+"InsertMrordtHist", saveMap);
	}

	public int selectDeliveryListCnt(Map<String, Object> params) {
		return (Integer) sqlSessionTemplate.selectOne(this.statement+"selectDeliveryListCnt", params);
	}

	
	public List<OrderDeliDto> selectDeliveryList(Map<String, Object> params, int page, int rows) {
		RowBounds rowBounds = new RowBounds((page-1)*rows, rows);
		return  sqlSessionTemplate.selectList(this.statement+"selectDeliveryList", params, rowBounds);
	}

	public int selectDeliIdenNumb(Map<String, Object> saveMap) {
		return (Integer) sqlSessionTemplate.selectOne(this.statement+"selectDeliIdenNumb", saveMap);
	}
	public void insertDeliveryInfo(Map<String, Object> saveMap) {
		this.sqlSessionTemplate.insert(statement+"insertDeliveryInfo", saveMap);
	}
	public int selectDeliProdQuan(Map<String, Object> saveMap) {
		return (Integer) sqlSessionTemplate.selectOne(this.statement+"selectDeliProdQuan", saveMap);
	}
	public void updateMrpurt(Map<String, Object> saveMap) {
		this.sqlSessionTemplate.update(statement+"updateMrpurt", saveMap);
	}
	
	/**
	 * 인수확인 리스트의 대상 데이터 갯수 리턴
	 * @param params
	 * @return
	 */
	public Integer selectReceiveListCnt(Map<String, Object> params) {
		return (Integer) sqlSessionTemplate.selectOne(this.statement+"selectReceiveListCnt", params);
	}
	/**
	 * 인수확인 리스트의 대상 데이터 리턴
	 * @param params
	 * @return
	 */
	
	public List<OrderDeliDto> selectReceiveList(Map<String, Object> params, int page, int rows) {
		RowBounds rowBounds = new RowBounds((page-1)*rows, rows);
		return  sqlSessionTemplate.selectList(this.statement+"selectReceiveList", params, rowBounds);  
	}

	public Integer selectDeliCompleteListCnt(Map<String, Object> params) {
		return (Integer) sqlSessionTemplate.selectOne(this.statement+"selectDeliCompleteListCnt", params);
	}

	
	public List<OrderDeliDto> selectDeliCompleteList( Map<String, Object> params, int page, int rows) {
		RowBounds rowBounds = new RowBounds((page-1)*rows, rows);
		return  sqlSessionTemplate.selectList(this.statement+"selectDeliCompleteList", params, rowBounds);  
	}

	public OrderDeliDto selectOrdeTypeClas(Map<String, Object> saveMap) {
		return (OrderDeliDto) sqlSessionTemplate.selectOne(this.statement+"selectOrdeTypeClas",saveMap);  
	}

	public void insertMrordtList(Map<String, Object> saveMap) {
		this.sqlSessionTemplate.insert(statement+"insertMrordtList", saveMap);
	}

	public int selectReceIdenNumb(Map<String, Object> saveMap) {
		return (Integer) sqlSessionTemplate.selectOne(this.statement+"selectReceIdenNumb", saveMap);
	}
	
	/**
	 * 선발주인수처리 리스트의 대상 데이터 갯수 리턴
	 * @param params
	 * @return
	 */
	public Integer selectFirstPurchaseHandleListCnt(Map<String, Object> params) {
		return (Integer) sqlSessionTemplate.selectOne(this.statement+"selectFirstPurchaseHandleListCnt", params);
	}
	/**
	 * 선발주인수처리 리스트의 대상 데이터 리턴
	 * @param params
	 * @return
	 */
	
	public List<OrderDeliDto> selectFirstPurchaseHandleList(Map<String, Object> params, int page, int rows) {
		RowBounds rowBounds = new RowBounds((page-1)*rows, rows);
		List<OrderDeliDto> list = null;
		if (page == -1 && rows == -1) {
			list =  sqlSessionTemplate.selectList(this.statement+"selectFirstPurchaseHandleList", params);
		} else {
			list =  sqlSessionTemplate.selectList(this.statement+"selectFirstPurchaseHandleList", params, rowBounds);
		}
		return list; 
	}
	
	/**
	 * 선발주 실 인수처리-내역확인 리스트의 대상 데이터 리턴
	 * @param params
	 * @return
	 */
	
	public List<OrderReceiveDto> selectFirstPurchaseHandlePopList(Map<String, Object> params) {
		return sqlSessionTemplate.selectList(this.statement+"selectFirstPurchaseHandlePopList", params);  
	}

	public int selectReceProdQuan(Map<String, Object> saveMap) {
		return (Integer) sqlSessionTemplate.selectOne(this.statement+"selectReceProdQuan", saveMap);
	}

	/** 물류센터 인수처리 과정 관련 Dao method */
	public int selectGoodsStockQuan(Map<String, Object> saveMap) {
		return (Integer) sqlSessionTemplate.selectOne(this.statement+"selectGoodsStockQuan", saveMap);
	}
	public void updateGoodsStockQuan(Map<String, Object> saveMap) {
		this.sqlSessionTemplate.update(statement+"updateGoodsStockQuan", saveMap);
	}
	public void insertMcGoodsVenderHist(Map<String, Object> saveMap) {
		this.sqlSessionTemplate.insert(statement+"insertMcGoodsVenderHist", saveMap);
	}

	
	public List<OrderReceiveDto> selectDeliShowHist(Map<String, Object> params) {
		return sqlSessionTemplate.selectList(this.statement+"selectDeliShowHist", params);
	}

	public void insertRealDeliveryInfo(Map<String, Object> saveMap) {
		this.sqlSessionTemplate.insert(statement+"insertRealDeliveryInfo", saveMap);
	}

	public void deleteRealDeliveryInfo(Map<String, Object> saveMap) {
		this.sqlSessionTemplate.delete(statement+"deleteRealDeliveryInfo", saveMap);
	}

	public void insertMrordtListForFirstOrder(Map<String, Object> saveMap) {
		this.sqlSessionTemplate.update(statement+"insertMrordtListForFirstOrder", saveMap);
	}

	public void updateReceiptImgFile(Map<String, Object> saveMap) {
		this.sqlSessionTemplate.update(statement+"updateReceiptImgFile", saveMap);
	}

	/** 주문번호 , 주문차수 , 발주차수로 조회한 발주수량 - 출하수량 */
	public int selectDeliPossibleQuan(Map<String, Object> tempMap) {
		return (Integer) sqlSessionTemplate.selectOne(this.statement+"selectDeliPossibleQuan", tempMap);
	}

	
	public  List<Map<String, Object>> selectDeliveryListExcelView( Map<String, Object> params) {
		return sqlSessionTemplate.selectList(this.statement+"selectDeliveryListExcelView", params);
	}

	
	public List<Map<String, Object>> selectDeliCompleteListExcelView( Map<String, Object> params) {
		return sqlSessionTemplate.selectList(this.statement+"selectDeliCompleteListExcelView", params);
	}
	
	
	public List<Map<String, Object>> selectReceiveListExcelView(Map<String, Object> params) {
		return sqlSessionTemplate.selectList(this.statement+"selectReceiveListExcelView", params);  
	}

	public Map<String, Object> selectOrderNumSmsInfo(Map<String, Object> saveMap) {
		return sqlSessionTemplate.selectOne(this.statement+"selectOrderNumSmsInfo", saveMap);
	}

	public Integer selectDeliProcListCnt(Map<String, Object> params) {
		return (Integer) sqlSessionTemplate.selectOne(this.statement+"selectDeliProcListCnt", params);
	}

	public List<OrderDeliDto> selectDeliProcList(Map<String, Object> params, int page, int rows) {
		RowBounds rowBounds = new RowBounds((page-1)*rows, rows);
		return  sqlSessionTemplate.selectList(this.statement+"selectDeliProcList", params, rowBounds);  
	}

	public void insertDeliProc(Map<String, Object> saveMap) {
		this.sqlSessionTemplate.insert(statement+"insertDeliProc", saveMap);
	}

	public List<Map<String, Object>> selectDeliProcListExcelView( Map<String, Object> params) {
		return sqlSessionTemplate.selectList(this.statement+"selectDeliProcListExcelView", params);
	}
	
	public int selectProdReceiveListCnt(Map<String, Object> params) {
		return (Integer) sqlSessionTemplate.selectOne(this.statement+"selectProdReceiveListCnt", params);
	}

	public List<OrderDeliDto> selectProdReceiveList(Map<String, Object> params, int page, int rows) {
		RowBounds rowBounds = new RowBounds((page-1)*rows, rows);
		return  sqlSessionTemplate.selectList(this.statement+"selectProdReceiveList", params, rowBounds);  
	}

	public Map<String, Object> selectClientReceiveDeliInfoPop( Map<String, Object> params) {
		return sqlSessionTemplate.selectOne(this.statement+"selectClientReceiveDeliInfoPop", params);
	}

	public int selectClientReceHistListCnt(Map<String, Object> params) {
		return (Integer) sqlSessionTemplate.selectOne(this.statement+"selectClientReceHistListCnt", params);
	}

	public List<Map<String, Object>> selectClientReceHistList( Map<String, Object> params, int page, int rows) {
		RowBounds rowBounds = new RowBounds((page-1)*rows, rows);
		return  sqlSessionTemplate.selectList(this.statement+"selectClientReceHistList", params, rowBounds);  
	}

	public int selectVenOrdReceStandByListCnt(Map<String, Object> params) {
		return (Integer) sqlSessionTemplate.selectOne(this.statement+"selectVenOrdReceStandByListCnt", params);
	}

	public List<Map<String, Object>> selectVenOrdReceStandByList( Map<String, Object> params, int page, int rows) {
		RowBounds rowBounds = new RowBounds((page-1)*rows, rows);
		return  sqlSessionTemplate.selectList(this.statement+"selectVenOrdReceStandByList", params, rowBounds);
	}

	public Map<String, Object> selectMrpurtInfo(Map<String, Object> param) {
		return  sqlSessionTemplate.selectOne(this.statement+"selectMrpurtInfo", param);
	}

	public void insertNewMrpurtInfo(Map<String, Object> saveMap) {
		this.sqlSessionTemplate.insert(statement+"insertNewMrpurtInfo", saveMap);
	}

	public int selectVenDeliProcListCnt(Map<String, Object> params) {
		return (Integer) sqlSessionTemplate.selectOne(this.statement+"selectVenDeliProcListCnt", params);
	}

	public List<OrderDeliDto> selectVenDeliProcList(Map<String, Object> params, int page, int rows) {
		RowBounds rowBounds = new RowBounds((page-1)*rows, rows);
		return  sqlSessionTemplate.selectList(this.statement+"selectVenDeliProcList", params, rowBounds);  
	}

	public Map<String, Object> selectVenReceiveDeliInfoPop( Map<String, Object> params) {
		return  sqlSessionTemplate.selectOne(this.statement+"selectVenReceiveDeliInfoPop", params);
	}

	public int selectVenReceHistListCnt(Map<String, Object> params) {
		return (Integer) sqlSessionTemplate.selectOne(this.statement+"selectVenReceHistListCnt", params);
	}

	public List<Map<String, Object>> selectVenReceHistList( Map<String, Object> params, int page, int rows) {
		RowBounds rowBounds = new RowBounds((page-1)*rows, rows);
		return  sqlSessionTemplate.selectList(this.statement+"selectVenReceHistList", params, rowBounds);  
	}

	@SuppressWarnings("unchecked")
	public Map<String, Object> selectAddProduct(Map<String, Object> params) {
		return  (Map<String, Object>) sqlSessionTemplate.selectOne(this.statement+"selectAddProduct", params);  
	}

	public Map<String, Object> selectVenReceiveDeliInfoPopForAddProd( Map<String, Object> params) {
		return  sqlSessionTemplate.selectOne(this.statement+"selectVenReceiveDeliInfoPopForAddProd", params);
	}

	public Map<String, Object> selectAddProdSearchForDeli(Map<String, Object> param) {
		return  sqlSessionTemplate.selectOne(this.statement+"selectAddProdSearchForDeli", param);
	}

	public void updateVenAddProdReceive(Map<String, Object> paramMap) {
		this.sqlSessionTemplate.update(statement+"updateVenAddProdReceive", paramMap);
	}

	/* 고객사 상품 인수 관련 부분 시작 */
	public int selectBuyProdReceiveListCnt(Map<String, Object> params) {
		return (Integer) sqlSessionTemplate.selectOne(this.statement+"selectBuyProdReceiveListCnt", params);
	}
	public List<OrderDeliDto> selectBuyProdReceiveList( Map<String, Object> params, int page, int rows) {
		RowBounds rowBounds = new RowBounds((page-1)*rows, rows);
		return  sqlSessionTemplate.selectList(this.statement+"selectBuyProdReceiveList", params, rowBounds);  
	}
	public List<OrderDeliDto> selectBuyProdReceiveList( Map<String, Object> params) {
		return  sqlSessionTemplate.selectList(this.statement+"selectBuyProdReceiveList", params);  
	}
	@SuppressWarnings("unchecked")
	public Map<String, Object> selectBuyAddProdOrde(Map<String, Object> tmpMap) {
		return (Map<String, Object>) sqlSessionTemplate.selectOne(this.statement+"selectBuyAddProdOrde", tmpMap);
	}
	/* 고객사 상품 인수 관련 부분 끝 */

	public Integer selectReceiveListCntNew(Map<String, Object> params) {
		return (Integer) sqlSessionTemplate.selectOne(this.statement+"selectReceiveListCntNew", params);
	}

	public List<OrderDeliDto> selectReceiveListNew(Map<String, Object> params, int page, int rows) {
		RowBounds rowBounds = new RowBounds((page-1)*rows, rows);
		return  sqlSessionTemplate.selectList(this.statement+"selectReceiveListNew", params, rowBounds);  
	}

	/** 인수대상 추가상품 조회 */
	@SuppressWarnings("unchecked")
	public Map<String, Object> addProdSearchForRece(Map<String, Object> paramMap) {
		return (Map<String, Object>) sqlSessionTemplate.selectOne(this.statement+"addProdSearchForRece", paramMap);
	}

	public void updateVenPurcPrintBtn(Map<String, Object> saveMap) {
		this.sqlSessionTemplate.update(statement+"updateVenPurcPrintBtn", saveMap);
	}

	public void updateInvoInfo(Map<String, Object> saveMap) {
		this.sqlSessionTemplate.update(statement+"updateInvoInfo", saveMap);
	}

	@SuppressWarnings("unchecked")
	public Map<String, Object> selectDeliInfoForTempDeliSave( Map<String, Object> saveParamMap) {
		return (Map<String, Object>) sqlSessionTemplate.selectOne(this.statement+"selectDeliInfoForTempDeliSave", saveParamMap);
	}

	public void updateDeliInfoForTempDeliSave(Map<String, Object> updateMap) {
		this.sqlSessionTemplate.update(statement+"updateDeliInfoForTempDeliSave", updateMap);
	}

	public int selectMrpurtKeyValue(Map<String, Object> tempParamater) {
		return (Integer) sqlSessionTemplate.selectOne(this.statement+"selectMrpurtKeyValue", tempParamater);
	}

	public void insertDeliInfoForTempDeliSave(Map<String, Object> insertMap) {
		this.sqlSessionTemplate.insert(statement+"insertDeliInfoForTempDeliSave", insertMap);
	}


}
