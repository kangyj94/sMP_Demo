package kr.co.bitcube.system.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import kr.co.bitcube.common.dao.GeneralDao;
import kr.co.bitcube.common.dto.CodesDto;
import kr.co.bitcube.common.dto.LoginUserDto;
import kr.co.bitcube.common.utils.CommonUtils;
import kr.co.bitcube.common.utils.Constances;
import kr.co.bitcube.common.utils.CustomResponse;
import kr.co.bitcube.system.dto.CodeTypesDto;
import kr.co.bitcube.system.service.CodeSvc;
import kr.co.bitcube.system.service.EtcSvc;

//import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

/**
 * 시스템 > 기타 메뉴 처리 요청을 처리하는 Controller 클래스
 * 
 * @author tytolee
 * @since 2012-07-19
 */
@Controller
@RequestMapping("system")
public class EtcCtl {

//	private Logger logger = Logger.getLogger(getClass());
	
	@Autowired
	private CodeSvc codeSvc;
	
	@Autowired
	private EtcSvc etcSvc;
	
	@Autowired
	private GeneralDao generalDao;
	
	/**
	 * 이미지 리사이즈 페이지로 이동하는 메소드
	 * 
	 * @author tytolee
	 * @param request
	 * @return ModelAndView
	 * @throws Exception
	 * @since 2012-07-19
	 */
	@RequestMapping("imageResizePage.sys")
	public ModelAndView imageResizePage(HttpServletRequest request, HttpServletResponse response) throws Exception {
		List<CodesDto>      imageResizeType = null;
		Map<String, Object> params          = null;
		ModelAndView        modelAndView    = null;
		
		params       = new HashMap<String, Object>();
		modelAndView = new ModelAndView("system/etc/imageResize");
		
		params.put("srcCodeTypeCd", "IMAGERESIZETYPE");
		params.put("orderString",   "A.DISORDER ASC");
		
		imageResizeType = this.codeSvc.getCodeList(params);
		
		modelAndView.addObject("imageResizeType", imageResizeType);
		
		return modelAndView;
	}
	
	/**
	 * 이미지 파일을 리사이즈 하고 그 결과를 리턴하는 메소드
	 * 
	 * @author tytolee
	 * @param imageFile
	 * @param request
	 * @param response
	 * @return ModelAndView
	 * @throws Exception
	 * @since 2012-07-20
	 */
	@RequestMapping("imageResizeProcess.sys")
	public ModelAndView imageResizeProcess(
			@RequestParam(value = "imageFile", required=true) MultipartFile imageFile,
			HttpServletRequest request, HttpServletResponse response) throws Exception {
		ModelAndView        modelAndView   = null;
		ServletContext      servletContext = null;
		Map<String, String> resizeResult   = null;
		String              realPath       = null;
		
		modelAndView = new ModelAndView("jsonView");
		
		servletContext = request.getServletContext();
		realPath       = servletContext.getRealPath(Constances.SYSTEM_IMAGE_PATH);
		resizeResult   = this.etcSvc.imageResizeProcess(imageFile, realPath); // 이미지 리사이즈 하고 그 결과를 반환
		
		modelAndView.addAllObjects(resizeResult);
		
		return modelAndView;
	}
	
	/**
	 * 상세 그리드 페이지로 이동하는 메소드
	 * 
	 * @author taeilyun
	 * @param request
	 * @return ModelAndView
	 * @throws Exception
	 * @since 2012-09-13
	 */
	@RequestMapping("detailListJQGrid.sys")
	public ModelAndView detailListJQGrid(
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		return new ModelAndView("system/etc/codeList4");
	}
	
	/**
	 * 상세 그리드 상세 페이지를 조회하여 반환하는 메소드
	 * 
	 * @author taeilyun
	 * @param request
	 * @return ModelAndView
	 * @throws Exception
	 * @since 2012-09-14
	 */
	@RequestMapping("codeTypesDetailInfo.sys")
	public ModelAndView getCodeTypesDetailInfo(
			@RequestParam(value = "rowid", defaultValue = "") String srcCodeTypeId,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		Map<String, Object> map = this.etcSvc.getCodeTypesDetailInfo(srcCodeTypeId);
		CodeTypesDto detailInfo = (CodeTypesDto) map.get("detailInfo");
		
		modelAndView.setViewName("system/etc/codeTypesDetail");
		modelAndView.addObject("detailInfo", detailInfo);
		return modelAndView;
	}
	
