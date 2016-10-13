package kr.co.bitcube.organ.dao;

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
public class OrganDao {
	private final String statement = "organ.";
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	public SmpBranchsDto selectOneBranchs(String branchId) {
		return (SmpBranchsDto) sqlSessionTemplate.selectOne(this.statement+"selectOneBranchs", branchId);
	}

	
	public List<SmpBranchsDto> selectReqBranchList(HashMap<String, Object> paramMap, int page, int rows) {
		RowBounds rowBounds = new RowBounds((page-1)*rows, rows);
		return  sqlSessionTemplate.selectList(this.statement+"selectReqBranchList", paramMap, rowBounds);
	}

	
	public List<SmpVendorsDto> selectReqVendorList(HashMap<String, Object> paramMap, int page, int rows) {
		RowBounds rowBounds = new RowBounds((page-1)*rows, rows);
		return  sqlSessionTemplate.selectList(this.statement+"selectReqVendorList", paramMap, rowBounds);
	}
	
	public int selectReqClientListCnt(HashMap<String, Object> paramMap) {
		return (Integer) sqlSessionTemplate.selectOne(this.statement+"selectReqClientListCnt", paramMap);
	}	

	public int selectReqVendorListCnt(HashMap<String, Object> paramMap) {
		return (Integer) sqlSessionTemplate.selectOne(this.statement+"selectReqVendorListCnt", paramMap);
	}	
	
	public SmpVendorsDto selectOneVendors(String vendorId) {
		return (SmpVendorsDto) sqlSessionTemplate.selectOne(this.statement+"selectOneVendors", vendorId);
	}
	
	
	public List<SmpDeliveryInfoDto> selectDeliveryInfoList(String branchId) {
		return  sqlSessionTemplate.selectList(this.statement+"selectDeliveryInfoList", branchId);
	}

	
	public List<BorgRoleDto> selectDefaultBorgRole(Map<String, Object> params) {
		return  sqlSessionTemplate.selectList(this.statement+"selectDefaultBorgRole", params);
	}

	public SmpUsersDto selectUserInfo(String vendorId) {
		return (SmpUsersDto) sqlSessionTemplate.selectOne(this.statement+"selectUserInfo", vendorId);
	}

	
	public List<AdminBorgsDto> getAdminborgs(String clientId) {
		return sqlSessionTemplate.selectList(this.statement+"selectAdminborgs", clientId);
	}
	
	public void insertAdminBorgs(HashMap<String, Object> saveMap) {
		sqlSessionTemplate.insert(this.statement+"insertAdminBorgs", saveMap);
	}
	
	public int selectAdminborgsDupCheck(HashMap<String, Object> saveMap) {
		return (Integer)sqlSessionTemplate.selectOne(this.statement+"selectAdminborgsDupCheck", saveMap);
	}

	public void deleteAdminBorgs(String adminBorgId) {
		sqlSessionTemplate.delete(this.statement+"deleteAdminBorgs", adminBorgId);
	}

	public void deleteBorgsUserRole(HashMap<String, Object> saveMap) {
		sqlSessionTemplate.delete(this.statement+"deleteBorgsUserRole", saveMap);
	}

	/**
	 * 사업장조회 리스트의 카운트 조회하는 메소드
	 * @param params
	 * @return
	 */ 
	public int selectOrganBranchListCnt(Map<String, Object> params) {
		return (Integer) sqlSessionTemplate.selectOne(this.statement+"selectOrganBranchListCnt", params);
	}
	
	/**
	 * 공급사조회 리스트의 카운트 조회하는 메소드
	 * @param params
	 * @return
	 */ 
	public int selectOrganVendorListCnt(Map<String, Object> params) {
		return (Integer) sqlSessionTemplate.selectOne(this.statement+"selectOrganVendorListCnt", params);
	}
	
	/**
	 * 사용자조회 리스트의 카운트 조회하는 메소드
	 * @param params
	 * @return
	 */ 
	public int selectOrganUserListCnt(Map<String, Object> params) {
		return (Integer) sqlSessionTemplate.selectOne(this.statement+"selectOrganUserListCnt", params);
	}
	
	/**
	 * 공급사사용자조회 리스트의 카운트 조회하는 메소드
	 * @param params
	 * @return
	 */ 
	public int selectOrganVendorUserListCnt(Map<String, Object> params) {
		return (Integer) sqlSessionTemplate.selectOne(this.statement+"selectOrganVendorUserListCnt", params);
	}
	
