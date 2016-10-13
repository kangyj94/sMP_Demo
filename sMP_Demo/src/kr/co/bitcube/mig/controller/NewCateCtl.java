package kr.co.bitcube.mig.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import kr.co.bitcube.common.dto.LoginUserDto;
import kr.co.bitcube.common.utils.CommonUtils;
import kr.co.bitcube.common.utils.Constances;
import kr.co.bitcube.common.utils.CustomResponse;
import kr.co.bitcube.mig.dto.NewCateDto;
import kr.co.bitcube.mig.dto.NewCateProdDto;
import kr.co.bitcube.mig.service.NewCateSvc;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

@Controller
@RequestMapping("newCate")
public class NewCateCtl {
	private Logger logger = Logger.getLogger(getClass());
	@Autowired
	private NewCateSvc newCateSvc;
	
	@RequestMapping("categoryTreeJQGrid.sys")
	public ModelAndView categoryTreeJQGrid(
			@RequestParam(value = "nodeid", defaultValue = "") String nodeid,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		List<Map<String, Object>> returnList = new ArrayList<Map<String, Object>>();
		if(nodeid==null || "".equals(nodeid)) {
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("ref_Cate_Seq", "");
			params.put("cate_Level", "0");
			List<NewCateDto> categoryList = newCateSvc.getCateList(params);	// root
			for(NewCateDto categoryDto : categoryList) {
				Map<String, Object> returnMap = new HashMap<String, Object>();
				returnMap.put("majo_Code_Name", categoryDto.getMajo_Code_Name());
				returnMap.put("cate_Cd", categoryDto.getCate_Cd());
				returnMap.put("mojo_Code_Desc", categoryDto.getMojo_Code_Desc());
				returnMap.put("ord_Num", categoryDto.getOrd_Num());
				returnMap.put("typeName", "");
				returnMap.put("treeKey", "1st∥"+categoryDto.getCate_Id());
				returnMap.put("ref_Cate_Seq", categoryDto.getRef_Cate_Seq());
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
				List<NewCateDto> categoryList = newCateSvc.getCateList(params);	// 상위카테고리Seq(1st)
				for(NewCateDto categoryDto : categoryList) {
					Map<String, Object> returnMap = new HashMap<String, Object>();
					returnMap.put("majo_Code_Name", categoryDto.getMajo_Code_Name());
					returnMap.put("cate_Cd", categoryDto.getCate_Cd());
					returnMap.put("mojo_Code_Desc", categoryDto.getMojo_Code_Desc());
					returnMap.put("ord_Num", categoryDto.getOrd_Num());
					returnMap.put("typeName", "1st");
					returnMap.put("treeKey", "2st∥"+categoryDto.getCate_Id());
					returnMap.put("ref_Cate_Seq", categoryDto.getRef_Cate_Seq());
					returnMap.put("level", 1);
					
					returnList.add(returnMap);
				}
			} else if("2st".equals(treeFlag)) {
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ref_Cate_Seq", treeKey);
				params.put("cate_Level", "2");
				List<NewCateDto> categoryList2 = newCateSvc.getCateList(params);	// 상위카테고리Seq(2st)
				for(NewCateDto categoryDto : categoryList2) {
					Map<String, Object> returnMap = new HashMap<String, Object>();
					returnMap.put("majo_Code_Name", categoryDto.getMajo_Code_Name());
					returnMap.put("cate_Cd", categoryDto.getCate_Cd());
					returnMap.put("mojo_Code_Desc", categoryDto.getMojo_Code_Desc());
					returnMap.put("ord_Num", categoryDto.getOrd_Num());
					returnMap.put("typeName", "2st");
					returnMap.put("treeKey", "3st∥"+categoryDto.getCate_Id());
					returnMap.put("ref_Cate_Seq", categoryDto.getRef_Cate_Seq());
					returnMap.put("parent", nodeid);
					returnMap.put("level", 2);
					
					returnList.add(returnMap);
				}
			} else if("3st".equals(treeFlag)) {
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ref_Cate_Seq", treeKey);
				params.put("cate_Level", "3");
				List<NewCateDto> categoryList3 = newCateSvc.getCateList(params);	// 상위카테고리Seq(3st)
				for(NewCateDto categoryDto : categoryList3) {
					Map<String, Object> returnMap = new HashMap<String, Object>();
					returnMap.put("majo_Code_Name", categoryDto.getMajo_Code_Name());
					returnMap.put("cate_Cd", categoryDto.getCate_Cd());
					returnMap.put("mojo_Code_Desc", categoryDto.getMojo_Code_Desc());
					returnMap.put("ord_Num", categoryDto.getOrd_Num());
					returnMap.put("typeName", "3st");
					returnMap.put("treeKey", "4st∥"+categoryDto.getCate_Id());
					returnMap.put("ref_Cate_Seq", categoryDto.getRef_Cate_Seq());
					returnMap.put("parent", nodeid);
					returnMap.put("level", 3);
					returnMap.put("isLeaf", true);
					
					returnList.add(returnMap);
				}
			}
		}
		
		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("treeList",returnList);
		return modelAndView;
	}

