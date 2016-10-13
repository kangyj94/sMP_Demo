package kr.co.bitcube.board.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import kr.co.bitcube.board.dto.BoardDto;
import kr.co.bitcube.board.service.BoardSvc;
import kr.co.bitcube.common.dto.LoginUserDto;
import kr.co.bitcube.common.utils.CommonUtils;
import kr.co.bitcube.common.utils.Constances;
import kr.co.bitcube.common.utils.CustomResponse;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

@Controller
@RequestMapping("board")
public class FleaMarketCtl {

	private Logger logger = Logger.getLogger(getClass());
	
	@Autowired
	private BoardSvc boardSvc;
	
	/**
	 * 벼룩시장 [판매] 페이지로 이동하는 메소드
	 */
	@RequestMapping("fleaMarketSaleList.sys")
	public ModelAndView getfleaMarketSaleList(
			@RequestParam(value = "board_Type", defaultValue = "") String board_Type,
			HttpServletRequest req, ModelAndView mav) throws Exception{
			mav.setViewName("board/fleaMarket/fleaMarketList");
		mav.addObject("board_Type","0203");
		return mav;
	}
	
	/**
	 * 벼룩시장 [구매] 페이지로 이동하는 메소드
	 */
	@RequestMapping("fleaMarketBuyList.sys")
	public ModelAndView getFleaMarketBuyList(
			@RequestParam(value = "board_Type", defaultValue = "") String board_Type,
			HttpServletRequest req, ModelAndView mav) throws Exception{
		mav.setViewName("board/fleaMarket/fleaMarketList");
		mav.addObject("board_Type","0204");
		return mav;
	}
	
	/**
	 * 벼룩시장 DB조회후 리턴시켜주는 메소드
	 */
	@RequestMapping("fleaMarketListJQGrid.sys")
	public ModelAndView fleaMarketListJQGrid(
			@RequestParam(value = "page", defaultValue = "1") int page,
			@RequestParam(value = "rows", defaultValue = "30") int rows,
			@RequestParam(value = "sidx", defaultValue = "board_No") String sidx,
			@RequestParam(value = "sord", defaultValue = "desc") String sord,
			@RequestParam(value = "srcTitle", defaultValue = "") String srcTitle,
			@RequestParam(value = "srcMessage", defaultValue = "") String srcMessage,
			@RequestParam(value = "srcRegi_User_Numb", defaultValue = "") String srcRegi_User_Numb,
			@RequestParam(value = "board_Type", defaultValue = "") String board_Type,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("srcTitle", srcTitle);
		params.put("srcMessage", srcMessage);
		params.put("srcRegi_User_Numb", srcRegi_User_Numb);
		params.put("board_Type", board_Type);
		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
		
		/*----------------페이징 세팅------------*/
        //int records = boardSvc.getMarketListCnt(params); //조회조건에 따른 카운트
		int records = boardSvc.getBoardListCnt(params);
        int total = (int)Math.ceil((float)records / (float)rows);
		
        /*----------------조회------------*/
        List<BoardDto> list = null;
        //if(records>0) list = boardSvc.getMarketList(params, page, rows);
        if(records>0) list = boardSvc.getBoardList(params, page, rows);

		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("page", page);
		modelAndView.addObject("total", total);
		modelAndView.addObject("records", records);
		modelAndView.addObject("list", list);
		modelAndView.addObject("board_Type", board_Type);
		return modelAndView;
	}
	
	/**
	 * 벼룩시장 상세 페이지를 조회하여 반환하는 메소드
	 */
	@RequestMapping("fleaMarketDetail.sys")
	public ModelAndView fleaMarketDetail(
			@RequestParam(value = "board_No", required = true) String board_No,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> searchMap = new HashMap<String, Object>();
		searchMap.put("board_No", board_No);
		BoardDto detailInfo = this.boardSvc.getNoticeDetailInfo(searchMap);
		modelAndView.setViewName("board/fleaMarket/fleaMarketDetail");
		modelAndView.addObject("detailInfo", detailInfo);
		return modelAndView;
	}
	
