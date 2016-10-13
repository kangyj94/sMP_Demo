package kr.co.bitcube.common.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import kr.co.bitcube.board.dto.BoardDto;
import kr.co.bitcube.board.service.BoardSvc;
import kr.co.bitcube.common.dao.DefaultDao;
import kr.co.bitcube.common.dao.GeneralDao;
import kr.co.bitcube.common.dto.LoginUserDto;
import kr.co.bitcube.common.utils.CommonUtils;
import kr.co.bitcube.organ.dto.SmpBranchsDto;

import org.apache.ibatis.session.RowBounds;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.ui.ModelMap;

@Service
public class DefaultSvc {
	@SuppressWarnings("unused")
	private Logger logger = Logger.getLogger(getClass());

	@Autowired
	private BoardSvc boardSvc;
	
	@Autowired
	private DefaultDao defaultDao;
	
	@Autowired
	private GeneralDao generalDao;

	/**
	 * 운영사 - 전체 공지사항 리스트를 조회하여 반환하는 메소드
	 */
	public List<Map<String, Object>> getAdminNoticeList(Map<String, Object> params) {
		return defaultDao.selectAdminNoticeList(params);
	}
	
	/**
	 * 운영사 - 고객사상품등록요청 DB조회후 리턴시켜주는 메소드
	 */
	public List<Map<String, Object>> getAdminNewProductRequestList(Map<String, Object> params) {
		return defaultDao.selectAdminNewProductRequestList(params);
	}
	
	/**
	 * 운영사 - 진행중 또는 낙찰대기 입찰 DB조회후 리턴시켜주는 메소드
	 */
	public List<Map<String, Object>> getAdminNewProductBidList(Map<String, Object> params) {
		return defaultDao.selectAdminNewProductBidList(params);
	}
	
	/**
	 * 운영사 - 물량배분주문 DB조회후 리턴시켜주는 메소드
	 */
	public List<Map<String, Object>> getAdminVolumeOrderList(Map<String, Object> params) {
		if(0 < defaultDao.selectManageCnt(params)) params.put("isAllSearch","true"); 
		return defaultDao.selectAdminVolumeOrderList(params);
	}
	
	/**
	 * 운영사 -  1일이상 미처리된 발주접수 대상 DB조회후 리턴시켜주는 메소드
	 */
	public List<Map<String, Object>> getAdminOrderReceivedList(Map<String, Object> params) {
		if(0 < defaultDao.selectManageCnt(params)) params.put("isAllSearch","true"); 
		return defaultDao.selectAdminOrderReceivedList(params);
	}
	
	/**
	 * 운영사 -  납품요청일이 지난 출하대상 DB조회후 리턴시켜주는 메소드
	 */
	public List<Map<String, Object>> getAdminLastShipmentTargetList(Map<String, Object> params) {
		if(0 < defaultDao.selectManageCnt(params)) params.put("isAllSearch","true"); 
		return defaultDao.selectAdminLastShipmentTargetList(params);
	}
	
	/**
	 * 운영사 -  3일 이상 미처리된 인수대상 DB조회후 리턴시켜주는 메소드
	 */
	public List<Map<String, Object>> getAdminTakeoverTargetList(Map<String, Object> params) {
		if(0 < defaultDao.selectManageCnt(params)) params.put("isAllSearch","true"); 
		return defaultDao.selectAdminTakeoverTargetList(params);
	}
	
	/**
	 * 운영사 -  전월실적 DB조회후 리턴시켜주는 메소드
	 */
	public List<Map<String, Object>> getAdminLastmonthPerformanceList(Map<String, Object> params) {
		return defaultDao.selectAdminLastmonthPerformanceList(params);
	}
	
	/**
	 * 운영사 -  채권관리업체 DB조회후 리턴시켜주는 메소드
	 */
	public List<Map<String, Object>> getAdminBondsManagementCompList(Map<String, Object> params) {
		return defaultDao.selectAdminBondsManagementCompList(params);
	}
	
	/**
	 * 운영사 -  미수채권 DB조회후 리턴시켜주는 메소드
	 */
	public List<Map<String, Object>> getAdminAccruedReceivableList(Map<String, Object> params) {
		return defaultDao.selectAdminAccruedReceivableList(params);
	}
	
	/**
	 * 운영사 -  (-) 미수관리채무
	 */
	public List<Map<String, Object>> getAdminDebtReceivableList() {
		return defaultDao.selectAdminDebtReceivableList();
	}
	
	/**
	 * 운영사 -  당월예상실적 DB조회후 리턴시켜주는 메소드
	 */
	public List<Map<String, Object>> getAdminForecastPerformanceList(Map<String, Object> params) {
		return defaultDao.selectAdminForecastPerformanceList(params);
	}
	
	/**
	 * 운영사 -  채권관리 사업장 DB조회후 리턴시켜주는 메소드
	 */
	public List<Map<String, Object>> getAdminManagementOrganList(Map<String, Object> params) {
		return defaultDao.selectAdminManagementOrganList(params);
	}

