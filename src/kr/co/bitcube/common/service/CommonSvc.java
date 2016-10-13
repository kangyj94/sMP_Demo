package kr.co.bitcube.common.service;

import java.math.BigDecimal;
import java.sql.Time;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;

import javax.annotation.Resource;

import kr.co.bitcube.common.dao.CommonDao;
import kr.co.bitcube.common.dao.GeneralDao;
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
import kr.co.bitcube.common.dto.UserDto;
import kr.co.bitcube.common.dto.WorkInfoDto;
import kr.co.bitcube.common.utils.CommonUtils;
import kr.co.bitcube.common.utils.Constances;
import kr.co.bitcube.common.utils.CustomResponse;
import kr.co.bitcube.organ.dao.OrganDao;
import kr.co.bitcube.organ.dao.ReqBorgDao;
import kr.co.bitcube.organ.dto.SmpBranchsDto;
import kr.co.bitcube.organ.dto.SmpVendorsDto;
import kr.co.bitcube.product.dto.BuyProductDto;
import kr.co.bitcube.product.dto.CategoryDto;
import kr.co.bitcube.system.dao.RoleDao;
import kr.co.bitcube.system.dto.NonUsersDto;
import kr.co.bitcube.system.dto.RoleDto;
import kr.co.bitcube.system.exception.SystemUserLoginException;
import kr.co.bitcube.board.dto.BoardDto;

import org.apache.ibatis.session.RowBounds;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.BadSqlGrammarException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.ModelMap;

import crosscert.Base64;
import crosscert.Certificate;
import crosscert.Verifier;
import egovframework.rte.fdl.idgnr.EgovIdGnrService;

@Service
public class CommonSvc {

	private Logger logger = Logger.getLogger(getClass());
	@Autowired private CommonDao commonDao;
	@Autowired private OrganDao organDao;
	@Autowired private RoleDao roleDao;
	@Autowired private ReqBorgDao reqBorgDao;
	@Autowired private GeneralDao generalDao;
	
	@Resource(name="seqMpUsersService")
	private EgovIdGnrService seqMpUsersService; // id 생성을 위해 추가

	@Resource(name="seqMpAttachInfoService")
	private EgovIdGnrService seqMpAttachInfoService; // 첨부파일 시퀀스

	@Resource(name="seqMpDeliveryInfoService")
	private EgovIdGnrService seqMpDeliveryInfoService; // 배송지관리 시퀀스

	@Resource(name="seqMpMailInfoService")
	private EgovIdGnrService seqMpMailInfoService; // 메일관리 시퀀스

	@Resource(name="seqWorkInfo")
	private EgovIdGnrService seqWorkInfo; // 메일관리 시퀀스
	
	@Resource(name="seqMmsId")
	private EgovIdGnrService seqMmsId; //mms 시퀀스
	
