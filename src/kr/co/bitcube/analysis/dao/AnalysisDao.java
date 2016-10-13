package kr.co.bitcube.analysis.dao;

import java.util.List;
import java.util.Map;

import kr.co.bitcube.analysis.dto.AnalysisDto;
import kr.co.bitcube.product.dto.McNewGoodRequestDto;

import org.apache.ibatis.session.RowBounds;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class AnalysisDao {
	
	private final String statement = "analysis.";
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	/**
	 * 경영정보요약 리스트를 조회하여 반환하는 메소드
	 * @param params
	 * @return
	 */
	
	public List<AnalysisDto> selectAnalysisSummaryList(Map<String, Object> params) {
		return sqlSessionTemplate.selectList(this.statement+"selectAnalysisSummaryList", params);
	}
	
	/**
	 * 매출경영정보상세 리스트를 조회하여 반환하는 메소드
	 * @param params
	 * @return
	 */
	
	public List<AnalysisDto> selectAnalysisSalesList(Map<String, Object> params) {
		return sqlSessionTemplate.selectList(this.statement+"selectAnalysisSalesList", params);
	}
	
	/**
	 * 매입경영정보상세 리스트를 조회하여 반환하는 메소드
	 * @param params
	 * @return
	 */
	
	public List<AnalysisDto> selectAnalysisBuyList(Map<String, Object> params) {
		return sqlSessionTemplate.selectList(this.statement+"selectAnalysisBuyList", params);
	}
	
	/**
	 * 고객사별 손익실적 리스트를 조회하여 반환하는 메소드
	 * @param params
	 * @return
	 */
	
	public List<AnalysisDto> selectAnalysisCustomerList(Map<String, Object> params) {
		return sqlSessionTemplate.selectList(this.statement+"selectAnalysisCustomerList", params);
	}
	
	public List<AnalysisDto> getAnalysisCustomerListDetail(Map<String, Object> params) {
		return sqlSessionTemplate.selectList(this.statement+"selectAnalysisCustomerListDetail", params);
	}
	
	/**
	 * 고객사의 품목별 손익실적 리스트를 조회하여 반환하는 메소드
	 * @param params
	 * @return
	 */
	public int selectAnalysisCustomerProductListCnt(Map<String, Object> params) {
		return (Integer) sqlSessionTemplate.selectOne(this.statement+"selectAnalysisCustomerProductListCnt", params);
	}
	
	public List<AnalysisDto> selectAnalysisCustomerProductList(Map<String, Object> params, int page, int rows) {
		RowBounds rowBounds = new RowBounds((page-1)*rows, rows);
		return sqlSessionTemplate.selectList(this.statement+"selectAnalysisCustomerProductList", params, rowBounds);
	}
	
	/**
	 * 공급사별 손익실적 리스트를 조회하여 반환하는 메소드
	 * @param params
	 * @return
	 */
	
	public List<AnalysisDto> selectAnalysisVendorList(Map<String, Object> params) {
		return sqlSessionTemplate.selectList(this.statement+"selectAnalysisVendorList", params);
	}
	
	/**
	 * 공급사의 품목별 손익실적 리스트를 조회하여 반환하는 메소드
	 * @param params
	 * @return
	 */
	
	public List<AnalysisDto> selectAnalysisVendorProductList(Map<String, Object> params) {
		return sqlSessionTemplate.selectList(this.statement+"selectAnalysisVendorProductList", params);
	}
	
	/**
	 * 권역별 손익실적 리스트를 조회하여 반환하는 메소드
	 * @param params
	 * @return
	 */
	
	public List<AnalysisDto> selectAnalysisAreaList(Map<String, Object> params) {
		return sqlSessionTemplate.selectList(this.statement+"selectAnalysisAreaList", params);
	}
	
	/**
	 * 권역의 품목별 손익실적 리스트를 조회하여 반환하는 메소드
	 * @param params
	 * @return
	 */
	
	public List<AnalysisDto> selectAnalysisAreaProductList(Map<String, Object> params) {
		return sqlSessionTemplate.selectList(this.statement+"selectAnalysisAreaProductList", params);
	}
	
	/**
	 * 품목별 판매실적 리스트의 카운트 조회하는 메소드
	 * @param params
	 * @return
	 */ 
	public Map<String, Integer> selectAnalysisProductListCnt(Map<String, Object> params) {
		return sqlSessionTemplate.selectOne(this.statement+"selectAnalysisProductListCnt", params);
	}
	
	/**
	 * 품목별 판매실적 리스트를 조회하여 반환하는 메소드
	 * @param params
	 * @param page(페이지번호)
	 * @param rows(페이지 Row 개수)
	 * @return
	 */
	
	public List<AnalysisDto> selectAnalysisProductList(Map<String, Object> params, int page, int rows) {
		RowBounds rowBounds = new RowBounds((page-1)*rows, rows);
		return sqlSessionTemplate.selectList(this.statement+"selectAnalysisProductList", params, rowBounds);
	}

	public List<Map<String, Object>> selectWorkInfoList() {
		return sqlSessionTemplate.selectList(this.statement+"selectWorkInfoList");
	}

	public Map<String, Object> selectAnalysisSalesListCnt(Map<String, Object> params) {
		return sqlSessionTemplate.selectOne(this.statement+"selectAnalysisSalesListCnt", params);
	}

	public List<AnalysisDto> selectAnalysisGoodRegYearList(Map<String, Object> params) {
		return sqlSessionTemplate.selectList(this.statement+"selectAnalysisGoodRegYearList", params);
	}

	public List<AnalysisDto> selectAnalysisYearList() {
		return sqlSessionTemplate.selectList(this.statement+"selectAnalysisYearList");
	}
	
	public Map<String, Integer> selectAnalysisWorkInfoExpectationSalesCnt(Map<String, Object> params) {
		return sqlSessionTemplate.selectOne(this.statement+"selectAnalysisWorkInfoExpectationSalesCnt", params);
	}
	
	public List<AnalysisDto> selectAnalysisWorkInfoExpectationSalesList(Map<String, Object> params) {
		return sqlSessionTemplate.selectList(this.statement+"selectAnalysisWorkInfoExpectationSalesList", params);
	}

	public List<AnalysisDto> selectAnalysisGoodRegMonthList(Map<String, Object> params) {
		return sqlSessionTemplate.selectList(this.statement+"selectAnalysisGoodRegMonthList",params);
	}
	public List<AnalysisDto> selectAnalysisGoodRegMonthList1(Map<String, Object> params) {
		return sqlSessionTemplate.selectList(this.statement+"selectAnalysisGoodRegMonthList1",params);
	}
	public List<AnalysisDto> selectAnalysisGoodRegMonthList2(Map<String, Object> params) {
		return sqlSessionTemplate.selectList(this.statement+"selectAnalysisGoodRegMonthList2",params);
	}

	public List<AnalysisDto> selectAnalysisWeekDaySalesList(Map<String, Object> params) {
		return sqlSessionTemplate.selectList(this.statement+"selectAnalysisWeekDaySalesList",params);
	}

	public List<AnalysisDto> getAnalysisBonds(Map<String, Object> params) {
		return sqlSessionTemplate.selectList(this.statement+"selectAnalysisBonds",params);
	}

	public Map<String, Object> getAnalysisBondsDetail(Map<String, Object> params) {
		return sqlSessionTemplate.selectOne(this.statement+"selectAnalysisBondsDetail",params);
	}
	/**
	 * 채권관리업체 카운트
	 * @param params
	 * @return
	 */
	public int selectAnalysisBondsCorpListCnt(Map<String, Object> params) {
		return (Integer) sqlSessionTemplate.selectOne(this.statement+"selectAnalysisBondsCorpListCnt", params);
	}
	/**
	 * 채권관리업체 리스트
	 * @param params
	 * @param page
	 * @param rows
	 * @return
	 */
	public List<AnalysisDto> selectAnalysisBondsCorpList(Map<String, Object> params, int page, int rows) {
		RowBounds rowBounds = new RowBounds((page-1)*rows, rows);
		return sqlSessionTemplate.selectList(this.statement+"selectAnalysisBondsCorpList", params, rowBounds);
	}
}
