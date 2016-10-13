package kr.co.bitcube.common.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import kr.co.bitcube.common.dao.CommonDao;
import kr.co.bitcube.common.dto.ChatDto;
import kr.co.bitcube.common.dto.ChatLoginDto;
import kr.co.bitcube.common.dto.LoginUserDto;
import kr.co.bitcube.common.dto.WebChatDto;
import kr.co.bitcube.common.service.CommonSvc;
import kr.co.bitcube.common.service.WebChatService;
import kr.co.bitcube.common.utils.Constances;
import kr.co.bitcube.common.utils.CustomResponse;
import kr.co.bitcube.organ.dto.SmpUsersDto;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

/**
 * 웹 채팅과 관련된 요청을 처리하는 Controller 클래스
 * 
 * @author tytolee
 * @since 2012-05-22
 */
@Controller
@RequestMapping("webChat")
public class WebChatController {
	@Autowired
	private WebChatService webChatService;
	
	@Autowired
	private CommonSvc commonSvc;
	
	@Autowired
	private CommonDao commonDao;
	/**
	 * 웹 채팅 요청을 받아 처리하는 메소드
	 * 
	 * @author tytolee
	 * @param req
	 * @param res
	 * @throws Exception
	 * @since 2012-05-22
	 * @modify 2012-05-30 (sendMessage 메소드 리턴값 변경에 따른 소스 수정, tytolee)
	 * @modify 2012-05-30 (sendMessage 메소드 파라미터값 변경에 따른 소스 수정, tytolee)
	 * @modify 2012-05-30 (페이지 최초 진입시 로그인 정보 전파 소스 추가, tytolee)
	 * @modify 2012-06-18 (메세지를 단건에서 리스트로 변경되어 소스 수정, tytolee)
	 * @modity 2012-06-18 (히스토리성 주석 삭제, tytolee)
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping("/sendMessage.sys")
	public ModelAndView sendMessage(HttpServletRequest req, HttpServletResponse res) throws Exception{
		String              fromMemberNo   = null;
		String              fromMemberName = null;
		String              toMemberNo     = null;
		String              message        = null;
		String              isBusy         = null;
		String              messageSeq     = null; // 변수 추가(2012-05-30, tytolee)
		HttpSession         session        = null;
		ModelAndView        modelAndView   = null;
		List<WebChatDto>    webChatDto     = null;
		LoginUserDto        adminDto       = null;
		Map<String, Object> map            = null; // 변수 추가(2012-05-30, tytolee)
		WebChatDto          tempWebChatDto = null;
		
		modelAndView = new ModelAndView();
		
		session      = req.getSession();
		adminDto     = (LoginUserDto)session.getAttribute(Constances.SESSION_NAME);
		
		if(adminDto == null){
			webChatDto     = new ArrayList<WebChatDto>();
			tempWebChatDto = new WebChatDto();
			
			tempWebChatDto.setType("SESSIONOUT");
			
			webChatDto.add(tempWebChatDto);
		}
		else{
			fromMemberNo   = adminDto.getUserId();
			fromMemberName = adminDto.getUserNm();
			toMemberNo     = req.getParameter("toMemberNo");
			message        = req.getParameter("message");
			isBusy         = req.getParameter("isBusy");
			messageSeq     = req.getParameter("messageSeq"); // 파라미터 값 추가로 인한 소스 추가(2012-05-30, tytolee)
			
			if(messageSeq.equals("0")){ // 최초 페이지 진입일 경우 다른 사람들에게 자신의 로그인 상태를 알림(2012-05-30, tytolee)
				this.webChatService.loginAnnounce(session);
			}
			
			map = this.webChatService.sendMessage(fromMemberNo, fromMemberName, toMemberNo, message, isBusy, messageSeq); // 서비스에 메세지 처리 요청
			
			// 리턴값 변경으로 인한 소스 추가 start!(2012-05-30, tytolee)
			webChatDto = (List<WebChatDto>)map.get("WebChatDto");
			messageSeq = ((Integer)map.get("messageSeq")).toString();
			// 리턴값 변경으로 인한 소스 추가 end!(2012-05-30, tytolee)
		}
		
		modelAndView.setViewName("jsonView");
		modelAndView.addObject("webChatDto", webChatDto);
		modelAndView.addObject("messageSeq", messageSeq); // 리턴값 변경으로 인한 소스 추가 (2012-05-30, tytolee)
		
		return modelAndView;
	}
	
	/**
	 * 웹 채팅 팝업창으로 이동하는 메소드
	 * 
	 * @author tytolee
	 * @param req
	 * @param res
	 * @return ModelAndView
	 * @throws Exception
	 * @since 2012-06-04
	 */
	@RequestMapping("/moveWebChatPop.sys")
	public ModelAndView moveWebChatPop(HttpServletRequest req, HttpServletResponse res) throws Exception{
		ModelAndView modelAndView = null;
		HttpSession  session      = null;
		
		modelAndView = new ModelAndView();
		session = req.getSession();
		
//		this.webChatService.loginAnnounce(session); // 사용자의 로그인을 다른 사용자에게 전달
		
		modelAndView.setViewName("webChat/webChatUser");
		return modelAndView;
	}
	
