package kr.co.bitcube.product.controller; 

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import kr.co.bitcube.common.utils.CommonUtils;
import kr.co.bitcube.common.utils.Constances;
import kr.co.bitcube.common.utils.CustomResponse;
import kr.co.bitcube.common.dto.LoginUserDto;
import kr.co.bitcube.product.dto.CategoryDto;
import kr.co.bitcube.product.service.CategorySvc;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

@Controller
@RequestMapping("category")
public class CategoryCtl {
	
	private Logger logger = Logger.getLogger(getClass());
	
	@Autowired
	private CategorySvc categorySvc;
	
	@RequestMapping("categoryList.sys")
	public ModelAndView categoryList(
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		return new ModelAndView("product/category/categoryList");
	}
	
	@RequestMapping("categoryTreeJQGrid.sys")
	public ModelAndView categoryTreeJQGrid(
			@RequestParam(value = "nodeid", defaultValue = "") String nodeid,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		List<Map<String, Object>> returnList = new ArrayList<Map<String, Object>>();
		if(nodeid==null || "".equals(nodeid)) {
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("ref_Cate_Seq", "");
			params.put("cate_Level", "0");
			List<CategoryDto> categoryList = categorySvc.getCategoryList(params);	// root
			for(CategoryDto categoryDto : categoryList) {
				Map<String, Object> returnMap = new HashMap<String, Object>();
				returnMap.put("majo_Code_Name", categoryDto.getMajo_Code_Name());
				returnMap.put("cate_Cd", categoryDto.getCate_Cd());
				returnMap.put("mojo_Code_Desc", categoryDto.getMojo_Code_Desc());
				returnMap.put("ord_Num", categoryDto.getOrd_Num());
				returnMap.put("typeName", "");
				returnMap.put("treeKey", "1st∥"+categoryDto.getCate_Id());
				returnMap.put("ref_Cate_Seq", categoryDto.getRef_Cate_Seq());
				returnMap.put("cate_Id", categoryDto.getCate_Id());
				returnMap.put("full_Cate_Name", categoryDto.getFull_Cate_Name());
				returnMap.put("level", 0);
				
				returnList.add(returnMap);
			}
		} else if(nodeid.split("∥").length>1) {
			String treeFlag = nodeid.split("∥")[0];
			String treeKey = nodeid.split("∥")[1];
			if("1st".equals(treeFlag)) {
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ref_Cate_Seq", treeKey);
				params.put("cate_Level", "1");
				List<CategoryDto> categoryList = categorySvc.getCategoryList(params);	// 상위카테고리Seq(1st)
				for(CategoryDto categoryDto : categoryList) {
					Map<String, Object> returnMap = new HashMap<String, Object>();
					returnMap.put("majo_Code_Name", categoryDto.getMajo_Code_Name());
					returnMap.put("cate_Cd", categoryDto.getCate_Cd());
					returnMap.put("mojo_Code_Desc", categoryDto.getMojo_Code_Desc());
					returnMap.put("ord_Num", categoryDto.getOrd_Num());
					returnMap.put("typeName", "1st");
					returnMap.put("treeKey", "2st∥"+categoryDto.getCate_Id());
					returnMap.put("ref_Cate_Seq", categoryDto.getRef_Cate_Seq());
					returnMap.put("cate_Id", categoryDto.getCate_Id());
					returnMap.put("full_Cate_Name", categoryDto.getFull_Cate_Name());
					returnMap.put("level", 1);
					
					returnList.add(returnMap);
				}
			} else if("2st".equals(treeFlag)) {
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ref_Cate_Seq", treeKey);
				params.put("cate_Level", "2");
				List<CategoryDto> categoryList2 = categorySvc.getCategoryList(params);	// 상위카테고리Seq(2st)
				for(CategoryDto categoryDto : categoryList2) {
					Map<String, Object> returnMap = new HashMap<String, Object>();
					returnMap.put("majo_Code_Name", categoryDto.getMajo_Code_Name());
					returnMap.put("cate_Cd", categoryDto.getCate_Cd());
					returnMap.put("mojo_Code_Desc", categoryDto.getMojo_Code_Desc());
					returnMap.put("ord_Num", categoryDto.getOrd_Num());
					returnMap.put("typeName", "2st");
					returnMap.put("treeKey", "3st∥"+categoryDto.getCate_Id());
					returnMap.put("ref_Cate_Seq", categoryDto.getRef_Cate_Seq());
					returnMap.put("cate_Id", categoryDto.getCate_Id());
					returnMap.put("full_Cate_Name", categoryDto.getFull_Cate_Name());
					returnMap.put("parent", nodeid);
					returnMap.put("level", 2);
					
					returnList.add(returnMap);
				}
			} else if("3st".equals(treeFlag)) {
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ref_Cate_Seq", treeKey);
				params.put("cate_Level", "3");
				List<CategoryDto> categoryList3 = categorySvc.getCategoryList(params);	// 상위카테고리Seq(3st)
				for(CategoryDto categoryDto : categoryList3) {
					Map<String, Object> returnMap = new HashMap<String, Object>();
					returnMap.put("majo_Code_Name", categoryDto.getMajo_Code_Name());
					returnMap.put("cate_Cd", categoryDto.getCate_Cd());
					returnMap.put("mojo_Code_Desc", categoryDto.getMojo_Code_Desc());
					returnMap.put("ord_Num", categoryDto.getOrd_Num());
					returnMap.put("typeName", "3st");
					returnMap.put("treeKey", "4st∥"+categoryDto.getCate_Id());
					returnMap.put("ref_Cate_Seq", categoryDto.getRef_Cate_Seq());
					returnMap.put("cate_Id", categoryDto.getCate_Id());
					returnMap.put("full_Cate_Name", categoryDto.getFull_Cate_Name());
					returnMap.put("parent", nodeid);
					returnMap.put("level", 3);
					returnMap.put("isLeaf", true);
					
					returnList.add(returnMap);
				}
//			} else if("4st".equals(treeFlag)) {
//				Map<String, Object> params = new HashMap<String, Object>();
//				params.put("ref_Cate_Seq", treeKey);
//				params.put("cate_Level", "4");
//				List<CategoryDto> categoryList4 = categorySvc.getCategoryList(params);	// 상위카테고리Seq(4st)
//				for(CategoryDto categoryDto : categoryList4) {
//					Map<String, Object> returnMap = new HashMap<String, Object>();
//					returnMap.put("majo_Code_Name", categoryDto.getMajo_Code_Name());
//					returnMap.put("cate_Cd", categoryDto.getCate_Cd());
//					returnMap.put("mojo_Code_Desc", categoryDto.getMojo_Code_Desc());
//					returnMap.put("ord_Num", categoryDto.getOrd_Num());
//					returnMap.put("typeName", "4st");
//					returnMap.put("treeKey", "5st∥"+categoryDto.getCate_Id());
//					returnMap.put("ref_Cate_Seq", categoryDto.getRef_Cate_Seq());
//					returnMap.put("parent", nodeid);
//					returnMap.put("level", 4);
//					returnMap.put("isLeaf", true);
//					
//					returnList.add(returnMap);
//				}
			}
		}
		
		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("treeList",returnList);
		return modelAndView;
	}
	
