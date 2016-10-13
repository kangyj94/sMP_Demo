<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.dto.LoginUserDto" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils"%>
<%
	LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
	String vendorid = "";
	String svcTypeCd = userInfoDto.getSvcTypeCd();
	if(svcTypeCd.equals("VEN")){
		vendorid = userInfoDto.getBorgId();
	}
	String srcStartDate = CommonUtils.getCustomDay("MONTH",-1);
	String srcEndDate = CommonUtils.getCurrentDate();
	
	String businessNum = "";
	String registNum = "";
	if(userInfoDto.getSmpVendorsDto() != null){
		businessNum = CommonUtils.getString(userInfoDto.getSmpVendorsDto().getBusinessNum());	
		registNum = CommonUtils.getString(userInfoDto.getSmpVendorsDto().getRegistNum());	
	}
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>

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
<% 	if(Constances.COMMON_ISREAL_SERVER && !"".equals(businessNum)) { %>
<%@ include file="/WEB-INF/jsp/common/auth/authBusinessNumberDiv.jsp" %>
<script type="text/javascript">
var authStep = "";
var _rowId = "";
var _vendorId = "";
function fnEditRow(rowid,vendorid) {
	_rowId = rowid;
	_vendorId = vendorid;
// 	if($.trim($("#is_use_certificate").val()) == "1"){
		//fnGetIsExistPublishAuth(svcTypeCd, borgId) - 현재 세션의 공인인증서 인증상태를 확인 (파라미터3 참조)
		authStep = fnGetIsExistPublishAuth('<%=userInfoDto.getSvcTypeCd()%>','<%=userInfoDto.getBorgId()%>');
		fnAuthBusinessNumberDialog("VEN", "ETC", authStep, '<%=businessNum%>',"fnCallBackAuthBusinessNumber", '<%=userInfoDto.getBorgId()%>');
// 	}else if($.trim($("#is_use_certificate").val()) == "0"){
// 		editRow(_rowId,_vendorId);
// 	}
}

function fnCallBackAuthBusinessNumber(userDn) {
	if((userDn != "" && userDn != null) || authStep == "2"){
		editRow(_rowId,_vendorId);
	}
}
</script>
<%	}else{ %>
<script type="">
function fnEditRow(rowid,vendorid) {
	editRow(rowid,vendorid);
}
</script>
<%	} %>
<% //------------------------------------------------------------------------------ %>

<!-- 버튼 이벤트 스크립트 -->
<script type="text/javascript">        
$(document).ready(function () {           
});    
</script>
<script type="text/javascript">
var jq = jQuery;
$(document).ready(function() {
    
});
</script>