	/**
	 * 운영사 -  채권관리 사업장 DB조회후 리턴시켜주는 메소드
	 */
	public List<Map<String, Object>> selectWorkManagementOrganList(Map<String, Object> params) {
		return defaultDao.selectWorkManagementOrganList(params);
	}
	
	/**
	 * 운영사 -  실적차트 DB조회후 리턴시켜주는 메소드
	 */
	public List<Map<String, Object>> getAdminPerformanceChart(Map<String, Object> params) {
		return defaultDao.selectAdminPerformanceChart(params);
	}
	
	/**
	 * 공급사 - 전체 공지사항 리스트를 조회하여 반환하는 메소드
	 */
	public List<Map<String, Object>> getVenNoticeList(Map<String, Object> params) {
		return defaultDao.selectVenNoticeList(params);
	}
	
	/**
	 * 공급사 - 진행중 입찰 리스트를 조회하여 반환하는 메소드
	 */
	public List<Map<String, Object>> getVenProgressBidList(Map<String, Object> params) {
		return defaultDao.selectVenProgressBidList(params);
	}
	
	/**
	 * 공급사 - 진행중 입찰 리스트를 조회하여 반환하는 메소드
	 */
	public List<Map<String, Object>> getVenProductRegReqList(Map<String, Object> params) {
		return defaultDao.selectVenProductRegReqList(params);
	}
	
	/**
	 * 공급사 - 발주접수 대상 리스트를 조회하여 반환하는 메소드
	 */
	public List<Map<String, Object>> getVenOrderTargetList(Map<String, Object> params) {
		return defaultDao.selectVenOrderTargetList(params);
	}
	
	/**
	 * 공급사 - 출하 대상 리스트를 조회하여 반환하는 메소드
	 */
	public List<Map<String, Object>> getVenShipTargetList(Map<String, Object> params) {
		return defaultDao.selectVenShipTargetList(params);
	}
	
	/**
	 * 공급사 - 배송완료 대상 리스트를 조회하여 반환하는 메소드
	 */
	public List<Map<String, Object>> getVenShippingDestiList(Map<String, Object> params) {
		return defaultDao.selectVenShippingDestiList(params);
	}
	
	/**
	 * 공급사 - 반품요청 대상 리스트를 조회하여 반환하는 메소드
	 */
	public List<Map<String, Object>> getVenReturnRequestList(Map<String, Object> params) {
		return defaultDao.selectVenReturnRequestList(params);
	}
	
	/**
	 * 물류센터 - picking 등록 대상 리스트를 조회하여 반환하는 메소드
	 */
	public List<Map<String, Object>> getCenPickingRegList(Map<String, Object> params) {
		return defaultDao.selectCenPickingRegList(params);
	}
	
	/**
	 * 물류센터 - 출고확정/인수증출력 리스트를 조회하여 반환하는 메소드
	 */
	public List<Map<String, Object>> getCenFactoryConList(Map<String, Object> params) {
		return defaultDao.selectCenFactoryConList(params);
	}
	
	/**
	 * 물류센터 -  송장입력/배송완료 리스트를 조회하여 반환하는 메소드
	 */
	public List<Map<String, Object>> getCenInvoiceShippingList(Map<String, Object> params) {
		return defaultDao.selectCenInvoiceShippingList(params);
	}
	
	/**
	 * 물류센터 - 수탁발주내역 리스트를 조회하여 반환하는 메소드
	 */
	public List<Map<String, Object>> getCenEntrustOrderList(Map<String, Object> params) {
		return defaultDao.selectCenEntrustOrderList(params);
	}
	
	/**
	 * 물류센터 - 수탁입고 대상 리스트를 조회하여 반환하는 메소드
	 */
	public List<Map<String, Object>> getCenEntrustStockList(Map<String, Object> params) {
		return defaultDao.selectCenEntrustStockList(params);
	}
	
	/**
	 * 물류센터 - 미재고수탁상품 리스트를 조회하여 반환하는 메소드
	 */
	public List<Map<String, Object>> getCenProductStockList(Map<String, Object> params) {
		return defaultDao.selectCenProductStockList(params);
	}
	
	/**
	 * 고객사 - 공지사항 리스트를 조회하여 반환하는 메소드
	 */
	public List<Map<String, Object>> getBuyNoticeList(Map<String, Object> params) {
		return defaultDao.selectBuyNoticeList(params);
	}
	
	/**
	 * 고객사 - 마이카테고리 리스트를 조회하여 반환하는 메소드
	 */
	public List<Map<String, Object>> getBuyMyCategoryList(Map<String, Object> params) {
		return defaultDao.selectBuyMyCategoryList(params);
	}
	
	/**
	 * 고객사 - 신규품목요청내역 리스트를 조회하여 반환하는 메소드
	 */
	public List<Map<String, Object>> getBuyNewItemStatusList(Map<String, Object> params) {
		return defaultDao.selectBuyNewItemStatusList(params);
	}
	
