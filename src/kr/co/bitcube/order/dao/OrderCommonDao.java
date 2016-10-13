package kr.co.bitcube.order.dao;

import java.util.List;
import java.util.Map;

import kr.co.bitcube.order.dto.OrderHistDto;
import kr.co.bitcube.organ.dto.SmpUsersDto;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class OrderCommonDao {
	private final String statement = "order.orderCommon.";
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	
	/**
	 * 주문의 히스토리 상태를 저장한다
	 */
	public void insertMrordtHist(Map<String, Object> histSaveMap) {
		this.sqlSessionTemplate.insert(statement+"insertMrordtHist", histSaveMap);
	}

	public OrderHistDto selectOrderChangeMessage(Map<String, Object> histSaveMap) {
		return (OrderHistDto) sqlSessionTemplate.selectOne(this.statement+"selectOrderChangeMessage", histSaveMap);
	}
	public List<SmpUsersDto> selectWorkUserInfo() {
		return  sqlSessionTemplate.selectList(this.statement+"selectWorkUserInfo");
	}

	public void insertMcgoodvendorStockQuan(Map<String, Object> stockSaveMap) {
		sqlSessionTemplate.insert(this.statement+"insertMcgoodvendorStockQuan",stockSaveMap);
	}

	public void updateMcgoodvendorQuan(Map<String, Object> stockSaveMap) {
		sqlSessionTemplate.update(this.statement+"updateMcgoodvendorQuan",stockSaveMap);
	}

	@SuppressWarnings("unchecked")
	public Map<String, Object> selectStockOrderInfo(Map<String, Object> saveMap) {
		return (Map<String, Object>) sqlSessionTemplate.selectOne(this.statement+"selectStockOrderInfo", saveMap);  
	}

	public List<SmpUsersDto> selectProductManager() {
		return sqlSessionTemplate.selectList(this.statement+"selectProductManager");
	}

	/** 발주 테이블에 있는 상품코드와 공급사코드를 조회하여 리턴함.
	 * @param params */
	@SuppressWarnings("unchecked")
	public Map<String, Object> selectGoodVendorInfoForStock(Map<String, Object> params) {
		return (Map<String, Object>) sqlSessionTemplate.selectOne(this.statement+"selectGoodVendorInfoForStock", params);  
	}

	/** 상품 공급사 테이블의 재고수량 차감, 누적 처리 */
	public void updateGoodVendorInventoryQuan(Map<String, Object> params) {
		this.sqlSessionTemplate.update(statement+"updateGoodVendorInventoryQuan", params);
	}

	/** * 재고수량 히스토리 저장 */
	public void insertGoodVendorInventoryQuanHist(Map<String, Object> params) {
		sqlSessionTemplate.insert(this.statement+"insertGoodVendorInventoryQuanHist",params);
	}
}
