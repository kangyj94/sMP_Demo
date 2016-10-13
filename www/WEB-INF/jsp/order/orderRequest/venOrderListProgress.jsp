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
<%
	String _menuId = "".equals(CommonUtils.getString(request.getParameter("_menuId"))) ? CommonUtils.getString(request.getAttribute("_menuId")) : CommonUtils.getString(request.getParameter("_menuId"));
	LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
	boolean isVendor = loginUserDto.getSvcTypeCd().equals("VEN") ? true : false;
	boolean isAdm = loginUserDto.getSvcTypeCd().equals("ADM") ? true : false;
	//그리드의 width와 Height을 정의    
	String listHeight = "$(window).height()- 360 + Number(gridHeightResizePlus)";
	String listWidth  = "1500";

	@SuppressWarnings("unchecked")	//화면권한가져오기(필수)
	List<ActivitiesDto> roleList = (List<ActivitiesDto>)request.getAttribute("useActivityList");
	
	// 날짜 세팅
	String srcPurcStartDate = CommonUtils.getCustomDay("DAY", -7);
	String srcPurcEndDate = CommonUtils.getCurrentDate();
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>
<!-- 버튼 이벤트 스크립트 -->
<script type="text/javascript">
var jq = jQuery;
$(document).ready(function() {
	$("#srcOrderNumber").keydown(function(e){ if(e.keyCode==13) { $("#srcButton").click(); } });
	$("#srcButton").click(function(){ 
		$("#srcOrderNumber").val($.trim($("#srcOrderNumber").val()));
		$("#srcPurcStartDate").val($.trim($("#srcPurcStartDate").val()));
		$("#srcPurcEndDate").val($.trim($("#srcPurcEndDate").val()));
		fnSearch(); 
	});

	//날짜 세팅
	$("#srcPurcStartDate").val("<%=srcPurcStartDate%>");
	$("#srcPurcEndDate").val("<%=srcPurcEndDate%>");
});
// 날짜 조회 및 스타일
$(function(){
	$("#srcPurcStartDate").datepicker(
       	{
	   		showOn: "button",
	   		buttonImage: "/img/system/btn_icon_calendar.gif",
	   		buttonImageOnly: true,
	   		dateFormat: "yy-mm-dd"
       	}
	);
	$("#srcPurcEndDate").datepicker(
       	{
       		showOn: "button",
       		buttonImage: "/img/system/btn_icon_calendar.gif",
       		buttonImageOnly: true,
       		dateFormat: "yy-mm-dd"
       	}
	);
	$("img.ui-datepicker-trigger").attr("style", "margin-left:5px; vertical-align:middle; cursor:pointer;"); // 입력창 옆의 이미지 속성 설정
});
	
//리사이징
$(window).bind('resize', function() { 
	$("#list").setGridHeight(<%=listHeight %>);  
    $("#list").setGridWidth(<%=listWidth%>);
}).trigger('resize');  
</script>

