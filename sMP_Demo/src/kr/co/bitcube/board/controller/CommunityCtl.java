package kr.co.bitcube.board.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import kr.co.bitcube.board.dto.BoardDto;
import kr.co.bitcube.board.service.BoardSvc;
import kr.co.bitcube.common.dao.GeneralDao;
import kr.co.bitcube.common.dto.LoginUserDto;
import kr.co.bitcube.common.service.CommonSvc;
import kr.co.bitcube.common.utils.CommonUtils;
import kr.co.bitcube.common.utils.Constances;
import kr.co.bitcube.common.utils.CustomResponse;

import org.apache.log4j.Logger;
import org.apache.poi.hssf.record.chart.BarRecord;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;


@Controller
@RequestMapping("board")
public class CommunityCtl {

	private Logger logger = Logger.getLogger(getClass());
	
	@Autowired
	private BoardSvc boardSvc;
	@Autowired
	private GeneralDao generalDao;
	@Autowired
	private CommonSvc commonSvc;
	
	/*--------------------------------------------------공지사항 시작----------------------------------------------------------*/
	/**
	 * 공지사항 페이지로 이동하는 메소드
	 */
	@RequestMapping("noticeList.sys")
	public ModelAndView getNoticeList(
			HttpServletRequest req, ModelAndView mav) throws Exception{
		mav.setViewName("board/community/noticeList");
		return mav;
	}
	/**
	 * 공지사항 DB조회후 리턴시켜주는 메소드
	 */
	@RequestMapping("noticeListJQGrid.sys")
	public ModelAndView noticeListJQGrid(
			@RequestParam(value = "page", defaultValue = "1") int page,
			@RequestParam(value = "rows", defaultValue = "30") int rows,
			@RequestParam(value = "sidx", defaultValue = "board_No") String sidx,
			@RequestParam(value = "sord", defaultValue = "desc") String sord,
			@RequestParam(value = "srcTitle", defaultValue = "") String srcTitle,
			@RequestParam(value = "srcMessage", defaultValue = "") String srcMessage,
			@RequestParam(value = "srcRegi_User_Numb", defaultValue = "") String srcRegi_User_Numb,
			@RequestParam(value = "board_Type", defaultValue = "0102") String board_Type,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		LoginUserDto loginUserDto = (LoginUserDto)request.getSession().getAttribute(Constances.SESSION_NAME);
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("srcTitle", srcTitle);
		params.put("srcMessage", srcMessage);
		params.put("srcRegi_User_Numb", srcRegi_User_Numb);
		params.put("board_Type", board_Type);
		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
		if(!"ADM".equals(loginUserDto.getSvcTypeCd())){
			params.put("srcBoardBorgType", loginUserDto.getSvcTypeCd());
			if("BUY".equals(loginUserDto.getSvcTypeCd())){
				params.put("workId", loginUserDto.getSmpBranchsDto().getWorkId());
			}
		}
		
		/*----------------페이징 세팅------------*/
        int records = boardSvc.getNoticeListCnt(params); //조회조건에 따른 카운트
        int total = (int)Math.ceil((float)records / (float)rows);
		
        /*----------------조회------------*/
        List<BoardDto> list = null;
        if(records>0) list = boardSvc.getNoticeList(params, page, rows);

		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("page", page);
		modelAndView.addObject("total", total);
		modelAndView.addObject("records", records);
		modelAndView.addObject("list", list);
		return modelAndView;
	}

	/**
	 * 공지사항 상세 페이지를 조회하여 반환하는 메소드
	 */
	@RequestMapping("noticeDetail.sys")
	public ModelAndView noticeDetail(
			@RequestParam(value = "board_No", required = true) String board_No,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> searchMap = new HashMap<String, Object>();
		searchMap.put("board_No", board_No);
		BoardDto detailInfo = this.boardSvc.getNoticeDetailInfo(searchMap);
		modelAndView.setViewName("board/community/noticeDetail");
		modelAndView.addObject("detailInfo", detailInfo);
		return modelAndView;
	}
	
