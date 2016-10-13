<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="kr.co.bitcube.common.dto.CodesDto" %>
<%@ page import="kr.co.bitcube.common.dto.SrcBorgScopeByRoleDto" %>
<%@ page import="kr.co.bitcube.common.dto.LoginUserDto" %>
<%@ page import="java.util.List"%>
<%@ page import="kr.co.bitcube.common.dto.UserDto" %>
<%@ page import="kr.co.bitcube.organ.dto.SmpUsersDto"%>
<%@ page import="kr.co.bitcube.common.dto.LoginRoleDto"%>
<%
	String _menuId = "".equals(CommonUtils.getString(request.getParameter("_menuId"))) ? CommonUtils.getString(request.getAttribute("_menuId")) : CommonUtils.getString(request.getParameter("_menuId"));
	LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
	List<ActivitiesDto> roleList = (List<ActivitiesDto>)request.getAttribute("useActivityList");
	
	String listHeight = "$(window).height()-300 + Number(gridHeightResizePlus)";
	String listWidth  = "460";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>
<style type="text/css">
html,body {
 height: 100%
}

.jqmPop{
	display: none;
	position: fixed;
	top: 17%;
	left: 50%;
	margin-left: -300px;
	width: 0px;
	background-color: #EEE;
	color: #333;
}
.jqmOverlay { background-color: #000; }
* html .jqmPop {
     position: absolute;
     top: expression((document.documentElement.scrollTop || document.body.scrollTop) + Math.round(17 * (document.documentElement.offsetHeight || document.body.clientHeight) / 100) + 'px');
}
</style>
</head>
<jsp:include page="/WEB-INF/jsp/system/treeFrame/adminMenu.jsp" flush="false" />
<form id="frm" name="frm" onsubmit="return false;" method="post">
<input type="hidden" id="belongBorgId" name="belongBorgId"/>
<input type="hidden" id="belongSvcTypeCd" name="belongSvcTypeCd"/>
<input type="hidden" id="moveUserId" name="moveUserId"/>
	
<input type="hidden" id="adminUserId" name="adminUserId"/>
<input type="hidden" id="adminBorgId" name="adminBorgId"/>
<input type="hidden" id="adminBorgNm" name="adminBorgNm"/>
<input type="hidden" id="adminSvcTypeCd" name="adminSvcTypeCd"/>

<table width="1500px" style="margin-left: 0px;" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td align="center">
			<!-- 타이틀 시작 -->
			<table width="1000px" border="0" cellspacing="0" cellpadding="0">
				<tr valign="top">
					<td width="20" valign="middle"><img src="/img/system/bullet_ptitle1.gif" width="14" height="15" /></td>
					<td height="29" class='ptitle' align="left">구매요청
					</td>
					<td align="right" class='ptitle'>
						<button id='srcButton' class="btn btn-primary btn-sm" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>"><i class="fa fa-search"></i> 조회</button>
					</td>
				</tr>
			</table> <!-- 타이틀 끝 -->
		</td>
	</tr>
	<tr>
		<td height="5"></td>
	</tr>
	<tr>
		<td align="center">
			<!-- 컨텐츠 시작 -->
			<table width="1000px" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td colspan="6" class="table_top_line"></td>
				</tr>
				<tr>
					<td width="100" class="table_td_subject" style="width: 100px">구매사</td>
					<td class="table_td_contents" style="width: 400px">
						<input id="srcBorgName" name="srcBorgName" type="text" value="" size="20" maxlength="30" style="width: 300px" />
						<input id="srcGroupId" name="srcGroupId" type="hidden" value=""/>
						<input id="srcClientId" name="srcClientId" type="hidden" value=""/>
						<input id="srcBranchId" name="srcBranchId" type="hidden" value=""/>
						<input id="authMode" name="authMode" type="hidden" value=""/>
						<a href="#">
							<img id="btnBuyBorg" src="/img/system/btn_icon_search.gif" width="20" height="18" style="vertical-align: middle;border: 0px;" />
						</a>
					</td>
					<td width="100" class="table_td_subject"  style="width: 100px">주문자</td>
					<td class="table_td_contents">
                        <input id="srcUserNm" name="srcUserNm" type="text" size="20" maxlength="50" />
					</td>
				</tr>
				<tr>
					<td colspan="6" class="table_top_line"></td>
				</tr>
			</table> 
			<!-- 컨텐츠 끝 -->
		</td>
	</tr>
    <tr><td height="5"></td></tr>
	<tr>
        <td style="width: 100%;" >  
            <iframe id="admOrderCart" name="admOrderCart" frameborder="0" scrolling="yes" marginwidth="0" marginheight="0" style="width:100%; height:800px; overflow-x:hidden;"></iframe>
        </td>
	</tr>
</table>
</form>

<div id="divPopup" class="jqmPop" style="width:300px; height: 500px; ">
    <div>
        <div id="divPopup" style="width: 600px;">
            <div id="popDetailDrag1">
                <h1>사용자조회<a href="#;"><img id="closeButton1Pop" src="/img/contents/btn_close.png"/></a></h1>
            </div>
            <div class="popcont">
                <table class="InputTable">
                    <tr>
                        <td>
                            <div id="jqgrid">
                                <table id="list"></table>
                                <div id="pager"></div>
                            </div>
                        </td>
                    </tr>
                </table>
                <div class="Ac mgt_10">
                    <button id='closeButton2Pop' class='btn btn-default btn-sm' >닫기</button>
                </div>
            </div>
        </div>
    </div>
</div>

</body>
<script>
var jq = jQuery;
$(document).ready(function() {
	$("#srcButton").click( function() { 
		fnSearch(); 
	});
	$('#divPopup').jqm();	//Dialog 초기화
	$("#closeButton1Pop").click(function(){$("#divPopup").jqmHide();});
	$("#closeButton2Pop").click(function(){$("#divPopup").jqmHide();});
	$('#divPopup').jqm().jqDrag('#popDetailDrag1');
});

jq(function() {
	jq("#list").jqGrid({
		url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/organ/organUserListJQGrid.sys', 
		datatype: 'local',
		mtype: 'POST',
		colNames:['borgId', '고객사', '권역', '사용자명', '사용자ID', '사용자상태', '고객사상태','감독여부','고객유형', '로그인여부', '전화번호', '이동전화번호','Email발송','SMS발송', '등록일', 'userId', 'isUseCd'],
		colModel:[
			{name:'borgId',index:'borgId', width:250,align:"left",search:false,sortable:false,
				editable:false, hidden:true
			},	//고객사
			{name:'branchNm',index:'branchNm', width:250,align:"left",search:false,sortable:false,
				editable:false
			},	//고객사
			{name:'areaTypeNm',index:'areaTypeNm', width:50,align:"center",search:false,sortable:false, hidden:true,
				editable:false 
			},	//권역
			{name:'userNm',index:'userNm', width:60,align:"center",search:false,sortable:false, 
				editable:false 
			},	//사용자명
			{name:'loginId',index:'loginId', width:60,align:"center",search:false,sortable:false, hideen:true,
				editable:false 
			},	//사용자ID
			{name:'isUse',index:'isUse', width:80,align:"center",search:false,sortable:false,
				editable:false 
			},	//사용자상태
			{name:'borg_IsUse',index:'borg_IsUse', width:80,align:"center",search:false,sortable:false,
				editable:false 
			},	//사업장상태
			{name:'isDirect',index:'isDirect', width:50,align:"center",search:false,sortable:false,
				editable:false 
			},	//감독여부
			{name:'workNm',index:'workNm', width:120,align:"left",search:false,sortable:false,
				editable:false 
			},	//고객유형
			{name:'isLogin',index:'isLogin', width:60,align:"center",search:false,sortable:false,
				editable:false 
			},	//로그인여부
			{name:'tel',index:'tel', width:80,align:"center",search:false,sortable:false,
				editable:false 
			},	//전화번호
			{name:'mobile',index:'mobile', width:80,align:"center",search:false,sortable:false, 
				editable:false
			},	//이동전화번호
			{name:'isEmail',index:'isEmail', width:70,align:"center",sortable:false,
				editable:false,
				edittype:"select",formatter:"select",editoptions:{value:"1:발송;0:미발송"}
			},	//EMAIL발송
			{name:'isSms',index:'isSms', width:70,align:"center",sortable:false,
				editable:false,
				edittype:"select",formatter:"select",editoptions:{value:"1:발송;0:미발송"}
			},	//SMS발송
			{name:'createDate',index:'createDate', width:80,align:"center",search:false,sortable:false,
				editable:false 
			},	//등록일
			{name:'userId',index:'userId', hidden:true 
			},	//userId
			{name:'isUseCd',index:'isUseCd', hidden:true 
			}	//isUseCd
		],
		postData: {
			srcGroupId:$("#srcGroupId").val(),
			srcClientId:$("#srcClientId").val(),
			srcBranchId:$("#srcBranchId").val(),
			srcUserNm:$("#srcUserNm").val(),
			srcIsUse:'1',
			srcBorgIsUse:'1'
		},multiselect:false ,
		width:550, height: 500,
		sortname: 'userId', sortorder: "desc",
		rowNum:30, rownumbers: false, rowList:[30,50,100,200], pager: '#pager',
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,	//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete: function() {
			var rowCnt = $(this).getGridParam('reccount');
			if(rowCnt > 0){
				for(var i=0; i<rowCnt; i++){
					var rowid = $(this).getDataIDs()[i];
					var selrowContent = $(this).jqGrid('getRowData',rowid);
					var tel = selrowContent.tel;
					tel = fnSetTelformat(tel);
					var mobile = selrowContent.mobile;
					mobile = fnSetTelformat(mobile);
					$(this).jqGrid('setRowData',rowid,{tel:tel});
					$(this).jqGrid('setRowData',rowid,{mobile:mobile});
				}
			}
		},
		afterInsertRow: function(rowid, aData){ 
			jq("#list").setCell(rowid,'userNm','',{color:'#0000ff'}); 
			jq("#list").setCell(rowid,'userNm','',{cursor: 'pointer'});  
			jq("#list").setCell(rowid,'userNm','',{'text-decoration':'underline'});  
		},
		onSelectRow: function (rowid, iRow, iCol, e) { },
		ondblClickRow: function (rowid, iRow, iCol, e) { },
		onCellSelect: function(rowid, iCol, cellcontent, target){ 
			var cm = jq("#list").jqGrid("getGridParam", "colModel");  
			var colName = cm[iCol];
			if(colName != undefined &&colName['index']=="userNm") { 
				var selrowContent = jq("#list").jqGrid('getRowData',rowid);
				jq("#list").setSelection(rowid);  
				var moveUserId = selrowContent.userId;
				var belongBorgId = selrowContent.borgId;
				var belongSvcTypeCd = "BUY";			
				$("#belongBorgId").val(belongBorgId);
				$("#belongSvcTypeCd").val(belongSvcTypeCd);
				$("#moveUserId").val(moveUserId);
				buyCartIframeCall();
			}
		},
		loadError : function(xhr, st, str){
			alert("에러가 발생하였습니다.");
		},
		jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"}
	}); 
});