	/**
	 * 사업장조회 리스트를 조회하여 반환하는 메소드
	 * @param params
	 * @param page(페이지번호)
	 * @param rows(페이지 Row 개수)
	 * @return
	 */
	
	public List<SmpBranchsDto> selectOrganBranchList(Map<String, Object> params, int page, int rows) {
		RowBounds rowBounds = new RowBounds((page-1)*rows, rows);
		return  sqlSessionTemplate.selectList(this.statement+"selectOrganBranchList", params, rowBounds);
	}
	
	/**
	 * 공급사조회 리스트를 조회하여 반환하는 메소드
	 * @param params
	 * @param page(페이지번호)
	 * @param rows(페이지 Row 개수)
	 * @return
	 */
	
	public List<SmpVendorsDto> selectOrganVendorList(Map<String, Object> params, int page, int rows) {
		RowBounds rowBounds = new RowBounds((page-1)*rows, rows);
		return  sqlSessionTemplate.selectList(this.statement+"selectOrganVendorList", params, rowBounds);
	}
	
	/**
	 * 사용자조회 리스트를 조회하여 반환하는 메소드
	 * @param params
	 * @param page(페이지번호)
	 * @param rows(페이지 Row 개수)
	 * @return
	 */
	
	public List<SmpUsersDto> selectOrganUserList(Map<String, Object> params, int page, int rows) {
		RowBounds rowBounds = new RowBounds((page-1)*rows, rows);
		return  sqlSessionTemplate.selectList(this.statement+"selectOrganUserList", params, rowBounds);
	}
	
	/**
	 * 공급사사용자조회 리스트를 조회하여 반환하는 메소드
	 * @param params
	 * @param page(페이지번호)
	 * @param rows(페이지 Row 개수)
	 * @return
	 */
	
	public List<SmpUsersDto> selectOrganVendorUserList(Map<String, Object> params, int page, int rows) {
		RowBounds rowBounds = new RowBounds((page-1)*rows, rows);
		if(rows==0) return  sqlSessionTemplate.selectList(this.statement+"selectOrganVendorUserList", params);
		else return  sqlSessionTemplate.selectList(this.statement+"selectOrganVendorUserList", params, rowBounds);
	}
	
	public void updateBranchReq(HashMap<String, Object> saveMap) {
		sqlSessionTemplate.update(this.statement+"updateBranchReq", saveMap);
	}

	public SmpBranchsDto selectOneReqBranchs(String branchId) {
		return (SmpBranchsDto) sqlSessionTemplate.selectOne(this.statement+"selectOneReqBranchs", branchId);
	}

	public SmpVendorsDto selectOneReqVendors(String branchId) {
		return (SmpVendorsDto) sqlSessionTemplate.selectOne(this.statement+"selectOneReqVendors", branchId);
	}
	
	public void updateSmpUser(Map<String, Object> saveMap) {
		sqlSessionTemplate.update(this.statement+"updateSmpUser", saveMap);
	}

	public void deleteDeliveryInfo(HashMap<String, Object> saveMap) {
		sqlSessionTemplate.delete(this.statement+"deleteDeliveryInfo", saveMap);
	}

	public void insertDeliveryInfo(Map<String, Object> saveMap) {
		sqlSessionTemplate.insert(this.statement+"insertDeliveryInfo", saveMap);
	}

	public void updateVendorReq(HashMap<String, Object> saveMap) {
		sqlSessionTemplate.update(this.statement+"updateVendorReq", saveMap);
	}

	public void reqBranchRegisterCdCancel(Map<String, Object> saveMap) {
		sqlSessionTemplate.update(this.statement+"reqBranchRegisterCdCancel", saveMap);
	}

	public void deleteReqBranch(String branchId) {
		sqlSessionTemplate.delete(this.statement+"deleteReqBranch", branchId);
	}
	
	public void deleteSmpBorgsUsersRoles(Map<String, Object> saveMap) {
		sqlSessionTemplate.delete(this.statement+"deleteSmpBorgsUsersRoles", saveMap);
	}
	
	public void deleteSmpBorgsUsers(Map<String, Object> saveMap) {
		sqlSessionTemplate.delete(this.statement+"deleteSmpBorgsUsers", saveMap);
	}
	