	/**
	 * 공지사항 팝업 페이지를 조회하여 반환하는 메소드
	 */
	@RequestMapping("noticePop.sys")
	public ModelAndView noticePop(
			@RequestParam(value = "board_No", required = true) String board_No,
			@RequestParam(value = "board_Type", required = true) String board_Type,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> searchMap = new HashMap<String, Object>();
		searchMap.put("board_No", board_No);
		searchMap.put("board_Type", board_Type);
		BoardDto detailInfo = this.boardSvc.getNoticePop(searchMap);
		modelAndView.setViewName("board/community/popupFormNew");
		modelAndView.addObject("detailInfo", detailInfo);
		return modelAndView;
	}
	
	/**
	 * 공지사항 등록 페이지로 이동하는 메소드
	 */
	@RequestMapping("noticeWrite.sys")
	public ModelAndView noticeWrite(
			@RequestParam(value = "board_No", defaultValue = "") String board_No,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		Map<String, Object> searchMap  = new HashMap<String, Object>();
		BoardDto            detailInfo = null;
		
		searchMap.put("board_No", board_No);
		
		if("".equals(board_No) == false){
			detailInfo = this.boardSvc.getNoticeDetailInfo(searchMap);
		}
		
		modelAndView.setViewName("board/community/noticeWrite");
		modelAndView.addObject("detailInfo", detailInfo);
		
		return modelAndView;
	}
	
	/**
	 * 공지사항 등록, 수정, 삭제 메소드
	 */
	@RequestMapping("noticeTransGrid.sys")
	public ModelAndView noticeTransGrid(
			@RequestParam(value = "oper", required = true) String oper,
			@RequestParam(value = "id", defaultValue = "") String id,
			@RequestParam(value = "board_No", defaultValue = "") String board_No,
			@RequestParam(value = "board_Type", defaultValue = "0102") String board_Type,
			@RequestParam(value = "board_Borg_Type", defaultValue = "ALL") String board_Borg_Type,
			@RequestParam(value = "title", defaultValue = "") String title,
			@RequestParam(value = "regi_User_Numb", defaultValue = "") String regi_User_Numb,
			@RequestParam(value = "message", defaultValue = "") String message,
			@RequestParam(value = "email_Yn", defaultValue = "Y") String email_Yn,
			@RequestParam(value = "sms_Yn", defaultValue = "Y") String sms_Yn,
			@RequestParam(value = "popup_Start", defaultValue = "") String popup_Start,
			@RequestParam(value = "popup_End", defaultValue = "") String popup_End,
			@RequestParam(value = "regi_BorgId", defaultValue = "") String regi_BorgId,
			@RequestParam(value = "file_list1", defaultValue = "") String file_list1,
			@RequestParam(value = "file_list2", defaultValue = "") String file_list2,
			@RequestParam(value = "file_list3", defaultValue = "") String file_list3,
			@RequestParam(value = "file_list4", defaultValue = "") String file_list4,
			@RequestParam(value = "workId", defaultValue = "") String workId,
			@RequestParam(value = "classify", defaultValue = "") String classify,
			@RequestParam(value = "standard", defaultValue = "") String standard,
			@RequestParam(value = "important", defaultValue = "N") String important,
			@RequestParam(value = "emergency", defaultValue = "N") String emergency,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		LoginUserDto       userInfoDto  = CommonUtils.getLoginUserDto(request); // 로그인 사용자 정보 조회
		Map<String,Object> saveMap      = new HashMap<String,Object>();
		CustomResponse     custResponse = new CustomResponse(true);
		String             borgId       = userInfoDto.getBorgId();
		String             userNm       = userInfoDto.getUserNm();
		
		saveMap.put("id",              id);
		saveMap.put("board_No",        board_No);
		saveMap.put("board_Type",      board_Type);
		saveMap.put("board_Borg_Type", board_Borg_Type);
		saveMap.put("regi_User_Numb",  regi_User_Numb);
		saveMap.put("title",           title);
		saveMap.put("message",         message);
		saveMap.put("email_Yn",        email_Yn);
		saveMap.put("sms_Yn",          sms_Yn);
		saveMap.put("popup_Start",     popup_Start);
		saveMap.put("popup_End",       popup_End);
		saveMap.put("regi_BorgId",     borgId); 
		saveMap.put("file_list1",      file_list1);
		saveMap.put("file_list2",      file_list2);
		saveMap.put("file_list3",      file_list3);
		saveMap.put("file_list4",      file_list4);
		saveMap.put("workId",          workId); //공사유형ID
		saveMap.put("classify",        classify);//구분
		saveMap.put("standard",        standard);//규격
		saveMap.put("importantYn",     important);
		saveMap.put("emergencyYn",     emergency);
		
		try {
			if("add".equals(oper)) {
				boardSvc.regNotice(saveMap); 
			}
			else if("edit".equals(oper)) {
				saveMap.put("modi_User_Numb", userNm);
				
				boardSvc.modNotice(saveMap);
			}
			else if("del".equals(oper)) {
				saveMap.clear();
				saveMap.put("id", id);
				
				boardSvc.delNotice(saveMap);
			}
		} catch(Exception e) {
			logger.error(CommonUtils.getExceptionStackTrace(e));
			
			custResponse.setSuccess(false);
			custResponse.setMessage("System Excute Error!....");
			custResponse.setMessage(CommonUtils.getErrSubString(e,50));	//Option(To Detail Message)
		}
		
		modelAndView = new ModelAndView("jsonView");
		
		modelAndView.addObject(custResponse);
		
		return modelAndView;
	}
	/*--------------------------------------------------공지사항 끝----------------------------------------------------------*/
	