	/**
	 * 로그인 사용자 체크하고 모바일인증 여부을 리턴(모바일번호을 리턴)
	 * @param searchMap
	 * @return
	 */
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false)
	public CustomResponse getUserAuthByLoginIdPassword(Map<String, Object> searchMap) {
		CustomResponse custResponse = new CustomResponse(true);
		int isDefaultCnt = commonDao.selectIsdefaultCnt(searchMap);
		if(isDefaultCnt>1) {	//사용자 default 조직이 1개 이상이면 1개로 만듬
			commonDao.updateIsDefaultZero(searchMap);
			commonDao.updateIsDefaultOne(searchMap);
		}
		
		searchMap.put("borgIsDefault", "1");
		Map<String, Object> loginAuthMap = commonDao.selectUserAuthByLoginIdPassword(searchMap);	//사용자 default조직 사용자Map
		if(loginAuthMap==null || loginAuthMap.isEmpty()) {	//사용자 default조직이 아닌 사용자Map(왜냐면 사용자Default조직이 존재하지 않을 수 있기 때문)
			searchMap.put("borgIsDefault", "");
			loginAuthMap = commonDao.selectUserAuthByLoginIdPassword(searchMap);
			if(loginAuthMap!=null && !loginAuthMap.isEmpty()) {	//사용자 default조직이 아닌 사용자에게 Default조직을 부여함
				Map<String, Object> updateMap = new HashMap<String, Object>();
				updateMap.put("userId", loginAuthMap.get("USERID"));
				updateMap.put("borgId", loginAuthMap.get("BORGID"));
				commonDao.updateIsDefaultBorgUser(updateMap);
			}
		}
		if(loginAuthMap==null || loginAuthMap.isEmpty()) {
			logger.error("Exception : 아이디, 패스워드 확인 -> "+searchMap);
			custResponse.setSuccess(false);
			custResponse.setMessage("아이디, 패스워드을 확인 하십시오");
		}  else if((Integer)loginAuthMap.get("ISUSE_CLIENT")==0) {
			logger.error("Exception : 고객사 법인 사용 중지 확인 -> "+searchMap);
			custResponse.setSuccess(false);
			custResponse.setMessage("법인사용이 정지되어 있습니다. <br/>관리자에게 문의하십시오!");
		} else {
			String areaType = commonDao.selectIsAreaModify(loginAuthMap);	//1월1일 이후 한해동안 권역정보을 수정하지 않았다면 사용자에게 권역정보을 확인을 독려하기 위해
			areaType = CommonUtils.getString(areaType);
			
			//특수운영자는 모바일인증하게..
			if(searchMap.get("loginId")!=null) {
				if("sk_admin".equals(searchMap.get("loginId")) || "sktelecom".equals(searchMap.get("loginId"))) {
					loginAuthMap.put("LOGINAUTHTYPE", "10");
				} else if("ADM".equals(loginAuthMap.get("SVCTYPECD"))) {
					loginAuthMap.put("LOGINAUTHTYPE", "20");
				}
			}
			
			if(!Constances.ETC_ISMOBILE_AUTH) {	//모바일인증여부
				loginAuthMap.put("LOGINAUTHTYPE", "20");
			}
			//if("20".equals(loginAuthMap.get("LOGINAUTHTYPE")) || "ADM".equals(loginAuthMap.get("SVCTYPECD"))) {	//일반인증 또는 운영사
			if("20".equals(loginAuthMap.get("LOGINAUTHTYPE"))) {	//일반인증
				custResponse.setMessage("");
			} else if("10".equals(loginAuthMap.get("LOGINAUTHTYPE"))) {	//모바일 인증(난수발생)
				Random rand = new Random();
				String randString = String.format("%04d", rand.nextInt(10000));
				searchMap.put("randString", randString);
				
				String mobile = CommonUtils.getString(loginAuthMap.get("MOBILE")).trim();
				String chk_flag = (String) searchMap.get("chk_flag");
				if(chk_flag.equals("1")) {
					commonDao.insertUserRandom(searchMap);
					logger.info("Mobile Auth => loginId:"+searchMap.get("loginId")+", mobile:"+mobile+", authKey:"+randString);
				}
				if(!"".equals(mobile)) {
					// 정연백과장 요청으로 SMS 내용 변경 및 즉시발송 by kkbum2000 20160701
					/*---------------------모바일전송 모듈 시작----------------------*/
					if(chk_flag.equals("1")) sendRightSms(mobile, "Okplaza 로그인 인증번호는 ["+randString+"] 입니다", true);
					/*---------------------모바일전송 모듈 끝----------------------*/
					custResponse.setMessage(mobile);
				} else {
					custResponse.setSuccess(false);
					custResponse.setMessage("핸드폰번호가 등록되어 있지 않습니다. 관리자에게 문의 하십시오!");
				}
			}
			areaType = "";	//권역수정 없음
			if(custResponse.getSuccess()) {	//로그인에 문제가 없을 경우
				List<String> messageList = custResponse.getMessage();
				String message = messageList.get(0);
				if("".equals(message) && "".equals(areaType)) {	//모바일인증을 하지 않고 권역수정대상이 아니면 => 바로 로그인
					custResponse.setNewIdx(0);
				} else if(!"".equals(message) && "".equals(areaType)) {	//모바일인증을 하고 권역수정대상이 아니면 => 모바일 인증
					custResponse.setNewIdx(1);
				} else if("".equals(message) && !"".equals(areaType)) {	//모바일인증을 하지 않고 권역수정대상 이라면 => 권역수정
					custResponse.setNewIdx(2);
					custResponse.setMessage(areaType);
					custResponse.setMessage((String)loginAuthMap.get("BORGID"));
				} else if(!"".equals(message) && !"".equals(areaType)) {	//모바일인증을 하고 권역수정대상 이라면 => 모바일인증+권역수정
					custResponse.setNewIdx(3);
					custResponse.setMessage(areaType);
					custResponse.setMessage((String)loginAuthMap.get("BORGID"));
				}
			}
		}
		return custResponse;
	}
	
	/**
	 * 로그인아이디로 인증번호 체크
	 * @param searchMap
	 * @return
	 */
	public int getMobileAuthCnt(Map<String, Object> searchMap) {
		return commonDao.selectMobileAuthCnt(searchMap);
	}

	/**
	 * 로그인사용자의 권역정보 수정
	 * @param searchMap
	 */
	public void updateBranchArea(Map<String, Object> saveMap) {
		commonDao.updateBranchArea(saveMap);
	}
	
	/**
	 * 로그인정보를 가져옴(권한과 메뉴는 리스트형태로 제공)
	 * @param loginId
	 * @param password
	 * @param svcTypeCd 
	 * @return
	 */
	public LoginUserDto getLoginUserInfo(Map<String, Object> searchMap) throws SystemUserLoginException, Exception {
		String userId = searchMap.get("userId")==null ? "" : (String)searchMap.get("userId");
		boolean moveFlag = false;	//조직이동여부
		if(!"".equals(userId)) moveFlag = true;
		
		LoginUserDto loginUserDto = commonDao.selectUserInfo(searchMap);	//사용자정보
		if(loginUserDto==null) {
			if(moveFlag) new Exception("사용자 및 조직정보를 체크해 주세요!");
			else throw new SystemUserLoginException("Check Your ID or Password!");
		} else if(loginUserDto.getIsUseClient() == 0) {
			throw new SystemUserLoginException("Try using the presence of corporate!");
		}
		List<LoginRoleDto> loginRoleList = commonDao.selectLoginRoleList(loginUserDto);
		if(loginRoleList==null || loginRoleList.size()<=0) { throw new SystemUserLoginException("You don't have the role...You must inquire to administrator!"); }
		loginUserDto.setLoginRoleList(loginRoleList);	//권한정보
		if("BUY".equals(loginUserDto.getSvcTypeCd()) || "VEN".equals(loginUserDto.getSvcTypeCd())) {
			loginUserDto.setSrcBorgScopeByRoleDto(commonDao.selectSrcBorgScopeByRole(loginUserDto, loginRoleList));	//기본권한스코포에 따른 조회조직 및 사용자 세팅
			if("BUY".equals(loginUserDto.getSvcTypeCd())) {	//사용자
				loginUserDto.setSmpBranchsDto(organDao.selectOneBranchs(loginUserDto.getBorgId()));
				loginUserDto.setAreaType(loginUserDto.getSmpBranchsDto().getAreaType());
			} else if("VEN".equals(loginUserDto.getSvcTypeCd())) {
				loginUserDto.setSmpVendorsDto(organDao.selectOneVendors(loginUserDto.getBorgId()));
				loginUserDto.setAreaType(loginUserDto.getSmpVendorsDto().getAreaType());
			}
		}
		loginUserDto.setBelongBorgList(commonDao.selectBelongBorgList(loginUserDto.getUserId()));	//소속조직리스트
		searchMap.clear();
		searchMap.put("svcTypeCd", loginUserDto.getSvcTypeCd());
		searchMap.put("roleId", loginUserDto.getLoginRoleList());
		searchMap.put("isFixed", 0);
		searchMap.put("menuLevel", 0);
		loginUserDto.setBigMenuList(commonDao.selectLoginMenuList(searchMap));	//동적 대메뉴리스트
		searchMap.put("menuLevel", 1);
		loginUserDto.setMiddleMenuList(commonDao.selectLoginMenuList(searchMap));	//동적 중메뉴리스트
		searchMap.put("menuLevel", 2);
		loginUserDto.setSmallMenuList(commonDao.selectLoginMenuList(searchMap));	//동적 소메뉴리스트
		searchMap.put("isFixed", 1);
		searchMap.put("menuLevel", 0);
		loginUserDto.setStaticMenuList(commonDao.selectLoginMenuList(searchMap));	//고정메뉴리스트
//		loginUserDto.setStaticMenuList(commonDao.selectStaticMenuList(searchMap));	//고정메뉴리스트(요거는 권한과 영역이 연결안된 메뉴리스트)
		
		/*-----------------------메뉴의 트리구조화----------------------*/
		List<LoginMenuDto> bigMenuList = loginUserDto.getBigMenuList();
		List<LoginMenuDto> middleMenuList = loginUserDto.getMiddleMenuList();
		List<LoginMenuDto> smallMenuList = loginUserDto.getSmallMenuList();
		for(LoginMenuDto bigMenuDto : bigMenuList) {
			String bigMenuId = bigMenuDto.getMenuId();
			List<LoginMenuDto> subMiddleMenuList = new ArrayList<LoginMenuDto>();
			for(LoginMenuDto middleMenuDto : middleMenuList) {
				String middleMenuId = middleMenuDto.getMenuId();
				String middleParMenuId = middleMenuDto.getParMenuId();
				if(bigMenuId.equals(middleParMenuId)) {
					subMiddleMenuList.add(middleMenuDto);
				}
				List<LoginMenuDto> subSmallMenuList = new ArrayList<LoginMenuDto>();
				for(LoginMenuDto smallMenuDto:smallMenuList) {
					String smallParMenuId = smallMenuDto.getParMenuId();
					if(middleMenuId.equals(smallParMenuId)) {
						subSmallMenuList.add(smallMenuDto);
					}
				}
				middleMenuDto.setSubMenuList(subSmallMenuList);
			}
			bigMenuDto.setSubMenuList(subMiddleMenuList);
		}
		
		try {
			if(!moveFlag) {	//조직이동은 로그인카운트를 update하지 않고 평가페이지로 가지 않는다.
				commonDao.updateLoginCount(loginUserDto.getUserId());
			} else {
				loginUserDto.setEvaluate(false);
			}
			//채팅로그인
			commonDao.saveChatLogin(loginUserDto.getUserId(), loginUserDto.getBorgId(), loginUserDto.getUserNm(), loginUserDto.getBorgNm());
		} catch(Exception e) {
			
			logger.error("Login Count update error"+e);
		}
		
		return loginUserDto;
	}

	/**
	 * 메뉴와 로그인사용자의 권한에 따른 영역정보을 가져옴
	 * @param menuId
	 * @param roleList
	 * @return
	 */
	public List<ActivitiesDto> getUseActivityList(String menuId, List<LoginRoleDto> roleList) {
		Map<String, Object> searchMap = new HashMap<String, Object>();
		searchMap.put("menuId", menuId);
		searchMap.put("roleList", roleList);
		/*----------메뉴가 대메뉴이고 하위메뉴가 있다면 하위메뉴의 번호로 영역정보을 가져옴----------*/
		String subMenuId = commonDao.selectSubMenuIdByMenuId(menuId);
		if(subMenuId!=null) {
			searchMap.put("menuId", subMenuId);
		}
		return commonDao.selectUseActivityList(searchMap);
	}

	/**
	 * 코드타입으로 코드정보를 가져옴 
	 * @param codeTypeCd 
	 * @param isUse
	 * @return
	 */
	public List<CodesDto> getCodeList(String codeTypeCd, int isUse) {
		Map<String, Object> searchMap = new HashMap<String, Object>();
		searchMap.put("codeTypeCd", codeTypeCd);
		searchMap.put("isUse", isUse);
		return commonDao.selectCodeList(searchMap);
	}
	
	/**
	 * 코드타입으로 코드정보를 가져옴 (codeVal2로 필터링하여 가져옴)
	 * @param codeTypeCd
	 * @param isUse
	 * @param codeVal2
	 * @return
	 */
	public List<CodesDto> getCodeList(String codeTypeCd, int isUse, String codeVal2) {
		Map<String, Object> searchMap = new HashMap<String, Object>();
		searchMap.put("codeTypeCd", codeTypeCd);
		searchMap.put("isUse", isUse);
		searchMap.put("codeVal2", codeVal2);
		return commonDao.selectCodeList(searchMap);
	}

	/**
	 * 서비스유형에 따른 사용자 리스트 개수
	 * @param params
	 * @return
	 */
	public int getSvcUserListCnt(Map<String, Object> params) {
		return commonDao.selectSvcUserListCnt(params);
	}

	/**
	 * 서비스유형에 따른 사용자 리스트
	 * @param params
	 * @param page
	 * @param rows
	 * @return
	 */
	public List<LoginUserDto> getSvcUserList(Map<String, Object> params, int page, int rows) {
		return commonDao.selectSvcUserList(params, page, rows);
	}
	
	/**
	 * 사용자등록(사용자등록, 소속조직등록, 사용자조직역할등록)
	 * @param saveMap
	 */
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false)
	public void regUser(Map<String, Object> saveMap) throws Exception {
		int userCnt = commonDao.selectUserCntByLoginId((String)saveMap.get("loginId"));
		if(userCnt>0) { throw new Exception("로그인아이디가 존재합니다."); }
		int userId = seqMpUsersService.getNextIntegerId();
		saveMap.put("userId", userId);
		String svcTypeCd = (String)saveMap.get("svcTypeCd");
		
		commonDao.insertUser(saveMap);	//smpusers 등록
		commonDao.insertBorgUser(saveMap);	//smpborgs_users 등록
		
		Map<String, Object> srcParams = new HashMap<String, Object>();
		srcParams.put("srcSvcTypeCd", svcTypeCd);
		srcParams.put("srcIsUse", 1);
		srcParams.put("srcInitIsRole", 1);
		List<RoleDto> initRoleList = roleDao.selectRoleList(srcParams);	//svcTypeCd의 사용자 초기권한 리스트
		for(RoleDto roleDto : initRoleList) {
			saveMap.put("roleId", roleDto.getRoleId());
			saveMap.put("borgScopeCd", roleDto.getBorgScopeCd());
			
			commonDao.insertBorgUserRole(saveMap);	//smpborgs_users_roles 등록
		}
	}

	/**
	 * 사용자수정
	 * @param saveMap
	 */
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false)
	public void modUser(Map<String, Object> saveMap) throws Exception {
		commonDao.updateUser(saveMap);
	}

	/**
	 * 첨부파일 정보 가져오기
	 * @param attach_seq
	 * @return
	 */
	public List<AttachInfoDto> getAttachList(String[] attach_seq) {
		return commonDao.selectAttachList(attach_seq);
	}

	/**
	 * 첨부파일정보 저장하고 다시 보내기
	 * @param saveMap
	 * @return
	 */
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false)
	public Map<String, Object> saveUploadFile(Map<String, Object> saveMap) throws Exception {
		String attach_seq = (String)saveMap.get("attach_seq");
		if(attach_seq==null || "".equals(attach_seq)) {
			saveMap.put("attach_seq", seqMpAttachInfoService.getNextStringId());
			commonDao.insertAttachInfo(saveMap);
		}
		commonDao.updateAttachInfo(saveMap);
		return saveMap;
	}

	/**
	 * 고객사팝업검색조회 가져오기
	 * @param params
	 * @return
	 */
	public int getBuyBorgDivListCnt(Map<String, Object> params) {
		return commonDao.selectBuyBorgDivListCnt(params);
	}
	public List<BorgDto> getBuyBorgDivList(Map<String, Object> params, int page, int rows) {
		return commonDao.selectBuyBorgDivList(params, page, rows);
	}

	/**
	 * 공급사팝업검색 조회 가져오기
	 * @param params
	 * @return
	 */
	public int getVendorDivListCnt(Map<String, Object> params) {
		return commonDao.selectVendorDivListCnt(params);
	}

	public List<BorgDto> getVendorDivList(Map<String, Object> params, int page,int rows) {
		return commonDao.selectVendorDivList(params, page, rows);
	}
	
	
	/*-----------------------------------------Email, Sms 관련 서비스 시작---------------------------------------------*/
	/**
	 * SMS 즉시 전송
	 * @param receiveNum : 받는번호
	 * @param sendMessage : 전송메시지
	 */
	public void sendRightSms(String receiveNum, String sendMessage) {
		sendRightSms(receiveNum, sendMessage, "");
	}
	public void sendRightSms(String receiveNum, String sendMessage, boolean isDirect) {
		sendRightSms(receiveNum, sendMessage, "", isDirect);
	}
	/**
	 * SMS 즉시 전송
	 * @param receiveNum : 받는번호
	 * @param sendMessage : 전송메시지
	 * @param senderNum : 보내는번호
	 */
	public void sendRightSms(String receiveNum, String sendMessage, String senderNum) {
		sendSeserveSms(receiveNum, sendMessage, "", senderNum, false);
	}
	public void sendRightSms(String receiveNum, String sendMessage, String senderNum, boolean isDirect) {
		sendSeserveSms(receiveNum, sendMessage, "", senderNum, isDirect);
	}
	/**
	 * SMS 예약 전송
	 * @param receiveNum : 받는번호
	 * @param sendMessage : 전송메시지
	 * @param sendDate : 예약일시(2012-11-27 18:00)
	 */
	public void sendSeserveSms(String receiveNum, String sendMessage, String sendDate) {
		sendSeserveSms(receiveNum, sendMessage, sendDate, "", false);
	}
	public void sendSeserveSms(String receiveNum, String sendMessage, String sendDate, boolean isDirect) {
		sendSeserveSms(receiveNum, sendMessage, sendDate, "", isDirect);
	}
	/**
	 * SMS 예약 전송
	 * @param receiveNum : 받는번호
	 * @param sendMessage : 전송메시지
	 * @param sendDate : 예약일시(2012-11-27 18:00)
	 * @param senderNum : 보내는번호
	 * @param isDirect : 즉시발송여부
	 */
	public void sendSeserveSms(String receiveNum, String sendMessage, String sendDate, String senderNum) {
		sendSeserveSms(receiveNum, sendMessage, sendDate, senderNum, false);
	}
	public void sendSeserveSms(String receiveNum, String sendMessage, String sendDate, String senderNum, boolean isDirect) {
		try{
			/**********(23시~08시) SMS 8시로 예약: 즉시발송 제외 [시작]**********/
			SimpleDateFormat timeFormat = new SimpleDateFormat("H");
			Time time = new Time(System.currentTimeMillis());
			int clock = Integer.valueOf(timeFormat.format(time));
			if(sendDate.equals("") && (clock>=23 || clock<8) && !isDirect) {
				if(clock>=23) {
					sendDate = (CommonUtils.getCustomDay("",1)).replaceAll("-", "") + "080000";
				} else {
					sendDate = (CommonUtils.getCurrentDate()).replaceAll("-", "") + "080000";
				}
			}
			/**********(23시~08시) SMS 8시로 예약: 즉시발송 제외 [끝]**********/
			
			if(receiveNum!=null && !"".equals(receiveNum)) {
				Map<String, Object> saveMap = new HashMap<String, Object>();
				saveMap.put("call_to", receiveNum.replace("-", ""));
//				receiveNum = "01041544632";
//				saveMap.put("call_to", receiveNum);
				
				//메세지 내용 바이트 체크
				int cnt=0;
				char[] sendMessageArr = sendMessage.toCharArray();
				for(int i=0; i<sendMessageArr.length; i++){
					if(sendMessageArr[i] >= '\uAC00' && sendMessageArr[i] <= '\uD7A3'){
						cnt = cnt+2;
					}else{
						cnt = cnt+1;
					}
				}
				if(cnt > 80){//80byte 보단 크면 mms 아니면 sms 코드값 등록
					saveMap.put("used_cd", "10");
					saveMap.put("content_cnt", "1");
					saveMap.put("content_mime_type", "text/plain");
				}else{
					saveMap.put("used_cd", "00");
					saveMap.put("content_cnt", "0");
					saveMap.put("content_mime_type", " ");
				}
				saveMap.put("sms_txt", sendMessage);
				String transmissionDate = "";
				if(!"".equals(sendDate)){
					transmissionDate = sendDate.replaceAll("-", "");
					transmissionDate = transmissionDate.replaceAll(":", "");
					transmissionDate = transmissionDate.replaceAll(" ", "");
				}
				saveMap.put("req_date", sendDate);
				if(senderNum==null || "".equals(senderNum)) {
					senderNum = Constances.ETC_MOBILE_SENDERNUM;
				}
				saveMap.put("transmissionDate", transmissionDate);
				saveMap.put("call_from", senderNum);
				saveMap.put("cmpMsgId", this.createCmpMsgId());
//				saveMap.put("seqMmsId", this.createCmpMsgId());
				saveMap.put("seqMmsId", seqMmsId.getNextStringId());
				
//				commonDao.insertMsgData(saveMap); //쏜다넷 SMS 테이블 인써트 부분
//				commonDao.insertMsgSktelink(saveMap);
				commonDao.insertTblSubmitQueue(saveMap);//SKTelink MMS 전송
			}
		} catch(Exception e) {}
	}
	
	/**
	 * 권한을 가진 운영사담당자 핸드폰번호
	 * @param roleCd("ADM_REG":조직등록 확인담당자)
	 * @return Array
	 */
	@Deprecated
	public String[] getSmsNumByAdminRole(String roleCd) {
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("roleCd", roleCd);
		return commonDao.selectSmsNumByAdminRole(roleCd);
	}
	
	/**
	 * 메일발송하기 위해 메일관리테이블에 정보을 등록
	 * @param reveiveMailAddrString (수신자메일주소, 여러명일경우[;]로 구분)
	 * @param mailSubject
	 * @param mailContents
	 * @throws Exception 
	 */
	public void saveSendMail(String reveiveMailAddrString, String mailSubject, String mailContents) {
		try {
			String[] reveiveMailAddrArray = reveiveMailAddrString.split(";");
			String receiveMailAddress = "";
			for(String reveiveMailAddr : reveiveMailAddrArray) {
				if(CommonUtils.isCheckMailAddr(reveiveMailAddr)) {
					if("".equals(receiveMailAddress)) receiveMailAddress = reveiveMailAddr;
					else receiveMailAddress = ";" + reveiveMailAddr;
				}
			}
			if(!"".equals(receiveMailAddress)) {
				Map<String, Object> saveMap = new HashMap<String, Object>();
				saveMap.put("mailSeq", seqMpMailInfoService.getNextStringId());
				saveMap.put("mailSubject", mailSubject);
//				saveMap.put("mailContents", CommonUtils.setMailContents(mailContents));
				saveMap.put("mailContents", mailContents);
				saveMap.put("reveiveMailAddr", receiveMailAddress);
				commonDao.insertMailInfo(saveMap);
			}
		} catch(Exception e) {
			logger.error("saveSendMail error : "+e);
		}
	}
	
	/**
	 * UserId로 SMS, Email 발송여부을 알수 있다.
	 * @param userId
	 * @return
	 */
	@Deprecated
	public ReceiveInfoDto getReceiveInfoDtoByUserId(String userId) {
		return commonDao.selectReceiveInfoDtoByUserId(userId);
	}
	/**
	 * 운영자권한코드로  SMS, Email 발송여부을 알수 있다.
	 * @param roleCd
	 * @return
	 */
	@Deprecated
	public List<ReceiveInfoDto> getAdminReceiveInfoDtoByRoleCd(String AdminRoleCd) {
		return commonDao.selectAdminReceiveInfoDtoByRoleCd(AdminRoleCd);
	}
	/**
	 * 조직의 사용자들 SMS, Email 발송여부을 알수 있다.
	 * @param borgId
	 * @return
	 */
	public List<ReceiveInfoDto> getReceiveInfoDtoByBorgId(String borgId) {
		return commonDao.selectReceiveInfoDtoByBorgId(borgId);
	}
	/**
	 * 법인Id로 관리자Sms,Email 정보 가져오기 	-> 운영사의 법인관리는 사용하지 않음(getManagerSmsEmailInfoByManageBranchId 로 변경 처리)
	 * @param manageClientId
	 * @return
	 */
	@Deprecated
	public List<SmsEmailInfo> getManagerSmsEmailInfoByManageClientId(String manageClientId) {
		return commonDao.selectManagerSmsEmailInfoByManageClientId(manageClientId);
	}
	/**
	 * 법인Id로 관리자Sms,Email 정보 가져오기
	 * @param manageClientId
	 * @return
	 */
	public List<SmsEmailInfo> getManagerSmsEmailInfosByManageClientId(String manageClientId) {
		return commonDao.selectManagerSmsEmailInfosByManageClientId(manageClientId);
	}
	/**
	 * 사업장Id로 공사유형담당자 Sms,Email 정보 가져오기
	 * @param branchId
	 * @return
	 */
	public List<SmsEmailInfo> getManagerSmsEmailInfoByManageBranchId(String branchId) {
		return commonDao.selectManagerSmsEmailInfoByManageBranchId(branchId);
	}
	
	/**
	 * 사업장ID로 채권관리자 Sms,Email 정보 가져오기
	 * @param branchId
	 * @return
	 */
	public List<SmsEmailInfo> getBondManagerSmsEmailInfoByBranchId(String branchId) {
		return commonDao.selectBondManagerSmsEmailInfoByBranchId(branchId);
	}
	
	/**
	 * 권한CD로 관리자Sms,Email 정보 가져오기
	 * @param roleCd
	 * @return
	 */
	public List<SmsEmailInfo> getApproverSmsEmailInfoByRoleCd(String roleCd) {
		return commonDao.selectApproverSmsEmailInfoByRoleCd(roleCd);
	}
	/**
	 * 사용자 일련번호로 Sms,Email 정보 가져오기 
	 * @param userid
	 * @return
	 */
	public SmsEmailInfo getUserSmsEmailInfoByUserId(String userid) {
		return commonDao.selectUserSmsEmailInfoByUserId(userid);
	}
	/**
	 * 공급사일련번호로 공급사사용자 Sms,Email 정보 가져오기
	 * @param vendorId
	 * @return
	 */
	public List<SmsEmailInfo> getVendorUserSmsEmailInfoByVendorId(String vendorId) {
		return commonDao.selectVendorUserSmsEmailInfoByVendorId(vendorId);
	}
	/**
	 * 주문번호로 수동물량배분주문의 메일과SMS 발송을 위한 정보을 가져옴
	 * @param string
	 * @return
	 */
	public Map<String, Object> getOrderDistributeEmailSmsByOrderNum(String orderNum) {
		return commonDao.selectOrderDistributeEmailSmsByOrderNum(orderNum);
	}
	/**
	 * 주문번호로 발주의뢰주문(자동물량배분포함)의 메일과SMS 발송을 위한 정보을 가져옴
	 * @param string
	 * @return
	 */
	public List<Map<String, Object>> getOrderEmailSmsListByOrderNum(String orderNum) {
		return commonDao.selectOrderEmailSmsListByOrderNum(orderNum);
	}
	/**
	 * 주문번호로 주문요청(담당자에게)/발주의뢰(공급사에게)시 관련자에게 SMS/Email을 발송
	 * @param orderNum
	 */
	public void exeOrderRequestSmsEmailByOrderNum(String orderNum) {
		if(orderNum!=null && orderNum.length()>0) {
//			Map<String,Object> tmpEmailSmsMap = this.getOrderDistributeEmailSmsByOrderNum(orderNum);	//수동물량배분 리스트
			//수동물량배분시 리스트
			List<Map<String, Object>> isDistributeList = this.getOrderDistributeEmailSmsByOrderNumList(orderNum);
			/*****************************************물량배분시 SMS/Email 발송 Start***************************************/
			if(isDistributeList.size() > 0) {
				for(int i=0; i<isDistributeList.size(); i++){
					Map<String, Object> tempMap = new HashMap<String, Object>();
//					String orde_iden_numb = (String) tmpEmailSmsMap.get("orde_iden_numb");
//					String good_name = (String) tmpEmailSmsMap.get("good_name");
//					int orderProdCnt =  (Integer) tmpEmailSmsMap.get("orderProdCnt");
//					String clientid = (String) tmpEmailSmsMap.get("clientid");
//					String borgNms = (String) tmpEmailSmsMap.get("borgNms");
//					String branchNm = (String) tmpEmailSmsMap.get("branchNm");
//					String branchId = (String) tmpEmailSmsMap.get("branchId");
					
					/**
					tempMap.put("ordeIdenNumb", isDistributeList.get(i).get("orde_iden_numb").toString());
					tempMap.put("ordeSequNumb", isDistributeList.get(i).get("orde_sequ_numb").toString());
					tempMap.put("goodName", isDistributeList.get(i).get("good_name").toString());
					tempMap.put("branchNm", isDistributeList.get(i).get("branchNm").toString());
					tempMap.put("borgNms", isDistributeList.get(i).get("borgNms").toString());
					tempMap.put("productManager", isDistributeList.get(i).get("product_manager").toString());
					tempMap.put("goodIdenNumb", isDistributeList.get(i).get("good_iden_numb").toString());
					*/
					
					//법인담당 운영자에게 SMS/Email발송
					//List<SmsEmailInfo> managerSmsEmailInfoList = this.getManagerSmsEmailInfoByManageClientId(clientid);	//법인담당 운영자 Email,Sms 정보 가져오기
					List<SmsEmailInfo> managerSmsEmailInfoList = this.getManagerSmsEmailInfoByManageBranchId(isDistributeList.get(i).get("branchId").toString());	//사업장의 공사유형담당자(운영사) Email,Sms 정보 가져오기
//					String receiveMailer = "";
					for(SmsEmailInfo smsEmailInfo : managerSmsEmailInfoList) {
						if(smsEmailInfo.isSms()) {
							try {
								this.sendRightSms(smsEmailInfo.getMobileNum(), "["+isDistributeList.get(i).get("branchNm").toString()+"]의 물량배분주문 요청이 왔습니다.");
							} catch(Exception e) {
								logger.error("SMS(exeOrderRequestSmsEmail) Save Errro : "+e);
							}
						}
//						if(smsEmailInfo.isEmail()) {
//							if("".equals(receiveMailer)) receiveMailer = smsEmailInfo.getEmailAddr();
//							else receiveMailer = receiveMailer + ";" + smsEmailInfo.getEmailAddr();
//						}
					}
//					if(!"".equals(receiveMailer)) {
//						String mailContents = "";
//						mailContents += "물량배분주문 요청<p>";
//						mailContents += "주문번호 : ["+orde_iden_numb+"]<br>";
//						if(orderProdCnt>1) mailContents += "상품명 : ["+good_name+"]외 "+(orderProdCnt-1)+"건<br>";
//						else mailContents += "상품명 : ["+good_name+"]<br>";
//						mailContents += "고객사명 : ["+borgNms+"]<p>";
//						mailContents += "주문관리 > 물량배분 발주처리 메뉴에서 확인하십시오";
//						this.saveSendMail(receiveMailer, "[OK플라자] 물량배분주문요청", mailContents);
//					}
					
					/**
					//상품담당자에게 SMS/E-mail 발송되게 처리
					SmsEmailInfo productManagerSmsEmailInfo = this.getProductManagerInfo(tempMap);
					if(productManagerSmsEmailInfo.isSms()){
						this.sendRightSms(productManagerSmsEmailInfo.getMobileNum(), "["+tempMap.get("branchNm").toString()+"]의 물량배분주문 요청이 왔습니다.");
					}
					if(productManagerSmsEmailInfo.isEmail()){
						String mailContents = "";
						mailContents += "물량배분주문 요청<p>";
						mailContents += "주문번호 : ["+tempMap.get("ordeIdenNumb").toString()+"-"+tempMap.get("ordeSequNumb").toString()+"]<br>";
						mailContents += "상품명 : ["+tempMap.get("goodName").toString()+"]<br>";
						mailContents += "구매사명 : ["+tempMap.get("borgNms").toString()+"]<p>";
						mailContents += "수발주관리 > 주문관리 > 물량배분 발주처리 메뉴에서 확인하십시오";
						this.saveSendMail(productManagerSmsEmailInfo.getEmailAddr(), "[OK플라자] 물량배분주문요청", mailContents);
					}
					*/
				}
			}
			/*****************************************물량배분시 SMS/Email 발송 End***************************************/
			
			/**
			List<Map<String,Object>> tmpEmailSmsList = this.getOrderEmailSmsListByOrderNum(orderNum);	//발주의뢰 리스트(자동물량배분 포함)
			//공급사에게 SMS/Email발송
			for(Map<String,Object> pur_tmpEmailSmsMap : tmpEmailSmsList) {
				String pur_orde_iden_numb = (String) pur_tmpEmailSmsMap.get("orde_iden_numb");
				String pur_vendorid = (String) pur_tmpEmailSmsMap.get("vendorid");
				String pur_good_name = (String) pur_tmpEmailSmsMap.get("good_name");
				int pur_orderProdCnt =  (Integer) pur_tmpEmailSmsMap.get("orderProdCnt");
				String pur_borgNms = (String) pur_tmpEmailSmsMap.get("borgNms");
				List<SmsEmailInfo> vendorSmsEmailInfoList = this.getVendorUserSmsEmailInfoByVendorId(pur_vendorid);	//공급사 Email,Sms 정보 가져오기
				for(SmsEmailInfo smsEmailInfo : vendorSmsEmailInfoList) {
					if(smsEmailInfo.isSms() && "1".equals(smsEmailInfo.getSmsByPurchaseOrder())) {
						try {
							this.sendRightSms(smsEmailInfo.getMobileNum(), "주문의뢰 정보가 있습니다.");
						} catch(Exception e) {
							logger.error("SMS(exeOrderRequestSmsEmail) Save Errro : "+e);
						}
					}
					if(smsEmailInfo.isEmail() && "1".equals(smsEmailInfo.getEmailByPurchaseOrder())) {
						String mailContents = "";
						mailContents += "발주을 의뢰합니다.<p>";
						mailContents += "주문번호 : ["+pur_orde_iden_numb+"]<br>";
						if(pur_orderProdCnt>1) mailContents += "상품명 : ["+pur_good_name+"]외 "+(pur_orderProdCnt-1)+"건<br>";
						else mailContents += "상품명 : ["+pur_good_name+"]<br>";
						mailContents += "고객사명 : ["+pur_borgNms+"]<p>";
						mailContents += "납품관리 > 발주접수 메뉴에서 확인 가능합니다.";
						this.saveSendMail(smsEmailInfo.getEmailAddr(), "[OK플라자] 주문의뢰 ", mailContents);
					}
				}
			}
			*/
		}
	}
	
	/**
	 * 주문번호로 주문요청(담당자에게)/발주의뢰(공급사에게)시 관련자에게 SMS/Email을 발송<br/>
	 * (선입금 여부에 따라 케이스 추가.)<br/>
	 * 선입금 여부, 물량배분 관련 로직 시 email 은 발송하지 않음. ( 운영사 유지보수 요청사항. 문자만 전송 )<br/>
	 * @throws Exception 
	 */
	public void exeNewOrderRequestSmsEmailByOrderNum(String orderNum) throws Exception {
		if(orderNum!=null && orderNum.length() > 0) {
            /********************************		감독관 사용자에게 주문 정보 sms 발송.		********************************/
			// 05 (승인 요청)상태  관련하여 처리 로직 없음.
			
            /********************************		물량배분, 선입금 주문 정보 sms 발송.		********************************/
			Map<String,Object> tmpEmailSmsMap 	= this.getOrderDistributeEmailSmsByOrderNum(orderNum);	//수동물량배분 리스트
			if(null != tmpEmailSmsMap){		// 물량배분 상품이 존재할 경우 아래 로직 실행.
				String orde_iden_numb 				= (String) tmpEmailSmsMap.get("orde_iden_numb");
				String branchNm 					= (String) tmpEmailSmsMap.get("branchNm");
				String branchId 					= (String) tmpEmailSmsMap.get("branchId");
				String prepay 						= (String) tmpEmailSmsMap.get("prepay");
				String orde_stat_flag 						= (String) tmpEmailSmsMap.get("orde_stat_flag");
				if("1".equals(prepay)){				// 선입금 여부가 1 일경우 운영사 채권담당자 "lovely" 사용자에게 sms 발송.
					//2016-02-23 요청사항 처리
                    //SMS 발송되는 문자 내용을 아래와 같이 변경하여 처리 요청 드립니다.
                    //"주문하신 건(주문 번호 ADBD12345646) 에 대한 OOOO원을 선입금하여
                    //  주시길 바랍니다. SKTS 올림 "
                    //발신자 번호 : 송태리 대리님 (02-2129-2049)
                    Map<String,Object> orderInfo  = commonDao.selectOrderPrepayInfo(orderNum);	
                    if(orderInfo != null){
                        String smsContent = 
                        		"[Okplaza] 주문하신 건(주문 번호 "+orderNum+") 에 대한 "
                                +CommonUtils.getDecimalAmount(
                                		( ((BigDecimal)orderInfo.get("PREPAY_PRICE")).doubleValue() + ((BigDecimal)orderInfo.get("PREPAY_PRICE")).doubleValue()/10 )
                                	)
                                +"원을 선입금하여 주시길 바랍니다. SKTS 올림";
                        String receiveUserId = CommonUtils.getString((String)orderInfo.get("ORDE_USER_ID"));
                        SmsEmailInfo smsEmailInfo = getUserSmsEmailInfoByUserId(receiveUserId);
                        if(smsEmailInfo.isSms()) {
                            try {
                                this.sendRightSms(smsEmailInfo.getMobileNum(), smsContent, "0221292049");
                            } catch(Exception e) {
                                logger.error("SMS(exeOrderRequestSmsEmail new prepay client) Save error : "+e);
                            }
                        }
                    }
                    
                    // 정연백과장 요청으로 SMS 미발송 처리 by kkbum2000 20160701
//					SmsEmailInfo smsEmailInfo = getUserSmsEmailInfoByUserId("lovely");
//					if(smsEmailInfo.isSms()) {
//						try {
//							this.sendRightSms(smsEmailInfo.getMobileNum(), "주문번호 ["+orde_iden_numb+"] 선입금 주문처리 요청이 왔습니다.");
//						} catch(Exception e) {
//							logger.error("SMS(exeOrderRequestSmsEmail new prepay admin) Save error : "+e);
//						}
//					}
				}else if("10".equals(orde_stat_flag)){// 선입금 여부가 0 이고, 상태가 10(주문요청) 일때 아래 실행. 05(승인요청) 은 아래 로직 실행하지 않음. 
					List<SmsEmailInfo> managerSmsEmailInfoList = this.getManagerSmsEmailInfoByManageBranchId(branchId);	//사업장의 공사유형담당자(운영사) Email,Sms 정보 가져오기
					for(SmsEmailInfo smsEmailInfo : managerSmsEmailInfoList) {
						if(smsEmailInfo.isSms()) {
							try {
								this.sendRightSms(smsEmailInfo.getMobileNum(), "["+branchNm+"]의 물량배분주문 요청이 왔습니다.");
							} catch(Exception e) {
								logger.error("SMS(exeOrderRequestSmsEmail new) Save error : "+e);
							}
						}
					}
				}
			}
					
            /********************************		주문의뢰 주문 정보 sms/email 발송.		********************************/
			List<Map<String,Object>> tmpEmailSmsList = this.getOrderEmailSmsListByOrderNum(orderNum);	//발주의뢰 리스트(자동물량배분 포함)
			//공급사에게 SMS/Email발송
			for(Map<String,Object> pur_tmpEmailSmsMap : tmpEmailSmsList) {
				String pur_orde_iden_numb = (String) pur_tmpEmailSmsMap.get("orde_iden_numb");
				String pur_vendorid = (String) pur_tmpEmailSmsMap.get("vendorid");
				String pur_good_name = (String) pur_tmpEmailSmsMap.get("good_name");
				int pur_orderProdCnt =  (Integer) pur_tmpEmailSmsMap.get("orderProdCnt");
				String pur_borgNms = (String) pur_tmpEmailSmsMap.get("borgNms");
				List<SmsEmailInfo> vendorSmsEmailInfoList = this.getVendorUserSmsEmailInfoByVendorId(pur_vendorid);	//공급사 Email,Sms 정보 가져오기
				for(SmsEmailInfo smsEmailInfo : vendorSmsEmailInfoList) {
					if(smsEmailInfo.isSms() && "1".equals(smsEmailInfo.getSmsByPurchaseOrder())) {
						try {
							// 정연백 과장 요청으로 SMS 내용 변경 by kkbum2000 20160701
							this.sendRightSms(smsEmailInfo.getMobileNum(), "[Okplaza] 주문의뢰 정보가 있습니다. 주문접수 처리 요청 드립니다. ");
						} catch(Exception e) {
							logger.error("SMS(exeOrderRequestSmsEmail new ) Save error : "+e);
						}
					}
					if(smsEmailInfo.isEmail() && "1".equals(smsEmailInfo.getEmailByPurchaseOrder())) {
						String mailContents = "";
						mailContents += "발주을 의뢰합니다.<p>";
						mailContents += "주문번호 : ["+pur_orde_iden_numb+"]<br>";
						if(pur_orderProdCnt>1) mailContents += "상품명 : ["+pur_good_name+"]외 "+(pur_orderProdCnt-1)+"건<br>";
						else mailContents += "상품명 : ["+pur_good_name+"]<br>";
						mailContents += "고객사명 : ["+pur_borgNms+"]<p>";
						mailContents += "납품관리 > 발주접수 메뉴에서 확인 가능합니다.";
						this.saveSendMail(smsEmailInfo.getEmailAddr(), "[OK플라자] 주문의뢰 ", mailContents);
					}
				}
			}
			
		}
	}
	
	/** 고객사의 주문 취소 요청에 대해서 공급사 사용자에게 sms 전송하기 */
	public void exeOrderCancelRequestSmsByOrderInfo(String ordeIdenNumb, String ordeSequNumb, String purcIdenNumb) {
		Map<String, String> tmpParamMap = new HashMap<String, String >();
		tmpParamMap.put("ordeIdenNumb", ordeIdenNumb);
		tmpParamMap.put("ordeSequNumb", ordeSequNumb);
		tmpParamMap.put("purcIdenNumb", purcIdenNumb);
		List<Map<String,Object>> tmpSmsList = commonDao.selectOrderSmsListByCancelRequest(tmpParamMap);	
		if(tmpSmsList != null && tmpSmsList.size() > 0){
			for(Map<String,Object> tmpSmsMap : tmpSmsList) {
				String userid = (String)tmpSmsMap.get("USERID"); // sms 받을 공급사 사용자
				// 정연백 과장 요청으로 SMS 내용 변경 by kkbum2000 20160701
				String smsContent  = "[Okplaza] 주문번호 ["+ordeIdenNumb+"-"+ordeSequNumb+"] 의 주문취소 요청이 있습니다. 확인 처리 요청 드립니다.";
				SmsEmailInfo smsEmailInfo = this.getUserSmsEmailInfoByUserId(userid);	//공급사 사용자의 Sms 정보 가져오기
				if(smsEmailInfo.isSms()) {// 주문취소요청에 대해서는 sms 수신여부가 true 일때만 문자 전송함. 
                    try {
                        this.sendRightSms(smsEmailInfo.getMobileNum(), smsContent);
                    } catch(Exception e) {
                        logger.error("SMS(exeOrderCancelRequestSmsByOrderInfo) Save error : "+e);
                    }
                }
			}
		}
	}
	
	
	/**
	 * 발주접수/출하/인수 메일/SMS 발송
	 * 주문번호,주문차수,발주차수의 배열정보로 메일,SMS발송 정보을 가져옴
	 * 메일,SMS발송 정보을 이용하여 주문자에게  발송
	 * @param orderNumFullArray	: (주문번호-주문차수-발주차수)
	 * @param orderStatus	: (발주접수:50, 출하:60, 인수:70)
	 */
	public void exeOrderReceiveDeliverySmsEmailByOrderNum(String[] orderNumFullArray, String orderStatus) {
		if(orderNumFullArray!=null && orderNumFullArray.length>0) {
			List<Map<String,Object>> tmpEmailSmsList = commonDao.selectOrderEmailSmsListByOrderNumArray(orderNumFullArray);	//발주접수, 출하 리스트
			for(Map<String,Object> tmpEmailSmsMap : tmpEmailSmsList) {
				String orde_iden_numb = (String) tmpEmailSmsMap.get("orde_iden_numb");
				String orde_sequ_numb = (String) tmpEmailSmsMap.get("orde_sequ_numb");
				String vendorNm = (String) tmpEmailSmsMap.get("vendorNm");
				String orde_user_id = (String) tmpEmailSmsMap.get("orde_user_id");
				int orderProdCnt =  (Integer) tmpEmailSmsMap.get("orderProdCnt");
				String good_name = (String) tmpEmailSmsMap.get("good_name");
				String vendorid = (String) tmpEmailSmsMap.get("vendorid");
				String borgNms = (String) tmpEmailSmsMap.get("borgNms");
				String branchNm = (String) tmpEmailSmsMap.get("branchNm");
				String phonenum = (String) tmpEmailSmsMap.get("phonenum");
				
				if("50".equals(orderStatus)) {
					// 정연백 과장 요청으로 미발송 처리 20160701 by kkbum2000 
					SmsEmailInfo smsEmailInfo = this.getUserSmsEmailInfoByUserId(orde_user_id);	//주문자 Email,Sms 정보 가져오기
					String smsSendMsg = "["+vendorNm+"]에서 발주접수 하였습니다.";
					if(phonenum != null && !"".equals(phonenum)) smsSendMsg += vendorNm + "공급사 " + phonenum;
					String emailSubject = "[OK플라자] ["+vendorNm+"] 발주접수 ";
					String emailContents = "공급사에서 발주접수 하였습니다.<p>";
					emailContents += "주문번호 : ["+orde_iden_numb+"]<br>";
					if(orderProdCnt>1) emailContents += "상품명 : ["+good_name+"]외 "+(orderProdCnt-1)+"건<br>";
					else emailContents += "상품명 : ["+good_name+"]<br>";
					emailContents += "공급사명 : ["+vendorNm+"]<p>";
					emailContents += "주문내역 메뉴에서 확인 가능합니다.";
					if(smsEmailInfo.isSms() && "1".equals(smsEmailInfo.getSmsByPurchase())) {
						try {
							this.sendRightSms(smsEmailInfo.getMobileNum(), smsSendMsg ,"0220902722" ); //유지보수 454번 요청사항  
						} catch(Exception e) {
							logger.error("SMS(exeOrderReceiveDeliverySmsEmailByOrderNum) Save Errro : "+e);
						}
					}
					if(smsEmailInfo.isEmail() && "1".equals(smsEmailInfo.getEmailByPurchase())) {
						this.saveSendMail(smsEmailInfo.getEmailAddr(), emailSubject, emailContents);
					}
				} else if("60".equals(orderStatus)) {
					/* 정연백과장님 요청사항 20160625 by kkbum2000 
					 * [Okplaza] ['공급사']에서 ['주문번호'-'주문차수'], [00 상품]에 대하여 출하 하였습니다. 
                     * '공급사' 공급사 '공급사전화번호'
					 */
					SmsEmailInfo smsEmailInfo = this.getUserSmsEmailInfoByUserId(orde_user_id);	//주문자 Email,Sms 정보 가져오기
					String smsSendMsg = "[Okplaza] ["+vendorNm+"]에서 ["+orde_iden_numb+"-"+orde_sequ_numb+"],["+good_name+" 상품]에 대하여 출하 하였습니다.";
					if(phonenum != null && !"".equals(phonenum)) smsSendMsg += vendorNm + " 공급사 " + phonenum;
					String emailSubject = "[OK플라자] ["+vendorNm+"] 출하 ";
					String emailContents = "공급사에서 출하 하였습니다.<p>";
					emailContents += "주문번호 : ["+orde_iden_numb+"]<br>";
					if(orderProdCnt>1) emailContents += "상품명 : ["+good_name+"]외 "+(orderProdCnt-1)+"건<br>";
					else emailContents += "상품명 : ["+good_name+"]<br>";
					emailContents += "공급사명 : ["+vendorNm+"]<p>";
					emailContents += "주문내역 메뉴에서 확인 가능합니다.";
					if(smsEmailInfo.isSms() && "1".equals(smsEmailInfo.getSmsByDelivery())) {
						try {
							this.sendRightSms(smsEmailInfo.getMobileNum(), smsSendMsg, phonenum);
						} catch(Exception e) {
							logger.error("SMS(exeOrderReceiveDeliverySmsEmailByOrderNum) Save Errro : "+e);
						}
					}
					if(smsEmailInfo.isEmail() && "1".equals(smsEmailInfo.getEmailByDelivery())) {
						this.saveSendMail(smsEmailInfo.getEmailAddr(), emailSubject, emailContents);
					}
				} else if("70".equals(orderStatus)) {
					String smsSendMsg = "["+branchNm+"]에서 인수확인 하였습니다.";
					String emailSubject = "[OK플라자] ["+borgNms+"] 인수확인 ";
					String emailContents = "고객사에서 인수확인 하였습니다.<p>";
					emailContents += "주문번호 : ["+orde_iden_numb+"]<br>";
					if(orderProdCnt>1) emailContents += "상품명 : ["+good_name+"]외 "+(orderProdCnt-1)+"건<br>";
					else emailContents += "상품명 : ["+good_name+"]<br>";
					emailContents += "고객사명 : ["+borgNms+"]<p>";
					emailContents += "납품관리 > 배송완료 메뉴에서 확인 가능합니다.<br>";
					emailContents += "미배송완료 상태 시 배송완료처리을 하십시오.";
					
					List<SmsEmailInfo> vendorSmsEmailInfoList = this.getVendorUserSmsEmailInfoByVendorId(vendorid);	//공급사 Email,Sms 정보 가져오기
					for(SmsEmailInfo smsEmailInfo : vendorSmsEmailInfoList) {
						// 정연백 과장 요청으로 SMS 미발송 처리 by kkbum2000 20160701
//						if(smsEmailInfo.isSms() && "1".equals(smsEmailInfo.getSmsByOrdrtReceive())) {
//							try {
//								this.sendRightSms(smsEmailInfo.getMobileNum(), smsSendMsg);
//							} catch(Exception e) {
//								logger.error("SMS(exeOrderReceiveDeliverySmsEmailByOrderNum) Save Errro : "+e);
//							}
//						}
						if(smsEmailInfo.isEmail() && "1".equals(smsEmailInfo.getEmailByOrdrtReceive())) {
							this.saveSendMail(smsEmailInfo.getEmailAddr(), emailSubject, emailContents);
						}
					}
				}
			}
		}
	}
	
	/** 주문 승인요청 건에 대해 sms/email 전송 */
	public void exeOrderApprovalRequestSmsEmailByOrderNum(String orderNum) {
		if(orderNum!=null && orderNum.length()>0) {
			Map<String,Object> tmpEmailSmsMap = this.getOrderApprovalRequestEmailSmsByOrderNum(orderNum);	 // 주문 승인요청 주문 정보 가져오기
			if(tmpEmailSmsMap!=null) {
				String orde_iden_numb = (String) tmpEmailSmsMap.get("orde_iden_numb");
				String good_name = (String) tmpEmailSmsMap.get("good_name");
				int orderProdCnt =  (Integer) tmpEmailSmsMap.get("orderProdCnt");
				String borgNms = (String) tmpEmailSmsMap.get("borgNms");
				String branchNm = (String) tmpEmailSmsMap.get("branchNm");
				String directorUserId = (String) tmpEmailSmsMap.get("directorUserId");
				List<SmsEmailInfo> approvalUserSmsEmailInfoList = this.getApprovalUserSmsEmailInfo(directorUserId);	// 주문승인자 Email,Sms 정보 가져오기
				String receiveMailer = "";
				for(SmsEmailInfo smsEmailInfo : approvalUserSmsEmailInfoList) {
					if(smsEmailInfo.isSms()) {
						try {
							/* 정연백 과장님 요청으로 주문접수 SMS 내용변경 처리 20160701 by kkbum2000 */
							this.sendRightSms(smsEmailInfo.getMobileNum(), "[Okplaza] ["+branchNm+"]의 주문 승인요청이 왔습니다. 확인처리 요청 드립니다.");
						} catch(Exception e) {
							logger.error("SMS(exeOrderRequestSmsEmail) Save Errro : "+e);
						}
					}
					if(smsEmailInfo.isEmail()) {
						if("".equals(receiveMailer)) receiveMailer = smsEmailInfo.getEmailAddr();
						else receiveMailer = receiveMailer + ";" + smsEmailInfo.getEmailAddr();
					}
				}
				if(!"".equals(receiveMailer)) {
					String mailContents = "";
					mailContents += "주문 승인요청<p>";
					mailContents += "주문번호 : ["+orde_iden_numb+"]<br>";
					if(orderProdCnt>1) mailContents += "상품명 : ["+good_name+"]외 "+(orderProdCnt-1)+"건<br>";
					else mailContents += "상품명 : ["+good_name+"]<br>";
					mailContents += "고객사명 : ["+borgNms+"]<p>";
					mailContents += "주문승인조회 메뉴에서 확인하십시오";
					this.saveSendMail(receiveMailer, "[OK플라자] 주문 승인요청", mailContents);
				}
			}
		}
	}
	
	private Map<String, Object> getOrderApprovalRequestEmailSmsByOrderNum( String orderNum) {
		return commonDao.selectOrderApprovalRequestEmailSmsByOrderNum(orderNum);
	}
	
	private List<SmsEmailInfo> getApprovalUserSmsEmailInfo(String directorUserId) {
		return commonDao.selectApprovalUserSmsEmailInfo(directorUserId);
	}
	
	/** * 물량배분 상품의 발주의뢰에 대해 sms와 email을 전송한다. */
	public void exePurcRequestSmsEmailByOrderNum(String orderNum, String sequNum, String purcNum) {
		Map<String,Object> pur_tmpEmailSmsMap = this.getOrderEmailSmsListByOrderNumForDivPurc(orderNum,sequNum,purcNum);	//발주의뢰 정보
		//공급사에게 SMS/Email발송
		String pur_orde_iden_numb = (String) pur_tmpEmailSmsMap.get("orde_iden_numb");
		String pur_vendorid = (String) pur_tmpEmailSmsMap.get("vendorid");
		String pur_good_name = (String) pur_tmpEmailSmsMap.get("good_name");
		String pur_borgNms = (String) pur_tmpEmailSmsMap.get("borgNms");
		List<SmsEmailInfo> vendorSmsEmailInfoList = this.getVendorUserSmsEmailInfoByVendorId(pur_vendorid);	//공급사 Email,Sms 정보 가져오기
		for(SmsEmailInfo smsEmailInfo : vendorSmsEmailInfoList) {
			if(smsEmailInfo.isSms() && "1".equals(smsEmailInfo.getSmsByPurchaseOrder())) {
				try {
					// 정연백 과장 요청으로 SMS 내용 변경 by kkbum2000 20160701
					this.sendRightSms(smsEmailInfo.getMobileNum(), "[Okplaza] 주문의뢰 정보가 있습니다. 주문접수 처리 요청 드립니다. ");
				} catch(Exception e) {
					logger.error("SMS(exeOrderRequestSmsEmail) Save Error : "+e);
				}
			}
			if(smsEmailInfo.isEmail() && "1".equals(smsEmailInfo.getEmailByPurchaseOrder())) {
				String mailContents = "";
				mailContents += "주문을 의뢰합니다.<p>";
				mailContents += "주문번호 : ["+pur_orde_iden_numb+"]<br>";
				mailContents += "상품명 : ["+pur_good_name+"]<br>";
				mailContents += "고객사명 : ["+pur_borgNms+"]<p>";
				mailContents += "주문/배송관리 > 주문접수 메뉴에서 확인 가능합니다.";
				this.saveSendMail(smsEmailInfo.getEmailAddr(), "[OK플라자] 주문의뢰", mailContents);
			}
		}
	}
	private Map<String, Object> getOrderEmailSmsListByOrderNumForDivPurc( String orderNum,String sequNum, String purcNum) {
		Map<String, String> params  = new HashMap<String, String>();
		params.put("orderNum", orderNum);
		params.put("sequNum", sequNum);
		params.put("purcNum", purcNum);
		return commonDao.selectOrderEmailSmsListByOrderNumForDivPurc(params);
	}

	/**
	 * 주문 취소 시 호출되는 sms/email method
	 * <br>주문 취소 시 sms/email 발송 대상은 주문의 상태가 발주 접수인 상태가 있을때 해당 공급사에 전송한다.
	 */
	public void exeOrderCancelSmsEmailByOrderNum(String orderNum, String orderSequNum, String cancelReason) {
		List<Map<String,Object>> tmpEmailSmsMapList = this.getOrderEmailSmsListByOrderNumForCancel(orderNum,orderSequNum);	// 주문 취소 정보
		if(tmpEmailSmsMapList!=null && tmpEmailSmsMapList.size()>0) {
			for(Map<String,Object> tmpEmailSmsMap : tmpEmailSmsMapList){
				//공급사에게 SMS/Email발송
				String pur_orde_iden_numb = (String) tmpEmailSmsMap.get("orde_iden_numb");
				String pur_vendorid = (String) tmpEmailSmsMap.get("vendorid");
				String pur_borgNms = (String) tmpEmailSmsMap.get("borgNms");
				List<SmsEmailInfo> vendorSmsEmailInfoList = this.getVendorUserSmsEmailInfoByVendorId(pur_vendorid);	//공급사 Email,Sms 정보 가져오기
				for(SmsEmailInfo smsEmailInfo : vendorSmsEmailInfoList) {
					/* 정연백 과장님 요청으로 SMS 미발송 처리 20160701 by kkbum2000 */
//					if(smsEmailInfo.isSms()) {
//						try {
//							this.sendRightSms(smsEmailInfo.getMobileNum(), "주문취소 정보가 있습니다.");
//						} catch(Exception e) {
//							logger.error("SMS(exeOrderRequestSmsEmail) Save Error : "+e);
//						}
//					}
					if(smsEmailInfo.isEmail()) {
						String mailContents = "";
						mailContents += "주문을 취소합니다.<p>";
						mailContents += "주문번호 : ["+pur_orde_iden_numb+"]<br>";
						mailContents += "고객사명 : ["+pur_borgNms+"]<p>";
						mailContents += "취소사유 : "+cancelReason+"<p>";
						mailContents += "납품관리 > 발주이력 메뉴에서 확인 가능합니다.";
						this.saveSendMail(smsEmailInfo.getEmailAddr(), "[OK플라자] 주문취소", mailContents);
					}
				}
			}
		}
	}
	private List<Map<String, Object>> getOrderEmailSmsListByOrderNumForCancel( String orderNum,String orderSequNum) {
		Map<String , String> params = new HashMap<String, String>();
		params.put("orderNum", orderNum);
		params.put("orderSequNum", orderSequNum);
		return commonDao.selectOrderCancelEmailSmsByOrderNum(params);
	}
	/*-----------------------------------------Email, Sms 관련 서비스 끝---------------------------------------------*/

	/**
	 * 사업장 id를 이용해 사용자정보를 조회한다. 
	 * @param codeTypeCd
	 * @param isUse
	 * @param codeVal2
	 * @return
	 */
	public List<UserDto> getUserInfoListByBranchId(String borgId) {
		Map<String, Object> searchMap = new HashMap<String, Object>();
		searchMap.put("borgId", borgId);
		return commonDao.selectUserInfoListByBranchId(searchMap);
	}
	
	
	/**
	 * 사업장 id를 이용해 사업장 배송지 정보를  조회한다. 
	 * @param codeTypeCd
	 * @param isUse
	 * @param codeVal2
	 * @return
	 */
	public List<DeliveryAddressDto> getDeliveryAddressByBranchId(String groupId, String clientId, String branchId) {
		Map<String, Object> searchMap = new HashMap<String, Object>();
		searchMap.put("groupId", groupId);
		searchMap.put("clientId", clientId);
		searchMap.put("branchId", branchId);
		return commonDao.selectDeliveryAddressByBranchId(searchMap);
	}
	
	
	/**
	 * 사업장 진열 카테고리 정보를 조회한다.  
	 * @param codeTypeCd
	 * @param isUse
	 * @param codeVal2
	 * @return
	 */
	public List<CategoryDto> getDispCateListInfoByBuyBorg(String groupId, String clientId, String branchId) {
		Map<String, Object> searchMap = new HashMap<String, Object>();
		searchMap.put("groupId", groupId);
		searchMap.put("clientId", clientId);
		searchMap.put("branchId", branchId);
		return commonDao.selectDispCateListInfoByBuyBorg(searchMap);
	}

	/**
	 * 우편번호검색(구주소)
	 * @param params
	 * @return
	 */
	public List<Map<String, Object>> getPostAddressList(Map<String, Object> params) {
		return commonDao.selectPostAddressList(params);
	}

	/**
	 * 우편번호검색(신주소)
	 * @param params
	 * @return
	 */
	public List<Map<String, Object>> getNewPostAddressList(Map<String, Object> params) {
		return commonDao.selectNewPostAddressList(params);
	}

	/**
	 * 배송지관리 정보을 등록
	 * @param saveMap
	 */
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false)
	public void regDeliveryManage(Map<String, Object> saveMap) throws Exception {
		String isDefault = (String) saveMap.get("isDefault");
		if("1".equals(isDefault)) {	//기본배송지등록이면 이전 기본배송설정을 아니오로 변경
			commonDao.updateNotDefaultDeliveryInfo(saveMap);
		}
		saveMap.put("deliveryId", seqMpDeliveryInfoService.getNextStringId());
		reqBorgDao.insertDeliveryInfo(saveMap);
	}

	/**
	 * 배송지관리정보을 삭제
	 * @param saveMap
	 */
	public void delDeliveryManage(Map<String, Object> saveMap) {
		commonDao.deleteDeliveryInfo(saveMap);
	}

	/**
	 * 배송지관리정보을 수정(기본여부만 수정)
	 * @param saveMap
	 */
	public void modDeliveryManage(Map<String, Object> saveMap) {
		commonDao.updateNotDefaultDeliveryInfo(saveMap);
		commonDao.updateDeliveryInfo(saveMap);
	}

	/**
	 * 공인인증 존재여부
	 * @param svcTypeCd
	 * @param borgId
	 * @return
	 */
	public boolean getIsExistPublishAuth(String svcTypeCd, String borgId) throws Exception {
		if("BUY".equals(svcTypeCd)) {
			int authCnt = commonDao.selectBuyPublishAuthCntByBranchId(borgId);
			if(authCnt>0) return true;
			else return false;
		} else if("VEN".equals(svcTypeCd)) {
			int authCnt = commonDao.selectVenPublishAuthCntByVendorId(borgId);
			if(authCnt>0) return true;
			else return false;
		} else {
			throw new Exception("서비스 타입이 존재하지 않습니다. 고객사와 공급사만 공인인증 체크을 합니다.");
		}
	}
	
	public void getBorgsDupCnt(Map<String, Object> paramMap) throws Exception{
		String 	borgType = paramMap.get("borgType").toString();
		String 	useType  = paramMap.get("useType").toString();
		int 	dupCnt 	= 0;
		
		if(Constances.COMMON_ISCHECK_SERVER){
			// 업체 등록
			if("REG".equals(useType)){
				if("CLT".equals(borgType)){
					dupCnt = commonDao.getSmpBranchsBusinessNumDupCnt(paramMap.get("businessNum").toString());
				}else if("VEN".equals(borgType)){
					dupCnt = commonDao.getSmpVendorsBusinessNumDupCnt(paramMap.get("businessNum").toString());
				}
				if(dupCnt > 0){
					throw new Exception(" 이미 등록된 업체입니다.\n 확인후 다시 등록해주세요.");
				}
			}
		}
	}
	
	public String[] authBusinessNumber(Map<String, Object> paramMap) throws Exception {
		//사업자 등록번호 중복체크
		getBorgsDupCnt(paramMap);
		
		String[] resultArr = new String[2];
		String signeddata = paramMap.get("signed_data").toString();		// 서명된 값
			
		int nRet;
		
		Base64 CBase64 = new Base64();  
		//nRet = CBase64.Decode(signeddata.getBytes("KSC5601"), signeddata.getBytes("KSC5601").length);
		nRet = CBase64.Decode(signeddata.getBytes(), signeddata.getBytes().length);
		
		if(nRet==0) 
		{
			
			Verifier CVerifier = new Verifier();
			CVerifier.errmessage = ""; // 추가
			nRet=CVerifier.VerSignedData(CBase64.contentbuf, CBase64.contentlen); 
			
			if(nRet==0) 
			{
				String sOrgData = new String(CVerifier.contentbuf, "KSC5601");
				
				resultArr[0] = sOrgData;

				//인증서 정보 추출 결과	
				Certificate CCertificate = new Certificate();
				nRet=CCertificate.ExtractCertInfo(CVerifier.certbuf, CVerifier.certlen);
				if (nRet ==0)
				{
					
					
					resultArr[1] = CCertificate.subject;

					// 인증서 검증
		
					String Policies = "";

					/* 법인상호연동용(범용) */  
					Policies +="1.2.410.200004.5.2.1.1"    + "|";          // 한국정보인증               법인
					Policies +="1.2.410.200004.5.1.1.7"    + "|";          // 한국증권전산               법인, 단체, 개인사업자
					Policies +="1.2.410.200005.1.1.5"      + "|";          // 금융결제원                 법인, 임의단체, 개인사업자
					Policies +="1.2.410.200004.5.3.1.1"    + "|";          // 한국전산원                 기관(국가기관 및 비영리기관)
					Policies +="1.2.410.200004.5.3.1.2"    + "|";          // 한국전산원                 법인(국가기관 및 비영리기관을  제외한 공공기관, 법인)
					Policies +="1.2.410.200004.5.4.1.2"    + "|";          // 한국전자인증               법인, 단체, 개인사업자
					Policies +="1.2.410.200012.1.1.3"      + "|";          // 한국무역정보통신           법인
					
					// 법인 특정용 인증서(OID)
					Policies +="1.2.410.200005.1.1.2"      + "|";          // 금융결제원                 법인 인터넷뱅킹용
					Policies +="1.2.410.200005.1.1.6.8"      + "|";        // 금결원에서 발급한 국세청 세금계산서용 OID					

					CCertificate.errmessage = "";

					nRet=CCertificate.ValidateCert(CVerifier.certbuf, CVerifier.certlen, Policies, 1);

					if(nRet==0) 
					{
						

						// ****************************************************************************************
						// 인증서 검증 결과가 성공하면 사용자에 해당 테이블에 DN값을 추가하기 위해
						// Update 문을 수행한다!@@@
						// Update   사용자 테이블   set    DN="CCertificate.subject"    where   세션의 아이디
						// 이런 형태로 사용자의 DN값을 등록해 주면 된다!@@@
						// ****************************************************************************************
					}
					else
					{
						//boolCertChk = false;
						logger.error("ksh signeddata [" + signeddata + "]");	//추가
						throw new Exception("인증서 검증 실패 [ 에러내용 : " + CCertificate.errmessage + " ["+CCertificate.errmessage+"]");
					} // 인증서 검증 결과 If문 끝..
				}
				else
				{
					//boolCertChk = false;
					logger.error("ksh signeddata [" + signeddata + "]"); // 추가
					throw new Exception("인증서 추출 실패 [ 에러내용 : " + CCertificate.errmessage + " ["+CCertificate.errcode+"]");
				}// 인증서 추출 결과 If문 끝
			}
			else
			{
				//boolCertChk = false;
				logger.error("ksh signeddata [" + signeddata + "]"); // 추가
				throw new Exception("전자서명 검증 결과 실패 [ 에러내용 : " + CVerifier.errmessage + " ["+CVerifier.errcode+"]");
			} // 서명검증 If문 끝...
		}
		else
		{
			//boolCertChk = false;
			logger.error("ksh signeddata [" + signeddata + "]"); // 추가
			throw new Exception("서명값 Base64 Decode 결과 실패 : " + CBase64.errmessage + " ["+CBase64.errcode+"]");
		}// 서명값 Base64 Decode If문 끝
		
		String authStep = paramMap.get("authStep").toString();
		String useType  = paramMap.get("useType").toString();
		
		if("0".equals(authStep) && "ETC".equals(useType)){			//공인인증서 미등록 상태 : 공인인증서를 등록한다. (초기 등록상태에서는 조직 등록시 등록됨.)
			paramMap.put("userDn", resultArr[1]);
			commonDao.insertAuthInfo(paramMap);
		}
		return resultArr;
	}

	/**
	 * 사용자의 아이디 분실할 때 입력정보가 정확한지 확인 메소드
	 * @param searchMap
	 * @return
	 */
	public CustomResponse getUserIdPasswordFind(Map<String, Object> searchMap) {
		HashMap<String,Object> resultMap = commonDao.getUserIdPasswordFind(searchMap);
		CustomResponse custResponse = new CustomResponse(true);
		
		String srcType = searchMap.get("srcType").toString();
		
		if(resultMap==null || resultMap.isEmpty()) {
			custResponse.setSuccess(false);
			custResponse.setMessage("입력하신 정보와 일치하는 사용자 정보가 존재하지 않습니다.\n");
			custResponse.setMessage("");
			custResponse.setMessage("정확한 사용자 정보를 입력하세요.");
		} else {
			
			String mobile = resultMap.get("mobile").toString();
			String loginid = resultMap.get("loginid").toString();
			
			if("id".equals(srcType)){
				if("".equals(mobile)){
					custResponse.setSuccess(false);
					custResponse.setMessage("핸드폰번호가 등록되어 있지 않습니다. 관리자에게 문의 하십시오!");
				}else{
					/*---------------------모바일전송 모듈 시작----------------------*/
					/* 정연백 과장님 요청으로 SMS 내용변경 20160701 by kkbum2000 */
					sendRightSms(mobile, "[Okplaza] 요청하신 로그인 아이디는 ["+loginid+"] 입니다", true);
					custResponse.setMessage("요청하신 로그인 아이디가 SMS로 발송되었습니다.");
					/*---------------------모바일전송 모듈 끝----------------------*/
				}
			}else if("pwd".equals(srcType)){
				if("".equals(mobile)){
					custResponse.setSuccess(false);
					custResponse.setMessage("핸드폰번호가 등록되어 있지 않습니다. 관리자에게 문의 하십시오!");
				}else{
					Random rand = new Random();
					String randPassword = String.format("%08d", rand.nextInt(100000000));
					searchMap.put("randPassword", randPassword);
					searchMap.put("loginid", loginid);
					commonDao.updateUserPasswordRandom(searchMap);
					/* 정연백 과장님 요청으로 SMS 내용변경 20160701 by kkbum2000 */
					/*---------------------모바일전송 모듈 시작----------------------*/
					sendRightSms(mobile, "[Okplaza] 요청하신 로그인 비밀번호는 ["+randPassword+"] 입니다", true);
					custResponse.setMessage("요청하신 로그인 비밀번호가 SMS로 발송되었습니다.");
					/*---------------------모바일전송 모듈 끝----------------------*/
				}
			}
		}
		return custResponse;
	}
	
	/**
	 * 공사유형 추가
	 * @param saveMap
	 */
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false)
	public void insertWorkInfo(Map<String, Object> saveMap) throws Exception {
		String workId = seqWorkInfo.getNextStringId();
		saveMap.put("workId", workId);
		commonDao.insertWorkInfo(saveMap);
	}
	
	public List<WorkInfoDto> selectWorkInfo(Map<String, Object>params){
		return commonDao.selectWorkInfo(params);
	}
	
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false)
	public void saveWorkInfo(Map<String, Object> saveMap) throws Exception {
		
		String[] chkWorkInfoArr = (String[])saveMap.get("chkWorkInfoArr");
		String[] unChkWorkInfoArr = (String[])saveMap.get("unChkWorkInfoArr");
		
		if(chkWorkInfoArr != null && chkWorkInfoArr.length > 0){
			commonDao.connWorkInfoToUser(saveMap);
		}

		if(unChkWorkInfoArr != null && unChkWorkInfoArr.length > 0){
			commonDao.disConnWorkInfoToUser(saveMap);
		}
	}

	public List<WorkInfoDto> selectConnWorkBranchList(Map<String, Object> params) {
		return commonDao.selectConnWorkBranchList(params);
	}

	@Transactional(propagation=Propagation.REQUIRED, readOnly=false)
	public void connBranchs(Map<String, Object> saveMap) throws Exception {
		String[] chkConnInfoArr = (String[])saveMap.get("chkConnInfoArr");
		if(chkConnInfoArr != null && chkConnInfoArr.length > 0){
			commonDao.connBranchs(saveMap);
		}
	}

	@Transactional(propagation=Propagation.REQUIRED, readOnly=false)
	public void disConnBranchs(Map<String, Object> saveMap) throws Exception {
		String[] unChkConnInfoArr = (String[])saveMap.get("unChkConnInfoArr");
		if(unChkConnInfoArr != null && unChkConnInfoArr.length > 0){
			commonDao.disConnBranchs(saveMap);
		}
	}
	public List<WorkInfoDto> selectConnAccBranchList(Map<String, Object> params) {
		return commonDao.selectConnAccBranchList(params);
	}
	
	public List<WorkInfoDto> getAccManageUserList(){
		return commonDao.getAccManageUserList();
	}
	
	public List<BuyProductDto> getDispGoodIdList(Map<String, Object> params) {
		return commonDao.selectDispGoodIdList(params);
	}
	public SmpBranchsDto getBranchInfoByBorgId(String borgId) {
		return organDao.selectOneBranchs(borgId);
	}
	
	/** sms 문자메세지를 전송하는 메소드 */
	public void smsTransmissionMsg(Map<String, Object> params) throws Exception {
		String[] receive_phone_numb_array = (String[]) params.get("receive_phone_numb_array");		// 수신할 번호들
		String trans_msg_desc = (String) params.get("trans_msg_desc");									// 전송할 메세지
		String trans_phone_numb = params.get("trans_phone_numb").toString().replace("-", "");		// 발신번호
		for(String receive_phone_numb : receive_phone_numb_array){
			this.sendRightSms(receive_phone_numb,trans_msg_desc,trans_phone_numb);
		}
	}

	public int getSmsSvcUserListCnt(Map<String, Object> params) {
		return commonDao.selectSmsSvcUserListCnt(params);
	}

	public List<Map<String, String>> getSmsSvcUserList(Map<String, Object> params, int page, int rows) {
		return commonDao.selectSmsSvcUserList(params, page, rows);
	}

	public List<Map<String, Object>> getSmsRoleKind(Map<String, Object> params) {
		return (List<Map<String, Object>>) commonDao.selectSmsRoleKind(params);
	}

	public List<Map<String, String>> getRoleInfoListBySmsSvcTypeNm( String srcSmsSvcTypeNm) {
		Map<String, Object> searchMap = new HashMap<String, Object>();
		searchMap.put("srcSmsSvcTypeNm", srcSmsSvcTypeNm);
		return commonDao.selectRoleInfoListBySmsSvcTypeNm(searchMap);
	}
	/*------------------------------------채팅관련서비스 시작-----------------------------------------*/
	public void setChatContinue(String userId, String borgId, String userNm, String borgNm) {
		commonDao.saveChatLogin(userId, borgId, userNm, borgNm);
	}

	public ChatLoginDto getChatMeUserInfo(String userId, String branchId) {
		return commonDao.selectChatMeUserInfo(userId, branchId);
	}

	public void chatLogout() {
		List<ChatLoginDto> logoutList = commonDao.selectLogoutChatList();
		for(ChatLoginDto chatLogoutDto : logoutList) {
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("userId", chatLogoutDto.getUserId());
			params.put("branchId", chatLogoutDto.getBranchId());
			String currentDate = CommonUtils.getCurrentDate();
			String logYyyyMm = currentDate.substring(0, 4) + currentDate.substring(5, 7);
			params.put("logTable", "SMPCHAT_LOG_"+logYyyyMm);
			try {
				commonDao.insertChatLogTable(params);
			} catch(BadSqlGrammarException e) {
				commonDao.createChatLog();
				try {
					commonDao.insertChatLogTable(params);
				} catch (Exception e1) {}
			}
			commonDao.deleteLogoutChatData(params);
			commonDao.deleteChatLogin(params);
		}
	} 

	public void initChatLogin() {
		commonDao.deleteAllChatLogin();
		commonDao.deleteAllChatInfo();
	}

	public void createChatLog() {
		commonDao.createChatLog();
	}

	public List<ChatLoginDto> getChatLoginList(String userId, String branchId) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userId", userId);
		params.put("branchId", branchId);
		return commonDao.selectChatLoginList(params);
	}

	public List<ChatDto> getChatList(Map<String, Object> params) {
		commonDao.updateReceiveChatToUser(params);
		return commonDao.selectChatList(params);
	}

	public List<ChatDto> getChatMeList(Map<String, Object> params) {
		List<ChatDto> chatMeList = commonDao.selectChatMeList(params);
		for(ChatDto chatDto : chatMeList) {
			commonDao.updateReceiveChatByChatId(chatDto.getChatId());
		}
		return chatMeList;
	}

	public void sendChatData(Map<String, Object> params) {
		commonDao.insertChatData(params);
	}

	public int getChatMessageListCnt(Map<String, Object> params) {
		return commonDao.selectChatMessageListCnt(params);
	}

	public List<ChatDto> getChatMessageList(Map<String, Object> params, int page, int rows) {
		return commonDao.selectChatMessageList(params, page, rows);
	}

	public void updateWorkInfo(Map<String, Object> saveMap) {
		commonDao.updateWorkInfo(saveMap);
	}

	public CustomResponse getOrderStatus(String[] orde_iden_numb_array,
			String[] purc_iden_numb_array, String[] deli_iden_numb_array,
			String[] rece_iden_numb_array, String[] prod_quan_array,
			String orde_stat_flag) throws Exception {
		
		CustomResponse custResponse = new CustomResponse(true);
		String orderStatus = "";
		int tmpCnt = 0;
		for(String orde_iden_numb_string : orde_iden_numb_array) {
			String orde_iden_numb = orde_iden_numb_string.split("-")[0];
			String orde_sequ_numb = orde_iden_numb_string.split("-")[1];
			
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("orde_iden_numb", orde_iden_numb);
			params.put("orde_sequ_numb", orde_sequ_numb);
			if(purc_iden_numb_array==null) {	//주문상품의 상태
				orderStatus = commonDao.selectMrordtStatus(params);
			} else if(deli_iden_numb_array==null) {	//발주의 상태
				params.put("purc_iden_numb", purc_iden_numb_array[tmpCnt]);
				if("50".equals(orde_stat_flag) && prod_quan_array!=null) {	//출하처리 체크는 수량으로 해야함
					params.put("prod_quan", prod_quan_array[tmpCnt]);
					orderStatus = commonDao.selectMrpurtStatus(params);
				} else {
					orderStatus = commonDao.selectMrordtStatus(params);
				}
			} else if(rece_iden_numb_array==null) {	//출하의 상태
				params.put("purc_iden_numb", purc_iden_numb_array[tmpCnt]);
				params.put("deli_iden_numb", deli_iden_numb_array[tmpCnt]);
//				orderStatus = commonDao.selectMracptStatus(params);
				orderStatus = commonDao.selectMrordtStatus(params);
			} else {	//인수의 상태
				params.put("purc_iden_numb", purc_iden_numb_array[tmpCnt]);
				params.put("deli_iden_numb", deli_iden_numb_array[tmpCnt]);
				params.put("rece_iden_numb", rece_iden_numb_array[tmpCnt]);
//				orderStatus = commonDao.selectMrordtlistStatus(params);
				orderStatus = commonDao.selectMrordtStatus(params);
			}
			
			tmpCnt++;
			if(orderStatus != null && !orderStatus.equals(orde_stat_flag)) {
				custResponse.setSuccess(false);
				custResponse.setMessage("처리 하실 수 있는 주문상태가 아닌 주문이 존재합니다.");
				break;
			} else if(orderStatus == null) {
				custResponse.setSuccess(false);
				custResponse.setMessage("처리 하실 주문에 대한 주문번호가 존재하지 않습니다.");
				break;
			}
		}
		return custResponse;
	}
	
	/**
	 * SMS PK 20자리 만들기
	 * @return
	 */
	public String createCmpMsgId(){
		String toDay = CommonUtils.getCurrentDate();
		String str[] = {"","",""};
		str = toDay.split("-");
		String result = "SMS"+str[0]+str[1]+str[2];
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("cmpMsgId", result);
		String cmpMsgId = commonDao.selectCmpMsgId(params);
		if(cmpMsgId == null){
			result += "000000001";
		}else{
			int tempSeq = Integer.parseInt(cmpMsgId.substring(11,cmpMsgId.length()));
			String tempSeqString = ++tempSeq +"";
			if(tempSeqString.length() < 2){
				tempSeqString = "00000000"+tempSeqString;
			}else if(tempSeqString.length() < 3){
				tempSeqString = "0000000"+tempSeqString;
			}else if(tempSeqString.length() < 4){
				tempSeqString = "000000"+tempSeqString;
			}else if(tempSeqString.length() < 5){
				tempSeqString = "00000"+tempSeqString;
			}else if(tempSeqString.length() < 6){
				tempSeqString = "0000"+tempSeqString;
			}else if(tempSeqString.length() < 7){
				tempSeqString = "000"+tempSeqString;
			}else if(tempSeqString.length() < 8){
				tempSeqString = "00"+tempSeqString;
			}else if(tempSeqString.length() < 9){
				tempSeqString = "0"+tempSeqString;
			}
			result += tempSeqString;
		}
		return result;
	}

	/*------------------------------비회원로그인 시작----------------------------------*/
	public String getGuestUserIdByLoginId(String loginId) {
		return commonDao.selectGuestUserIdByLoginId(loginId);
	}
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false)
	public String saveGuestUser(Map<String, Object> searchMap) throws Exception {
		
		int businessNumCnt = commonDao.selectBusinessCnt(searchMap);
		
		if(businessNumCnt > 0){
			throw new SystemUserLoginException("이미 가입된 업체 입니다.\n회원로그인을 이용해주세요.");
		}
		
		String nonUserId = commonDao.selectGuestNoneUserId(searchMap);
		if(nonUserId==null || "".equals(nonUserId)) {
			nonUserId = seqMpUsersService.getNextStringId();
			searchMap.put("nonUserId", nonUserId);
			commonDao.insertGuestUser(searchMap);
		} else {
			searchMap.put("nonUserId", nonUserId);
			commonDao.updateGuestUser(searchMap);
		}
		return nonUserId;
	}
	public NonUsersDto getNonUserInfo(String nonUserId) {
		return commonDao.selectNonUserInfo(nonUserId);
	}
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false)
	public String saveGuestResist(Map<String, Object> saveMap) throws Exception {
		String nonUserId = seqMpUsersService.getNextStringId();
		saveMap.put("nonUserId", nonUserId);
		String userId = commonDao.selectGuestUserIdByLoginId("xxxxxxxxxx");
		saveMap.put("userId", userId);
		commonDao.insertGuestUser(saveMap);
		return nonUserId;
	}
	/*------------------------------비회원로그인 끝----------------------------------*/
	
	
	/**
	 * 배송정보 입력시 이메일, SMS발송
	 * @param saveMap
	 */
	public void orderReceiveDeliverySmsEmailSend(Map<String, Object> saveMap) throws Exception{
		Map<String, Object> tmpEmailSmsMap = commonDao.selectOrderReceiveDeliverySmsEmail(saveMap);
		SmsEmailInfo smsEmailInfo = this.getUserSmsEmailInfoByUserId(tmpEmailSmsMap.get("orde_user_id").toString());	//주문자 Email,Sms 정보 가져오기
		String orde_iden_numb = (String) tmpEmailSmsMap.get("orde_iden_numb");
		String vendorNm = (String) tmpEmailSmsMap.get("vendorNm");
		int orderProdCnt =  (Integer) tmpEmailSmsMap.get("orderProdCnt");
		String good_name = (String) tmpEmailSmsMap.get("good_name");
		
		String smsSendMsg = "["+vendorNm+"]에서 출하 하였습니다.";
		String emailSubject = "[OK플라자] ["+vendorNm+"] 출하 ";
		String emailContents = "공급사에서 출하 하였습니다.<p>";
		emailContents += "주문번호 : ["+orde_iden_numb+"]<br>";
		if(orderProdCnt>1) emailContents += "상품명 : ["+good_name+"]외 "+(orderProdCnt-1)+"건<br>";
		else emailContents += "상품명 : ["+good_name+"]<br>";
		emailContents += "공급사명 : ["+vendorNm+"]<p>";
		emailContents += "주문내역 메뉴에서 확인 가능합니다.";
		if(smsEmailInfo.isSms() && "1".equals(smsEmailInfo.getSmsByDelivery())) {
			try {
				this.sendRightSms(smsEmailInfo.getMobileNum(), smsSendMsg);
			} catch(Exception e) {
				logger.error("SMS(exeOrderReceiveDeliverySmsEmailByOrderNum) Save Errro : "+e);
			}
		}
		if(smsEmailInfo.isEmail() && "1".equals(smsEmailInfo.getEmailByDelivery())) {
			this.saveSendMail(smsEmailInfo.getEmailAddr(), emailSubject, emailContents);
		}
	}

	public Map<String, Object> getIndividualContractDetail() throws Exception{
		return commonDao.selectIndividualContractDetail();
	}
	
	/**
	 * 회원가입 및 사업장 승인시 무조건 SMS발송
	 * @param unconditionalList 메세지 보낼 사람의 아이디
	 * @param smsMsg 메세지 내용
	 */
	public void unconditionalSmsList(List<CodesDto> unconditionalList, String smsMsg) throws Exception {
		for(int i=0; i<unconditionalList.size(); i++){
			Map<String, Object> unconditionalSmsUser = commonDao.selectUnconditionalSmsUser(unconditionalList.get(i).getCodeVal1().toString());
			this.sendRightSms(unconditionalSmsUser.get("MOBILE").toString(), smsMsg);
		}
	}

	
	/**
	 * 물량배분 발주시 발주수량과 주문수량과 비교
	 * @param saveMap
	 * @return
	 * @throws Exception
	 */
	public CustomResponse getAllocationStatus(Map<String, Object> saveMap) throws Exception{
		CustomResponse custResponse = null;
		Map<String, Object> allocationStatus = commonDao.selectAllocationStatus(saveMap);
		if("0".equals(allocationStatus.get("flag").toString())){
			custResponse = new CustomResponse(true);
		}else{
			custResponse = new CustomResponse(false);
			custResponse.setMessage("발주수량을 확인해 주십시오.");
		}
		return custResponse;
	}

	/**
	 * 첨부파일의 원래 파일명 검색
	 */
	public String selectAttachOringinName(String attachFilePath) {
		return commonDao.selectAttachOringinName(attachFilePath);
	}
	
	/**
	 * 수동물량배분시 주문리스트
	 * @param orderNum
	 * @return
	 */
	public List<Map<String, Object>> getOrderDistributeEmailSmsByOrderNumList(String orderNum) {
		return commonDao.selectOrderDistributeEmailSmsByOrderNumList(orderNum);
	}
	
	/**
	 * 상품담당자의 SMS,Email정보
	 */
	public SmsEmailInfo getProductManagerInfo(Map<String, Object> tempMap){
		return commonDao.selectProductManagerInfo(tempMap);
	}
	
	
	/**
	 * 초기팝업정보를 가져옴
	 */
	public List<BoardDto> noticePopBoardMain() {
		return commonDao.selectNoticePopBoardMainList();
	}
	
	/**
	 * 계약 제외 대상 법인인지 조회하는 메소드
	 * 
	 * @param borgId
	 * @return boolean
	 * @throws Exception
	 */
	public boolean isContractExcludeClient(String borgId) throws Exception{
		List<CodesDto> contractExcludeCltList     = this.getCodeList("CONTRACT_EXCLUDE_CLT", 1);
		String         parBorgCd                  = null;
		String         codeVal1                   = null;
		ModelMap       daoParam                   = new ModelMap();
		CodesDto       contractExcludeCltInfo     = null;
		boolean        result                     = false;
		int            contractExcludeCltListSize = 0;
		int            i                          = 0;
		
		daoParam.put("borgId", borgId);
		
		parBorgCd = (String)this.generalDao.selectGernalObject("common.etc.selectParborgCdInfoByBorgId", daoParam);
		
		if(contractExcludeCltList != null){
			contractExcludeCltListSize = contractExcludeCltList.size();
		}
		
		for(i = 0; i < contractExcludeCltListSize; i++){
			contractExcludeCltInfo = contractExcludeCltList.get(i);
			codeVal1               = contractExcludeCltInfo.getCodeNm1();
			
			if(codeVal1.equals(parBorgCd)){
				result = true;
				
				break;
			}
		}
		
		return result;
	}

	/**
	 * 계약서 서명대상 조직ID
	 * @param loginId (사용자 로그인 아이디)
	 * @return String
	 */
	@SuppressWarnings("unchecked")
	public String getBorgIdContractBorgUser(String loginId) throws Exception {
		String              returnBorgId         = "";
		String              borgId               = null;
		String              svcTypeCd            = null;
		ModelMap            daoParam             = new ModelMap();
		Map<String, Object> contractMap          = null;
		int                 allCnt               = 0;
		int                 sameCnt              = 0;
		boolean             isContractExcludeClt = false;
		
		daoParam.put("loginId", loginId);
		
		borgId    = (String) generalDao.selectGernalObject("common.etc.selectDefaultBorgIdByLoginId", daoParam); // 사용자 아이디의 기본 조직 정보 조회
		svcTypeCd = this.getSvctypeByBorgId(borgId); // 고객 유형 코드 조회
		
		if("BUY".equals(svcTypeCd) || "VEN".equals(svcTypeCd)) {
			if("BUY".equals(svcTypeCd)){
				isContractExcludeClt = this.isContractExcludeClient(borgId); // 계약 제외 대상 법인 여부 조회
				
				if(isContractExcludeClt){
					sameCnt = 1;
				}
			}
			
			if(allCnt == sameCnt){
				daoParam.clear();
				daoParam.put("borgId",    borgId);
				daoParam.put("svcTypeCd", svcTypeCd);
				
				contractMap = (Map<String, Object>) generalDao.selectGernalObject("common.etc.selectBIQContractSameCnt", daoParam);
				allCnt      = (int) contractMap.get("ALL_CNT");
				sameCnt     = (int) contractMap.get("SAME_CNT");
				
				if(allCnt != sameCnt){ // 계약서 건수와 서명 건수가 일치하지 않는 경우
					returnBorgId = borgId;
				}
			}
		}
		
		return returnBorgId;
	}
	
	/**
	 * 구매사, 공급사가 서명해야되는 계약서 리스트
	 */
	public Map<String, Object> getContractToDoList(String borgId) throws Exception{
		Map<String, Object>       map                      = new HashMap<String, Object>();
		Map<String, Object>       daoParam                 = new HashMap<String, Object>();
		Map<String, Object>       info                     = null;
		List<Map<String, Object>> list                     = null;
		String                    borgSvcTypeCd            = this.getSvctypeByBorgId(borgId);
		String                    limitContractDate        = null;
		String                    contractSignYn           = null;
		StringBuffer              stringBuffer             = new StringBuffer();
		int                       i                        = 0;
		int                       listSize                 = 0;
		int                       limitContractDateInt     = 99991231;
		int                       tempLimitContractDateInt = 0;
		
		daoParam.put("borgId", borgId);
		
		if("BUY".equals(borgSvcTypeCd)){
			list = commonDao.selectBranchContractToDoList(daoParam);	//구매사
		}
		else{
			list = commonDao.selectVendorContractToDoList(daoParam);	//공급사
		}
		
		if(list != null){
			listSize = list.size();
		}
		
		for(i = 0; i < listSize; i++){
			info                = list.get(i);
			limitContractDate = (String)info.get("LIMIT_CONTRACT_DATE");
			contractSignYn   = (String)info.get("CONTRACT_SIGN_YN");
			limitContractDate = limitContractDate.trim();
			
			if("N".equals(contractSignYn)){
				tempLimitContractDateInt = CommonUtils.parseInt(limitContractDate, 99991231);
			
				if(tempLimitContractDateInt < limitContractDateInt){
					limitContractDateInt = tempLimitContractDateInt;
				}
			}
		}
		
		limitContractDate = Integer.toString(limitContractDateInt);
		
		stringBuffer.append(limitContractDate.substring(4, 6));
		stringBuffer.append("/");
		stringBuffer.append(limitContractDate.substring(6, 8));
		
		limitContractDate = stringBuffer.toString();
		
		map.put("svcTypeCd",         borgSvcTypeCd);  
		map.put("list",              list);           
		map.put("limitContractDate", limitContractDate);
		
		return map;
	}
	
	/**
	 * 구매사 계약서 사인
	 */
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})
	public void branchContractSign(Map<String, Object> saveMap) throws Exception{
		String[] contractVirsionArr = (String[])saveMap.get("contractVirsion_array");
		for(int i=0; i<contractVirsionArr.length; i++){
			saveMap.put("contractVersion", contractVirsionArr[i]);
			Map<String, Object> contractBorgInfo = commonDao.selectSmpborgContractBranchInfo(saveMap);
			commonDao.saveSmpborgContract(contractBorgInfo);
			commonDao.insertContractSign(contractBorgInfo);
		}
	}
	
	/**
	 * 공급사 계약서 사인
	 */
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})
	public void vendorContractSign(Map<String, Object> saveMap) throws Exception{
		String[] contractVirsionArr = (String[])saveMap.get("contractVirsion_array");
		for(int i=0; i<contractVirsionArr.length; i++){
			saveMap.put("contractVersion", contractVirsionArr[i]);
			Map<String, Object> contractBorgInfo = commonDao.selectSmpborgContractVendorInfo(saveMap);
			commonDao.saveSmpborgContract(contractBorgInfo);
			commonDao.insertContractSign(contractBorgInfo);
		}
	}
	
	/**
	 * <pre>
	 * 리스트를 조회하여 그 결과를 리턴하는 메소드
	 * 
	 * ~. 조회 파라미터 맵 형식
	 *   !. 조회 쿼리에 맞는 정보를 넣되 다음의 정보는 반드시 들어가야 한다.
	 *   !. page : 조회할 페이지 번호
	 *   !. rows : 페이지당 조회할 수
	 * 
	 * ~. 결과 Map 형식
	 *   !. record  (Integer, 리스트 전체 카운트)
	 *   !. pageMax (Integer, 페이지 최대 수)
	 *   !. list    (List,    조회 리스트)
	 * </pre>
	 * 
	 * 
	 * @param countSqlId (String, 카운트 조회 쿼리 id)
	 * @param listSqlId (String, 리스트 조회 쿼리 id)
	 * @param param (Map, 조회 파라미터)
	 * @return Map
	 * @throws Exception
	 */
	public Map<String, Object> getJqGridList(String countSqlId, String listSqlId, ModelMap param) throws Exception{
		Map<String, Object> result    = new HashMap<String, Object>();
		List<?>             list      = null;
		String              page      = (String)param.get("page");
		String              rows      = (String)param.get("rows");
		Integer             record    = null;
		Integer             pageMax   = null;
		Integer             rowsInt   = Integer.parseInt(rows);
		Integer             offset    = CommonUtils.getPageSkip(page, rows); // 페이지 스킵량 계산
		RowBounds           rowBounds = new RowBounds(offset, rowsInt);
  		
		record  = (Integer)this.generalDao.selectGernalObject(countSqlId, param); // 카운트 조회
		pageMax = (int)Math.ceil((float)record / (float)rowsInt);
		
		if(record > 0){
			param.put("rowBounds", rowBounds);
			
			list = this.generalDao.selectGernalList(listSqlId, param); // 리스트 조회
		}
		else{
			list = new ArrayList<String>();
		}
		
		result.put("record",  record);
		result.put("pageMax", pageMax);
		result.put("list",    list);
		
		return result;
	}

	/** 공급사 역주문 : 사업장 조회 */
	public int borgDivListVenOrdReqCnt(Map<String, Object> params) {
		return commonDao.selectBorgDivListVenOrdReqCnt(params);
	}
	public List<Map<String, Object>> borgDivListVenOrdReq(Map<String, Object> params, int page, int rows) {
		return commonDao.selectBorgDivListVenOrdReq(params);
	}

	public Map<String, Object> selectUserInfoByUserInfo(Map<String, Object> params) {
		return commonDao.selectUserInfoByUserInfo(params);
	}

	public int getSmsSvcUserListCnt2(Map<String, Object> params) {
		return commonDao.selectSmsSvcUserListCnt2(params);
	}

	public List<Map<String, String>> getSmsSvcUserList2(Map<String, Object> params, int page, int rows) {
		return commonDao.selectSmsSvcUserList2(params, page, rows);
	}
	
	/**
	 * 조직 아이디로 사용자 유형 코드를 반환하는 메소드
	 * 
	 * @param borgId
	 * @return String
	 * @throws Exception
	 */
	private String getSvctypeByBorgId(String borgId) throws Exception{
		ModelMap daoParam = new ModelMap();
		String   svcTypeCd = null;
		
		daoParam.put("borgId", borgId);
		
		svcTypeCd = (String) generalDao.selectGernalObject("common.etc.selectSvctypeByBorgId", daoParam); // 조직의 서비스 타입 조회
		
		return svcTypeCd;
	}
	
	/**
	 * <pre>
	 * 공인인증 처리를 위한 사용자 정보를 반환하는 메소드
	 * 
	 * ~. return map 구조
	 *   !. clientId (고객사의 경우 법인 아이디, 공급사의 경우 공급사 아이디)
	 *   !. svcTypeCd (고객유형코드)
	 *   !. businessNum (사덥자 등록 번호)
	 * </pre>
	 * 
	 * @param borgId (사용자의 조직 아이디)
	 * @return Map
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public Map<String, String> authUserInfo(String borgId) throws Exception{
		Map<String, String> result      = new HashMap<String, String>();
		Map<String, String> userInfo    = null;
		String              svcTypeCd   = this.getSvctypeByBorgId(borgId); // 고객 유형 코드 조회
		String              clientId    = null;
		String              businessNum = null;
		ModelMap            daoParam    = new ModelMap();
		
		daoParam.put("borgId", borgId);
		
		if("BUY".equals(svcTypeCd)){ // 고객사
			userInfo = (Map<String, String>)this.generalDao.selectGernalObject("common.etc.selectBuyAuthUserInfo", daoParam);
		}
		else if("VEN".equals(svcTypeCd)){ // 공급사
			userInfo = (Map<String, String>)this.generalDao.selectGernalObject("common.etc.selectVenAuthUserInfo", daoParam);
		}
		else{
			userInfo = new HashMap<String, String>();
		}
		
		clientId    = userInfo.get("clientId");
		businessNum = userInfo.get("businessNum");
		
		result.put("clientId",    clientId);
		result.put("svcTypeCd",   svcTypeCd);
		result.put("businessNum", businessNum);
		
		return result;
	}
	
	/**
	 * 조직의 정보를 조회하여 반환하는 메소드
	 * 
	 * @param borgId
	 * @return Map
	 * @throws Exception
	 */
	public Map<String, String> getBorgInfo(String borgId) throws Exception{
		Map<String, String> result        = new HashMap<String, String>();
		ModelMap            daoParam      = new ModelMap();
		String              svcTypeCd     = this.getSvctypeByBorgId(borgId); // 고객 유형 코드 조회
		String              address       = null;
		String              addressDetail = null;
		String              presentNm     = null;
		String              borgNm        = null;
		SmpBranchsDto       branchInfo    = null;
		SmpVendorsDto       smpVendorsDto = null;
		
		if("BUY".equals(svcTypeCd)){ // 고객사
			daoParam.put("branchId", borgId);
			
			branchInfo = (SmpBranchsDto)this.generalDao.selectGernalObject("organ.selectBranchsDetail", daoParam);
			
			if(branchInfo != null){
				address       = CommonUtils.nvl(branchInfo.getAddres());
				addressDetail = CommonUtils.nvl(branchInfo.getAddresDesc());
				presentNm     = CommonUtils.nvl(branchInfo.getPressentNm());
				borgNm        = CommonUtils.nvl(branchInfo.getBranchNm());
				address       = address + " " + addressDetail;
			}
			else{
				address   = "";
				presentNm = "";
				borgNm    = "";
			}
		}
		else if("VEN".equals(svcTypeCd)){ // 공급사
			daoParam.put("vendorId", borgId);
			
			smpVendorsDto = (SmpVendorsDto)this.generalDao.selectGernalObject("organ.selectVendorsDetail", daoParam);
			
			if(smpVendorsDto != null){
				address       = CommonUtils.nvl(smpVendorsDto.getAddres());
				addressDetail = CommonUtils.nvl(smpVendorsDto.getAddresDesc());
				presentNm     = CommonUtils.nvl(smpVendorsDto.getPressentNm());
				borgNm        = CommonUtils.nvl(smpVendorsDto.getVendorNm());
				address       = address + " " + addressDetail;
			}
			else{
				address   = "";
				presentNm = "";
				borgNm    = "";
			}
		}
		else{
			address   = "";
			presentNm = "";
			borgNm    = "";
		}
		
		result.put("address",   address);
		result.put("presentNm", presentNm);
		result.put("borgNm",    borgNm);
		
		return result;
	}
	
	/**
	 * <pre>
	 * 사용자의 개인정보를 수정하는 메소드
	 * 
	 * ~. saveMap 구조
	 *   !. userNm : 사용자명
	 *   !. password : 비밀번호
	 *   !. tel : 전화번호
	 *   !. mobile : 휴대전화번호
	 *   !. email : 이메일
	 *   !. isEmail : 이메일발송여부
	 *   !. isSms : SMS 발송여부
	 *   !. userId : 사용자 아이디
	 *   !. updaterId : 수정자 아이디
	 *   !. remoteIp : 접속 아이피 정보
	 * </pre>
	 * 
	 * @param saveMap
	 * @throws Exception
	 */
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})
	public void updateUser(Map<String, String> saveMap) throws Exception{
		ModelMap  daoParam  = new ModelMap();
		String    userNm    = saveMap.get("userNm");
		String    password  = saveMap.get("password");
		String    tel       = saveMap.get("tel");
		String    mobile    = saveMap.get("mobile");
		String    email     = saveMap.get("email");
		String    isEmail   = saveMap.get("isEmail");
		String    isSms     = saveMap.get("isSms");
		String    userId    = saveMap.get("userId");
		String    updaterId = saveMap.get("updaterId");
		String    remoteIp  = saveMap.get("remoteIp");
		
		daoParam.put("userNm",    userNm);
		daoParam.put("pwd",       password);
		daoParam.put("tel",       tel);
		daoParam.put("mobile",    mobile);
		daoParam.put("email",     email);
		daoParam.put("remoteIp",  remoteIp);
		daoParam.put("updaterId", updaterId);
		daoParam.put("userId",    userId);
		
		this.generalDao.updateGernal("system.borg.updateAdmSmpUsersInfo", daoParam);
		
		daoParam.clear();
		daoParam.put("isEmail", isEmail);
		daoParam.put("isSms",   isSms);
		daoParam.put("userId",  userId);
		
		this.generalDao.updateGernal("common.etc.updateAdminReceiveInfo", daoParam);
	}



}