function fnSearch() {
	jq("#list").jqGrid("setGridParam", {"page":1});
	var data = jq("#list").jqGrid("getGridParam", "postData");
	data.srcGroupId = $("#srcGroupId").val();
	data.srcClientId = $("#srcClientId").val();
	data.srcBranchId = $("#srcBranchId").val();
	data.srcUserNm = $("#srcUserNm").val();
	data.srcIsUse = '1';
	jq("#list").jqGrid("setGridParam", { "postData": data });
	$("#list").jqGrid("setGridParam",{datatype:"json"}).trigger("reloadGrid");
    $("#divPopup").jqmShow();
}

function buyCartIframeCall(){
	if(!confirm("해당 사용자의 장바구니 화면으로 이동하시겠습니까?")) return false;
	$("#divPopup").jqmHide();
    $( "#admOrderCart" ).attr("src","/order/admCart/admCartInfoIframe.sys?belongBorgId="+$.trim($("#belongBorgId").val())+"&belongSvcTypeCd="+$.trim($("#belongSvcTypeCd").val()) +"&moveUserId="+$.trim($("#moveUserId").val())  );
}
</script>

<% //---------------------------------	고객사 조회	--------------------------------------------- %>
<%@ include file="/WEB-INF/jsp/common/buyBorgListDiv.jsp" %>
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
		fnBuyborgDialog("", "", borgNm, "fnCallBackBuyBorg"); 
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
// 	alert("groupId : "+groupId+", clientId : "+clientId+", branchId : "+branchId+", borgNm : "+borgNm+", areaType : "+areaType);
	$("#srcGroupId").val(groupId);
	$("#srcClientId").val(clientId);
	$("#srcBranchId").val(branchId);
	$("#srcBorgName").val(borgNm);
}
</script>
<% //------------------------------------------------------------------------------ %>
</html>