	/*--------------------------------------------------게시판 시작----------------------------------------------------------*/
	/**
	 * 게시판 페이지로 이동하는 메소드
	 */
	@RequestMapping("freeList.sys")
	public ModelAndView getFreeList(
			@RequestParam(value = "board_Type", defaultValue = "") String board_Type,
			HttpServletRequest req, ModelAndView mav) throws Exception{
		mav.setViewName("board/community/freeList");
		mav.addObject("board_Type","0201");
		return mav;
	}
	/*--------------------------------------------------게시판 끝----------------------------------------------------------*/
	
	/*--------------------------------------------------자재관련문의 시작----------------------------------------------------------*/
	/**
	 * 자재관련문의 페이지로 이동하는 메소드
	 */
	@RequestMapping("materialsInquiryList.sys")
	public ModelAndView getMaterialsInquiryList(
			@RequestParam(value = "board_Type", defaultValue = "") String board_Type,
			HttpServletRequest req, ModelAndView mav) throws Exception{
		mav.setViewName("board/community/materialsInquiryList");
		mav.addObject("board_Type","0202");
		return mav;
	}
	/*--------------------------------------------------자재관련문의 끝----------------------------------------------------------*/
	
	/*--------------------------------------------------자료실 시작----------------------------------------------------------*/
	/**
	 * 자료실 페이지로 이동하는 메소드
	 */
	@RequestMapping("bbsList.sys")
	public ModelAndView getBbsList(
			@RequestParam(value = "board_Type", defaultValue = "") String board_Type,
			HttpServletRequest req, ModelAndView mav) throws Exception{
		mav.setViewName("board/community/bbsList");
		mav.addObject("board_Type","0103");
		return mav;
	}
	/*--------------------------------------------------자료실 끝----------------------------------------------------------*/
	
	/*--------------------------------------------------게시판,자재관련문의,자료실 시작----------------------------------------------------------*/
	/**
	 * 커뮤니티 - 게시판 등록,수정,상세
	 */
	@RequestMapping("boardDetailWrite.sys")
	public ModelAndView freeDetailWrite(
			@RequestParam(value = "moveFlag", required = true) String moveFlag,
			@RequestParam(value = "board_Type", required = true) String board_Type,
			@RequestParam(value = "board_No", defaultValue = "") String board_No,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		/*----------------조회조건 세팅------------*/
		Map<String, Object> searchMap = new HashMap<String, Object>();
		searchMap.put("board_No", board_No);
		BoardDto detailInfo = null;
		if(!"".equals(board_No)) {
			detailInfo = this.boardSvc.getNoticeDetailInfo(searchMap);
		}
		if("W".equals(moveFlag)) {
			modelAndView.setViewName("board/community/boardWrite");	//등록, 수정
		} else if("D".equals(moveFlag)) {
			modelAndView.setViewName("board/community/boardDetail");	//상세
		}
		String boardTitle = "";
		if("0201".equals(board_Type)) boardTitle = "게시판";
		else if("0202".equals(board_Type)) boardTitle = "자재관련문의";
		else if("0103".equals(board_Type)) boardTitle = "자료실";
		modelAndView.addObject("boardTitle", boardTitle);
		modelAndView.addObject("detailInfo", detailInfo);
		return modelAndView;
	}
	
