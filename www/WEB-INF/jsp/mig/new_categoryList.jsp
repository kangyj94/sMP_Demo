<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="java.util.List"%>

<%
	//화면권한가져오기(필수)
	@SuppressWarnings("unchecked")
	List<ActivitiesDto> roleList = (List<ActivitiesDto>) request.getAttribute("useActivityList");

	//그리드의 width와 Height을 정의
	int treelistWidth = 300;
	String treelistHeight = "$(window).height()-158 + Number(gridHeightResizePlus)";
	String treelist2Height = "$(window).height()-592 + Number(gridHeightResizePlus)";
	String listHeight = "$(window).height()-258 + Number(gridHeightResizePlus)";
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>

<script type="text/javascript">
$(document).ready(function(){
	$("#regButton").click( function() { addRow(); });
	$("#modButton").click( function() { editRow(); });
	$("#delButton").click( function() { delRow(); });

	$("#newCatePdSearchBtn").hide();
	$("#newCatePdSaveBtn").hide();
	$("#newCatePdDelBtn").hide();
	
	$("#newCatePdSearchBtn").click(function(){
		var popurl = "/newCate/prodSearchForCateReg.sys";
		var popproperty = "width=1000px, height=650px, status=no,resizable=no";
		window.open(popurl, 'window', popproperty);
	});
	$("#newCatePdSaveBtn").click(function(){
		if(confirm("선택한 상품을 저장하시겠습니까?")){
			var treeKey = $("#treeList").jqGrid('getGridParam','selrow');
			if(treeKey == null){
				alert("좌측 표준정보카테고리를 선택해주십시오.");
			}
			var prod_key_array = new Array(); 
			var isReg_array = new Array(); 
			var rowCnt = jq("#list").getGridParam('reccount');
			if(rowCnt>0) {
				var arrRowIdx = 0 ;
				for(var i=0; i<rowCnt; i++) {
					var rowid = $("#list").getDataIDs()[i];
					if (jq("#isCheck_"+rowid).attr("checked")) {
						var selrowContent = jq("#list").jqGrid('getRowData',rowid);
						prod_key_array[arrRowIdx] = selrowContent.prod_key;
						isReg_array[arrRowIdx] = selrowContent.isReg;
						arrRowIdx++;
					}
				}
				if (arrRowIdx == 0 ) {
					jq("#dialogSelectRow").dialog();
					return; 
				}
				$.post(
					"<%=Constances.SYSTEM_CONTEXT_PATH %>/newCate/saveProdInfo.sys", 
					{
						treeKey:treeKey,
						prod_key_array:prod_key_array,
						isReg_array:isReg_array
					},
					function(arg){ 
						if(fnTransResult(arg, false)) {	//성공시
							alert("저장이 완료되었습니다.");
							jq("#list").trigger("reloadGrid");
						} else {
							alert("저장이 실패하였습니다.");
							jq("#list").trigger("reloadGrid");
						}
					}
				);
			}
		}
	});
	$("#newCatePdDelBtn").click(function(){
		if(confirm("선택한 상품을 삭제하시겠습니까?")){
			var treeKey = $("#treeList").jqGrid('getGridParam','selrow');
			if(treeKey == null){
				alert("좌측 표준정보카테고리를 선택해주십시오.");
			}
			var prod_key_array = new Array(); 
			var isReg_array = new Array(); 
			var rowCnt = jq("#list").getGridParam('reccount');
			if(rowCnt>0) {
				var arrRowIdx = 0 ;
				for(var i=0; i<rowCnt; i++) {
					var rowid = $("#list").getDataIDs()[i];
					if (jq("#isCheck_"+rowid).attr("checked")) {
						var selrowContent = jq("#list").jqGrid('getRowData',rowid);
						prod_key_array[arrRowIdx] = selrowContent.prod_key;
						isReg_array[arrRowIdx] = "N";
						arrRowIdx++;
					}
				}
				if (arrRowIdx == 0 ) {
					jq("#dialogSelectRow").dialog();
					return; 
				}
				$.post(
					"<%=Constances.SYSTEM_CONTEXT_PATH %>/newCate/saveProdInfo.sys", 
					{
						treeKey:treeKey,
						prod_key_array:prod_key_array,
						isReg_array:isReg_array
					},
					function(arg){ 
						if(fnTransResult(arg, false)) {	//성공시
							alert("삭제가 완료되었습니다.");
							jq("#list").trigger("reloadGrid");
						} else {
							alert("삭제가 실패하였습니다.");
							jq("#list").trigger("reloadGrid");
						}
					}
				);
			}
		}
	});
});


