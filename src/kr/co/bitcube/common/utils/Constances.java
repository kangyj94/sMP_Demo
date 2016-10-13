package kr.co.bitcube.common.utils;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

/**
 * @author Administrator
 *
 */
@Component 
public class Constances {

	/*------------------------------System Constances-------------------------*/
	//시스템 초기 로그인 페이지
	public static String SYSTEM_LOGIN_PATH;
	//System 메뉴타입이 기본인 frameset 경로
	public static String SYSTEM_FRAME_PATH;
	//System 메뉴타입이 Tree인 frameset 경로
	public static String SYSTEM_TREE_FRAME_PATH;
	//System 서비스 타이틀
	public static String SYSTEM_SERVICE_TITLE;
	//System ContextPath
	public static String SYSTEM_CONTEXT_PATH;
	//System 기본 이미지 URL
	public static String SYSTEM_IMAGE_URL;
	//System 기본 js/css URL
	public static String SYSTEM_JSCSS_URL;
	//메뉴타입(로그인 Controller에서 세팅)
	public static String MENU_TYPE = "";
	// 이미지 경로
	public static String SYSTEM_IMAGE_PATH = "";
	
	@Value("#{cubeFrameworkConfig['sys.image.path']}")
	public void setSystemImagePath(String systemImagePath){
		Constances.SYSTEM_IMAGE_PATH = systemImagePath;
	}
	@Value("#{cubeFrameworkConfig['sys.login.path']}")
	public void setSystemLoginPath(String systemLoginPath) {
		Constances.SYSTEM_LOGIN_PATH = systemLoginPath;
	}
	@Value("#{cubeFrameworkConfig['sys.frame.path']}")
	public void setSystemFramePath(String systemFramePath) {
		Constances.SYSTEM_FRAME_PATH = systemFramePath;
	}
	@Value("#{cubeFrameworkConfig['sys.treeFrame.path']}")
	public void setSystemTreeFramePath(String systemTreeFramePath) {
		Constances.SYSTEM_TREE_FRAME_PATH = systemTreeFramePath;
	}
	@Value("#{cubeFrameworkConfig['sys.service.title']}")
	public void setSystemServiceTitle(String systemServiceTitle) {
		Constances.SYSTEM_SERVICE_TITLE = systemServiceTitle;
	}
	@Value("#{cubeFrameworkConfig['sys.context.path']}")
	public void setSystemContextPath(String contextPath) {
		Constances.SYSTEM_CONTEXT_PATH = contextPath;
	}
	@Value("#{cubeFrameworkConfig['sys.image.url']}")
	public void setSystemImageUrl(String systemImageUrl) {
		Constances.SYSTEM_IMAGE_URL = systemImageUrl;
	}
	@Value("#{cubeFrameworkConfig['sys.jscss.url']}")
	public void setSystemJsCssUrl(String systemJsCssUrl) {
		Constances.SYSTEM_JSCSS_URL = systemJsCssUrl;
	}
	public static void setMenuType(String menuType) {
		Constances.MENU_TYPE = menuType;
	}
	
	/*------------------------------Common Constances-------------------------*/
	//세션명 로그인
	public static String SESSION_NAME;
	//엑셀업로드  경로
	public static String EXCEL_UPLOAD_PATH;
	//첨부파일 경로
	public static String COMMON_ATTACH_PATH;
	//실운영장비 여부
	public static boolean COMMON_ISREAL_SERVER;
	//유효성 체크여부
	public static boolean COMMON_ISCHECK_SERVER;
	
	@Value("#{cubeFrameworkConfig['common.login.sessionName']}")
	public void setSessionName(String sessionName) {
		Constances.SESSION_NAME = sessionName;
	}
	@Value("#{cubeFrameworkConfig['common.excelUpload.path']}")
	public void setExcelUploadPath(String excelUploadPath) {
		Constances.EXCEL_UPLOAD_PATH = excelUploadPath;
	}
	@Value("#{cubeFrameworkConfig['common.attach.path']}")
	public void setCommonAttachPath(String commonAttachPath) {
		Constances.COMMON_ATTACH_PATH = commonAttachPath;
	}
	@Value("#{cubeFrameworkConfig['common.isReal.server']}")
	public void setCommonIsRealServer(boolean commonIsRealServer) {
		Constances.COMMON_ISREAL_SERVER = commonIsRealServer;
	}
	@Value("#{cubeFrameworkConfig['common.isCheck.server']}")
	public void setCOMMON_ISCHECK_SERVER(boolean commonIsCheckServer) {
		Constances.COMMON_ISCHECK_SERVER = commonIsCheckServer;
	}