	/**
	 * 고객사 - 관심품목 리스트를 조회하여 반환하는 메소드
	 */
	public List<Map<String, Object>> getBuyWishlistItemList(Map<String, Object> params) {
		return defaultDao.selectBuyWishlistItemList(params);
	}
	
	/**
	 * 고객사 - 발주대기 리스트를 조회하여 반환하는 메소드
	 */
	public Map<String, Object> getBuyOrderConditionListCnt(Map<String, Object> params) {
		return defaultDao.selectBuyOrderConditionListCnt(params);
	}
	
	/**
	 * 고객사 -  주문현황 차트조회
	 */
	public List<Map<String, Object>> buyChartForClientOrder(Map<String, Object> params) {
		return defaultDao.buyChartForClientOrder(params);
	}
	
	/**
	 * 고객사 -  사업장별 주문현황 차트조회
	 */
	public List<Map<String, Object>> buyChartForBranchOrder(Map<String, Object> params) {
		return defaultDao.buyChartForBranchOrder(params);
	}
	
	/**
	 * 고객사 -  주문현황 리스트를 조회하여 반환하는 메소드
	 */
	public List<Map<String, Object>> getBuyOrderStatusList(Map<String, Object> params) {
		return defaultDao.selectBuyOrderStatusList(params);
	}

	public List<Map<String, Object>> getNoneBorgAdjustList(Map<String, Object> params) {
		return defaultDao.selectNoneBorgAdjustList(params);
	}
	
	/**
	 * 공지사항 리스트 조회
	 * 
	 * @param request
	 * @param isEmergency (긴급공지 조회 여부)
	 * @return List
	 * @throws Exception
	 */
	public List<BoardDto> systemDefaultNoticeList(LoginUserDto loginUserDto, boolean isEmergency, int row) throws Exception{
		List<BoardDto> result        = null;
		ModelMap       params        = new ModelMap();
		SmpBranchsDto  smpBranchsDto = loginUserDto.getSmpBranchsDto();
		String         svcTypeCd     = loginUserDto.getSvcTypeCd();
		String         workId        = null;
		int            records       = 0;
		
		if(smpBranchsDto != null ){
			workId = smpBranchsDto.getWorkId();
		}
		
		params.put("srcTitle",          "");
		params.put("srcMessage",        "");
		params.put("srcRegi_User_Numb", "");
		params.put("board_Type",        "0102");
		params.put("orderString",       " board_No desc ");
		
		if(isEmergency){
			params.put("srcEmergencyYn",    "Y");
		}
		
		if("ADM".equals(svcTypeCd) == false){
			params.put("srcBoardBorgType", svcTypeCd);
			
			if("BUY".equals(svcTypeCd)){
				params.put("workId", workId);
			}
		}
		
        records = this.generalDao.selectGernalCount("board.selectNoticeList_count", params);
		
        if(records > 0){
        	result = this.boardSvc.getNoticeList(params, 1, row);
        }
		
		return result;
	}
	
	/**
	 * 맵의 특정 키값에 해당하는 값을 콤마 처리
	 * 
	 * @param listInfo
	 * @param key
	 * @return Map
	 * @throws Exception
	 */
	private Map<String, String> setMapComma(Map<String, String> listInfo, String key) throws Exception{
		String value = null;
		
		if(listInfo != null){
			value = listInfo.get(key);
			value = CommonUtils.nvl(value, "0");
			value = CommonUtils.getDecimalAmount(value);
			
			listInfo.put(key, value);
		}
		
		return listInfo;
	}
	
