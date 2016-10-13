package kr.co.bitcube.system.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import kr.co.bitcube.board.dto.BoardDto;
import kr.co.bitcube.common.dao.CommonDao;
import kr.co.bitcube.common.dao.GeneralDao;
import kr.co.bitcube.common.dto.BorgDto;
import kr.co.bitcube.common.dto.LoginUserDto;
import kr.co.bitcube.common.dto.UserDto;
import kr.co.bitcube.common.utils.Constances;
import kr.co.bitcube.organ.dto.SmpBranchsDto;
import kr.co.bitcube.organ.dto.SmpUsersDto;
import kr.co.bitcube.organ.dto.SmpVendorsDto;
import kr.co.bitcube.organ.service.OrganSvc;
import kr.co.bitcube.system.dao.BorgDao;
import kr.co.bitcube.system.dao.RoleDao;
import kr.co.bitcube.system.dto.RoleDto;

import org.apache.ibatis.session.RowBounds;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.ModelMap;

import egovframework.rte.fdl.idgnr.EgovIdGnrService;

@Service
public class BorgSvc {

	@Autowired
	private BorgDao borgDao;
	@Autowired
	private CommonDao commonDao;
	@Autowired
	private RoleDao roleDao;
	@Autowired
	private OrganSvc organSvc;
	
	@Autowired
	private GeneralDao generalDao;
	
	@Resource(name="seqMpBorgsService")
	private EgovIdGnrService seqMpBorgsService; // id 생성을 위해 추가

	@Resource(name="systemIdGenerationService")
	private EgovIdGnrService systemIdGenerationService;
	
	@Resource(name="seqContract")
	private EgovIdGnrService seqContract; // 물품공급 계약 시퀀스
	
	@Resource(name="seqContractList")
	private EgovIdGnrService seqContractList; // 물품공급 계약 시퀀스
	
	public List<BorgDto> getBorgTreeList( Map<String, Object> searchMap) {
		return borgDao.selectBorgTreeList(searchMap);
	}

	@Transactional(propagation=Propagation.REQUIRED, readOnly=false)
	public void regBorg(Map<String, Object> saveMap) throws Exception {
		int borgCdCnt = borgDao.selectBorgCdCnt((String)saveMap.get("borgCd"));
		if(borgCdCnt>0) { throw new Exception("입력하신 조직코드는 이미 등록되어 있습니다."); }
		saveMap.put("borgId", seqMpBorgsService.getNextStringId());
		borgDao.insertBorg(saveMap);
	}

	@Transactional(propagation=Propagation.REQUIRED, readOnly=false)
	public void modBorg(Map<String, Object> saveMap) {
		borgDao.updateBorg(saveMap);
	}

	@Transactional(propagation=Propagation.REQUIRED, readOnly=false)
	public void delBorg(Map<String, Object> saveMap) throws Exception {
		int subBorgCnt = borgDao.selectSubBorgCnt((String)saveMap.get("borgId"));
		if(subBorgCnt>0) { throw new Exception("하위조직이 존재하면 삭제가 불가합니다."); }
		borgDao.deleteBorg(saveMap);
	}

	public int getBorgUserListCnt(Map<String, Object> params) {
		return borgDao.selectBorgUserListCnt(params);
	}

	public List<UserDto> getBorgUserList(Map<String, Object> params, int page, int rows) {
		return borgDao.selectBorgUserList(params, page, rows);
	}

	public List<BorgDto> getManagedBorgList(Map<String, Object> params) {
		return borgDao.selectManagedBorgList(params);
	}

	@Transactional(propagation=Propagation.REQUIRED, readOnly=false)
	public void regBorgManager(Map<String, Object> saveMap) throws Exception {
		String[] manageBorgIdArray = (String[]) saveMap.get("manageBorgIdArray");
		for(String manageBorgId : manageBorgIdArray) {
			saveMap.put("adminBorgId", systemIdGenerationService.getNextStringId());
			saveMap.put("manageBorgId", manageBorgId);
			borgDao.insertAdminBorgs(saveMap);
		}
	}

	@Transactional(propagation=Propagation.REQUIRED, readOnly=false)
	public void delBorgManager(Map<String, Object> saveMap) throws Exception {
		borgDao.deleteAdminBorgs(saveMap);
	}

