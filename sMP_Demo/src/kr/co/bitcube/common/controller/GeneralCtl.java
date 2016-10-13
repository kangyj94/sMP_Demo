package kr.co.bitcube.common.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import kr.co.bitcube.common.dao.GeneralDao;
import kr.co.bitcube.common.dto.LoginUserDto;
import kr.co.bitcube.common.utils.CommonUtils;
import kr.co.bitcube.common.utils.Constances;
import kr.co.bitcube.common.utils.CustomResponse;
import kr.co.bitcube.common.utils.RequestUtils;

import org.apache.commons.beanutils.MethodUtils;
import org.apache.ibatis.session.RowBounds;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.NoSuchBeanDefinitionException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class GeneralCtl {

	private Logger logger = Logger.getLogger(getClass());

	@Autowired
	private GeneralDao generalDao;
	
	@Autowired
	private WebApplicationContext context;
	
	/**
	 * 단순 페이지 이동(메뉴을 클릭했을때 페이지로 이동) : 2 Depth 이동
	 * @param bigId : jsp(대 폴더)
	 * @param smallId : jsp(페이지 명)
	 * @param request
	 * @param modelAndView
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "menu/{bigId}/{smallId}")
	public ModelAndView generalPageMove(
			@PathVariable String bigId,
			@PathVariable String smallId,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		return generalPageMove(bigId, "", smallId, request, modelAndView);
	}
	
	/**
	 * 단순 페이지 이동(메뉴을 클릭했을때 페이지로 이동) : 3 Depth 이동
	 * @param bigId : jsp(대 폴더)
	 * @param middleId : jsp(중 폴더)
	 * @param smallId : jsp(페이지 명)
	 * @param request
	 * @param modelAndView
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "menu/{bigId}/{middleId}/{smallId}")
	public ModelAndView generalPageMove(
			@PathVariable String bigId,
			@PathVariable String middleId,
			@PathVariable String smallId,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		return new ModelAndView(bigId+"/"+middleId+"/"+smallId);
	}
	
	/**
	 * Select Json Object 가져오기 : 1 Depth Map
	 * @param sqlFileNm : map 파일명
	 * @param queryId : map(queryId)
	 * @param objectNm : Object Name(View 에서 받을 Object 명)
	 * @param request
	 * @param paramMap : query parameter 담을 Map
	 * @param modelAndView
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "{sqlFileNm}/{queryId}/{objectNm}/object")
	public ModelAndView general_object(
			@PathVariable String sqlFileNm,
			@PathVariable String queryId,
			@PathVariable String objectNm,
			HttpServletRequest request, ModelAndView modelAndView, ModelMap paramMap) throws Exception {
		return general_object(sqlFileNm, "", queryId, objectNm, request, modelAndView, paramMap);
	}
	
	/**
	 * Select Json Object 가져오기 : 2 Depth Map
	 * @param moduleNm : map(map 폴더)
	 * @param sqlFileNm : map(map 파일명) : ''일 경우 moduleNm 이 파일명
	 * @param queryId : map(queryId)
	 * @param objectNm : Object Name(View 에서 받을 Object 명)
	 * @param request
	 * @param paramMap : query parameter 담을 Map
	 * @param modelAndView
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "{moduleNm}/{sqlFileNm}/{queryId}/{objectNm}/object")
	public ModelAndView general_object(
			@PathVariable String moduleNm,
			@PathVariable String sqlFileNm,
			@PathVariable String queryId,
			@PathVariable String objectNm,
			HttpServletRequest request, ModelAndView modelAndView, ModelMap paramMap) throws Exception {

		LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		paramMap.put("loginUserDto", loginUserDto);
		RequestUtils.bind(request, paramMap);
		queryId = moduleNm+"."+("".equals(sqlFileNm) ? "" :  sqlFileNm+".")+queryId;
		Object object = generalDao.selectGernalObject(queryId, paramMap);
		modelAndView.setViewName("jsonView");
		modelAndView.addObject(objectNm, object);
		return modelAndView;
	}
	
	/**
	 * Grid의 단순 Select Json List 가져오기(rows가 0이면 카운트를 가져오지 않음) : 1 Depth Map
	 * @param sqlFileNm : map 파일명
	 * @param queryId : map(queryId)
	 * @param page : paging number
	 * @param rows : paging row count
	 * @param sidx : query sorting 대상
	 * @param sord : asc/desc
	 * @param request
	 * @param paramMap : query parameter 담을 Map
	 * @param modelAndView
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "{sqlFileNm}/{queryId}/list")
	public ModelAndView general_list(
			@PathVariable String sqlFileNm,
			@PathVariable String queryId,
			@RequestParam(value = "page", defaultValue = "1") int page,
			@RequestParam(value = "rows", defaultValue = "0") int rows,
			@RequestParam(value = "sidx", defaultValue = "") String sidx,
			@RequestParam(value = "sord", defaultValue = "") String sord,
			HttpServletRequest request, ModelAndView modelAndView, ModelMap paramMap) throws Exception {
		
		return general_list(sqlFileNm, "", queryId, page, rows, sidx, sord, request, modelAndView, paramMap);
	}
	
	/**
	 * Grid의 단순 Select Json List 가져오기(rows가 0이면 카운트를 가져오지 않음) : 2 Depth Map
	 * @param moduleNm : map(map 폴더)
	 * @param sqlFileNm : map(map 파일명) : ''일 경우 moduleNm 이 파일명
	 * @param queryId : map(queryId)
	 * @param page : paging number
	 * @param rows : paging row count
	 * @param sidx : query sorting 대상
	 * @param sord : asc/desc
	 * @param request
	 * @param paramMap : query parameter 담을 Map
	 * @param modelAndView
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "{moduleNm}/{sqlFileNm}/{queryId}/list")
	public ModelAndView general_list(
			@PathVariable String moduleNm,
			@PathVariable String sqlFileNm,
			@PathVariable String queryId,
			@RequestParam(value = "page", defaultValue = "1") int page,
			@RequestParam(value = "rows", defaultValue = "0") int rows,
			@RequestParam(value = "sidx", defaultValue = "") String sidx,
			@RequestParam(value = "sord", defaultValue = "") String sord,
			HttpServletRequest request, ModelAndView modelAndView, ModelMap paramMap) throws Exception {
		
		CustomResponse custResponse = new CustomResponse(true); 
		try{	
			LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
			paramMap.put("loginUserDto", loginUserDto);
			RequestUtils.bind(request, paramMap);
			queryId = moduleNm+"."+("".equals(sqlFileNm) ? "" :  sqlFileNm+".")+queryId;
			int offset = (page-1)*rows;
	//		paramMap.put("offset", offset);
	//		paramMap.put("row_count", rows);
			paramMap.put("rowBounds", new RowBounds(offset, rows));
			if(!"".equals(sidx)) {
				String orderString = " " + sidx + " " + sord + " ";
				paramMap.put("orderString", orderString);
			}
	
			int records = 0;
			int total = 0;
			if(rows>0 && rows!=10000) {
				records = generalDao.selectGernalCount(queryId+"_count", paramMap);
				total = (int)Math.ceil((float)records / (float)rows);
			}
			List<Object> list = generalDao.selectGernalList(queryId, paramMap);
			
			modelAndView.addObject("page", page);
			modelAndView.addObject("total", total);
			modelAndView.addObject("records", records);
			modelAndView.addObject("list", list);
		} catch(Exception e) {
			logger.error("Exception : "+e);
			custResponse.setSuccess(false);
			custResponse.setMessage("System Excute Error!....");
			custResponse.setMessage(CommonUtils.getErrSubString(e,50));	//Option(To Detail Message)
		}
		modelAndView.setViewName("jsonView");
		modelAndView.addObject("custResponse",custResponse);
		return modelAndView;
	}

	/**
	 * 단순 Select List 가져와 Excel파일을 만듬 : 1 Depth Map
	 * @param sqlFileNm : map 파일명
	 * @param queryId : map(queryId)
	 * @param sheetTitle : excel sheet name
	 * @param excelFileName : excel file name
	 * @param colLabels : column name array
	 * @param colIds :  column id array
	 * @param numColIds : number type column id array(###,###)
	 * @param figureColIds : number type column id array(######)
	 * @param sidx : sorting column
	 * @param sord : sorting asc/desc
	 * @param request
	 * @param modelAndView
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "{sqlFileNm}/{queryId}/excel")
	public ModelAndView general_excel(
			@PathVariable String sqlFileNm,
			@PathVariable String queryId,
			@RequestParam(value = "sheetTitle", defaultValue = "") String sheetTitle,
			@RequestParam(value = "excelFileName", defaultValue = "") String excelFileName,
			@RequestParam(value = "colLabels", required = false) String[] colLabels,
			@RequestParam(value = "colIds", required = false) String[] colIds,
			@RequestParam(value = "numColIds", required = false) String[] numColIds,
			@RequestParam(value = "figureColIds", required = false) String[] figureColIds,
			@RequestParam(value = "sidx", defaultValue = "") String sidx,
			@RequestParam(value = "sord", defaultValue = "") String sord,
			HttpServletRequest request, ModelAndView modelAndView, ModelMap paramMap) throws Exception {
		
		return general_excel(sqlFileNm, "", queryId, sheetTitle, excelFileName, colLabels, colIds, numColIds, figureColIds, sidx, sord, request, modelAndView, paramMap);
	}
	
	/**
	 * 단순 Select List 가져와 Excel파일을 만듬
	 * @param moduleNm : map(map 폴더 or sqlFileNm 가 ''일 경우 파일명)
	 * @param sqlFileNm : map(map 파일명) : ''일 경우 moduleNm 가 파일명
	 * @param queryId : map(queryId)
	 * @param sheetTitle : excel sheet name
	 * @param excelFileName : excel file name
	 * @param colLabels : column name array
	 * @param colIds :  column id array
	 * @param numColIds : number type column id array(###,###)
	 * @param figureColIds : number type column id array(######)
	 * @param sidx : sorting column
	 * @param sord : sorting asc/desc
	 * @param request
	 * @param modelAndView
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "{moduleNm}/{sqlFileNm}/{queryId}/excel")
	public ModelAndView general_excel(
			@PathVariable String moduleNm,
			@PathVariable String sqlFileNm,
			@PathVariable String queryId,
			@RequestParam(value = "sheetTitle", defaultValue = "") String sheetTitle,
			@RequestParam(value = "excelFileName", defaultValue = "") String excelFileName,
			@RequestParam(value = "colLabels", required = false) String[] colLabels,
			@RequestParam(value = "colIds", required = false) String[] colIds,
			@RequestParam(value = "numColIds", required = false) String[] numColIds,
			@RequestParam(value = "figureColIds", required = false) String[] figureColIds,
			@RequestParam(value = "sidx", defaultValue = "") String sidx,
			@RequestParam(value = "sord", defaultValue = "") String sord,
			HttpServletRequest request, ModelAndView modelAndView, ModelMap paramMap) throws Exception {

		LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		paramMap.put("loginUserDto", loginUserDto);
		paramMap.put("isExcel", 1);	//Query에서 상태값을 Case처리하기 위함
		if(!"".equals(sidx)) {
			String orderString = " " + sidx + " " + sord + " ";
			paramMap.put("orderString", orderString);
		}
		RequestUtils.bind(request, paramMap);
		
		queryId = moduleNm+"."+("".equals(sqlFileNm) ? "" :  sqlFileNm+".")+queryId;
		List<Object> dtoList = generalDao.selectGernalList(queryId, paramMap);
		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		for(Object obj : dtoList) {
			list.add(CommonUtils.ConverObjectToMap(obj));
		}
		
        List<Map<String, Object>> sheetList = new ArrayList<Map<String, Object>>();
        Map<String, Object> map1 = new HashMap<String, Object>();
        map1.put("sheetTitle", sheetTitle);
        map1.put("colLabels", colLabels);
        map1.put("colIds", colIds);
        map1.put("numColIds", numColIds);
        map1.put("figureColIds", figureColIds);
        map1.put("colDataList", list);
        sheetList.add(map1);
        modelAndView.setViewName("commonExcelViewResolver");
        modelAndView.addObject("excelFileName", excelFileName);
        modelAndView.addObject("sheetList", sheetList);
		
//		modelAndView.setViewName("commonExcelViewResolver");
//		modelAndView.addObject("sheetTitle", sheetTitle);
//		modelAndView.addObject("excelFileName", excelFileName);
//		modelAndView.addObject("colLabels", colLabels);
//		modelAndView.addObject("colIds", colIds);
//		modelAndView.addObject("numColIds", numColIds);
//		modelAndView.addObject("figureColIds", figureColIds);
//		modelAndView.addObject("colDataList", list);
		return modelAndView;
	}
	
	/**
	 * Transaction 구문 처리
	 * @param moduleNm : map(map 폴더 or sqlFileNm 가 ''일 경우 파일명), Service(Service명 : moduleNm) -> Service명이 없을 경우 공통모듈 수행 
	 * @param methodQueryId : map(queryId), Service(Service Method명) -> Service Method명이 없을 경우 공통모듈 수행
	 * @param oper : Save Flag(add, edit, del)
	 * @param idGenSvcNm : Id Generation Service Name(Insert Key를 받을 Service명)
	 * @param request
	 * @param modelAndView
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "{moduleNm}/{methodQueryId}/save")
	public ModelAndView general_save(
			@PathVariable String moduleNm,
			@PathVariable String methodQueryId,
			@RequestParam(value = "oper", required = false) String oper,
			@RequestParam(value = "idGenSvcNm", defaultValue = "") String idGenSvcNm,
			HttpServletRequest request, ModelAndView modelAndView, ModelMap paramMap) throws Exception {
		
		return general_save(moduleNm, "", methodQueryId, oper, idGenSvcNm, request, modelAndView, paramMap);
	}
	
	/**
	 * Transaction 구문 처리
	 * @param moduleNm : map(map 폴더 or sqlFileNm 가 ''일 경우 파일명), Service(Service명 : moduleNm) -> Service명이 없을 경우 공통모듈 수행 
	 * @param sqlFileNm : map(map 파일명) : ''일 경우 moduleNm 가 파일명
	 * @param methodQueryId : map(queryId), Service(Service Method명) -> Service Method명이 없을 경우 공통모듈 수행
	 * @param oper : Save Flag(add, edit, del)
	 * @param idGenSvcNm : Id Generation Service Name(Insert Key를 받을 Service명)
	 * @param request
	 * @param modelAndView
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "{moduleNm}/{sqlFileNm}/{methodQueryId}/save")
	public ModelAndView general_save(
			@PathVariable String moduleNm,
			@PathVariable String sqlFileNm,
			@PathVariable String methodQueryId,
			@RequestParam(value = "oper", required = false) String oper,
			@RequestParam(value = "idGenSvcNm", defaultValue = "") String idGenSvcNm,
			HttpServletRequest request, ModelAndView modelAndView, ModelMap paramMap) throws Exception {
		
		LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		paramMap.put("loginUserDto", loginUserDto);
		RequestUtils.bind(request, paramMap);
		String methodNm = methodQueryId;
		String queryId = moduleNm+"."+("".equals(sqlFileNm) ? "" :  sqlFileNm+".")+methodQueryId;
		
		CustomResponse custResponse = new CustomResponse(true);
		try {
			if(!"".equals(idGenSvcNm)) {
				Object object = context.getBean(idGenSvcNm);
				String id = (String) MethodUtils.invokeMethod(object, "getNextStringId",null);
				paramMap.put("id", id);	//id생성
				custResponse.setNewIdx(id);
			}
			if (RequestUtils.invokeService(context, moduleNm, methodNm, paramMap)) {
				if("add".equals(oper)) {
					try {
						generalDao.insertGernal(queryId, paramMap);
					} catch (NoSuchBeanDefinitionException be) {
						logger.error("Exception : "+be);
						custResponse.setSuccess(false);
						custResponse.setMessage("Id Generation Service Name["+idGenSvcNm+"]이 존재하지 않습니다.");
					} catch (Exception e) {
						logger.error("Exception : "+e);
						custResponse.setSuccess(false);
						custResponse.setMessage(CommonUtils.getErrSubString(e,50));
					}
				} else if("edit".equals(oper)) {
					generalDao.updateGernal(queryId, paramMap);
				} else if("del".equals(oper)) {
					generalDao.deleteGernal(queryId, paramMap);
				}
			}
		} catch(Exception e) {
			logger.error("Exception : "+e);
			custResponse.setSuccess(false);
			custResponse.setMessage("System Excute Error!....");
			custResponse.setMessage(CommonUtils.getErrSubString(e,50));	//Option(To Detail Message)
		}
		modelAndView.setViewName("jsonView");
		modelAndView.addObject(custResponse);
		return modelAndView;
	}
}