<!-- 그리드 초기화 스크립트 -->
<script type="text/javascript">
jq(function() {
	jq("#list").jqGrid({
		url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/order/orderRequest/venOrderListProgressJQGrid.sys', 
		datatype: 'json',
		mtype : 'POST',
		colNames:['주문일자','고객유형','주문번호','공사명','고객사','발주의뢰','발주의뢰중지','발주접수','발주접수중지','출하준비중','출하','출하취소','인수','주문취소','반품','branchId'],
		colModel:[
			{name:'regi_date_time',index:'regi_date_time', width:93,align:"center",search:false,sortable:true, 
				editable:false 
			},	//주문일자	
			{name:'worknm',index:'worknm', width:90,align:"left",search:false,sortable:true,
				editable:false 
			},	//고객유형
			{name:'orde_iden_numb',index:'orde_iden_numb', width:100,align:"center",search:false,sortable:true,
				editable:false 
			},	//주문번호
			{name:'cons_iden_name',index:'cons_iden_name', width:200,align:"left",search:false,sortable:true, 
				editable:false
			},	//공사명
			{name:'orde_client_name',index:'orde_client_name', width:125,align:"left",search:false,sortable:true,
				editable:false 
			},	//고객사
			{name:'purt_request',index:'purt_request', width:80,align:"center",search:false,sortable:true,
				editable:false , formatter:image2
			},	//발주의뢰
			{name:'purt_request_stop',index:'purt_request_stop', width:80,align:"center",search:false,sortable:true, 
				editable:false , formatter:image3
			},	//발주의뢰중지
			{name:'purt_receive',index:'purt_receive', width:80,align:"center",search:false,sortable:true, 
				editable:false , formatter:image4
			},	//발주접수
			{name:'purt_receive_stop',index:'purt_receive_stop', width:80,align:"center",search:false,sortable:true,
				editable:false , formatter:image5
			},	//발주접수중지
			{name:'delivery_rdy',index:'delivery_rdy', width:80,align:"center",search:false,sortable:true,
				editable:false , formatter:image11
			},	//출하
			{name:'delivery',index:'delivery', width:80,align:"center",search:false,sortable:true,
				editable:false , formatter:image6
			},	//출하
			{name:'delivery_stop',index:'delivery_stop', width:80,align:"center",search:false,sortable:true,
				editable:false , formatter:image7
			},	//출하중지
			{name:'delivery_receive',index:'delivery_receive', width:80,align:"center",search:false,sortable:true,
				editable:false , formatter:image8
			},	//인수
			{name:'order_cancel',index:'order_cancel', width:80,align:"center",search:false,sortable:true,
				editable:false, formatter:image9
			},	//주문취소
			{name:'order_return',index:'order_return', width:80,align:"center",search:false,sortable:true,
				editable:false , formatter:image10
			},	//반품
			{name:'branchId',index:'branchId', hidden:true}	//구매사ID
		],
		postData: {
			srcPurcStartDate:$("#srcPurcStartDate").val()
			,srcPurcEndDate:$("#srcPurcEndDate").val()
<%if(isVendor){%>
			,srcVendorId:"<%=loginUserDto.getBorgId()%>"
<%}%>
		},
		rowNum:30, rownumbers: false, rowList:[30,50,100,200], pager: '#pager',
		height: <%=listHeight%>,width:<%=listWidth%>,
		sortname: 'regi_date_time', sortorder: "desc",
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,	//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete: function() { },
		onSelectRow: function (rowid, iRow, iCol, e) { },
		ondblClickRow: function (rowid, iRow, iCol, e) { },
		afterInsertRow: function(rowid, aData){
			jq("#list").setCell(rowid,'orde_iden_numb','',{color:'#0000ff'});
			jq("#list").setCell(rowid,'orde_iden_numb','',{cursor: 'pointer'});
<%if(isAdm){%>
			jq("#list").setCell(rowid,'orde_client_name','',{color:'#0000ff'});
			jq("#list").setCell(rowid,'orde_client_name','',{cursor: 'pointer'});
<%}%>
		},
		onCellSelect: function(rowid, iCol, cellcontent, target){ 
			var cm = jq("#list").jqGrid("getGridParam", "colModel");
			var colName = cm[iCol];
			var selrowContent = $("#list").jqGrid('getRowData',rowid);
			if(colName != undefined &&colName['index']=="orde_iden_numb") { <%=CommonUtils.isDisplayRole(roleList, "COMM_READ","viewPurcListRow(rowid);")%> }
<%if(isAdm){%>
			if(colName != undefined &&colName['index']=="orde_client_name") {
				<%=CommonUtils.isDisplayRole(roleList, "COMM_READ","fnBranchDetailView("+_menuId+", selrowContent.branchId);")%>
			}
<%}%>
		},
		loadError : function(xhr, st, str){
			alert("에러가 발생하였습니다.");
		},
		jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"}
	}); 
	jQuery("#list").jqGrid('setGroupHeaders', {
		useColSpanStyle: true,
		groupHeaders:[
			{startColumnName: 'purt_request', numberOfColumns: 2, titleText: '운영사'},
			{startColumnName: 'purt_receive', numberOfColumns: 4, titleText: '공급사'},
			{startColumnName: 'delivery_receive', numberOfColumns: 1, titleText: '고객사'}
		]
	});
});
</script>

