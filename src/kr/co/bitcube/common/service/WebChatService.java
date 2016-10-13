package kr.co.bitcube.common.service;

import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.annotation.PostConstruct;
import javax.annotation.Resource;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpSession;

import kr.co.bitcube.common.dao.WebChatDao;
import kr.co.bitcube.common.dto.LoginUserDto;
import kr.co.bitcube.common.dto.WebChatDto;
import kr.co.bitcube.common.queue.MessageQue;
import kr.co.bitcube.common.utils.Constances;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.ibatis.session.RowBounds;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.rte.fdl.idgnr.EgovIdGnrService;

@Service
public class WebChatService {
	private static HashMap<String, MessageQue> addressMap;
	private        Log                         logger;
	@Resource(name="seqMpChatService")
	private EgovIdGnrService seqMpChatService; // 채팅 내용 DB 저장을 위한 시컨스 생성서비스
	@Autowired
	private WebChatDao webChatDao; // 채팅 내용 DB 저장을 위한 DAO 클래스
	
	/**
	 * 서비스 객체 생성 후 호출되는 메소드
	 * 
	 * @author tytolee
	 * @throws Exception
	 * @since 2012-05-22
	 */
	@PostConstruct
	public void init() throws Exception{
		addressMap = new HashMap<String, MessageQue>();
		
		this.logger = LogFactory.getLog(this.getClass());
	}
	
	/**
	 * 메세지 처리를 하는 메소드<br/>
	 * 결과 맵 구조
	 * <ul>
	 * 	<li>
	 * 		WebChatDto (메세지 객체)
	 * 	</li>
	 * 	<li>
	 * 		messageSeq (메세지 번호)
	 * 	</li>
	 * </ul>
	 * 
	 * @author tytolee
	 * @param fromMemberNo (발송자 번호)
	 * @param fromMemberName (발송자명)
	 * @param toMemberNo (수신자번호)
	 * @param message (메세지)
	 * @param isBusy (대기 객체 반환여부, 0 : 미반환, 1 : 반환)
	 * @param messageSeq (조회 메세지 시컨스)
	 * @return WebChatDto (메세지 객체)
	 * @throws Exception
	 * @since 2012-05-22
	 */
	public Map<String, Object> sendMessage(String fromMemberNo, String fromMemberName, String toMemberNo, String message, String isBusy, String messageSeq) throws Exception{
		MessageQue          queue             = null;
		Map<String, Object> map               = null;
		Map<String, String> params            = null;
		Integer             messageSeqInteger = null;
		String              chatSeq           = null;
		
		params = new HashMap<String, String>();
		
		try{
			messageSeqInteger = Integer.parseInt(messageSeq);
		}
		catch(Exception e){
			messageSeqInteger = 0;
		}
		
		if(!message.equals("")){
			this.registMessage(fromMemberNo, fromMemberName, toMemberNo, message); // 메세지를 큐에 등록
			
			chatSeq = this.seqMpChatService.getNextStringId(); // 시컨스 조회
			
			params.put("chatId",  chatSeq);
			params.put("fromId",  fromMemberNo);
			params.put("toId",    toMemberNo);
			params.put("message", this.DeCode(message));
			
			this.webChatDao.insertWebChatInfo(params); // 채팅 내용 DB 저장
		}
		
		if(isBusy.equals("1")){
			this.registMessage(fromMemberNo, fromMemberName, fromMemberNo, ""); // 대기 객체 반환을 위해 빈 메세지 추가
		}
		
		queue = this.getMessageQue(fromMemberNo); // 사용자 번호에 해당하는 큐 객체 반환
		map   = queue.popMessage(messageSeqInteger);
		
		return map;
	}
	
	/**
	 * 사용자의 로그인을 다른 사용자에게 전달하는 메소드
	 * 
	 * @author tytolee
	 * @param httpSession
	 * @param adminDto
	 * @throws Exception
	 * @since 2012-05-24
	 */
	@SuppressWarnings("unchecked")
	public void loginAnnounce(HttpSession httpSession) throws Exception{
		ServletContext               servletContext   = null;
		HashMap<String, HttpSession> accessSessionMap = null;
		HttpSession                  mapSession       = null;
		Iterator<HttpSession>        value            = null;
		LoginUserDto                 mapAdminDto      = null;
		LoginUserDto                 adminDto         = null;
		
		adminDto         = (LoginUserDto)httpSession.getAttribute(Constances.SESSION_NAME);
		servletContext   = httpSession.getServletContext();
		accessSessionMap = (HashMap<String, HttpSession>)servletContext.getAttribute("accessSessionMap");
		value            = accessSessionMap.values().iterator();
		
		while(value.hasNext()){
			mapSession = value.next();
			
			if((mapSession != null) && (!httpSession.getId().equals(mapSession.getId()))){ // 맵에 담긴 세션이 널이 아니고 현재 세션이 아닐 경우
				mapAdminDto = (LoginUserDto)mapSession.getAttribute(Constances.SESSION_NAME);
				
				if((mapAdminDto != null) && (!adminDto.getUserId().equals(mapAdminDto.getUserId()))){ // 로그인 된 세션이고 같은 사용자가 아닐경우
					this.registType(adminDto.getUserId(),    adminDto.getUserNm(),    mapAdminDto.getUserId(), mapAdminDto.getBorgNm(), "LOGIN");
					this.registType(mapAdminDto.getUserId(), mapAdminDto.getUserNm(), adminDto.getUserId(), mapAdminDto.getBorgNm(),    "LOGIN");
				}
			}
		}
	}
	