	/**
	 * 공급사 메인 페이지 상품 현황 리스트를 조회하는 메소드
	 * 
	 * @param vendorId
	 * @return List
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public Map<String, String> selectVenDefaultProductList(String vendorId) throws Exception{
		Map<String, String> result   = null;
		ModelMap            daoParam = new ModelMap();
		
		daoParam.put("vendorId", vendorId);
		
		result = (Map<String, String>)this.generalDao.selectGernalObject("common.default.selectVenDefaultProductList", daoParam);
		result = this.setMapComma(result, "info01");
		result = this.setMapComma(result, "info02");
		result = this.setMapComma(result, "info03");
		result = this.setMapComma(result, "info04");
		result = this.setMapComma(result, "info05");
		result = this.setMapComma(result, "info06");
		result = this.setMapComma(result, "info07");
		result = this.setMapComma(result, "info08");
		result = this.setMapComma(result, "info09");
		result = this.setMapComma(result, "info10");
		result = this.setMapComma(result, "info11");
		result = this.setMapComma(result, "info12");
		result = this.setMapComma(result, "info13");
		result = this.setMapComma(result, "info14");
		result = this.setMapComma(result, "info15");
		
		return result;
	}
	
	private Map<String, String> selectVenDefaultSupplyListRoundAmount(Map<String, String> listInfo, String key) throws Exception{
		String value = null;
		
		if(listInfo != null){
			value = listInfo.get(key);
			value = this.getRoundAmount(value);
			
			listInfo.put(key, value);
		}
		
		return listInfo;
	}
	
	/**
	 * 공급사 메인 공급현황 리스트를 반환하는 메소드
	 * 
	 * @param borgId
	 * @return List
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public Map<String, String> selectVenDefaultSupplyList(String borgId) throws Exception{
		ModelMap            daoParam = new ModelMap();
		Map<String, String> listInfo = null;
		
		daoParam.put("borgId", borgId);
		
		listInfo = (Map<String, String>)this.generalDao.selectGernalObject("common.default.selectVenDefaultSupplyList", daoParam);
		listInfo = this.selectVenDefaultSupplyListRoundAmount(listInfo, "supply01");
		listInfo = this.selectVenDefaultSupplyListRoundAmount(listInfo, "supply02");
		listInfo = this.selectVenDefaultSupplyListRoundAmount(listInfo, "supply03");
		listInfo = this.selectVenDefaultSupplyListRoundAmount(listInfo, "supply04");
		listInfo = this.selectVenDefaultSupplyListRoundAmount(listInfo, "supply11");
		listInfo = this.selectVenDefaultSupplyListRoundAmount(listInfo, "supply12");
		listInfo = this.selectVenDefaultSupplyListRoundAmount(listInfo, "supply13");
		listInfo = this.selectVenDefaultSupplyListRoundAmount(listInfo, "supply14");
		listInfo = this.setMapComma(listInfo, "supply01");
		listInfo = this.setMapComma(listInfo, "supply02");
		listInfo = this.setMapComma(listInfo, "supply03");
		listInfo = this.setMapComma(listInfo, "supply04");
		listInfo = this.setMapComma(listInfo, "supply11");
		listInfo = this.setMapComma(listInfo, "supply12");
		listInfo = this.setMapComma(listInfo, "supply13");
		listInfo = this.setMapComma(listInfo, "supply14");
		
		return listInfo;
	}
	
	/**
	 * 공급사 메인 세금계산서 리스트 조회
	 * 
	 * @param borgId
	 * @return List
	 * @throws Exception
	 */
	public List<Map<String, String>> selectVenDefaultTexList(String borgId) throws Exception{
		List<Map<String, String>> result   = null;
		List<Object>              list     = null;
		ModelMap                  daoParam = new ModelMap();
		Map<String, String>       listInfo = null;
		int                       listSize = 0;
		int                       i        = 0;
		
		daoParam.put("borgId", borgId);
		
		list     = (List<Object>)this.generalDao.selectGernalList("common.default.selectVenDefaultTexList", daoParam);
		result   = CommonUtils.selectListObjectToListMap(list); // 제네릭 변환
		listSize = CommonUtils.getListSize(result); // 리스트 사이즈 조회
		
		for(i = 0; i < listSize; i++){
			listInfo = result.get(i);
			listInfo = this.setMapComma(listInfo, "buyiTotaAmou");
		}
		
		return result;
	}
	
	/**
	 * 6번째 자리수 반올림하는 메소드
	 * 
	 * @param string
	 * @return String
	 * @throws Exception
	 */
	private String getRoundAmount(String string) throws Exception{
		String result       = null;
		double resultDouble = 0;
		
		string       = CommonUtils.nvl(string, "0");
		resultDouble = Double.parseDouble(string);
		resultDouble = resultDouble / 1000000;
		resultDouble = Math.round(resultDouble);
		result       = CommonUtils.getDecimalAmount(resultDouble);
		
		return result;
	}
	
	/**
	 * 운영사 배치 데이터 매출현항 데이터 조작하여 리턴하는 메소드
	 * 
	 * @param listInfo
	 * @return Map
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	private Map<String, String> selectAdmBatchListInfo01(Map<String, String> listInfo) throws Exception{
		Map<String, String> thisMonthOrderInfo = (Map<String, String>)this.generalDao.selectGernalObject("common.default.selectAdmThisMonthOrderInfo", new ModelMap());
		String              info01             = null; // 당월 주문금액
		String              info02             = null; // 당월 인수금액
		String              info03             = listInfo.get("info03"); // 년간 매출
		String              info04             = listInfo.get("info04"); // 년간 매출이익
		String              info05             = listInfo.get("info05"); // 년간 이익율
		
		if(thisMonthOrderInfo != null){
			info01 = thisMonthOrderInfo.get("info01");
			info02 = thisMonthOrderInfo.get("info02");
		}
		
		info01 = CommonUtils.nvl(info01, "0");
		info02 = CommonUtils.nvl(info02, "0");
		info01 = this.getRoundAmount(info01);
		info02 = this.getRoundAmount(info02);
		info03 = this.getRoundAmount(info03);
		info04 = this.getRoundAmount(info04);
		info05 = CommonUtils.getRoundPercent(info05);
		
		listInfo.put("info01", info01);
		listInfo.put("info02", info02);
		listInfo.put("info03", info03);
		listInfo.put("info04", info04);
		listInfo.put("info05", info05);
		
		return listInfo;
	}
	
	/**
	 * 운영사 배치 데이터 채권현항1 데이터 조작하여 리턴하는 메소드
	 * 
	 * @param listInfo
	 * @return Map
	 * @throws Exception
	 */
	private Map<String, String> selectAdmBatchListInfo02(Map<String, String> listInfo) throws Exception{
		String info01 = listInfo.get("info01"); // 전월 채권금액
		String info02 = listInfo.get("info02"); // 당월 수금액
		String info03 = listInfo.get("info03"); // 채권 잔액
		String info04 = listInfo.get("info04"); // 정상채권 회수율
		String info05 = listInfo.get("info05"); // 주문제한 업체수
		
		info01 = this.getRoundAmount(info01);
		info02 = this.getRoundAmount(info02);
		info03 = this.getRoundAmount(info03);
		info04 = CommonUtils.getRoundPercent(info04);
		info05 = CommonUtils.getDecimalAmount(info05);
		
		listInfo.put("info01", info01);
		listInfo.put("info02", info02);
		listInfo.put("info03", info03);
		listInfo.put("info04", info04);
		listInfo.put("info05", info05);
		
		return listInfo;
	}
	
