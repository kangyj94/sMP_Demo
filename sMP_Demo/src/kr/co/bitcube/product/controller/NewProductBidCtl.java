package kr.co.bitcube.product.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.ibatis.session.RowBounds;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import kr.co.bitcube.common.dto.LoginUserDto;
import kr.co.bitcube.common.service.CommonSvc;
import kr.co.bitcube.common.utils.CommonUtils;
import kr.co.bitcube.common.utils.Constances;
import kr.co.bitcube.common.utils.CustomResponse;
import kr.co.bitcube.product.dto.McBidAuctionDto;
import kr.co.bitcube.product.dto.McBidDto;
import kr.co.bitcube.product.dto.McNewGoodRequestDto;
import kr.co.bitcube.product.service.NewProductBidSvc;

@Controller
@RequestMapping("product")
public class NewProductBidCtl {

	private Logger logger = Logger.getLogger(getClass());
	
	@Autowired
	private NewProductBidSvc newProductBidSvc;
	@Autowired
	private CommonSvc commonSvc;
	 
	/**
	 * 고객사상품등록요청 (고객사) 
	 */
	@RequestMapping("newProductRequestList.sys")
	public ModelAndView newProductRequestList(
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {

		return new ModelAndView("product/newProductBid/newProductRequestList");
	}

	/**
	 * 고객사상품등록요청 (고객사) 
	 */
	@RequestMapping("newProductRequestListForAdm.sys")
	public ModelAndView newProductRequestListForAdm(
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {

		return new ModelAndView("product/newProductBid/newProductRequestListForAdm");
	}
	
	/**
	 * 고객사상품등록요청 DB조회후 리턴시켜주는 메소드
	 */
	@RequestMapping("newProductRequestListJQGrid.sys")
	public ModelAndView newProductRequestListJQGrid(
			@RequestParam(value = "page", defaultValue = "1") int page,
			@RequestParam(value = "rows", defaultValue = "30") int rows,
			@RequestParam(value = "sidx", defaultValue = "") String sidx,
			@RequestParam(value = "sord", defaultValue = "desc") String sord,
			@RequestParam(value = "srcBorgName", defaultValue = "") String srcBorgName,
			@RequestParam(value = "srcGroupId", defaultValue = "0") String srcGroupId,
			@RequestParam(value = "srcClientId", defaultValue = "0") String srcClientId,
			@RequestParam(value = "srcBranchId", defaultValue = "0") String srcBranchId,
			@RequestParam(value = "srcInsert_FromDt", defaultValue = "") String srcInsert_FromDt,
			@RequestParam(value = "srcInsert_EndDt", defaultValue = "") String srcInsert_EndDt,
			@RequestParam(value = "srcStand_good_name", defaultValue = "") String srcStand_good_name,
			@RequestParam(value = "srcState", defaultValue = "") String srcState,
			@RequestParam(value = "srcStand_good_spec_desc", defaultValue = "") String srcStand_good_spec_desc,
			@RequestParam(value = "srcInsertUserId", defaultValue = "") String srcInsertUserId,
			@RequestParam(value = "srcRequestType", defaultValue = "0") String srcRequestType,
		ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		
		LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		
		if("0".equals(srcGroupId)) { srcGroupId = ""; }
		if("0".equals(srcClientId)) { srcClientId = ""; }
		if("0".equals(srcBranchId)) { srcBranchId = ""; }
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("srcBorgName", srcBorgName);
		params.put("srcGroupId", srcGroupId);
		params.put("srcClientId", srcClientId);
		params.put("srcBranchId", srcBranchId);
		params.put("srcInsert_FromDt", srcInsert_FromDt);
		params.put("srcInsert_EndDt", srcInsert_EndDt);
		params.put("srcStand_good_name", srcStand_good_name);
		params.put("srcState", srcState);
		params.put("srcStand_good_spec_desc", srcStand_good_spec_desc);
		params.put("srcInsertUserId", srcInsertUserId);
		params.put("srcRequestType", srcRequestType);
		params.put("srcSvcTypeCd",loginUserDto.getSvcTypeCd());
		
		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
		
		/*----------------페이징 세팅------------*/
		List<McNewGoodRequestDto> list = null;
		int records = 0; 
		int total = 0; 
		
		records = newProductBidSvc.getNewProductRequestListCnt(params); //조회조건에 따른 카운트
        total = (int)Math.ceil((float)records / (float)rows);
		
        /*----------------조회------------*/
        if(records>0) list = newProductBidSvc.getNewProductRequestList(params, page, rows);
		
        

		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("page", page);
		modelAndView.addObject("total", total);
		modelAndView.addObject("records", records);
		modelAndView.addObject("list", list);
		return modelAndView;
	}
	
	/**
	 * 고객사상품등록요청 DB조회후 엑셀 다운로드
	 */
	@RequestMapping("newProductRequestListExcel.sys")
	public ModelAndView newProductRequestListExcel(
			@RequestParam(value = "sidx", defaultValue = "newgoodid") String sidx,
			@RequestParam(value = "sord", defaultValue = "desc") String sord,
			@RequestParam(value = "srcBorgName", defaultValue = "") String srcBorgName,
			@RequestParam(value = "srcGroupId", defaultValue = "0") String srcGroupId,
			@RequestParam(value = "srcClientId", defaultValue = "0") String srcClientId,
			@RequestParam(value = "srcBranchId", defaultValue = "0") String srcBranchId,
			@RequestParam(value = "srcInsert_FromDt", defaultValue = "") String srcInsert_FromDt,
			@RequestParam(value = "srcInsert_EndDt", defaultValue = "") String srcInsert_EndDt,
			@RequestParam(value = "srcStand_good_name", defaultValue = "") String srcStand_good_name,
			@RequestParam(value = "srcState", defaultValue = "") String srcState,
			@RequestParam(value = "srcStand_good_spec_desc", defaultValue = "") String srcStand_good_spec_desc,
			@RequestParam(value = "srcInsertUserId", defaultValue = "") String srcInsertUserId,
			@RequestParam(value = "srcRequestType", defaultValue = "0") String srcRequestType,
			
			@RequestParam(value = "sheetTitle", defaultValue = "") String sheetTitle,
			@RequestParam(value = "excelFileName", defaultValue = "") String excelFileName,
			@RequestParam(value = "colLabels", required = false) String[] colLabels,
			@RequestParam(value = "colIds", required = false) String[] colIds,
			@RequestParam(value = "numColIds", required = false) String[] numColIds,	
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		
		LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		
		if("0".equals(srcGroupId)) { srcGroupId = ""; }
		if("0".equals(srcClientId)) { srcClientId = ""; }
		if("0".equals(srcBranchId)) { srcBranchId = ""; }
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("srcBorgName", srcBorgName);
		params.put("srcGroupId", srcGroupId);
		params.put("srcClientId", srcClientId);
		params.put("srcBranchId", srcBranchId);
		params.put("srcInsert_FromDt", srcInsert_FromDt);
		params.put("srcInsert_EndDt", srcInsert_EndDt);
		params.put("srcStand_good_name", srcStand_good_name);
		params.put("srcState", srcState);
		params.put("srcStand_good_spec_desc", srcStand_good_spec_desc);
		params.put("srcInsertUserId", srcInsertUserId);
		params.put("srcRequestType", srcRequestType);
		params.put("srcSvcTypeCd",loginUserDto.getSvcTypeCd());
		
		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
		
		/*----------------페이징 세팅------------*/
		List<McNewGoodRequestDto> list = newProductBidSvc.getNewProductRequestList(params, 1, RowBounds.NO_ROW_LIMIT);
		
		List<Map<String, Object>> colDataList = null;
		if(list != null && list.size() > 0){
			Map<String, Object> rtnData = null;
			colDataList = new ArrayList<Map<String, Object>>();
			for(int i = 0; i < list.size() ; i++){
				rtnData = new HashMap<String, Object>();
				rtnData.put("stand_good_name", list.get(i).getStand_good_name());
				rtnData.put("stand_good_spec_desc", list.get(i).getStand_good_spec_desc());
				rtnData.put("insert_date", list.get(i).getInsert_date());
				rtnData.put("stateNm", list.get(i).getStateNm());
				rtnData.put("bidid", list.get(i).getBidid());
				rtnData.put("userBorgNm", list.get(i).getUserBorgNm());
				rtnData.put("userId", list.get(i).getUserId());
				rtnData.put("good_iden_numb", list.get(i).getGood_iden_numb());
				colDataList.add(rtnData);
			}
		}			
		
        List<Map<String, Object>> sheetList = new ArrayList<Map<String, Object>>();
        Map<String, Object> map1 = new HashMap<String, Object>();
        map1.put("sheetTitle", sheetTitle);
        map1.put("colLabels", colLabels);
        map1.put("colIds", colIds);
        map1.put("numColIds", numColIds);
//        map1.put("figureColIds", figureColIds);
        map1.put("colDataList", colDataList);
        sheetList.add(map1);
        modelAndView.setViewName("commonExcelViewResolver");
        modelAndView.addObject("excelFileName", excelFileName);
        modelAndView.addObject("sheetList", sheetList);
		
//		modelAndView.addObject("sheetTitle", sheetTitle);
//		modelAndView.addObject("excelFileName", excelFileName);
//		modelAndView.addObject("colLabels", colLabels);
//		modelAndView.addObject("colIds", colIds);
//		modelAndView.addObject("numColIds", numColIds);
//		modelAndView.addObject("colDataList", colDataList);
//		modelAndView.setViewName("commonExcelViewResolver");
		return modelAndView;
	}
	
	/**
	 * (공통)신규품목요청 상세 page Forward 
	 */
	@RequestMapping("newProductRequestDetail.sys")
	public ModelAndView newProductRequestDetail(
			@RequestParam(value = "newgoodid", defaultValue = "") String newgoodid,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		//상태 정보 
		modelAndView.setViewName("product/newProductBid/newProductRequestDetail");
		modelAndView.addObject("newgoodid", newgoodid);
		return modelAndView;
	}
	
	/**
	 * 상세 데이터 조회 
	 */
	@RequestMapping("newProductRequestDetailDataInit.sys")
	public ModelAndView newProductRequestDetailDataInit(
			@RequestParam(value = "newgoodid", defaultValue = "") String newgoodid,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("newgoodid", newgoodid);
		
		//상태 정보 
		modelAndView.addObject("detailInfo", newProductBidSvc.getRequestProductDetailInfo(params));
		modelAndView.setViewName("jsonView");
		return modelAndView;
	}
	
	/**
	 * (고객사)신규품목요청 상세 page Forward 
	 */
	@RequestMapping("setNewProductRequest.sys")
	public ModelAndView setNewProductRequest(
			@RequestParam(value = "oper", defaultValue = "") String oper,
			@RequestParam(value = "newgoodid", defaultValue = "") String newgoodid,
			@RequestParam(value = "stand_good_name", defaultValue = "") String stand_good_name,
			@RequestParam(value = "request_type", defaultValue = "") String request_type,
			@RequestParam(value = "stand_good_spec_desc", defaultValue = "") String stand_good_spec_desc,
			@RequestParam(value = "note", defaultValue = "") String note,
			@RequestParam(value = "firstattachseq", defaultValue = "") String firstattachseq,
			@RequestParam(value = "secondattachseq", defaultValue = "") String secondattachseq,
			@RequestParam(value = "thirdattachseq", defaultValue = "") String thirdattachseq,
			@RequestParam(value = "state", defaultValue = "") String state,
			@RequestParam(value = "insert_user_id", defaultValue = "") String insert_user_id,
			@RequestParam(value = "insert_borgid", defaultValue = "") String insert_borgid,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("oper"					,oper					);
		params.put("newgoodid"				,newgoodid				);
		params.put("stand_good_name"		,stand_good_name		);
		params.put("request_type"			,request_type			);
		params.put("stand_good_spec_desc"	,stand_good_spec_desc	);
		params.put("note"					,note                	);
		params.put("firstattachseq"			,firstattachseq      	);
		params.put("secondattachseq"		,secondattachseq     	);
		params.put("thirdattachseq"			,thirdattachseq      	);
		params.put("state"					,state               	);
		params.put("insert_user_id"			,insert_user_id      	);
		params.put("insert_borgid"			,insert_borgid       	);
		
		LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		params.put("loginUserDto",loginUserDto);
		
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		try {
			newProductBidSvc.setNewProductRequest(params);
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
	
	/**
	 * 기상품 처리시 
	 * @param newgoodid
	 * @param good_iden_numb
	 * @param request
	 * @param modelAndView
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("setExistsProductProcess.sys")
	public ModelAndView setExistsProductProcess(
			@RequestParam(value = "newgoodid", defaultValue = "") String newgoodid,
			@RequestParam(value = "good_iden_numb", defaultValue = "") String good_iden_numb,
			@RequestParam(value = "insert_user_id", defaultValue = "") String insert_user_id,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		/*----------------조회조건 세팅------------*/
		LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		Map<String, Object> params = new HashMap<String, Object>();
		
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		try {
			 params.put("newgoodid"			,newgoodid		);      
			 params.put("good_iden_numb"	,good_iden_numb	); 
			 params.put("state"				,"90"	);
			 params.put("insert_user_id"	, insert_user_id);
			 
			 newProductBidSvc.setExistsProductProcess(params); 
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
	
	
	
	/**
	 * (운영사)신규품목요청 상세 page Forward 
	 */
	@RequestMapping("newProductReqForAdmin.sys")
	public ModelAndView newProductReqForAdmin(
			@RequestParam(value = "newgoodid", defaultValue = "") String newgoodid,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		modelAndView.setViewName("product/newProductBid/newProductReqForAdmin");
		modelAndView.addObject("newgoodid", newgoodid);
		return modelAndView;
	}
	
	/**
	 * 입찰조회운영사
	 */
	@RequestMapping("newProductBidList.sys")
	public ModelAndView newProductBidList(
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		return new ModelAndView("product/newProductBid/newProductBidList");
	}
	
	/**
	 * 입찰조회운영사 DB조회후 리턴시켜주는 메소드
	 */
	@RequestMapping("newProductBidListJQGrid.sys")
	public ModelAndView newProductBidListJQGrid(
			@RequestParam(value = "page", defaultValue = "1") int page,
			@RequestParam(value = "rows", defaultValue = "30") int rows,
			@RequestParam(value = "sidx", defaultValue = "bidid") String sidx,
			@RequestParam(value = "sord", defaultValue = "desc") String sord,
			@RequestParam(value = "srcBidid", defaultValue = "") String srcBidid,
			@RequestParam(value = "srcBidname", defaultValue = "") String srcBidname,
			@RequestParam(value = "srcBidState", defaultValue = "") String srcBidState,
			@RequestParam(value = "srcStand_good_name", defaultValue = "") String srcStand_good_name,
			@RequestParam(value = "srcInsert_FromDt", defaultValue = "") String srcInsert_FromDt,
			@RequestParam(value = "srcInsert_EndDt", defaultValue = "") String srcInsert_EndDt,
			@RequestParam(value = "srcStand_good_spec_desc", defaultValue = "") String srcStand_good_spec_desc,
			@RequestParam(value = "srcVendorid", defaultValue = "") String srcVendorid,
			@RequestParam(value = "bidClassify", defaultValue = "") String bidClassify,
		ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("srcBidid", srcBidid);
		params.put("srcBidname", srcBidname);
		params.put("srcBidState", srcBidState);
		params.put("srcStand_good_name", srcStand_good_name);
		params.put("srcInsert_FromDt", srcInsert_FromDt);
		params.put("srcInsert_EndDt", srcInsert_EndDt);
		params.put("srcStand_good_spec_desc", srcStand_good_spec_desc);
		params.put("srcVendorid", srcVendorid);
		params.put("bidClassify", bidClassify);
		String orderString = " A." + sidx + " " + sord + " ";
		params.put("orderString", orderString);
		
		/*----------------페이징 세팅------------*/
        int records = newProductBidSvc.getNewProductBidListCnt(params); //조회조건에 따른 카운트
        int total = (int)Math.ceil((float)records / (float)rows);
		
        /*----------------조회------------*/
        List<McBidDto> list = null;
        if(records>0) list = newProductBidSvc.getNewProductBidList(params, page, rows);

		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("page", page);
		modelAndView.addObject("total", total);
		modelAndView.addObject("records", records);
		modelAndView.addObject("list", list);
		return modelAndView;
	}
	
	/**
	 * 입찰조회운영사 DB조회후 엑셀 다운로드
	 */
	@RequestMapping("newProductBidListExcel.sys")
	public ModelAndView newProductBidListExcel(
			@RequestParam(value = "sidx", defaultValue = "insert_date") String sidx,
			@RequestParam(value = "sord", defaultValue = "desc") String sord,
			@RequestParam(value = "srcBidid", defaultValue = "") String srcBidid,
			@RequestParam(value = "srcBidname", defaultValue = "") String srcBidname,
			@RequestParam(value = "srcBidState", defaultValue = "") String srcBidState,
			@RequestParam(value = "srcStand_good_name", defaultValue = "") String srcStand_good_name,
			@RequestParam(value = "srcInsert_FromDt", defaultValue = "") String srcInsert_FromDt,
			@RequestParam(value = "srcInsert_EndDt", defaultValue = "") String srcInsert_EndDt,
			@RequestParam(value = "srcStand_good_spec_desc", defaultValue = "") String srcStand_good_spec_desc,
			@RequestParam(value = "srcVendorid", defaultValue = "") String srcVendorid,
			@RequestParam(value = "bidClassify", defaultValue = "") String bidClassify,
			
			@RequestParam(value = "sheetTitle", defaultValue = "") String sheetTitle,
			@RequestParam(value = "excelFileName", defaultValue = "") String excelFileName,
			@RequestParam(value = "colLabels", required = false) String[] colLabels,
			@RequestParam(value = "colIds", required = false) String[] colIds,
			@RequestParam(value = "numColIds", required = false) String[] numColIds,	
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("srcBidid", srcBidid);
		params.put("srcBidname", srcBidname);
		params.put("srcBidState", srcBidState);
		params.put("srcStand_good_name", srcStand_good_name);
		params.put("srcInsert_FromDt", srcInsert_FromDt);
		params.put("srcInsert_EndDt", srcInsert_EndDt);
		params.put("srcStand_good_spec_desc", srcStand_good_spec_desc);
		params.put("srcVendorid", srcVendorid);
		params.put("bidClassify", bidClassify);
		String orderString = " A." + sidx + " " + sord + " ";
		params.put("orderString", orderString);
		
		/*----------------조회------------*/
		List<McBidDto> list = newProductBidSvc.getNewProductBidList(params, 1, RowBounds.NO_ROW_LIMIT);
		
		List<Map<String, Object>> colDataList = null;
		if(list != null && list.size() > 0){
			Map<String, Object> rtnData = null;
			colDataList = new ArrayList<Map<String, Object>>();
			for(int i = 0; i < list.size() ; i++){
				rtnData = new HashMap<String, Object>();
				rtnData.put("bidid", list.get(i).getBidid());
				rtnData.put("bidname", list.get(i).getBidname());
				rtnData.put("stand_good_name", list.get(i).getStand_good_name());
				rtnData.put("stand_good_spec_desc", list.get(i).getStand_good_spec_desc());
				rtnData.put("bidstateNm", list.get(i).getBidstateNm());
				rtnData.put("bidenddate", list.get(i).getBidenddate());
				rtnData.put("insert_user_id", list.get(i).getInsert_user_id());
				rtnData.put("is_use_certificate", list.get(i).getIs_use_certificate());
				rtnData.put("insert_date", list.get(i).getInsert_date());
				rtnData.put("bid_classify", list.get(i).getBid_classify());
				colDataList.add(rtnData);
			}
		}				
		
        List<Map<String, Object>> sheetList = new ArrayList<Map<String, Object>>();
        Map<String, Object> map1 = new HashMap<String, Object>();
        map1.put("sheetTitle", sheetTitle);
        map1.put("colLabels", colLabels);
        map1.put("colIds", colIds);
        map1.put("numColIds", numColIds);
//        map1.put("figureColIds", figureColIds);
        map1.put("colDataList", colDataList);
        sheetList.add(map1);
        modelAndView.setViewName("commonExcelViewResolver");
        modelAndView.addObject("excelFileName", excelFileName);
        modelAndView.addObject("sheetList", sheetList);
		
//		modelAndView.addObject("sheetTitle", sheetTitle);
//		modelAndView.addObject("excelFileName", excelFileName);
//		modelAndView.addObject("colLabels", colLabels);
//		modelAndView.addObject("colIds", colIds);
//		modelAndView.addObject("numColIds", numColIds);
//		modelAndView.addObject("colDataList", colDataList);
//		modelAndView.setViewName("commonExcelViewResolver");
		return modelAndView;		
	}
	
	@RequestMapping("newProductBidDetail.sys")
	public ModelAndView newProductBidDetail(
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		return new ModelAndView("product/newProductBid/newProductBidDetail");
	}
	
	/**
	 * 입찰생성요청
	 */
	@RequestMapping("newProductBidRegist.sys")
	public ModelAndView newProductBidRegist(
			@RequestParam(value = "newgoodid", defaultValue = "") String newgoodid,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		//상태 정보 
		modelAndView.setViewName("product/newProductBid/newProductBidRegist");
		modelAndView.addObject("newgoodid", newgoodid);
		modelAndView.addObject("deliAreaCodeList", commonSvc.getCodeList("DELI_AREA_CODE", 1));	//권역유형
		return modelAndView;
	}
	
	/**
	 * 상품입찰공고 및 상품입찰공급사정보 등록 
	 * @param 
	 * @param request
	 * @param modelAndView
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("bidTrans.sys")
	public ModelAndView bidTrans(
			@RequestParam(value = "bidname", defaultValue = "0") String bidname,
			@RequestParam(value = "bidstate", defaultValue = "0") String bidstate,
			@RequestParam(value = "stand_good_name", defaultValue = "0") String stand_good_name,
			@RequestParam(value = "stand_good_spec_desc", defaultValue = "0") String stand_good_spec_desc,
			@RequestParam(value = "is_use_certificate", defaultValue = "0") String is_use_certificate,
			@RequestParam(value = "hope_sale_price", defaultValue = "0") String hope_sale_price,
			@RequestParam(value = "bidnote", defaultValue = "0") String bidnote,
			@RequestParam(value = "firstattachseq", defaultValue = "0") String firstattachseq,
			@RequestParam(value = "secondattachseq", defaultValue = "0") String secondattachseq,
			@RequestParam(value = "thirdattachseq", defaultValue = "0") String thirdattachseq,
			@RequestParam(value = "bidenddate", defaultValue = "0") String bidenddate,
			@RequestParam(value = "newgoodid", defaultValue = "") String newgoodid,
			@RequestParam(value = "insert_user_id", defaultValue = "0") String insert_user_id,
			@RequestParam(value = "vendorIdArray[]") String[] vendorIdArray,
			@RequestParam(value = "bidStartdate", defaultValue = "0")String bidStartdate,
			@RequestParam(value = "bidClassify", defaultValue = "")String bidClassify, 
			ModelAndView modelAndView, HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		/*----------------저장값 세팅------------*/
		Map<String,Object> params = new HashMap<String,Object>();
		params.put("bidname", bidname);
		params.put("bidstate", bidstate);
		params.put("stand_good_name", stand_good_name);
		params.put("stand_good_spec_desc", stand_good_spec_desc);
		params.put("is_use_certificate", is_use_certificate);
		params.put("hope_sale_price", CommonUtils.stringParseDouble(hope_sale_price, 0.0));
		params.put("bidnote", bidnote);
		params.put("firstattachseq", firstattachseq);
		params.put("secondattachseq", secondattachseq);
		params.put("thirdattachseq", thirdattachseq);
		params.put("bidenddate", bidenddate);
		params.put("newgoodid", CommonUtils.stringParseInt(newgoodid, 0));
		params.put("insert_user_id", insert_user_id);
		params.put("vendorIdArray", vendorIdArray);
		params.put("bidStartdate", bidStartdate);
		params.put("bidClassify", bidClassify);
		
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		try {
			newProductBidSvc.bidTrans(params);
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
	/*----------------운영사 끝------------*/
	
	/*----------------공급사 시작------------*/
	@RequestMapping("venProductTendorRegist.sys")
	public ModelAndView venProductTendorRegist(
			@RequestParam(value = "bidid", defaultValue = "") String bidid,
			@RequestParam(value = "vendorid", defaultValue = "") String vendorid,
			@RequestParam(value = "bidstate", defaultValue = "") String bidstate,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {

		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("bidid", bidid);
		params.put("vendorid", vendorid);
				
		String vendorbidstate = "";
		if( !("".equals(vendorid)) ) {
			List<McBidAuctionDto> detailInfo = newProductBidSvc.getBidAuctionDetailInfo(params);
			vendorbidstate = detailInfo.get(0).getVendorbidstate();
		}
		
		modelAndView.setViewName("product/newProductBid/newProductTenderRegist");
		modelAndView.addObject("bidid"			, bidid);
		modelAndView.addObject("bidstate"		, bidstate);
		modelAndView.addObject("bidStateCd"		, commonSvc.getCodeList("BIDSTATE", 1));
		modelAndView.addObject("orderUnitCd"	, commonSvc.getCodeList("ORDERUNIT", 1));
		modelAndView.addObject("vendorbidstate"	, vendorbidstate);
		return modelAndView;
	}
	
	/**
	 * 상세 데이터 조회 (상품입찰공고)
	 */
	@RequestMapping("newProductBidDetailDataInit.sys")
	public ModelAndView newProductBidDetailDataInit(
			@RequestParam(value = "bidid", defaultValue = "") String bidid,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("bidid", bidid);
		
		//상태 정보 
		modelAndView.addObject("detailInfo", newProductBidSvc.getBidProductDetailInfo(params));
		modelAndView.setViewName("jsonView");
		return modelAndView;
	}
	
	/**
	 * 상품입찰공급사정보 DB조회후 리턴시켜주는 메소드
	 */
	@RequestMapping("newProductBidAuctionListJQGrid.sys")
	public ModelAndView newProductBidAuctionListJQGrid(
			@RequestParam(value = "sidx", defaultValue = "") String sidx,
			@RequestParam(value = "sord", defaultValue = "asc") String sord,
			@RequestParam(value = "bidid", defaultValue = "0") String bidid,
		ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("bidid", bidid);
		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
		
		/*----------------페이징 세팅------------*/
        int records = newProductBidSvc.getNewProductBidAuctionListCnt(params); //조회조건에 따른 카운트
		
        /*----------------조회------------*/
        List<McBidAuctionDto> list = null;
        if(records>0) list = newProductBidSvc.getNewProductBidAuctionList(params);

		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("list", list);
		return modelAndView;
	}
	
	/**
	 * 상세 데이터 조회 (상품입찰공급사정보)
	 */
	@RequestMapping("newProductBidAuctionDetailDataInit.sys")
	public ModelAndView newProductBidAuctionDetailDataInit(
			@RequestParam(value = "bidid", defaultValue = "") String bidid,
			@RequestParam(value = "vendorid", defaultValue = "") String vendorid,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("bidid", bidid);
		params.put("vendorid", vendorid);
		
		//상태 정보 
		modelAndView.addObject("detailInfo", newProductBidSvc.getBidAuctionProductDetailInfo(params));
		modelAndView.setViewName("jsonView");
		return modelAndView;
	}
	
	/**
	 * 상품입찰공급사정보 수정 
	 * @param 
	 * @param request
	 * @param modelAndView
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("bidAuctionTrans.sys")
	public ModelAndView bidAuctionTrans(
			@RequestParam(value = "bidid", defaultValue = "0") String bidid,
			@RequestParam(value = "vendorid", defaultValue = "") String vendorid,
			@RequestParam(value = "good_name", defaultValue = "") String good_name,
			@RequestParam(value = "good_spec_desc", defaultValue = "") String good_spec_desc,
			@RequestParam(value = "orde_clas_code", defaultValue = "") String orde_clas_code,
			@RequestParam(value = "sale_unit_price", defaultValue = "0") String sale_unit_price,
			@RequestParam(value = "deli_mini_day", defaultValue = "0") String deli_mini_day,
			@RequestParam(value = "deli_mini_quan", defaultValue = "0") String deli_mini_quan,
			@RequestParam(value = "make_comp_name", defaultValue = "") String make_comp_name,
			@RequestParam(value = "original_img_path", defaultValue = "") String original_img_path,
			@RequestParam(value = "large_img_path", defaultValue = "") String large_img_path,
			@RequestParam(value = "middle_img_path", defaultValue = "") String middle_img_path,
			@RequestParam(value = "small_img_path", defaultValue = "") String small_img_path,
			@RequestParam(value = "good_desc", defaultValue = "") String good_desc,
			@RequestParam(value = "good_same_word", defaultValue = "") String good_same_word,
			@RequestParam(value = "FIRSTATTACHSEQ", defaultValue = "") String FIRSTATTACHSEQ,
			@RequestParam(value = "SECONDATTACHSEQ", defaultValue = "") String SECONDATTACHSEQ,
			@RequestParam(value = "THIRDATTACHSEQ", defaultValue = "") String THIRDATTACHSEQ,
			@RequestParam(value = "bidding_user_id", defaultValue = "") String bidding_user_id,
			ModelAndView modelAndView, HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		/*----------------저장값 세팅------------*/
		Map<String,Object> params = new HashMap<String,Object>();
		params.put("bidid", CommonUtils.stringParseInt(bidid, 0));
		params.put("vendorid", vendorid);
		params.put("vendorbidstate", "15");
		params.put("good_name", good_name);
		params.put("good_spec_desc", good_spec_desc);
		params.put("orde_clas_code", orde_clas_code);
		params.put("sale_unit_price", CommonUtils.stringParseDouble(sale_unit_price, 0.0));
		params.put("deli_mini_day", CommonUtils.stringParseDouble(deli_mini_day, 0.0));
		params.put("deli_mini_quan", CommonUtils.stringParseDouble(deli_mini_quan, 0.0));
		params.put("make_comp_name", make_comp_name);
		params.put("original_img_path", original_img_path);
		params.put("large_img_path", large_img_path);
		params.put("middle_img_path", middle_img_path);
		params.put("small_img_path", small_img_path);
		params.put("good_desc", good_desc);
		params.put("good_same_word", good_same_word);
		params.put("FIRSTATTACHSEQ", FIRSTATTACHSEQ);
		params.put("SECONDATTACHSEQ", SECONDATTACHSEQ);
		params.put("THIRDATTACHSEQ", THIRDATTACHSEQ);
		params.put("bidding_user_id", bidding_user_id);
		
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		try {
			newProductBidSvc.bidAuctionTrans(params);
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
	
	@RequestMapping("venProductBidDetail.sys")
	public ModelAndView venProductBidDetail(
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		return new ModelAndView("product/newProductBid/venProductBidDetail");
	}
	
	/**
	 * 상품입찰공고 및 상품입찰공급사정보 상태 수정 
	 * @param 
	 * @param request
	 * @param modelAndView
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("bidAuctionStateTrans.sys")
	public ModelAndView bidAuctionStateTrans(
			@RequestParam(value = "bidid", defaultValue = "0") String bidid,
			@RequestParam(value = "vendorid", defaultValue = "") String vendorid,
			@RequestParam(value = "newgoodid", defaultValue = "0") String newgoodid,
			@RequestParam(value = "bidstate", defaultValue = "") String bidstate,
			@RequestParam(value = "vendorbidstate", defaultValue = "") String vendorbidstate,
			@RequestParam(value = "insert_user_id", defaultValue = "") String insert_user_id,
			ModelAndView modelAndView, HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		/*----------------저장값 세팅------------*/
		Map<String,Object> params = new HashMap<String,Object>();
		params.put("bidid", CommonUtils.stringParseInt(bidid, 0));
		params.put("vendorid", vendorid);
		params.put("newgoodid", CommonUtils.stringParseInt(newgoodid, 0));
		params.put("bidstate", bidstate);
		params.put("vendorbidstate", vendorbidstate);
		params.put("insert_user_id", insert_user_id);
		
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		try {
			newProductBidSvc.bidAuctionStateTrans(params);
			if("90".equals(bidstate)) {
				modelAndView.addObject("msg", "유찰 되었습니다.");
			} else if("50".equals(bidstate)) {
				modelAndView.addObject("msg", "낙찰 되었습니다.");
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
	/**
	 * 입찰종료 일자 서버 시간과 비교 
	 */
	@RequestMapping("bidEndDateCompare.sys")
	public ModelAndView bidEndDateCompare(
			@RequestParam(value = "bidEndDate", defaultValue = "") String bidEndDate,
			@RequestParam(value = "bidInsertDate", defaultValue = "") String bidInsertDate,
			ModelAndView modelAndView, HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		CustomResponse custResponse = new CustomResponse(true);
		try{
			String systemDate = CommonUtils.getCurrentDateTime();
			int dateFlag = systemDate.compareTo(bidEndDate);
			if(dateFlag>0){
				custResponse.setSuccess(false);
				custResponse.setMessage("입찰종료일자가 지났습니다.\n투찰을 할 수 없습니다.");
			}
			
			int dateInsertFlag = systemDate.compareTo(bidInsertDate);
			
			if(dateInsertFlag<0){
				custResponse.setSuccess(false);
				custResponse.setMessage("아직 입찰이 시작되지 않았습니다.\n투찰을 할 수 없습니다.");
			}
		}catch(Exception e) {
			
			logger.error("Exception : "+e);
			custResponse.setSuccess(false);
			custResponse.setMessage("System Date Error....");
			custResponse.setMessage(CommonUtils.getErrSubString(e,50));	//Option(To Detail Message)
		}
		modelAndView.addObject(custResponse);
		modelAndView.setViewName("jsonView");
		return modelAndView;
	}
}
