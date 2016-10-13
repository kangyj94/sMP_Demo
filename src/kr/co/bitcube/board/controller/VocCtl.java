package kr.co.bitcube.board.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import kr.co.bitcube.board.dto.ImproDto;
import kr.co.bitcube.board.dto.VocDto;
import kr.co.bitcube.board.service.VocSvc;
import kr.co.bitcube.common.dto.CodesDto;
import kr.co.bitcube.common.dto.LoginUserDto;
import kr.co.bitcube.common.service.CommonSvc;
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
@RequestMapping("voc")
public class VocCtl {

	private Logger logger = Logger.getLogger(getClass());
	
	@Autowired
	private VocSvc vocSvc;
	
	@Autowired
	private CommonSvc commonSvc;
	
	/** 고객의 소리 등록 팝업 */
	@RequestMapping("vocWrite.sys")
	public ModelAndView vocWrite(HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		List<CodesDto> vocReceType = this.commonSvc.getCodeList("VOC_RECE_TYPE", 1);
		
		modelAndView.addObject("VOC_RECE_TYPE", vocReceType);
		modelAndView.setViewName("board/community/vocWrite");	
		
		return modelAndView;
	}
	
	/** 고객의 소리 등록 */
	@RequestMapping("regVoc.sys")
	public ModelAndView regVoc(
			@RequestParam(value = "title",      defaultValue = "0") String title,
			@RequestParam(value = "message",    defaultValue = "")  String message,
			@RequestParam(value = "email",      defaultValue = "")  String email,
			@RequestParam(value = "tel",        defaultValue = "")  String tel,
			@RequestParam(value = "file_list1", defaultValue = "")  String fileList1,
			@RequestParam(value = "file_list2", defaultValue = "")  String fileList2,
			@RequestParam(value = "file_list3", defaultValue = "")  String fileList3,
			@RequestParam(value = "file_list4", defaultValue = "")  String fileList4,
			ModelAndView modelAndView, HttpServletRequest request, HttpServletResponse response) throws Exception {
		LoginUserDto       loginUserDto = CommonUtils.getLoginUserDto(request);
		Map<String,Object> saveMap      = new HashMap<String,Object>();
		CustomResponse     custResponse = new CustomResponse(true);
		String             userId       = loginUserDto.getUserId();
		String             userNm       = loginUserDto.getUserNm();
		String             svcTypeCd    = loginUserDto.getSvcTypeCd();
		String             borgNm       = loginUserDto.getBorgNm();
		
		saveMap.put("title",          title);
		saveMap.put("message",        message);
		saveMap.put("email",          email);
		saveMap.put("tel",            tel);
		saveMap.put("file_list1",     fileList1);
		saveMap.put("file_list2",     fileList2);
		saveMap.put("file_list3",     fileList3);
		saveMap.put("file_list4",     fileList4);
		saveMap.put("regi_user_id",   userId);
		saveMap.put("regi_user_name", userNm);
		saveMap.put("svcTypeCd",      svcTypeCd);
		saveMap.put("borgNm",         borgNm);
		
		try {
			this.vocSvc.insertVocInfo(saveMap);
		}
		catch(Exception e) {
			this.logger.error(CommonUtils.getExceptionStackTrace(e));
			
			custResponse.setSuccess(false);
			custResponse.setMessage("System Excute Error!....");
			custResponse.setMessage(CommonUtils.getErrSubString(e,50));	//Option(To Detail Message)
		}
		
		modelAndView.setViewName("jsonView");
		modelAndView.addObject(custResponse);
		
		return modelAndView;
	}
	
	
	
	/** * 고객의 소리 리스트 (운영자) */
	@RequestMapping("vocListJQGrid.sys")
	public ModelAndView vocListJQGrid(
			@RequestParam(value = "page", defaultValue = "1") int page,
			@RequestParam(value = "rows", defaultValue = "30") int rows,
			@RequestParam(value = "sidx", defaultValue = "voc_No") String sidx,
			@RequestParam(value = "sord", defaultValue = "desc") String sord,
			@RequestParam(value = "srcWriter", defaultValue = "") String srcWriter,
			@RequestParam(value = "srcUserWriter", defaultValue = "") String srcUserWriter,
			@RequestParam(value = "sTat_Flag_Code", defaultValue = "") String sTat_Flag_Code,
			@RequestParam(value = "srcFromDt", defaultValue = "") String srcFromDt,
			@RequestParam(value = "srcEndDt", defaultValue = "") String srcEndDt,
			@RequestParam(value = "rece_type", defaultValue = "") String rece_type,
			
//			@RequestParam(value = "srcTitle", defaultValue = "") String srcTitle,
//			@RequestParam(value = "srcMessage", defaultValue = "") String srcMessage,
//			@RequestParam(value = "srcRegi_User_Numb", defaultValue = "") String srcRegi_User_Numb,
//			@RequestParam(value = "board_Type", defaultValue = "0102") String board_Type,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("srcWriter", srcWriter);
		params.put("srcUserWriter", srcUserWriter);
		params.put("sTat_Flag_Code", sTat_Flag_Code);
		params.put("srcFromDt", srcFromDt);
		params.put("srcEndDt", srcEndDt);
		params.put("rece_type", rece_type);
		
//		params.put("srcTitle", srcTitle);
//		params.put("srcMessage", srcMessage);
//		params.put("srcRegi_User_Numb", srcRegi_User_Numb);
//		params.put("board_Type", board_Type);
		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
		
		/*----------------페이징 세팅------------*/
        int records = vocSvc.getVocListCnt(params); //조회조건에 따른 카운트
        int total = (int)Math.ceil((float)records / (float)rows);
		
        /*----------------조회------------*/
        List<VocDto> list = null;
        if(records>0) list = vocSvc.getVocList(params, page, rows);

		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("page", page);
		modelAndView.addObject("total", total);
		modelAndView.addObject("records", records);
		modelAndView.addObject("list", list);
		modelAndView.addObject("rece_type", rece_type);
		return modelAndView;
	}
	
	@RequestMapping("vocDetail.sys")
	public ModelAndView freeDetailWrite(
			@RequestParam(value = "voc_No", defaultValue = "") String voc_No,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		/*----------------조회조건 세팅------------*/
		
		Map<String, Object> searchMap = new HashMap<String, Object>();
		searchMap.put("voc_No", voc_No);
		VocDto detailInfo = this.vocSvc.getSelectVocDetail(searchMap,loginUserDto);
		modelAndView.setViewName("board/community/vocDetail");
		modelAndView.addObject("detailInfo", detailInfo);
		
		return modelAndView;
	}
}
