<%@page import="kr.co.bitcube.common.dto.WorkInfoDto"%>
<%@page import="kr.co.bitcube.common.dto.UserDto"%>
<%@page import="crosscert.Hash"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="kr.co.bitcube.common.dto.CodesDto" %>
<%@ page import="kr.co.bitcube.organ.dto.SmpBranchsDto"%>
<%@ page import="kr.co.bitcube.common.dto.LoginUserDto" %>
<%@ page import="kr.co.bitcube.common.dto.SrcBorgScopeByRoleDto" %>
<%@ page import="java.util.List"%>

<%
	LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);

	//그리드의 width와 Height을 정의
	
	String listHeight =	"$(window).height()-220 + Number(gridHeightResizePlus)";
// 	if("ADM".equals(loginUserDto.getSvcTypeCd())){
		listHeight = "$(window).height()-248 + Number(gridHeightResizePlus)";
// 	}

	@SuppressWarnings("unchecked")	//화면권한가져오기(필수)
	List<ActivitiesDto> roleList = (List<ActivitiesDto>)request.getAttribute("useActivityList");
	LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
	String _menuId = "".equals(CommonUtils.getString(request.getParameter("_menuId"))) ? CommonUtils.getString(request.getAttribute("_menuId")) : CommonUtils.getString(request.getParameter("_menuId"));
	
	String businessNum = "";
	if(loginUserDto.getSmpBranchsDto() != null)	businessNum = CommonUtils.getString(loginUserDto.getSmpBranchsDto().getBusinessNum());
	
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>


<% if(Constances.COMMON_ISREAL_SERVER) { %>
<%
/**------------------------------------공인인증 등록---------------------------------
  파라미터1 : 법인 (CLT), 공급사 (VEN)
  파라미터2 : 사용구분 (REG : 업체등록, ETC : 기타)
  파라미터3 : 공인인증서 인증상태 (0 : 등록, 1 : 생성, 2 : 무시), 공통함수사용
  파라미터4 : 사업자 등록번호 (인증상태값이 1인 경우에만 사용한다. 1이 아닌경우 '' 으로 넘긴다.)
  파라미터5 : CallBack function명
  파라미터6 : 조직ID (법인일경우 ClientId, 사업장일경우 VendorId) 
*/
%>
<%@ include file="/WEB-INF/jsp/common/auth/authBusinessNumberDiv.jsp" %>
<script type="text/javascript">
var authStep = "";
function fnAuth(){
	//fnGetIsExistPublishAuth(svcTypeCd, borgId) - 현재 세션의 공인인증서 인증상태를 확인 (파라미터3 참조)
	authStep = fnGetIsExistPublishAuth('<%=loginUserDto.getSvcTypeCd()%>','<%=loginUserDto.getBorgId()%>');
	fnAuthBusinessNumberDialog("CLT", "ETC", authStep, '<%=businessNum%>',"fnCallBackAuthBusinessNumber", '<%=loginUserDto.getClientId()%>');
}

function fnCallBackAuthBusinessNumber(userDn) {
	if((userDn != "" && userDn != null) || authStep == "2"){
		
		if("A" == $.trim($("#authMode").val())){
			addRow();
		}else if("D" == $.trim($("#authMode").val())){
			onDetail();
		}
	}
}
</script>
<% //------------------------------------------------------------------------------ %>

<%	}else{ %>
<script type="text/javascript">
function fnAuth(){
	if("A" == $.trim($("#authMode").val())){
		addRow();
	}else if("D" == $.trim($("#authMode").val())){
		onDetail();
	}
}		
</script>
<%	} %> 	