<!-- 그리드 초기화 스크립트 -->
<script type="text/javascript">
jq(function() {
    jq("#list").jqGrid({
        url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/common/venOrderTargetListJQGrid.sys',
        datatype: 'json',
        mtype: 'POST',
        colNames:['주문번호','상품명','수량','고객사명','공급사명','상품ID','공급사ID'],
        colModel:[
            {name:'ORDE_IDEN_NUMB',index:'ORDE_IDEN_NUMB', width:100,align:"left",search:false,sortable:true,
                editable:false, editrules:{required:true}
            },  //주문번호 
            {name:'GOOD_NAME',index:'GOOD_NAME', width:128,align:"left",search:false,sortable:true,
                editable:false
            },  //상품명
            {name:'PURC_REQU_QUAN',index:'PURC_REQU_QUAN', width:40,align:"right",search:false,sortable:true,
            	 editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" } 
            }, //수량
            {name:'ORDE_CLIENT_NAME',index:'ORDE_CLIENT_NAME', width:100,align:"center",search:false,sortable:true,
                editable:false 
            },   // 고객사명
            {name:'VENDORNM',index:'VENDORNM', width:80,align:"center",search:false,sortable:true,
                editable:false 
            },   // 공급사명
            {name:'GOOD_IDEN_NUMB',index:'GOOD_IDEN_NUMB', width:80,align:"center",search:false,sortable:false,
                editable:false , hidden:true
            },   // 상품ID
            {name:'VENDORID',index:'VENDORID', width:80,align:"center",search:false,sortable:false,
                editable:false , hidden:true
            }   // 공급사ID
        ],
        postData: {},
        height:132 ,width: 490, rowNum: 0,
        sortname: 'ORDE_IDEN_NUMB', sortorder: 'desc',
        caption:"발주접수 대상",
        viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false, //해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
        loadComplete: function() {},
        onSelectRow: function (rowid, iRow, iCol, e) {},    
        ondblClickRow: function (rowid, iRow, iCol, e) {},
        onCellSelect: function(rowid, iCol, cellcontent, target){
        	var selrowContent = jq("#list").jqGrid('getRowData',rowid);
			var cm = jq("#list").jqGrid("getGridParam", "colModel");
			var colName = cm[iCol];
			if(colName != undefined &&colName['index']=="GOOD_NAME") { 
			fnVendorProductDetailView(12798, selrowContent.GOOD_IDEN_NUMB, selrowContent.VENDORID);
			}
        },
        afterInsertRow:function(rowid, aData) {
            jq("#list").setCell(rowid,'GOOD_NAME','',{color:'#0000ff'});
            jq("#list").setCell(rowid,'GOOD_NAME','',{cursor: 'pointer'});  
        },
        loadError : function(xhr, st, str){ $("#list").html(xhr.responseText); },
        jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"}
    }); 
});
</script>

<!-- 그리드 초기화 스크립트 -->
<script type="text/javascript">
jq(function() {
    jq("#list1").jqGrid({
        url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/common/venShipTargetListJQGrid.sys',
        datatype: 'json',
        mtype: 'POST',
        colNames:['주문번호','상품명','수량','고객사명','공급사명','상품ID','공급사ID'],
        colModel:[
            {name:'ORDE_IDEN_NUMB',index:'ORDE_IDEN_NUMB', width:100,align:"left",search:false,sortable:true,
                editable:false, editrules:{required:true}
            },  //주문번호 
            {name:'GOOD_NAME',index:'GOOD_NAME', width:128,align:"center",search:false,sortable:true,
                editable:false
            },  //상품명
            {name:'PURC_REQU_QUAN',index:'PURC_REQU_QUAN', width:40,align:"right",search:false,sortable:true,
            	 editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" } 
            }, //수량
            {name:'ORDE_CLIENT_NAME',index:'ORDE_CLIENT_NAME', width:100,align:"center",search:false,sortable:true,
                editable:false 
            },   // 고객사명
            {name:'VENDORNM',index:'VENDORNM', width:80,align:"center",search:false,sortable:true,
                editable:false 
            },   // 공급사명
            {name:'GOOD_IDEN_NUMB',index:'GOOD_IDEN_NUMB', width:80,align:"center",search:false,sortable:false,
                editable:false , hidden:true
            },   // 상품ID
            {name:'VENDORID',index:'VENDORID', width:80,align:"center",search:false,sortable:false,
                editable:false , hidden:true
            }   // 공급사ID
        ],
        postData: {},
        height:132 ,width: 490, rowNum: 0,
        sortname: 'ORDE_IDEN_NUMB', sortorder: 'desc',
        caption:"출하 대상",
        viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false, //해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
        loadComplete: function() {},
        onSelectRow: function (rowid, iRow, iCol, e) {},    
        ondblClickRow: function (rowid, iRow, iCol, e) {},
		onCellSelect: function(rowid, iCol, cellcontent, target){
		    var selrowContent = jq("#list1").jqGrid('getRowData',rowid);
			var cm = jq("#list1").jqGrid("getGridParam", "colModel");
			var colName = cm[iCol];
			if(colName != undefined &&colName['index']=="GOOD_NAME") { 
				fnVendorProductDetailView(12799, selrowContent.GOOD_IDEN_NUMB, selrowContent.VENDORID);
			}
		},
        afterInsertRow:function(rowid, aData) {
            jq("#list1").setCell(rowid,'GOOD_NAME','',{color:'#0000ff'});
            jq("#list1").setCell(rowid,'GOOD_NAME','',{cursor: 'pointer'});  
        },
        loadError : function(xhr, st, str){ $("#list").html(xhr.responseText); },
        jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"}
    }); 
});
</script>