	/*------------------------------Mail Constances-------------------------*/
	//메일호스트정보
	public static String MAIL_HOST = "219.252.78.45";
	//메일송신자 메일주소
	public static String MAIL_SENDER_ADDRESS = "okplaza@sk.com";
	//반송메일주소
	public static String MAIL_REPLYTO_ADDRESS = "j723@sk.com";
	//메일링크 URL
	public static String MAIL_LINK_URL = "http://localhost";

	@Value("#{cubeFrameworkConfig['mail.host']}")
	public void setMAIL_HOST(String mailHost) {
		Constances.MAIL_HOST = mailHost;
	}
	@Value("#{cubeFrameworkConfig['mail.sender.address']}")
	public void setMAIL_SENDER_ADDRESS(String mailSenderAddress) {
		Constances.MAIL_SENDER_ADDRESS = mailSenderAddress;
	}
	@Value("#{cubeFrameworkConfig['mail.link.url']}")
	public void setMAIL_LINK_URL(String mailLinkUrl) {
		Constances.MAIL_LINK_URL = mailLinkUrl;
	}

	/*------------------------------Product-------------------------*/
	//상품변경 승인 플래그 (0:승인프로세스없음, 1:승인프로세스)
	public static boolean PROD_APPROVAL_FLAG;
	//표준 상품 규격 () 
	public static String[]  PROD_GOOD_ST_SPEC;
		
	//상품규격 () 
	public static String[]  PROD_GOOD_SPEC;
	
	
	@Value("#{cubeFrameworkConfig['prod.approval.flag']}")
	public void setPROD_APPROVAL_FLAG(boolean prodApprovalFlag) {
		Constances.PROD_APPROVAL_FLAG = prodApprovalFlag;
	}
	
	
	@Value("#{cubeFrameworkConfig['prod.good.st.spec'].split(',')}")
	public void setPROD_GOOD_ST_SPEC(String[] prod_good_st_spec) {
		PROD_GOOD_ST_SPEC = prod_good_st_spec;
	}
	
	@Value("#{cubeFrameworkConfig['prod.good.spec'].split(',')}")
	public void setPROD_GOOD_SPEC(String[] prod_good_spec) {
		PROD_GOOD_SPEC = prod_good_spec;
	}
	
	/*--------------------------- SAP ---------------------------*/
	//Sap Host Properties
	public static String SAP_JCO_ASHOST;
	public static String SAP_JCO_SYSNR;
	public static String SAP_JCO_CLIENT;
	public static String SAP_JCO_USER;
	public static String SAP_JCO_PASSWD;
	public static String SAP_JCO_LANG;
	public static String SAP_JCO_POOL_CAPACITY;
	public static String SAP_JCO_PEAK_LIMIT;

	@Value("#{cubeFrameworkConfig['sap.jco_ashost']}")
	public void setSAP_JCO_ASHOST(String sAP_JCO_ASHOST) {
		SAP_JCO_ASHOST = sAP_JCO_ASHOST;
	}
	
	@Value("#{cubeFrameworkConfig['sap.jco_sysnr']}")
	public void setSAP_JCO_SYSNR(String sAP_JCO_SYSNR) {
		SAP_JCO_SYSNR = sAP_JCO_SYSNR;
	}
	
	@Value("#{cubeFrameworkConfig['sap.jco_client']}")
	public void setSAP_JCO_CLIENT(String sAP_JCO_CLIENT) {
		SAP_JCO_CLIENT = sAP_JCO_CLIENT;
	}
	
	@Value("#{cubeFrameworkConfig['sap.jco_user']}")
	public void setSAP_JCO_USER(String sAP_JCO_USER) {
		SAP_JCO_USER = sAP_JCO_USER;
	}
	
	@Value("#{cubeFrameworkConfig['sap.jco_passwd']}")
	public void setSAP_JCO_PASSWD(String sAP_JCO_PASSWD) {
		SAP_JCO_PASSWD = sAP_JCO_PASSWD;
	}
	