	/**
	 * 자료실, 자유게시판, 자재관련문의 등록, 수정, 삭제 메소드
	 */
	@RequestMapping("boardTransGrid.sys")
	public ModelAndView boardTransGrid(
			@RequestParam(value = "oper", required = true) String oper,
			@RequestParam(value = "id", defaultValue = "") String id,
			@RequestParam(value = "board_No", defaultValue = "") String board_No,
			@RequestParam(value = "board_Type", defaultValue = "") String board_Type,
			@RequestParam(value = "title", defaultValue = "") String title,
			@RequestParam(value = "regi_User_Numb", defaultValue = "") String regi_User_Numb,
			@RequestParam(value = "message", defaultValue = "") String message,
			@RequestParam(value = "regi_BorgId", defaultValue = "") String regi_BorgId,
			@RequestParam(value = "file_list1", defaultValue = "") String file_list1,
			@RequestParam(value = "file_list2", defaultValue = "") String file_list2,
			@RequestParam(value = "file_list3", defaultValue = "") String file_list3,
			@RequestParam(value = "file_list4", defaultValue = "") String file_list4,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
			LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		/*----------------저장값 세팅----------*/
		Map<String,Object> saveMap = new HashMap<String,Object>();
		saveMap.put("id", id);
		saveMap.put("board_No", board_No);
		saveMap.put("board_Type", board_Type);
		saveMap.put("regi_User_Numb", regi_User_Numb);
		saveMap.put("title", title);
		saveMap.put("message", message);
		saveMap.put("regi_BorgId", userInfoDto.getBorgId());
		saveMap.put("file_list1", file_list1);
		saveMap.put("file_list2", file_list2);
		saveMap.put("file_list3", file_list3);
		saveMap.put("file_list4", file_list4);
		
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		try {
			if("add".equals(oper)) {
				boardSvc.regNotice(saveMap);
			} else if("edit".equals(oper)) {
				saveMap.put("modi_User_Numb", userInfoDto.getUserNm());
				boardSvc.modNotice(saveMap);
			} else if("del".equals(oper)) {
				saveMap.clear();
				saveMap.put("id", id);
				//본인만 글을 삭제 할 수 있도록 수정
				if("0103".equals(board_Type)){
					if( regi_User_Numb.equals(userInfoDto.getUserNm())){
						boardSvc.delNotice(saveMap);
					}
					else{
						custResponse.setSuccess(false);
						custResponse.setMessage("본인글만 삭제하실 수 있습니다.");
					}
				}
				else{
					boardSvc.delNotice(saveMap);
				}
			}
		} catch(Exception e) {
			logger.error("Exception : "+e);
			custResponse.setSuccess(false);
			custResponse.setMessage("System Excute Error!....");
			custResponse.setMessage(CommonUtils.getErrSubString(e,50));	//Option(To Detail Message)
		}
		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject(custResponse);
		return modelAndView;
	}
	
