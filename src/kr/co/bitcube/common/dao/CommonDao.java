package kr.co.bitcube.common.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import kr.co.bitcube.common.dto.ActivitiesDto;
import kr.co.bitcube.common.dto.AttachInfoDto;
import kr.co.bitcube.common.dto.BorgDto;
import kr.co.bitcube.common.dto.ChatDto;
import kr.co.bitcube.common.dto.ChatLoginDto;
import kr.co.bitcube.common.dto.CodesDto;
import kr.co.bitcube.common.dto.DeliveryAddressDto;
import kr.co.bitcube.common.dto.LoginMenuDto;
import kr.co.bitcube.common.dto.LoginRoleDto;
import kr.co.bitcube.common.dto.LoginUserDto;
import kr.co.bitcube.common.dto.ReceiveInfoDto;
import kr.co.bitcube.common.dto.SmsEmailInfo;
import kr.co.bitcube.common.dto.SrcBorgScopeByRoleDto;
import kr.co.bitcube.common.dto.UserDto;
import kr.co.bitcube.common.dto.WorkInfoDto;
import kr.co.bitcube.common.utils.CommonUtils;
import kr.co.bitcube.product.dto.BuyProductDto;
import kr.co.bitcube.product.dto.CategoryDto;
import kr.co.bitcube.system.dto.NonUsersDto;
import kr.co.bitcube.board.dto.BoardDto;
import kr.co.bitcube.system.exception.SystemUserLoginException;

import org.apache.ibatis.session.RowBounds;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.BadSqlGrammarException;
import org.springframework.stereotype.Repository;