function addRow() {
	$("#textCateState").val("");
	$("#textCateState").val("add");
	var row = jq("#treeList").jqGrid('getGridParam','selrow'); // 선택된 로우 조회
	if(row != null) {
		var selrowContent = jq("#treeList").jqGrid('getRowData',row);
		var tmpLevel = Number(selrowContent.level);
		var addCaption = "";
		var refCateSeq = "0";
		var cateLevel = "0";
		if(tmpLevel==0) {
			//addCaption = "1st등록";
			addCaption = "<font color='red'>대</font> 카테고리 등록";
			refCateSeq = selrowContent.treeKey.split("∥")[1];
			cateLevel = "1";
		} else if(tmpLevel==1) {
			addCaption = "<font color='blue'>"+selrowContent.majo_Code_Name+"</font> <font color='red'>중</font> 카테고리 등록";
			refCateSeq = selrowContent.treeKey.split("∥")[1];
			cateLevel = "2";
		} else if(tmpLevel==2) {
			addCaption = "<font color='blue'>"+selrowContent.majo_Code_Name+"</font> <font color='red'>소</font> 카테고리 등록";
			refCateSeq = selrowContent.treeKey.split("∥")[1];
			cateLevel = "3";
		} else {
			alert("표준카테고리정보는 소 카테고리까지 등록 및 수정이 가능합니다.");
			return;
		}
		jq("#treeList").jqGrid('setColProp','mojo_Code_Desc',{ hidden:false });
		jq("#treeList").jqGrid('setColProp','ord_Num',{ hidden:false });
		jq("#treeList").jqGrid(
			'editGridRow','new',{
				addCaption:addCaption,
				bottominfo:"<font color='red'>(*)</font>는 필수 입력정보 입니다.",
				url:"<%=Constances.SYSTEM_CONTEXT_PATH %>/newCate/newCategoryMasterTransGrid.sys", 
				editData: { refCateSeq:refCateSeq,cateLevel:cateLevel },
				recreateForm:true,beforeShowForm:function(form) {},
				width:"400",modal:true,closeAfterAdd:true,reloadAfterSubmit:true,
				afterSubmit:function(response, postdata) {
					return fnJqTransResult(response, postdata);
				}
			}
		);
		jq("#treeList").jqGrid('setColProp','mojo_Code_Desc',{ hidden:true });
  		jq("#treeList").jqGrid('setColProp','ord_Num',{ hidden:true });
	} else {
		alert("표준카테고리의 등록은 상위카테고리를 선택하셔야 합니다.");
	}
}
function editRow() {
	$("#textCateState").val("");
	$("#textCateState").val("edit");
	var row = jq("#treeList").jqGrid('getGridParam','selrow'); // 선택된 로우 조회
  	if(row != null) {
  		var selrowContent = jq("#treeList").jqGrid('getRowData',row);
		var tmpLevel = Number(selrowContent.level);
		var editCaption = "";
		if(tmpLevel==1) {
			editCaption = "<font color='red'>대</font> 카테고리 수정";
		} else if(tmpLevel==2) {
			editCaption = "<font color='red'>중</font> 카테고리 수정";
		} else if(tmpLevel==3) {
			editCaption = "<font color='red'>소</font> 카테고리 수정";
		} else {
			//alert("표준카테고리정보는 1st와 2st만 등록 및 수정이 가능합니다.");
			return;
		}
		jq("#treeList").jqGrid('setColProp','mojo_Code_Desc',{ hidden:false });
		jq("#treeList").jqGrid('setColProp', 'cate_Cd',{editoptions:{
  			disabled:true,size:"14",maxLength:"10",
  			dataInit: function(elem){
  				$(elem).css("ime-mode", "disabled");
  				$(elem).css("text-transform","uppercase");
  			}
  		}});
		jq("#treeList").jqGrid('setColProp','ord_Num',{ hidden:false });
  		jq("#treeList").jqGrid(
  			'editGridRow',row, {
  				editCaption:editCaption,
  				bottominfo:"<font color='red'>(*)</font>는 필수 입력정보 입니다.",
  				url:"<%=Constances.SYSTEM_CONTEXT_PATH %>/newCate/newCategoryMasterTransGrid.sys",
  				editData: {},
				recreateForm:true,beforeShowForm:function(form) {},
				width:"400",modal:true,closeAfterEdit:true,reloadAfterSubmit:false,
   			afterSubmit:function(response, postdata) {
   				return fnJqTransResult(response, postdata);
				}
			}
  		);
  		jq("#treeList").jqGrid('setColProp','mojo_Code_Desc',{ hidden:true });
  		jq("#treeList").jqGrid('setColProp', 'cate_Cd',{editoptions:{
  			disabled:false,size:"14",maxLength:"10",
  			dataInit: function(elem){
  				$(elem).css("ime-mode", "disabled");
  				$(elem).css("text-transform","uppercase");
  			}
  		}});
  		jq("#treeList").jqGrid('setColProp','ord_Num',{ hidden:true });
  	} else { jq( "#dialogSelectRow" ).dialog(); }
}
function delRow() {
	$("#textCateState").val("");
	$("#textCateState").val("del");
	
	
	var row = jq("#treeList").jqGrid('getGridParam','selrow');
	if( row != null ) {
		var regProdCnt = jq("#list").getGridParam('reccount');
		if(regProdCnt>0) {
			alert("해당 카테고리에 연결되어있는 상품정보가 있습니다. \n모두 삭제 후 다시 시도해주십시오.");
			return;
		}
		jq("#treeList").jqGrid( 
			'delGridRow', row,{
  				url:"<%=Constances.SYSTEM_CONTEXT_PATH %>/newCate/newCategoryMasterTransGrid.sys",
				recreateForm: true,beforeShowForm: function(form) {
					jq(".delmsg").replaceWith('<span style="white-space: pre;">' + '선택한 데이터를 삭제 하시겠습니까?' + '</span>');
					jq('#pData').hide();jq('#nData').hide();  
				},
				reloadAfterSubmit:true,closeAfterDelete: true,
				afterSubmit: function(response, postdata){
					return fnJqTransResult(response, postdata);
				}
			}
		);
	} else { jq( "#dialogSelectRow" ).dialog(); }
	
}


