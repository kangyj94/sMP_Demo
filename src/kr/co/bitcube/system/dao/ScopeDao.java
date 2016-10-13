package kr.co.bitcube.system.dao;

import java.util.List;
import java.util.Map;

import kr.co.bitcube.system.dto.MenuActivityDto;
import kr.co.bitcube.system.dto.ScopesDto;

import org.apache.log4j.Logger;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class ScopeDao {

	@SuppressWarnings("unused")
	private Logger logger = Logger.getLogger(getClass());
	
	private final String statement = "system.scope.";
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	
	public List<ScopesDto> getScopeList(Map<String, Object> params) {
		return sqlSessionTemplate.selectList(this.statement+"selectScopeList", params);
	}

	public int selectScopeCnt(Map<String, Object> saveMap) {
		return (Integer) sqlSessionTemplate.selectOne(this.statement+"selectScopeCnt", saveMap);
	}

	public void insertScope(Map<String, Object> saveMap) {
		sqlSessionTemplate.insert(this.statement+"insertScope", saveMap);
	}

	public void updateScope(Map<String, Object> saveMap) {
		sqlSessionTemplate.update(this.statement+"updateScope", saveMap);
	}

	public void deleteScope(Map<String, Object> saveMap) {
		sqlSessionTemplate.delete(this.statement+"deleteScope", saveMap);
	}

	
	public List<MenuActivityDto> getScopeMenuActivityList( Map<String, Object> params) {
		return sqlSessionTemplate.selectList(this.statement+"selectScopeMenuActivityList", params);
	}

	public void insertScopeActivity(Map<String, Object> saveMap) {
		sqlSessionTemplate.insert(this.statement+"insertScopeActivity", saveMap);
	}

	public void deleteScopeActivity(Map<String, Object> saveMap) {
		sqlSessionTemplate.delete(this.statement+"deleteScopeActivity", saveMap);
	}
	
}