<!-- 그리드 초기화 스크립트 -->
<script type="text/javascript">
jq(function() {
    jq("#list2").jqGrid({
        url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/common/venShippingDestiListJQGrid.sys',
        datatype: 'json',
        mtype: 'POST',
        colNames:['주문번호','상품명','수량','고객사명','공급사명','상품ID','공급사ID'],
        colModel:[
            {name:'ORDE_IDEN_NUMB',index:'ORDE_IDEN_NUMB', width:100,align:"left",search:false,sortable:true,
                editable:false, editrules:{required:true}
            },  //주문번호 
            {name:'GOOD_NAME',index:'GOOD_NAME', width:128,align:"center",search:false,sortable:true,
                editable:false
            },  //상품명
            {name:'DELI_PROD_QUAN',index:'DELI_PROD_QUAN', width:40,align:"right",search:false,sortable:true,
            	 editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" } 
            }, //수량
            {name:'ORDE_CLIENT_NAME',index:'ORDE_CLIENT_NAME', width:100,align:"center",search:false,sortable:true,
                editable:false 
            },   // 고객사명
            {name:'VENDORNM',index:'VENDORNM', width:80,align:"center",search:false,sortable:true,
                editable:false 
            },   // 공급사명
            {name:'GOOD_IDEN_NUMB',index:'GOOD_IDEN_NUMB', width:80,align:"center",search:false,sortable:false,
                editable:false , hidden:true
            },   // 상품ID
            {name:'VENDORID',index:'VENDORID', width:80,align:"center",search:false,sortable:false,
                editable:false , hidden:true
            }   // 공급사ID
        ],
        postData: {},
        height:130 ,width: 490, rowNum: 0,
        sortname: 'ORDE_IDEN_NUMB', sortorder: 'desc',
        caption:"배송완료 대상",
        viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false, //해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
        loadComplete: function() {},
        onSelectRow: function (rowid, iRow, iCol, e) {},    
        ondblClickRow: function (rowid, iRow, iCol, e) {},
        onCellSelect: function(rowid, iCol, cellcontent, target){
			var cm = jq("#list2").jqGrid("getGridParam", "colModel");
			var colName = cm[iCol];
            var selrowContent = jq("#list2").jqGrid('getRowData',rowid);

			if(colName != undefined &&colName['index']=="GOOD_NAME") {
				fnVendorProductDetailView(12800, selrowContent.GOOD_IDEN_NUMB, selrowContent.VENDORID); 
    		}
		},
        afterInsertRow:function(rowid, aData) {
            jq("#list2").setCell(rowid,'GOOD_NAME','',{color:'#0000ff'});
            jq("#list2").setCell(rowid,'GOOD_NAME','',{cursor: 'pointer'});  
        },
        loadError : function(xhr, st, str){ $("#list").html(xhr.responseText); },
        jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"}
    }); 
});
</script>

