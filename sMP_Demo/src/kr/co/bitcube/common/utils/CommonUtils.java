package kr.co.bitcube.common.utils;

import java.io.PrintWriter;
import java.io.StringWriter;
import java.io.Writer;
import java.lang.reflect.Field;
import java.sql.Timestamp;
import java.text.DecimalFormat; 
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.regex.Pattern;

import javax.mail.Message;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeUtility;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestParam;

import kr.co.bitcube.common.dto.ActivitiesDto;
import kr.co.bitcube.common.dto.LoginMenuDto;
import kr.co.bitcube.common.dto.LoginUserDto;
import kr.co.bitcube.common.service.WebChatService;

public class CommonUtils {
	/*============================ 로그인 관련 Util ============================*/
	/**
	 * Object을 sessionName으로 세션저장 
	 * @param request
	 * @param sessionName
	 * @param object
	 */
	public static void setLoginInUserSession(HttpServletRequest request, String sessionName, Object object) {
		HttpSession session = request.getSession();
		
		session.removeAttribute(sessionName);
		session.setAttribute(sessionName, object);
	}
	
	public static void setLoginInUserSession(HttpServletRequest request, String sessionName, Object object, WebChatService webChatService) {
		setLoginInUserSession(request, sessionName, object);
		
		try{
			webChatService.loginAnnounce(request.getSession()); // 웹 채팅 접속자에게 자신의 로그인을 알림(2012-05-24, tytolee)
		}
		catch(Exception e){
			Logger logger = Logger.getLogger("CommonUtils.setLoginInUserSession()");
			
			logger.error("webChatService.loginAnnounce error : "+e);
		}
	}
	
	/**
	 * sessionName 세션제거 
	 * @param request
	 * @param sessionName
	 */
	public static void setLogOutUserSession(HttpServletRequest request, String sessionName) {
		HttpSession session = request.getSession();
		
		session.removeAttribute(sessionName);
	}
	
	public static void setLogOutUserSession(HttpServletRequest request, String sessionName, WebChatService webChatService) {
		try{
			webChatService.logoutAnnounce(request.getSession()); // 웹 채팅 접속자에게 자신의 로그아웃을 알림(2012-05-24, tytolee)
		}
		catch(Exception e) {
			Logger logger = Logger.getLogger("CommonUtils.setLogOutUserSession()");
			
			logger.error("webChatService.logoutAnnounce error : "+e);
		}
		
		setLogOutUserSession(request, sessionName);
	}
	
	/**
	 * 로그인 사용자 정보를 반환하는 메소드
	 * 
	 * @param request
	 * @return LoginUserDto
	 * @throws Exception
	 */
	public static LoginUserDto getLoginUserDto(HttpServletRequest request) throws Exception{
		HttpSession  session     = request.getSession();
		LoginUserDto userInfoDto = (LoginUserDto)session.getAttribute(Constances.SESSION_NAME);
		
		return userInfoDto;
	}
	
	/*============================ 문자열관련 Util ============================*/
	/**
	 * 문자열이 null일 경우 기본값으로 반환하는 메소드
	 * 
	 * @param String string : 검사할 문자열
	 * @param String defaultValue : 기본값
	 * @return String : 반환값
	 * @throws Exception : 반환 중 예외 발생시
	 */
	public static String nvl(String string, String defaultValue) throws Exception{
		String result = null;
		
		result = CommonUtils.nvl(string);
		
		if(result.equals("")){
			result = defaultValue;
		}
		
		return result;
	}
	
	/**
	 * 문자열이 널일경우 ""으로 반환하는 메소드
	 * 
	 * @param String string : 검사할 문자열
	 * @return String : 결과값
	 * @throws Exception : 반환 중 예외발생시
	 */
	public static String nvl(String string){
		String result = null;
		
		if(string == null){
			result = "";
		}
		else{
			result = string;
		}
		
		return result;
	}
	
	/**
     * Object를 받아 문자열 값으로 리턴함.
     * @param  Object obj
     * @return String
     */
	public static String getString(Object obj) {
 		String value = "" + obj;
 		
 		try {
 			if(obj == null){
 				value = "";
 			} 
 			else {
	 			if(value.equals("null") || value.length() == 0){
	 				value = ""; 
	 			}
 			}
    	}
 		catch(Exception e){
 			value = "";
 		}
 		
 		return value;
	}
	
	/**
	 * Exception의 stackTrace정보를 반환하는 메소드
	 * 
	 * @param e
	 * @return
	 */
	public static String getExceptionStackTrace(Exception e){
		String      result      = null;
		Writer      writer      = null;
		PrintWriter printwriter = null;
		
		writer      = new StringWriter();
		printwriter = new PrintWriter(writer);
		
		e.printStackTrace(printwriter);
		
		result = writer.toString();
		
		return result;
	}
	
