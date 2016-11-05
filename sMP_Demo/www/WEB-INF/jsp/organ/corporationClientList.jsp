<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="kr.co.bitcube.common.dto.CodesDto" %>
<%@ page import="java.util.List"%>
<%
	@SuppressWarnings("unchecked")	
	List<ActivitiesDto> roleList = (List<ActivitiesDto>)request.getAttribute("useActivityList"); //화면권한가져오기(필수)
	String _menuId = CommonUtils.getRequestMenuId(request);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>
<%@ include file="/WEB-INF/jsp/common/svcUserListDiv.jsp" %>
</head>
<jsp:include page="/WEB-INF/jsp/system/treeFrame/adminMenu.jsp" flush="false" />
<body>
<form id="frm" name="frm" onsubmit="return false;">
<table width="1500px" style="margin-left: 0px;" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td bgcolor="#FFFFFF">
			<table width="1500px"  border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="20" valign="middle">
						<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_ptitle1.gif" width="14" height="15"/>
					</td>
					<td height="25" class='ptitle'>법인 조회</td>
					<td align="right" class='ptitle'>
						<button id='srcBranchButton' class="btn btn-primary btn-sm" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>"><i class="fa fa-search"></i> 사업장 조회</button>
						<button id='srcUsrButton'    class="btn btn-primary btn-sm" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>"><i class="fa fa-search"></i> 사용자 조회</button>
						<button id='srcButton'       class="btn btn-default btn-sm" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>"><i class="fa fa-search"></i> 조회</button>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td height="1"></td>
	</tr>
	<tr>
		<td>
			<table width="1500px"  border="0" cellspacing="0" cellpadding="0">
				<colgroup>
					<col width="100px" />
					<col width="400px" />
					<col width="100px" />
					<col width="400px" />
					<col width="100px" />
					<col width="400px" />
				</colgroup>
				<tr>
					<td colspan="6" class="table_top_line"></td>
				</tr>
				<tr>
					<td class="table_td_subject">법인명</td>
					<td class="table_td_contents">
						<input id="srcClientNmTxt" name="srcClientNmTxt" type="text" size="50"/>
					</td>
					<td class="table_td_subject">사용여부</td>
					<td class="table_td_contents">
						<select name="srcIsUseSel" id="srcIsUseSel" >
							<option value="">전체</option>
							<option value="1" selected="selected">Y</option>
							<option value="0">N</option>
						</select>
					</td>
					<td class="table_td_subject">대표자명</td>
					<td class="table_td_contents">
						<input id="srcPressentNm" name="srcPressentNm" type="text" size="50"/>
					</td>
				</tr>
				<tr>
					<td colspan="6" height='1'></td>
				</tr>
				<tr>
					<td class="table_td_subject">사업자등록번호</td>
					<td class="table_td_contents" colspan="5">
						<input id="srcBusinessNum" name="srcBusinessNum" type="text" size="50"/>
					</td>
				</tr>
				<tr>
					<td colspan="6" class="table_top_line"></td>
				</tr>
				<tr>
					<td colspan="6" height='8'></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td>
			<table width="100%" style="height: 100%"  border="0" cellspacing="0" cellpadding="0">
				<col width="485" />
				<col width="10" />
				<col width="100%"/>
				<tr>
					<td align="right">
						<button id='excelButton' class="btn btn-success btn-xs" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>"><i class="fa fa-file-excel-o"></i> 엑셀</button>
						<button id='srcClientReg' class="btn btn-primary btn-xs" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>"><i class="fa fa-plus"></i> 등록</button>
					</td>
					<td></td>
					<td></td>
				</tr>
				<tr>
					<td height='2'></td>
				</tr>
				<tr>
					<td>
						<table id="list"></table>
						<div id="pager"></div>
					</td>
					<td>&nbsp;&nbsp;</td>
					<td>
						<div id="jqgrid">
							<table id="list2"></table>
						</div>
					</td>
				</tr>
			</table>
			<div id="dialog" title="Feature not supported" style="display:none;">
				<p>That feature is not supported.</p>
			</div>
		</td>
	</tr>
</table>
<div id="dialogSelectRow" title="Warning" style="display:none;font-size: 12px;color: red;">
	<p>처리할 데이터를 선택 하십시오!</p>
