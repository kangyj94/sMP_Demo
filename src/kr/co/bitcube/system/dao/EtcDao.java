package kr.co.bitcube.system.dao;

import kr.co.bitcube.system.dto.CodeTypesDto;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class EtcDao {
	
	private final String statement = "common.etc.";
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	
	public CodeTypesDto selectCodeTypesInfo(String srcCodeTypeId) {
		return sqlSessionTemplate.selectOne(this.statement+"selectCodeTypesInfo", srcCodeTypeId);
	}
}