	/**
	 * 운영사 배치 데이터 채권현항2 데이터 조작하여 리턴하는 메소드
	 * 
	 * @param listInfo
	 * @return Map
	 * @throws Exception
	 */
	private Map<String, String> selectAdmBatchListInfo03(Map<String, String> listInfo) throws Exception{
		String info01 = listInfo.get("info01"); // 채권액 정상채권
		String info02 = listInfo.get("info02"); // 채권액 관리채권
		String info03 = listInfo.get("info03"); // 채권액 장기채권
		String info04 = listInfo.get("info04"); // 점유율 정상채권
		String info05 = listInfo.get("info05"); // 점유율 관리채권
		String info06 = listInfo.get("info06"); // 점유율 장기채권
		String info07 = listInfo.get("info07"); // 업체수 정상채권
		String info08 = listInfo.get("info08"); // 업체수 관리채권
		String info09 = listInfo.get("info09"); // 업체수 장기채권
		
		info01 = this.getRoundAmount(info01);
		info02 = this.getRoundAmount(info02);
		info03 = this.getRoundAmount(info03);
		info04 = CommonUtils.getRoundPercent(info04);
		info05 = CommonUtils.getRoundPercent(info05);
		info06 = CommonUtils.getRoundPercent(info06);
		info07 = CommonUtils.getDecimalAmount(info07);
		info08 = CommonUtils.getDecimalAmount(info08);
		info09 = CommonUtils.getDecimalAmount(info09);
		
		listInfo.put("info01", info01);
		listInfo.put("info02", info02);
		listInfo.put("info03", info03);
		listInfo.put("info04", info04);
		listInfo.put("info05", info05);
		listInfo.put("info06", info06);
		listInfo.put("info07", info07);
		listInfo.put("info08", info08);
		listInfo.put("info09", info09);
		
		return listInfo;
	}
	
	/**
	 * 운영사 배치 데이터 고객사 현황 데이터 조작하여 리턴하는 메소드
	 * 
	 * @param listInfo
	 * @return Map
	 * @throws Exception
	 */
	private Map<String, String> selectAdmBatchListInfo04(Map<String, String> listInfo) throws Exception{
		String info01 = listInfo.get("info01"); // 구매사 당월 신규
		String info02 = listInfo.get("info02"); // 구매사 당월 종료
		String info03 = listInfo.get("info03"); // 구매사 당월 소계
		String info04 = listInfo.get("info04"); // 구매사 누적
		String info05 = listInfo.get("info05"); // 공급사 당월 신규 
		String info06 = listInfo.get("info06"); // 공급사 당월 종료 
		String info07 = listInfo.get("info07"); // 공급사 당월 소계 
		String info08 = listInfo.get("info08"); // 공급사 누적    
		
		info01 = CommonUtils.getDecimalAmount(info01);
		info02 = CommonUtils.getDecimalAmount(info02);
		info03 = CommonUtils.getDecimalAmount(info03);
		info04 = CommonUtils.getDecimalAmount(info04);
		info05 = CommonUtils.getDecimalAmount(info05);
		info06 = CommonUtils.getDecimalAmount(info06);
		info07 = CommonUtils.getDecimalAmount(info07);
		info08 = CommonUtils.getDecimalAmount(info08);
		
		listInfo.put("info01", info01);
		listInfo.put("info02", info02);
		listInfo.put("info03", info03);
		listInfo.put("info04", info04);
		listInfo.put("info05", info05);
		listInfo.put("info06", info06);
		listInfo.put("info07", info07);
		listInfo.put("info08", info08);
		
		return listInfo;
	}
	