	/**
	 * 운영사용자을 시스템사용자로 추가등록
	 * @param saveMap
	 */
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false)
	public void regSysUser(Map<String, Object> saveMap) throws Exception {
		String svcTypeCd = (String)saveMap.get("svcTypeCd");
		commonDao.insertBorgUser(saveMap);	//smpborgs_users 등록
		Map<String, Object> srcParams = new HashMap<String, Object>();
		srcParams.put("srcSvcTypeCd", svcTypeCd);
		srcParams.put("srcIsUse", 1);
		srcParams.put("srcInitIsRole", 1);
		List<RoleDto> initRoleList = roleDao.selectRoleList(srcParams);	//svcTypeCd의 사용자 초기권한 리스트
		for(RoleDto roleDto : initRoleList) {
			saveMap.put("roleId", roleDto.getRoleId());
			saveMap.put("borgScopeCd", roleDto.getBorgScopeCd());
			
			commonDao.insertBorgUserRole(saveMap);	//smpborgs_users_roles 등록
		}
	}
	
	public int getSystemUserManagerListCnt(Map<String, Object> params) {
		return borgDao.selectSystemUserManagerListCnt(params);
	}
	
	public List<Map<String, Object>> getSystemUserManagerList(Map<String, Object> params, int page, int rows) {
		return borgDao.selectSystemUserManagerList(params, page, rows);
	}

	public int getSystemIfBorgsListCnt(Map<String, Object> params) {
		return borgDao.selectSystemIfBorgsListCnt(params);
	}

	public List<Map<String, Object>> getSystemIfBorgsList(Map<String, Object> params, int page, int rows) {
		return borgDao.selectSystemIfBorgsList(params, page, rows);
	}

	public void setIfBorgsHistory(Map<String, Object> saveMap) {
		borgDao.updateIfBorgsHistory(saveMap);
	}

	public int getContractCnt(Map<String, Object> params) {
		return borgDao.selectContractCnt(params);
	}

	public List<Map<String, Object>> getContractList(Map<String, Object> params, int page, int rows) {
		return borgDao.selectContractList(params, page, rows);
	}

	/**
	 * 물품공급계약서 등록
	 */
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false)
	public void systemContractSave(Map<String, Object> saveMap) throws Exception{
		String insertContractNo = seqContract.getNextStringId();
		saveMap.put("insertContractNo", insertContractNo);
		borgDao.insertCommodityContract(saveMap);
	}
	
	/**
	 * 물품공급계약서 JQGrid
	 */
	public List<Map<String, Object>> getCommodityContractList() {
		return borgDao.selectCommodityContractList();
	}
	
	/**
	 * 물품공급계약서 상세
	 */
	public Map<String, Object> getCommodityContractDetail(Map<String, Object> params) {
		return borgDao.selectCommodityContractDetail(params);
	}

	/**
	 * 물품공급계약서 수정
	 */
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false)
	public void systemContractMod(Map<String, Object> saveMap) throws Exception{
		borgDao.updateCommodityContract(saveMap);
	}
	
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false)
	public void systemContractDelete(Map<String, Object> saveMap) throws Exception{
		borgDao.deleteCommodityContract(saveMap);
	}

	/**
	 * 물품공급계약서 팝업화면
	 */
	public List<Map<String, Object>> getCommodityContractListPopup(Map<String, Object> params) {
		return borgDao.selectCommodityContractListPopup(params);
	}
	
	/**
	 * 고객사, 공급사에 물품공급 계약서 내용 출력
	 */
	public List<Map<String, Object>> getCommodityContractView(Map<String, Object> params) throws Exception{
		return borgDao.selectGetCommodityContractView(params);
	}

	/**
	 * 물품공급계약 등록 
	 */
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false)
	public void commodityContractSave(Map<String, Object> saveMap, LoginUserDto loginUserDto) throws Exception{
		String[] contractVersion = (String[])saveMap.get("contractVersionArray");
		String[] contractClassify = (String[])saveMap.get("contractClassifyArray");
		for(int i=0; i<contractVersion.length;i++){
			Map<String, Object> tempMap = new HashMap<String, Object>();
			tempMap.put("contractNo", seqContractList.getNextStringId());
			tempMap.put("contractVersion", contractVersion[i]);
			tempMap.put("contractClassify", contractClassify[i]);
			tempMap.put("loginId", loginUserDto.getLoginId());
			tempMap.put("userNm", loginUserDto.getUserNm());
			tempMap.put("borgId", loginUserDto.getBorgId());
			if("BUY".equals(loginUserDto.getSvcTypeCd())){
				tempMap.put("contractCustomerCd", loginUserDto.getSmpBranchsDto().getBranchCd());
			}else{
				tempMap.put("contractCustomerCd", loginUserDto.getSmpVendorsDto().getVendorCd());
			}
			borgDao.insertCommodityContractList(tempMap);
		}
	}

	/**
	 * 물품공급계약서 서명 중복 방지
	 */
	public List<Map<String, Object>> getCommodityContractListValidation(Map<String, Object> saveMap, LoginUserDto loginUserDto) {
		String[] contractVersion = (String[])saveMap.get("contractVersionArray");
		String[] contractClassify = (String[])saveMap.get("contractClassifyArray");
		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		for(int i=0; i<contractVersion.length;i++){
			Map<String, Object> tempMap = new HashMap<String, Object>();
			Map<String, Object> map = new HashMap<String, Object>();
			tempMap.put("contractVersion", contractVersion[i]);
			tempMap.put("contractClassify", contractClassify[i]);
			tempMap.put("loginId", loginUserDto.getLoginId());
			tempMap.put("userNm", loginUserDto.getUserNm());
			tempMap.put("borgId", loginUserDto.getBorgId());
			map = borgDao.selectCommodityContractListValidation(tempMap);
			list.add(map);
		}
		return list;
	}
	
	/**
	 * 구매사,공급사가 계약한 날짜받아오기
	 */
	public String getCommodityContractListDate(Map<String, Object> params) {
		return borgDao.selectCommodityContractListDate(params);
	}
	
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false)
	public void updateCommodityContractList(Map<String, Object> contractMap) throws Exception{
		borgDao.updateCommodityContractList(contractMap);
	}
	
	
	/**
	 * 계약서에 구매사 공급사 등록 여부 리턴
	 */
	public boolean getContractSignature(LoginUserDto userInfoDto){
		boolean signatureFlag = false;
		boolean isAdmMove = false;
		List<BorgDto> belongBorgList = userInfoDto.getBelongBorgList();
		for(BorgDto borgDto:belongBorgList) {
			if("13".equals(borgDto.getBorgId())) {
				isAdmMove = true;
				break;
			}
		}
		ModelMap paramMap = new ModelMap();
		paramMap.put("borgId", userInfoDto.getBorgId());
		paramMap.put("contractClassify", userInfoDto.getSvcTypeCd());
		int contractSignature = generalDao.selectGernalCount("system.borg.selctContractSignature", paramMap);
		if(contractSignature > 0 || isAdmMove){
			signatureFlag = true;
		}
		return signatureFlag;
	}

	public String getUserPassword(Map<String, Object> params) {
		return borgDao.selectUserPassword(params);
	}
	
	/**
	 * 계약서 Update 및 히스토리 테이블 insert
	 */
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false)
	public void contractSave(ModelMap modelMap) throws Exception{
		generalDao.updateGernal("system.borg.updateCommodityContractNew", modelMap);
		
		generalDao.insertGernal("system.borg.insertCommodityContractNewHist", modelMap);
	}

	/**
	 * 구매사,공급사 미서명 JQGrid
	 */
	public Map<String, Object> contractNoSign(ModelMap paramMap) throws Exception{
		Map<String, Object>	contractNoSignMap	= new HashMap<String, Object>();
		List <Object> contractNoSignList		= null;
		RowBounds rowBounds						= null;
		String				svcTypeCd			= paramMap.get("svcTypeCd").toString();
		String				sidx				= paramMap.get("sidx").toString();
		String				sord				= paramMap.get("sord").toString();
		String				orderString			= " " + sidx + " " + sord + " ";
		int					page				= paramMap.get("page") == null ? 1: Integer.parseInt(paramMap.get("page").toString()); 
		int					rows				= paramMap.get("rows") == null ? 15:Integer.parseInt(paramMap.get("rows").toString());
		int					records				= 0;
		int					total				= 0;
		paramMap.put("orderString", orderString);
		if("BUY".equals(svcTypeCd)){
			records = generalDao.selectGernalCount("system.borg.selectBranchContractNoSignList_count", paramMap);
			total = (int)Math.ceil((float)records / (float)rows);
			rowBounds = new RowBounds((page-1)*rows, rows);
			paramMap.put("rowBounds", rowBounds);
			contractNoSignList = generalDao.selectGernalList("system.borg.selectBranchContractNoSignList", paramMap);
		}else{
			records = generalDao.selectGernalCount("system.borg.selectVendorContractNoSignList_count", paramMap);
			total = (int)Math.ceil((float)records / (float)rows);
			rowBounds = new RowBounds((page-1)*rows, rows);
			paramMap.put("rowBounds", rowBounds);
			contractNoSignList = generalDao.selectGernalList("system.borg.selectVendorContractNoSignList", paramMap);
		}
		contractNoSignMap.put("page"	, page);
		contractNoSignMap.put("total"	, total);
		contractNoSignMap.put("records"	, records);
		contractNoSignMap.put("list"	, contractNoSignList);
		return contractNoSignMap;
	}

	public ArrayList<String> requestSapTrans(Map<String, Object> saveMap) throws Exception {
		ArrayList<String>	tranDescList	= new ArrayList<String>();	
		String   			tranDesc		= "";
		String[] 			borgIds 		= (String[])saveMap.get("borgIds");
		String[] 			svcTypeCds 		= (String[])saveMap.get("svcTypeCds");
		
		if(borgIds != null && borgIds.length > 0){
			
			Map<String, Object> sendMap 	= null;
			String	 			businessNum	= "";
			String				borgNm		= "";
			
			for(int i = 0 ; i < borgIds.length ; i++){
				sendMap = new HashMap<String, Object>();

				//업체 조회
				ModelMap paramMap = new ModelMap();
				if("BCH".equals(svcTypeCds[i])){
					paramMap.put("branchId", borgIds[i]);
					SmpBranchsDto bchDto = (SmpBranchsDto)generalDao.selectGernalObject("organ.selectOneBranchs", paramMap);
					
					//파라미터 셋팅
					businessNum = bchDto.getBusinessNum();
					borgNm		= bchDto.getClientNm();
					sendMap.put("businessNum"	, businessNum);
					sendMap.put("bankCd"		, bchDto.getBankCd());
					sendMap.put("accountNum"	, bchDto.getAccountNum());
					sendMap.put("recipient"		, bchDto.getRecipient());
					sendMap.put("clientNm"		, borgNm);
					sendMap.put("addres"		, bchDto.getAddres());
					sendMap.put("postAddrNum"	, bchDto.getPostAddrNum());
					sendMap.put("addresDesc"	, bchDto.getAddresDesc());
					sendMap.put("phoneNum"		, bchDto.getPhoneNum());
					sendMap.put("faxNum"		, bchDto.getFaxNum());
					sendMap.put("eMail"			, bchDto.getE_mail());
					sendMap.put("pressentNm"	, bchDto.getPressentNm());
					sendMap.put("bustClas"		, bchDto.getBranchBusiClas());
					sendMap.put("bustType"		, bchDto.getBranchBusiType());
					sendMap.put("payBillType"	, bchDto.getPayBilltype());
					
				}else if("VEN".equals(svcTypeCds[i])){
					paramMap.put("vendorId", borgIds[i]);
					SmpVendorsDto venDto = (SmpVendorsDto)generalDao.selectGernalObject("organ.selectOneVendors", paramMap);
					
					//파라미터 셋팅
					businessNum = venDto.getBusinessNum();
					borgNm		= venDto.getVendorNm();
					sendMap.put("businessNum"	, businessNum);
					sendMap.put("bankCd"		, venDto.getBankCd());
					sendMap.put("accountNum"	, venDto.getAccountNum());
					sendMap.put("recipient"		, venDto.getRecipient());
					sendMap.put("clientNm"		, borgNm);
					sendMap.put("addres"		, venDto.getAddres());
					sendMap.put("postAddrNum"	, venDto.getPostAddrNum());
					sendMap.put("addresDesc"	, venDto.getAddresDesc());
					sendMap.put("phoneNum"		, venDto.getPhoneNum());
					sendMap.put("faxNum"		, venDto.getFaxNum());
					sendMap.put("eMail"			, venDto.getE_mail());
					sendMap.put("pressentNm"	, venDto.getPressentNm());
					sendMap.put("bustClas"		, venDto.getVendorBusiClas());
					sendMap.put("bustType"		, venDto.getVendorBusiType());
					sendMap.put("payBillType"	, venDto.getPayBilltype());
				}
				//SAP전송
				String[] rtnResult = organSvc.sendComp(sendMap);
//				System.out.println("sendMap : > " + sendMap);
//				System.out.println("rtnResult[0] : "+rtnResult[0]);
//				System.out.println("rtnResult[1] : "+rtnResult[1]);
				
				if("F".equals(rtnResult[0])){
					//전송시 Error 발생할 경우 1번더 전송시도
					organSvc.sendComp(sendMap);
					tranDesc += "["+borgNm+"] "+rtnResult[1] + "<br/>";
				}else if("S".equals(rtnResult[0])){
					saveMap.put("borgId", businessNum);
					saveMap.put("transCd", "0");
					borgDao.updateIfBorgsHistory(saveMap);
				}
			}
			if("".equals(tranDesc))tranDesc = "처리하였습니다.";
//			System.out.println("tranDesc : "+tranDesc);
			tranDescList.add(tranDesc);
		}
		return tranDescList;
	}
}
