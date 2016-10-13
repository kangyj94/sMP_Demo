package kr.co.bitcube.quality.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import kr.co.bitcube.common.dto.RolesDto;
import kr.co.bitcube.organ.dto.AdminBorgsDto;
import kr.co.bitcube.organ.dto.BorgRoleDto;
import kr.co.bitcube.organ.dto.SmpBranchsDto;
import kr.co.bitcube.organ.dto.SmpDeliveryInfoDto;
import kr.co.bitcube.organ.dto.SmpUsersDto;
import kr.co.bitcube.organ.dto.SmpVendorsDto;

import org.apache.ibatis.session.RowBounds;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class QualityDao {
	private final String statement = "quality.";
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	/**
	 * 품질관리 업로드 파일 insert
	 * @param saveMap
	 */
	public void qualityFileSave(String kind, Map<String, Object> saveMap) {
		if("S".equals(kind)){
			sqlSessionTemplate.insert(this.statement+"standardFileSave", saveMap);			
		}else if("P".equals(kind)){
			sqlSessionTemplate.insert(this.statement+"processFileSave", saveMap);
		}
	}

	@SuppressWarnings("unchecked")
	public Map<String, Object> selectSourcingVendorExists( Map<String, Object> svMap) {
		return (Map<String, Object>) sqlSessionTemplate.selectOne(this.statement+"selectSourcingVendorExists", svMap);
	}

	public void updateSourcingVendor(Map<String, Object> pMap) {
		this.sqlSessionTemplate.update(statement+"updateSourcingVendor", pMap);
	}
	
	public void updateSourcingVendorLabTest(Map<String, Object> saveMap) {
		this.sqlSessionTemplate.update(statement+"updateSourcingVendorLabTest", saveMap);
	}

	public void updateSourcingVendorFieldTest(Map<String, Object> saveMap) {
		this.sqlSessionTemplate.update(statement+"updateSourcingVendorFieldTest", saveMap);
	}

	public void insertSourcingVendor(Map<String, Object> pMap) {
		this.sqlSessionTemplate.update(statement+"insertSourcingVendor", pMap);
	}
	
	public void updateSourcingFinalInfo(Map<String, Object> saveParamMap) {
		this.sqlSessionTemplate.update(statement+"updateSourcingFinalInfo", saveParamMap);
	}
	
	public void insertVoc(Map<String, Object> saveMap) {
		this.sqlSessionTemplate.insert(statement+"insertVoc", saveMap);
	}

	public void updateQualityVenStatus(Map<String, Object> saveMap) {
		this.sqlSessionTemplate.update(statement+"updateQualityVenStatus", saveMap);
	}

	/** smpqualityvendor 테이블 수정 : 분기별 컬럼에 시퀀스값 수정 */
	public void updateQualityvendorInfo(Map<String, Object> sqvMap) {
		this.sqlSessionTemplate.update(statement+"updateQualityvendorInfo", sqvMap);
		
	}
	/** 사용자가 입력했던 정보 입력 */
	public void insertQualityChkInfo(Map<String, Object> sqcMap) {
		this.sqlSessionTemplate.insert(statement+"insertQualityChkInfo", sqcMap);
		
	}

	/** 사용자가 입력했던 정보 수정. */
	public void updateQualityChkInfo(Map<String, Object> sqcMap) {
		this.sqlSessionTemplate.update(statement+"updateQualityChkInfo", sqcMap);
	}

	/** voc 처리 정보 저장 */
	public void saveVocProcInfo(Map<String, Object> saveMap) {
		this.sqlSessionTemplate.update(statement+"saveVocProcInfo", saveMap);
	}

	/** BMT 결재 승인/반려 */
	public void setSourcingApproval(HashMap<String, Object> saveMap) {
		this.sqlSessionTemplate.update(statement+"setSourcingApproval", saveMap);
	}

	/** 품질검사 결재 승인/반려 */
	public void setQualityApproval(HashMap<String, Object> saveMap) {
		this.sqlSessionTemplate.update(statement+"setQualityApproval", saveMap);
	}
	
	/** VOC 결재 승인/반려 */
	public void setVocApproval(HashMap<String, Object> saveMap) {
		this.sqlSessionTemplate.update(statement+"setVocApproval", saveMap);
	}

	public List<Map<String, Object>> selectSourcingTarget(String qualityYYYY) {
		return this.sqlSessionTemplate.selectList(statement+"selectSourcingTarget", qualityYYYY) ;
	}

	public void insertQuality(Map<String, Object> targetMap) {
		this.sqlSessionTemplate.update(statement+"insertQuality", targetMap);
	}
	
	public List<Map<String, Object>> selectSourcingVendorTarget(String qualityYYYY) {
		return this.sqlSessionTemplate.selectList(statement+"selectSourcingVendorTarget", qualityYYYY) ;
	}
	
	public void insertQualityVendor(Map<String, Object> targetMap) {
		this.sqlSessionTemplate.update(statement+"insertQualityVendor", targetMap);
	}

	public void insertSourcing(Map<String, Object> params) {
		this.sqlSessionTemplate.update(statement+"insertSourcing", params);
	}
}