	/**
	 * Exception을 받아 len까지 Exception메시지을 리턴함
	 * 
	 * @param exception
	 * @param len
	 * @return
	 */
	public static String getErrSubString(Exception exception, int len) {
		String msg = getExceptionStackTrace(exception); // Exception의 stackTrace정보를 반환
		
		msg = getSubstring(msg, 0, len); // 에러대신 Zero String을 리턴하는 substring
		
		return msg;
	}
	
	/**
	* 기능 : 에러대신 Zero String을 리턴하는 substring 함수    <BR>
	*        (예) getSubstring("1234",4,2) --> ""   <BR>
	* @param    String   str      string source
	* @param    int      start    substring 시작위치
	* @param    int      length   substring 길이
	* @return   String
	*/
    public static String getSubstring(String str, int start, int len){
    	String result = null;
    	int    slen   = 0;
    	
    	try{
    		str  = nvl(str);
        	slen = str.length();
        	
        	if((slen < 1) || (start < 0) || (len < 1)){
            	throw new Exception();
            }

            if((slen - 1) < start){
            	throw new Exception();
            }

            if(slen >= (start + len)){
            	slen = start+len;
            }
            
            result = str.substring(start, slen);
    	}
    	catch(Exception e){
    		result = "";
    	}
        
        return result;
    }
    
    /**
     * 문자열의 바이트 길이가 넘어갈 경우 substring후 postFix를 붙여 반환하는 메소드
     * 
     * @param str
     * @param len
     * @param postFix
     * @return String
     */
    public static String getByteSubstring(String str, int len, String postFix){
    	byte[] strByteArray       = null;
    	int    strByteArrayLength = 0;
    	int    strLength          = 0;
    	
    	str                = nvl(str);
    	strByteArray       = str.getBytes();
    	strByteArrayLength = strByteArray.length;
    	
    	if(strByteArrayLength > len){
    		while(strByteArrayLength > len){
    			strLength          = str.length();
    			strLength          = strLength - 1;
    			str                = str.substring(0, strLength);
    			strByteArray       = str.getBytes();
    	    	strByteArrayLength = strByteArray.length;
    		}
    		
    		str = str + postFix;
    	}
    	
    	return str;
    }
	
	/**
	 * sopt 형태의 부등호를 실제 부등호 바꾸어 줌
	 * @param searchOper sopt 형태의 부등호
	 * @param searchString 조회값
	 * @return
	 */
	public static String getStringSoptSign(String searchOper, String searchString) {
		String soptSignString = "";
		
		searchOper = nvl(searchOper);
		
		if("eq".equals(searchOper)) {
			soptSignString = " = '" + searchString + "' ";
		}
		else if("ne".equals(searchOper)) {
			soptSignString = " <> '" + searchString + "' ";
		}
		else if("gt".equals(searchOper)) {
			soptSignString = " > '" + searchString + "' ";
		}
		else if("gte".equals(searchOper)) {
			soptSignString = " >= '" + searchString + "' ";
		}
		else if("lt".equals(searchOper)) {
			soptSignString = " < '" + searchString + "' ";
		}
		else if("lte".equals(searchOper)) {
			soptSignString = " <= '" + searchString + "' ";
		}
		else if("cn".equals(searchOper)) {
			soptSignString = " like '%" + searchString + "%' ";
		}
		else if("bw".equals(searchOper)) {
			soptSignString = " like '" + searchString + "%' ";
		}
		else if("ew".equals(searchOper)) {
			soptSignString = " like '%" + searchString + "' ";
		}
		
		return soptSignString;
	}
	
	/**
	* 현재 시스템 날짜를 "yyyyMMdd" 형식으로 String 형으로 반환
	* @return String
	*/
	public static String getCurrentDate() {
		return getCustomDay("", 0);
	}

	/**
	* 현재 시스템 시간을 "HHmmss" 형식으로 String 형으로 반환
	* @return String
	*/
	public static String getCurrentTime(){
		Timestamp    wdate             = null;
		String       sDate             = null;
		String       temp              = null;
		StringBuffer stringBuffer      = new StringBuffer();
		long         currentTimeMillis = System.currentTimeMillis();
		
		wdate = new Timestamp(currentTimeMillis);
		sDate = wdate.toString();
		
		stringBuffer.append(sDate.substring(11, 13));
		stringBuffer.append(sDate.substring(14, 16));
		stringBuffer.append(sDate.substring(17, 19));
		
		temp = stringBuffer.toString();
		
		return temp;
	}
	