	/**
	 * 사용자의 로그아웃을 다른 사용자에게 전달하는 메소드
	 * 
	 * @author tytolee
	 * @param httpSession
	 * @param adminDto
	 * @throws Exception
	 * @since 2012-05-24
	 */
	@SuppressWarnings("unchecked")
	public void logoutAnnounce(HttpSession httpSession) throws Exception{
		ServletContext               servletContext   = null;
		HashMap<String, HttpSession> accessSessionMap = null;
		HttpSession                  mapSession       = null;
		Iterator<HttpSession>        value            = null;
		LoginUserDto                 mapAdminDto      = null;
		LoginUserDto                 adminDto         = null;
		
		adminDto         = (LoginUserDto)httpSession.getAttribute(Constances.SESSION_NAME);
		servletContext   = httpSession.getServletContext();
		accessSessionMap = (HashMap<String, HttpSession>)servletContext.getAttribute("accessSessionMap");
		value            = accessSessionMap.values().iterator();
		
		if(adminDto != null){
			while(value.hasNext()){
				mapSession = value.next();
			  
				if((mapSession != null) && (!httpSession.getId().equals(mapSession.getId()))){ // 맵에 담긴 세션이 널이 아니고 현재 세션이 아닐 경우
					mapAdminDto = (LoginUserDto)mapSession.getAttribute(Constances.SESSION_NAME);
					
					if((mapAdminDto != null) && (!adminDto.getUserId().equals(mapAdminDto.getUserId()))){ // 로그인 된 세션이고 같은 사용자가 아닐경우
						this.registType(adminDto.getUserId(), adminDto.getUserNm(), mapAdminDto.getUserId(), "LOGOUT");
					}
				}
			}
		}
		
		addressMap.remove(adminDto.getUserId());
	}
	
	/**
	 * 사용자 채팅 메세지 정보를 조회하여 반환하는 메소드<br/>
	 * return map 구조
	 * <ul>
	 * 	<li>
	 * 		count : 총 데이터 카운트 (Integer)
	 * 	</li>
	 * 	<li>
	 * 		list : 해당 조회 리스트 페이지 (List<HashMap>)
	 * 	</li>
	 * 	<li>
	 * 		totalPage : 총 페이지 카운트 (Integer)
	 * 	</li>
	 * </ul>
	 * 
	 * @author tytolee
	 * @param fromId (사용자 아이디1)
	 * @param toId (사용자 아이디2)
	 * @return Map<String, Object>
	 * @throws Exception
	 * @since 2012-06-19
	 */
	@SuppressWarnings("rawtypes")
	public Map<String, Object> selectWebChatMessageList(String fromId, String toId, String pageNo, String pageSize) throws Exception{
		List<HashMap>       list            = null;
		Map<String, String> params          = null;
		Map<String, Object> result          = null;
		RowBounds           rowBounds       = null;
		Integer             count           = null;
		Integer             totalPage       = null;
		Integer             pageNoInteger   = null;
		Integer             pageSizeInteger = null;
		
		params = new HashMap<String, String>();
		result = new HashMap<String, Object>();
		
		params.put("fromId", fromId);
		params.put("toId",   toId);
		
		count = this.webChatDao.selectWebChatMessageListCount(params);
		
		if(count.intValue() == 0){
			list      = null;
			totalPage = 0;
		}
		else{
			try{
				pageNoInteger = Integer.parseInt(pageNo);				
			}
			catch(Exception e){
				pageNoInteger = 1;
			}
			
			try{
				pageSizeInteger = Integer.parseInt(pageSize);				
			}
			catch(Exception e){
				pageSizeInteger = 10;
			}
			
			rowBounds = new RowBounds((pageNoInteger - 1) * pageSizeInteger, pageSizeInteger);
			
			list      = this.webChatDao.selectWebChatMessageList(params, rowBounds); // 채팅 메세지 리스트를 조회하여 반환
			totalPage = (int)Math.ceil((float)count / (float)pageSizeInteger);
		}
		
		result.put("count",     count);
		result.put("list",      list);
		result.put("totalPage", totalPage);
		
		return result;
	}
	