<!-- 그리드 초기화 스크립트 -->
<script type="text/javascript">
jq(function() {
    jq("#list3").jqGrid({
        url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/common/venReturnRequestListJQGrid.sys',
        datatype: 'json',
        mtype: 'POST',
        colNames:['반품번호','반품사유','반품수량','고객사명','상품ID','공급사ID'],
        colModel:[
            {name:'RETU_IDEN_NUM',index:'RETU_IDEN_NUM', width:50,align:"center",search:false,sortable:true,
                editable:false, editrules:{required:true}
            },  //반품번호 
            {name:'RETU_RESE_TEXT',index:'RETU_RESE_TEXT', width:240,align:"left",search:false,sortable:true,
                editable:false
            },  //반품사유
            {name:'RETU_PROD_QUAN',index:'RETU_PROD_QUAN', width:50,align:"right",search:false,sortable:true,
            	 editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" } 
            }, //반품수량
            {name:'ORDE_CLIENT_NAME',index:'ORDE_CLIENT_NAME', width:113,align:"center",search:false,sortable:true,
                editable:false 
            },   // 고객사명
            {name:'GOOD_IDEN_NUMB',index:'GOOD_IDEN_NUMB', width:80,align:"center",search:false,sortable:false,
                editable:false , hidden:true
            },   // 상품ID
            {name:'VENDORID',index:'VENDORID', width:80,align:"center",search:false,sortable:false,
                editable:false , hidden:true
            }   // 공급사ID
        ],
        postData: {},
        height:80 ,width: 490, rowNum: 0,
        sortname: 'RETU_IDEN_NUM', sortorder: 'desc',
        caption:"반품요청",
        viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false, //해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
        loadComplete: function() {},
        onSelectRow: function (rowid, iRow, iCol, e) {},    
        ondblClickRow: function (rowid, iRow, iCol, e) {},
        onCellSelect: function(rowid, iCol, cellcontent, target){
			var cm = jq("#list3").jqGrid("getGridParam", "colModel");
			var colName = cm[iCol];
			if(colName != undefined &&colName['index']=="RETU_IDEN_NUM") { 
				fnOrderRetrunDetailView(cellcontent);
			}
		},
        afterInsertRow:function(rowid, aData) {
            jq("#list3").setCell(rowid,'RETU_IDEN_NUM','',{color:'#0000ff'});
            jq("#list3").setCell(rowid,'RETU_IDEN_NUM','',{cursor: 'pointer'});  
        },
        loadError : function(xhr, st, str){ $("#list").html(xhr.responseText); },
        jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"}
    }); 
});
</script>

<!-- 그리드 초기화 스크립트 -->
<script type="text/javascript">
jq(function() {
    jq("#list4").jqGrid({
        url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/common/venProgressBidListJQGrid.sys',
        datatype: 'json',
        mtype: 'POST',
        colNames:['입찰번호','입찰명','종료일시','vendorbidstate'],
        colModel:[
            {name:'bidid',index:'bidid', width:50,align:"center",search:false,sortable:true,
                editable:false, editrules:{required:true}
            },  //입찰번호 
            {name:'bidname',index:'bidname', width:328,align:"left",search:false,sortable:true,
                editable:false
            },  //입찰명
            {name:'bidenddate',index:'bidenddate', width:94,align:"center",search:false,sortable:true,
                editable:false 
            },   // 종료일시
            {name:'vendorbidstate',index:'vendorbidstate', hidden:true}	//vendorbidstate
        ],
        postData: {},
        height:80 ,width: 490, rowNum: 0,
        sortname: 'bidenddate', sortorder: 'asc',
        caption:"진행중 입찰",
        viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false, //해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
        loadComplete: function() {},
        onSelectRow: function (rowid, iRow, iCol, e) {},    
        ondblClickRow: function (rowid, iRow, iCol, e) {},
        onCellSelect: function(rowid, iCol, cellcontent, target){
        	var selrowContent = jq("#list4").jqGrid('getRowData',rowid);
        	var cm = $("#list4").jqGrid('getGridParam','colModel');
			if(cm[iCol]!=undefined && cm[iCol].index == 'bidid') {
				if(selrowContent.vendorbidstate == '10' || 'ADM'=='<%=userInfoDto.getSvcTypeCd() %>') {
					editRow(rowid,'<%=vendorid%>');
				} else {
					fnEditRow(rowid,'<%=vendorid%>');
				}
			}
        },
        afterInsertRow:function(rowid, aData) {
            jq("#list4").setCell(rowid,'bidid','',{color:'#0000ff'});
            jq("#list4").setCell(rowid,'bidid','',{cursor: 'pointer'});  
        },
        loadError : function(xhr, st, str){ $("#list").html(xhr.responseText); },
        jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"}
    }); 
});
</script>