	/**
	 * 현재 시스템 날짜 시간을 "yyyy-MM-dd HH24:mm:ss" 형식으로 반환
	 * 
	 * @return String
	 */
	public static String getCurrentDateTime(){
		Timestamp timestamp         = null;
		String    timestampString   = null;
		long      currentTimeMillis = 0;
		
		currentTimeMillis = System.currentTimeMillis();
		
		timestamp = new Timestamp(currentTimeMillis);
		
		timestampString = timestamp.toString();
		timestampString = timestampString.substring(0, 19);
		
		return timestampString;
	}
	
	/**
	* 현재 일자 기준으로 이전 일자를 찾아 리턴한다.
	* @param  int
	* @return String
	*/
	public static String getCustomDay(String mode, int addDay){
		Calendar         dt = Calendar.getInstance();
		SimpleDateFormat df = new SimpleDateFormat ("yyyy-MM-dd");
		
		if (addDay == 0) {
			return df.format(dt.getTime()); 
		}
		else {
			if (mode.equals("MONTH")) {
				dt.add(Calendar.MONTH, addDay);
				
				return df.format(dt.getTime()); 
			}
			else if (mode.equals("YEAR")) {
				dt.add(Calendar.YEAR, addDay);
				
				return df.format(dt.getTime()); 
			}else {
				dt.add(Calendar.DATE, addDay);
				
				return df.format(dt.getTime()); 
			}
		}
	}
	
	/**
	 * 숫자나 문자열ㅇ르 Int형 문자로 변환
	 * @param object
	 * @return
	 */
	public static String getIntString(Object object) {
		String returnString = "";
		if(object==null) return returnString;
		returnString = String.valueOf(object);
		if(returnString == "") return returnString; 
		try {
			Double doubleValue = Double.valueOf(returnString);
			DecimalFormat df = new DecimalFormat( "#,###" );
			return df.format(doubleValue);
		} catch(Exception e) {
//			
			returnString = String.valueOf(object);
		}
		return returnString;
	}
	
	
    /**
	 * String UnEscape 처리
	 * 
	 * @param src
	 * @return
	 */
	public static String unescape(String src) {
		StringBuffer tmp = new StringBuffer();
		tmp.ensureCapacity(src.length());
		int lastPos = 0, pos = 0;
		char ch;
		while (lastPos < src.length()) {
			pos = src.indexOf("%", lastPos);
			if (pos == lastPos) {
				if (src.charAt(pos + 1) == 'u') {
					ch = (char) Integer.parseInt(src
							.substring(pos + 2, pos + 6), 16);
					tmp.append(ch);
					lastPos = pos + 6;
				} else {
					ch = (char) Integer.parseInt(src
							.substring(pos + 1, pos + 3), 16);
					tmp.append(ch);
					lastPos = pos + 3;
				}
			} else {
				if (pos == -1) {
					tmp.append(src.substring(lastPos));
					lastPos = src.length();
				} else {
					tmp.append(src.substring(lastPos, pos));
					lastPos = pos;
				}
			}
		}
		return tmp.toString();
	}

	
	/*============================ staticMenu 관련 Util ============================*/
	/**
	 * 고정메뉴의 Style Display 여부을 String으로 리턴
	 * @param staticMenuList
	 * @param menuCd
	 * @return
	 */
	public static String getStaticMenuDisplay(List<LoginMenuDto> staticMenuList, String menuCd) {
		String displayString = "none";
		if(staticMenuList!=null && staticMenuList.size()>0) {
			for(LoginMenuDto staticMenuDto : staticMenuList) {
				if(menuCd.equals(staticMenuDto.getMenuCd())) {
					displayString = "display";
					break;
				}
			}
		}
		return displayString;
	}
	/**
	 * 고정메뉴의 Forward 경로을 반환
	 * @param staticMenuList
	 * @param menuCd
	 * @param contextPath
	 * @return
	 */
	public static String getStaticMenuForward(List<LoginMenuDto> staticMenuList, String menuCd, String contextPath) {
		String forwardPath = "";
		if(staticMenuList!=null && staticMenuList.size()>0) {
			for(LoginMenuDto staticMenuDto : staticMenuList) {
				if(menuCd.equals(staticMenuDto.getMenuCd())) {
					forwardPath = contextPath + staticMenuDto.getFwdPath();
					break;
				}
			}
		}
		return forwardPath;
	}
	/**
	 * 고정메뉴의 Function 반환
	 * @param staticMenuList
	 * @param menuCd
	 * @return
	 */
	public static String getStaticMenuFunction(List<LoginMenuDto> staticMenuList, String menuCd) {
		String forwardFunction = "";
		if(staticMenuList!=null && staticMenuList.size()>0) {
			for(LoginMenuDto staticMenuDto : staticMenuList) {
				if(menuCd.equals(staticMenuDto.getMenuCd())) {
					forwardFunction = staticMenuDto.getFwdPath();
					break;
				}
			}
		}
		return forwardFunction;
	}
	