	@RequestMapping("/chatLoginList.sys")
	public ModelAndView chatLoginList(
			@RequestParam(value = "borgUserNm", defaultValue = "") String borgUserNm,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		LoginUserDto loginUserDto = (LoginUserDto)request.getSession().getAttribute(Constances.SESSION_NAME);
//		List<ChatLoginDto> chatLoginList = commonSvc.getChatLoginList(loginUserDto.getUserId(), loginUserDto.getBorgId());
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userId", loginUserDto.getUserId());
		params.put("branchId", loginUserDto.getBorgId());
		params.put("borgUserNm", borgUserNm);
		List<ChatLoginDto> chatLoginList = commonDao.selectChatLoginList(params);
		
		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("list", chatLoginList);
		return modelAndView;
	}
	
	
	/**
	 * 웹 채팅 대화 팝업창으로 이동하는 메소드
	 * 
	 * @author tytolee
	 * @param req
	 * @param res
	 * @return ModelAndView
	 * @throws Exception
	 * @since 2012-06-04
	 */
	@RequestMapping("/talkWebChatPop.sys")
	public ModelAndView talkWebChatPop(
			@RequestParam(value = "userId", required = true) String userId,
			@RequestParam(value = "branchId", required = true) String branchId,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception{
		
		LoginUserDto loginUserDto = (LoginUserDto)request.getSession().getAttribute(Constances.SESSION_NAME);
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("fromUserId", loginUserDto.getUserId());
		params.put("fromBranchId", loginUserDto.getBorgId());
		params.put("toUserId", userId);
		params.put("toBranchId", branchId);
		
		List<ChatDto> chatList = commonSvc.getChatList(params);
		modelAndView.setViewName("webChat/webChatTalk");
		modelAndView.addObject("chatList", chatList);
		return modelAndView;
	}
	
	/**
	 * 웹 채팅 내역 조회 팝업창으로 이동하는 메소드
	 * 
	 * @author tytolee
	 * @param req
	 * @param res
	 * @return ModelAndView
	 * @throws Exception
	 * @since 2012-05-29
	 */
	@RequestMapping("/getWebChatPop.sys")
	public ModelAndView getWebChatPop(
			HttpServletRequest request, ModelAndView modelAndView) throws Exception{
		
		modelAndView.setViewName("webChat/webChat");
		return modelAndView;
	}
	
	/**
	 * 사용자 채팅 메세지 정보를 조회하여 반환
	 * 
	 * @author tytolee
	 * @param req
	 * @param res
	 * @return ModelAndView
	 * @throws Exception
	 * @since 2012-06-19
	 */
	@RequestMapping("/getWebChatMessageList.sys")
	public ModelAndView getWebChatMessageList(
			@RequestParam(value = "userId", required = true) String userId,
			@RequestParam(value = "branchId", required = true) String branchId,
			@RequestParam(value = "srcYyyyMn", required = true) String srcYyyyMn,
			@RequestParam(value = "page", defaultValue = "1") int page,
			@RequestParam(value = "rows", defaultValue = "10") int rows,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception{
		
		LoginUserDto loginUserDto = (LoginUserDto)request.getSession().getAttribute(Constances.SESSION_NAME);
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("fromUserId", loginUserDto.getUserId());
		params.put("fromBranchId", loginUserDto.getBorgId());
		params.put("toUserId", userId);
		params.put("toBranchId", branchId);
		params.put("logTable", "SMPCHAT_LOG_"+srcYyyyMn);
		
		/*----------------페이징 세팅------------*/
        int records = commonSvc.getChatMessageListCnt(params); //조회조건에 따른 카운트
        int total = (int)Math.ceil((float)records / (float)rows);
		
        /*----------------조회------------*/
		List<ChatDto> chatList = null;
        if(records>0) chatList = commonSvc.getChatMessageList(params, page, rows);
		
        modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("page", page);
		modelAndView.addObject("total", total);
		modelAndView.addObject("records", records);
		modelAndView.addObject("list", chatList);
		return modelAndView;
	}
	
	
	@RequestMapping("/chatContinue.sys")
	public ModelAndView chatContinue(
			HttpServletRequest request, ModelAndView modelAndView) throws Exception{
		LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		if(loginUserDto!=null) {
			commonSvc.setChatContinue(loginUserDto.getUserId(), loginUserDto.getBorgId(), loginUserDto.getUserNm(), loginUserDto.getBorgNm());
			//자신에게 온 체팅 대화자 정보를 가져옴
			ChatLoginDto chatLoginDto = commonSvc.getChatMeUserInfo(loginUserDto.getUserId(), loginUserDto.getBorgId());
			if(chatLoginDto != null) modelAndView.addObject(chatLoginDto);
		}
		modelAndView.setViewName("jsonView");
		return modelAndView;
	}
	
	@RequestMapping("/chatDataReceive.sys")
	public ModelAndView chatDataReceive(
			@RequestParam(value = "userId", required = true) String userId,
			@RequestParam(value = "branchId", required = true) String branchId,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception{
		
		LoginUserDto loginUserDto = (LoginUserDto)request.getSession().getAttribute(Constances.SESSION_NAME);
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("fromUserId", userId);
		params.put("fromBranchId", branchId);
		params.put("toUserId", loginUserDto.getUserId());
		params.put("toBranchId", loginUserDto.getBorgId());
		
		List<ChatDto> chatMeList = commonSvc.getChatMeList(params);
		CustomResponse custResponse = new CustomResponse(true);
		for(ChatDto chatDto : chatMeList) {
			custResponse.setMessage(chatDto.getMessage());
		}
		modelAndView.setViewName("jsonView");
		modelAndView.addObject(custResponse);
		return modelAndView;
	}
	
	@RequestMapping("/chatDataSend.sys")
	public void chatDataSend(
			@RequestParam(value = "userId", required = true) String userId,
			@RequestParam(value = "branchId", required = true) String branchId,
			@RequestParam(value = "userNm", required = true) String userNm,
			@RequestParam(value = "message", required = true) String message,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception{
		
		LoginUserDto loginUserDto = (LoginUserDto)request.getSession().getAttribute(Constances.SESSION_NAME);
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("fromUserId", loginUserDto.getUserId());
		params.put("fromBranchId", loginUserDto.getBorgId());
		params.put("fromUserNm", loginUserDto.getUserNm());
		params.put("toUserId", userId);
		params.put("toBranchId", branchId);
		params.put("toUserNm", userNm);
		params.put("message", message);
		commonSvc.sendChatData(params);
	}
	
}