	public void deleteSmpUsers(Map<String, Object> saveMap) {
		sqlSessionTemplate.delete(this.statement+"deleteSmpUsers", saveMap);
	}
	
	public void deleteDeliveryInfo(Map<String, Object> saveMap) {
		sqlSessionTemplate.delete(this.statement+"deleteDeliveryInfoToCancel", saveMap);
	}
	
	public void deleteAdminBorgs(Map<String, Object> saveMap) {
		sqlSessionTemplate.delete(this.statement+"deleteAdminBorgsToCancel", saveMap);
	}

	public void insertSmpBorgs(Map<String, Object> saveMap) {
		sqlSessionTemplate.insert(this.statement+"insertSmpBorgs", saveMap);
	}

	public void updateSmpUsersIsUse(Map<String, Object> saveMap) {
		sqlSessionTemplate.update(this.statement+"updateSmpUsersIsUse", saveMap);
	}

	public void insertSmpBranchs(Map<String, Object> saveMap) {
		sqlSessionTemplate.insert(this.statement+"insertSmpBranchs", saveMap);
	}

	public void insertSmpVendors(Map<String, Object> saveMap) {
		sqlSessionTemplate.insert(this.statement+"insertSmpVendors", saveMap);
	}
	
	public void insertSmpReceiveInfo(Map<String, Object> saveMap) {
		sqlSessionTemplate.insert(this.statement+"insertSmpReceiveInfo", saveMap);
	}
	
	public void reqVendorRegisterCdCancel(Map<String, Object> saveMap) {
		sqlSessionTemplate.update(this.statement+"reqVendorRegisterCdCancel", saveMap);
	}

	public void deleteReqVendor(String vendorId) {
		sqlSessionTemplate.delete(this.statement+"deleteReqVendor", vendorId);
	}

	
	public List<SmpUsersDto> selectUsersMobile(Map<String, Object> params) {
		return  sqlSessionTemplate.selectList(this.statement+"selectUsersMobile", params);
	}
	
	public SmpBranchsDto selectBranchsDetail(String branchId) {
		return (SmpBranchsDto)sqlSessionTemplate.selectOne(this.statement+"selectBranchsDetail", branchId);
	}

	public void updateSmpBranchs(Map<String, Object> saveMap) {
		sqlSessionTemplate.update(this.statement+"updateSmpBranchs", saveMap);
	}

	public void updateSmpBorgs(Map<String, Object> saveMap) {
		sqlSessionTemplate.update(this.statement+"updateSmpBorgs", saveMap);
	}
	
	
	public List<SmpUsersDto> selectBorgUsers(String borgId) {
		return  sqlSessionTemplate.selectList(this.statement+"selectBorgUsers", borgId);
	}

	public void insertBorgsUsers(Map<String, Object> saveMap) {
		sqlSessionTemplate.insert(this.statement+"insertBorgsUsers", saveMap);
	}
	
	public SmpBranchsDto organBranchSearch(String clientId) {
		return (SmpBranchsDto)sqlSessionTemplate.selectOne(this.statement+"organBranchSearch", clientId);
	}
	
	public void insertRegSmpBranchs(Map<String, Object> saveMap) {
		sqlSessionTemplate.insert(this.statement+"insertRegSmpBranchs", saveMap);
	}

	public void insertSmpUser(Map<String, Object> saveMap) {
		sqlSessionTemplate.insert(this.statement+"insertSmpUser", saveMap);
	}

	public void insertBorgsUsersRoles(Map<String, Object> saveMap) {
		sqlSessionTemplate.insert(this.statement+"insertBorgsUsersRoles", saveMap);
	}
	
	public String getBranchCdSeq(String clientCd) {
		return (String)sqlSessionTemplate.selectOne(this.statement+"getBranchCdSeq", clientCd);
	}
	
	public RolesDto selectSmpRoles(String borgId){
		return (RolesDto)sqlSessionTemplate.selectOne(this.statement+"selectSmpRoles", borgId);
	}
	
	public SmpUsersDto selectOrganUserDetail(Map<String, Object> params) {
		return (SmpUsersDto)sqlSessionTemplate.selectOne(this.statement+"selectOrganUserDetail", params);
	}
	