	@RequestMapping("newCategoryMasterTransGrid.sys")
	public ModelAndView newCategoryMasterTransGrid(
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
				newCateSvc.regNewCategoryMaster(saveMap, custResponse);
			} else if("edit".equals(oper)) {
				saveMap.put("cateId", cateId.split("∥")[1]);
				newCateSvc.modNewCategoryMaster(saveMap);
			} else if("del".equals(oper)) {
				saveMap.put("cateId", cateId.split("∥")[1]);
				newCateSvc.delNewCategoryMaster(saveMap);
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

	/** 카테고리에 등록할 상품 조회 팝업 호출   */
	@RequestMapping("prodSearchForCateReg.sys")
	public ModelAndView prodSearchForCateReg(
			HttpServletRequest request, ModelAndView modelAndView) throws Exception{
		modelAndView.setViewName("jspViewResolver");
		modelAndView.setViewName("mig/prodSearchForNewCate");
		return modelAndView;
	}

	/** * 운영사 상품 검색 */
	@RequestMapping("productListJQGrid.sys")
	public ModelAndView productListJQGrid(
			@RequestParam(value = "page", defaultValue = "1") int page,
			@RequestParam(value = "rows", defaultValue = "30") int rows,
			@RequestParam(value = "sidx", defaultValue = "good_Name") String sidx,
			@RequestParam(value = "sord", defaultValue = "desc") String sord,
			@RequestParam(value = "srcCateId", defaultValue = "0") String srcCateId,
			@RequestParam(value = "srcGoodIdenNumb", defaultValue = "") String srcGoodIdenNumb,
			@RequestParam(value = "srcGoodName", defaultValue = "") String srcGoodName,
			@RequestParam(value = "srcInsertStartDate", defaultValue = "") String srcInsertStartDate,
			@RequestParam(value = "srcInsertEndDate", defaultValue = "") String srcInsertEndDate,
			@RequestParam(value = "srcGoodSpecDesc", defaultValue = "") String srcGoodSpecDesc,
			@RequestParam(value = "srcGoodSameWord", defaultValue = "") String srcGoodSameWord,
			@RequestParam(value = "srcGoodClasCode", defaultValue = "") String srcGoodClasCode,
			@RequestParam(value = "srcIsUse", defaultValue = "") String srcIsUse,
			@RequestParam(value = "srcGroupId", defaultValue = "0") String srcGroupId,
			@RequestParam(value = "srcProductManager", defaultValue = "") String srcProductManager,				//상품담당자
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		//----------------조회조건 세팅------------/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("srcCateId", srcCateId);
		params.put("srcGoodIdenNumb", srcGoodIdenNumb);
		params.put("srcGoodName", srcGoodName);
		params.put("srcInsertStartDate", srcInsertStartDate);
		params.put("srcInsertEndDate", srcInsertEndDate);
		params.put("srcGoodSpecDesc", srcGoodSpecDesc);
		params.put("srcGoodSameWord", srcGoodSameWord);
		params.put("srcGoodClasCode", srcGoodClasCode);
		params.put("srcIsUse", srcIsUse);
		params.put("srcGroupId", srcGroupId);
		params.put("srcProductManager", srcProductManager);
		String table = "";
		
		String orderString = " " + table + sidx + " " + sord + " ";
		params.put("orderString", orderString);

		
		logger.debug("params value ["+params+"]");
		//----------------페이징 세팅------------/
		int records = newCateSvc.getProductListCnt(params); //조회조건에 따른 카운트
		int total = (int)Math.ceil((float)records / (float)rows);
		
		//----------------조회------------/
		List<NewCateProdDto> list = null;
		if(records>0) {
			list = newCateSvc.getProductList(params, page, rows);
//			for(int i=0; i<list.size(); i++){
//				//상품표준 규격
//				String[] tmpGoodStSpecDescArr = new String[] {"","","","","",""};
//				if(list.get(i).getGood_St_Spec_Desc() != null && list.get(i).getGood_St_Spec_Desc() != ""){
//					String[] goodStSpecDescArr = list.get(i).getGood_St_Spec_Desc().split("‡");
//					
//					for(int j=0; j<goodStSpecDescArr.length; j++){
//						tmpGoodStSpecDescArr[j] = goodStSpecDescArr[j];
						
						
//					}
//					goodStSpecDescArr = tmpGoodStSpecDescArr;
//					list.get(i).setGoodStSpecDesc1(goodStSpecDescArr[0]);
//					list.get(i).setGoodStSpecDesc2(goodStSpecDescArr[1]);
//					list.get(i).setGoodStSpecDesc3(goodStSpecDescArr[2]);
//					list.get(i).setGoodStSpecDesc4(goodStSpecDescArr[3]);
//					list.get(i).setGoodStSpecDesc5(goodStSpecDescArr[4]);
//					list.get(i).setGoodStSpecDesc6(goodStSpecDescArr[5]);
//				}
//				
//				//상품규격
//				String[] tmpGoodSpecDescArr = new String[] {"","","","","","","",""};
//				if(list.get(i).getGood_Spec_Desc() != null && list.get(i).getGood_Spec_Desc() != ""){
//					String[] goodSpecDescArr = list.get(i).getGood_Spec_Desc().split("‡");
//					for(int j=0; j<goodSpecDescArr.length; j++){
//						tmpGoodSpecDescArr[j] = goodSpecDescArr[j];
						
//					}
//					goodSpecDescArr = tmpGoodSpecDescArr;
//					list.get(i).setGoodSpecDesc1(goodSpecDescArr[0]);
//					list.get(i).setGoodSpecDesc2(goodSpecDescArr[1]);
//					list.get(i).setGoodSpecDesc3(goodSpecDescArr[2]);
//					list.get(i).setGoodSpecDesc4(goodSpecDescArr[3]);
//					list.get(i).setGoodSpecDesc5(goodSpecDescArr[4]);
//					list.get(i).setGoodSpecDesc6(goodSpecDescArr[5]);
//					list.get(i).setGoodSpecDesc7(goodSpecDescArr[6]);
//					list.get(i).setGoodSpecDesc8(goodSpecDescArr[7]);
//				}
//				
//			}
		}
		
		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("page", page);
		modelAndView.addObject("total", total);
		modelAndView.addObject("records", records);
		modelAndView.addObject("list", list);
		return modelAndView;
	}

	@RequestMapping("saveProdInfo.sys")
	public ModelAndView saveProdInfo(
			@RequestParam(value = "treeKey", defaultValue = "0") String treeKey,
			@RequestParam(value = "prod_key_array[]", required=true) String[] prod_key_array,
			@RequestParam(value = "isReg_array[]", required=true) String[] isReg_array,
			ModelAndView modelAndView, HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		/*----------------저장값 세팅------------*/
		LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		Map<String,Object> saveMap = new HashMap<String,Object>();
		saveMap.put("treeKey", treeKey);
		saveMap.put("prod_key_array", prod_key_array);
		saveMap.put("isReg_array", isReg_array);
		saveMap.put("insertUserId", loginUserDto.getUserId());
		
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		String rtnMsg = "";
		try {
			rtnMsg = newCateSvc.saveProdInfo(saveMap);
			if("".equals(rtnMsg) == false){
				throw new Exception();
			}
		} catch(Exception e) {
			logger.error("Exception : "+e);
			custResponse.setSuccess(false);
			custResponse.setMessage(rtnMsg);
			custResponse.setMessage(CommonUtils.getErrSubString(e,50));	//Option(To Detail Message)
		}
		
		modelAndView.setViewName("jsonView");
		modelAndView.addObject(custResponse);
		return modelAndView;
	}

	@RequestMapping("selectCateGoods.sys")
	public ModelAndView selectCateGoods(
			@RequestParam(value = "keyVal", defaultValue = "") String keyVal,
			@RequestParam(value = "sidx", defaultValue = "good_Name") String sidx,
			@RequestParam(value = "sord", defaultValue = "desc") String sord,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("keyVal", keyVal);
		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
		List<NewCateProdDto> list = newCateSvc.selectCateGoods(params);
		
		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("list",list);
		return modelAndView;
	}
}