<%
/**------------------------------------구매사팝업 사용방법---------------------------------
* fnBuyborgDialog(borgType, isFixed, borgNm, callbackString) 을 호출하여 Div팝업을 Display ===
* borgType : 구매사조직유형("":전체, "GRP":그룹, "CLT":법인, "BCH":사업장)
* isFixed : 구매사조직유형 고정여부("":아니오, "1":예)
* borgNm : 찾고자하는 구매사명
* callbackString : 콜백함수(문자열), 콜백함수파라메타는 5개(그룹일련번호, 법인일련번호, 사업장일련번호, 조직명String, 권역코드) 
*/
%>
<%@ include file="/WEB-INF/jsp/common/buyBorgListDiv.jsp" %>
<!-- 구매사검색관련 스크립트 -->
<script type="text/javascript">
$(document).ready(function(){
<%
	String _srcGroupId = "";
	String _srcClientId = "";
	String _srcBranchId = "";
	String _srcBorgNms = "";
	SrcBorgScopeByRoleDto _srcBorgScopeByRoleDto = null;
	if("BUY".equals(loginUserDto.getSvcTypeCd())) {
		_srcBorgScopeByRoleDto = loginUserDto.getSrcBorgScopeByRoleDto();
		_srcGroupId = _srcBorgScopeByRoleDto.getSrcGroupId();
		_srcClientId = _srcBorgScopeByRoleDto.getSrcClientId();
		_srcBranchId = _srcBorgScopeByRoleDto.getSrcBranchId();
		_srcBorgNms = _srcBorgScopeByRoleDto.getSrcBorgNms();
		_srcBorgNms = _srcBorgNms.replaceAll("&gt;", ">");
	}
%>
	$("#srcGroupId").val("<%=_srcGroupId %>");
	$("#srcClientId").val("<%=_srcClientId %>");
	$("#srcBranchId").val("<%=_srcBranchId %>");
	$("#srcBorgName").val("<%=_srcBorgNms %>");
<%	if("BUY".equals(loginUserDto.getSvcTypeCd())) {	%>
	$("#srcBorgName").attr("disabled", true);
	$("#btnBuyBorg").css("display","none");
<%	}	%>
	
	$("#btnBuyBorg").click(function(){
		
		var borgNm = $("#srcBorgName").val();
		fnBuyborgDialog("BCH", "1", "", "fnCallBackBuyBorg"); 
	});
	$("#srcBorgName").keydown(function(e){ if(e.keyCode==13) { $("#btnBuyBorg").click(); } });
	$("#srcBorgName").change(function(e){
		if($("#srcBorgName").val()=="") {
			$("#srcGroupId").val("");
			$("#srcClientId").val("");
			$("#srcBranchId").val("");
		}
	});
});
/**
 * 조직팝업검색후 선택한 값 세팅
 */
function fnCallBackBuyBorg(groupId, clientId, branchId, borgNm, areaType) {
	$("#srcGroupId").val(groupId);
	$("#srcClientId").val(clientId);
	$("#srcBranchId").val(branchId);
	$("#srcBorgName").val(borgNm);
}

/**
 * ','3자리 마다 콤마넣기
 * @param obj
 */
function commaNum(num) {   
    var len, point, str;   

    num = num + "";   
    point = num.length % 3;   
    len = num.length;   

    str = num.substring(0, point);   
    while (point < len) {   
        if (str != "") str += ",";   
        str += num.substring(point, point + 3);   
        point += 3;   
    }   
    return str;   
} 
/**
 * ','3자리 마다 콤마넣기
 * @param obj
 */
function commaNum1(num, options, rowObject) {   
    var len, point, str;   

    num = num + "";   
    point = num.length % 3;   
    len = num.length;   

    str = num.substring(0, point);   
    while (point < len) {   
        if (str != "") str += ",";   
        str += num.substring(point, point + 3);   
        point += 3;   
    }   
    return str;   
} 


</script>
<% //------------------------------------------------------------------------------ %>