<!-- 그리드 초기화 스크립트 -->
<script type="text/javascript">
jq(function() {
    jq("#list5").jqGrid({
        url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/common/venProductRegReqListJQGrid.sys',
        datatype: 'json',
        mtype: 'POST',
        colNames:['상품명','진행상태','요청일시' , 'req_good_id'],
        colModel:[
            {name:'good_name',index:'good_name', width:336,align:"left",search:false,sortable:true,
                editable:false, editrules:{required:true}
            },  //상품명 
            {name:'stateNm',index:'stateNm', width:50,align:"center",search:false,sortable:true,
                editable:false
            },  //진행상태
            {name:'insert_date',index:'insert_date', width:70,align:"center",search:false,sortable:true,
                editable:false 
            },   // 요청일시
            {name:'req_good_id',index:'req_good_id', hidden:true
            }   // 요청일시
        ],
        postData: {},
        height:80 ,width: 490, rowNum: 0,
        sortname: 'good_name', sortorder: 'desc',
        caption:"공급사상품등록요청",
        viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false, //해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
        loadComplete: function() {},
        onSelectRow: function (rowid, iRow, iCol, e) {},    
        ondblClickRow: function (rowid, iRow, iCol, e) {},
        onCellSelect: function(rowid, iCol, cellcontent, target){
        	var cm = $("#list5").jqGrid('getGridParam','colModel');
			if(cm[iCol]!=undefined && cm[iCol].index == 'good_name') 
    			detail(FNgetGridDataObj('list5', rowid , 'req_good_id'));
// 			alert(FNgetGridDataObj('list5', rowid , 'req_good_id'));
			
        },
        afterInsertRow:function(rowid, aData) {
            jq("#list5").setCell(rowid,'good_name','',{color:'#0000ff'});
            jq("#list5").setCell(rowid,'good_name','',{cursor: 'pointer'});  
        },
        loadError : function(xhr, st, str){ $("#list").html(xhr.responseText); },
        jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"}
    }); 
});
</script>

<!-- 그리드 초기화 스크립트 -->
<script type="text/javascript">
jq(function() {
    jq("#list6").jqGrid({
        url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/common/venBoardListJQGrid.sys',
        datatype: 'json',
        mtype: 'POST',
        colNames:['번호','제목','등록일','board_Borg_Type','board_Type'],
        colModel:[
            {name:'board_No',index:'board_No', width:50,align:"center",search:false,sortable:true,
                editable:false, editrules:{required:true}
            },  //번호 
            {name:'title',index:'title', width:345,align:"left",search:false,sortable:true,
                editable:false
            },  //제목
            {name:'regi_Date_Time',index:'regi_Date_Time', width:80,align:"center",search:false,sortable:true,
                editable:false
            },  // 등록일
            {name:'board_Borg_Type',index:'board_Borg_Type', width:80,align:"center",search:false,sortable:false,
                editable:false ,hidden:true
            },  // board_borg_type
            {name:'board_Type',index:'board_Type', width:80,align:"center",search:false,sortable:false,
                editable:false ,hidden:true
            }   // board_Type
        ],
        postData: {},
        height:80 ,width: 490, rowNum: 0,
        sortname: 'board_No', sortorder: 'desc',
        caption:"공지사항",
        viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false, //해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
        loadComplete: function() {},
        onSelectRow: function (rowid, iRow, iCol, e) {},    
        ondblClickRow: function (rowid, iRow, iCol, e) {},
        onCellSelect: function(rowid, iCol, cellcontent, target){
            viewRow();
        },
        afterInsertRow:function(rowid, aData) {
            jq("#list6").setCell(rowid,'board_No','',{color:'#0000ff'});
            jq("#list6").setCell(rowid,'board_No','',{cursor: 'pointer'});  
        },
        loadError : function(xhr, st, str){ $("#list").html(xhr.responseText); },
        jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"}
    }); 
});
</script>

