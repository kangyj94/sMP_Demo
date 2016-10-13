package kr.co.bitcube.system.dao;

import java.util.List;
import java.util.Map;

import kr.co.bitcube.system.dto.MenuActivityDto;
import kr.co.bitcube.system.dto.RoleDto;
import kr.co.bitcube.system.dto.RoleMemberDto;
import kr.co.bitcube.system.dto.ScopesDto;

import org.apache.ibatis.session.RowBounds;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class RoleDao {

	private final String statement = "system.role.";
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	
	
	public List<RoleDto> selectRoleList(Map<String, Object> params) {
		return  sqlSessionTemplate.selectList(this.statement+"selectRoleList", params);
	}

	
	public List<ScopesDto> selectRoleScopeList(Map<String, Object> params) {
		return  sqlSessionTemplate.selectList(this.statement+"selectRoleScopeList", params);
	}

	public int selectRoleCnt(Map<String, Object> saveMap) {
		return (Integer) sqlSessionTemplate.selectOne(this.statement+"selectRoleCnt", saveMap);
	}

	public void insertRole(Map<String, Object> saveMap) {
		sqlSessionTemplate.insert(this.statement+"insertRole", saveMap);
	}

	public void updateRole(Map<String, Object> saveMap) {
		sqlSessionTemplate.update(this.statement+"updateRole", saveMap);
	}

	public void deleteRole(Map<String, Object> saveMap) {
		sqlSessionTemplate.delete(this.statement+"deleteRole", saveMap);
	}

	public void deleteRoleScope(Map<String, Object> saveMap) {
		sqlSessionTemplate.delete(this.statement+"deleteRoleScope", saveMap);
	}

	public void insertRoleScope(Map<String, Object> saveMap) {
		sqlSessionTemplate.insert(this.statement+"insertRoleScope", saveMap);
	}

	
	public List<ScopesDto> selectScopeListByRoleId(Map<String, Object> params) {
		return  sqlSessionTemplate.selectList(this.statement+"selectScopeListByRoleId", params);
	}

	
	public List<MenuActivityDto> selectRoleMenuList(Map<String, Object> params) {
		return sqlSessionTemplate.selectList(this.statement+"selectRoleMenuList", params);
	}

	public int selectRoleMemberListCnt(Map<String, Object> params) {
		return (Integer) sqlSessionTemplate.selectOne(this.statement+"selectRoleMemberListCnt", params);
	}

	
	public List<RoleMemberDto> selectRoleMemberList(Map<String, Object> params, int page, int rows) {
//		params.put("page", page);
//		params.put("rows", rows);
//		return (List<RoleMemberDto>)sqlSessionTemplate.selectList(this.statement+"selectRoleMemberList", params);
		RowBounds rowBounds = new RowBounds((page-1)*rows, rows);
		return sqlSessionTemplate.selectList(this.statement+"selectRoleMemberList", params, rowBounds);
	}

	public int selectRoleUserCnt(Map<String, Object> params) {
		return (Integer) sqlSessionTemplate.selectOne(this.statement+"selectRoleUserCnt", params);
	}

	public void insertUserRole(Map<String, Object> saveMap) {
		sqlSessionTemplate.insert(this.statement+"insertUserRole", saveMap);
	}

	public void updateUserRole(Map<String, Object> saveMap) {
		sqlSessionTemplate.update(this.statement+"updateUserRole", saveMap);
	}

	public void deleteUserRole(Map<String, Object> saveMap) {
		sqlSessionTemplate.delete(this.statement+"deleteUserRole", saveMap);
	}
}