	public void updateUserRolesDefault (Map<String, Object> saveMap) {
		sqlSessionTemplate.update(this.statement+"updateUserRolesDefault", saveMap);
	}

	public void updateUserRolesNoDefault (Map<String, Object> saveMap) {
		sqlSessionTemplate.update(this.statement+"updateUserRolesNoDefault", saveMap);
	}

	public void updateSmpReceiveInfo (Map<String, Object> saveMap) {
		sqlSessionTemplate.update(this.statement+"updateSmpReceiveInfo", saveMap);
	}

	public int smpReceiveInfoCnt (String userId) {
		return (Integer)sqlSessionTemplate.selectOne(this.statement+"smpReceiveInfoCnt", userId);
	}
	
	public RolesDto selectSmpBorgsUserRoles(String svcTypeCd) {
		return (RolesDto) sqlSessionTemplate.selectOne(this.statement+"selectSmpBorgsUserRoles", svcTypeCd);
	}
	
	public void insertRegSmpVendors(Map<String, Object> saveMap) {
		sqlSessionTemplate.insert(this.statement+"insertRegSmpVendors", saveMap);
	}
	
	public SmpVendorsDto selectVendorsDetail(String vendorId) {
		return (SmpVendorsDto)sqlSessionTemplate.selectOne(this.statement+"selectVendorsDetail", vendorId);
	}
	
	public void updateSmpVendorsDetail(Map<String, Object> saveMap) {
		sqlSessionTemplate.update(this.statement+"updateSmpVendorsDetail", saveMap);
	}
	
	public SmpUsersDto selectVendorUserDetail (Map<String, Object> params) {
		return (SmpUsersDto)sqlSessionTemplate.selectOne(this.statement+"selectVendorUserDetail", params); 
	}

	public String getClientCdByClientId(String clientId) {
		return (String) sqlSessionTemplate.selectOne(this.statement+"getClientCdByClientId", clientId);
	}
	
	public void insertSmpDirectInfo(Map<String, Object> saveMap) {
		sqlSessionTemplate.insert(this.statement+"insertSmpDirectInfo", saveMap);
	}

	public void deleteSmpDirectInfo(Map<String, Object> saveMap) {
		sqlSessionTemplate.insert(this.statement+"deleteSmpDirectInfo", saveMap);
	}

	
	public List<SmpUsersDto> selectSmpDirectInfoList (Map<String, Object> params) {
		return sqlSessionTemplate.selectList(this.statement+"selectSmpDirectInfoList", params); 
	}

	public void updateSmpBorgsIsUse(Map<String, Object> saveMap) {
		sqlSessionTemplate.insert(this.statement+"updateSmpBorgsIsUse", saveMap);
	}

	public int getMrordmCount (Map<String, Object> params) {
		return (int)sqlSessionTemplate.selectOne(this.statement+"getMrordmCount", params); 
	}

	
	public List<SmpUsersDto> getSmpBorgsUsersByUserId (String userId) {
		return sqlSessionTemplate.selectList(this.statement+"getSmpBorgsUsersByUserId", userId); 
	}
	
	public void setSmpBorgsUsersIsDefault(Map<String, Object> saveMap) {
		sqlSessionTemplate.update(this.statement+"setSmpBorgsUsersIsDefault", saveMap);
	}

	public void insertIfBorgsHist(Map<String, Object> saveMap) {
		sqlSessionTemplate.update(this.statement+"insertIfBorgsHist", saveMap);
	}


	public void updateReqSmpBranchs(Map<String, Object> saveMap) {
		sqlSessionTemplate.update(this.statement+"updateReqSmpBranchs",saveMap);
	}
	
	public int selectSharpMailVendorCount(Map<String, Object> params) {
		return (Integer)sqlSessionTemplate.selectOne(this.statement+"selectSharpMailVendorCount", params);
	}

	public int selectSharpMailBranchCount(Map<String, Object> params) {
		return (Integer)sqlSessionTemplate.selectOne(this.statement+"selectSharpMailBranchCount", params);
	}


	public void updateVendorSharpMail(Map<String, Object> saveMap) {
		sqlSessionTemplate.update(this.statement+"updateVendorSharpMail", saveMap);
	}


