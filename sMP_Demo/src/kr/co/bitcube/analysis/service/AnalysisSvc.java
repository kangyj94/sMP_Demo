package kr.co.bitcube.analysis.service;

import java.util.List;
import java.util.Map;

import kr.co.bitcube.analysis.dao.AnalysisDao;
import kr.co.bitcube.analysis.dto.AnalysisDto;
import kr.co.bitcube.common.dto.LoginUserDto;
import kr.co.bitcube.common.utils.CommonUtils;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class AnalysisSvc {
	
	@SuppressWarnings("unused")
	private Logger logger = Logger.getLogger(getClass());
	@Autowired
	private AnalysisDao analysisDao;
	
	/**
	 * 경영정보요약 리스트를 조회하여 반환하는 메소드
	 * @param params
	 * @return
	 */
	public List<AnalysisDto> getAnalysisSummaryList(Map<String, Object> params) throws Exception{
		LoginUserDto      loginUserDto = (LoginUserDto)params.get("loginUserDto");
		List<AnalysisDto> result       = this.analysisDao.selectAnalysisSummaryList(params); // 리스트 조회
		boolean           isMng        = CommonUtils.isMngUser(loginUserDto); // 메니져 여부
		
		if(isMng){
			result.remove(2);
			result.remove(1);
		}
		
		return result;
	}
	
	/**
	 * 매출경영정보상세 리스트를 조회하여 반환하는 메소드
	 * @param params
	 * @return
	 */
	public List<AnalysisDto> getAnalysisSalesList(Map<String, Object> params) {
		return analysisDao.selectAnalysisSalesList(params);
	}
	
	/**
	 * 매입경영정보상세 리스트를 조회하여 반환하는 메소드
	 * @param params
	 * @return
	 */
	public List<AnalysisDto> getAnalysisBuyList(Map<String, Object> params) {
		return analysisDao.selectAnalysisBuyList(params);
	}
	
	/**
	 * 고객사별 손익실적 리스트를 조회하여 반환하는 메소드
	 * @param params
	 * @return
	 */
	public List<AnalysisDto> getAnalysisCustomerList(Map<String, Object> params) {
		return analysisDao.selectAnalysisCustomerList(params);
	}
	public List<AnalysisDto> getAnalysisCustomerListDetail(Map<String, Object> params) {
		return analysisDao.getAnalysisCustomerListDetail(params);
	}
	
	/**
	 * 고객사의 품목별 손익실적 리스트를 조회하여 반환하는 메소드
	 * @param params
	 * @return
	 */
	public int getAnalysisCustomerProductListCnt(Map<String, Object> params) {
		return analysisDao.selectAnalysisCustomerProductListCnt(params);
	}
	public List<AnalysisDto> getAnalysisCustomerProductList(Map<String, Object> params, int page, int rows) {
		return analysisDao.selectAnalysisCustomerProductList(params, page, rows);
	}
	
	/**
	 * 공급사별 손익실적 리스트를 조회하여 반환하는 메소드
	 * @param params
	 * @return
	 */
	public List<AnalysisDto> getAnalysisVendorList(Map<String, Object> params) {
		return analysisDao.selectAnalysisVendorList(params);
	}
	
	/**
	 * 공급사의 품목별 손익실적 리스트를 조회하여 반환하는 메소드
	 * @param params
	 * @return
	 */
	public List<AnalysisDto> getAnalysisVendorProductList(Map<String, Object> params) {
		return analysisDao.selectAnalysisVendorProductList(params);
	}
	
	/**
	 * 권역별 손익실적 리스트를 조회하여 반환하는 메소드
	 * @param params
	 * @return
	 */
	public List<AnalysisDto> getAnalysisAreaList(Map<String, Object> params) {
		return analysisDao.selectAnalysisAreaList(params);
	}
	
	/**
	 * 권역의 품목별 손익실적 리스트를 조회하여 반환하는 메소드
	 * @param params
	 * @return
	 */
	public List<AnalysisDto> getAnalysisAreaProductList(Map<String, Object> params) {
		return analysisDao.selectAnalysisAreaProductList(params);
	}
	
	/**
	 * 품목별 판매실적 리스트의 카운트 조회하는 메소드
	 * @param params
	 * @return
	 */
	public Map<String, Integer> getAnalysisProductListCnt(Map<String, Object> params) {
		return (Map<String, Integer>)analysisDao.selectAnalysisProductListCnt(params);
	}
	
	/**
	 * 품목별 판매실적 리스트를 조회하여 반환하는 메소드
	 * @param params
	 * @param page(페이지번호)
	 * @param rows(페이지 Row 개수)
	 * @return
	 */
	public List<AnalysisDto> getAnalysisProductList(Map<String, Object> params, int page, int rows) {
		return analysisDao.selectAnalysisProductList(params, page, rows);
	}
	
	
	/**
	 * 매출상세 페이지에 공사유형 리스트를 받아오는 메소드 
	 * @return
	 */
	public List<Map<String, Object>> getWorkInfoList() {
		return analysisDao.selectWorkInfoList();
	}
	
	/**
	 * 매출상세 페이지에 업체갯수와 금액합계
	 * @param params
	 * @return
	 */
	public Map<String, Object> getAnalysisSalesListCnt(Map<String, Object> params) {
		return analysisDao.selectAnalysisSalesListCnt(params);
	}
	/**
	 * 연 매출현황 리스트
	 * @param params
	 * @return
	 */
	public List<AnalysisDto> getAnalysisGoodRegYearList(Map<String, Object> params) {
		return analysisDao.selectAnalysisGoodRegYearList(params);
		
	}
	
	/**
	 * 공사유형별 월 예상실적 갯수 및 합계
	 * @param params
	 * @return
	 */
	public Map<String, Integer> getAnalysisWorkInfoExpectationSalesCnt(Map<String, Object> params) {
		return analysisDao.selectAnalysisWorkInfoExpectationSalesCnt(params);
	}
	
	/**
	 * 공사유형별 월 예상실적 리스트
	 * @param params
	 * @return
	 */
	public List<AnalysisDto> getAnalysisWorkInfoExpectationSalesList(Map<String, Object> params) {
		return analysisDao.selectAnalysisWorkInfoExpectationSalesList(params);
	}
	
	/**
	 * 월 매출현황 리스트
	 * @param params
	 * @return
	 */
	public List<AnalysisDto> getAnalysisGoodRegMonthList(Map<String, Object> params) {
		String srcDateFlag = CommonUtils.getString(params.get("srcDateFlag"));
		if("".equals(srcDateFlag)) {	//세금계산서 기준
			return analysisDao.selectAnalysisGoodRegMonthList1(params);
		} else {	//인수일자 기준
			return analysisDao.selectAnalysisGoodRegMonthList2(params);
		}
//		return analysisDao.selectAnalysisGoodRegMonthList(params);
	}
	/**
	 * 일자별 주문실적, 출하실적, 인수실적 리스트
	 * @param params
	 * @return
	 */
	public List<AnalysisDto> getAnalysisWeekDaySalesList(Map<String, Object> params) throws Exception {
		List<AnalysisDto> list               = this.analysisDao.selectAnalysisWeekDaySalesList(params);
		AnalysisDto       info               = null;
		String            autoSaleAmount     = null;
		String            menuSaleAmount     = null;
		String            recePayAmouPercent = null;
		int               listSize           = CommonUtils.getListSize(list);
		int               i                  = 0;
		
		for(i = 0; i < listSize; i++){
			info               = list.get(i);
			autoSaleAmount     = info.getAuto_sale_amount();
			menuSaleAmount     = info.getMenu_sale_amount();
			recePayAmouPercent = info.getRece_pay_amou_percent();
			
			this.logger.debug("autoSaleAmount : " + autoSaleAmount);
			this.logger.debug("menuSaleAmount : " + menuSaleAmount);
			this.logger.debug("recePayAmouPercent : " + recePayAmouPercent);
			
			autoSaleAmount     = CommonUtils.getRoundPercent(autoSaleAmount); // 소수점 한자리로 변환
			menuSaleAmount     = CommonUtils.getRoundPercent(menuSaleAmount);
			recePayAmouPercent = CommonUtils.getRoundPercent(recePayAmouPercent);
			
			this.logger.debug("");
			this.logger.debug("autoSaleAmount : " + autoSaleAmount);
			this.logger.debug("menuSaleAmount : " + menuSaleAmount);
			this.logger.debug("recePayAmouPercent : " + recePayAmouPercent);
			
			this.logger.debug("");
			this.logger.debug("");
			
			info.setAuto_sale_amount(autoSaleAmount);
			info.setMenu_sale_amount(menuSaleAmount);
			info.setRece_pay_amou_percent(recePayAmouPercent);
		}
		
		return list;
	}

	public List<AnalysisDto> getAnalysisBonds(Map<String, Object> params) {
		return analysisDao.getAnalysisBonds(params);
	}

	public Map<String, Object> getAnalysisBondsDetail(Map<String, Object> params) {
		return analysisDao.getAnalysisBondsDetail(params);
	}
	/**
	 * 채권관리업체 카운트
	 * @param params
	 * @return
	 */
	public int getAnalysisBondsCorpListCnt(Map<String, Object> params) {
		return analysisDao.selectAnalysisBondsCorpListCnt(params);
	}
	/**
	 * 채권관리업체 리스트
	 * @param params
	 * @param page
	 * @param rows
	 * @return
	 */
	public List<AnalysisDto> getAnalysisBondsCorpList(Map<String, Object> params, int page, int rows) {
		return analysisDao.selectAnalysisBondsCorpList(params, page, rows);
	}
}
