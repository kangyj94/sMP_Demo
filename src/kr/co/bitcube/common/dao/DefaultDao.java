package kr.co.bitcube.common.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class DefaultDao {

	private final String statement = "common.default.";
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	
	/**
	 * 운영사 - 전체 공지사항 리스트를 조회하여 반환하는 메소드
	 */
	
	public List<Map<String, Object>> selectAdminNoticeList(Map<String, Object> params) {
		return  sqlSessionTemplate.selectList(this.statement+"selectAdminNoticeList", params);
	}
	
	/**
	 * 운영사 - 고객사상품등록요청 DB조회후 리턴시켜주는 메소드
	 */
	
	public List<Map<String, Object>> selectAdminNewProductRequestList(Map<String, Object> params) {
		return  sqlSessionTemplate.selectList(this.statement+"selectAdminNewProductRequestList", params);
	}
	
	/**
	 * 운영사 - 진행중 또는 낙찰대기 입찰 DB조회후 리턴시켜주는 메소드
	 */
	
	public List<Map<String, Object>> selectAdminNewProductBidList(Map<String, Object> params) {
		return  sqlSessionTemplate.selectList(this.statement+"selectAdminNewProductBidList", params);
	}
	
	/**
	 * 운영사 - 물량배분주문 DB조회후 리턴시켜주는 메소드
	 */
	
	public List<Map<String, Object>> selectAdminVolumeOrderList(Map<String, Object> params) {
		return  sqlSessionTemplate.selectList(this.statement+"selectAdminVolumeOrderList", params);
	}
	
	/**
	 * 운영사 - 1일이상 미처리된 발주접수 대상 DB조회후 리턴시켜주는 메소드
	 */
	
	public List<Map<String, Object>> selectAdminOrderReceivedList(Map<String, Object> params) {
		return  sqlSessionTemplate.selectList(this.statement+"selectAdminOrderReceivedList", params);
	}
	
	/**
	 * 운영사 - 납품요청일이 지난 출하대상 DB조회후 리턴시켜주는 메소드
	 */
	
	public List<Map<String, Object>> selectAdminLastShipmentTargetList(Map<String, Object> params) {
		return  sqlSessionTemplate.selectList(this.statement+"selectAdminLastShipmentTargetList", params);
	}
	
	/**
	 * 운영사 - 3일 이상 미처리된 인수대상 DB조회후 리턴시켜주는 메소드
	 */
	
	public List<Map<String, Object>> selectAdminTakeoverTargetList(Map<String, Object> params) {
		return  sqlSessionTemplate.selectList(this.statement+"selectAdminTakeoverTargetList", params);
	}
	
	/**
	 * 운영사 - 전월실적 미처리된 인수대상 DB조회후 리턴시켜주는 메소드
	 */
	
	public List<Map<String, Object>> selectAdminLastmonthPerformanceList(Map<String, Object> params) {
		return  sqlSessionTemplate.selectList(this.statement+"selectAdminLastmonthPerformanceList", params);
	}
	
	/**
	 * 운영사 - 채권관리업체 미처리된 인수대상 DB조회후 리턴시켜주는 메소드
	 */
	
	public List<Map<String, Object>> selectAdminBondsManagementCompList(Map<String, Object> params) {
		return  sqlSessionTemplate.selectList(this.statement+"selectAdminBondsManagementCompList", params);
	}
	
	/**
	 * 운영사 - 미수채권 미처리된 인수대상 DB조회후 리턴시켜주는 메소드
	 */
	
	public List<Map<String, Object>> selectAdminAccruedReceivableList(Map<String, Object> params) {
		return  sqlSessionTemplate.selectList(this.statement+"selectAdminAccruedReceivableList", params);
	}
	
	public List<Map<String, Object>> selectAdminDebtReceivableList() {
		return  sqlSessionTemplate.selectList(this.statement+"selectAdminDebtReceivableList");
	}
	
	/**
	 * 운영사 - 당월예상실적 미처리된 인수대상 DB조회후 리턴시켜주는 메소드
	 */
	
	public List<Map<String, Object>> selectAdminForecastPerformanceList(Map<String, Object> params) {
		return  sqlSessionTemplate.selectList(this.statement+"selectAdminForecastPerformanceList", params);
//		return  sqlSessionTemplate.selectList(this.statement+"selectAdminForecastPerformanceList2", params);
	}
	
	/**
	 * 운영사 - 채권관리 사업장 DB조회후 리턴시켜주는 메소드
	 */
	
	public List<Map<String, Object>> selectAdminManagementOrganList(Map<String, Object> params) {
		return  sqlSessionTemplate.selectList(this.statement+"selectAdminManagementOrganList", params);
	}
	/**
	 * 운영사 - 공사유형별 사업장 DB조회후 리턴시켜주는 메소드
	 */
	
	public List<Map<String, Object>> selectWorkManagementOrganList(Map<String, Object> params) {
		return  sqlSessionTemplate.selectList(this.statement+"selectWorkManagementOrganList", params);
	}
	
	/**
	 * 운영사 - 실적차트 DB조회후 리턴시켜주는 메소드
	 */
	
	public List<Map<String, Object>> selectAdminPerformanceChart(Map<String, Object> params) {
		return  sqlSessionTemplate.selectList(this.statement+"selectAdminPerformanceChart", params);
	}
	
	/**
	 * 공급사 - 전체 공지사항 리스트를 조회하여 반환하는 메소드
	 */
	
	public List<Map<String, Object>> selectVenNoticeList(Map<String, Object> params) {
		return  sqlSessionTemplate.selectList(this.statement+"selectVenNoticeList", params);
	}
	
	/**
	 * 공급사 - 진행중 입찰 리스트를 조회하여 반환하는 메소드
	 */
	
	public List<Map<String, Object>> selectVenProgressBidList(Map<String, Object> params) {
		return  sqlSessionTemplate.selectList(this.statement+"selectVenProgressBidList", params);
	}
	
	/**
	 * 공급사 - 진행중 입찰 리스트를 조회하여 반환하는 메소드
	 */
	
	public List<Map<String, Object>> selectVenProductRegReqList(Map<String, Object> params) {
		return  sqlSessionTemplate.selectList(this.statement+"selectVenProductRegReqList", params);
	}
	
	/**
	 * 공급사 - 발주접수 대상 리스트를 조회하여 반환하는 메소드
	 */
	
	public List<Map<String, Object>> selectVenOrderTargetList(Map<String, Object> params) {
		return  sqlSessionTemplate.selectList(this.statement+"selectVenOrderTargetList", params);
	}
	
	/**
	 * 공급사 - 출하 대상 리스트를 조회하여 반환하는 메소드
	 */
	
	public List<Map<String, Object>> selectVenShipTargetList(Map<String, Object> params) {
		return  sqlSessionTemplate.selectList(this.statement+"selectVenShipTargetList", params);
	}
	
	/**
	 * 공급사 - 배송완료 대상 리스트를 조회하여 반환하는 메소드
	 */
	
	public List<Map<String, Object>> selectVenShippingDestiList(Map<String, Object> params) {
		return  sqlSessionTemplate.selectList(this.statement+"selectVenShippingDestiList", params);
	}
	
	/**
	 * 공급사 - 반품요청 대상 리스트를 조회하여 반환하는 메소드
	 */
	
	public List<Map<String, Object>> selectVenReturnRequestList(Map<String, Object> params) {
		return  sqlSessionTemplate.selectList(this.statement+"selectVenReturnRequestList", params);
	}
	
	/**
	 * 물류센터 - picking 등록 대상 리스트를 조회하여 반환하는 메소드
	 */
	
	public List<Map<String, Object>> selectCenPickingRegList(Map<String, Object> params) {
		return  sqlSessionTemplate.selectList(this.statement+"selectCenPickingRegList", params);
	}
	
	/**
	 * 물류센터 - 출고확정/인수증출력 리스트를 조회하여 반환하는 메소드
	 */
	
	public List<Map<String, Object>> selectCenFactoryConList(Map<String, Object> params) {
		return  sqlSessionTemplate.selectList(this.statement+"selectCenFactoryConList", params);
	}
	
	/**
	 * 물류센터 -  송장입력/배송완료 리스트를 조회하여 반환하는 메소드
	 */
	
	public List<Map<String, Object>> selectCenInvoiceShippingList(Map<String, Object> params) {
		return  sqlSessionTemplate.selectList(this.statement+"selectCenInvoiceShippingList", params);
	}
	
	/**
	 * 물류센터 - 수탁발주내역 리스트를 조회하여 반환하는 메소드
	 */
	
	public List<Map<String, Object>> selectCenEntrustOrderList(Map<String, Object> params) {
		return  sqlSessionTemplate.selectList(this.statement+"selectCenEntrustOrderList", params);
	}
	
	/**
	 * 물류센터 - 수탁입고 대상 리스트를 조회하여 반환하는 메소드
	 */
	
	public List<Map<String, Object>> selectCenEntrustStockList(Map<String, Object> params) {
		return  sqlSessionTemplate.selectList(this.statement+"selectCenEntrustStockList", params);
	}
	
	/**
	 * 물류센터 - 미재고 수탁상품 리스트를 조회하여 반환하는 메소드
	 */
	
	public List<Map<String, Object>> selectCenProductStockList(Map<String, Object> params) {
		return  sqlSessionTemplate.selectList(this.statement+"selectCenProductStockList", params);
	}
	
	/**
	 * 고객사 - 공지사항 리스트를 조회하여 반환하는 메소드
	 */
	
	public List<Map<String, Object>> selectBuyNoticeList(Map<String, Object> params) {
		return  sqlSessionTemplate.selectList(this.statement+"selectBuyNoticeList", params);
	}
	
	/**
	 * 고객사 - 마이카테고리를 조회하여 반환하는 메소드
	 */
	
	public List<Map<String, Object>> selectBuyMyCategoryList(Map<String, Object> params) {
		return  sqlSessionTemplate.selectList(this.statement+"selectBuyMyCategoryList", params);
	}
	
	/**
	 * 고객사 - 신규품목요청내역 리스트 조회하여 반환하는 메소드
	 */
	
	public List<Map<String, Object>> selectBuyNewItemStatusList(Map<String, Object> params) {
		return  sqlSessionTemplate.selectList(this.statement+"selectBuyNewItemStatusList", params);
	}
	
	/**
	 * 고객사 - 관심상품 리스트 조회하여 반환하는 메소드
	 */
	
	public List<Map<String, Object>> selectBuyWishlistItemList(Map<String, Object> params) {
		return  sqlSessionTemplate.selectList(this.statement+"selectBuyWishlistItemList", params);
	}
	
	/**
	 * 고객사 - 발주대기 리스트 조회하여 반환하는 메소드
	 */
	
	public Map<String, Object> selectBuyOrderConditionListCnt(Map<String, Object> params) {
		return sqlSessionTemplate.selectOne(this.statement+"selectBuyOrderConditionListCnt", params);
	}
	
	/**
	 * 고객사 - 주문현황 차트조회
	 */
	
	public List<Map<String, Object>> buyChartForClientOrder(Map<String, Object> params) {
		return  sqlSessionTemplate.selectList(this.statement+"buyChartForClientOrder", params);
	}

	/**
	 * 고객사 - 사업장별 주문현황
	 */
	
	public List<Map<String, Object>> buyChartForBranchOrder(Map<String, Object> params) {
		return  sqlSessionTemplate.selectList(this.statement+"buyChartForBranchOrder", params);
	}
	
	/**
	 * 고객사 - 주문현황 DB조회후 리턴시켜주는 메소드
	 */
	
	public List<Map<String, Object>> selectBuyOrderStatusList(Map<String, Object> params) {
		return  sqlSessionTemplate.selectList(this.statement+"selectBuyOrderStatusList", params);
	}

	/** * 관리하는 조직의 숫자를 리턴한다. */
	public int selectManageCnt(Map<String, Object> params) {
		return (Integer) sqlSessionTemplate.selectOne(this.statement+"selectManageCnt", params);
	}

	public List<Map<String, Object>> selectNoneBorgAdjustList(Map<String, Object> params) {
		return sqlSessionTemplate.selectList(this.statement+"selectNoneBorgAdjustList", params);
	}
}

