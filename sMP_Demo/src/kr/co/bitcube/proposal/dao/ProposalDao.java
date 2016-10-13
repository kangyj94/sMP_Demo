package kr.co.bitcube.proposal.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.RowBounds;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class ProposalDao {
	private final String statement = "proposal.";

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	/** 리스트 카운트 조회 */
	public int selectProposalListCnt(Map<String, Object> params) {
		return (Integer) sqlSessionTemplate.selectOne(this.statement+"selectProposalListCnt", params);
	}

	/** 리스트 조회 */
	public List<Map<String, Object>> selectProposalList( Map<String, Object> params, int page, int rows) {
		RowBounds rowBounds = new RowBounds((page-1)*rows, rows);
		return  sqlSessionTemplate.selectList(this.statement+"selectProposalList", params, rowBounds);  
	}

	/** 상태 코드값 조회 */
	public List<Map<String, Object>> selectProposalStat() {
		return  sqlSessionTemplate.selectList(this.statement+"selectProposalStat");  
	}

	/** 비회원 조회 */
	public Integer selectNonUserId(Map<String, Object> selParam) {
		return (Integer) sqlSessionTemplate.selectOne(this.statement+"selectNonUserId", selParam);
	}

	/** 제안 등록 */
	public void insertProposalInfo(Map<String, Object> params) {
		this.sqlSessionTemplate.insert(statement+"insertProposalInfo", params);
	}

	/** 공급사 사업자 번호 조회 */
	@SuppressWarnings("unchecked")
	public Map<String, Object> selectBusiNumForVen(Map<String, Object> selParam) {
		return (Map<String, Object>) sqlSessionTemplate.selectOne(this.statement+"selectBusiNumForVen", selParam);
	}

	/** 고객사 사업자 번호 조회 */
	@SuppressWarnings("unchecked")
	public Map<String, Object> selectBusiNumForBuy(Map<String, Object> selParam) {
		return (Map<String, Object>) sqlSessionTemplate.selectOne(this.statement+"selectBusiNumForBuy", selParam);
	}

	/** SMPNEW_MATERSUGGEST 테이블 업데이트함. */
	public void updateProposalInfo(Map<String, Object> params) {
		this.sqlSessionTemplate.update(this.statement+"updateProposalInfo", params);
	}

	/** 히스토리 저장. */
	public void insertProposalInfoHist(Map<String, Object> params) {
		this.sqlSessionTemplate.insert(statement+"insertProposalInfoHist", params);
	}

	/** 상태 변경을 하려는 제안의 상태 조회
	 * @param params */
	public Integer selectProposalStatus(Map<String, Object> params) {
		return (Integer) sqlSessionTemplate.selectOne(this.statement+"selectProposalStatus", params);
	}

	/** 제안정보 삭제. */
	public void delProposalInfo(Map<String, Object> params) {
		this.sqlSessionTemplate.delete(statement+"delProposalInfo", params);
	}

	/** 최종권한자인지 조회. */
	public String selectProposalFinalRole(Map<String, Object> params) {
		String tmpVal = sqlSessionTemplate.selectOne(this.statement+"selectProposalFinalRole", params);
		return tmpVal == null ? "N" : tmpVal;
	}

	/** 글 작성자인지 조회. */
	public String selectProposalIsWriter(Map<String, Object> params) {
		String tmpVal = sqlSessionTemplate.selectOne(this.statement+"selectProposalIsWriter", params);
		return tmpVal == null ? "N" : tmpVal;
	}
	/** 운영자인지 조회하여 리턴한다.*/
	public String selectProposalIsB2BAdm(Map<String, Object> params) {
		String tmpVal = sqlSessionTemplate.selectOne(this.statement+"selectProposalIsB2BAdm", params);
		return tmpVal == null ? "N" : tmpVal;
	}

	/** b2b 운영자 리스트를 조회하여 리턴한다.
	 * @param params */
	public List<Map<String, Object>> selectProposalB2BAdmList(Map<String, Object> params) {
		return  sqlSessionTemplate.selectList(this.statement+"selectProposalB2BAdmList", params);  
	}

	/** 일괄 엑셀 출력 */
	public List<Map<String, Object>> selectProposalListExcel( Map<String, Object> params) {
		return  sqlSessionTemplate.selectList(this.statement+"selectProposalList", params);  
	}

	/** 이메일 전송 자료 조회 */
	public Map<String, Object> selectProposalDetailInfoForEmail( Map<String, Object> params) {
		return sqlSessionTemplate.selectOne(this.statement+"selectProposalList", params);
	}

	public Map<String, Object> selectProposalCntText(Map<String, Object> params) {
		Map<String, Object> returnMap = sqlSessionTemplate.selectOne(this.statement+"selectProposalCnt", params);
		if(returnMap == null){
			returnMap = new HashMap<String, Object>();
			returnMap.put("ALL_CNT", 0);
			returnMap.put("ACCEPT_CNT", 0);
			returnMap.put("SUITABLE_Y_CNT", 0);
			returnMap.put("SUITABLE_N_CNT", 0);
			returnMap.put("APPR_Y_CNT", 0);
			returnMap.put("APPR_N_CNT", 0);
			returnMap.put("ACCEPT_WAITING_CNT", 0);
		}
		return returnMap;
	}
	
	/**
	 * 메일전송 리스트 조회
	 */
	public List<Map<String, Object>> selectProposalB2BAdmMailList(Map<String, Object> params) {
		return sqlSessionTemplate.selectList(this.statement+"selectProposalB2BAdmMailList", params);
	}

}