	@RequestMapping("categoryTreeExcelJQGrid.sys")
	public ModelAndView categoryTreeExcelJQGrid(
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
        /*----------------조회------------*/
       	List<CategoryDto> list = categorySvc.getCategoryTreeExcel();
		
		modelAndView.setViewName("jsonView");
		modelAndView.addObject("treeListExcel", list);
		return modelAndView;
	}
	
	
	@RequestMapping("categoryMasterTransGrid.sys")
	public ModelAndView categoryMasterTransGrid(
			@RequestParam(value = "oper", required = true) String oper,
			@RequestParam(value = "id", defaultValue = "") String cateId,
			@RequestParam(value = "majo_Code_Name", defaultValue = "") String majoCodeName,
			@RequestParam(value = "cate_Cd", defaultValue = "") String cateCd,
			@RequestParam(value = "mojo_Code_Desc", defaultValue = "") String mojoCodeDesc,
			@RequestParam(value = "refCateSeq", defaultValue = "") String refCateSeq,
			@RequestParam(value = "cateLevel", defaultValue = "") String cateLevel,
			@RequestParam(value = "ord_Num", defaultValue = "") String ordNum,
			ModelAndView modelAndView, HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		/*----------------저장값 세팅------------*/
		LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		Map<String,Object> saveMap = new HashMap<String,Object>();
		saveMap.put("majoCodeName", majoCodeName);
		saveMap.put("cateCd", cateCd.toUpperCase());
		saveMap.put("mojoCodeDesc", mojoCodeDesc);
		saveMap.put("refCateSeq", refCateSeq);
		saveMap.put("cateLevel", cateLevel);
		saveMap.put("ordNum", ordNum);
		saveMap.put("insertUserId", loginUserDto.getUserId());
		saveMap.put("remoteIp", loginUserDto.getRemoteIp());
		
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		try {
			if("add".equals(oper)) {
				categorySvc.regCategoryMaster(saveMap, custResponse);
				//custResponse.setMessage("등록 되었습니다.");
			} else if("edit".equals(oper)) {
				saveMap.put("cateId", cateId.split("∥")[1]);
				categorySvc.modCategoryMaster(saveMap);
				//custResponse.setMessage("수정 되었습니다.");
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
	
	@RequestMapping("displayListJQGrid.sys")
	public ModelAndView displayListJQGrid(
			@RequestParam(value = "sidx", defaultValue = "cate_Disp_Name") String sidx,
			@RequestParam(value = "sord", defaultValue = "desc") String sord,
			@RequestParam(value = "srcCateDispName", defaultValue = "") String srcCateDispName,
			@RequestParam(value = "srcGroupId", defaultValue = "0") String srcGroupId,
			@RequestParam(value = "srcClientId", defaultValue = "0") String srcClientId,
			@RequestParam(value = "srcBranchId", defaultValue = "0") String srcBranchId,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
//		if("0".equals(srcGroupId) && "0".equals(srcClientId) && "0".equals(srcBranchId) ) {
//			srcGroupId = "";	srcClientId = "";	srcBranchId = "";
//		}
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("srcCateDispName", srcCateDispName);
		params.put("srcGroupId", srcGroupId);
		params.put("srcClientId", srcClientId);
		params.put("srcBranchId", srcBranchId);
		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
		
		/*----------------페이징 세팅------------*/
		List<CategoryDto> list = null;
        int records = categorySvc.getDisplayListCnt(params);
        
        /*----------------조회------------*/
        if(records>0) {
        	list = categorySvc.getDisplayList(params);
        }
		
		modelAndView.setViewName("jsonView");
		modelAndView.addObject("list", list);
		return modelAndView;
	}
	
	@RequestMapping("displayMasterTransGrid.sys")
	public ModelAndView displayMasterTransGrid(
			@RequestParam(value = "oper", required = true) String oper,
			@RequestParam(value = "id", defaultValue = "") String cateDispId,
			@RequestParam(value = "cate_Disp_Name", defaultValue = "") String cateDispName,
			@RequestParam(value = "cate_Disp_Desc", defaultValue = "") String cateDispDesc,
			@RequestParam(value = "is_Disp_Use", defaultValue = "1") String isDispUse,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		/*----------------저장값 세팅------------*/
		LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		Map<String,Object> saveMap = new HashMap<String,Object>();
		saveMap.put("cateDispId", cateDispId);
		saveMap.put("cateDispName", cateDispName);
		saveMap.put("cateDispDesc", cateDispDesc);
		saveMap.put("isDispUse", isDispUse);
		saveMap.put("insertUserId", loginUserDto.getUserId());
		saveMap.put("remoteIp", loginUserDto.getRemoteIp());
		
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		try {
			if("add".equals(oper)) {
				categorySvc.regDisplayMaster(saveMap);
				//modelAndView.addObject("msg", "등록 되었습니다.");
			} else if("edit".equals(oper)) {
				categorySvc.modDisplayMaster(saveMap);
				//modelAndView.addObject("msg", "수정 되었습니다.");
			} else if("del".equals(oper)) {
				categorySvc.delDisplayMaster(saveMap);
				modelAndView.addObject("msg", "삭제 되었습니다.");
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
	
	@RequestMapping("displayCategoryTransGrid.sys")
	public ModelAndView displayCategoryTransGrid(
			@RequestParam(value = "oper", required = true) String oper,
			@RequestParam(value = "cate_Disp_Id", defaultValue = "") String cateDispId,
			@RequestParam(value = "cate_Id", defaultValue = "") String cateId,
			@RequestParam(value = "ref_Cate_Seq", defaultValue = "") String refCateSeq,
			@RequestParam(value = "lastSt", defaultValue = "") String lastSt,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		/*----------------저장값 세팅------------*/
		int records = 0;
		LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		Map<String,Object> saveMap = new HashMap<String,Object>();
		saveMap.put("cateDispId", cateDispId);
		saveMap.put("cateId", cateId);
		saveMap.put("refCateSeq", refCateSeq);
		if(lastSt.equals("true")) {
			saveMap.put("lastSt", true);
			records = categorySvc.getDisplayCategoryListCnt(saveMap);
		} else {
			saveMap.put("lastSt", false);
		}
		saveMap.put("insertUserId", loginUserDto.getUserId());
		saveMap.put("remoteIp", loginUserDto.getRemoteIp());
		
		logger.debug("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^");
		logger.debug("cateDispId : "+cateDispId);
		logger.debug("cateId : "+cateId);
		logger.debug("refCateSeq : "+refCateSeq);
		logger.debug("lastSt : "+lastSt);
		logger.debug("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^");
		
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		try {
			if("add".equals(oper)) {
				if(records == 0) {
					categorySvc.regDisplayCategory(saveMap);
				}
			} else if("del".equals(oper)) {
				categorySvc.delDisplayCategory(saveMap);
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
	
	@RequestMapping("displayCategoryTreeJQGrid.sys")
	public ModelAndView displayCategoryTreeJQGrid(
			@RequestParam(value = "nodeid", defaultValue = "") String nodeid,
			@RequestParam(value = "srcCateDispId", defaultValue = "") String srcCateDispId,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		List<Map<String, Object>> returnList = new ArrayList<Map<String, Object>>();
		if(srcCateDispId!=null && !"".equals(srcCateDispId)) {
			if(nodeid==null || "".equals(nodeid)) {
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("cate_Disp_Id", srcCateDispId);
				params.put("cate_Id", "0");
				params.put("lastSt", false);
				List<CategoryDto> categoryList = categorySvc.getDisplayCategoryList(params);	// 상위카테고리Seq(1st)
				for(CategoryDto categoryDto : categoryList) {
					Map<String, Object> returnMap = new HashMap<String, Object>();
					returnMap.put("majo_Code_Name", categoryDto.getMajo_Code_Name());
					returnMap.put("mojo_Code_Desc", categoryDto.getMojo_Code_Desc());
					returnMap.put("ord_Num", categoryDto.getOrd_Num());
					returnMap.put("typeName", "1st");
					returnMap.put("treeKey", "2st∥"+categoryDto.getCate_Id());
					returnMap.put("level", 1);
					
					returnList.add(returnMap);
				}
			} else {
				String treeFlag = nodeid.split("∥")[0];
				String srcCateId = nodeid.split("∥")[1];
				if("2st".equals(treeFlag)) {
					Map<String, Object> params = new HashMap<String, Object>();
					params.put("cate_Disp_Id", srcCateDispId);
	    			params.put("cate_Id", srcCateId);
	    			params.put("lastSt", false);
					List<CategoryDto> categoryList2 = categorySvc.getDisplayCategoryList(params);	// 상위카테고리Seq(2st)
					for(CategoryDto categoryDto : categoryList2) {
						Map<String, Object> returnMap = new HashMap<String, Object>();
						returnMap.put("majo_Code_Name", categoryDto.getMajo_Code_Name());
						returnMap.put("mojo_Code_Desc", categoryDto.getMojo_Code_Desc());
						returnMap.put("ord_Num", categoryDto.getOrd_Num());
						returnMap.put("typeName", "2st");
						returnMap.put("treeKey", "3st∥"+categoryDto.getCate_Id());
						returnMap.put("parent", nodeid);
						returnMap.put("level", 2);
						
						returnList.add(returnMap);
					}
				} else if("3st".equals(treeFlag)) {
					Map<String, Object> params = new HashMap<String, Object>();
					params.put("cate_Disp_Id", srcCateDispId);
					params.put("cate_Id", srcCateId);
					params.put("lastSt", true);
					List<CategoryDto> categoryList3 = categorySvc.getDisplayCategoryList(params);	// 상위카테고리Seq(3st)
					for(CategoryDto categoryDto : categoryList3) {
						Map<String, Object> returnMap = new HashMap<String, Object>();
						returnMap.put("majo_Code_Name", categoryDto.getMajo_Code_Name());
						returnMap.put("mojo_Code_Desc", categoryDto.getMojo_Code_Desc());
						returnMap.put("ord_Num", categoryDto.getOrd_Num());
						returnMap.put("typeName", "3st");
						returnMap.put("treeKey", "4st∥"+categoryDto.getCate_Id());
						returnMap.put("parent", nodeid);
						returnMap.put("level", 3);
						returnMap.put("isLeaf", true);
						
						returnList.add(returnMap);
					}
//				} else if("4st".equals(treeFlag)) {
//					Map<String, Object> params = new HashMap<String, Object>();
//					params.put("cate_Disp_Id", srcCateDispId);
//					params.put("cate_Id", srcCateId);
//					params.put("lastSt", true);
//					List<CategoryDto> categoryList4 = categorySvc.getDisplayCategoryList(params);	// 상위카테고리Seq(4st)
//					for(CategoryDto categoryDto : categoryList4) {
//						Map<String, Object> returnMap = new HashMap<String, Object>();
//						returnMap.put("majo_Code_Name", categoryDto.getMajo_Code_Name());
//						returnMap.put("mojo_Code_Desc", categoryDto.getMojo_Code_Desc());
//						returnMap.put("ord_Num", categoryDto.getOrd_Num());
//						returnMap.put("typeName", "4st");
//						returnMap.put("treeKey", "5st∥"+categoryDto.getCate_Id());
//						returnMap.put("parent", nodeid);
//						returnMap.put("level", 3);
//						returnMap.put("isLeaf", true);
//						
//						returnList.add(returnMap);
//					}
				}
			}
		}
		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("treeList2",returnList);
		return modelAndView;
	}
	
	@RequestMapping("categoryBorgListJQGrid.sys")
	public ModelAndView categoryBorgListJQGrid(
			@RequestParam(value = "srcCateDispId", defaultValue = "") String srcCateDispId,
			@RequestParam(value = "sidx", defaultValue = "BORGNMS") String sidx,
			@RequestParam(value = "sord", defaultValue = "ASC") String sord,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("srcCateDispId", srcCateDispId);
		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
		
		List<CategoryDto> list = null;
		if(!"".equals(srcCateDispId)) {
			/*----------------페이징 세팅------------*/
	        int records = categorySvc.getCategoryBorgListCnt(params);
	        
	        /*----------------조회------------*/
	        if(records>0) {
	        	list = categorySvc.getCategoryBorgList(params);
	        }
        }
		
		modelAndView.setViewName("jsonView");
		modelAndView.addObject("list2", list);
		return modelAndView;
	}
	
	@RequestMapping("categoryBorgTransGrid.sys")
	public ModelAndView categoryBorgTransGrid(
			@RequestParam(value = "oper", required = true) String oper,
			@RequestParam(value = "cate_Disp_Id", defaultValue = "") String cateDispId,
			@RequestParam(value = "borgIdArr[]", defaultValue = "") String[] borgIdArr,
			@RequestParam(value = "groupIdArr[]", defaultValue = "") String[] groupIdArr,
			@RequestParam(value = "clientIdArr[]", defaultValue = "") String[] clientIdArr,
			@RequestParam(value = "branchIdArr[]", defaultValue = "") String[] branchIdArr,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		/*----------------저장값 세팅------------*/
		LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		Map<String,Object> saveMap = new HashMap<String,Object>();
		saveMap.put("cateDispId", cateDispId);
		saveMap.put("borgIdArr", borgIdArr);
		saveMap.put("groupIdArr", groupIdArr);
		saveMap.put("clientIdArr", clientIdArr);
		saveMap.put("branchIdArr", branchIdArr);
		saveMap.put("insertUserId", loginUserDto.getUserId());
		saveMap.put("remoteIp", loginUserDto.getRemoteIp());
		
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		try {
			if("add".equals(oper)) {
				String rtnMsg = categorySvc.regCategoryBorg(saveMap,custResponse);
				custResponse.setSuccess(true);
				custResponse.setMessage(rtnMsg);	//Option(To Detail Message)				
			} else if("del".equals(oper)) {
				categorySvc.delCategoryBorg(saveMap);
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
	
	@RequestMapping("categoryInfoListJQGrid.sys")
	public ModelAndView categoryInfoListJQGrid(
			@RequestParam(value = "page", defaultValue = "1") int page,
			@RequestParam(value = "rows", defaultValue = "10") int rows,
			@RequestParam(value = "sidx", defaultValue = "BORGNMS") String sidx,
			@RequestParam(value = "sord", defaultValue = "ASC") String sord,
			@RequestParam(value = "srcCateId", defaultValue = "0") String srcCateId,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("srcCateId", srcCateId);
		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
		
		List<CategoryDto> list = null;
		int records = 0;
		int total = 0;
		if(!"".equals(srcCateId)) {
			/*----------------페이징 세팅------------*/
	        records = categorySvc.getCategoryInfoListCnt(params);
	        total = (int)Math.ceil((float)records / (float)rows);
	        
	        /*----------------조회------------*/
	        if(records>0) {
	        	list = categorySvc.getCategoryInfoList(params, page, rows);
	        }
        }
		
		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("page", page);
		modelAndView.addObject("total", total);
		modelAndView.addObject("records", records);
		modelAndView.addObject("list", list);
		return modelAndView;
	}
	
//	@RequestMapping("categoryTreePop.sys")
//	public ModelAndView categoryTreePop(
//			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
//		return new ModelAndView("product/category/categoryTreePop");
//	}
	
	@RequestMapping("getStandardCategoryTreeJQ.sys")
	public ModelAndView getStandardCategoryTreeJQ(
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		modelAndView.setViewName("jsonView");
		modelAndView.addObject("standCategoryListInfo", categorySvc.getStandardCategoryList());
		return modelAndView;
	}
	
	@RequestMapping("getBuyerDisplayCategoryInfoListJQ.sys")
	public ModelAndView getBuyerDisplayCategoryInfoListJQ(
			@RequestParam(value = "schRefCateSeq", defaultValue = "0") String schRefCateSeq,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		/*----------------조회조건 세팅------------*/
		LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("schRefCateSeq", schRefCateSeq);
		params.put("groupId"  , loginUserDto.getGroupId());
		params.put("clientId"  , loginUserDto.getClientId());
		params.put("branchId"  , loginUserDto.getBorgId());
		
		logger.debug("getBuyerDisplayCategoryInfoListJQ Method Start  !!!! ");
		logger.debug("Search params "+params);
		modelAndView.setViewName("jsonView");
		modelAndView.addObject("displayCategoryListInfo", categorySvc.getBuyerDisplayCategoryInfoListJQ(params));
		return modelAndView;
	}
	
	@RequestMapping("getBuyerDisplayCategoryInfoAdmListJQ.sys")
	public ModelAndView getBuyerDisplayCategoryInfoAdmListJQ(
			@RequestParam(value = "schRefCateSeq", defaultValue = "0") String schRefCateSeq,
			@RequestParam(value = "_groupId", defaultValue = "0") String _groupId,
			@RequestParam(value = "_clientId", defaultValue = "0") String _clientId,
			@RequestParam(value = "_branchId", defaultValue = "0") String _branchId,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("schRefCateSeq", schRefCateSeq);
		params.put("groupId"  , _groupId);
		params.put("clientId"  , _clientId);
		params.put("branchId"  , _branchId);
		
		logger.debug("getBuyerDisplayCategoryInfoAdmListJQ Method Start  !!!! ");
		logger.debug("Search params "+params);
		modelAndView.setViewName("jsonView");
		modelAndView.addObject("displayCategoryListInfo", categorySvc.getBuyerDisplayCategoryInfoListJQ(params));
		return modelAndView;
	}
	
	/**
	 * (고객사)마이카테고리 추가 
	 * @param cate_id_Array
	 * @param request
	 * @param modelAndView
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("addBorgUserCateGoryTranJQ.sys")
	public ModelAndView addBorgUserCateGoryTranJQ(
			@RequestParam(value = "cate_id_Array[]", required = false) String[] cate_id_Array,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		/*----------------조회조건 세팅------------*/
		LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		Map<String, Object> params = new HashMap<String, Object>();
		
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		try {
			params.put("groupId"  		, loginUserDto.getGroupId()	);
			params.put("clientId"  		, loginUserDto.getClientId());
			params.put("branchId"  		, loginUserDto.getBorgId()	);
			params.put("cate_id_Array"	, cate_id_Array);
			params.put("userId"			, loginUserDto.getUserId()	);
			
			categorySvc.addBorgUserCateGory(params); 
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
	 * (고객사)마이카테고리 추가 
	 * @param cate_id_Array
	 * @param request
	 * @param modelAndView
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("delBorgUserCateGoryTranJQ.sys")
	public ModelAndView delBorgUserCateGoryTranJQ(
			@RequestParam(value = "cate_Id_Array[]", required = false) String[] cate_Id_Array,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		/*----------------조회조건 세팅------------*/
		LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		Map<String, Object> params = new HashMap<String, Object>();
		
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		try {
			params.put("groupId"  		, loginUserDto.getGroupId()	);
			params.put("clientId"  		, loginUserDto.getClientId());
			params.put("branchId"  		, loginUserDto.getBorgId()	);
			params.put("cate_Id_Array"	, cate_Id_Array);
			params.put("userId"			, loginUserDto.getUserId()	);
			
			categorySvc.delBorgUserCateGory(params); 
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
	 * 마이카테고리 페이지로 이동하는 메소드
	 */
	@RequestMapping("myCategoryList.sys")
	public ModelAndView getMyCategoryList(
			HttpServletRequest req, ModelAndView mav) throws Exception{
		mav.setViewName("product/category/myCategoryList");
		return mav;
	}
	
	/**
	 * 마이카테고리 페이지 리턴시켜주는 메소드
	 */
	@RequestMapping("myCategoryListJQGrid.sys")
	public ModelAndView myCategoryListJQGrid(
			@RequestParam(value = "page", defaultValue = "1") int page,
			@RequestParam(value = "rows", defaultValue = "10") int rows,
			@RequestParam(value = "sidx", defaultValue = "") String sidx,
			@RequestParam(value = "sord", defaultValue = "") String sord,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
			/*----------------조회조건 세팅------------*/
			LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("groupId" , loginUserDto.getGroupId());
			params.put("clientId" , loginUserDto.getClientId());
			params.put("branchId" , loginUserDto.getBorgId());
			
			
			/*----------------페이징 세팅------------*/
	        int records = categorySvc.getMyCategoryListCnt(params); //조회조건에 따른 카운트
	        int total = (int)Math.ceil((float)records / (float)rows);
			
	        /*----------------조회------------*/
	        List<CategoryDto> list = null;
	        if(records>0) list = categorySvc.getMyCategoryListInfo(params, page, rows);

			modelAndView = new ModelAndView("jsonView");
			modelAndView.addObject("page", page);
			modelAndView.addObject("total", total);
			modelAndView.addObject("records", records);
			modelAndView.addObject("list", list);
			return modelAndView;
		}
	
	
	/**
	 * 마이카테고리 페이지 리턴시켜주는 메소드
	 */
	@RequestMapping("getBuyerCategoryTreeJQ.sys")
	public ModelAndView getBuyerCategoryTreeJQ(
			@RequestParam(value = "groupId"	, defaultValue = "0") String groupId,
			@RequestParam(value = "clientId", defaultValue = "0") String clientId,
			@RequestParam(value = "branchId", defaultValue = "0") String branchId,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
			/*----------------조회조건 세팅------------*/
			LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
			Map<String, Object> params = new HashMap<String, Object>();
			
			logger.debug("groupId value ["+groupId+"]");
			logger.debug("clientId value ["+clientId+"]");
			logger.debug("branchId value ["+branchId+"]");
			
			params.put("groupId" 	, groupId );
			params.put("clientId" 	, clientId);
			params.put("branchId" 	, branchId);
			
			modelAndView.addObject("buyerCategoryDto"	, categorySvc.getBuyerDisplayCategoryInfoListJQ(params)	);
			modelAndView.setViewName("jsonView");
			
			return modelAndView;
		}
}