</div>
</form>
</body>
<script type="text/javascript">
$(document).ready(function(){
	$("#srcButton").click(function(){
		jq("#list").jqGrid("setGridParam", {"page":1});   
		var data = jq("#list").jqGrid("getGridParam", "postData");
		data.srcClientNm = $("#srcClientNmTxt").val();
		data.srcIsUse = $("#srcIsUseSel").val();
		data.srcPressentNm = $("#srcPressentNm").val();
		data.srcBusinessNum = $("#srcBusinessNum").val();
		jq("#list").jqGrid("setGridParam", { "postData": data });
		jq("#list").trigger("reloadGrid");
	});
	
	$("#srcClientNmTxt").keydown(function(key){
		if(key.keyCode == 13){
			$("#srcButton").click();
		}
	});
	$("#srcPressentNm").keydown(function(key){
		if(key.keyCode == 13){
			$("#srcButton").click();
		}
	});
	$("#srcIsUseSel").change(function(){
		$("#srcButton").click();
	});
	
	$("#srcBranchButton").click(function(){
		location.href="/organ/organBranchList.sys?_menuId=<%=_menuId %>";
	});
	
	$("#srcUsrButton").click(function(){
		location.href="/organ/organUserList.sys?_menuId=<%=_menuId %>";
	});
	
	$("#srcClientReg").click(function(){
		addRow();
	});
	
	$("#excelButton").click(function(){ 
		$("#srcClientNmTxt").val($.trim($("#srcClientNmTxt").val()));
		$("#srcIsUseSel").val($.trim($("#srcIsUseSel").val()));
		$("#srcPressentNm").val($.trim($("#srcPressentNm").val()));
		fnAllExcelPrintDown();
	});
});

<%-- init end --%>
//리사이징
<%
	String listHeight = "$(window).height()-370 + Number(gridHeightResizePlus)";
	String listHeight2 = "$(window).height()-345 + Number(gridHeightResizePlus)";
%>
$(window).bind('resize', function() { 
	$("#list").setGridHeight(<%=listHeight %>);
	$("#list2").setGridHeight(<%=listHeight2 %>);
}).trigger('resize');  


<%-- function start --%>
function addRow() {
    var addCaption = "";
    var topBorgId = 0;
    var borgTypeCd = "";
    var parBorgId = 0;
    var svcTypeCd = "BUY";
    var groupId = 0;
    var clientId = 0;
    var branchId = 0;
    var deptId = 0;
    var borgLevel = 2;
    addCaption = "법인등록";
    borgTypeCd = "CLT";
    groupId = '304452';
	topBorgId = '304452';
	parBorgId = '304452';
	jq("#list").jqGrid('setColProp', 'BORGCD' ,{ editable:true, hidden:false, editoptions:{ disabled:false,size:"10",maxLength:"3", dataInit: function(elem){ $(elem).css("ime-mode", ""); $(elem).css("text-transform","uppercase");} } });   
    jq("#list").jqGrid('setColProp', 'ISLIMIT' ,{ hidden:false, editoptions:{ value:"N:N;Y:Y",disabled:true, dataInit: function(elem){ $(elem).css("ime-mode", "disabled"); } } });  
    jq("#list").jqGrid(
        'editGridRow', 'new',{
            addCaption: addCaption,
            url: "<%=Constances.SYSTEM_CONTEXT_PATH %>/organ/insertClientInfo.sys", 
            editData: {
            	topBorgId:topBorgId, 
            	borgTypeCd:borgTypeCd, 
            	parBorgId:parBorgId, 
            	svcTypeCd:svcTypeCd,
                groupId:groupId, 
                clientId:clientId, 
                branchId:branchId, 
                deptId:deptId, 
                borgLevel:borgLevel
            },
            recreateForm: true,beforeShowForm: function(form) {},
            width:"400",modal:true,closeAfterAdd: true,reloadAfterSubmit:true,
            afterSubmit : function(response, postdata){
                return fnJqTransResult(response, postdata);
            }
        }
    );
    jq("#list").jqGrid('setColProp', 'BORGCD',{editable:true,hidden:true});
	jq("#list").jqGrid('setColProp', 'ISLIMIT' ,{ hidden:false, editoptions:{ value:"N:N;Y:Y",disabled:false, dataInit: function(elem){ $(elem).css("ime-mode", "disabled"); } } }); 
}
function editRow() {
	var row = jq("#list").jqGrid('getGridParam','selrow'); // 선택된 로우 조회
  	if( row != null ){
        var tempSelrowContent = jq("#list").jqGrid('getRowData',row);        // 선택된 로우의 데이터 객체 조회
        var isLimitControll = (tempSelrowContent.ISLIMIT == "N" ? false : true);  
		jq("#list").jqGrid('setColProp', 'BORGCD' ,{ hidden:false, editoptions:{ disabled:true, dataInit: function(elem){ $(elem).css("ime-mode", "disabled"); $(elem).css("text-transform","uppercase");} } }); 
		jq("#list").jqGrid('setColProp', 'ISLIMIT' ,{ hidden:false, editoptions:{ value:"N:N;Y:Y",disabled:isLimitControll, dataInit: function(elem){ $(elem).css("ime-mode", "disabled"); } } });
	    jq("#list").jqGrid('setColProp', 'LOAN' ,{ hidden:false, editoptions:{ dataInit: function(elem){ $(elem).val( $(elem).val()/1000000    );   $(elem).css("text-align","right");       } } });
  		jq("#list").jqGrid(
  			'editGridRow', row,{ 
  				bottominfo:"<font color='red'>(*)</font>는 필수 입력정보 입니다.",
  				url:"<%=Constances.SYSTEM_CONTEXT_PATH%>/organ/updateCorporationInfo.sys",
				editData:{},recreateForm: true,beforeShowForm: function(form) {},
				width:"400",modal:true,closeAfterEdit: true,reloadAfterSubmit:true,
				afterSubmit : function(response, postdata){ 
					return fnJqTransResult(response, postdata);
				}
			}
		);
		jq("#list").jqGrid('setColProp', 'BORGCD',{hidden:true});
		jq("#list").jqGrid('setColProp', 'ISLIMIT' ,{ hidden:false, editoptions:{ value:"N:N;Y:Y",disabled:false, dataInit: function(elem){ $(elem).css("ime-mode", "disabled"); } } }); 
	} else { jq( "#dialogSelectRow" ).dialog(); }
}

