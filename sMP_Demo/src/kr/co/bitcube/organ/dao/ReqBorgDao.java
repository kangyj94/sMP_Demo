package kr.co.bitcube.organ.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import kr.co.bitcube.common.dto.RolesDto;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class ReqBorgDao {
	private final String statement = "req_borg.";
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	public void insertReqBranch(Map<String, Object> paramMap) {
		sqlSessionTemplate.insert(this.statement+"insertReqBranch", paramMap);
	}

	public void insertReqVendor(Map<String, Object> paramMap) {
		sqlSessionTemplate.insert(this.statement+"insertReqVendor", paramMap);
	}

	public void insertSmpUser(Map<String, Object> paramMap) {
		sqlSessionTemplate.insert(this.statement+"insertSmpUser", paramMap);
	}

	public void insertDeliveryInfo(Map<String, Object> paramMap) {
		sqlSessionTemplate.insert(this.statement+"insertDeliveryInfo", paramMap);
	}
	
	public List<RolesDto> selectRolesList (HashMap <String, Object> paramMap) {
		return  sqlSessionTemplate.selectList(this.statement+"selectRolesList", paramMap);
	}
	
	public void insertBorgsUsers(Map<String, Object> paramMap) {
		sqlSessionTemplate.insert(this.statement+"insertBorgsUsers", paramMap);
	}

	public void insertUserRoles(Map<String, Object> paramMap) {
		sqlSessionTemplate.insert(this.statement+"insertUserRoles", paramMap);
	}
	
	public int reqBorgDupCheck(String clientCd) {
		return (Integer)sqlSessionTemplate.selectOne(this.statement+"reqBorgDupCheck", clientCd);
	}

	public int loginIdDupCheck(String loginId) {
		return (Integer)sqlSessionTemplate.selectOne(this.statement+"loginIdDupCheck", loginId);
	}
}
