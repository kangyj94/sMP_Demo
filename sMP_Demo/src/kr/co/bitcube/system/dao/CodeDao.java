package kr.co.bitcube.system.dao;

import java.util.List;
import java.util.Map;

import kr.co.bitcube.common.dto.CodesDto;
import kr.co.bitcube.system.dto.CodeTypesDto;

import org.apache.ibatis.session.RowBounds;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class CodeDao {

	private final String statement = "system.code.";
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	
	public int selectCodeTypeListCnt(Map<String, Object> params) {
		return (Integer) sqlSessionTemplate.selectOne(this.statement+"selectCodeTypeListCnt", params);
	}

	
	public List<CodeTypesDto> selectCodeTypeList(Map<String, Object> params, int page, int rows) {
		RowBounds rowBounds = new RowBounds((page-1)*rows, rows);
		return  sqlSessionTemplate.selectList(this.statement+"selectCodeTypeList", params, rowBounds);
	}

	
	public List<CodesDto> selectCodeList(Map<String, Object> params) {
		return sqlSessionTemplate.selectList(this.statement+"selectCodeList", params);
	}

	public int selectCodeTypeCdCnt(String codeTypeCd) {
		return (Integer) sqlSessionTemplate.selectOne(this.statement+"selectCodeTypeCdCnt", codeTypeCd);
	}

	public void insertCodeType(Map<String, Object> saveMap) {
		sqlSessionTemplate.insert(this.statement+"insertCodeType", saveMap);
	}

	public void updateCodeType(Map<String, Object> saveMap) {
		sqlSessionTemplate.update(this.statement+"updateCodeType", saveMap);
	}

	public int selectCodesCnt(String codeTypeId) {
		return (Integer) sqlSessionTemplate.selectOne(this.statement+"selectCodesCnt", codeTypeId);
	}

	public void deleteCodeType(Map<String, Object> saveMap) {
		sqlSessionTemplate.delete(this.statement+"deleteCodeType", saveMap);
	}

	public void insertCodes(Map<String, Object> saveMap) {
		sqlSessionTemplate.insert(this.statement+"insertCodes", saveMap);
	}

	public void updateCodes(Map<String, Object> saveMap) {
		sqlSessionTemplate.update(this.statement+"updateCodes", saveMap);
	}

	public void deleteCodes(Map<String, Object> saveMap) {
		sqlSessionTemplate.delete(this.statement+"deleteCodes", saveMap);
	}

	public int selectDupliCodesCnt(Map<String, Object> params) {
		return (Integer) sqlSessionTemplate.selectOne(this.statement+"selectDupliCodesCnt", params);
	}
}