	/**
	 * VOC게시판 삭제 메소드
	 */
	@RequestMapping("vocTransGrid.sys")
	public ModelAndView vocTransGrid(
			@RequestParam(value = "oper", required = true) String oper,
			@RequestParam(value = "id", defaultValue = "") String id,
			@RequestParam(value = "voc_No", defaultValue = "") String voc_No,
			@RequestParam(value = "rece_Type", defaultValue = "") String rece_Type,
			@RequestParam(value = "title", defaultValue = "") String title,
			@RequestParam(value = "regi_User_Numb", defaultValue = "") String regi_User_Numb,
			@RequestParam(value = "message", defaultValue = "") String message,
			@RequestParam(value = "regi_BorgId", defaultValue = "") String regi_BorgId,
			@RequestParam(value = "file_list1", defaultValue = "") String file_list1,
			@RequestParam(value = "file_list2", defaultValue = "") String file_list2,
			@RequestParam(value = "file_list3", defaultValue = "") String file_list3,
			@RequestParam(value = "file_list4", defaultValue = "") String file_list4,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
			LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		/*----------------저장값 세팅----------*/
		Map<String,Object> saveMap = new HashMap<String,Object>();
		saveMap.put("id", id);
		saveMap.put("voc_No", voc_No);
		saveMap.put("rece_Type", rece_Type);
		saveMap.put("regi_User_Numb", regi_User_Numb);
		saveMap.put("title", title);
		saveMap.put("message", message);
		saveMap.put("regi_BorgId", userInfoDto.getBorgId());
		saveMap.put("file_list1", file_list1);
		saveMap.put("file_list2", file_list2);
		saveMap.put("file_list3", file_list3);
		saveMap.put("file_list4", file_list4);
		
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		try {
			if("del".equals(oper)) {
				saveMap.clear();
				saveMap.put("id", id);
				//본인만 글을 삭제 할 수 있도록 수정
				if("ADM".equals(rece_Type)){
					if( id.equals(userInfoDto.getUserNm())){
						boardSvc.delVoc(saveMap);
					}
					else{
						custResponse.setSuccess(false);
						custResponse.setMessage("본인글만 삭제하실 수 있습니다.");
					}
				}
				else{
					boardSvc.delVoc(saveMap);
				}
			}
		} catch(Exception e) {
			logger.error("Exception : "+e);
			custResponse.setSuccess(false);
			custResponse.setMessage("System Excute Error!....");
			custResponse.setMessage(CommonUtils.getErrSubString(e,50));	//Option(To Detail Message)
		}
		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject(custResponse);
		return modelAndView;
	}
	
	/**
	 * 자료실, 자유게시판, 자재관련문의 답변페이지로 이동하는 메소드
	 */
	@RequestMapping("boardReply.sys")
	public ModelAndView boardReply(
			@RequestParam(value = "board_Type", required = true) String board_Type,
			@RequestParam(value = "board_No", defaultValue = "") String board_No,
			@RequestParam(value = "group_No", defaultValue = "") String group_No,
			@RequestParam(value = "parent_Board_No", defaultValue = "") String parent_Board_No,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> searchMap = new HashMap<String, Object>();
		searchMap.put("board_No", board_No);
		searchMap.put("group_No", group_No);
		searchMap.put("parent_Board_No", parent_Board_No);
		BoardDto detailInfo = this.boardSvc.getNoticeDetailInfo(searchMap);
		modelAndView.setViewName("board/community/boardReply");
		String boardTitle = "";
		if("0201".equals(board_Type)) boardTitle = "게시판 답변";
		else if("0202".equals(board_Type)) boardTitle = "자재관련문의 답변";
		modelAndView.addObject("boardTitle", boardTitle);
		modelAndView.addObject("detailInfo", detailInfo);
		return modelAndView;
	}
	
	/**
	 * 게시판 답변 등록, 수정, 삭제처리하는 메소드
	 */
	@RequestMapping("boardReplyTransGrid.sys")
	public ModelAndView boardReplyTransGrid(
			@RequestParam(value = "oper", required = true) String oper,
			@RequestParam(value = "id", defaultValue = "") String id,
			@RequestParam(value = "board_No", defaultValue = "") String board_No,
			@RequestParam(value = "board_Type", defaultValue = "") String board_Type,
			@RequestParam(value = "title", defaultValue = "") String title,
			@RequestParam(value = "regi_User_Numb", defaultValue = "") String regi_User_Numb,
			@RequestParam(value = "message", defaultValue = "") String message,
			@RequestParam(value = "regi_BorgId", defaultValue = "") String regi_BorgId,
			@RequestParam(value = "group_No", defaultValue = "") String group_No,
			@RequestParam(value = "parent_Board_No", defaultValue = "") String parent_Board_No,
			@RequestParam(value = "file_list1", defaultValue = "") String file_list1,
			@RequestParam(value = "file_list2", defaultValue = "") String file_list2,
			@RequestParam(value = "file_list3", defaultValue = "") String file_list3,
			@RequestParam(value = "file_list4", defaultValue = "") String file_list4,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
			LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		
		/*----------------저장값 세팅----------*/
		Map<String,Object> saveMap = new HashMap<String,Object>();
		saveMap.put("id", id);
		saveMap.put("board_No", board_No);
		saveMap.put("board_Type", board_Type);
		saveMap.put("regi_User_Numb", regi_User_Numb);
		saveMap.put("title", title);
		saveMap.put("message", message);
		saveMap.put("regi_BorgId", userInfoDto.getBorgId());
		saveMap.put("group_No", group_No);
		saveMap.put("parent_Board_No", parent_Board_No);
		saveMap.put("file_list1", file_list1);
		saveMap.put("file_list2", file_list2);
		saveMap.put("file_list3", file_list3);
		saveMap.put("file_list4", file_list4);
		
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		try {
			if("add".equals(oper)) {
				boardSvc.regBoardReply(saveMap);
			} else if("edit".equals(oper)) {
				saveMap.put("modi_User_Numb", userInfoDto.getUserNm());
				boardSvc.modNotice(saveMap);
			} else if("del".equals(oper)) {
				saveMap.clear();
				saveMap.put("id", id);
				boardSvc.delNotice(saveMap);
			}
		} catch(Exception e) {
			logger.error("Exception : "+e);
			custResponse.setSuccess(false);
			custResponse.setMessage("System Excute Error!....");
			custResponse.setMessage(CommonUtils.getErrSubString(e,50));	//Option(To Detail Message)
		}
		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject(custResponse);
		return modelAndView;
	}
	/*--------------------------------------------------게시판,자재관련문의,자료실 끝----------------------------------------------------------*/
	