<!-- 그리드 이벤트 스크립트 -->
<script type="text/javascript">
function viewRow() {
    var row = jq("#list6").jqGrid('getGridParam','selrow'); // 선택된 로우 조회
    if( row != null ){
        var selrowContent = jq("#list6").jqGrid('getRowData',row);        // 선택된 로우의 데이터 객체 조회
        var popurl = "/board/noticeDetail.sys?board_No=" + selrowContent.board_No;
        var popproperty = "dialogWidth:720px;dialogHeight=500px;scroll=auto;status=no;resizable=no;";
//         window.showModalDialog(popurl,self,popproperty);
        window.open(popurl, 'okplazaPop', 'width=720, height=500, scrollbars=yes, status=no, resizable=no');
    } else { jq( "#dialogSelectRow" ).dialog(); }
}

function editRow(rowid, vendorid) {
	var selrowContent = jq("#list4").jqGrid('getRowData',rowid);
	var bidid = selrowContent.bidid;
		var popurl = "/product/venProductTendorRegist.sys?_menuId=12796&bidid="+bidid+"&vendorid="+vendorid;
	var popproperty = "dialogWidth:930px;dialogHeight=700px;scroll=yes;status=no;resizable=no;";
// 	window.showModalDialog(popurl,self,popproperty);
	window.open(popurl, 'okplazaPop', 'width=930, height=700, scrollbars=yes, status=no, resizable=no');
}

function detail(req_good_id) {
// 	var selrowContent = jq("#list5").jqGrid('getRowData',rowid);
// 	var good_name = selrowContent.good_name;
	fnReqProductDetailView('12782',req_good_id);
}

function fnOrderRetrunDetailView(str1){
   	var popurl = "/order/returnOrder/returnOrderRegistDetail.sys?retu_iden_num=" + str1;
   	var popproperty = "dialogWidth:800px;dialogHeight=330px;scroll=yes;status=no;resizable=no;";
//     window.showModalDialog(popurl,self,popproperty);  
    window.open(popurl, 'okplazaPop', 'width=800, height=330, scrollbars=yes, status=no, resizable=no');
}
</script>

<script type="text/javascript">
$(document).ready(function(){
	$("#question").click( function() { vendorManual(); });	//메뉴얼호출
});