	/**
	 * 고정메뉴의 메뉴코드의 메뉴ID 반환
	 * @param staticMenuList
	 * @param menuCd
	 * @return
	 */
	public static String getStaticMenuId(List<LoginMenuDto> staticMenuList, String menuCd) {
		String menuId = "";
		if(staticMenuList!=null && staticMenuList.size()>0) {
			for(LoginMenuDto staticMenuDto : staticMenuList) {
				if(menuCd.equals(staticMenuDto.getMenuCd())) {
					menuId = staticMenuDto.getMenuId();
					break;
				}
			}
		}
		return menuId;
	}
	
	/*============================ 기타 Util ============================*/
	/**
	 * 화면에 대한 화면권한을 보여줄 것 인지에 대한 여부
	 * @param roleList 화면권한 List
	 * @param activityCd 화면권한 Code
	 * @return (display:none or display:)
	 */
	public static String getDisplayRoleButton(List<ActivitiesDto> roleList, String activityCd) {
		boolean isRole = false;
		String displayString = "display:";
		if(roleList!=null) {
			for(ActivitiesDto dto : roleList) {
				if(activityCd.equals(dto.getActivityCd())) { isRole = true; break; }
			}
		}
		if(!isRole) displayString += "none;";
		else displayString += "inline;";
		return displayString;
	}
	
	/**
	 * 화면에 대한 visibility 것인지 대한 여부 ( show() hide() 사용하여  Object 설정시 ) 
	 * @param roleList 화면권한 List
	 * @param activityCd 화면권한 Code
	 * @return (visibility: hidden; or visibility: )
	 */
	public static String getVisibilityRoleButton(List<ActivitiesDto> roleList, String activityCd) {
		boolean isRole = false;
		String displayString = "visibility:";
		if(roleList!=null) {
			for(ActivitiesDto dto : roleList) {
				if(activityCd.equals(dto.getActivityCd())) { isRole = true; break; }
			}
		}
		if(!isRole) displayString += "hidden";
		return displayString;
	}
	
	
	
	
	/**
	 * 화면에 대한 화면권한이 있으면 CallBack함수 호출
	 * @param roleList
	 * @param activityCd
	 * @param callBack
	 * @return
	 */
	public static String isDisplayRole(List<ActivitiesDto> roleList, String activityCd, String callBack) {
		boolean isRole = false;
		if(roleList!=null) {
			for(ActivitiesDto dto : roleList) {
				if(activityCd.equals(dto.getActivityCd())) { isRole = true; break; }
			}
		}
		if(isRole) return callBack;
		return "";
	}
	/**
	 * 화면권한 존재여부 체크
	 * @param roleList
	 * @param activityCd
	 * @return
	 */
	public static boolean isRoleExist(List<ActivitiesDto> roleList, String activityCd) {
		boolean isRole = false;
		if(roleList!=null) {
			for(ActivitiesDto dto : roleList) {
				if(activityCd.equals(dto.getActivityCd())) { isRole = true; break; }
			}
		}
		return isRole;
	}
	