@Repository
public class CommonDao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	/*-------------------------------- Login --------------------------------*/
	private final String loginStatement = "common.login.";
	
	public LoginUserDto selectUserInfo(Map<String, Object> searchMap) {
		return (LoginUserDto)sqlSessionTemplate.selectOne(this.loginStatement+"selectUserInfo", searchMap);
	}

	
	public List<LoginRoleDto> selectLoginRoleList(LoginUserDto loginUserDto) {
		return sqlSessionTemplate.selectList(this.loginStatement+"selectLoginRoleList", loginUserDto);
	}

	
	public List<LoginMenuDto> selectLoginMenuList(Map<String, Object> searchMap) {
		return sqlSessionTemplate.selectList(this.loginStatement+"selectLoginMenuList", searchMap);
	}

	
	public List<LoginMenuDto> selectStaticMenuList(Map<String, Object> searchMap) {
		return sqlSessionTemplate.selectList(this.loginStatement+"selectStaticMenuList", searchMap);
	}

	
	public List<ActivitiesDto> selectUseActivityList(Map<String, Object> searchMap) {
		return sqlSessionTemplate.selectList(this.loginStatement+"selectUseActivityList", searchMap);
	}

	public String selectSubMenuIdByMenuId(String menuId) {
		return (String) sqlSessionTemplate.selectOne(this.loginStatement+"selectSubMenuIdByMenuId", menuId);
	}

	
	public List<BorgDto> selectBelongBorgList(String userId) {
		return sqlSessionTemplate.selectList(this.loginStatement+"selectBelongBorgList", userId);
	}

	
	public SrcBorgScopeByRoleDto selectSrcBorgScopeByRole(LoginUserDto loginUserDto, List<LoginRoleDto> loginRoleList) {
		int isDefaultRoleCnt = 0;
		int tmpScopeCd = 0;
		String tmpRoleId = "";
		String tmpBorgId = "";
		String tmpUserId = "";
		for(LoginRoleDto loginRoleDto : loginRoleList) {
			if("1".equals(loginRoleDto.getIsDefault())) { 
				isDefaultRoleCnt++; 
			}
			if(tmpScopeCd < Integer.parseInt(loginRoleDto.getBorgScopeCd())) {
				tmpScopeCd = Integer.parseInt(loginRoleDto.getBorgScopeCd());
				tmpRoleId = loginRoleDto.getRoleId();
				tmpBorgId = loginRoleDto.getBorgId();
				tmpUserId = loginRoleDto.getUserId();
			}
		}
		//권한은 있으나 기본권한이 없거나 1개 이상 존재 할 경우 스코프가 가장큰 권한을 기본권한으로 한다.
		if(loginRoleList!=null && (loginRoleList.size()>0 && isDefaultRoleCnt!=1)) {
			Map<String, Object> srcParam = new HashMap<String, Object>();
			srcParam.put("roleId", tmpRoleId);
			srcParam.put("borgId", tmpBorgId);
			srcParam.put("userId", tmpUserId);
			sqlSessionTemplate.update(this.loginStatement+"updateIsNotDefaultSmpborgsUsersRoles", srcParam);
			sqlSessionTemplate.update(this.loginStatement+"updateIsDefaultSmpborgsUsersRoles", srcParam);
			loginRoleList = this.selectLoginRoleList(loginUserDto);
			loginUserDto.setLoginRoleList(loginRoleList);	//권한정보
		}
		LoginRoleDto tmpLoginRoleDto = null;
		SrcBorgScopeByRoleDto srcBorgScopeByRoleDto = null;
		for(LoginRoleDto loginRoleDto : loginRoleList) {	//기본권한스코포에 따른 조회조직 및 사용자 세팅
			if("1".equals(loginRoleDto.getIsDefault())) {
				tmpLoginRoleDto = loginRoleDto;
				srcBorgScopeByRoleDto = (SrcBorgScopeByRoleDto) sqlSessionTemplate.selectOne(this.loginStatement+"selectSrcBorgScopeByRole", tmpLoginRoleDto);
				break;
			}
		}
		if(srcBorgScopeByRoleDto == null) throw new SystemUserLoginException("기본권한정보가 존재하지 않습니다. 관리자에게 문의하십시오!");
		if(Integer.parseInt(tmpLoginRoleDto.getBorgScopeCd()) <= 6000) {	//법인범위 이하만 사용자 정보을 가져옴
			srcBorgScopeByRoleDto.setSrcUserList(sqlSessionTemplate.selectList(this.loginStatement+"selectUserListByRoleScope", tmpLoginRoleDto));
		}
		return srcBorgScopeByRoleDto;
	}

	public void updateLoginCount(String userId) {
		sqlSessionTemplate.update(this.loginStatement+"updateLoginCount", userId);
	}

	public String selectIsAreaModify(Map<String, Object> loginAuthMap) {
		return (String) sqlSessionTemplate.selectOne(this.loginStatement+"selectIsAreaModify", loginAuthMap);
	}

	public void updateBranchArea(Map<String, Object> saveMap) {
		sqlSessionTemplate.update(this.loginStatement+"updateBranchArea", saveMap);
	}
	
	/*-------------------------------- Etc --------------------------------*/
	private final String etcStatement = "common.etc.";
	
	public List<CodesDto> selectCodeList(Map<String, Object> searchMap) {
		return sqlSessionTemplate.selectList(this.etcStatement+"selectCodeList", searchMap);
	}

	public int selectSvcUserListCnt(Map<String, Object> params) {
		return (Integer) sqlSessionTemplate.selectOne(this.etcStatement+"selectSvcUserListCnt", params);
	}

	
	public List<LoginUserDto> selectSvcUserList(Map<String, Object> params, int page, int rows) {
		RowBounds rowBounds = new RowBounds((page-1)*rows, rows);
		return sqlSessionTemplate.selectList(this.etcStatement+"selectSvcUserList", params, rowBounds);
	}

	public int selectUserCntByLoginId(String loginId) {
		return (Integer) sqlSessionTemplate.selectOne(this.etcStatement+"selectUserCntByLoginId", loginId);
	}

	
	public Map<String, Object> selectUserAuthByLoginIdPassword(Map<String, Object> params) {
		return sqlSessionTemplate.selectOne(this.etcStatement+"selectUserAuthByLoginIdPassword", params);
	}

	public void updateIsDefaultBorgUser(Map<String, Object> updateMap) {
		sqlSessionTemplate.update(this.etcStatement+"updateIsDefaultBorgUser", updateMap);
	}
	
	public int selectMobileAuthCnt(Map<String, Object> params) {
		return (Integer) sqlSessionTemplate.selectOne(this.etcStatement+"selectMobileAuthCnt", params);
	}
	
	public void insertUserRandom(Map<String, Object> saveMap) {
		sqlSessionTemplate.insert(this.etcStatement+"insertUserRandom", saveMap);
	}

	public void insertUser(Map<String, Object> saveMap) {
		sqlSessionTemplate.insert(this.etcStatement+"insertUser", saveMap);
		sqlSessionTemplate.insert(this.etcStatement+"insertAdminReceiveInfo", saveMap);
	}

	public void insertBorgUser(Map<String, Object> saveMap) {
		sqlSessionTemplate.insert(this.etcStatement+"insertBorgUser", saveMap);
	}

	public void insertBorgUserRole(Map<String, Object> saveMap) {
		sqlSessionTemplate.insert(this.etcStatement+"insertBorgUserRole", saveMap);
	}

	public void updateUser(Map<String, Object> saveMap) {
		sqlSessionTemplate.update(this.etcStatement+"updateUser", saveMap);
		sqlSessionTemplate.update(this.etcStatement+"updateAdminReceiveInfo", saveMap);
	}

	
	public List<AttachInfoDto> selectAttachList(String[] attach_seq) {
		return sqlSessionTemplate.selectList(this.etcStatement+"selectAttachList", attach_seq);
	}

	public void insertAttachInfo(Map<String, Object> saveMap) {
		sqlSessionTemplate.insert(this.etcStatement+"insertAttachInfo", saveMap);
	}

	public void updateAttachInfo(Map<String, Object> saveMap) {
		sqlSessionTemplate.update(this.etcStatement+"updateAttachInfo", saveMap);
	}

	public int selectBuyBorgDivListCnt(Map<String, Object> params) {
		return (Integer) sqlSessionTemplate.selectOne(this.etcStatement+"selectBuyBorgDivListCnt", params);
	}

	
	public List<BorgDto> selectBuyBorgDivList(Map<String, Object> params, int page, int rows) {
		RowBounds rowBounds = new RowBounds((page-1)*rows, rows);
		return sqlSessionTemplate.selectList(this.etcStatement+"selectBuyBorgDivList", params, rowBounds);
	}

	public int selectVendorDivListCnt(Map<String, Object> params) {
		return (Integer) sqlSessionTemplate.selectOne(this.etcStatement+"selectVendorDivListCnt", params);
	}

	
	public List<BorgDto> selectVendorDivList(Map<String, Object> params, int page, int rows) {
		RowBounds rowBounds = new RowBounds((page-1)*rows, rows);
		return sqlSessionTemplate.selectList(this.etcStatement+"selectVendorDivList", params, rowBounds);
	}
	
	public void insertMsgData(Map<String, Object> saveMap) {
		sqlSessionTemplate.insert(this.etcStatement+"insertMsgData", saveMap);
	}

	
	public String[] selectSmsNumByAdminRole(String roleCd) {
		List<String> numberList =  sqlSessionTemplate.selectList(this.etcStatement+"selectSmsNumByAdminRole", roleCd);
		String[] rtnString = new String[numberList.size()];
		int tmpI = 0;
		for(String tmpString : numberList) {
			rtnString[tmpI] = tmpString;
			tmpI++;
		}
		return rtnString;
	}
	
	
	public List<UserDto> selectUserInfoListByBranchId(Map<String, Object> searchMap) {
		return sqlSessionTemplate.selectList(this.etcStatement+"selectUserInfoListByBranchId", searchMap);
	}
	
	
	public List<DeliveryAddressDto> selectDeliveryAddressByBranchId(Map<String, Object> searchMap) {
		return sqlSessionTemplate.selectList(this.etcStatement+"selectDeliveryAddressByBranchId", searchMap);
	}
	
	
	public List<CategoryDto> selectDispCateListInfoByBuyBorg(Map<String, Object> searchMap) {
		return sqlSessionTemplate.selectList(this.etcStatement+"selectDispCateListInfoByBuyBorg", searchMap);
	}
	
	public List<Map<String, Object>> selectPostAddressList(Map<String, Object> params) {
		return sqlSessionTemplate.selectList(this.etcStatement+"selectPostAddressList", params);
	}

	
	public List<Map<String, Object>> selectNewPostAddressList(Map<String, Object> params) {
		return sqlSessionTemplate.selectList(this.etcStatement+"selectNewPostAddressList", params);
	}

	public void updateNotDefaultDeliveryInfo(Map<String, Object> saveMap) {
		sqlSessionTemplate.update(this.etcStatement+"updateNotDefaultDeliveryInfo", saveMap);
	}

	public void deleteDeliveryInfo(Map<String, Object> saveMap) {
		sqlSessionTemplate.delete(this.etcStatement+"deleteDeliveryInfo", saveMap);
	}

	public void updateDeliveryInfo(Map<String, Object> saveMap) {
		sqlSessionTemplate.update(this.etcStatement+"updateDeliveryInfo", saveMap);
	}

	public void insertMailInfo(Map<String, Object> saveMap) {
		sqlSessionTemplate.insert(this.etcStatement+"insertMailInfo", saveMap);
	}

	public ReceiveInfoDto selectReceiveInfoDtoByUserId(String userId) {
		ReceiveInfoDto receiveInfoDto = (ReceiveInfoDto)sqlSessionTemplate.selectOne(this.etcStatement+"selectReceiveInfoDtoByUserId", userId);
		//if(receiveInfoDto==null) { receiveInfoDto = new ReceiveInfoDto(userId); }
		return receiveInfoDto;
	}

	
	public List<ReceiveInfoDto> selectAdminReceiveInfoDtoByRoleCd(String AdminRoleCd) {
		return sqlSessionTemplate.selectList(this.etcStatement+"selectAdminReceiveInfoDtoByRoleCd", AdminRoleCd);
	}

	
	public List<ReceiveInfoDto> selectReceiveInfoDtoByBorgId(String borgId) {
		return sqlSessionTemplate.selectList(this.etcStatement+"selectReceiveInfoDtoByBorgId", borgId);
	}

	public int selectBuyPublishAuthCntByBranchId(String branchId) {
		return sqlSessionTemplate.selectOne(this.etcStatement+"selectBuyPublishAuthCntByBranchId", branchId);
	}

	public int selectVenPublishAuthCntByVendorId(String vendorId) {
		return sqlSessionTemplate.selectOne(this.etcStatement+"selectVenPublishAuthCntByVendorId", vendorId);
	}	
	
	public int getSmpBranchsBusinessNumDupCnt(String businessNum){
		return sqlSessionTemplate.selectOne(this.etcStatement+"getSmpBranchsBusinessNumDupCnt", businessNum);
	}

	public int getSmpVendorsBusinessNumDupCnt(String businessNum){
		return sqlSessionTemplate.selectOne(this.etcStatement+"getSmpVendorsBusinessNumDupCnt", businessNum);
	}

	public int getSmpBranchsAuthCnt(String businessNum){
		return (Integer)sqlSessionTemplate.selectOne(this.etcStatement+"getSmpBranchsAuthCnt", businessNum);
	}

	public void insertAuthInfo(Map<String, Object> saveMap) {
		sqlSessionTemplate.insert(this.etcStatement+"insertAuthInfo", saveMap);
	}

	
	@Deprecated
	public List<SmsEmailInfo> selectManagerSmsEmailInfoByManageClientId(String manageClientId) {
		return sqlSessionTemplate.selectList(this.etcStatement+"selectManagerSmsEmailInfoByManageClientId", manageClientId);
	}

	public List<SmsEmailInfo> selectManagerSmsEmailInfosByManageClientId(String manageClientId) {
		return sqlSessionTemplate.selectList(this.etcStatement+"selectManagerSmsEmailInfosByManageClientId", manageClientId);
	}
	
	public List<SmsEmailInfo> selectBondManagerSmsEmailInfoByBranchId(String branchId) {	//채권담당운영자 가져오기
		return sqlSessionTemplate.selectList(this.etcStatement+"selectBondManagerSmsEmailInfoByBranchId", branchId);
	}
	
	public List<SmsEmailInfo> selectManagerSmsEmailInfoByManageBranchId(String branchId) {	//공사유형 담당운영자 가져오기
		return sqlSessionTemplate.selectList(this.etcStatement+"selectManagerSmsEmailInfoByManageBranchId", branchId);
	}
	
	
	public List<SmsEmailInfo> selectApproverSmsEmailInfoByRoleCd(String roleCd) {
		return sqlSessionTemplate.selectList(this.etcStatement+"selectApproverSmsEmailInfoByRoleCd", roleCd);
	}

	public SmsEmailInfo selectUserSmsEmailInfoByUserId(String userid) {
		return sqlSessionTemplate.selectOne(this.etcStatement+"selectUserSmsEmailInfoByUserId", userid);
	}

	
	public List<SmsEmailInfo> selectVendorUserSmsEmailInfoByVendorId(String vendorId) {
		return sqlSessionTemplate.selectList(this.etcStatement+"selectVendorUserSmsEmailInfoByVendorId", vendorId);
	}

	
	public Map<String, Object> selectOrderDistributeEmailSmsByOrderNum(String orderNum) {
		return sqlSessionTemplate.selectOne(this.etcStatement+"selectOrderDistributeEmailSmsByOrderNum", orderNum);
	}

	
	public List<Map<String, Object>> selectOrderEmailSmsListByOrderNum(String orderNum) {
		return sqlSessionTemplate.selectList(this.etcStatement+"selectOrderEmailSmsListByOrderNum", orderNum);
	}

	
	public List<Map<String, Object>> selectOrderEmailSmsListByOrderNumArray( String[] orderNumFullArray) {
		String queryString = " (";
		int cnt = 0;
		for(String orderNumFull : orderNumFullArray) {
			queryString += " c.orde_iden_numb = '"+orderNumFull.split("-")[0]+"'";
			queryString += " and ";
			queryString += " c.orde_sequ_numb = '"+orderNumFull.split("-")[1]+"'";
			queryString += " and ";
			queryString += " c.purc_iden_numb = '"+orderNumFull.split("-")[2]+"'";
			if(++cnt!=orderNumFullArray.length) {
				queryString += " or ";
			}
		}
		queryString += ") ";
		Map<String,Object> paramMap = new HashMap<String,Object>();
		paramMap.put("queryString", queryString);
		return sqlSessionTemplate.selectList(this.etcStatement+"selectOrderEmailSmsListByOrderNumArray", paramMap);
	}
	
	
	public HashMap<String,Object> getUserIdPasswordFind(Map<String, Object> searchMap) {
		return sqlSessionTemplate.selectOne(this.etcStatement+"getUserIdPasswordFind", searchMap);
	}
	
	public void updateUserPasswordRandom(Map<String, Object> searchMap) {
		sqlSessionTemplate.update(this.etcStatement+"updateUserPasswordRandom", searchMap);
	}

	public void insertWorkInfo(Map<String, Object> searchMap) {
		sqlSessionTemplate.insert(this.etcStatement+"insertWorkInfo", searchMap);
	}

	
	public List<WorkInfoDto> selectWorkInfo(Map<String, Object> params) {
		return sqlSessionTemplate.selectList(this.etcStatement+"selectWorkInfo", params);
	}
	
	public void connWorkInfoToUser(Map<String, Object> searchMap) {
		sqlSessionTemplate.update(this.etcStatement+"connWorkInfoToUser", searchMap);
	}

	public void disConnWorkInfoToUser(Map<String, Object> searchMap) {
		sqlSessionTemplate.update(this.etcStatement+"disConnWorkInfoToUser", searchMap);
	}

	
	public List<WorkInfoDto> selectConnWorkBranchList(Map<String, Object> params) {
		return sqlSessionTemplate.selectList(this.etcStatement+"selectConnWorkBranchList", params);
	}
	
	public void connBranchs(Map<String, Object> searchMap) {
		sqlSessionTemplate.update(this.etcStatement+"connBranchs", searchMap);
	}

	public void disConnBranchs(Map<String, Object> searchMap) {
		sqlSessionTemplate.update(this.etcStatement+"disConnBranchs", searchMap);
	}

	
	public List<WorkInfoDto> selectConnAccBranchList(Map<String, Object> params) {
		return sqlSessionTemplate.selectList(this.etcStatement+"selectConnAccBranchList", params);
	}
	
	
	public List<WorkInfoDto> getAccManageUserList() {
		return sqlSessionTemplate.selectList(this.etcStatement+"getAccManageUserList");
	}
	
	
	public List<BuyProductDto> selectDispGoodIdList(Map<String, Object> params) {
		return sqlSessionTemplate.selectList(this.etcStatement+"selectDispGoodIdList", params);
	}

	
	public Map<String, Object> selectOrderApprovalRequestEmailSmsByOrderNum( String orderNum) {
		return sqlSessionTemplate.selectOne(this.etcStatement+"selectOrderApprovalRequestEmailSmsByOrderNum", orderNum);
	}

	
	public List<SmsEmailInfo> selectApprovalUserSmsEmailInfo( String directorUserId) {
		return sqlSessionTemplate.selectList(this.etcStatement+"selectApprovalUserSmsEmailInfo", directorUserId);
	}

	
	public Map<String, Object> selectOrderEmailSmsListByOrderNumForDivPurc(Map<String, String> params) {
		return sqlSessionTemplate.selectOne(this.etcStatement+"selectOrderEmailSmsListByOrderNumForDivPurc",  params);
	}

	
	public List<Map<String, Object>> selectOrderCancelEmailSmsByOrderNum( Map<String , String> params) {
		return sqlSessionTemplate.selectList(this.etcStatement+"selectOrderCancelEmailSmsByOrderNum", params);
	}

	
	public List<Map<String, String>> selectSmsSvcUserList( Map<String, Object> params, int page, int rows) {
		RowBounds rowBounds = new RowBounds((page-1)*rows, rows);
		return sqlSessionTemplate.selectList(this.etcStatement+"selectSmsSvcUserList", params, rowBounds);
	}

	public int selectSmsSvcUserListCnt(Map<String, Object> params) {
		return (Integer) sqlSessionTemplate.selectOne(this.etcStatement+"selectSmsSvcUserListCnt", params);
	}

	
	public List<Map<String, Object>> selectSmsRoleKind(Map<String, Object> params) {
		return sqlSessionTemplate.selectList(this.etcStatement+"selectSmsRoleKind", params);
	}

	
	public List<Map<String, String>> selectRoleInfoListBySmsSvcTypeNm( Map<String, Object> searchMap) {
		return sqlSessionTemplate.selectList(this.etcStatement+"selectSmsRoleKind", searchMap);
	}

	/*------------------------------------채팅관련서비스 시작-----------------------------------------*/
	public void saveChatLogin(String userId, String borgId, String userNm, String borgNm) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userId", userId);
		params.put("branchId", borgId);
		params.put("userNm", userNm);
		params.put("branchNm", borgNm);
		sqlSessionTemplate.insert(this.etcStatement+"saveChatLogin", params);
	}

	public ChatLoginDto selectChatMeUserInfo(String userId, String branchId) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userId", userId);
		params.put("branchId", branchId);
		return (ChatLoginDto) sqlSessionTemplate.selectOne(this.etcStatement+"selectChatMeUserInfo", params);
	}
	
	
	public List<ChatLoginDto> selectLogoutChatList() {
		return sqlSessionTemplate.selectList(this.etcStatement+"selectLogoutChatList");
	}

	public void insertChatLogTable(Map<String, Object> params) throws BadSqlGrammarException {
		sqlSessionTemplate.insert(this.etcStatement+"insertChatLogTable", params);
	}

	public void deleteLogoutChatData(Map<String, Object> params) {
		sqlSessionTemplate.delete(this.etcStatement+"deleteLogoutChatData", params);
	}

	public void deleteChatLogin(Map<String, Object> params) {
		sqlSessionTemplate.delete(this.etcStatement+"deleteChatLogin", params);
	}

	public void deleteAllChatLogin() {
		sqlSessionTemplate.delete(this.etcStatement+"deleteAllChatLogin");
	}

	public void deleteAllChatInfo() {
		sqlSessionTemplate.delete(this.etcStatement+"deleteAllChatInfo");
	}

	public void createChatLog() {
		String currentDate = CommonUtils.getCurrentDate();
		String logYyyyMm = currentDate.substring(0, 4) + currentDate.substring(5, 7);
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("logYyyyMm", logYyyyMm);
		sqlSessionTemplate.insert(this.etcStatement+"createChatLog", params);
		sqlSessionTemplate.insert(this.etcStatement+"alterChatLog", params);
	}

	
	public List<ChatLoginDto> selectChatLoginList(Map<String, Object> params) {
		return sqlSessionTemplate.selectList(this.etcStatement+"selectChatLoginList", params);
	}

	
	public List<ChatDto> selectChatList(Map<String, Object> params) {
		return sqlSessionTemplate.selectList(this.etcStatement+"selectChatList", params);
	}

	public void updateReceiveChatToUser(Map<String, Object> params) {
		sqlSessionTemplate.update(this.etcStatement+"updateReceiveChatToUser", params);
	}

	
	public List<ChatDto> selectChatMeList(Map<String, Object> params) {
		return sqlSessionTemplate.selectList(this.etcStatement+"selectChatMeList", params);
	}
	
	public void updateReceiveChatByChatId(String chatId) {
		sqlSessionTemplate.update(this.etcStatement+"updateReceiveChatByChatId", chatId);
	}

	public void insertChatData(Map<String, Object> params) {
		sqlSessionTemplate.insert(this.etcStatement+"insertChatData", params);
	}

	public int selectChatMessageListCnt(Map<String, Object> params) {
		return sqlSessionTemplate.selectOne(this.etcStatement+"selectChatMessageListCnt", params);
	}

	
	public List<ChatDto> selectChatMessageList(Map<String, Object> params, int page, int rows) {
		RowBounds rowBounds = new RowBounds((page-1)*rows, rows);
		return sqlSessionTemplate.selectList(this.etcStatement+"selectChatMessageList", params, rowBounds);
	}

	public void updateWorkInfo(Map<String, Object> saveMap) {
		sqlSessionTemplate.insert(this.etcStatement+"updateWorkInfo", saveMap);
	}


	public String selectMrordtStatus(Map<String, Object> params) {
		return sqlSessionTemplate.selectOne(this.etcStatement+"selectMrordtStatus", params);
	}
	public String selectMrpurtStatus(Map<String, Object> params) {
		return sqlSessionTemplate.selectOne(this.etcStatement+"selectMrpurtStatus", params);
	}
	public String selectMracptStatus(Map<String, Object> params) {
		return sqlSessionTemplate.selectOne(this.etcStatement+"selectMracptStatus", params);
	}
	public String selectMrordtlistStatus(Map<String, Object> params) {
		return sqlSessionTemplate.selectOne(this.etcStatement+"selectMrordtlistStatus", params);
	}


	public int selectReturnProdQuanCnt(Map<String, Object> params) {
		return sqlSessionTemplate.selectOne(this.etcStatement+"selectReturnProdQuanCnt", params);
	}

	public String selectCmpMsgId(Map<String, Object> params) {
		return sqlSessionTemplate.selectOne(this.etcStatement+"selectCmpMsgId", params);
	}

	public void insertMsgSktelink(Map<String, Object> saveMap) {
		sqlSessionTemplate.insert(this.etcStatement+"insertMsgSktelink", saveMap);
	}

	/*------------------------------비회원로그인 시작----------------------------------*/
	public String selectGuestUserIdByLoginId(String loginId) {
		return sqlSessionTemplate.selectOne(this.etcStatement+"selectGuestUserIdByLoginId", loginId);
	}
