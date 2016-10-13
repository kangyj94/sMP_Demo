package kr.co.bitcube.system.dao;

import java.util.List;
import java.util.Map;

import kr.co.bitcube.common.dto.BorgDto;
import kr.co.bitcube.common.dto.UserDto;
import kr.co.bitcube.organ.dto.SmpUsersDto;

import org.apache.ibatis.session.RowBounds;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class BorgDao {

	private final String statement = "system.borg.";
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	
	public List<BorgDto> selectBorgTreeList(Map<String, Object> searchMap) {
		return  sqlSessionTemplate.selectList(this.statement+"selectBorgTreeList", searchMap);
	}

	public int selectBorgCdCnt(String borgCd) {
		return (Integer) sqlSessionTemplate.selectOne(this.statement+"selectBorgCdCnt", borgCd);
	}

	public void insertBorg(Map<String, Object> saveMap) {
		sqlSessionTemplate.insert(this.statement+"insertBorg", saveMap);
	}

	public void updateBorg(Map<String, Object> saveMap) {
		sqlSessionTemplate.update(this.statement+"updateBorg", saveMap);
	}

	public int selectSubBorgCnt(String borgId) {
		return (Integer) sqlSessionTemplate.selectOne(this.statement+"selectSubBorgCnt", borgId);
	}

	public void deleteBorg(Map<String, Object> saveMap) {
		sqlSessionTemplate.delete(this.statement+"deleteBorg", saveMap);
	}

	public int selectBorgUserListCnt(Map<String, Object> params) {
		return (Integer) sqlSessionTemplate.selectOne(this.statement+"selectBorgUserListCnt", params);
	}

	
	public List<UserDto> selectBorgUserList(Map<String, Object> params, int page, int rows) {
		RowBounds rowBounds = new RowBounds((page-1)*rows, rows);
		return sqlSessionTemplate.selectList(this.statement+"selectBorgUserList", params, rowBounds);
	}

	
	public List<BorgDto> selectManagedBorgList(Map<String, Object> params) {
		return sqlSessionTemplate.selectList(this.statement+"selectManagedBorgList", params);
	}

	public void insertAdminBorgs(Map<String, Object> saveMap) {
		sqlSessionTemplate.insert(this.statement+"insertAdminBorgs", saveMap);
	}

	public void deleteAdminBorgs(Map<String, Object> saveMap) {
		sqlSessionTemplate.delete(this.statement+"deleteAdminBorgs", saveMap);
	}
	
	public int selectSystemUserManagerListCnt(Map<String, Object> params) {
		return (Integer) sqlSessionTemplate.selectOne(this.statement+"selectSystemUserManagerListCnt", params);
	}
	
	
	public List<Map<String, Object>> selectSystemUserManagerList(Map<String, Object> params, int page, int rows) {
		RowBounds rowBounds = new RowBounds((page-1)*rows, rows);
		return  sqlSessionTemplate.selectList(this.statement+"selectSystemUserManagerList", params, rowBounds);
	}

	public int selectSystemIfBorgsListCnt(Map<String, Object> params) {
		return (Integer) sqlSessionTemplate.selectOne(this.statement+"selectSystemIfBorgsListCnt", params);
	}

	
	public List<Map<String, Object>> selectSystemIfBorgsList(Map<String, Object> params, int page, int rows) {
		RowBounds rowBounds = new RowBounds((page-1)*rows, rows);
		return sqlSessionTemplate.selectList(this.statement+"selectSystemIfBorgsList", params, rowBounds);
	}

	public void updateIfBorgsHistory(Map<String, Object> saveMap) {
		sqlSessionTemplate.update(this.statement+"updateIfBorgsHistory", saveMap);
	}

	public int selectContractCnt(Map<String, Object> params) {
		return (Integer) sqlSessionTemplate.selectOne(this.statement+"selectContractCnt", params);
	}

	public List<Map<String, Object>> selectContractList(Map<String, Object> params, int page, int rows) {
		RowBounds rowBounds = new RowBounds((page-1)*rows, rows);
		return sqlSessionTemplate.selectList(this.statement+"selectContractList",params, rowBounds);
	}

	public void insertCommodityContract(Map<String, Object> saveMap) {
		sqlSessionTemplate.insert(this.statement+"insertCommodityContract", saveMap);
	}

	public List<Map<String, Object>> selectCommodityContractList() {
		return sqlSessionTemplate.selectList(this.statement+"selectCommodityContractList");
	}

	public Map<String, Object> selectCommodityContractDetail(Map<String, Object> params) {
		return sqlSessionTemplate.selectOne(this.statement+"selectCommodityContractDetail", params);
	}

	public void updateCommodityContract(Map<String, Object> saveMap) {
		sqlSessionTemplate.update(this.statement+"updateCommodityContract", saveMap);
	}

	public void deleteCommodityContract(Map<String, Object> saveMap) {
		sqlSessionTemplate.delete(this.statement+"deleteCommodityContract", saveMap);
	}

	public List<Map<String, Object>> selectCommodityContractListPopup(Map<String, Object> params) {
		return sqlSessionTemplate.selectList(this.statement+"selectCommodityContractListPopup", params);
	}

	public List<Map<String, Object>> selectGetCommodityContractView(Map<String, Object> params) {
		return sqlSessionTemplate.selectList(this.statement+"selectGetCommodityContractView", params);
	}

	public void insertCommodityContractList(Map<String, Object> tempMap) {
		sqlSessionTemplate.insert(this.statement+"insertCommodityContractList", tempMap);
	}

	public Map<String, Object> selectCommodityContractListValidation(Map<String, Object> tempMap) {
		return sqlSessionTemplate.selectOne(this.statement+"selectCommodityContractListValidation", tempMap);
	}

	public String selectCommodityContractListDate(Map<String, Object> params) {
		return sqlSessionTemplate.selectOne(this.statement+"selectCommodityContractListDate", params);
	}

	public void updateCommodityContractList(Map<String, Object> contractMap) {
		sqlSessionTemplate.update(this.statement+"updateCommodityContractList", contractMap);
	}
	
	public void insertCommodityContractClient(Map<String, Object> tempMap) {
		sqlSessionTemplate.insert(this.statement+"insertCommodityContractClient", tempMap);
	}

	public String selectUserPassword(Map<String, Object> params) {
		return sqlSessionTemplate.selectOne(this.statement+"selectUserPassword", params);
	}

	public void updateCorporationInfo(Map<String, Object> params) {
		sqlSessionTemplate.update(this.statement+"updateCorporationInfo", params);
	}
}