	/**
	 * 운영사 배치 데이터 상품 현황 데이터 조작하여 리턴하는 메소드
	 * 
	 * @param listInfo
	 * @return Map
	 * @throws Exception
	 */
	private Map<String, String> selectAdmBatchListInfo05(Map<String, String> listInfo) throws Exception{
		String info01 = listInfo.get("info01"); // 총계 당월 신규
		String info02 = listInfo.get("info02"); // 총계 당월 종료 
		String info03 = listInfo.get("info03"); // 총계 당월 소계
		String info04 = listInfo.get("info04"); // 총계 누적
		String info05 = listInfo.get("info05"); // 지정 당월 신규 
		String info06 = listInfo.get("info06"); // 지정 당월 종료 
		String info07 = listInfo.get("info07"); // 지정 당월 소계
		String info08 = listInfo.get("info08"); // 지정 누적
		String info09 = listInfo.get("info09"); // 일반 당월 신규
		String info10 = listInfo.get("info10"); // 일반 당월 종료
		String info11 = listInfo.get("info11"); // 일반 당월 소계
		String info12 = listInfo.get("info12"); // 일반 누적
		
		info01 = CommonUtils.getDecimalAmount(info01);
		info02 = CommonUtils.getDecimalAmount(info02);
		info03 = CommonUtils.getDecimalAmount(info03);
		info04 = CommonUtils.getDecimalAmount(info04);
		info05 = CommonUtils.getDecimalAmount(info05);
		info06 = CommonUtils.getDecimalAmount(info06);
		info07 = CommonUtils.getDecimalAmount(info07);
		info08 = CommonUtils.getDecimalAmount(info08);
		info09 = CommonUtils.getDecimalAmount(info09);
		info10 = CommonUtils.getDecimalAmount(info10);
		info11 = CommonUtils.getDecimalAmount(info11);
		info12 = CommonUtils.getDecimalAmount(info12);
		
		listInfo.put("info01", info01);
		listInfo.put("info02", info02);
		listInfo.put("info03", info03);
		listInfo.put("info04", info04);
		listInfo.put("info05", info05);
		listInfo.put("info06", info06);
		listInfo.put("info07", info07);
		listInfo.put("info08", info08);
		listInfo.put("info09", info09);
		listInfo.put("info10", info10);
		listInfo.put("info11", info11);
		listInfo.put("info12", info12);
		
		return listInfo;
	}
	
	/**
	 * <pre>
	 * 운영사 배치 데이터 조회하여 리턴하는 메소드
	 * 
	 * 데이터 타입에 따라 return map 구조가 상이함. 소스 및 ERD 참조
	 * </pre>
	 * 
	 * @return List
	 * @throws Exception
	 */
	public List<Map<String, String>> selectAdmBatchList() throws Exception{
		List<Map<String, String>> result   = null;
		List<Object>              list     = null;
		Map<String, String>       listInfo = null;
		String                    infoType = null;
		int                       listSize = 0;
		int                       i        = 0;
		
		list     = (List<Object>)this.generalDao.selectGernalList("common.default.selectAdmBatchList", new ModelMap());
		result   = CommonUtils.selectListObjectToListMap(list); // 제네릭 변환
		listSize = CommonUtils.getListSize(list); // 리스트 사이즈 조회
		
		for(i = 0; i < listSize; i++){
			listInfo = result.get(i);
			infoType = listInfo.get("infoType");
			
			if("1".equals(infoType)){
				listInfo = this.selectAdmBatchListInfo01(listInfo); // 매출현황
			}
			else if("2".equals(infoType)){
				listInfo = this.selectAdmBatchListInfo02(listInfo); // 채권현황1
			}
			else if("3".equals(infoType)){
				listInfo = this.selectAdmBatchListInfo03(listInfo); // 채권현황2
			}
			else if("4".equals(infoType)){
				listInfo = this.selectAdmBatchListInfo04(listInfo); // 고객사현황
			}
			else if("5".equals(infoType)){
				listInfo = this.selectAdmBatchListInfo05(listInfo); // 상품현황
			}
		}
		
		return result;
	}
	
