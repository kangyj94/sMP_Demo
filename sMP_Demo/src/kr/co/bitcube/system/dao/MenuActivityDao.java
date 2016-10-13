package kr.co.bitcube.system.dao;

import java.util.List;
import java.util.Map;

import kr.co.bitcube.common.dto.ActivitiesDto;
import kr.co.bitcube.system.dto.MenuDto;

import org.apache.ibatis.session.RowBounds;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class MenuActivityDao {

	private final String statement = "system.menuActivity.";
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	
	
	public List<MenuDto> selectMenuList(Map<String, Object> params) {
		return sqlSessionTemplate.selectList(this.statement+"selectMenuList", params);
	}

	
	public List<MenuDto> selectSvcMenuList(Map<String, Object> params) {
		return sqlSessionTemplate.selectList(this.statement+"selectSvcMenuList", params);
	}

	public int selectMenuCdCnt(String menuCd) {
		return (Integer) sqlSessionTemplate.selectOne(this.statement+"selectMenuCdCnt", menuCd);
	}

	public void insertMenu(Map<String, Object> saveMap) {
		sqlSessionTemplate.insert(this.statement+"insertMenu", saveMap);
	}

	public void updateMenu(Map<String, Object> saveMap) {
		sqlSessionTemplate.update(this.statement+"updateMenu", saveMap);
	}

	public int selectActivityCnt(String menuId) {
		return (Integer) sqlSessionTemplate.selectOne(this.statement+"selectActivityCnt", menuId);
	}

	public int selectScopeCnt(String menuId) {
		return (Integer) sqlSessionTemplate.selectOne(this.statement+"selectScopeCnt", menuId);
	}

	public void deleteMenu(Map<String, Object> saveMap) {
		sqlSessionTemplate.delete(this.statement+"deleteMenu", saveMap);
	}

	
	public List<ActivitiesDto> selectActivityList(String srcMenuId) {
		return sqlSessionTemplate.selectList(this.statement+"selectActivityList", srcMenuId);
	}

	public int selectUnActivityListCnt(Map<String, Object> params) {
		return (Integer) sqlSessionTemplate.selectOne(this.statement+"selectUnActivityListCnt", params);
	}

	
	public List<ActivitiesDto> selectUnActivityList(Map<String, Object> params, int page, int rows) {
		RowBounds rowBounds = new RowBounds((page-1)*rows, rows);
		return sqlSessionTemplate.selectList(this.statement+"selectUnActivityList", params, rowBounds);
	}

	public void insertMenuActivity(Map<String, Object> saveMap) {
		sqlSessionTemplate.insert(this.statement+"insertMenuActivity", saveMap);
	}

	public void deleteMenuActivity(Map<String, Object> saveMap) {
		sqlSessionTemplate.delete(this.statement+"deleteMenuActivity", saveMap);
	}

	public void deleteMenuActivityScope(Map<String, Object> saveMap) {
		sqlSessionTemplate.delete(this.statement+"deleteMenuActivityScope", saveMap);
	}

	public int selectActivityCntByCd(String activityCd) {
		return (Integer) sqlSessionTemplate.selectOne(this.statement+"selectActivityCntByCd", activityCd);
	}

	public void insertActivity(Map<String, Object> saveMap) {
		sqlSessionTemplate.insert(this.statement+"insertActivity", saveMap);
	}

	public void updateActivity(Map<String, Object> saveMap) {
		sqlSessionTemplate.update(this.statement+"updateActivity", saveMap);
	}

	public void deleteActivity(Map<String, Object> saveMap) {
		sqlSessionTemplate.delete(this.statement+"deleteActivity", saveMap);
	}


	public Map<String, Object> selectMenuPath(Map<String, Object> params) {
		return sqlSessionTemplate.selectOne(this.statement+"selectMenuPath", params);
	}
}