var jq = jQuery;
jq(function() {
	//표준카테고리 Grid
	jq("#treeList").jqGrid({
		url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/newCate/categoryTreeJQGrid.sys',
		datatype:'json',
		mtype:'POST',
		colNames:['카테고리명','카테고리CD','카테고리설명','진열순서','레벨','treeKey','상위카테고리Seq','level','isLeaf','cateid'],
		colModel:[
			{name:'majo_Code_Name',index:'majo_Code_Name',width:220,align:'left',search:false,sortable:false,
				editable:true,editrules:{required:true},formoptions:{rowpos:1,elmprefix:"<font color='red'>(*)</font>"},
				editoptions:{size:'20',maxLength:'30'}
			},//카테고리명
			{name:'cate_Cd',index:'cate_Cd',width:70,align:'left',search:false,sortable:false,
				editable:true,editrules:{custom:true,custom_func:fnCateCdCheck},formoptions:{rowpos:2,elmprefix:"<font color='red'>(*)</font>"},
				editoptions:{size:'14',maxLength:'10',dataInit:function(elem) {
					$(elem).css("ime-mode","disabled"); $(elem).css("text-transform","uppercase");}}
			},//카테고리CD
			{name:'mojo_Code_Desc',index:'mojo_Code_Desc',width:70,align:'left',search:false,sortable:false,hidden:true,
				editable:false
			},//카테고리설명
			{name:'ord_Num',index:'ord_Num',width:70,align:'center',search:false,sortable:false,hidden:true,
				editable:true,editrules:{required:true},formoptions:{rowpos:3,elmprefix:"<font color='red'>(*)</font>"},
				editoptions:{ size:"2",maxLength:"2", dataInit:function(elem) {
					$(elem).numeric();
					$(elem).css("ime-mode", "disabled");
					if($(elem).val()=='') $(elem).val(0);
				}}
			},//진열순서
			{name:'typeName',index:'typeName',width:40,align:'center',search:false,sortable:false,hidden:false,editable:false },//레벨
			
			{name:'treeKey',index:'treeKey',hidden:true,key:true },
			{name:'ref_Cate_Seq',index:'ref_Cate_Seq',hidden:true },//상위카테고리Seq
			{name:'level',index:'level',hidden:true },
			{name:'isLeaf',index:'isLeaf',hidden:true },
			{name:'cate_Id',index:'cate_Id',hidden:false }
		],
		rowNum:0,rownumbers:false,
		treeGridModel:'adjacency',
		height:<%=treelistHeight%>,width:<%=treelistWidth%>,
		treeGrid:true,hoverrows:false,
		ExpandColumn:'majo_Code_Name',ExpandColClick:true,
		caption:'표준카테고리',
		viewrecords:true,emptyrecords:'Empty records',loadonce:false,shrinkToFit:false,	//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		gridComplete: function() {
			var rData = $("#treeList").jqGrid('getGridParam','data');
			if(rData[0]) {
				setTimeout(function() {
					//for(i=0;i<rData.length;i++) {
					for(var i=0;i<1;i++) {
						$("#treeList").jqGrid('expandRow',rData[i]);
						$("#treeList").jqGrid('expandNode',rData[i]);
					}
				}, 0);
			}
		},
		loadComplete:function() {},
		onSelectRow:function (rowid,iRow,iCol,e) {
			var selrowContent = jq("#treeList").jqGrid('getRowData',rowid);
			fnCateProdSearch(rowid,selrowContent.isLeaf);
		},
		loadError:function(xhr,st,str){ $("#treeList").html(xhr.responseText); },
		jsonReader:{ root:"treeList",repeatitems:false,cell:"cell" }
	});
	
	

	jq("#list").jqGrid({
		url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/newCate/selectCateGoods.sys',
		datatype:'local',
		mtype:'POST',
		colNames:["prod_key","<input id='chkAllOutputField' type='checkbox' style='border:0px;' onclick='checkBox(event)' />",'상품코드','상품명','이미지','공급사코드','공급사명','규격','과세구분','배분여부','진열여부','절대판매가','매입단가','단위','이미지여부','설명여부','상품구분','cate_Id', 'small_Img_Path','등록여부'],
		colModel:[
			{name:'prod_key',index:'prod_key',width:60,align:"left",search:false,sortable:true,editable:false,key:true,hidden:true },//키
			{name:'isCheck',index:'isCheck', width:30,align:"center",search:false,sortable:false,editable:false, formoptions:{rowpos:1,elmprefix:"&nbsp;&nbsp;&nbsp;&nbsp;"},formatter:checkboxFormatter},
			{name:'good_Iden_Numb',index:'good_Iden_Numb',width:60,align:"left",search:false,sortable:true,editable:false },//상품코드
			{name:'good_Name', index:'good_Name',width:160,align:"left",search:false,sortable:true,editable:false },//상품명
			{name:'good_img', index:'good_img',width:30,align:"center",search:false,sortable:true,editable:false },//이미지
			{name:'vendorId', index:'vendorId',width:80,align:"center",search:false,sortable:true,editable:false },//이미지
			{name:'vendorNm', index:'vendorNm',width:80,align:"center",search:false,sortable:true,editable:false },//이미지
			{name:'good_Spec_Desc',index:'good_Spec_Desc',width:60,align:"left",search:false,sortable:false,editable:false },//규격
			{name:'vtax_Clas_Code',index:'vtax_Clas_Code',width:60,align:"center",search:false,sortable:false ,editable:false,formatter:"select",editoptions:{value:"10:과세10%;20:영세율;30:면세"} },//과세구분
			{name:'isDistribute',index:'isDistribute',width:60,align:"center",search:false,sortable:false ,editable:false,formatter:"select",editoptions:{value:"1:Y;0:N"} },//물량배분여부
			{name:'isDispPastGood',index:'isDispPastGood',width:60,align:"center",search:false,sortable:false ,editable:false,formatter:"select",editoptions:{value:"1:진열;0:미진열"} },//과거상품진열여부
			{name:'stan_buying_money',index:'stan_buying_money',width:60,align:"right",search:false,sortable:false ,editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" } },//매입단가
			{name:'sale_Unit_Pric',index:'sale_Unit_Pric',width:60,align:"right",search:false,sortable:false ,editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" } },//매입단가
			{name:'orde_Clas_Code',index:'orde_Clas_Code',width:60,align:"center",search:false,sortable:false,editable:false },//단위
			{name:'isSetImage',index:'isSetImage',width:60,align:"center",search:false,sortable:false,editable:false },//대표이미지여부
			{name:'isSetDesc',index:'isSetDesc',width:60,align:"center",search:false,sortable:false,editable:false },//상품설명여부
			{name:'good_Clas_Code',index:'good_Clas_Code',width:60,align:"center",search:false,sortable:false ,editable:false,formatter:"select",editoptions:{value:"10:일반;20:지정;30:수탁"} },//상품구분
			{name:'cate_Id',index:'cate_Id',hidden:true,search:false },
			{name:'small_Img_Path',index:'small_Img_Path',hidden:true,search:false },
			{name:'isReg',index:'isReg',hidden:false,search:false }
		],
		postData: { },
		multiselect:true,
		rowNum:0,
		height:<%=listHeight%>,autowidth:true,
		sortname:'good_Name',sortorder:'desc',
		caption:"상품정보",
		multiselect:false,
		viewrecords:true,emptyrecords:'Empty records',loadonce:false,shrinkToFit:false,	
		loadComplete:function() {
			// 품목 규격 설정 
			var prodSpcNm = new Array();
		   <% for(int idx = 0 ; idx < Constances.PROD_GOOD_SPEC.length ; idx++) {     %>
				prodSpcNm.push('<%= Constances.PROD_GOOD_SPEC[idx]%>');
		   <% }                                                                       %>
			
			var rowCnt = jq("#list").getGridParam('reccount');
			for(var idx=0; idx<rowCnt; idx++) {
				var rowid = $("#list").getDataIDs()[idx];
				
				jq("#list").restoreRow(rowid);
				var selrowContent = jq("#list").jqGrid('getRowData',rowid);
				
				// 규격 화면 로드 
				var argArray = selrowContent.good_Spec_Desc.split(" ");
				var prodSpec = "";
				for(var jIdx = 0 ; jIdx < prodSpcNm.length ; jIdx ++ ) {
					if(argArray[jIdx] > ' ') {
				         prodSpec += prodSpcNm[jIdx]+":"+ argArray[jIdx] + " ";
					}
				}
				jQuery('#list').jqGrid('setRowData',rowid,{good_Spec_Desc:prodSpec});
				
				// img 화면 로드 
				var imgTag = ""; 
				if($.trim(selrowContent.small_Img_Path) > ' ') imgTag = "<img src='<%=Constances.SYSTEM_IMAGE_PATH%>/"+selrowContent.small_Img_Path+"' style='width:30px;height:30px;' />";	
				else imgTag = "<img src='<%=Constances.SYSTEM_IMAGE_URL%>/img/system/imageResize/prod_img_50.gif' style='width:30px;height:30px;' />";
				
				jQuery('#list').jqGrid('setRowData',rowid,{good_img:imgTag});
			}
		},
		ondblClickRow:function(rowid,iRow,iCol,e) {},
		onCellSelect:function(rowid,iCol,cellcontent,target) { },
		loadError:function(xhr,st,str) { $("#list").html(xhr.responseText); },
		jsonReader: { root:"list",total:"total",records:"records",repeatitems:false,cell:"cell" }
	});
});

function fnCateProdSearch(keyVal, isView){
	if(isView){
		var data = jq("#list").jqGrid("getGridParam", "postData");
		data.keyVal= keyVal;
		jq("#list").jqGrid('setGridParam', { datatype: 'json', data:data })
		jq("#list").trigger("reloadGrid");
		
		$("#newCatePdSearchBtn").show();
		$("#newCatePdSaveBtn").show();
		$("#newCatePdDelBtn").show();
	}else{
		jQuery("#list") .jqGrid('setGridParam', { datatype: 'local' })
		$("#newCatePdSearchBtn").hide();
		$("#newCatePdSaveBtn").hide();
		$("#newCatePdDelBtn").hide();
	}
}



function fnCateCdCheck(value, colname) {
	var oper = $("#textCateState").val();
	var row = jq("#treeList").jqGrid('getGridParam','selrow');
  	if(row != null) {
  		var selrowContent = jq("#treeList").jqGrid('getRowData',row);
		var tmpLevel = Number(selrowContent.level);
		if(oper == "add") {
			if(tmpLevel==0) {
				if(value.length != 4) {
					return [false,"대 카테고리CD는 4자리입니다."]; 
				} else {
					return [true,""];
				}
			} else if(tmpLevel==1) {
				if(value.length != 7) {
					return [false,"중 카테고리CD는 7자리입니다."]; 
				} else {
					return [true,""];
				}
			} else if(tmpLevel==2) {
				if(value.length != 10) {
					return [false,"소 카테고리CD는 10자리입니다."]; 
				} else {
					return [true,""];
				}
			}
		} else if(oper == "edit") {
			if(tmpLevel==1) {
				if(value.length != 4) {
					return [false,"대 카테고리CD는 4자리입니다."]; 
				} else {
					return [true,""];
				}
			} else if(tmpLevel==2) {
				if(value.length != 7) {
					return [false,"중 카테고리CD는 7자리입니다."]; 
				} else {
					return [true,""];
				}
			} else if(tmpLevel==3) {
				if(value.length != 10) {
					return [false,"소 카테고리CD는 10자리입니다."]; 
				} else {
					return [true,""];
				}
			}
		}
  	}
}


/** * 고객사 진열 상품 */
function fnOpenProdSearchPopForAdmin() {
	if ($.trim($('#srcBranchId').val()) == '') {
		$('#dialogSelectRow').html('<p>사업장 선택후 이용하시기 바랍니다.</p>');
		$("#dialogSelectRow").dialog({
			title : 'Warning',
			modal : true
		});
		return true;
	}
	var popurl = "/newCate/prodSearchForCateReg.sys";
	var popproperty = "width=1000px, height=650px, status=no,resizable=no";
	window.open(popurl, 'window', popproperty);
}

/** *  삼품검색 콜백 */
function fnProdSearchCallBack(goods_array) {
    var rowCnt = $("#list").getGridParam('reccount');
    var errMsg = "";
	for(var i = 0 ; i < goods_array.length; i++){
		var chkCnt = 0;
		for(var k = 0 ; k < rowCnt; k++){
			var rowid = $("#list").getDataIDs()[k];
			var selrowContent = jq("#list").jqGrid('getRowData',rowid);
			if(selrowContent.prod_key == goods_array[i].prod_key){
				if(errMsg == ""){
					errMsg += "["+goods_array[i].vendorNm+"] 공급사의 ["+goods_array[i].good_Name+"] 상품은 이미 등록되어있습니다."
				}else{
					errMsg += "\n["+goods_array[i].vendorNm+"] 공급사의 ["+goods_array[i].good_Name+"] 상품은 이미 등록되어있습니다."
				}
				chkCnt++;
			}
		}
		if(chkCnt == 0){
			jQuery("#list").jqGrid('addRow', {
				rowID : goods_array[i].prod_key,
				initdata : {
					"prod_key":goods_array[i].prod_key,
					"good_Iden_Numb":goods_array[i].good_Iden_Numb,
					"good_Name":goods_array[i].good_Name,
					"good_img":goods_array[i].good_img,
					"vendorId":goods_array[i].vendorId,
					"vendorNm":goods_array[i].vendorNm,
					"good_Spec_Desc":goods_array[i].good_Spec_Desc,
					"vtax_Clas_Code":goods_array[i].vtax_Clas_Code,
					"isDistribute":goods_array[i].isDistribute,
					"isDispPastGood":goods_array[i].isDispPastGood,
					"stan_buying_money":goods_array[i].stan_buying_money,
					"sale_Unit_Pric":goods_array[i].sale_Unit_Pric,
					"orde_Clas_Code":goods_array[i].orde_Clas_Code,
					"isSetImage":goods_array[i].isSetImage,
					"isSetDesc":goods_array[i].isSetDesc,
					"good_Clas_Code":goods_array[i].good_Clas_Code,
					"cate_Id":goods_array[i].cate_Id,
					"small_Img_Path":goods_array[i].small_Img_Path,
					"isReg":"Y"
				},
				position :"last",           //first, last
				useDefValues : false,
				useFormatter : false,
				addRowParams : {extraparam:{}}
			});
			$("#isCheck_"+goods_array[i].prod_key).prop("checked",true);
		}
	}
	if(errMsg!=""){
		alert(errMsg);
	}
}

function checkboxFormatter(cellvalue, options, rowObject) {
	return "<input id='isCheck_"+options.rowId+"' name='isCheck_"+options.rowId+"' type='checkbox'  offval='no'  style='border:none;'/>";
}
function checkBox(e) {
	e = e||event;/* get IE event ( not passed ) */
	e.stopPropagation? e.stopPropagation() : e.cancelBubble = true;
   if($("#chkAllOutputField").is(':checked')) {
	   var rowCnt = jq("#list").getGridParam('reccount');
	    if(rowCnt>0) {
	        for(var i=0; i<rowCnt; i++) {
	            var rowid = $("#list").getDataIDs()[i];
	            jq('input:checkbox[name=isCheck_'+rowid+']:not(checked)').attr("checked", true);
	        }
	    }
   } else {
	    var rowCnt = jq("#list").getGridParam('reccount');
	    if(rowCnt>0) {
	        for(var i=0; i<rowCnt; i++) {
	            var rowid = $("#list").getDataIDs()[i];
	            jq('input:checkbox[name=isCheck_'+rowid+']:checked').attr("checked", false);
	        }
	    }
   }
}
</script>

</head>

<body>
<form id="frm" name="frm" method="post">
<table width="100%" border="0" cellspacing="0" cellpadding="0" align="left">
<tr>
	<td colspan="3">
		<!-- 타이틀 시작 -->
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr valign="top">
				<td width="20" valign="middle">
					<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_ptitle1.gif" style="width:14px;height:15px;" /></td>
				<td height="29" class="ptitle">카테고리관리</td>
			</tr>
		</table>
		<!-- 타이틀 끝 -->
	</td>
</tr>
<tr>
	<td width="300" valign="top">
		<!-- 타이틀 시작 -->
		<table width="100%" style="height:27px;" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td width="20" valign="top">
					<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_stitle_blue.gif" style="width:5px;height:5px;" class="bullet_stitle" /></td>
				<td class="stitle">표준카테고리정보</td>
				<td>
					<div id="jqgridExcel">
						<table id="treeListExcel"></table>
					</div>
				</td>
				<td height="27px" align="right" valign="bottom"> 
					<input id="textCateState" name="textCateState" type="hidden" value="" readonly="readonly" />
<%-- 					<a href="#"><img id="regButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Add.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>' /></a> --%>
<%-- 					<a href="#"><img id="modButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Modify.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>' /></a> --%>
<%-- 					<a href="#"><img id="delButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Trash.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>' /></a> --%>
					<a href="#"><img id="regButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Add.gif" width="15" height="15" style='border:0;' /></a>
					<a href="#"><img id="modButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Modify.gif" width="15" height="15" style='border:0;' /></a>
					<a href="#"><img id="delButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Trash.gif" width="15" height="15" style='border:0;' /></a>
				</td>
			</tr>
		</table>
		<!-- 타이틀 끝 -->
		<table width="100%" border="0" cellpadding="0" cellspacing="0" id="그리드 영역표시">
			<tr>
				<td valign="top" bgcolor="#CCCCCC">
					<div id="jqgrid">
						<table id="treeList"></table>
					</div>
				</td>
			</tr>
		</table></td>
	<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
	<td valign="top">
		<!-- 타이틀 시작 -->
		<table width="100%" style="height:27px;" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td width="20" valign="top">
					<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_stitle_blue.gif" style="width:5px;height:5px;" class="bullet_stitle" /></td>
				<td class="stitle">상품정보</td>
				<td align="right" class="stitle">
					<a href="#"><img id="srcButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type3_search.gif" style="width:65px;height:22px;border:9px;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>" /></a>
				</td>
			</tr>
		</table>
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td colspan="4" class="table_top_line"></td>
			</tr>
			<tr>
				<td colspan="4" height="1" bgcolor="eaeaea"></td>
			</tr>
			<tr>
				<td class="table_td_subject" width="100">상품명</td>
				<td class="table_td_contents">
					<input id="srcCateDispName" name="srcCateDispName" type="text" value="" size="" maxlength="50" style="width:80%" class="blue" /></td>
			</tr>
			<tr>
				<td colspan="4" height="1" bgcolor="eaeaea"></td>
			</tr>
			<tr>
				<td colspan="4" class="table_top_line"></td>
			</tr>
		</table>
		<!-- 컨텐츠 끝 -->
		<table width="100%" border="0" cellpadding="0" cellspacing="0" id="그리드 영역표시2">
			<tr>
				<td height="27px" align="right" valign="bottom">
					<input type="button" id="newCatePdSearchBtn" value="상품찾기"/>
					<input type="button" id="newCatePdSaveBtn" value="상품저장"/>
					<input type="button" id="newCatePdDelBtn" value="상품삭제"/>
<%-- 					<a href="#"><img id="regButton2" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Add.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>' /></a> --%>
<%-- 					<a href="#"><img id="modButton2" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Modify.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>' /></a> --%>
<%-- 					<a href="#"><img id="delButton2" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Trash.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>' /></a> --%>
<%-- 					<a href="#"><img id="excelButton2" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Table.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>' /></a> --%>
				</td>
			</tr>
			<tr>
				<td>
				&nbsp;
				</td>
			</tr>
			<tr>
				<td align="left">
					<div id="jqgrid">
						<table id="list"></table>
					</div>
				</td>
			</tr>
		</table>
	</tr>
</table>
<div id="dialogSelectRow" title="Warning" style="display:none;font-size: 12px;color: red;">
	<p>처리할 데이터를 선택 하십시오!</p>
</div>
<div id="dialog" title="Feature not supported" style="display:none;">
	<p>That feature is not supported.</p>
</div>
<!-------------------------------- Dialog Div Start -------------------------------->
<%@ include file="/WEB-INF/jsp/product/category/svcDisplayRegistDiv.jsp" %>
<!-------------------------------- Dialog Div End -------------------------------->
</form>
</body>
</html>