	/**
	 * 메일전송
	 * @param toEmailAddrArray
	 * @param mailSubject
	 * @param mailContents
	 */
	public static void sendEmail(String[] toEmailAddrArray, String mailSubject, String mailContents) throws Exception {
		if(toEmailAddrArray==null || toEmailAddrArray.length==0) return;
		int mailToCnt = 0;
		for(String toEmailAddr : toEmailAddrArray) {
			if(isCheckMailAddr(toEmailAddr)) { mailToCnt++; }
		}
		if(mailToCnt==0) return;
		Properties prop = new Properties();
		prop.put("mail.smtp.host", Constances.MAIL_HOST);
		
		Session session = Session.getDefaultInstance(prop, null);
		MimeMessage message = new MimeMessage(session);
//		try {
			InternetAddress from = new InternetAddress(Constances.MAIL_SENDER_ADDRESS);
			message.setFrom(from);
			InternetAddress[] toList = new InternetAddress[mailToCnt];
			int i = 0;
			for(String toEmailAddr : toEmailAddrArray) {
				if(isCheckMailAddr(toEmailAddr)) {
					InternetAddress to = new InternetAddress(toEmailAddr.trim());
					toList[i++] = to;
				}
			}
			try{
				InternetAddress[] reply = new InternetAddress[1];
				reply[0] = new InternetAddress(Constances.MAIL_REPLYTO_ADDRESS.trim());
				message.setReplyTo(reply);
			}catch(Exception e){
				e.printStackTrace();
			}
			message.setRecipients(Message.RecipientType.TO, toList);
//			message.setSubject(mailSubject);
			message.setSubject(MimeUtility.encodeText(mailSubject,"EUC-KR","B"));
//			message.setContent(mailContents, "text/plain");
			message.setContent(setMailContents(mailContents), "text/html; charset=EUC-KR");
			Transport.send(message);
//		} catch (Exception e) {
//			
//			throw e;
//		}
	}
	public static boolean isCheckMailAddr(String mailAddress) {
		if(mailAddress==null || "".equals(mailAddress.trim())) return false;
		else {
			if(mailAddress.indexOf("@")==-1 || mailAddress.indexOf(".")==-1) return false;
		}
		return true;
	}
	public static String setMailContents(String contents) {
		StringBuffer mailContents = new StringBuffer();
		mailContents.append("<!DOCTYPE html PUBLIC '-//W3C//DTD XHTML 1.0 Transitional//EN' 'http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd'>");
		mailContents.append("<html xmlns='http://www.w3.org/1999/xhtml'>");
		mailContents.append("<head>");
		mailContents.append("<meta http-equiv='Content-Type' content='text/html; charset=utf-8' />");
		mailContents.append("<title>메일링 서비스 입니다.</title>");
		mailContents.append("</head>");
		mailContents.append("<body>");
		mailContents.append("<table width='780' border='0' cellspacing='0' cellpadding='0' style='font-size: 12px;line-height: 18px;color: #666;font-family:dotum;'>");
		mailContents.append("	<tr>");
		mailContents.append("		<td height='64' colspan='3' style=' font-size:12px; color:5e5e5e; padding:0 20px 10px 0; background-repeat:no-repeat' align='right' valign='bottom' background='"+Constances.MAIL_LINK_URL+"/img/system/mailImg/mail_form_img_01.gif' >");
		mailContents.append("			발송일 : "+getCurrentDate()+"");
		mailContents.append("		</td>");
		mailContents.append("	</tr>");
		mailContents.append("	<tr>");
		mailContents.append("		<td colspan='3' height='100' valign='bottom'><img src='"+Constances.MAIL_LINK_URL+"/img/system/mailImg/mail_form_title_01.gif' width='780' height='107' /></td>");
		mailContents.append("	</tr>");
		mailContents.append("	<tr>");
//		mailContents.append("		<td style=\"background-image: url('"+Constances.MAIL_LINK_URL+"/img/system/mailImg/mail_form_img_02.gif');\">&nbsp;</td>");
		mailContents.append("		<td width='69' background='"+Constances.MAIL_LINK_URL+"/img/system/mailImg/mail_form_img_02.gif'>&nbsp;</td>");
		mailContents.append("		<td width='642' height='150' style='font-size:15px; font-weight:bold; letter-spacing:-1px; color:#000000; padding-top:1px;vertical-align:middle;text-align:center'>");
		mailContents.append(contents);
//		mailContents.append("납품을 요청합니다.<p>");
//		mailContents.append("발주번호 : 12321321<br>");
		mailContents.append("<p>");
		mailContents.append("<a href='"+Constances.MAIL_LINK_URL+"'>OK플라자</a> 에서 확인바랍니다.");
		mailContents.append("		</td>");
		mailContents.append("		<td width='69' background='"+Constances.MAIL_LINK_URL+"/img/system/mailImg/mail_form_img_03.gif'>&nbsp;</td>");
		mailContents.append("	</tr>");
		mailContents.append("	<tr>");
		mailContents.append("		<td colspan='3'><img src='"+Constances.MAIL_LINK_URL+"/img/system/mailImg/mail_form_img_04.gif' width='780' height='80' /></td>");
		mailContents.append("	</tr>");
		mailContents.append("</table>");
		mailContents.append("</body>");
		mailContents.append("</html>");
		
		return mailContents.toString();
	}
	
	public static void main(String[] args) {
		String[] toEmailAddrArray = {"james@bitcube.co.kr","kangyj94@daum.net"};
		String mailContents = "납품을 요청합니다.<p>발주번호 : 12321321<br>고객사명 : 비트고객사<p>";
		try{
			sendEmail(toEmailAddrArray, "테스트메일", mailContents);
		} catch(Exception e) {
			
		}
	}
	
	/**
	 * 상품 규격을 DelimiterIdx를 이용하여 추출 
	 * @param contents
	 * @param prodSpecConstances
	 * @param dlimiterIdx
	 * @return
	 */
	public  static String getProdSpecByDelimiterIdx(String content ,int dlimiterIdx) {
		String contents[] = content.replaceAll(" ", "↔").split("↔");
		if(contents.length < dlimiterIdx)	return ""; 
		return contents[dlimiterIdx];
	}
	