function fnBranchDetail() {
	var row = jq("#list2").jqGrid('getGridParam','selrow'); // 선택된 로우 조회
	if( row != null ){
		var selrowContent = jq("#list2").jqGrid('getRowData',row);        // 선택된 로우의 데이터 객체 조회
		var popurl = "/organ/organBranchDetail.sys?branchId=" + selrowContent.BRANCHID + "&clientId=" + selrowContent.CLIENTID+"&_menuId=<%=_menuId %>";
		var popproperty = "dialogWidth:920px;dialogHeight=800px;scroll=yes;status=no;resizable=no;";
		window.open(popurl, 'okplazaPopBranch', 'width=920, height=800, scrollbars=yes, status=no, resizable=no');
	} else { jq( "#dialogSelectRow" ).dialog(); }	
}

function fnUserDetail(str) {
	var row = $("#"+str).jqGrid('getGridParam','selrow'); // 선택된 로우 조회
	if( row != null ){
		var selrowContent = $("#"+str).jqGrid('getRowData',row);        // 선택된 로우의 데이터 객체 조회
		var popurl = "/organ/organUserDetail.sys?borgId=" + selrowContent.BORGID + "&userId=" + selrowContent.USERID + "&_menuId=<%=_menuId %>";
		var popproperty = "dialogWidth:600px;dialogHeight=650px;scroll=yes;status=no;resizable=yes;";
	    window.open(popurl, 'okplazaPopUser', 'width=600, height=510, scrollbars=yes, status=no, resizable=yes');
	} else { $( "#dialogSelectRow" ).dialog(); }	
}

<%-- function end --%>

