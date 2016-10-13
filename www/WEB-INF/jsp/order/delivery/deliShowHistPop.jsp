<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="kr.co.bitcube.common.dto.CodesDto" %>
<%@ page import="java.util.List"%>
<%@ page import="kr.co.bitcube.common.dto.LoginUserDto" %>
<%
	LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
    boolean isClient = loginUserDto.getSvcTypeCd().equals("BUY") ? true: false;
	//그리드의 width와 Height을 정의  
    int heightThisGrid = isClient ? 190 : 249; 
	String listHeight = "$(window).height()-"+heightThisGrid+" + Number(gridHeightResizePlus)";

	@SuppressWarnings("unchecked")	//화면권한가져오기(필수)
	List<ActivitiesDto> roleList = (List<ActivitiesDto>)request.getAttribute("useActivityList");
    
    String orde_iden_numb = (String)request.getAttribute("orde_iden_numb");
    String purc_iden_numb = (String)request.getAttribute("purc_iden_numb");
    String deli_iden_numb = (String)request.getAttribute("deli_iden_numb");
	String deliDate_today = CommonUtils.getCurrentDate();
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>

<!-- 버튼 이벤트 스크립트 -->
<script type="text/javascript">
var jq = jQuery;
$(document).ready(function() {
	$("#closeButton").click(function(){ close(); });
	$("#deliSaveButton").click(function(){ 
		$("#realDeliveryQuan").val($.trim($("#realDeliveryQuan").val()));
		$("#deliDate").val($.trim($("#deliDate").val()));
		$("#deliDesc").val($.trim($("#deliDesc").val()));
		deliSaveHistory(); 
	});
	$("#delButton").click(function(){ deleteDeliHistory(); });
	$("#excelButton").click(function(){ exportExcel(); });
	$("#deliDate").val("<%=deliDate_today%>");
    // 날짜 조회 및 스타일
    $(function(){
       	$("#deliDate").datepicker(
              	{
       	   		showOn: "button",
       	   		buttonImage: "/img/system/btn_icon_calendar.gif",
       	   		buttonImageOnly: true,
       	   		dateFormat: "yy-mm-dd"
              	}
       	);
   	$("img.ui-datepicker-trigger").attr("style", "margin-left:5px; vertical-align:middle; cursor:pointer;"); // 입력창 옆의 이미지 속성 설정
    });
   
	$("#realDeliveryQuan").keydown(function(e){ 
		//입력 허용 키
		if ((e.keyCode >= 48 && e.keyCode <= 57) || //숫자열 0 ~ 9 : 48 ~ 57
		(e.keyCode >= 96 && e.keyCode <= 105) || //키패드 0 ~ 9 : 96 ~ 105
		e.keyCode == 8 || //BackSpace
		e.keyCode == 46 || //Delete
		e.keyCode == 110 || //소수점(.) : 문자키배열
		e.keyCode == 190 || //소수점(.) : 키패드
		e.keyCode == 37 || //좌 화살표
		e.keyCode == 39 || //우 화살표
		e.keyCode == 35 || //End 키
		e.keyCode == 36 || //Home 키
		e.keyCode == 9 || //Tab 키
		e.keyCode == 13 // Enter 키
		) {
			return true;
		} else {
			// - 키
			if (e.keyCode == 189) {
				if ($(this).val().charAt(0) != "-") {
				} else {
					$(this).val(
							$(this).val().substring(1,
									$(this).val().length));
				}
			}

			return false;
		}
	});
});

//리사이징
$(window).bind('resize', function() { 
	$("#list").setGridHeight(<%=listHeight %>);
    $("#list").setGridWidth($(window).width()-60 + Number(gridWidthResizePlus));
}).trigger('resize');  
</script>

<!-- 그리드 초기화 스크립트 -->
<script type="text/javascript">
jq(function() {
	jq("#list").jqGrid({
		url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/order/delivery/deliShowHistJQGrid.sys', 
		datatype: 'json',
		mtype: 'POST',
		colNames:['납품수량', '날짜', '납품설명', '등록자', '등록일', 'mracptsub_id'],
		colModel:[
			{name:'delivery_quan',index:'delivery_quan', width:90,align:"right",search:false,sortable:true,
				editable:false ,sorttype:'integer',formatter:'integer',
				formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" } 
			},	//납품수량
			{name:'delivery_date',index:'delivery_date', width:70,align:"center",search:false,sortable:true,
				editable:false
			},	//날짜
			{name:'delivery_desc',index:'delivery_desc', width:150,align:"left",search:false,sortable:true,
				editable:false 
			},	//납품설명
			{name:'regi_user_id',index:'regi_user_id', width:70,align:"left",search:false,sortable:true,
				editable:false 
			},	//등록자
			{name:'regi_date_time',index:'regi_date_time', width:70,align:"center",search:false,sortable:true,
				editable:false
			},	//등록일
			{name:'mracptsub_id',index:'mracptsub_id', hidden:true, search:false,sortable:true, editable:false }
		],
		postData: {
			orde_iden_numb:"<%=orde_iden_numb%>",
			purc_iden_numb:"<%=purc_iden_numb%>",
			deli_iden_numb:"<%=deli_iden_numb%>"
		},  
		sortname: 'regi_date_time', sortorder: "desc",
		rowNum:30, rownumbers: false,
		height: <%=listHeight%>,width:$(window).width()-60 + Number(gridWidthResizePlus),
		caption:"선정산 실 납품정보", 
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,	//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete: function() {},
		onSelectRow: function (rowid, iRow, iCol, e) {},
		ondblClickRow: function (rowid, iRow, iCol, e) {
		},
		onCellSelect: function(rowid, iCol, cellcontent, target){},
		loadError : function(xhr, st, str){ $("#list").html(xhr.responseText); },
		jsonReader : {root: "list",records: "records",repeatitems: false,cell: "cell"}
	}); 
});
</script>