	/**
	 * String 을 int 타입으로 변환시 "" Or Null 값에 대한 치환
	 * @param str        : 변환될 문자열 
	 * @param defaultVal : 변환시 디폴트 벨류 
	 * @return
	 */
	public static int stringParseInt(String str , int defaultVal){
		int returnVal = defaultVal; 
		if(str == null || str.equals(""))	return returnVal;
		
		try {
			str = str.replaceAll("\\,", "");
			str = str.replaceAll("\\-", "");
			str = str.replaceAll("\\_", "");
			str = str.replaceAll("\\/", "");
			returnVal = Integer.parseInt(str);
		} catch(NumberFormatException e) {}
		
		return returnVal;
	}
	
	/**
	 * String 을 int 타입으로 변환시 "" Or Null 값에 대한 치환
	 * @param str        : 변환될 문자열 
	 * @param defaultVal : 변환시 디폴트 벨류 
	 * @return
	 */
	public static long stringParseLong(String str , long defaultVal){
		long returnVal = defaultVal; 
		if(str == null || str.equals(""))	return returnVal;
		
		try {
			str = str.replaceAll("\\,", "");
			str = str.replaceAll("\\-", "");
			str = str.replaceAll("\\_", "");
			str = str.replaceAll("\\/", "");
			returnVal = Long.parseLong(str);
		} catch(NumberFormatException e) {}
		
		return returnVal;
	}
	
	/**
	 * String 을 Double 타입으로 변환시 "" Or Null 값에 대한 치환
	 * @param str        : 변환될 문자열 
	 * @param defaultVal : 변환시 디폴트 벨류 
	 * @return
	 */
	public static double stringParseDouble(String str , double defaultVal){
		double returnVal = defaultVal; 

		if(str == null || str.equals(""))	return returnVal;
		
		try {
			str = str.replaceAll("\\,", "");
			str = str.replaceAll("\\-", "");
			str = str.replaceAll("\\_", "");
			str = str.replaceAll("\\/", "");
			returnVal = Double.parseDouble(str);
		} catch(NumberFormatException e) {}
		
		return returnVal;
	}
	
	
	
	public static String lengthLimit(String inputStr, int limit, String fixStr) { 

        if (inputStr == null)
             return "";
 
        if (limit <= 0)
             return inputStr;
 
        byte[] strbyte = null;
 
        strbyte = inputStr.getBytes();
 

        if (strbyte.length <= limit) {
             return inputStr;
        }
 
        char[] charArray = inputStr.toCharArray();
 
        int checkLimit = limit;
         for ( int i = 0 ; i < charArray.length ; i++ ) {
             if (charArray[i] < 256) {
                 checkLimit -= 1;
             }
             else {
                 checkLimit -= 2;
             }
 
            if (checkLimit <= 0) {
                 break;
             }
         }
 
        //대상 문자열 마지막 자리가 2바이트의 중간일 경우 제거함
         
        byte[] newByte = new byte[limit + checkLimit];

        if(newByte.length <= limit){
        	
        	for ( int i = 0 ; i < newByte.length ; i++ ) {
        		newByte[i] = strbyte[i];
        	}
 
        	if (fixStr == null) {
        		return new String(newByte);
        	}else{
        		return new String(newByte) + fixStr;
        	}
        }else{
        	return new String(newByte);
        }
    }
	
	/**
	 * Dto Object를 Map으로 Conversion
	 * @param obj
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public static Map<String, Object> ConverObjectToMap(Object obj){
		try {
			if(obj instanceof Map) {
				return (Map<String, Object>) obj;
			} else {
				//Field[] fields = obj.getClass().getFields(); //private field는 나오지 않음.
				Field[] fields = obj.getClass().getDeclaredFields();
				Map<String, Object> resultMap = new HashMap<String, Object>();
				for(int i=0; i<=fields.length-1;i++){
					fields[i].setAccessible(true);
					resultMap.put(fields[i].getName(), fields[i].get(obj));
				}
				return resultMap;
			}
		} catch (IllegalArgumentException e) {
			
		} catch (IllegalAccessException e) {
			
		}
		return null;
	}
	
	/**
	 * 페이징 조회시 스킵할 양을 계산하여 반환하는 메소드
	 * 
	 * @author tytolee
	 * @param pageNo : 조회할 페이지 번호
	 * @param pageSize : 페이징 사이즈
	 * @return int
	 * @throws Exception
	 * @since 2012-02-05
	 * @modify 2012-05-03 (페이지 사이즈 변환 메소드 변경, tytolee)
	 * @modify 2012-07-02 (소스 튜닝, tytolee)
	 * @modify 2012-07-26 (유틸 클래스 변경, tytolee)
	 */
	public static int getPageSkip(String pageNo, String pageSize) throws Exception{
		int pageNoInt   = 0;
		int pageSizeInt = 0;
		int pageSkip    = 0;
		
		pageNoInt   = parseInt(pageNo,   1); // 문자열을 Integer로 파싱
		pageSizeInt = parseInt(pageSize, 0); // 문자열을 Integer로 파싱
		pageSkip    = (pageNoInt - 1) * pageSizeInt;
		
		return pageSkip;
	}
	