	@Value("#{cubeFrameworkConfig['sap.jco_lang']}")
	public void setSAP_JCO_LANG(String sAP_JCO_LANG) {
		SAP_JCO_LANG = sAP_JCO_LANG;
	}
	
	@Value("#{cubeFrameworkConfig['sap.jco_pool_capacity']}")
	public void setSAP_JCO_POOL_CAPACITY(String sAP_JCO_POOL_CAPACITY) {
		SAP_JCO_POOL_CAPACITY = sAP_JCO_POOL_CAPACITY;
	}
	
	@Value("#{cubeFrameworkConfig['sap.jco_peak_limit']}")
	public void setSAP_JCO_PEAK_LIMIT(String sAP_JCO_PEAK_LIMIT) {
		SAP_JCO_PEAK_LIMIT = sAP_JCO_PEAK_LIMIT;
	}
	
	/*--------------------------- E-Bill ---------------------------*/
	public static String EBILL_MEMID;
	public static String EBILL_MEMNAME;
	public static String EBILL_EMAIL;
	public static String EBILL_TEL;
	public static String EBILL_FAX;
	public static String EBILL_COREGNO;
	public static String EBILL_CONAME;
	public static String EBILL_COCEO;
	public static String EBILL_COADDR;
	public static String EBILL_COBIZTYPE;
	public static String EBILL_COBIZSUB;
	public static String EBILL_URL;

	@Value("#{cubeFrameworkConfig['ebill.memid']}")
	public void setEBILL_MEMID(String eBILL_MEMID) {
		EBILL_MEMID = eBILL_MEMID;
	}

	@Value("#{cubeFrameworkConfig['ebill.fax']}")
	public void setEBILL_FAX(String eBILL_FAX) {
		EBILL_FAX = eBILL_FAX;
	}
	
	@Value("#{cubeFrameworkConfig['ebill.memname']}")
	public void setEBILL_MEMNAME(String eBILL_MEMNAME) {
		EBILL_MEMNAME = eBILL_MEMNAME;
	}
	
	@Value("#{cubeFrameworkConfig['ebill.email']}")
	public void setEBILL_EMAIL(String eBILL_EMAIL) {
		EBILL_EMAIL = eBILL_EMAIL;
	}
	
	@Value("#{cubeFrameworkConfig['ebill.tel']}")
	public void setEBILL_TEL(String eBILL_TEL) {
		EBILL_TEL = eBILL_TEL;
	}
	
	@Value("#{cubeFrameworkConfig['ebill.coregno']}")
	public void setEBILL_COREGNO(String eBILL_COREGNO) {
		EBILL_COREGNO = eBILL_COREGNO;
	}
	
	@Value("#{cubeFrameworkConfig['ebill.coname']}")
	public void setEBILL_CONAME(String eBILL_CONAME) {
		EBILL_CONAME = eBILL_CONAME;
	}
	
	@Value("#{cubeFrameworkConfig['ebill.coceo']}")
	public void setEBILL_COCEO(String eBILL_COCEO) {
		EBILL_COCEO = eBILL_COCEO;
	}
	
	@Value("#{cubeFrameworkConfig['ebill.coaddr']}")
	public void setEBILL_COADDR(String eBILL_COADDR) {
		EBILL_COADDR = eBILL_COADDR;
	}
	
	@Value("#{cubeFrameworkConfig['ebill.cobiztype']}")
	public void setEBILL_COBIZTYPE(String eBILL_COBIZTYPE) {
		EBILL_COBIZTYPE = eBILL_COBIZTYPE;
	}
	
	@Value("#{cubeFrameworkConfig['ebill.cobizsub']}")
	public void setEBILL_COBIZSUB(String eBILL_COBIZSUB) {
		EBILL_COBIZSUB = eBILL_COBIZSUB;
	}

	@Value("#{cubeFrameworkConfig['ebill.url']}")
	public void setEBILL_URL(String eBILL_URL) {
		EBILL_URL = eBILL_URL;
	}
	
	/*------------------------------세금계산서 발행 제외업체(법인)-------------------------*/
	//제외법인 사업자등록번호
	public static String[]  UNISSUED_BUSINESSNUM;
	//제외법인중 특정사업장만 발행해야 할 경우 사용될 사업장코드
	public static String[]  UNISSUED_BRANCHID;
	