<!-- 그리드 이벤트 스크립트 -->
<script type="text/javascript">
function viewPurcListRow(str){
	var selrowContent = jq("#list").jqGrid('getRowData',str);        
  	var popurl = "/order/orderRequest/venOrderProgressPopup.sys?orde_iden_numb=" + selrowContent.orde_iden_numb+"&_menuId="+<%=_menuId%>;
  	var popproperty = "dialogWidth:900px;dialogHeight=700px;scroll=yes;status=no;resizable=no;";
//     window.showModalDialog(popurl,window,popproperty);
  	window.open(popurl, 'okplazaPop', 'width=900, height=700, scrollbars=yes, status=no, resizable=no');
}

function fnSearch() {
	jq("#list").jqGrid("setGridParam", {"page":1});
	var data = jq("#list").jqGrid("getGridParam", "postData");
	data.srcOrderNumber = $("#srcOrderNumber").val();
	data.srcPurcStartDate = $("#srcPurcStartDate").val();
	data.srcPurcEndDate = $("#srcPurcEndDate").val();
<%if(isVendor){%>
	data.srcVendorId = "<%=loginUserDto.getBorgId()%>";
<%}%>
	jq("#list").jqGrid("setGridParam", { "postData": data });
	jq("#list").trigger("reloadGrid");
}

<%
/**
 * 리스트에 뿌려질 그림 데이터
 */
%>
function image1(cellValue, options, rowObject){
    var space2 = "";
    var img    = "<img src='/img/system/icon/Forward.gif' width='12' heiht='12' border='0'/>";
    if (rowObject.order_request == 0){
    	space2 = "";
    } else if(rowObject.order_request == 1){
    	space2 = img;
    }
    return space2;
}
function image2(cellValue, options, rowObject){
    var space2 = "";
    var img    = "<img src='/img/system/icon/Forward.gif' width='12' heiht='12' border='0'/>";
    if (rowObject.purt_request == 0){
    	space2 = "";
    } else if(rowObject.purt_request == 1){
    	space2 = img;
    }
    return space2;
}
function image3(cellValue, options, rowObject){
    var space2 = "";
    var img    = "<img src='/img/system/icon/Forward.gif' width='12' heiht='12' border='0'/>";
    if (rowObject.purt_request_stop == 0){
    	space2 = "";
    } else if(rowObject.purt_request_stop == 1){
    	space2 = img;
    }
    return space2;
}
function image4(cellValue, options, rowObject){
    var space2 = "";
    var img    = "<img src='/img/system/icon/Forward.gif' width='12' heiht='12' border='0'/>";
    if (rowObject.purt_receive == 0){
    	space2 = "";
    } else if(rowObject.purt_receive == 1){
    	space2 = img;
    }
    return space2;
}
function image5(cellValue, options, rowObject){
    var space2 = "";
    var img    = "<img src='/img/system/icon/Forward.gif' width='12' heiht='12' border='0'/>";
    if (rowObject.purt_receive_stop == 0){
    	space2 = "";
    } else if(rowObject.purt_receive_stop == 1){
    	space2 = img;
    }
    return space2;
}
function image11(cellValue, options, rowObject){
    var space2 = "";
    var img    = "<img src='/img/system/icon/Forward.gif' width='12' heiht='12' border='0'/>";
    if (rowObject.delivery_rdy == 0){
    	space2 = "";
    } else if(rowObject.delivery_rdy == 1){
    	space2 = img;
    }
    return space2;
}
function image6(cellValue, options, rowObject){
    var space2 = "";
    var img    = "<img src='/img/system/icon/Forward.gif' width='12' heiht='12' border='0'/>";
    if (rowObject.delivery == 0){
    	space2 = "";
    } else if(rowObject.delivery == 1){
    	space2 = img;
    }
    return space2;
}
function image7(cellValue, options, rowObject){
    var space2 = "";
    var img    = "<img src='/img/system/icon/Forward.gif' width='12' heiht='12' border='0'/>";
    if (rowObject.delivery_stop == 0){
    	space2 = "";
    } else if(rowObject.delivery_stop == 1){
    	space2 = img;
    }
    return space2;
}
function image8(cellValue, options, rowObject){
    var space2 = "";
    var img    = "<img src='/img/system/icon/Forward.gif' width='12' heiht='12' border='0'/>";
    if (rowObject.delivery_receive == 0){
    	space2 = "";
    } else if(rowObject.delivery_receive == 1){
    	space2 = img;
    }
    return space2;
}
function image9(cellValue, options, rowObject){
    var space2 = "";
    var img    = "<img src='/img/system/icon/Forward.gif' width='12' heiht='12' border='0'/>";
    if (rowObject.order_cancel == 0){
    	space2 = "";
    } else if(rowObject.order_cancel == 1){
    	space2 = img;
    }
    return space2;
}
function image10(cellValue, options, rowObject){
    var space2 = "";
    var img    = "<img src='/img/system/icon/Forward.gif' width='12' heiht='12' border='0'/>";
    if (rowObject.order_return == 0){
    	space2 = "";
    } else if(rowObject.order_return == 1){
    	space2 = img;
    }
    return space2;
}
</script>