	/**
	 * 문자열을 Integer로 파싱하는 메소드
	 * 
	 * @author tytolee
	 * @param target (파싱할 문자열)
	 * @param errorValue (파싱 에러시 사용할 값)
	 * @return Integer
	 * @throws Exception
	 */
	public static Integer parseInt(String target, int errorValue){
		Integer result    = null;
		String  targetNvl = nvl(target);
		
		try{
			result = Integer.parseInt(targetNvl);
		}
		catch(Exception e){
			result = errorValue;
		}
		
		return result;
	}
	
	/**
	 * jqGrid 정렬 방식을 문자열로 반환하는 메소드
	 * 
	 * @param sidx : 정렬 칼럼명
	 * @param sord : 정렬방법
	 * @return String
	 * @throws Exception
	 */
	public static String getOrderString(String sidx, String sord) throws Exception{
		String       result       = null;
		StringBuffer stringBuffer = new StringBuffer();
		
		sidx = nvl(sidx);
		sord = nvl(sord);
		
		stringBuffer.append(sidx).append(" ").append(sord);
		
		result = stringBuffer.toString();
		result = result.trim();
		
		return result;
	}
	
	/**
	 * 3자리마다 콤마추가하는 메소드
	 * 
	 * @param str
	 * @return String
	 * @throws Exception
	 */
	public static String getDecimalAmount(String str) throws Exception{
		 String result = null;
		 double doubl  = 0;
		 
		 str    = str.replaceAll(",", "");
		 doubl  = Double.parseDouble(str);
		 result = getDecimalAmount(doubl);
		 
		 return result;
	}
	
	public static String getDecimalAmount(double target) throws Exception{
		String        result        = null;
		DecimalFormat decimalFormat = new DecimalFormat("#,##0");
		
		result = decimalFormat.format(target);
		
		return result;
	}
	
	public static String[] getListToArray(List<String> list) throws Exception{
		String[] result   = null;
		int      listSize = -1;
		int      i        = 0;
		
		if(list != null){
			listSize = list.size();
		}
		
		if(listSize > -1){
			result = new String[listSize];
			
			for(i = 0; i < listSize; i++){
				result[i] = list.get(i);
			}
		}
		
		return result;
	}
	
	/**
	 * 리스트의 사이즈르 측정하여 반환하는 메소드 널일경우 -1 반환
	 * 
	 * @param list
	 * @return int
	 * @throws Exception
	 */
	@SuppressWarnings("rawtypes")
	public static int getListSize(List list) throws Exception{
		int result = -1;
		
		if(list != null){
			result = list.size();
		}
		
		return result;
	}
	
	@SuppressWarnings("unchecked")
	public static List<Map<String, String>> selectListObjectToListMap(List<Object> list) throws Exception{
		List<Map<String, String>> result     = new ArrayList<Map<String, String>>();
		Map<String, String>       resultInfo = null;
		int                       listSize   = CommonUtils.getListSize(list); // 리스트 사이즈 조회
		int                       i          = 0;
		
		for(i = 0; i < listSize; i++){
			resultInfo = (Map<String, String>)list.get(i);
			
			result.add(resultInfo);
		}
		
		return result;
	}
	
	/**
	 * 로그인 사용자가 메니져 인지 여부를 판단하는 메소드
	 * 
	 * @param loginUserDto
	 * @return boolean
	 * @throws Exception
	 */
	public static boolean isMngUser(LoginUserDto loginUserDto) throws Exception{
		boolean isSkbMng = loginUserDto.isSKBMng();
		boolean isSktMng = loginUserDto.isSKTMng();
		boolean isMng    = false;
		
		if(isSkbMng || isSktMng){ // 메니져 여부 판단
			isMng = true;
		}
		
		return isMng;
	}
	
	/**
	 * request에 담겨있는 menuId 정보를 반환하는 메소드
	 * 
	 * @param request
	 * @return String
	 * @throws Exception
	 */
	public static String getRequestMenuId(HttpServletRequest request) throws Exception{
		String result = request.getParameter("_menuId");
		
		result = nvl(result);
		
		if("".equals(result)){
			result = (String)request.getAttribute("_menuId");
		}
		
		return result;
	}
	
	/**
	 * 소수접 2번째 자리수 반올림하는 메소드
	 * 
	 * @param string
	 * @return double
	 * @throws Exception
	 */
	public static String getRoundPercent(String string) throws Exception{
		String result       = null;
		double resultDouble = 0;
		
		string       = nvl(string, "0.00");
		resultDouble = Double.parseDouble(string);
		resultDouble = resultDouble * 10;
		resultDouble = Math.round(resultDouble);
		resultDouble = resultDouble / 10;
		result       = Double.toString(resultDouble);
		
		return result;
	}
	