	/**
	 * 자료실, 자유게시판, 자재관련문의 DB조회후 리턴시켜주는 메소드
	 */
	@RequestMapping("boardListJQGrid.sys")
	public ModelAndView boardListJQGrid(
			@RequestParam(value = "page",              defaultValue = "1")        String page,
			@RequestParam(value = "rows",              defaultValue = "30")       String rows,
			@RequestParam(value = "sidx",              defaultValue = "board_No") String sidx,
			@RequestParam(value = "sord",              defaultValue = "desc")     String sord,
			@RequestParam(value = "srcTitle",          defaultValue = "")         String srcTitle,
			@RequestParam(value = "srcMessage",        defaultValue = "")         String srcMessage,
			@RequestParam(value = "srcRegi_User_Numb", defaultValue = "")         String srcRegi_User_Numb,
			@RequestParam(value = "board_Type",        defaultValue = "")         String board_Type,
			@RequestParam(value = "classify",          defaultValue = "")         String classify,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		ModelMap            params       = new ModelMap();
		Map<String, Object> svcResult    = null;
		String              orderString  = null;
		StringBuffer        stringBuffer = new StringBuffer();
		List<?>             list         = null;
		Integer             total        = null;
		Integer             records      = null;
		
		stringBuffer.append(" ").append(sidx).append(" ").append(sord).append(" ");
		
		orderString = stringBuffer.toString();
		
		params.put("srcTitle",          srcTitle);
		params.put("srcMessage",        srcMessage);
		params.put("srcRegi_User_Numb", srcRegi_User_Numb);
		params.put("board_Type",        board_Type);
		params.put("classify",          classify);
		params.put("page",              page);
		params.put("rows",              rows);
		params.put("orderString",       orderString);
		
		svcResult = this.commonSvc.getJqGridList("board.selectBoardListCnt", "board.selectBoardList", params); // 리스트 조회
		list      = (List<?>)svcResult.get("list");
		total     = (Integer)svcResult.get("pageMax");
		records   = (Integer)svcResult.get("record");
        
		modelAndView.setViewName("jsonView");
		modelAndView.addObject("page",       page);
		modelAndView.addObject("total",      total);
		modelAndView.addObject("records",    records);
		modelAndView.addObject("list",       list);
		modelAndView.addObject("board_Type", board_Type);
		
		return modelAndView;
	}
	