	/**
	 * <pre>
	 * 관리자 사이드 카운트를 조회하여 반환하는 메소드
	 * 
	 * ~. return map 구조
	 *   !. brc01 (고객사 상품 등록 요청 건수)
	 *   !. brc02 (고객사 선입금 주문처리 건수)
	 *   !. brc03 (고객사 신규등록 요청 건수)
	 *   !. ven01 (공급사 상품등록 요청 건수)
	 *   !. ven02 (공급사 상품변경 요청 건수)
	 *   !. ven03 (공급사 물량배분 건수)
	 *   !. ven04 (공급사 신규등록요청 건수)
	 *   !. ven05 (공급사 신규제안 건수)
	 * </pre>
	 * 
	 * @return Map
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public Map<String, String> selectAmdSideCount() throws Exception{
		ModelMap paramMap	=	new ModelMap();
		paramMap.put("brc01_start_date", CommonUtils.getCustomDay("YEAR", -1));
		paramMap.put("brc01_end_date", CommonUtils.getCurrentDate());
		paramMap.put("ven01_start_date", CommonUtils.getCustomDay("YEAR", -1));
		paramMap.put("ven01_end_date", CommonUtils.getCurrentDate());
		paramMap.put("ven02_start_date", CommonUtils.getCustomDay("YEAR", -1));
		paramMap.put("ven02_end_date", CommonUtils.getCurrentDate());
		paramMap.put("ven05_start_date", CommonUtils.getCustomDay("YEAR", -1));
		paramMap.put("ven05_end_date", CommonUtils.getCurrentDate());
		Map<String, String> result 		= (Map<String, String>)this.generalDao.selectGernalObject("common.default.selectAmdSideCountInfo", paramMap);
		
		result = this.setMapComma(result, "brc01");
		result = this.setMapComma(result, "brc02");
		result = this.setMapComma(result, "brc03");
		result = this.setMapComma(result, "ven01");
		result = this.setMapComma(result, "ven02");
		result = this.setMapComma(result, "ven03");
		result = this.setMapComma(result, "ven04");
		result = this.setMapComma(result, "ven05");
		
		return result;
	}
	
	/**
	 * 신규 자재 제안 카운트를 조회하는 메소드
	 * @param srcFinalProcStatFlagNm
	 * @return
	 * @throws Exception
	 */
	private String getProposalListCnt(String srcFinalProcStatFlagNm) throws Exception{
		ModelMap            daoParam          = new ModelMap();
		String              srcSuggestStDate  = CommonUtils.getCustomDay("YEAR", -1);
		String              srcSuggestEndDate = CommonUtils.getCurrentDate();
		String              result            = null;
		int                 resultInt         = 0;
		
		daoParam.put("srcSuggestStDate",       srcSuggestStDate);
		daoParam.put("srcSuggestEndDate",      srcSuggestEndDate);
		daoParam.put("srcFinalProcStatFlagNm", srcFinalProcStatFlagNm);
		
		resultInt = this.generalDao.selectGernalCount("proposal.selectProposalListCnt", daoParam);
		result    = Integer.toString(resultInt);
		
		return result;
	}
	
	private String getRequestManageListCnt(LoginUserDto userInfoDto, String srcStatFlagCode) throws Exception{
		ModelMap            daoParam          = new ModelMap();
		String              srcFromDt         = CommonUtils.getCustomDay("YEAR", -1);
		String              srcEndDt          = CommonUtils.getCurrentDate();
		String              result            = null;
		int                 resultInt = 0;
		
		daoParam.put("srcFromDt",       srcFromDt);
		daoParam.put("srcEndDt",        srcEndDt);
		daoParam.put("srcStatFlagCode", srcStatFlagCode);
		daoParam.put("userInfoDto",     userInfoDto);
		
		resultInt = this.generalDao.selectGernalCount("board.selectRequestManageListCnt", daoParam);
		result    = Integer.toString(resultInt);
		
		return result;
	}
	
