<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<style type="text/css">
.jqmUserWindow {
    display: none;
    position: fixed;
    top: 17%;
    margin-left: 30px;
    width: 510px;
    background-color: #EEE;
    color: #333;
    border: 1px solid black;
    padding: 12px;
}
.jqmOverlay { background-color: #000; }
* html .jqmUserWindow {
     position: absolute;
     top: expression((document.documentElement.scrollTop || document.body.scrollTop) + Math.round(17 * (document.documentElement.offsetHeight || document.body.clientHeight) / 100) + 'px');
}
</style>

<!-------------------------------- Dialog Div Start -------------------------------->
<!-- 그리드 초기화 스크립트 -->
<script type="text/javascript">
$(function(){
	// Dialog Button Event
	$("#srcJqmUserNm").keydown(function(e){
		if(e.keyCode==13) { $("#srcJqmButton").click(); }
	});
	$("#srcJqmLoginId").keydown(function(e){
		if(e.keyCode==13) { $("#srcJqmButton").click(); }
	});
	$("#srcJqmButton").click(function(){	//조회
		fnJqmSearch();
	});

	$('#userDialogPop').jqm();	//Dialog 초기화
	$("#userCloseButton").click(function(){	//Dialog 닫기
		$('#userDialogPop').jqmHide();
		$("#srcJqmUserNm").val("");
		$("#srcJqmBranchId").val("");
		$("#srcJqmSvcTypeCd").val("");
		$("#stcJqmSvcTypeNm").val("");
		fnUserCallback = "";
	});
	$("#userSelectButton").click(function(){	//선택
		fnJqmSelectUser();
	});
	$('#userDialogPop').jqm().jqDrag('#userDialogHandle'); 
});

/**
 * 등록버튼을 눌렀을경우 조회조건을 초기화 하고 조회
 */
 var fnUserCallback = "";
function fnJqmUserInitSearch(userNm, loginId, svcTypeCd, callbackString, branchId, userId, directorId) {
	$("#userDialogPop").jqmShow();
	$("#srcJqmUserNm").val(userNm);
	$("#srcJqmUserNm").focus();
	$("#srcJqmSvcTypeCd").val(svcTypeCd);
	$("#srcJqmBranchId").val(branchId);
	$("#srcJqmUserId").val(userId);
	$("#srcJqmDirectorUserId").val(directorId);
	if(svcTypeCd=="ADM") $("#stcJqmSvcTypeNm").val("운영사");
	else if(svcTypeCd=="BUY") $("#stcJqmSvcTypeNm").val("고객사");
	else if(svcTypeCd=="VEN") $("#stcJqmSvcTypeNm").val("공급사");
	else if(svcTypeCd=="CEN") $("#stcJqmSvcTypeNm").val("물류센타");
	else if(svcTypeCd=="") $("#stcJqmSvcTypeNm").val("전체");
	$("#srcJqmLoginId").val(loginId);
	fnUserCallback = callbackString;
	userDialogDivInit();
}

var jq = jQuery;
var jqmStaticNum = 0;	//memberList 그리드를 한번만 초기화하기 위해
function userDialogDivInit() {
	if(jqmStaticNum>0) {
		fnJqmSearch();
		return;
	}
	jq("#memberList").jqGrid({
		url:'<%=Constances.SYSTEM_CONTEXT_PATH %>/common/svcMemberListJQGrid.sys',
		datatype: 'json', mtype: 'POST',
		multiselect:true,
		colNames:['사용자명','Login ID','업체조직명','userId','borgId', 'mobile'],
		colModel:[
			{name:'userNm',index:'userNm', width:90,align:"left",search:false,sortable:true,editable:false},//사용자명
			{name:'loginId',index:'loginId', width:90,align:"left",search:false,sortable:true,editable:false},//사용자ID
			{name:'borgNm',index:'borgNm', width:250,align:"left",search:false,sortable:true,editable:false},//업체조직명
	   		{name:'userId',index:'userId', hidden:true},//userId
	   		{name:'borgId',index:'borgId', hidden:true},//borgId
	   		{name:'mobile',index:'mobile', hidden:true}	//mobile
		],
		postData: {
			srcSvcTypeCd:$("#srcJqmSvcTypeCd").val(),
			srcUserNm:$("#srcJqmUserNm").val(),
			srcLoginId:$("#srcJqmLoginId").val(),
			srcBranchId:$("#srcJqmBranchId").val(),
			srcUserId:$("#srcJqmUserId").val(),
			srcDirectorUserId:$("#srcJqmDirectorUserId").val(),
			isDirector:"Y"
		},
		rowNum:10, rownumbers: true, rowList:[10,20,30,50,100,500,1000], pager: '#memberPager',
		height:200, width:470, 
		sortname: 'borgNms', sortorder: "asc",
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,	//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete: function() { jqmStaticNum++; },
		afterInsertRow: function(rowid, aData){},
		ondblClickRow: function (rowid, iRow, iCol, e) {},
		loadError : function(xhr, st, str){ $("#memberList").html(xhr.responseText); },
		jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"}
	});
}

/**
 * 조회조건에 따른 사용자정보 조회
 */
function fnJqmSearch(){
	jq("#memberList").jqGrid("setGridParam", {"page":1, "rows":10});
	var data = jq("#memberList").jqGrid("getGridParam", "postData");
	data.srcSvcTypeCd = $("#srcJqmSvcTypeCd").val();
	data.srcUserNm = $("#srcJqmUserNm").val();
	data.srcLoginId = $("#srcJqmLoginId").val();
	data.srcBranchId = $("#srcJqmBranchId").val();
	data.srcUserId = $("#srcJqmUserId").val();
	data.isDirector = "Y";
	jq("#memberList").jqGrid("setGridParam", { "postData":data });
	jq("#memberList").trigger("reloadGrid");
}

/**
 * 사용자 선택후 Callback 호출(Parent페이지에 반드시 fnSelectUserCallback 함수 존재해야 함)
 */
function fnJqmSelectUser() {
	var id = $("#memberList").getGridParam('selarrrow');
    var ids = $("#memberList").jqGrid('getDataIDs');
    var count = 0;
    var loginIdArr = Array();
    var userIdArr = Array();
    var userNmArr = Array();
    for (var i = 0; i < ids.length; i++) {
    	var check = false;
        $.each(id, function (index, value) {
        	if (value == ids[i])	check = true;
        });
        if (check) {
        	var rowdata = $("#memberList").getRowData(ids[i]);
        	loginIdArr[count] = rowdata.loginId;
        	userIdArr[count] = rowdata.userId;
        	userNmArr[count] = rowdata.userNm;
          	count++;
        }
   	}	
    
    if(count == 0){
    	alert("선택된 사용자가 없습니다.");
    	return;
    }
    fnDirectUserCallBack(loginIdArr, userIdArr, userNmArr);
	$("#userCloseButton").click();
}
</script>
</head>
<body>
<div class="jqmUserWindow" id="userDialogPop">
	<table width="100%"  border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td>
				<div id="userDialogHandle">
					<table width="100%"  border="0" cellpadding="0" cellspacing="0" style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/popup_titlebar_mid.gif');">
		      			<tr>
		        			<td width="21" style="background-color: #ea002c; height: 47px;"></td>
							<td style="background-color: #ea002c; height: 47px;color: #fff;font-size: 20px;font-weight: 700;">사용자 검색</td>
							<td width="22" align="right" style="background-color: #ea002c; height: 47px;">
								<a href="#" class="jqmClose">
									<img src="/img/contents/btn_close.png" class="jqmClose">
								</a>
							</td>
							<td width="10" style="background-color: #ea002c; height: 47px;"></td>
		      			</tr>
					</table>
				</div>
				<table width="100%"  border="0" cellpadding="0" cellspacing="0">
					<tr>
						<td style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_4.gif');">&nbsp;</td>
						<td bgcolor="#FFFFFF">
							<!-- 조회조건 -->
							<table width="100%"  border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td colspan="4" align="right" valign="top">
										<a href="#;">
											<a href="#;"><img src="/img/contents/btn_tablesearch.gif" id="srcJqmButton" name="srcJqmButton" style="width: 55px; height: 24px; margin: 2px;"/></a>
<%-- 											<img id="srcJqmButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type3_search.gif" height="22" style='border:0;vertical-align: middle;' align="right"/> --%>
										</a>
									</td>
								</tr>
								<tr>
									<td colspan="4" class="table_top_line"></td>
								</tr>
								<tr>
									<td class="table_td_subject" width="100">사용자ID</td>
									<td class="table_td_contents">
										<input id="srcJqmSvcTypeCd" name="srcJqmSvcTypeCd" type="hidden" value="" size="20" maxlength="30"/>
										<input id="srcJqmBranchId" name="srcJqmBranchId" type="hidden" value="" size="20" maxlength="30"/>
										<input id="srcJqmUserId" name="srcJqmUserId" type="hidden" value="" size="20" maxlength="30"/>
										<input id="srcJqmDirectorUserId" name="srcJqmDirectorUserId" type="hidden" value="" size="20" maxlength="30"/>
										<input id="srcJqmLoginId" name="srcJqmLoginId" type="text" value="" size="20" maxlength="30"/>
									</td>
									<td class="table_td_subject" width="100">사용자명</td>
									<td class="table_td_contents">
										<input id="srcJqmUserNm" name="srcJqmUserNm" type="text" value="" size="20" maxlength="30" />
									</td>
								</tr>

								<tr>
									<td colspan="4" height='8'>
                                       <input id="srcClientNm" name="srcClientNm" type="hidden" value="" size="20" maxlength="30"/>
                                    </td>
								</tr>
							</table>
							
							<table width="100%"  border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td>
										<div id="jqgrid">
											<table id="memberList"></table>
											<div id="memberPager"></div>
										</div>
									</td>
								</tr>
								<tr>
									<td height='8'></td>
								</tr>
							</table>
							
							<table width="100%"  border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td align="center">
										<button id='userSelectButton' class="btn btn-darkgray btn-sm"><i class="fa fa-floppy-o"></i> 선택</button>
										<button id='userCloseButton' class="btn btn-default btn-sm" ><i class="fa fa-times"></i> 닫기</button>
									</td>
								</tr>
							</table>
						</td>
						<td style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_2.gif');">&nbsp;</td>
					</tr>
					<tr>
						<td width="20" height="20"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_4.gif" width="20" height="20"/></td>
						<td style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_3.gif');">&nbsp;</td>
						<td width="20"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_3.gif" width="20" height="20" /></td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
</div>
<!-------------------------------- Dialog Div End -------------------------------->
</body>
</html>