<%--    jqgrid start    --%>
jq(function() {
	jq("#list").jqGrid({
		url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/organ/selectCorporationInfo/list.sys',
		datatype: 'json',
		mtype: 'POST',
		colNames:[ '법인명','법인코드' ,'법인ID','사업자등록번호' ,'사용여부' ,'선입금' ,'주문제한' ,'여신금액'],
		colModel:[
			{name:'BORGNM',index:'BORGNM', width:160,align:"left",search:false
				,sortable:false,
				editable:true,editrules:{required:true},formoptions:{rowpos:1,elmprefix:"<font color='red'>(*)</font>"},
				editoptions:{size:"20",maxLength:"20" }
			},//법인명
			{name:'BORGCD',index:'BORGCD', width:160,align:"left",search:false,hidden:true
				,sortable:false,
				editable:true,editrules:{required:true},formoptions:{rowpos:2,elmprefix:"<font color='red'>(*)</font>"},
				editoptions:{size:"10",maxLength:"10" }
				,dataInit: function(elem){
					$(elem).css("ime-mode", "disabled");
					$(elem).css("text-transform","uppercase");
				}
			},//법인명
			{name:'BORGID',index:'BORGID',search:false,key:true,width:80,align:"left"
				,sortable:false,hidden:true, editable:true,formoptions:{rowpos:3,elmprefix:"&nbsp;&nbsp;&nbsp;"}
			},//법인코드
			{name:'BUSINESSNUM',index:'BUSINESSNUM', width:85,align:"center",search:false,sortable:false,
				editable:false, formoptions:{rowpos:4},editoptions:{size:"20",maxLength:"30"}
			},//사업자등록번호
			{name:'ISUSE',index:'ISUSE', width:50,align:"center",search:false,sortable:false,
				editable:true,formoptions:{rowpos:5,elmprefix:"<font color='red'>(*)</font>"},
				edittype:"select",formatter:"select",editoptions:{value:"Y:Y;N:N"}
			},//사용여부
			{name:'ISPREPAY',index:'ISPREPAY', width:50,align:"center",search:false,sortable:false,
				editable:true,formoptions:{rowpos:6,elmprefix:"&nbsp;&nbsp;&nbsp;"},
				edittype:"select",formatter:"select",editoptions:{value:"N:N;Y:Y"}
			},//선입금
			{name:'ISLIMIT',index:'ISLIMIT', width:50,align:"center",search:false,sortable:false,
				editable:true,formoptions:{rowpos:7,elmprefix:"&nbsp;&nbsp;&nbsp;"},
				edittype:"select",formatter:"select",editoptions:{value:"N:N;Y:Y"}
			},//주문제한
			{name:'LOAN',index:'LOAN', width:80,align:"right",search:false,sortable:false,formatter:'integer',
				editable:true,
				formoptions:{ rowpos:8,elmprefix:"&nbsp;&nbsp;&nbsp;",elmsuffix:"(단위:백만원)" },
				formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" },
				editoptions:{
					size:"10",maxLength:"10",
					maxlength:10,
					dataInit:function(elem){
						$(elem).numeric();
						$(elem).css("ime-mode", "disabled");
						$(elem).css("text-align", "right");
					}
				}
			}//여신금액
		],
		postData: {
            srcIsUse:$("#srcIsUseSel").val()
		},
		rowNum:30, rownumbers: true, rowList:[30,50,100], pager: '#pager',
<%-- 		height: <%=listHeight%>,width: 555, --%>
		height: <%=listHeight %>,width: 555,
		sortname: 'BORGNM', sortorder: "asc",
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,	//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete: function() {
			var rowCnt = jq("#list").getGridParam('reccount');
			if(rowCnt>0) {
				var top_rowid = $("#list").getDataIDs()[0];	//첫번째 로우 아이디 구하기
				var data = jq("#list2").jqGrid("getGridParam", "postData");
				data.clientid=top_rowid;
				jq("#list2").jqGrid("setGridParam", { "postData": data, "page":1 ,	datatype:'json' }).trigger("reloadGrid");
				jq("#list").setSelection(top_rowid);
			} else {
				jq("#list2").clearGridData();
			}
		},
		onSelectRow: function (rowid, iRow, iCol, e) { },
		onCellSelect: function(rowid, iCol, cellcontent, target){
			var selrowContent = jq("#list").jqGrid('getRowData',rowid);
			var cm = jq("#list").jqGrid("getGridParam", "colModel");
			var colName = cm[iCol];
			if(colName != undefined &&colName['index']=="BORGNM") { 
<%				if(CommonUtils.isRoleExist(roleList, "COMM_READ")){ %> 
					jq("#list").setSelection(rowid);  
					editRow(); 
<%				}else{%>
					var data = jq("#list2").jqGrid("getGridParam", "postData");
					data.clientid=rowid;
					jq("#list2").jqGrid("setGridParam", { "postData": data, "page":1 ,	datatype:'json' }).trigger("reloadGrid");
<%				} %>
			}else{
				var data = jq("#list2").jqGrid("getGridParam", "postData");
				data.clientid=rowid;
				jq("#list2").jqGrid("setGridParam", { "postData": data, "page":1 ,	datatype:'json' }).trigger("reloadGrid");
			}
		},
		afterInsertRow: function(rowid, aData){
<%			if(CommonUtils.isRoleExist(roleList, "COMM_READ")){ %> 
				jq("#list").setCell(rowid,'BORGNM','',{color:'#0000ff'}); 
				jq("#list").setCell(rowid,'BORGNM','',{cursor: 'pointer'});  
				jq("#list").setCell(rowid,'BORGNM','',{'text-decoration':'underline'});  
<%			} %>
			var selrowContent = jq("#list").jqGrid('getRowData',rowid);
			if(selrowContent.ISUSE == "N"){
				jq("#list").setCell(rowid,'ISUSE','',{color:'#ff0000'}); 
			}
		},
		loadError : function(xhr, st, str){ $("#list").html(xhr.responseText); },
		jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"}
	});
	
	jq("#list2").jqGrid({
		url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/organ/selectCorporationBranches/list.sys',
		datatype: 'local',
		mtype: 'POST',
		colNames:[ '사업장ID' ,'사업장명' ,'고객유형' ,'등급' ,'상태' ,'주문제한' ,'휴면사업장' ,'사용자' ,'권역','clientid' ],
		colModel:[
			{name:'BRANCHID',		index:'BRANCHID',		hidden:true, key:true },//사업장ID
			{name:'BRANCHNM',		index:'BRANCHNM',		width:230,   search:false, align:"left",   sortable:false},//법인코드
			{name:'WORKNM',			index:'WORKNM',			width:190,   search:false, align:"left",   sortable:false},//고객유형
			{name:'BRANCHGRADNM',	index:'BRANCHGRADNM',	width:70,    search:false, align:"center", sortable:false},//등급
			{name:'ISUSE',			index:'ISUSE',			width:80,    search:false, align:"center", sortable:false},//상태
			{name:'ISORDERLIMIT',	index:'ISORDERLIMIT',	width:70,    search:false, align:"center", sortable:false},//주문제한  
			{name:'USER_LOGNIN_YN',	index:'USER_LOGNIN_YN',	width:70,    search:false, align:"center", sortable:false},//휴면사업장
			{name:'USERS_COUNT',	index:'USERS_COUNT',	width:60,    search:false, align:"right",  sortable:false},//사용자
			{name:'AREATYPENM',		index:'AREATYPENM',		width:60,    search:false, align:"center", sortable:false},//권역
			{name:'CLIENTID',		index:'CLIENTID',		hidden:true}
		],
		postData: { },
		rowNum:30, rownumbers: false, rowList:[30,50,100], pager: '#pager2',
		height: <%=listHeight2 %>, autowidth: true,
		sortname: 'BORGNM', sortorder: "asc",
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,	//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete: function() {
		},
		onSelectRow: function (rowid, iRow, iCol, e) { },
		onCellSelect: function(rowid, iCol, cellcontent, target){
<%			if(CommonUtils.isRoleExist(roleList, "COMM_READ")){ %> 
				var selrowContent = jq("#list2").jqGrid('getRowData',rowid);
				var cm = jq("#list2").jqGrid("getGridParam", "colModel");
				var colName = cm[iCol];
				if(colName != undefined &&colName['index']=="BRANCHNM") {
					jq("#list2").setSelection(rowid);  
					fnBranchDetail();
				}
<%			} %>
		},
		afterInsertRow: function(rowid, aData){
<%			if(CommonUtils.isRoleExist(roleList, "COMM_READ")){ %> 
				jq("#list2").setCell(rowid,'BRANCHNM','',{color:'#0000ff'});
				jq("#list2").setCell(rowid,'BRANCHNM','',{cursor: 'pointer'});  
				jq("#list2").setCell(rowid,'BRANCHNM','',{'text-decoration':'underline'});  
<%			} %>
			var selrowContent = jq("#list2").jqGrid('getRowData',rowid);
			if(selrowContent.ISUSE == "N"){
				jq("#list2").setCell(rowid,'ISUSE','',{color:'#ff0000'}); 
			}
		} ,
		subGrid:true,
		subGridUrl: '<%=Constances.SYSTEM_CONTEXT_PATH%>/organ/selectCorporationBranchesUsersList/list.sys',
		subGridRowExpanded: function (grid_id, rowId) {
			var subgridTableId = grid_id + "_t";
			$("#" + grid_id).html("<table id='" + subgridTableId + "'></table>");
			$("#" + subgridTableId).jqGrid({
				url: '<%=Constances.SYSTEM_CONTEXT_PATH%>/organ/selectCorporationBranchesUsersList/list.sys',
				datatype: 'json',
				mtype: 'POST',
				postData: {borgid:rowId},
				colNames:[ '사용자명' ,'ID' ,'상태' ,'로그인여부' ,'감독여부' ,'사용권한' ,'이동전화번호' ,'이메일발송' ,'SMS발송' ,'휴면여부', '등록일' ,'USERID','BORGID'],
				colModel:[
					{name:'USERNM',			width:70,	align:'center',search:false,sortable:false},				//사용자명
					{name:'LOGINID',		width:65,	align:'center',search:false,sortable:false},				//사용자id
					{name:'ISUSE',			width:30,	align:'center',search:false,sortable:false},				//상태
					{name:'ISLOGIN',		width:40,	align:'center',search:false,sortable:false, hidden:true},	//로그인여부
					{name:'ISDIRECT',		width:35,	align:'center',search:false,sortable:false},				//감독여부
					{name:'ROLENM',			width:90,	align:'center',search:false,sortable:false},				//사용권한
					{name:'MOBILE',			width:80,	align:'center',search:false,sortable:false},				//이동전화번호
					{name:'ISEMAIL',		width:40,	align:'center',search:false,sortable:false},				//이메일발송
					{name:'ISSMS',			width:40,	align:'center',search:false,sortable:false},				//sms발송
					{name:'USER_LOGNIN_YN',	width:40,	align:'center',search:false,sortable:false},				//휴면여부
					{name:'CREATEDATE',		width:65,	align:'center',search:false,sortable:false},				//등록일
					{name:'USERID',			width:40,	align:'center',search:false,sortable:false,hidden:true},	//USERID
					{name:'BORGID',			width:70,	align:'center',search:false,sortable:false,hidden:true}		//BORGID
				],
				jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"},
				height:'100%', autowidth: true,
				afterInsertRow: function(rowid, aData) { 
<%					if(CommonUtils.isRoleExist(roleList, "COMM_READ")){ %> 
						$(this).setCell(rowid,'USERNM','',{color:'#0000ff'});
						$(this).setCell(rowid,'USERNM','',{cursor: 'pointer'});  
						$(this).setCell(rowid,'USERNM','',{'text-decoration':'underline'});  
<%					} %>
					var selrowContent = $(this).jqGrid('getRowData',rowid);
					if(selrowContent.ISUSE == "N"){
						$(this).setCell(rowid,'ISUSE','',{color:'#ff0000'}); 
					}
				},
				onCellSelect: function(rowid, iCol, cellcontent, target) {
<%					if(CommonUtils.isRoleExist(roleList, "COMM_READ")){ %> 
						var selrowContent = $(this).jqGrid('getRowData',rowid);
						var cm = $(this).jqGrid("getGridParam", "colModel");
						var colName = cm[iCol];
						subGrid = $(this);
						if (cellcontent == '&nbsp;') return;
						if(colName != undefined &&colName['name']=="USERNM") {
							$(this).setSelection(rowid);  
							fnUserDetail(subgridTableId);
						}
<%					} %>
				},
				loadComplete: function() {
					var rowCnt = $(this).getGridParam('reccount');
					if(rowCnt > 0){
						for(var i=0; i<rowCnt; i++){
							var rowid = $(this).getDataIDs()[i];
		 					var selrowContent = $(this).jqGrid('getRowData',rowid);
		 					var mobile = selrowContent.MOBILE;
		 					mobile = fnSetTelformat(mobile);
		 					$(this).jqGrid('setRowData',rowid,{MOBILE:mobile});
						}
					}
				}
			});
		},
		loadError : function(xhr, st, str){ $("#list2").html(xhr.responseText); },
		jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"}
	});
});

function fnAllExcelPrintDown(){
	var colLabels		= ['법인명',	'사업자등록번호',	'사용여부',	'선입금',	'주문제한',	'여신금액'];
	var colIds			= ['BORGNM',	'BUSINESSNUM',		'ISUSE',	'ISPREPAY',	'ISLIMIT',	'LOAN']; 
	var numColIds		= ['LOAN'];					//숫자표현ID
	var sheetTitle		= "법인조회";				//sheet 타이틀
	var excelFileName	= "CorporationClientList";	//file명
	var fieldSearchParamArray = new Array();
	fieldSearchParamArray[0] = 'srcClientNmTxt';
	fieldSearchParamArray[1] = 'srcIsUseSel';
	fieldSearchParamArray[2] = 'srcPressentNm';
	fnExportExcelToSvc(jq("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>", fieldSearchParamArray,"/organ/corporationInfoListExcel.sys");
}
</script>
</html>