	/**
	 * 벼룩시장 등록 페이지로 이동하는 메소드
	 */
	@RequestMapping("fleaMarketWrite.sys")
	public ModelAndView fleaMarketWrite(
			@RequestParam(value = "board_No", defaultValue = "") String board_No,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> searchMap = new HashMap<String, Object>();
		searchMap.put("board_No", board_No);
		BoardDto detailInfo = null;
		if(!"".equals(board_No)) {
			detailInfo = this.boardSvc.getNoticeDetailInfo(searchMap);
		}
		modelAndView.setViewName("board/fleaMarket/fleaMarketWrite");
		modelAndView.addObject("detailInfo", detailInfo);
		return modelAndView;
	}
	
	/**
	 * 벼룩시장 등록, 수정, 삭제 메소드
	 */
	@RequestMapping("fleaMarketTransGrid.sys")
	public ModelAndView fleaMarketTransGrid(
			@RequestParam(value = "oper", required = true) String oper,
			@RequestParam(value = "id", defaultValue = "") String id,
			@RequestParam(value = "board_No", defaultValue = "") String board_No,
			@RequestParam(value = "board_Type", defaultValue = "0203") String board_Type,
			@RequestParam(value = "title", defaultValue = "") String title,
			@RequestParam(value = "regi_User_Numb", defaultValue = "") String regi_User_Numb,
			@RequestParam(value = "message", defaultValue = "") String message,
			@RequestParam(value = "regi_BorgId", defaultValue = "") String regi_BorgId,
			@RequestParam(value = "req_Sale_Amout", defaultValue = "") String req_Sale_Amout,
			@RequestParam(value = "tran_Vehi_Proc", defaultValue = "") String tran_Vehi_Proc,
			@RequestParam(value = "user_Phon_Numb", defaultValue = "") String user_Phon_Numb,
			@RequestParam(value = "user_Mail_Addr", defaultValue = "") String user_Mail_Addr,
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
		saveMap.put("title", title);
		saveMap.put("regi_User_Numb", regi_User_Numb);
		saveMap.put("message", message);
		saveMap.put("regi_BorgId", userInfoDto.getBorgId());
		saveMap.put("req_Sale_Amout", req_Sale_Amout);
		saveMap.put("tran_Vehi_Proc", tran_Vehi_Proc);
		saveMap.put("user_Phon_Numb", user_Phon_Numb);
		saveMap.put("user_Mail_Addr", user_Mail_Addr);
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
	
	/**
	 * 벼룩시장 답변페이지로 이동하는 메소드
	 */
	@RequestMapping("fleaMarketReply.sys")
	public ModelAndView fleaMarketReply(
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
		modelAndView.setViewName("board/fleaMarket/fleaMarketReply");
		modelAndView.addObject("detailInfo", detailInfo);
		return modelAndView;
	}
	
	/**
	 * 벼룩시장 답변 등록, 수정, 삭제처리하는 메소드
	 */
	@RequestMapping("fleaMarketReplyTransGrid.sys")
	public ModelAndView fleaMarketReplyTransGrid(
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
			@RequestParam(value = "req_Sale_Amout", defaultValue = "") String req_Sale_Amout,
			@RequestParam(value = "tran_Vehi_Proc", defaultValue = "") String tran_Vehi_Proc,
			@RequestParam(value = "user_Phon_Numb", defaultValue = "") String user_Phon_Numb,
			@RequestParam(value = "user_Mail_Addr", defaultValue = "") String user_Mail_Addr,
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
		saveMap.put("req_Sale_Amout", req_Sale_Amout);
		saveMap.put("tran_Vehi_Proc", tran_Vehi_Proc);
		saveMap.put("user_Phon_Numb", user_Phon_Numb);
		saveMap.put("user_Mail_Addr", user_Mail_Addr);
		saveMap.put("file_list1", file_list1);
		saveMap.put("file_list2", file_list2);
		saveMap.put("file_list3", file_list3);
		saveMap.put("file_list4", file_list4);
		
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		try {
			if("add".equals(oper)) {
				boardSvc.regBoardReply(saveMap);
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
}