<!-- 버튼 이벤트 스크립트 -->
<script type="text/javascript">
var jq = jQuery;
$(document).ready(function() {
	$.post(	//조회조건의 회원사등급 세팅
		'<%=Constances.SYSTEM_CONTEXT_PATH %>/common/getCodeList.sys',
		{codeTypeCd:"MEMBERGRADE", isUse:"1"},
		function(arg){
			var codeList = eval('(' + arg + ')').codeList;
			for(var i=0;i<codeList.length;i++) {
				$("#srcBranchGrad").append("<option value='"+codeList[i].codeVal1+"'>"+codeList[i].codeNm1+"</option>");
			}
			$.post(	//조회조건의 권역세팅
				'<%=Constances.SYSTEM_CONTEXT_PATH %>/common/getCodeList.sys',
				{codeTypeCd:"DELI_AREA_CODE", isUse:"1"},
				function(arg){
					var codeList = eval('(' + arg + ')').codeList;
					for(var i=0;i<codeList.length;i++) {
						if(codeList[i].codeVal1!="99") {
							$("#srcAreaType").append("<option value='"+codeList[i].codeVal1+"'>"+codeList[i].codeNm1+"</option>");
						}
					}
					initList();	//그리드 초기화
				}
			);
		}
	);
	$("#srcButton").click( function() { 
		fnSearch(); 
	});
<%if(loginUserDto.getSvcTypeCd().equals("ADM")){%>
	$("#srcBorgNameLike").keydown(function(e){
		if(e.keyCode==13) {
			$("#srcButton").click();
		}
	});
<%}%>
	$("#srcBranchGrad").keydown(function(e){
		if(e.keyCode==13) {
			$("#srcButton").click();
		}
	});
	$("#srcAreaType").keydown(function(e){
		if(e.keyCode==13) {
			$("#srcButton").click();
		}
	});
	$("#srcIsUse").keydown(function(e){
		if(e.keyCode==13) {
			$("#srcButton").click();
		}
	});
	$("#srcButton").click( function() { fnSearch(); });
	$("#colButton").click( function() { jq("#list").jqGrid('columnChooser'); });
	$("#excelButton").click(function(){ exportExcel(); });
	$("#excelAll").click(function(){ exportExcelToSvc(); });
	$("#modButton").click(function(){ 
		$("#authMode").val("D");
		fnAuth(); 
	});
//	$("#regButton").click(function(){ addRow(); });
	$("#regButton").click(function(){ 
		$("#authMode").val("A");
		fnAuth(); 
	});
});

//리사이징
$(window).bind('resize', function() { 
	$("#list").setGridHeight(<%=listHeight %>);
    $("#list").setGridWidth($(window).width()-60 + Number(gridWidthResizePlus));
}).trigger('resize');  
</script>

<!-- 그리드 초기화 스크립트 -->
<%-- to-be :  아래 그리드 부분 적절히 수정할것. --%>
<script type="text/javascript">
function initList() {
	jq("#list").jqGrid({
		url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/analysis/analysisBondsCorpListJQGrid.sys',
		datatype: 'json',
		mtype: 'POST',
		colNames:['사업장명', '사업자등록번호', '채권담당자','미수금액', '관리채권 기준일 ', '기준일(60일) 대비 초과일수', '세금계산서 발행대비 경과일수', '채권구분'],
		colModel:[
			{name:'branchnm',index:'branchnm', width:250,align:"left",search:false,sortable:true,
				editable:false 
			},	//사업장명
			{name:'businessnum',index:'businessnum', width:90,align:"center",search:false,sortable:true,
				editable:false 
			},	//사업자등록번호
			{name:'usernm',index:'usernm', width:90,align:"center",search:false,sortable:true,
				editable:false 
			},	//채권담당자
			{name:'sum_amou',index:'sum_amou', width:80,align:"right",search:false,sortable:true,
				editable:false
			},	//미수금액
			{name:'clos_sale_date',index:'clos_sale_date', width:150,align:"center",search:false,sortable:true,
				editable:false 
			},	//관리채권 기준일
			{name:'st_over_date',index:'st_over_date', width:150,align:"center",search:false,sortable:true,
				editable:false 
			},	//기준일 대비 초과일수
			{name:'clos_over_date',index:'clos_over_date', width:170,align:"center",search:false,sortable:true,
				editable:false
			},	//세금계산서 발행대비 경과일수
			{name:'rece_name',index:'rece_name', width:80,align:"center",search:false,sortable:true,
				editable:false 
			}	//채권 구분
		],
		postData: {
		},
		rowNum:30, rownumbers: false, rowList:[30,50,100,500,1000,5000], pager: '#pager',
		height: <%=listHeight%>,autowidth: true,
		sortname: 'clos_sale_date', sortorder: "desc",
		caption:"채권관리업체", 
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,	//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete: function() {
			var rowCnt = jq("#list").getGridParam('reccount');
			if(rowCnt>0) {
				var top_rowid = $("#list").getDataIDs()[0];	//첫번째 로우 아이디 구하기
				var selrowContent = jq("#list").jqGrid('getRowData',top_rowid);
				jq("#list").setSelection(top_rowid);
			}
			var sum = 0;
			if(rowCnt > 0){
				for(var i=0; i<rowCnt; i++) {
					var rowid = $("#list").getDataIDs()[i];
					sum += Number(jq("#list").jqGrid('getRowData',rowid)['sum_amou']);
				}
			}
			$("#innerTotalCnt").html(commaNum(sum));
			
		},
		onSelectRow: function (rowid, iRow, iCol, e) {},
		ondblClickRow: function (rowid, iRow, iCol, e) {
			$("#authMode").val("D");
			<%=CommonUtils.isDisplayRole(roleList, "COMM_READ","fnAuth();")%>
		},
		onCellSelect: function(rowid, iCol, cellcontent, target){},
		loadError : function(xhr, st, str){ $("#list").html(xhr.responseText); },
		jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"}
	}); 
}
</script>