<!-- 그리드 이벤트 스크립트 -->
<script type="text/javascript">
function exportExcel() {
	var colLabels = ['납품수량', '날짜', '납품설명', '등록자', '등록일'];
	var colIds = ['delivery_quan', 'delivery_date', 'delivery_desc', 'regi_user_id', 'regi_date_time'];	//출력컬럼ID
	var numColIds = ['delivery_quan'];	//숫자표현ID
	var sheetTitle = "선정산 실 납품정보";	//sheet 타이틀
	var excelFileName = "deliveryHistoryInfo";	//file명
	fnExportExcel(jq("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>");	//Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
}

<%if(!isClient){ %>
function deliSaveHistory(){
	if($("#realDeliveryQuan").val() == ""){
		alert("수량을 입력해주십시오.");
		return;
	}
	if($("#deliDate").val() == ""){
		alert("날짜를 선택해주십시오.");
		return;
	}
	if(!confirm("입력하신 내용으로 실납품정보를 저장하시겠습니까?")) return;
	$.post(
		"<%=Constances.SYSTEM_CONTEXT_PATH%>/order/delivery/realDeliveryInfoTransGrid.sys",
		{  orde_iden_numb:'<%=orde_iden_numb%>'
		 , purc_iden_numb:'<%=purc_iden_numb%>'
		 , deli_iden_numb:'<%=deli_iden_numb%>'
		 , realDeliveryQuan: $("#realDeliveryQuan").val()
		 , deliDate: $("#deliDate").val()
		 , deliDesc: $("#deliDesc").val()
		}
		,function(arg){ 
			if(fnAjaxTransResult(arg)) {	
				alert("정상적으로 처리가 되었습니다.");
				jq("#list").trigger("reloadGrid");
			}
		}
	);
}
function deleteDeliHistory(){
 	var rowid = $("#list").jqGrid('getGridParam','selrow');
 	if(rowid==null) { alert("삭제할 대상이 선택되지 않았습니다."); return; }
 	var selrowContent = jq("#list").jqGrid('getRowData',rowid);
 	var mracptsub_id= selrowContent.mracptsub_id;
	if(!confirm("입력하신 내용으로 실납품정보를 삭제하시겠습니까?")) return;
	$.post(
		"<%=Constances.SYSTEM_CONTEXT_PATH%>/order/delivery/deleteRealDeliveryInfoTransGrid.sys",
		{ 
		  mracptsub_id:mracptsub_id
		}
		,function(arg){ 
			if(fnAjaxTransResult(arg)) {	
				alert("정상적으로 삭제가 되었습니다.");
				jq("#list").trigger("reloadGrid");
			}
		}
	);
}
<%}%>
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
							<td height="29" class='ptitle'>선정산 실납품정보</td>
							<td height="29" align="right" style="vertical-align: middle;">
<%if(!isClient){ %>                            
                                <a href="#"><img id="deliSaveButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type3_save.gif" width="65" height="22" style='border:0;' /></a>
<%} %>                                
                            </td>
						</tr>
					</table> 
					<!-- 타이틀 끝 -->
				</td>
			</tr>
<%if(!isClient){ %>            
			<tr>
				<td>
					<!-- 컨텐츠 시작 -->
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td colspan="4" class="table_top_line"></td>
						</tr>
						<tr>
							<td class="table_td_subject" width="100px">수량</td>
							<td class="table_td_contents"> <input id="realDeliveryQuan" name="realDeliveryQuan" type="text" value="" size="" maxlength="10" style="width: 150px; width: 60%;" dir="rtl"/></td>
							<td width="100" class="table_td_subject">날짜</td>
							<td class="table_td_contents"> <input type="text" name="deliDate" id="deliDate" style="width: 70px;vertical-align: middle;"/> </td>
						</tr>
						<tr>
							<td colspan="4" height='1' bgcolor="eaeaea"></td>
						</tr>
						<tr>
							<td width="100" class="table_td_subject">비고</td>
							<td class="table_td_contents" colspan="3"><input id="deliDesc" name="deliDesc" type="text" value="" size="" maxlength="500" style="width: 200px ; width: 98%" /></td>
						</tr>
						<tr>
							<td colspan="4" class="table_top_line"></td>
						</tr>
					</table> <!-- 컨텐츠 끝 -->
				</td>
			</tr>
<%} %>            
            <tr><td style="height: 4px;"></td></tr>
			<tr>
				<td align="right">  
<%if(!isClient){ %>
					<a href="#"><img id="delButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Trash.gif" width="15" height="15" style='border:0; vertical-align: middle;' /></a>
<%} %>
					<a href="#"><img id="excelButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Table.gif" width="15" height="15" style='border:0; vertical-align: middle;' /></a>
				</td>
			</tr>
            <tr><td style="height: 2px;"></td></tr>
			<tr>
				<td>
					<div id="jqgrid">
						<table id="list"></table>
					</div>
				</td>
			</tr>
            <tr><td style="height: 15px;"></td></tr>
			<tr>
				<td align="center"> <a href="#"><img id="closeButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type5_close.gif" style='border:0;' width="65" height="22" /></a></td>
			</tr>
		</table>
<div id="dialogSelectRow" title="Warning" style="display:none;font-size: 12px;color: red;">
	<p>처리할 데이터를 선택 하십시오!</p>
</div>
</form>
</body>
</html>