	public void updateBranchsSharpMail(Map<String, Object> saveMap) {
		sqlSessionTemplate.update(this.statement+"updateBranchsSharpMail", saveMap);
	}

	
	public String selectClientNm(String clientId) {
		return sqlSessionTemplate.selectOne(this.statement+"selectClientNm", clientId);
	}


	public String selectMenuCd(String menuId) {
		return sqlSessionTemplate.selectOne(this.statement+"selectMenuCd", menuId);
	}
	
	public void updateReqSmpVendors(Map<String, Object> saveMap) {
		sqlSessionTemplate.update(this.statement+"updateReqSmpVendors", saveMap);
	}


	public void updateAllSmpBranchsPressentNm(Map<String, Object> saveMap) {
		sqlSessionTemplate.update(this.statement+"updateAllSmpBranchsPressentNm", saveMap);
	}


	public List<Map<String,Object>> selectUserListByBranchId(Map<String, Object> paramMap) {
		return  sqlSessionTemplate.selectList(this.statement+"selectCorporationBranchesUsersList", paramMap);
	}


	public void updateUserStatusByUserId(String userIdTemp) {
		sqlSessionTemplate.update(this.statement+"updateUserStatusByUserId", userIdTemp);
	}
	
	
	public void updateCorporationInfo(Map<String, Object> params) {
		sqlSessionTemplate.update(this.statement+"updateCorporationInfo", params);
	}


	/** 법인 이하 사업장 조회 */
	public List<Map<String, Object>> selectCorporationBranches( Map<String, Object> params) {
		return  sqlSessionTemplate.selectList(this.statement+"selectCorporationBranches", params);
	}


	/** 사업장 상태 변경 */
	public void updateBranchsClose(Map<String, Object> branchesMap) {
		sqlSessionTemplate.update(this.statement+"updateBranchsClose", branchesMap);
	}


	/** 사업장 사용자 조회 */
	public List<Map<String, Object>> selectCorporationBranchesUsersList( Map<String, Object> params) {
		return  sqlSessionTemplate.selectList(this.statement+"selectCorporationBranchesUsersList", params);
	}


	public void updateBranchsPrepay(Map<String, Object> branchesMap) {
		sqlSessionTemplate.update(this.statement+"updateBranchsPrepay", branchesMap);
	}


	public int selectBorgCdCnt(String string) {
		return (Integer) sqlSessionTemplate.selectOne(this.statement+"selectBorgCdCnt", string);
	}


	public void insertClientInfo(Map<String, Object> saveMap) {
		sqlSessionTemplate.insert(this.statement+"insertClientInfo", saveMap);
	}


	public SmpBranchsDto organBranchSearchForReg(String clientId) {
		return (SmpBranchsDto)sqlSessionTemplate.selectOne(this.statement+"organBranchSearchForReg", clientId);
	}


	public void updateBranchsLimit(Map<String, Object> branchesMap) {
		sqlSessionTemplate.update(this.statement+"updateBranchsLimit", branchesMap);
	}


	public List<Map<String, Object>> selectBranchEndUserList(Map<String, Object> tempParamMap) {
		return sqlSessionTemplate.selectList(this.statement+"selectBranchEndUserList", tempParamMap);
	}

	public void updateSmpBorgsNm(HashMap<String, Object> saveMap) throws Exception{
		sqlSessionTemplate.update(this.statement+"updateSmpBorgsNm", saveMap);
	}
	
	public void updateSmpBranchsNm(HashMap<String, Object> saveMap) throws Exception{
		sqlSessionTemplate.update(this.statement+"updateSmpBranchsNm", saveMap);
	}


	public List<Map<String, Object>> selectVenEvaluationList(Map<String, Object> params) {
		return sqlSessionTemplate.selectList(this.statement+"selectVenEvaluationList", params);
	}


	public List<Map<String, Object>> selectVenEvaluationStats(Map<String, Object> params) {
		return sqlSessionTemplate.selectList(this.statement+"selectVenEvaluationStats", params);
	}
	public List<Map<String, Object>> selectVenEvaluationStatsExcel(Map<String, Object> params) {
		return sqlSessionTemplate.selectList(this.statement+"selectVenEvaluationStatsExcel", params);
	}


	public List<Map<String, Object>> selectVenEvaluationExcel(Map<String, Object> params) {
		return sqlSessionTemplate.selectList(this.statement+"selectVenEvaluationExcel", params);
	}
}