function vendorManual(){
	//공급사홈
	var header = "Home";
	var manualPath = "/img/manual/vendor/venHome.jpg";
	var popUrl = "/system/manual.sys?header="+header+"&manualPath="+manualPath;
	window.open(popUrl, 'okplazaPop', 'width=1050, height=800, scrollbars=yes, status=no, resizable=no');
}
</script>
</head>
<body>
<table width="100%" border="0" cellspacing="0" cellpadding="0" align="left">
	<tr>
		<td bgcolor="#FFFFFF">
			<!-- 타이틀 -->
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				<tr valign="top">
					<td width="20" valign="middle"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_ptitle1.gif" width="14" height="15"/></td>
					<td height="29" class='ptitle'>Home
						&nbsp;<span id="question" class="questionButton">도움말</span>
					</td>
				</tr>
			</table>


			<table width="1050"  border="0" align="left" cellpadding="0" cellspacing="0">
				<tr>
					<td bgcolor="#FFFFFF">
						<table border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td width="301" valign="top">
									<!-- 왼쪽영역 시작 -->
									<!-- 납품관리 시작 -->
									<table width="100%" border="0" cellspacing="0" cellpadding="0">
										<tr>
											<td width="10"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/FR/tbl_box_tl.gif" width="10" height="12"/></td>
											<td style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/FR/tbl_box_top.gif');"></td>
											<td width="10"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/FR/tbl_box_tr.gif" width="10" height="12"/></td>
										</tr>
										<tr>
											<td width="10" style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/FR/tbl_box_left.gif');"></td>
											<td>
												<!-- 서브타이틀 시작-->
												<table width="100%"  border="0" cellspacing="0" cellpadding="0">
													<tr valign="top">
														<td width="24"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/FR/bullet_ptitle4.gif" width="18" height="18"/></td>
														<td height="29" class='ptitle' style="vertical-align: top;">납품관리</td>
													</tr>
												</table>
												
												<!-- 서브타이틀 끝-->
												<!-- 발주접수 대상 시작-->
												<table width="100%" border="0" cellpadding="0" cellspacing="0" style="height: 27px">
													<tr>
														<td width="20" valign="top" ><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/FR/bullet_stitle_blue.gif" width="5" height="5" class="bullet_stitle"/></td>
														<td class="stitle">발주접수 대상</td>
													</tr>
												</table>
												 <table width="100%"  border="0" cellspacing="0" cellpadding="0">
                                                    <tr>
                                                        <td>
                                                            <div id="jqgrid">
                                                                <table id="list"></table>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </table>
												<!-- 발주접수 대상 끝-->
												<!-- 출하 대상 시작-->
												<table width="100%" border="0" cellpadding="0" cellspacing="0" style="height: 27px">
													<tr>
														<td width="20" valign="top" ><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/FR/bullet_stitle_blue.gif" width="5" height="5" class="bullet_stitle"/></td>
														<td class="stitle">출하 대상</td>
													</tr>
												</table>
												 <table width="100%"  border="0" cellspacing="0" cellpadding="0">
                                                    <tr>
                                                        <td>
                                                            <div id="jqgrid">
                                                                <table id="list1"></table>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </table>
												<!-- 출하 대상 끝-->
												<!-- 배송완료 대상 시작-->
												<table width="100%" border="0" cellpadding="0" cellspacing="0" style="height: 27px">
													<tr>
														<td width="20" valign="top" ><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/FR/bullet_stitle_blue.gif" width="5" height="5" class="bullet_stitle"/></td>
														<td class="stitle">배송완료 대상</td>
													</tr>
												</table>
												 <table width="100%"  border="0" cellspacing="0" cellpadding="0">
                                                    <tr>
                                                        <td>
                                                            <div id="jqgrid">
                                                                <table id="list2"></table>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </table>
												<!-- 배송완료 대상 끝-->
											</td>
											<td style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/FR/tbl_box_right.gif');"></td>
										</tr>
										<tr>
											<td width="10"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/FR/tbl_box_bl.gif" width="10" height="12"/></td>
											<td style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/FR/tbl_box_bottom.gif');"></td>
											<td width="10"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/FR/tbl_box_br.gif" width="10" height="12"/></td>
										</tr>
									</table>
									<!-- 납품관리 끝 -->
									<!-- 왼쪽영역 끝 --> 
								</td>
								<td width="13"></td>
								<td width="505" valign="top">
								<!-- 오른쪽영역 시작 -->
								<!-- 기타 시작 -->
									<table width="100%" border="0" cellspacing="0" cellpadding="0">
										<tr>
											<td width="10"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/FR/tbl_box_tl.gif" width="10" height="12"/></td>
											<td style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/FR/tbl_box_top.gif');"></td>
											<td width="10"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/FR/tbl_box_tr.gif" width="10" height="12"/></td>
										</tr>
										<tr>
											<td width="10" style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/FR/tbl_box_left.gif');"></td>
											<td>
											<!-- 서브타이틀 시작-->
											<table width="100%"  border="0" cellspacing="0" cellpadding="0">
												<tr valign="top">
													<td width="24"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/FR/bullet_ptitle4.gif" width="18" height="18"/></td>
													<td height="29" class='ptitle' style="vertical-align: top;">기타</td>
												</tr>
											</table>
											<!-- 서브타이틀 끝-->
											<!-- 반품요청 시작-->
											<table width="100%" border="0" cellpadding="0" cellspacing="0" style="height: 27px">
												<tr>
													<td width="20" valign="top" ><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/FR/bullet_stitle_blue.gif" width="5" height="5" class="bullet_stitle"/></td>
													<td class="stitle">반품요청</td>
												</tr>
											</table>
											 <table width="100%"  border="0" cellspacing="0" cellpadding="0">
                                                    <tr>
                                                        <td>
                                                            <div id="jqgrid">
                                                                <table id="list3"></table>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </table>
											<!-- 반품요청 끝-->
											<!-- 진행중 입찰 시작-->
											<table width="100%" border="0" cellpadding="0" cellspacing="0" style="height: 27px">
												<tr>
													<td width="20" valign="top" ><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/FR/bullet_stitle_blue.gif" width="5" height="5" class="bullet_stitle"/></td>
													<td class="stitle">진행중 입찰</td>
												</tr>
											</table>
											 <table width="100%"  border="0" cellspacing="0" cellpadding="0">
                                                    <tr>
                                                        <td>
                                                            <div id="jqgrid">
                                                                <table id="list4"></table>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </table>
											<!-- 진행중 입찰 끝-->
											<!-- 공급사상품등록요청 시작-->
											<table width="100%" border="0" cellpadding="0" cellspacing="0" style="height: 27px">
												<tr>
													<td width="20" valign="top" ><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/FR/bullet_stitle_blue.gif" width="5" height="5" class="bullet_stitle"/></td>
													<td class="stitle">공급사상품등록요청(<%=srcStartDate %> ~ <%=srcEndDate %>)</td>
												</tr>
											</table>
											 <table width="100%"  border="0" cellspacing="0" cellpadding="0">
                                                    <tr>
                                                        <td>
                                                            <div id="jqgrid">
                                                                <table id="list5"></table>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </table>
											<!-- 공급사상품등록요청 끝-->
											<!-- 공지사항 시작-->
											<table width="100%" border="0" cellpadding="0" cellspacing="0" style="height: 27px">
												<tr>
													<td width="20" valign="top" ><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/FR/bullet_stitle_blue.gif" width="5" height="5" class="bullet_stitle"/></td>
													<td class="stitle">공지사항</td>
												</tr>
											</table>
											 <table width="100%"  border="0" cellspacing="0" cellpadding="0">
                                                    <tr>
                                                        <td>
                                                            <div id="jqgrid">
                                                                <table id="list6"></table>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </table>
											<!-- 공지사항 끝-->
											</td>
											<td style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/FR/tbl_box_right.gif');"></td>
										</tr>
										<tr>
                                            <td width="10"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/FR/tbl_box_bl.gif" width="10" height="12"/></td>
                                            <td style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/FR/tbl_box_bottom.gif');"></td>
                                            <td width="10"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/FR/tbl_box_br.gif" width="10" height="12"/></td>
                                        </tr>
									</table>
									<!-- 기타 끝 -->
									<!-- 오른쪽영역 끝 --> 
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
			<div id="dialog" title="Feature not supported" style="display:none;">
				<p>That feature is not supported.</p>
			</div>
		</td>
	</tr>
</table>
<!-- 설문조사 팝업 처리 시작 -->
<div id="pollPop"></div>
<script src="<%=Constances.SYSTEM_JSCSS_URL%>/jq/js/src/jqModal.js" type="text/javascript"></script>
<script src="<%=Constances.SYSTEM_JSCSS_URL%>/jq/js/src/jqDnR.js" type="text/javascript"></script>
<script type="text/javascript">
$(function() {
    $.ajaxSetup ({
        cache: false
    });
    $('#pollPop').load('/board/poll/popup.sys');
});
</script>
<!-- 설문조사 팝업 처리 끝 -->
</body>
</html>