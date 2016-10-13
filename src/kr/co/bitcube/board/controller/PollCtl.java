package kr.co.bitcube.board.controller;


import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.servlet.ModelAndView;

import kr.co.bitcube.common.dao.GeneralDao;
import kr.co.bitcube.common.dto.LoginUserDto;
import kr.co.bitcube.common.service.CommonSvc;
import kr.co.bitcube.common.utils.Constances;

@Controller
@RequestMapping("board/poll")
public class PollCtl {
	
	private Logger logger = Logger.getLogger(getClass());

	@Autowired
	private GeneralDao generalDao;
	@Autowired
	private CommonSvc commonSvc;
	
	@Autowired
	private WebApplicationContext context;
	
	/**
	 * 설문조사 팝업
	 */
	@RequestMapping("popup.sys")
	public ModelAndView popup(HttpServletRequest request, ModelMap paramMap, ModelAndView modelAndView) throws Exception {
		modelAndView.addObject("list", generalDao.selectGernalList("board.selectPollListByUser", paramMap));
		return modelAndView;
	}
	
	/**
	 * 설문조사 팝업2
	 */
	@RequestMapping("{pollId}")
	public ModelAndView popup2(@PathVariable String pollId, HttpServletRequest request, ModelMap paramMap, ModelAndView modelAndView) throws Exception {
		LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		paramMap.put("loginUserDto", loginUserDto);
		paramMap.put("pollId", pollId);
		modelAndView.addObject("poll", generalDao.selectGernalObject("board.selectPollByUser", paramMap));
		modelAndView.setViewName("board/poll/popup2");
		return modelAndView;
	}
	
	/**
	 * 설문조사 등록 팝업
	 */
	@RequestMapping("pollReg.sys")
	public ModelAndView evaluateReg(HttpServletRequest request, ModelMap paramMap, ModelAndView modelAndView) throws Exception {
		if (paramMap.get("pollId") != null) {
			modelAndView.addObject("poll", generalDao.selectGernalObject("board.selectPoll", paramMap));
		}
		modelAndView.setViewName("board/poll/pollReg");
		return modelAndView;
	}
}