	/**
	 * 자료실, 자유게시판, 자재관련문의 등록 페이지로 이동하는 메소드
	 */
	@RequestMapping("boardWrite.sys")
	public ModelAndView boardWrite(
			@RequestParam(value = "board_No", defaultValue = "") String board_No,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		Map<String, Object> searchMap = new HashMap<String, Object>();
		BoardDto detailInfo = null;
		
		searchMap.put("board_No", board_No);
		
		if("".equals(board_No) == false) {
			detailInfo = this.boardSvc.getNoticeDetailInfo(searchMap);
		}
		
		modelAndView.setViewName("board/community/boardWrite");
		modelAndView.addObject("detailInfo", detailInfo);
		
		return modelAndView;
	}

	
	@RequestMapping("attachDelete.sys")
	public ModelAndView attachDelete(
			@RequestParam(value = "board_no", required = true) String board_no,
			@RequestParam(value = "file_list", required = true) String file_list,
			@RequestParam(value = "columnName", required = true) String columnName,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
	
		/*----------------저장값 세팅----------*/
		Map<String,Object> saveMap = new HashMap<String,Object>();
		saveMap.put("board_no", board_no);
		if("file_list1".equals(columnName)) { saveMap.put("file_list1", file_list); } 
		else if("file_list2".equals(columnName)) { saveMap.put("file_list2", file_list); } 
		else if("file_list3".equals(columnName)) { saveMap.put("file_list3", file_list); } 
		else if("file_list4".equals(columnName)) { saveMap.put("file_list4", file_list); }
		
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		try {
			boardSvc.delBoardAttachFile(saveMap);
		} catch(Exception e) {
			logger.error("Exception : "+e);
			custResponse.setSuccess(false);
			custResponse.setMessage("System Excute Error!....");
			custResponse.setMessage(CommonUtils.getErrSubString(e,50));	//Option(To Detail Message)
		}
		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject(custResponse);
		return modelAndView;
	}
	
	@RequestMapping("participationReg.sys")
	public ModelAndView participationReg(
			@RequestParam(value="participationNo", defaultValue="") String participationNo,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("participationNo", participationNo);
		Map<String, Object> participationBoardDetail = boardSvc.getParticipationBoardDetail(params);
		modelAndView.addObject("participationBoardDetail", participationBoardDetail);
		modelAndView.setViewName("board/participation/participationReg");
		return modelAndView;
	}
	
	//참여게시판 상세 페이지 이동
	@RequestMapping("participationDetail.sys")
	public ModelAndView participationDetail(
			@RequestParam(value = "participationNo", required = true) String participationNo,
			@RequestParam(value = "businessNum", defaultValue= "") String businessNum,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("participationNo", participationNo);
		params.put("businessNum", businessNum);
		boardSvc.updateParticipationHitCnt(params);
		List<Map<String, Object>> list = boardSvc.getParticipationCommentList(params);
		modelAndView.setViewName("board/participation/participationDetail");
		modelAndView.addObject("list", list);
		return modelAndView;
	}
	
	//
	@RequestMapping("deleteParticipation.sys")
	public ModelAndView deleteParticipation(
			@RequestParam(value = "participationNo", required = true) String participationNo,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		CustomResponse custResponse = new CustomResponse(true);
		Map<String, Object> saveMap = new HashMap<String, Object>();
		saveMap.put("participationNo", participationNo);
		try{
			int cnt = boardSvc.deleteParticipation(saveMap);
			if(cnt == 0){
				custResponse.setSuccess(false);
				custResponse.setMessage("해당 글의 답글이 있으므로 삭제할 수 없습니다.");
			}
		}catch(Exception e){
			logger.error("Exception : "+e);
			custResponse.setSuccess(false);
			custResponse.setMessage("System Excute Error!....");
			custResponse.setMessage(CommonUtils.getErrSubString(e,50));	//Option(To Detail Message)
		}

		modelAndView.addObject(custResponse);
		modelAndView.setViewName("jsonView");
		return modelAndView;
	}
	
	/*-------------------------------------------------- FAQ ----------------------------------------------------------*/
	
	/**
	 * FAQ 관리 등록 팝업
	 */
	@RequestMapping("faqRegPop.sys")
	public ModelAndView RegReg(HttpServletRequest request, ModelMap paramMap, ModelAndView modelAndView) throws Exception {
		if (paramMap.get("faq_seq") != null) {
			modelAndView.addObject("faq", generalDao.selectGernalObject("board.selectFapList", paramMap));
		}
		modelAndView.setViewName("board/faq/faqRegPop");
		return modelAndView;
	}
	

	/*-------------------------------------------------- /FAQ----------------------------------------------------------*/
	/*-------------------------------------------------- 유지보수 ----------------------------------------------------------*/
	

	
	/*-------------------------------------------------- /유지보수 ----------------------------------------------------------*/
	
	
}