	/**
	 * <pre>
	 * 문자열이 숫자로 구성되어 있는지 확인하는 메소드(소수포함)
	 * 
	 * ~. return (true : 숫자, false : 숫자가이님)
	 * </pre>
	 * 
	 * @param s (검사할 문자열)
	 * @return boolean
	 */
	public static boolean isNumeric(String s) {  

        return s.matches("[-+]?\\d*\\.?\\d+");  

    }
	
	/**
	 * <pre>
	 * 문자열이 정수로 구성되어 있는지 확인하는 메소드(소수미포함)
	 * 
	 * ~. return (true : 숫자, false : 숫자가이님)
	 * </pre>
	 * 
	 * @param s (검사할 문자열)
	 * @return boolean
	 */
	public static boolean CheckNumber(String str){
		boolean result = false;
		
		if(Pattern.matches("^[0-9]+$", str)){
			result = true;
		}
		
		return result;
	}
	
	public static String decrypt(String encrypt) throws Exception {
		StringBuffer stringBuffer = null;
		String       result       = null;
		String       sLen         = null;
		String       code         = null;
		int          pos          = 0;
		int          nLen         = 0;
		boolean      flg          = true;
		
		stringBuffer = new StringBuffer();
		
		if(encrypt != null){
	        if(encrypt.length() > 1){
	            while(flg){
	                sLen = encrypt.substring(pos,++pos);
	                nLen = 0;

	                try{
	                    nLen = Integer.parseInt(sLen);
	                }
	                catch(Exception e){
	                    nLen = 0;
	                }

	                code = "";
	                
	                if((pos + nLen) > encrypt.length()){
	                	code = encrypt.substring(pos);
	                }
	                else{
	                	code = encrypt.substring(pos,(pos+nLen));
	                }

	                pos += nLen;

	                stringBuffer.append(((char) Integer.parseInt(code)));

	                if(pos >= encrypt.length()){
	                	flg = false;
	                }
	            }
	        }
	    }
	    else{
	    	encrypt = "";
	    }
		
		result = stringBuffer.toString();
		
		return result;
	}
	
	/**
	 * 상품규격들을 조합하여 가져옴
	 * @param paramMap
	 * @return
	 */
	@SuppressWarnings("rawtypes")
	public static String getSpecUnion(Map paramMap) {
		String good_spec_desc = "";
		String spec_spec = getString(paramMap.get("spec_spec"));
		String spec_pi = getString(paramMap.get("spec_pi"));
		String spec_width = getString(paramMap.get("spec_width"));
		String spec_deep = getString(paramMap.get("spec_deep"));
		String spec_height = getString(paramMap.get("spec_height"));
		String spec_liter = getString(paramMap.get("spec_liter"));
		String spec_ton = getString(paramMap.get("spec_ton"));
		String spec_meter = getString(paramMap.get("spec_meter"));
		String spec_material = getString(paramMap.get("spec_material"));
		String spec_size = getString(paramMap.get("spec_size"));
		String spec_color = getString(paramMap.get("spec_color"));
		String spec_type = getString(paramMap.get("spec_type"));
		String spec_weight_sum = getString(paramMap.get("spec_weight_sum"));
		String spec_weight_real = getString(paramMap.get("spec_weight_real"));
		
		if(!"".equals(spec_spec)) { good_spec_desc += spec_spec; }
		if(!"".equals(spec_pi)) { good_spec_desc += " Ø:"+spec_pi; }
		if(!"".equals(spec_width)) { good_spec_desc += " W:"+spec_width; }
		if(!"".equals(spec_deep)) { good_spec_desc += " D:"+spec_deep; }
		if(!"".equals(spec_height)) { good_spec_desc += " H:"+spec_height; }
		if(!"".equals(spec_liter)) { good_spec_desc += " L:"+spec_liter; }
		if(!"".equals(spec_ton)) { good_spec_desc += " t:"+spec_ton; }
		if(!"".equals(spec_meter)) { good_spec_desc += " M(미터):"+spec_meter; }
		if(!"".equals(spec_material)) { good_spec_desc += " 재질:"+spec_material; }
		if(!"".equals(spec_size)) { good_spec_desc += " 크기:"+spec_size; }
		if(!"".equals(spec_color)) { good_spec_desc += " 색상:"+spec_color; }
		if(!"".equals(spec_type)) { good_spec_desc += " TYPE:"+spec_type; }
		if(!"".equals(spec_weight_sum)) { good_spec_desc += " 총중량(KG,할증포함):"+spec_weight_sum; }
		if(!"".equals(spec_weight_real)) { good_spec_desc += " 실중량(KG):"+spec_weight_real; }
		
		return good_spec_desc;
	}
}