	/**
	 * <pre>
	 * 관리자 voc 정보를 조회하여 반환
	 * 
	 * ~. return map 구조
	 *   !. vocRequest (VOC 접수 건수)
	 *   !. vocAccept (VOC 조치 중 건수)
	 *   !. vocEnd (VOC 종결 건수)
	 *   !. newProductRequest (신규상품제안 접수 건수)
	 *   !. newProductAccept (신규상품제안 조치 중 건수)
	 *   !. newProductEnd (신규상품제안 종결 건수)
	 *   !. qnaRequest (Q&A 접수 건수)
	 *   !. qnaEnd (Q&A 종결 건수)
	 * </pre>
	 * 
	 * @return Map
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public Map<String, String> selectAdmVocInfo(LoginUserDto userInfoDto) throws Exception{
		Map<String, String> result            = (Map<String, String>)this.generalDao.selectGernalObject("common.default.selectAdmVocInfo", new ModelMap());
		String              newProductRequest = this.getProposalListCnt("10");
		String              newProductAccept  = this.getProposalListCnt("20");
		String              newProductEnd     = this.getProposalListCnt("41");
		String              qnaRequest        = this.getRequestManageListCnt(userInfoDto, "0");
		String              qnaEnd            = this.getRequestManageListCnt(userInfoDto, "2");
		
		result.put("newProductRequest", newProductRequest);
		result.put("newProductAccept",  newProductAccept);
		result.put("newProductEnd",     newProductEnd);
		result.put("qnaRequest",        qnaRequest);
		result.put("qnaEnd",            qnaEnd);
		
		result = this.setMapComma(result, "vocRequest");
		result = this.setMapComma(result, "vocAccept");
 		result = this.setMapComma(result, "vocEnd");
 		result = this.setMapComma(result, "newProductRequest");
 		result = this.setMapComma(result, "newProductAccept");
 		result = this.setMapComma(result, "newProductEnd");
 		result = this.setMapComma(result, "qnaRequest");
 		result = this.setMapComma(result, "qnaEnd");
		
		return result;
	}
	
	/**
	 * <pre>
	 * 관리자 스마일 지수 정보를 조회하여 반환하는 메소드
	 * 
	 * ~. return map 구조
	 *   !. sktsBuyMonth (SKT 지수 구매사 당월)
	 *   !. sktsBuyAccmulate (SKT 지수 구매사 누적)
	 *   !. sktsVenMonth (SKT 지수 공급사 당월)
	 *   !. sktsVenAccmulate (SKT 지수 공급사 누적)
	 *   !. venMonth (공급사 지수 당월)
	 *   !. venAccmulate (공급사 지수 누적)
	 * </pre>
	 * 
	 * @return Map
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public Map<String, String> selectAdmSmilePointInfo() throws Exception{
		Map<String, String> result = (Map<String, String>)this.generalDao.selectGernalObject("common.default.selectAdmSmilePointInfo", new ModelMap());
		
		result = this.setMapComma(result, "sktsBuyMonth");
		result = this.setMapComma(result, "sktsBuyAccmulate");
		result = this.setMapComma(result, "sktsVenMonth");
		result = this.setMapComma(result, "sktsVenAccmulate");
		result = this.setMapComma(result, "venMonth");
		result = this.setMapComma(result, "venAccmulate");
		
		return result;
	}
	
	/**
	 * <pre>
	 * 관리자 신규 상품 리스트를 조회하여 반환하는 메소드
	 * 
	 * ~. return map 구조
	 *   !. newGoodId (요청번호)
	 *   !. standGoodName (상품명)
	 *   !. borgNm (요청 업체 명)
	 * </pre>
	 * 
	 * @return List
	 * @throws Exception
	 */
	public List<Map<String, String>> selectAdmProductRequestList() throws Exception{
		List<Map<String, String>> result    = null;
		List<Object>              list      = null;
		RowBounds                 rowBounds = new RowBounds(0, 5);
		ModelMap                  modelMap  = new ModelMap();
		
		modelMap.put("rowBounds", rowBounds);
		
		list   = (List<Object>)this.generalDao.selectGernalList("common.default.selectAdmProductRequestList", modelMap);
		result = CommonUtils.selectListObjectToListMap(list);
		
		return result;
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, String> selectVenDefaultSmileInfo(String borgId) throws Exception{
		Map<String, String> result   = null;
		ModelMap            modelMap = new ModelMap();
		String              t        = "0";
		String              a        = "0";
		
		modelMap.put("borgId", borgId);
		
		result = (Map<String, String>)this.generalDao.selectGernalObject("common.default.selectVenDefaultSmileInfo", modelMap);
		
		if(result != null){
			t = result.get("t");
			t = CommonUtils.getRoundPercent(t);
			a = result.get("a");
			a = CommonUtils.getRoundPercent(a);
		}
		else{
			result = new HashMap<String, String>();
		}
		
		result.put("t", t);
		result.put("a", a);
		
		return result;
	}
	
	/**
	 * 메니져 화면의 채권현황 정보를 리턴하는 메소드
	 * 
	 * @param loginUserDto
	 * @return Map
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public Map<String, String> selectManagerBondInfo(LoginUserDto loginUserDto) throws Exception{
		Map<String, String> result        = null;
		ModelMap            daoParam      = new ModelMap();
		String              managerType   = null;
		String              amount90Rate  = null;
		String              amount150Rate = null;
		String              amountSumRate = null;
		boolean             isSktMng      = loginUserDto.isSKTMng();
		boolean             isSkbMng      = loginUserDto.isSKBMng();
		
		if(isSktMng){
			managerType = "1";
		}
		
		if(isSkbMng){
			managerType = "2";
		}
		
		daoParam.put("managerType", managerType);
		
		result        = (Map<String, String>)this.generalDao.selectGernalObject("common.default.selectManagerBondInfo", daoParam);
		result        = this.setMapComma(result, "amount90");
		result        = this.setMapComma(result, "amount150");
		result        = this.setMapComma(result, "amountSum");
		result        = this.setMapComma(result, "amount90Cnt");
		result        = this.setMapComma(result, "amount150Cnt");
		result        = this.setMapComma(result, "amountSumCnt");
		amount90Rate  = result.get("amount90Rate");
		amount150Rate = result.get("amount150Rate");
		amountSumRate = result.get("amountSumRate");
		amount90Rate  = CommonUtils.getRoundPercent(amount90Rate);
		amount150Rate = CommonUtils.getRoundPercent(amount150Rate);
		amountSumRate = CommonUtils.getRoundPercent(amountSumRate);
		
		result.put("amount90Rate",  amount90Rate);
		result.put("amount150Rate", amount150Rate);
		result.put("amountSumRate", amountSumRate);
		
		return result;
	}

	/**
	 * Vendor Quick Menu COUNT 조회
	 * 
	 * @param getVendorQuickMenuCnt
	 * @return Map
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public Map<String, String> getVendorQuickMenuCnt(Map<String, Object> params)  throws Exception{
		Map<String, String> quickInfo        = null;
		
//		String              quick01           = null;
//		String              quick02           = null;
//		String              quick03           = null;
//		String              quick04           = null;
//		String              quick05           = null;
		
		quickInfo = (Map<String, String>)this.generalDao.selectGernalObject("common.default.selectVendorQuickList", params);
//		quick01   = quickInfo.get("quick01");
//		quick02   = quickInfo.get("quick02");
//		quick03   = quickInfo.get("quick03");
//		quick04   = quickInfo.get("quick04");
//		quick05   = quickInfo.get("quick05");
		
		return quickInfo;
	}
}