	/**
	 * 메세지를 큐에 등록하는 메소드
	 * 
	 * @author tytolee
	 * @param fromMemberNo : 발송자 번호
	 * @param fromMemberName : 발송자 명
	 * @param toMemberNo : 수신자 번호
	 * @param message : 메세지
	 * @throws Exception
	 * @since 2012-05-22
	 */
	protected void registMessage(String fromMemberNo, String fromMemberName, String toMemberNo, String message) throws Exception{
		MessageQue queue      = null;
		WebChatDto webChatDto = null;
		
		webChatDto = new WebChatDto();
		
		queue = this.getMessageQue(toMemberNo); // 사용자 번호에 해당하는 큐 객체 반환
		
		webChatDto.setFromMemberNo(fromMemberNo);
		webChatDto.setFromMemberName(fromMemberName); // 발송자명 추가(2012-05-24, tytolee)
		webChatDto.setToMemberNo(toMemberNo);
		webChatDto.setMessage(message);
		
		queue.push(webChatDto); // 메세지를 큐에 등록
	}
	
	/**
	 * 메신저 타입을 큐에 등록하는 메소드
	 * 
	 * @param fromMemberNo : 보내는 사람 번호
	 * @param toMemberNo : 받는 사람 번호
	 * @param type : 등록 타입(LOGIN : 로그인, LOGOUT : 로그아웃)
	 * @throws Exception
	 * @since 2012-05-24
	 */
	protected void registType(String fromMemberNo, String fromMemberName, String toMemberNo, String type) throws Exception{
		MessageQue queue      = null;
		WebChatDto webChatDto = null;
		
		logger.debug("");
		logger.debug("fromMemberNo   : " + fromMemberNo);
		logger.debug("fromMemberName : " + fromMemberName);
		logger.debug("toMemberNo     : " + toMemberNo);
		logger.debug("type           : " + type);
		logger.debug("");
		
		webChatDto = new WebChatDto();
		
		queue = this.getMessageQue(toMemberNo); // 사용자 번호에 해당하는 큐 객체 반환
		
		webChatDto.setFromMemberNo(fromMemberNo);
		webChatDto.setToMemberNo(toMemberNo);
		webChatDto.setFromMemberName(fromMemberName);
		webChatDto.setMessage("");
		webChatDto.setType(type);
		
		queue.push(webChatDto); // 메세지를 큐에 등록
	}
	
	/**
	 * 메신저 타입을 큐에 등록하는 메소드
	 * 
	 * @param fromMemberNo : 보내는 사람 번호
	 * @param toMemberNo : 받는 사람 번호
	 * @param type : 등록 타입(LOGIN : 로그인, LOGOUT : 로그아웃)
	 * @throws Exception
	 * @since 2012-05-24
	 */
	protected void registType(String fromMemberNo, String fromMemberName, String toMemberNo, String fromMemberBorgNm, String type) throws Exception{
		MessageQue queue      = null;
		WebChatDto webChatDto = null;
		
		logger.debug("");
		logger.debug("fromMemberNo   	: " + fromMemberNo);
		logger.debug("fromMemberName 	: " + fromMemberName);
		logger.debug("toMemberNo     	: " + toMemberNo);
		logger.debug("fromMemberBorgNm  : " + fromMemberBorgNm);
		logger.debug("type           	: " + type);
		logger.debug("");
		
		webChatDto = new WebChatDto();
		
		queue = this.getMessageQue(toMemberNo); // 사용자 번호에 해당하는 큐 객체 반환
		
		webChatDto.setFromMemberNo(fromMemberNo);
		webChatDto.setToMemberNo(toMemberNo);
		webChatDto.setFromMemberName(fromMemberName);
		webChatDto.setFromMemberBorgNm(fromMemberBorgNm);
		webChatDto.setMessage("");
		webChatDto.setType(type);
		
		queue.push(webChatDto); // 메세지를 큐에 등록
	}
	
	/**
	 * 사용자 번호에 해당하는 큐 객체 반환하는 메소드
	 * 
	 * @author tytolee
	 * @param memberNo
	 * @return MessageQue
	 * @throws Exception
	 * @since 2011-05-22
	 */
	protected MessageQue getMessageQue(String memberNo) throws Exception{
		MessageQue queue = null;
		
		queue = addressMap.get(memberNo);
		
		if(queue == null){
			addressMap.put(memberNo, new MessageQue());
			
			queue = addressMap.get(memberNo);
		}
		
		return queue;
	}
	
	/**
	 * 클라이언트와의 한글 통신을 위한 문자 디코딩 함수<br/>
	 * 
	 * @author sjisbmoc
	 * @param param
	 * @return String
	 * @since 2011-01-26
	 */
	protected String DeCode(String param){
	    StringBuffer sb  = new StringBuffer();
	    int          pos = 0;
	    boolean      flg = true;

	    if(param!=null){
	        if(param.length()>1){
	            while(flg){
	                String sLen = param.substring(pos,++pos);
	                int    nLen = 0;

	                try{
	                    nLen = Integer.parseInt(sLen);
	                }
	                catch(Exception e){
	                    nLen = 0;
	                }

	                String  code    = "";
	                
	                if((pos+nLen)>param.length()){
	                	code = param.substring(pos);
	                }
	                else{
	                	code = param.substring(pos,(pos+nLen));
	                }

	                pos += nLen;

	                sb.append(((char) Integer.parseInt(code)));

	                if(pos >= param.length()){
	                	flg = false;
	                }
	            }
	        }
	    }
	    else{
	        param = "";
	    }

	    return sb.toString();
	}
}
