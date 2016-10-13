<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils"%>

<%
	String srcStartDate = CommonUtils.getCustomDay("MONTH",-1);
	String srcEndDate = CommonUtils.getCurrentDate();
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>

<script type="text/javascript">
var jq = jQuery;
$(document).ready(function() {
    
});
</script>

<!-- 그리드 초기화 스크립트 -->
<script type="text/javascript">
jq(function() {
    jq("#list1").jqGrid({
        url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/common/cenPickingRegListJQGrid.sys',
        datatype: 'json',
        mtype: 'POST',
        colNames:['주문번호','상품명','수량','고객사명','상품ID','공급사ID'],
        colModel:[
            {name:'ORDE_IDEN_NUMB',index:'ORDE_IDEN_NUMB', width:100,align:"center",search:false,sortable:true,
                editable:false, editrules:{required:true}
            },  //주문번호 
            {name:'GOOD_NAME',index:'GOOD_NAME', width:230,align:"left",search:false,sortable:true,
                editable:false
            },  //상품명
            {name:'PURC_REQU_QUAN',index:'PURC_REQU_QUAN', width:40,align:"right",search:false,sortable:true,
                editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" } 
            }, //수량
            {name:'ORDE_CLIENT_NAME',index:'ORDE_CLIENT_NAME', width:100,align:"center",search:false,sortable:true,
                editable:false 
            },  // 고객사
            {name:'GOOD_IDEN_NUMB',index:'GOOD_IDEN_NUMB', width:80,align:"center",search:false,sortable:true,
                editable:false, hidden:true
            },  // 상품ID
            {name:'VENDORID',index:'VENDORID', width:80,align:"center",search:false,sortable:true,
                editable:false , hidden:true
            }   // 공급사ID
        ],
        postData: {},
        height:100 ,width: 490, rowNum: 0,
        sortname: 'ORDE_IDEN_NUMB', sortorder: 'desc',
        caption:"Picking 등록 대상",
        viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false, //해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
        loadComplete: function() {},
        onSelectRow: function (rowid, iRow, iCol, e) {},    
        ondblClickRow: function (rowid, iRow, iCol, e) {},
        onCellSelect: function(rowid, iCol, cellcontent, target){
		    var selrowContent = jq("#list1").jqGrid('getRowData',rowid);
			var cm = jq("#list1").jqGrid("getGridParam", "colModel");
			var colName = cm[iCol];
			if(colName != undefined &&colName['index']=="orde_iden_numb") { 
				fnOrderDetailView(cellcontent, 13226 ,selrowContent.purc_iden_numb);
			}
		},
        afterInsertRow:function(rowid, aData) {
            jq("#list1").setCell(rowid,'ORDE_IDEN_NUMB','',{color:'#0000ff'});
            jq("#list1").setCell(rowid,'ORDE_IDEN_NUMB','',{cursor: 'pointer'});  
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
        url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/common/cenFactoryConListJQGrid.sys',
        datatype: 'json',
        mtype: 'POST',
        colNames:['주문번호','상품명','수량','고객사명','상품ID','공급사ID'],
        colModel:[
            {name:'ORDE_IDEN_NUMB',index:'ORDE_IDEN_NUMB', width:100,align:"center",search:false,sortable:true,
                editable:false, editrules:{required:true}
            },  //주문번호 
            {name:'GOOD_NAME',index:'GOOD_NAME', width:230,align:"left",search:false,sortable:true,
                editable:false
            },  //상품명
            {name:'PURC_REQU_QUAN',index:'PURC_REQU_QUAN', width:40,align:"right",search:false,sortable:true,
                editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" } 
            }, //수량
            {name:'ORDE_CLIENT_NAME',index:'ORDE_CLIENT_NAME', width:100,align:"center",search:false,sortable:true,
                editable:false 
            },  // 고객사
            {name:'GOOD_IDEN_NUMB',index:'GOOD_IDEN_NUMB', width:80,align:"center",search:false,sortable:true,
                editable:false, hidden:true
            },  // 상품ID
            {name:'VENDORID',index:'VENDORID', width:80,align:"center",search:false,sortable:true,
                editable:false , hidden:true
            }   // 공급사ID
        ],
        postData: {},
        height:100 ,width: 490, rowNum: 0,
        sortname: 'ORDE_IDEN_NUMB', sortorder: 'desc',
        caption:"출고 확정/ 인수증 출력",
        viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false, //해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
        loadComplete: function() {},
        onSelectRow: function (rowid, iRow, iCol, e) {},    
        ondblClickRow: function (rowid, iRow, iCol, e) {},
        onCellSelect: function(rowid, iCol, cellcontent, target){
			var cm = jq("#list2").jqGrid("getGridParam", "colModel");
			var colName = cm[iCol];
			if(colName != undefined &&colName['index']=="ORDE_IDEN_NUMB") { 
				fnOrderDetailView(cellcontent, 13227);
			}
            var selrowContent = jq("#list2").jqGrid('getRowData',rowid);
			if(colName != undefined &&colName['index']=="ORDE_IDEN_NUMB") { 
				fnOrderDetailView(cellcontent,13227,selrowContent.purc_iden_numb); 
			}
		},
        afterInsertRow:function(rowid, aData) {
            jq("#list2").setCell(rowid,'ORDE_IDEN_NUMB','',{color:'#0000ff'});
            jq("#list2").setCell(rowid,'ORDE_IDEN_NUMB','',{cursor: 'pointer'});  
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
        url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/common/cenInvoiceShippingListJQGrid.sys',
        datatype: 'json',
        mtype: 'POST',
        colNames:['주문번호','상품명','수량','고객사명','상품ID','공급사ID'],
        colModel:[
            {name:'ORDE_IDEN_NUMB',index:'ORDE_IDEN_NUMB', width:100,align:"center",search:false,sortable:true,
                editable:false, editrules:{required:true}
            },  //주문번호 
            {name:'GOOD_NAME',index:'GOOD_NAME', width:230,align:"left",search:false,sortable:true,
                editable:false
            },  //상품명
            {name:'PURC_REQU_QUAN',index:'PURC_REQU_QUAN', width:40,align:"right",search:false,sortable:true,
                editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" } 
            }, //수량
            {name:'ORDE_CLIENT_NAME',index:'ORDE_CLIENT_NAME', width:100,align:"center",search:false,sortable:true,
                editable:false 
            },  // 고객사
            {name:'GOOD_IDEN_NUMB',index:'GOOD_IDEN_NUMB', width:80,align:"center",search:false,sortable:true,
                editable:false, hidden:true
            },  // 상품ID
            {name:'VENDORID',index:'VENDORID', width:80,align:"center",search:false,sortable:true,
                editable:false , hidden:true
            }   // 공급사ID
        ],
        postData: {},
        height:100 ,width: 490, rowNum: 0,
        sortname: 'ORDE_IDEN_NUMB', sortorder: 'desc',
        caption:"송장 입력 / 배송 완료",
        viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false, //해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
        loadComplete: function() {},
        onSelectRow: function (rowid, iRow, iCol, e) {},    
        ondblClickRow: function (rowid, iRow, iCol, e) {},
        onCellSelect: function(rowid, iCol, cellcontent, target){
			var cm = jq("#list3").jqGrid("getGridParam", "colModel");
			var colName = cm[iCol];
			if(colName != undefined &&colName['index']=="ORDE_IDEN_NUMB") { 
				fnOrderDetailView(cellcontent, 13228);
			}
		},
        afterInsertRow:function(rowid, aData) {
        	 jq("#list3").setCell(rowid,'ORDE_IDEN_NUMB','',{color:'#0000ff'});
             jq("#list3").setCell(rowid,'ORDE_IDEN_NUMB','',{cursor: 'pointer'});  
             jq("#list3").setCell(rowid,'GOOD_NAME','',{color:'#0000ff'});
             jq("#list3").setCell(rowid,'GOOD_NAME','',{cursor: 'pointer'});   
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
        url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/common/cenEntrustOrderListJQGrid.sys',
        datatype: 'json',
        mtype: 'POST',
        colNames:['주문번호','상품명','수량','공급사','상품ID','공급사ID'],
        colModel:[
            {name:'ORDE_IDEN_NUMB',index:'ORDE_IDEN_NUMB', width:100,align:"center",search:false,sortable:true,
                editable:false, editrules:{required:true}
            },  //주문번호 
            {name:'GOOD_IDEN_NAME',index:'GOOD_IDEN_NAME', width:230,align:"left",search:false,sortable:true,
                editable:false
            },  //상품명
            {name:'ORDE_REQU_QUAN',index:'ORDE_REQU_QUAN', width:40,align:"right",search:false,sortable:true,
                editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" } 
            }, //수량
            {name:'VENDOR_NAME',index:'VENDOR_NAME', width:100,align:"center",search:false,sortable:true,
                editable:false 
            },  // 공급사
            {name:'GOOD_IDEN_NUMB',index:'GOOD_IDEN_NUMB', width:80,align:"center",search:false,sortable:true,
                editable:false, hidden:true
            },  // 상품ID
            {name:'VENDORID',index:'VENDORID', width:80,align:"center",search:false,sortable:true,
                editable:false , hidden:true
            }   // 공급사ID
        ],
        postData: {},
        height:100 ,width: 490, rowNum: 0,
        sortname: 'ORDE_IDEN_NUMB', sortorder: 'desc',
        caption:"수탁발주내역",
        viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false, //해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
        loadComplete: function() {},
        onSelectRow: function (rowid, iRow, iCol, e) {},    
        ondblClickRow: function (rowid, iRow, iCol, e) {},
        onCellSelect: function(rowid, iCol, cellcontent, target){
			var cm = jq("#list4").jqGrid("getGridParam", "colModel");
			var colName = cm[iCol];
			if(colName != undefined &&colName['index']=="ORDE_IDEN_NUMB") { 
			fnOrderDetailView(cellcontent, 13221); 
			}
            var selrowContent = jq("#list4").jqGrid('getRowData',rowid);
			if(colName != undefined &&colName['index']=="GOOD_IDEN_NAME") { 
			fnProductDetailView(13221, selrowContent.GOOD_IDEN_NUMB, selrowContent.VENDORID);
			}
		},
        afterInsertRow:function(rowid, aData) {
            jq("#list4").setCell(rowid,'ORDE_IDEN_NUMB','',{color:'#0000ff'});
            jq("#list4").setCell(rowid,'ORDE_IDEN_NUMB','',{cursor: 'pointer'});  
            jq("#list4").setCell(rowid,'GOOD_IDEN_NAME','',{color:'#0000ff'});
            jq("#list4").setCell(rowid,'GOOD_IDEN_NAME','',{cursor: 'pointer'});  
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
        url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/common/cenEntrustStockListJQGrid.sys',
        datatype: 'json',
        mtype: 'POST',
        colNames:['주문번호','상품명','수량','공급사','상품ID','공급사ID'],
        colModel:[
            {name:'ORDE_IDEN_NUMB',index:'ORDE_IDEN_NUMB', width:100,align:"center",search:false,sortable:true,
                editable:false, editrules:{required:true}
            },  //주문번호 
            {name:'GOOD_NAME',index:'GOOD_NAME', width:230,align:"left",search:false,sortable:true,
                editable:false
            },  //상품명
            {name:'DELI_PROD_QUAN',index:'DELI_PROD_QUAN', width:40,align:"right",search:false,sortable:true,
                editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" } 
            }, //수량
            {name:'VENDORNM',index:'VENDORNM', width:100,align:"center",search:false,sortable:true,
                editable:false 
            },  // 공급사
            {name:'GOOD_IDEN_NUMB',index:'GOOD_IDEN_NUMB', width:80,align:"center",search:false,sortable:true,
                editable:false, hidden:true
            },  // 상품ID
            {name:'VENDORID',index:'VENDORID', width:80,align:"center",search:false,sortable:true,
                editable:false , hidden:true
            }   // 공급사ID
        ],
        postData: {},
        height:100 ,width: 490, rowNum: 0,
        sortname: 'ORDE_IDEN_NUMB', sortorder: 'desc',
        caption:"수탁입고 대상",
        viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false, //해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
        loadComplete: function() {},
        onSelectRow: function (rowid, iRow, iCol, e) {},    
        ondblClickRow: function (rowid, iRow, iCol, e) {},
        onCellSelect: function(rowid, iCol, cellcontent, target){
			var cm = jq("#list5").jqGrid("getGridParam", "colModel");
			var colName = cm[iCol];
			if(colName != undefined &&colName['index']=="ORDE_IDEN_NUMB") { 
				fnOrderDetailView(cellcontent, 13223);
			}
		},
        afterInsertRow:function(rowid, aData) {
        	  jq("#list5").setCell(rowid,'ORDE_IDEN_NUMB','',{color:'#0000ff'});
              jq("#list5").setCell(rowid,'ORDE_IDEN_NUMB','',{cursor: 'pointer'});  
              jq("#list5").setCell(rowid,'GOOD_NAME','',{color:'#0000ff'});
              jq("#list5").setCell(rowid,'GOOD_NAME','',{cursor: 'pointer'});  
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
        url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/common/cenProductStockListJQGrid.sys',
        datatype: 'json',
        mtype: 'POST',
        colNames:['상품명','상품코드','공급사명','ISEXIST','VENDORID'],
        colModel:[
            {name:'GOOD_NAME',index:'GOOD_NAME', width:288,align:"left",search:false,sortable:true,
                editable:false
            },  //상품명
            {name:'GOOD_IDEN_NUMB',index:'GOOD_IDEN_NUMB', width:70,align:"center",search:false,sortable:true,
                editable:false 
            }, //상품코드
            {name:'VENDORNM',index:'VENDORNM', width:100,align:"center",search:false,sortable:true,
                editable:false 
            },  // 공급사
            {name:'ISEXIST',index:'ISEXIST', width:80,align:"center",search:false,sortable:true,
                editable:false, hidden:true
            },  // ISEXIST
            {name:'VENDORID',index:'VENDORID', width:80,align:"center",search:false,sortable:true,
                editable:false, hidden:true
            }  // ISEXIST
        ],
        postData: {},
        height:100 ,width: 490, rowNum: 0,
        sortname: 'GOOD_NAME', sortorder: 'desc',
        caption:"미재고 수탁상품",
        viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false, //해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
        loadComplete: function() {},
        onSelectRow: function (rowid, iRow, iCol, e) {},    
        ondblClickRow: function (rowid, iRow, iCol, e) {},
        onCellSelect:function(rowid,iCol,cellcontent,target) {
        	var cm = jq("#list6").jqGrid("getGridParam", "colModel");
			var colName = cm[iCol];
            var selrowContent = jq("#list6").jqGrid('getRowData',rowid);
			if(colName != undefined &&colName['index']=="GOOD_NAME") { 
				fnProductDetailView(13229, selrowContent.GOOD_IDEN_NUMB, selrowContent.VENDORID);
			}
        },
        afterInsertRow:function(rowid, aData) {
            jq("#list6").setCell(rowid,'GOOD_NAME','',{color:'#0000ff'});
            jq("#list6").setCell(rowid,'GOOD_NAME','',{cursor: 'pointer'});  
        },
        loadError : function(xhr, st, str){ $("#list").html(xhr.responseText); },
        jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"}
    }); 
});
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
					<td height="29" class='ptitle'>Home</td>
				</tr>
			</table>
			<!-- 그리드시작 -->
			<table width="1050"  border="0" align="left" cellpadding="0" cellspacing="0">
				<tr>
					<td bgcolor="#FFFFFF">
						<table border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td width="505" valign="top">
								<!-- 왼쪽영역 시작 -->
								<!-- 수탁출고 시작 -->
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
														<td height="29" class='ptitle' style="vertical-align: top;">수탁출고</td>
													</tr>
												</table>
												<!-- 서브타이틀 끝-->
												<!-- 발주접수 대상 시작-->
												<table width="100%" border="0" cellpadding="0" cellspacing="0" style="height: 27px">
													<tr>
														<td width="20" valign="top" ><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/FR/bullet_stitle_blue.gif" width="5" height="5" class="bullet_stitle"/></td>
														<td class="stitle">Picking 등록 대상</td>
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
												<!-- 발주접수 대상 끝-->
												<!-- 출하 대상 시작-->
												<table width="100%" border="0" cellpadding="0" cellspacing="0" style="height: 27px">
													<tr>
														<td width="20" valign="top" ><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/FR/bullet_stitle_blue.gif" width="5" height="5" class="bullet_stitle"/></td>
														<td class="stitle">출고 확정/ 인수증 출력</td>
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
												<!-- 출하 대상 끝-->
												<!-- 배송완료 대상 시작-->
												<table width="100%" border="0" cellpadding="0" cellspacing="0" style="height: 27px">
													<tr>
														<td width="20" valign="top" ><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/FR/bullet_stitle_blue.gif" width="5" height="5" class="bullet_stitle"/></td>
														<td class="stitle">송장 입력 / 배송 완료</td>
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
												<!-- 배송완료 대상 끝-->
											</td>
											<td width="10" style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/FR/tbl_box_right.gif');"></td>
										</tr>
										<tr>
											<td width="10"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/FR/tbl_box_bl.gif" width="10" height="12"/></td>
											<td style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/FR/tbl_box_bottom.gif');"></td>
											<td width="10"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/FR/tbl_box_br.gif" width="10" height="12"/></td>
										</tr>
									</table>
									<!-- 추탁출고 끝 -->
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
												<!-- 수탁발주내역 시작-->
												<table width="100%" border="0" cellpadding="0" cellspacing="0" style="height: 27px">
													<tr>
														<td width="20" valign="top" ><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/FR/bullet_stitle_blue.gif" width="5" height="5" class="bullet_stitle"/></td>
														<td class="stitle">수탁발주내역(<%=srcStartDate %> ~ <%=srcEndDate %>)</td>
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
												<!-- 수탁발주내역 끝-->
												<!-- 수탁입고 대상 시작-->
												<table width="100%" border="0" cellpadding="0" cellspacing="0" style="height: 27px">
													<tr>
														<td width="20" valign="top" ><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/FR/bullet_stitle_blue.gif" width="5" height="5" class="bullet_stitle"/></td>
														<td class="stitle">수탁입고 대상</td>
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
												<!-- 수탁입고 대상 끝-->
												<!-- 미재고 수탁상품 시작-->
												<table width="100%" border="0" cellpadding="0" cellspacing="0" style="height: 27px">
													<tr>
														<td width="20" valign="top" ><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/FR/bullet_stitle_blue.gif" width="5" height="5" class="bullet_stitle"/></td>
														<td class="stitle">미재고 수탁상품</td>
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
												<!-- 미재고 수탁상품 끝-->
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
			<!-- 그리드끝 -->
			<div id="dialog" title="Feature not supported" style="display:none;">
				<p>That feature is not supported.</p>
			</div>
		</td>
	</tr>
</table>
</body>
</html>