//	public List<String> selectGuestNoneUserIds(Map<String, Object> searchMap) {
//		return sqlSessionTemplate.selectList(this.etcStatement+"selectGuestNoneUserIds", searchMap);
//	}
	public String selectGuestNoneUserId(Map<String, Object> searchMap) {
		return sqlSessionTemplate.selectOne(this.etcStatement+"selectGuestNoneUserId", searchMap);
	}
	public void insertGuestUser(Map<String, Object> saveMap) {
		sqlSessionTemplate.insert(this.etcStatement+"insertGuestUser", saveMap);
	}
	public void updateGuestUser(Map<String, Object> saveMap) {
		sqlSessionTemplate.update(this.etcStatement+"updateGuestUser", saveMap);
	}
	public NonUsersDto selectNonUserInfo(String nonUserId) {
		return sqlSessionTemplate.selectOne(this.etcStatement+"selectNonUserInfo", nonUserId);
	}
	public Integer selectBusinessCnt(Map<String, Object> saveMap) {
		return sqlSessionTemplate.selectOne(this.etcStatement+"selectBusinessCnt", saveMap);
	}
	/*------------------------------비회원로그인 끝----------------------------------*/


	public void insertTblSubmitQueue(Map<String, Object> saveMap) {
		sqlSessionTemplate.insert(this.etcStatement+"insertTblSubmitQueue", saveMap);
	}


	public Map<String, Object> selectOrderReceiveDeliverySmsEmail(Map<String, Object> saveMap) {
		return sqlSessionTemplate.selectOne(this.etcStatement+"selectOrderReceiveDeliverySmsEmail", saveMap);
	}


	public Map<String, Object> selectIndividualContractDetail() throws Exception{
		return sqlSessionTemplate.selectOne(this.etcStatement+"selectIndividualContractDetail");
	}


	public Map<String, Object> selectUnconditionalSmsUser(String codeVal1) throws Exception{
		return sqlSessionTemplate.selectOne(this.etcStatement+"selectUnconditionalSmsUser", codeVal1);
	}


	public Map<String, Object> selectAllocationStatus(Map<String, Object> saveMap) {
		return sqlSessionTemplate.selectOne(this.etcStatement+"selectAllocationStatus", saveMap);
	}


	public String selectAttachOringinName(String attachFilePath) {
		return sqlSessionTemplate.selectOne(this.etcStatement+"selectAttachOringinName", attachFilePath);
	}

	public void insertMenuAccessLog(Map<String, Object> accessMap) {
		sqlSessionTemplate.insert(this.etcStatement+"insertMenuAccessLog", accessMap);
	}


	public List<Map<String, Object>> selectOrderDistributeEmailSmsByOrderNumList(String orderNum) {
		return sqlSessionTemplate.selectList(this.etcStatement+"selectOrderDistributeEmailSmsByOrderNumList", orderNum);
	}


	public SmsEmailInfo selectProductManagerInfo(Map<String, Object> tempMap){
		return sqlSessionTemplate.selectOne(this.etcStatement+"selectProductManagerInfo", tempMap);
	}


	public int selectIsdefaultCnt(Map<String, Object> searchMap) {
		return sqlSessionTemplate.selectOne(this.etcStatement+"selectIsdefaultCnt", searchMap);
	}

	public void updateIsDefaultZero(Map<String, Object> searchMap) {
		sqlSessionTemplate.update(this.etcStatement+"updateIsDefaultZero", searchMap);
	}


	public void updateIsDefaultOne(Map<String, Object> searchMap) {
		sqlSessionTemplate.update(this.etcStatement+"updateIsDefaultOne", searchMap);
	}


	public int selectNoneBusinessCnt(Map<String, Object> searchMap) {
		return sqlSessionTemplate.selectOne(this.etcStatement+"selectNoneBusinessCnt", searchMap);
	}

	public int selectNoneBusinessNumNameCnt(Map<String, Object> searchMap) {
		return sqlSessionTemplate.selectOne(this.etcStatement+"selectNoneBusinessNumNameCnt", searchMap);
	}
	
	public List<BoardDto> selectNoticePopBoardMainList() {
		return sqlSessionTemplate.selectList(this.etcStatement+"selectNoticePopBoardMainList");
	}


	/** menuCd값으로 menuId 값 조회 */
	public String selectMenuIdForMenuCd(String menuCd) {
		return sqlSessionTemplate.selectOne(this.etcStatement+"selectMenuIdForMenuCd", menuCd);
	}
	
	public String selectContractSvcTypeCd(Map<String, Object> params) {
		return sqlSessionTemplate.selectOne(this.etcStatement+"selectContractSvcTypeCd", params);
	}
	
	/**
	 * 구매사가 서명해야되는 계약서 리스트
	 */
	public List<Map<String, Object>> selectBranchContractToDoList(Map<String, Object> params) throws Exception{
		return sqlSessionTemplate.selectList(this.etcStatement+"selectBranchContractToDoList", params);
	}

	/**
	 * 공급사가 서명해야되는 계약서 리스트
	 */
	public List<Map<String, Object>> selectVendorContractToDoList(Map<String, Object> params) throws Exception{
		return sqlSessionTemplate.selectList(this.etcStatement+"selectVendorContractToDoList", params);
	}


	public Map<String, Object> selectSmpborgContractBranchInfo(Map<String, Object> saveMap)  throws Exception{
		return sqlSessionTemplate.selectOne(this.etcStatement+"selectSmpborgContractBranchInfo", saveMap);
	}


	public void saveSmpborgContract(Map<String, Object> contractBorgInfo) throws Exception{
		sqlSessionTemplate.insert(this.etcStatement+"saveSmpborgContract", contractBorgInfo);
	}


	public void insertContractSign(Map<String, Object> contractBorgInfo) throws Exception{
		sqlSessionTemplate.insert(this.etcStatement+"insertContractSign", contractBorgInfo);
	}


	public Map<String, Object> selectSmpborgContractVendorInfo(Map<String, Object> saveMap) throws Exception{
		return sqlSessionTemplate.selectOne(this.etcStatement+"selectSmpborgContractVendorInfo", saveMap);
	}


	public int selectBorgDivListVenOrdReqCnt(Map<String, Object> params) {
		return (Integer) sqlSessionTemplate.selectOne(this.etcStatement+"selectBorgDivListVenOrdReqCnt", params);
	}
	public List<Map<String, Object>> selectBorgDivListVenOrdReq(Map<String, Object> params) {
		return sqlSessionTemplate.selectList(this.etcStatement+"selectBorgDivListVenOrdReq", params);
	}
	public Map<String, Object> selectUserInfoByUserInfo(Map<String, Object> params) {
		return (Map<String, Object>)sqlSessionTemplate.selectOne(this.etcStatement+"selectUserInfoByUserInfo", params);
	}


	public int selectSmsSvcUserListCnt2(Map<String, Object> params) {
		return (Integer) sqlSessionTemplate.selectOne(this.etcStatement+"selectSmsSvcUserListCnt2", params);
	}
	public List<Map<String, String>> selectSmsSvcUserList2(Map<String, Object> params, int page, int rows) {
		RowBounds rowBounds = new RowBounds((page-1)*rows, rows);
		return sqlSessionTemplate.selectList(this.etcStatement+"selectSmsSvcUserList2", params, rowBounds);
	}


	/** sms 발송 용 선입금 주문 정보 조회 */
	@SuppressWarnings("unchecked")
	public Map<String, Object> selectOrderPrepayInfo(String createdOrdeIdenNumb) {
		return (Map<String, Object>)sqlSessionTemplate.selectOne(this.etcStatement+"selectOrderPrepayInfo", createdOrdeIdenNumb);
	}


	/** 고객사의 주문취소요청 시 해당 공급사 사용자의 사용자 정보를 조회하여 리턴한다. */
	public List<Map<String, Object>> selectOrderSmsListByCancelRequest( Map<String, String> tmpParamMap) {
		return sqlSessionTemplate.selectList(this.etcStatement+"selectOrderSmsListByCancelRequest", tmpParamMap);
	}
	
}