<script type="text/javascript">
$(document).ready(function(){
	$("#question").click( function() { vendorManual(); });	//메뉴얼호출
});

function vendorManual(){
	var header = "";
	var manualPath = "";
	//공급사 주문진척도
	header = "공급사 주문진척도";
	manualPath = "/img/manual/vendor/venOrderListProgress.jpg";

	var popUrl = "/system/manual.sys?header="+header+"&manualPath="+manualPath;
	window.open(popUrl, 'okplazaPop', 'width=1050, height=800, scrollbars=yes, status=no, resizable=no');
}
</script>
</head>
<jsp:include page="/WEB-INF/jsp/system/treeFrame/adminMenu.jsp" flush="false" />
<body>
<form id="frm" name="frm" onsubmit="return false;">
<%@ include file="/WEB-INF/jsp/common/front/productSearch.jsp"%>
<table width="1500px" style="margin-left: 0px;" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td>
			<!-- 타이틀 시작 -->
			<table width="1500px" border="0" cellspacing="0" cellpadding="0">
				<tr valign="top">
					<td width="20" valign="middle">
						<img src="/img/system/bullet_ptitle1.gif" width="14" height="15" />
					</td>
					<td height="29" class='ptitle'>공급사 주문진척도
					<%if(isVendor){ %>
						&nbsp;<span id="question" class="questionButton">도움말</span>
					<%} %>
					</td>
					<td align="right" class='ptitle'>
						<button id='srcButton' class="btn btn-default btn-sm" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>">
								<i class="fa fa-search"></i> 조회
						</button>
					</td>
				</tr>
			</table> 
			<!-- 타이틀 끝 -->
		</td>
	</tr>
	<tr><td height="1"></td></tr>
	<tr>
		<td>
			<!-- 컨텐츠 시작 -->
			<table width="1500px" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td colspan="4" class="table_top_line"></td>
				</tr>
				<tr>
					<td width="100" class="table_td_subject" width="100">주문번호</td>
					<td class="table_td_contents">
						<input id="srcOrderNumber" name="srcOrderNumber" type="text" value="" size="" maxlength="50" style="width:200px" />
					</td>
					<td width="100" class="table_td_subject">주문일</td>
					<td class="table_td_contents">
						<input type="text" name="srcPurcStartDate" id="srcPurcStartDate" style="width: 75px;vertical-align: middle;" /> 
						~ 
						<input type="text" name="srcPurcEndDate" id="srcPurcEndDate" style="width: 75px;vertical-align: middle;" />
					</td>
				</tr>
				<tr>
					<td colspan="4" class="table_top_line"></td>
				</tr>
			</table> 
			<!-- 컨텐츠 끝 -->
		</td>
	</tr>
	<tr><td height="10"></td></tr>
	<tr><td>* 주문번호를 클릭하면 상세화면에서 공급사 정보를 확인 할 수 있습니다.</td></tr>
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
</form>
</body>
</html>