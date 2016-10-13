<%@page import="java.util.Calendar"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="kr.co.bitcube.common.dto.CodesDto" %>
<%@ page import="kr.co.bitcube.common.dto.LoginUserDto" %>
<%@ page import="kr.co.bitcube.common.dto.SrcBorgScopeByRoleDto" %>
<%@ page import="kr.co.bitcube.common.dto.BorgDto" %>
<%@ page import="java.util.List"%>

<%
    LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);

    //그리드의 width와 Height을 정의
    String listHeight = "$(window).height()-360 + Number(gridHeightResizePlus)";
    String listWidth  = "1500";

    @SuppressWarnings("unchecked")  //화면권한가져오기(필수)
    List<ActivitiesDto> roleList = (List<ActivitiesDto>)request.getAttribute("useActivityList");
    String _menuId = "".equals(CommonUtils.getString(request.getParameter("_menuId"))) ? CommonUtils.getString(request.getAttribute("_menuId")) : CommonUtils.getString(request.getParameter("_menuId"));
    
    Calendar cal = Calendar.getInstance();
    
    int year = cal.get(cal.YEAR);
    
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>
<%@ include file="/WEB-INF/jsp/system/holiday/regHolidayDiv.jsp" %>

<!-- 버튼 이벤트 스크립트 -->
<script type="text/javascript">
var jq = jQuery;
$(document).ready(function() {
	
    $("#srcYear").change( function() { 
        fnSearch(); 
    });
    
    $("#regPopButton").click( function() { addRow(); });
    $("#delButton").click( function() { deleteRow(); });
    
    initList();
});

//리사이징
$(window).bind('resize', function() { 
    $("#list").setGridHeight(<%=listHeight %>);
    $("#list").setGridWidth(<%=listWidth%>);
}).trigger('resize');  
</script>

<!-- 그리드 초기화 스크립트 -->
<script type="text/javascript">
function initList() {
    jq("#list").jqGrid({
        url:'<%=Constances.SYSTEM_CONTEXT_PATH %>/system/holiday/selectHolidayManageList/list.sys',
        datatype: 'json',
        mtype: 'POST',
        colNames:['휴일일자','휴일명'],
        colModel:[
            {name:'HOLIDAY',index:'HOLIDAY', width:200,align:"center",search:false,sortable:true, editable:true },  //휴일일자
            {name:'HOLIDAY_NM',index:'HOLIDAY_NM', width:300,align:"center",search:false,sortable:true, editable:true}  //휴일명
        ],
        postData: {
        	srcYear:$("#srcYear").val()
        },
        rownumbers: false, 
        height: <%=listHeight%>,width:<%=listWidth%>,
        sortname: '', sortorder: "",
        viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false, //해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
        loadComplete: function() {},
        onSelectRow: function (rowid, iRow, iCol, e) {},
        ondblClickRow: function (rowid, iRow, iCol, e) {},
        onCellSelect: function(rowid, iCol, cellcontent, target){},
        loadError : function(xhr, st, str){ $("#list").html(xhr.responseText); },
        jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"}
    }); 
}

function addRow() {
	fnHolidayDialog();
}


function deleteRow() {
	
	var row = jq("#list").jqGrid('getGridParam','selrow');
	
	if( ! row ){
		alert("처리할 데이터를 선택하시기 바랍니다.");
		return;	
	}
	
	var holiday = jq("#list").jqGrid("getRowData",row).HOLIDAY;
	
	
	$.post(
		"/system/holiday/deleteHolidayManage/save.sys",
		{
			holiday		: holiday ,
			oper		: 'del'
		},
		function(args){
			if ( fnAjaxTransResult(args)) {
				fnSearch();
			} 
		}
	);

}
</script>

<!-- 그리드 이벤트 스크립트 -->
<script type="text/javascript">
function fnSearch() {
    jq("#list").jqGrid("setGridParam", {"page":1});
    var data = jq("#list").jqGrid("getGridParam", "postData");
    data.srcYear = $("#srcYear").val();

    jq("#list").jqGrid("setGridParam", { "postData": data ,"datatype":"json"});
    jq("#list").trigger("reloadGrid");
}

</script>
<style type="text/css">
/* 로우에 손가락 모양 */
.ui-jqgrid .ui-jqgrid-btable { cursor : pointer; }
</style>

</head>
<body>
<jsp:include page="/WEB-INF/jsp/system/treeFrame/adminMenu.jsp" flush="false" />
<form id="frm" name="frm" onsubmit="return false;">
    <table width="1500px" style="margin-left: 0px;" border="0" cellspacing="0" cellpadding="0">
        <tr>
            <td>
                <!-- 타이틀 시작 -->
                <table width="1500px" border="0" cellspacing="0" cellpadding="0">
                    <tr valign="top">
                        <td width="20" valign="middle"><img src="/img/system/bullet_ptitle1.gif" width="14" height="15" /></td>
                        <td height="29" class='ptitle'>휴일관리</td>
                    </tr>
                </table> <!-- 타이틀 끝 -->
            </td>
        </tr>
        <tr>
            <td>
                <!-- 컨텐츠 시작 -->
                <table width="1500px" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                        <td colspan="6" class="table_top_line"></td>
                    </tr>
                    <tr>
                        <td class="table_td_subject" width="100">년도</td>
                        <td class="table_td_contents">
                            <select id="srcYear" name="srcYear" class="select"> 
<%
    String selected = "";
    for(int i = 2015 ; i < year+2 ; i++){ 
    	selected  = (i==year) ? "selected": "";
%>
                                <option <%=selected %>> <%=i %></option>
<%  } %>
                            </select>
                        </td>
                    </tr>

                    <tr>
                        <td colspan="6" class="table_top_line"></td>
                    </tr>
                </table> <!-- 컨텐츠 끝 -->
            </td>
        </tr>
        <tr>
            <td>&nbsp;</td>
        </tr>
        <tr>
            <td align="right">
            <button id='regPopButton' class="btn btn-primary btn-sm" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>">
                            <i class="fa fa-floppy-o"></i>
                            등록
            </button>
            <button id='delButton' class="btn btn-primary btn-sm" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>">삭제</button>
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
    </table>
    
<div id="dialogSelectRow" title="Warning" style="display:none;font-size: 12px;color: red;">
    <p>처리할 데이터를 선택 하십시오!</p>
</div>

<div id="dialog" title="Feature not supported" style="display:none;">
	<p>That feature is not supported.</p>
</div>
</form>
</body>
</html>