	/**
	 * 즐겨찾기 메뉴 정보를 조회하여 반환하는 메소드
	 * 
	 * @author sun
	 * @param request
	 * @return ModelAndView
	 * @throws Exception
	 * @since 2015-04-13
	 */
	@RequestMapping("getFavoritesMenu.sys")
	public ModelAndView getFavoritesMenuBy(
			HttpServletRequest request, ModelAndView modelAndView, ModelMap params) throws Exception {
		LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		
		params.put("userId", loginUserDto.getUserId() );
		
		List<Object>  list = generalDao.selectGernalList("common.etc.selectSmpFavoritesMenuByUserId", params);
		
		modelAndView.setViewName("jsonView");
		modelAndView.addObject("list", list);
	
		return modelAndView;
	}
	
	/**
	 * 즐겨찾기 메뉴를 저장하는 메소드
	 * 
	 * @author sun
	 * @param request
	 * @return ModelAndView
	 * @throws Exception
	 * @since 2015-04-13
	 */
	@RequestMapping("regfavoritesMenu.sys")
	public ModelAndView regfavoritesMenu(
			@RequestParam(value = "menuId", defaultValue="" ) String menuId,
			HttpServletRequest request, ModelAndView modelAndView, ModelMap params) throws Exception {
		
		LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		CustomResponse custResponse = new CustomResponse(true);
		

		params.put("userId", loginUserDto.getUserId() );
		params.put("menuId", menuId );
		
		try{
			if( menuId.equals("") || menuId.equals("home") ){
				throw new Exception();
			}
			//validation check
			int cnt = generalDao.selectGernalCount("common.etc.selectSmpFavoritesMenuCntByPk", params);
			
			if( cnt == 0 ){ //메뉴 즐겨찾기 등록
				generalDao.insertGernal("common.etc.insertSmpFavoritesMenu", params );
			}else{	//이미 등록된 메뉴
				custResponse.setSuccess(false);
				custResponse.setMessage("이미 즐겨찾기에 등록된 메뉴입니다.");
			}
			
		}catch(Exception e){
			custResponse.setSuccess(false);
			custResponse.setMessage("System Excute Error!....");
			custResponse.setMessage(CommonUtils.getErrSubString(e,50));	//Option(To Detail Message)
		}
		
		modelAndView.setViewName("jsonView");
		modelAndView.addObject(custResponse);
		
		return modelAndView;
		
	}
	
	/**
	 * 즐겨찾기 메뉴를 삭제하는 메소드
	 * 
	 * @author sun
	 * @param request
	 * @return ModelAndView
	 * @throws Exception
	 * @since 2015-04-13
	 */
	@RequestMapping("delfavoritesMenu.sys")
	public ModelAndView delfavoritesMenu(
			@RequestParam(value = "menuId", defaultValue="" ) String menuId,
			HttpServletRequest request, ModelAndView modelAndView, ModelMap params) throws Exception {
		
		LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		CustomResponse custResponse = new CustomResponse(true);
		
		params.put("userId", loginUserDto.getUserId() );
		params.put("menuId", menuId );
		
		try{
			if(  menuId.equals("")  ){
				throw new Exception();
			}
			//validation check
			int cnt = generalDao.selectGernalCount("common.etc.selectSmpFavoritesMenuCntByPk", params);
			
			if( cnt > 0 ){ //메뉴 즐겨찾기 삭제
				generalDao.deleteGernal("common.etc.deleteSmpFavoritesMenu", params );
			}else{	//이미 즐겨찾기에 없는 메뉴
				custResponse.setSuccess(false);
				custResponse.setMessage("즐겨찾기에 이미 등록되지 않은 메뉴입니다.");
			}
			
		}catch(Exception e){
			custResponse.setSuccess(false);
			custResponse.setMessage("System Excute Error!....");
			custResponse.setMessage(CommonUtils.getErrSubString(e,50));	//Option(To Detail Message)
		}
		
		modelAndView.setViewName("jsonView");
		modelAndView.addObject(custResponse);
		
		return modelAndView;
		
	}
}