<!-- 그리드 이벤트 스크립트 -->
<script type="text/javascript">
function fnSearch() {
	jq("#list").jqGrid("setGridParam", {"page":1});
	var data = jq("#list").jqGrid("getGridParam", "postData");
	data.srcAccUser = $("#srcAccUser").val();
	data.srcBranchId = $("#srcBranchId").val();
	data.srcBondDiv = $("#srcBondDiv").val();
	jq("#list").jqGrid("setGridParam", { "postData": data });
	jq("#list").trigger("reloadGrid");
}

/**
 * list Excel Export
 */
function exportExcel() {
	var colLabels = ['사업장명','사업자등록번호','채권담당자','미수금액' ,'관리채권 기준일','기준일 대비 초과일수','세금계산서 발행대비 경과일','채권구분'];
	var colIds = ['branchnm','businessnum','usernm','sum_amou','clos_sale_date','st_over_date','clos_over_date','rece_name'];	//출력컬럼ID
	var numColIds = [];	//숫자표현ID
	var figureColIds = ['businessnum'];
	var sheetTitle = "사업장 조회";	//sheet 타이틀
	var excelFileName = "AnalysisBondsCorpList";	//file명
	
	fnExportExcel(jq("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>", figureColIds);	//Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
}

function exportExcelToSvc() {
	var colLabels = ['사업장명','사업자등록번호','채권담당자','미수금액' ,'관리채권 기준일','기준일 대비 초과일수','세금계산서 발행대비 경과일','채권구분'];
	var colIds = ['branchnm','businessnum','usernm','sum_amou','clos_sale_date','st_over_date','clos_over_date','rece_name'];	//출력컬럼ID
	var numColIds = [];	//숫자표현ID
	var figureColIds = ['businessnum'];
	var sheetTitle = "사업장 조회";	//sheet 타이틀
	var excelFileName = "allAnalysisBondsCorpList";	//file명
	
	var actionUrl = "/analysis/analysisBondsCorpListExcel.sys";
	var fieldSearchParamArray = new Array();
	fieldSearchParamArray[0] = 'srcAccUser';
	fieldSearchParamArray[1] = 'srcBranchId';
	fieldSearchParamArray[2] = 'srcBondDiv';
// 	fieldSearchParamArray[3] = 
// 	fieldSearchParamArray[4] = 
// 	fieldSearchParamArray[5] = 
// 	fieldSearchParamArray[6] = 
// 	fieldSearchParamArray[7] = 
	fnExportExcelToSvc(jq("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>",fieldSearchParamArray, actionUrl, figureColIds);	//Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
}

function onDetail(){
	var row = jq("#list").jqGrid('getGridParam','selrow'); // 선택된 로우 조회
	if( row != null ){
		var selrowContent = jq("#list").jqGrid('getRowData',row);        // 선택된 로우의 데이터 객체 조회
		var popurl = "/organ/organBranchDetail.sys?branchId=" + selrowContent.branchId + "&clientId=" + selrowContent.clientId+"&_menuId=<%=_menuId %>";
		var popproperty = "dialogWidth:920px;dialogHeight=800px;scroll=yes;status=no;resizable=no;";
	    //window.showModalDialog(popurl,self,popproperty);
	    window.open(popurl, 'okplazaPop', 'width=920, height=800, scrollbars=yes, status=no, resizable=no');
	} else { jq( "#dialogSelectRow" ).dialog(); }	
}

// function addRow(){
<%-- 	var popurl = "/organ/organBranchReg.sys?_menuId=<%=_menuId %>"; --%>
// 	var popproperty = "dialogWidth:950px;dialogHeight=850px;scroll=yes;status=no;resizable=no;";
// //     window.showModalDialog(popurl,self,popproperty);
//     window.open(popurl, 'okplazaPop', 'width=950, height=850, scrollbars=yes, status=no, resizable=no');
// }
</script>

</head>
<body>
<form id="frm" name="frm">
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td>
				<!-- 타이틀 시작 -->
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr valign="top">
						<td width="20" valign="middle"><img src="/img/system/bullet_ptitle1.gif" width="14" height="15" /></td>
						<td height="29" class='ptitle'>채권관리업체</td>
						<td align="right">
							<a href="#">
								<img id="excelAll" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type3_orderResultExcel.gif" height="22" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>' />
								<img id="srcButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type3_search.gif" height="22" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>' />
							</a>
						</td>
					</tr>
				</table> 
				<!-- 타이틀 끝 -->
			</td>
		</tr>
		<tr>
			<td>
				<!-- 컨텐츠 시작 -->
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td colspan="8" class="table_top_line"></td>
					</tr>
					<tr>
						<td class="table_td_subject" width="100">사업장명</td>
						<td class="table_td_contents">
							<input id="srcBorgName" name="srcBorgName" type="text" value="" size="20" maxlength="30" style="width: 300px" />
							<input id="srcGroupId" name="srcGroupId" type="hidden" value=""/>
							<input id="srcClientId" name="srcClientId" type="hidden" value=""/>
							<input id="srcBranchId" name="srcBranchId" type="hidden" value=""/>
							<input id="authMode" name="authMode" type="hidden" value=""/>
							<a href="#">
							<img id="btnBuyBorg" src="/img/system/btn_icon_search.gif" width="20" height="18" style="vertical-align: middle;border: 0px;" />
							</a>
    					</td>
<!--     				</tr> -->
<!-- 					<tr> -->
<!-- 						<td colspan="6" height="1" bgcolor="eaeaea"></td> -->
<!-- 					</tr> -->
<!-- 					<tr> -->
						<td class="table_td_subject" width="100">채권담당자</td>
						<td class="table_td_contents">
							<select id="srcAccUser" name="srcAccUser" style="width: 70px;" class="select">
                        	<option value="">전체</option>
<%	@SuppressWarnings("unchecked")
List<UserDto> admUserList = (List<UserDto>) request.getAttribute("admUserList");

	if(admUserList != null && admUserList.size() > 0 ){
		for(UserDto userDto : admUserList){
%>	
                        	<option value="<%=userDto.getUserId()%>" ><%=userDto.getUserNm() %></option>
<%							
		}
	}	
%>                        
                        </select>
    					</td>
<!--     				</tr> -->
<!-- 					<tr> -->
<!-- 						<td colspan="6" height="1" bgcolor="eaeaea"></td> -->
<!-- 					</tr> -->
<!-- 					<tr> -->
						<td class="table_td_subject" width="100">채권구분</td>
						<td class="table_td_contents">
							<select id="srcBondDiv" name="srcBondDiv" class="select"> 
								<option value="">전체</option> 
								<option value="장기채권">장기채권</option> 
								<option value="관리채권">관리채권</option> 
								<option value="이관채권">이관채권</option> 
							</select>
    					</td>
    				</tr>
					<tr>
						<td colspan="8" class="table_top_line"></td>
					</tr>
				</table> <!-- 컨텐츠 끝 -->
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td align="right">
			&nbsp;<font size="2" style="font-weight:bold;">합계금액&nbsp;:&nbsp;<span id="innerTotalCnt"></span></font>
				<a href="#"><img id="regButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Add.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>' /></a>
				<a href="#"><img id="modButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Modify.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>' /></a>
				<a href="#"><img id="colButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Equipment.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>' /></a>
				<a href="#"><img id="excelButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Table.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>' /></a>
			</td>
		</tr>
		<tr>
			<td>
				<div id="jqgrid">
					<table id="list"></table>
					<div id="pager"></div>
				</div>
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
		</tr>
	</table>
	<div id="dialogSelectRow" title="Warning" style="display:none;font-size: 12px;color: red;">
		<p>처리할 데이터를 선택 하십시오!</p>
	</div>
</form>
</body>
</html>