	@Value("#{cubeFrameworkConfig['unissued.businessnum'].split(',')}")
	public void setUNISSUED_BUSINESSNUM(String[] businessnum) {
		UNISSUED_BUSINESSNUM = businessnum;
	}

	@Value("#{cubeFrameworkConfig['unissued.branchid'].split(',')}")
	public void setUNISSUED_BRANCHID(String[] branchid) {
		UNISSUED_BRANCHID = branchid;
	}
	
	/*------------------------------체팅관련세팅-------------------------*/
	//체팅사용여부
	public static boolean CHAT_ISUSE;
	//채팅로그인 유지 체크시간(초)
	public static int CHAT_LOGIN_SECOND;
	//채팅사용자 리플래쉬 시간(초)
	public static int CHAT_LOGINUSER_SECOND;
	//채팅창 리플래쉬 시간(초)
	public static int CHAT_MESSENGER_SECOND;
	//채팅창 아무것도 하지 않을때 닫는 시간(분)
	public static int CHAT_MESSENGER_CLOSE_MINUTE;
	
	@Value("#{cubeFrameworkConfig['chat.isUse']}")
	public void setCHAT_ISUSE(boolean chatIsUse) {
		CHAT_ISUSE = chatIsUse;
	}
	@Value("#{cubeFrameworkConfig['chat.login.second']}")
	public void setCHAT_LOGIN_SECOND(int chatLoginSecond) {
		CHAT_LOGIN_SECOND = chatLoginSecond;
	}
	@Value("#{cubeFrameworkConfig['chat.loginuser.second']}")
	public void setCHAT_LOGINUSER_SECOND(int chatLoginuserSecond) {
		CHAT_LOGINUSER_SECOND = chatLoginuserSecond;
	}
	@Value("#{cubeFrameworkConfig['chat.messenger.second']}")
	public void setCHAT_MESSENGER_SECOND(int chatMessengerSecond) {
		CHAT_MESSENGER_SECOND = chatMessengerSecond;
	}
	@Value("#{cubeFrameworkConfig['chat.messenger.close.minute']}")
	public void setCHAT_MESSENGER_CLOSE_MINUTE(int chatMessengerCloseMinute) {
		CHAT_MESSENGER_CLOSE_MINUTE = chatMessengerCloseMinute;
	}
	
	/*------------------------------기타세팅-------------------------*/
	//평가여부
	public static boolean ETC_ISEVALUATION;
	public static boolean ETC_ISMOBILE_AUTH;	//모바일인증여부
	public static String ETC_MOBILE_SENDERNUM;	//모바일 보내는 사람
	public static String ETC_SPECIAL_SKB;		//SKB 매니저 권한
	public static String ETC_SPECIAL_SKT;		//SKT 매니저 권한
	public static String ETC_SPECIAL_CON;		//SK건설 매니저 권한
	
	@Value("#{cubeFrameworkConfig['etc.isEvaluation']}")
	public void setETC_ISEVALUATION(boolean isEvaluation) {
		ETC_ISEVALUATION = isEvaluation;
	}
	@Value("#{cubeFrameworkConfig['etc.isMobile.auth']}")
	public void setETC_ISMOBILE_AUTH(boolean isMobileAuth) {
		ETC_ISMOBILE_AUTH = isMobileAuth;
	}
	@Value("#{cubeFrameworkConfig['etc.mobile.senderNum']}")
	public void setETC_MOBILE_SENDERNUM(String mobileSenderNum) {
		ETC_MOBILE_SENDERNUM = mobileSenderNum;
	}

	@Value("#{cubeFrameworkConfig['etc.special.skb']}")
	public void setETC_SPECIAL_SKB(String eTC_SPECIAL_SKB) {
		ETC_SPECIAL_SKB = eTC_SPECIAL_SKB;
	}

	@Value("#{cubeFrameworkConfig['etc.special.skt']}")
	public void setETC_SPECIAL_SKT(String eTC_SPECIAL_SKT) {
		ETC_SPECIAL_SKT = eTC_SPECIAL_SKT;
	}
	
	@Value("#{cubeFrameworkConfig['etc.special.con']}")
	public void setETC_SPECIAL_CON(String eTC_SPECIAL_CON) {
		ETC_SPECIAL_CON = eTC_SPECIAL_CON;
	}
	
}
