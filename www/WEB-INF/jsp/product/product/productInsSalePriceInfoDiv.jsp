<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances"%>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils"%>
<%
	//날짜 세팅
	String divContractStDate = CommonUtils.getCurrentDate();
    String divContractEndDate = "9999-12-31";
	//String divContractEndDate = CommonUtils.getCustomDay("DAY", +365);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <style type="text/css">
        .jqmProductInsSalePriceWindow {
            display: none;
            position: fixed;
            top: 17%;
            left: 50%;
            margin-left: -300px;
            width: 560px;
            background-color: #EEE;
            color: #333;
            border: 1px solid black;
            padding: 12px;
        }
        .jqmOverlay { background-color: #000; }
            * html .jqmProductInsSalePriceWindow {
                position: absolute;
                top: expression((document.documentElement.scrollTop || document.body.scrollTop) + Math.round(17 * (document.documentElement.offsetHeight || document.body.clientHeight) / 100) + 'px');
            }
    </style>
    <!-- 초기세팅 및 선택값 리턴 스크립트 -->
    <script type="text/javascript">
		$(function(){
   			$('#productInsSalePriceDialogPop').jqm(); 
   			$('#productInsSalePriceDialogPop').jqm().jqDrag('#productInsSalePriceDialogHandle');
   			
   			
   			// 이벤트 등록  
   			$("#dispBtnFirst") .click(    function() { fnSearchBuyBorg();   }); /* fnInitSalePriceDialog('add'); */
   	        $("#dispBtnSecond").click(    function() { fnDelDisBorgInfo();	});
   	     	$("#productInsSalePriceSaveButton").click(    function() { fnInsDispBorgInfo();	});
   	     	$("#jqmCloseDiv").click(function() { 						$("#productInsSalePriceDialogPop").jqmHide(); });
   	     	$("#productInsSalePriceCloseButton").click(function() { 	$("#productInsSalePriceDialogPop").jqmHide();
   	     																checkBoxUnchecked(); });
   	     	
   	     	
       	   	//날짜 조회 및 스타일
       	 	$("#txtDispContractStartDate").datepicker( {
       	 		showOn: "button",
       	 		buttonImage: "<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_icon_calendar.gif",
       	 		buttonImageOnly: true,
       	 		dateFormat: "yy-mm-dd"
       	 	});
       	 	$("#txtDispContractEndDateDiv").datepicker( {
       	 		showOn: "button",
       	 		buttonImage: "<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_icon_calendar.gif",
       	 		buttonImageOnly: true,
       	 		dateFormat: "yy-mm-dd"
       	 	});
       	 	$("img.ui-datepicker-trigger").attr("style", "margin-left:3px; vertical-align:middle; cursor:pointer;");
   	 	
   	     
		});
	</script>
    <script type="text/javascript">
    
    
    //전국이외의 모든체크박스 선택
    function allCheckBoxSelect(){
    	if($('#allChk').attr('checked')){
			$('input[name=areaCodeChk]').attr('checked',true);
			$('#areaCode_99').attr('checked', false);
    	}else{
    		$('input[name=areaCodeChk]').attr('checked',false);
    	}
    } 
    //등록이나 닫기버튼 클릭후 체크박스 지워주기
    function checkBoxUnchecked(){
    	$('input[name=allChk]').attr('checked',false);
    }
    
    
    
 	// openDial   
    function fnProdInsDiv() {
 	    // 초기화 데이트  
 	    $('#txtCustGoodIdenNumb').val('');
 	    $('#txtDispSaleUnitPrice').val('');
 	   	$('#txtDsipSellPrice').val('');
 	  	$('#txtDispContractStartDate').val('<%=divContractStDate%>');
 	 	$('#txtDispContractEndDateDiv').val('<%=divContractEndDate%>');
 	 
        jq("#insDispBorg").clearGridData();
        
        $('#txtDispContractStartDate').val('<%=divContractStDate%>');
        $('#txtDispContractEndDateDiv').val('<%=divContractEndDate%>');
        
        $("#productInsSalePriceDialogPop").jqmShow();
        fnInitInsDispBorgGrid();
        
        
        $.post(  //조회조건의 공급사세팅
            '<%=Constances.SYSTEM_CONTEXT_PATH %>/common/getCodeList.sys',
    		{codeTypeCd:'DELI_AREA_CODE',isUse:'1'},
    		function(arg){
               	var codeList = eval('(' + arg + ')').codeList;
              	var htmlStr = "";
               	$("#dispAreaCodeChkDiv").html("");
    			//$("#dispAreaCodeDiv").append("<option value=''>선택</option>");
    			
    			htmlStr += "<table width='100%' border='0' cellspacing='0' cellpadding='0'>";
    			
    			for(var i=0;i<codeList.length;i++) {
    				//$("#dispAreaCodeDiv").append("<option value='"+codeList[i].codeVal1+"'>"+codeList[i].codeNm1+"</option>");
    				//alert(codeList[i].codeVal1);
    				if(i % 4 == 0){
    					htmlStr += "<tr>";		
    				}
    				
    				htmlStr += "<td>";
    				htmlStr += "<label style='cursor:pointer;'>";
    				htmlStr += "<input type='checkbox' id='areaCode_"+codeList[i].codeVal1+"' name='areaCodeChk' value='"+codeList[i].codeVal1+"' style='border:0px; vertical-align:-5px;'>"+codeList[i].codeNm1+"</input>";
    				htmlStr += "</label>";
    				htmlStr += "</td>";
    				
    				if(i % 4 == 3){
    					htmlStr += "</tr>";		
    				}
    				
    			}
    			htmlStr += "</table>";
    			$("#dispAreaCodeChkDiv").append(htmlStr);
        	}
    	);
        
        
		// 공급사 정보 조회
        $("#dispSelectVendor option").remove();
        $("#dispSelectVendor").append("<option value=''>선택</option>");
        var rowCnt = jq("#prodVendor").getGridParam('reccount'); 
        var msg = ''; 
     	if(rowCnt > 0){
    	    for(var i=0 ; i<rowCnt ; i++) {
    	        var venRowid = $("#prodVendor").getDataIDs()[i];
    	        var venRowData = jq("#prodVendor").jqGrid('getRowData',venRowid);
    	        
    	        // 종료요청인 데이터는 Pass 한다
    	        if(venRowData['orgisUse'] == '0' || venRowData['orgvendorid'] == '' ) continue;
    	        
    	        $("#dispSelectVendor").append("<option value='"+venRowData['vendorid']+"'>"+venRowData['vendornm']+"</option>");
    	        //msg += "\n value ["+venRowData['vendorid']+"] text [" + venRowData['vendornm'] + "]" ; 
    	    }
     	}
    }
 	
    /**
     *   카테고리 정보를 조회한다. 
     */
     var fnInitInsDispBorgGrid = function(){
         jq("#insDispBorg").jqGrid({
             datatype: "local",
             mtype:'POST',
             colNames:['조직유형','고객사명','권역','조직코드','areaType','groupId','clientId','branchId','borgId'],
             colModel:[
                 {name:'borgTypeNm',index:'borgTypeNm', width:60,align:"center",sortable:false,editable:false},//조직유형
                 {name:'borgNms',index:'borgNms', width:300,align:"left",search:false,sortable:false,editable:false},//고객사명
                 {name:'areaNm',index:'areaNm', width:60,align:"center",search:false,sortable:false,editable:false},//권역
                 {name:'borgCd',index:'borgCd', width:80,align:"center",search:false,sortable:false,editable:false},//조직코드
                 {name:'areaType',index:'areaType', hidden:true},//areaType
                 {name:'groupId',index:'groupId', hidden:true},//groupId
                 {name:'clientId',index:'clientId', hidden:true},//clientId
                 {name:'branchId',index:'branchId', hidden:true},//branchId
                 {name:'borgId',index:'borgId', hidden:true, key:true}//borgId
             ],
             //postData: '' ,
             rowNum:0,rownumbers:false,
             height:'150px',width:'520px',
             sortname:'borgNms',sortorder:'asc',
             caption:"상품진열정보", 
             viewrecords:true,emptyrecords:'Empty records',loadonce:false,shrinkToFit:false, //해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
             loadComplete:function() {
                 
             },
             onSelectRow:function(rowid,iRow,iCol,e) {},
             ondblClickRow:function(rowid,iRow,iCol,e) {},
             onCellSelect:function(rowid,iCol,cellcontent,target) {},
             loadError:function(xhr,st,str) { $("#list").html(xhr.responseText); },
             jsonReader: { root:"list",page:"page",total:"total",records:"records",repeatitems:false,cell:"cell" }
         });
     };
     

		// 진열조직 삭제
     var fnDelDisBorgInfo = function (){
         var rowId = $("#insDispBorg").getGridParam("selrow");
         if(rowId == null){
             $('#dialogSelectRow').html('<p>선택된 조직 정보가 존재하지 않습니다. </p>'); 
             $("#dialogSelectRow").dialog();
             return;
         }
         $('#insDispBorg').jqGrid('delRowData',rowId);
     };
     
     //fnChangeDispselectVendor fnChangeselectVendorDiv
	 var fnChangeDispselectVendor = function(obj){
         
	     if($(obj).val() == '' ){
	         $("#txtCustGoodIdenNumb").val('');
	         $("#txtDsipSellPrice").val('');
             $("#txtDispSaleUnitPrice").val('');
	     }else {
		     var mstRowId       = $("#productMaster").getGridParam("selrow");
		     var good_iden_numb = FNgetGridDataObj('productMaster',mstRowId,'good_iden_numb');
		                
		     $.post(  //조회조건의 공급사세팅
	             '<%=Constances.SYSTEM_CONTEXT_PATH %>/productManage/getGoodVendorListByGoodIdenNumJQGrid.sys',
	             {good_iden_numb:good_iden_numb
	                 ,vendorid:$(obj).val()},
	             function(arg){
	                var vendorList = eval('(' + arg + ')').list;
	                if(vendorList.length == 0 ){
	                    $("#dispSelectVendor option:eq(0)").attr("selected", "selected");
	                    alert('선택된 공급사는 실제 저장된 데이터가 아닙니다. 마스터 정보 저장후 이용하시기 바랍니다.');
	                }else if(vendorList.length == 1){
	                    
	                    var mstData = jq("#productMaster").jqGrid('getRowData',$("#productMaster").getGridParam("selrow"));
	                    var vendorData = jq("#prodVendor").jqGrid('getRowData',$(obj).val());
	                    var money = 0;
	                    
	                    if(mstData['sale_criterion_type'] == '10'){
	                        money =    parseInt(vendorData['sale_unit_pric'].replace(/,/g , "")) * (1 + parseInt(mstData['stan_buying_rate'].replace(/,/g , ""))*0.01 ); 
	                    }else if(mstData['sale_criterion_type'] == '20'){
	                        money = mstData['stan_buying_money'].replace(/,/g , "");
	                    }
	                    
	                    $("#txtDsipSellPrice").val($.number(money) );
	                    $("#txtDispSaleUnitPrice").val($.number(vendorList[0].sale_unit_pric));
	                    
	                }
	             }
	          );	         
	     }
     };
     
    // 공급사 등록 프로시저 
	var fnInsDispBorgInfo = function(){
    	
	    var areaChkCnt = $("input[name=areaCodeChk]:checkbox:checked").length;
	    if(areaChkCnt < 1){
	         alert('권역은 하나이상 선택하여야 합니다.');
	         return;
	    }
    	
		if(fnInputValidation()){
            return;
        }    	
    	
    	$("input:checkbox[name=areaCodeChk]").each(function(){
    		if(this.checked){
    			$("#dispAreaNameDiv").val(this.nextSibling.nodeValue);
    			$("#dispAreaCodeDiv").val(this.value);
    	        
    	        if(fnDispValidation()){
    	            return;
    	        }
    	        
    	        var tranObj = new Object(); 
    	        var groupId_array = new Array();
    	        var clientId_array = new Array();
    	        var branchId_array = new Array();
    	        
    	        
    	        var insRowCnt = jq("#insDispBorg").getGridParam('reccount');
    	        if(insRowCnt > 0 ) {
    	            for(var insIdx=0 ; insIdx<insRowCnt ; insIdx++) {
    	     	        var insRowid = $("#insDispBorg").getDataIDs()[insIdx];
    	     	        var insRowData = jq("#insDispBorg").jqGrid('getRowData',insRowid);
    	     	         
    	    			if(insRowData['groupId'] == '')insRowData['groupId'] = 0;
    	    			if(insRowData['clientId'] == '')insRowData['clientId'] = 0;
    	    			if(insRowData['branchId'] == '')insRowData['branchId'] = 0;
    	    		
    	    			groupId_array.push(insRowData['groupId']);
    	    	        clientId_array.push(insRowData['clientId']);
    	    	        branchId_array.push(insRowData['branchId']);
    	    	        
    	            }    
    	        }
    	        
    	        var rowid = $('#productMaster').getGridParam("selrow");
    	        
    	        tranObj['good_iden_numb']   = FNgetGridDataObj('productMaster',rowid,'good_iden_numb');
    	        tranObj['areatype'] 		= $('#dispAreaCodeDiv').val() ;
    	        tranObj['groupid_array'] 	= groupId_array; 
    	        tranObj['clientid_array'] 	= clientId_array;
    	        tranObj['branchid_array'] 	= branchId_array;
    	        tranObj['vendorid'] 		= $('#dispSelectVendor').val();
    	        tranObj['cont_from_date']   = $('#txtDispContractStartDate').val();
    	        tranObj['cont_to_date']    	= $('#txtDispContractEndDateDiv').val();
    	        tranObj['sale_unit_pric']   = $('#txtDispSaleUnitPrice').val();
    	        tranObj['sell_price']    	= $('#txtDsipSellPrice').val();
    	        tranObj['cust_good_iden_numb'] =  $('#txtCustGoodIdenNumb').val();
    	        
    	        fnDispInsGoodTrans(tranObj);    			
    		}
    	});
	};
	
	// input Validation
	var fnInputValidation = function(){
	    
// 	    if($('#dispAreaCodeDiv').val() == '' ){
// 	        alert('권역 정보는 필수 입력 값입니다.');
// 	        return true;
// 	    }
	    
	    if($.trim($('#dispSelectVendor').val()) == ''){
	        alert('공급사 정보는 필수 입력값 입니다.');
	        return true;
	    }
	    
		if( Number($('#txtDispSaleUnitPrice').val().replace(/,/g , ""))>Number($('#txtDsipSellPrice').val().replace(/,/g , ""))){
			alert('판매가는 매입가보다 작을 수 없습니다.');
			return true;
		}
		return false; 
	};

	// 그리드 데이터 Validation 
	var fnDispValidation = function(){
	    var insRowCnt = jq("#insDispBorg").getGridParam('reccount');
	    
	    if(insRowCnt > 0 ){
	        for(var insIdx=0 ; insIdx<insRowCnt ; insIdx++) {
	 	        var insRowid = $("#insDispBorg").getDataIDs()[insIdx];
	 	        var insRowData = jq("#insDispBorg").jqGrid('getRowData',insRowid);
	 	         
				if(insRowData['groupId'] == '')insRowData['groupId'] = 0;
				if(insRowData['clientId'] == '')insRowData['clientId'] = 0;
				if(insRowData['branchId'] == '')insRowData['branchId'] = 0;
	 	       
				var orgCnt = jq("#prodDisplay").getGridParam('reccount');
				
			    for(var i=0 ; i<orgCnt ; i++) {
	 	 	        var orgRowid = $("#prodDisplay").getDataIDs()[i];
	 	 	        var orgRowData = jq("#prodDisplay").jqGrid('getRowData',orgRowid);
	 	 	        var msg = '';
	 	 	        msg += '\n '+orgRowData['areatype']+'[]'+ $('#dispAreaCodeDiv').val(); 
	 	 	      	msg += '\n '+orgRowData['vendorid']+'[]'+ $('#dispSelectVendor').val();
	 	 	    	msg += '\n '+orgRowData['groupid'] +'[]'+ insRowData['groupId'];
	 	 	  		msg += '\n '+orgRowData['clientid']+'[]'+ insRowData['clientId'];
	 	 			msg += '\n '+orgRowData['branchid'] +'[]'+ insRowData['branchId'];
//	   	 			alert(msg);
//	   	 	        alert(orgRowData['areatype'] == $('#dispAreaCodeDiv').val() && // 권역
//	   	 	 	           orgRowData['vendorid'] == $('#dispSelectVendor').val() && // 공급사
//	   	 	 	           orgRowData['groupid']  == insRowData['groupId'] && // 그룹 
//	   	 	 	           orgRowData['clientid'] == insRowData['clientId'] && // 법인 
//	   	 	 	           orgRowData['branchid'] == insRowData['branchId']); 
	 	 	        
	 	 	        
	 	 	        if(orgRowData['areatype'] == $('#dispAreaCodeDiv').val() && // 권역
	 	 	           orgRowData['vendorid'] == $('#dispSelectVendor').val() && // 공급사
	 	 	           orgRowData['groupid']  == insRowData['groupId'] && // 그룹 
	 	 	           orgRowData['clientid'] == insRowData['clientId'] && // 법인 
	 	 	           orgRowData['branchid'] == insRowData['branchId'] ){    // 사업장 
	 	 	          
	 	 	            alert('조직 ['+insRowData['borgNms']+']는 이미 추가된 진열 정보입니다. \n 확인후 이용하시기 바랍니다.');
	 	 	          	return true;
	 	 	        }
	 	 	    }
	 	    }	        
	    }else {
	        
	        var orgCnt = jq("#prodDisplay").getGridParam('reccount');
	        if(orgCnt > 0 ){
	            for(var i=0 ; i<orgCnt ; i++) {
	 	 	        var orgRowid = $("#prodDisplay").getDataIDs()[i];
	 	 	        var orgRowData = jq("#prodDisplay").jqGrid('getRowData',orgRowid);
	 	 	        
	 	 	        if(orgRowData['areatype'] == $('#dispAreaCodeDiv').val() && // 권역
	 	 	           orgRowData['vendorid'] == $('#dispSelectVendor').val() && // 공급사
	 	 	           orgRowData['groupid']  == '0' && // 그룹 
	 	 	           orgRowData['clientid'] == '0' && // 법인 
	 	 	           orgRowData['branchid'] == '0' ){    // 사업장 
	 	 	          
	 	 	            alert('권역 ['+$("#dispAreaNameDiv").val()+']는 이미 추가된 진열 정보입니다. \n 확인후 이용하시기 바랍니다.'); 
	 	 	          	return true;
	 	 	        }
	 	 	    }
	        }
	    }

        return false; 
	};
    
	//
	var fnInsDisplayOpenPopClose = function(){
	    $("#productInsSalePriceDialogPop").jqmHide();
	};
    </script>
</head>
<body>

    <div class="jqmProductInsSalePriceWindow" id="productInsSalePriceDialogPop">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
                <td>
                    <input id='textDispGoodId' name='textDispGoodId' type="hidden" value='' />
                    <div id="productInsSalePriceDialogHandle">
                        <table width="100%" border="0" cellpadding="0" cellspacing="0" style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/popup_titlebar_mid.gif');">
                            <tr>
                                <td width="21">
                                    <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/popup_titlebar_left.gif" width="21" height="47" />
                                </td>
                                <td width="22">
                                    <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/popup_titlebar_bullet.gif" width="14" height="13" style="margin-bottom: 5px;" />
                                </td>
                                <td class="popup_title">상품판매가 상세정보</td>
                                <td width="22" align="right">
                                    <img id="jqmCloseDiv" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Close.gif" width="14" height="13" style="margin-bottom: 5px; border: 0; cursor: pointer;" />
                                </td>
                                <td width="10" style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/popup_titlebar_right.gif');">&nbsp;</td>
                            </tr>
                        </table>
                    </div>

                    <table width="100%" border="0" cellpadding="0" cellspacing="0">
                        <tr>
                            <td width="20" height="20">
                                <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_1.gif" width="20" height="20" />
                            </td>
                            <td style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_1.gif');">&nbsp;</td>
                            <td width="20">
                                <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_2.gif" width="20" height="20" />
                            </td>
                        </tr>
                        <tr>
                            <td style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_4.gif');">&nbsp;</td>
                            <td bgcolor="#FFFFFF">
                                <!-- 타이틀 시작 -->
                                <table width="100%" style="height: 27px;" border="0" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td width="20" valign="top">
                                            <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_stitle_blue.gif" style="width: 5px; height: 5px;" class="bullet_stitle" />
                                        </td>
                                        <td class="stitle">판매가 상품 조직정보 </td>
                                        <td align="right">
											<label style='cursor:pointer;'>
                                        		<input type="checkbox" id="allChk" name="allChk" onclick="allCheckBoxSelect()" style="border:0px; vertical-align:-5px;">
                                        		전체지역선택
                                        	</label>
                                        </td>
                                    </tr>
                                </table>
                                <!-- 타이틀 끝 -->
                                <!-- 조회조건 시작 -->
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                    <tr>
                                        <td colspan="4" class="table_top_line"></td>
                                    </tr>
                                    <tr>
                                        <td class="table_td_subject" width="80">권역</td>
                                        <td class="table_td_contents" colspan="3">
                                            <input type="hidden" id="dispAreaNameDiv" name="dispAreaNameDiv"/>
                                            <input type="hidden" id="dispAreaCodeDiv" name="dispAreaCodeDiv"/>
<!--                                             <select id="dispAreaCodeChkDiv" name="dispAreaCodeDiv" class="select" onchange="javaScript:void(0);"> -->
<!--                                                 <option value="">선택</option> -->
<!--                                             </select> -->
                                            <div id="dispAreaCodeChkDiv"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="4" height="1" bgcolor="eaeaea"></td>
                                    </tr>
                                    
                                    <tr>
                                        <td colspan="4" class="table_top_line"></td>
                                    </tr>
                                    <tr>
                                        <td colspan="4" height="1" bgcolor="eaeaea"></td>
                                    </tr>
                                    
                                    <tr>
                                        <td colspan="4" align="right"> 
                                            <img id='dispBtnFirst'  src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Add.gif" width="15" height="15" style="cursor: pointer;" />
                                            <img id='dispBtnSecond' src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Trash.gif" width="15" height="15" style="cursor: pointer;" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="4">
                                            <div id="jqgrid">
                                                <table id="insDispBorg">
                                                </table>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="4" class="table_top_line"></td>
                                    </tr>
                                    <tr>
                                        <td colspan="4" height='8'></td>
                                    </tr>
                                </table>

                                <!-- 타이틀 시작 -->
                                <table width="100%" style="height: 27px;" border="0" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td width="20" valign="top">
                                            <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_stitle_blue.gif" style="width: 5px; height: 5px;" class="bullet_stitle" />
                                        </td>
                                        <td class="stitle">판매가 공급사정보</td>
                                    </tr>
                                </table>
                                <!-- 타이틀 끝 -->
                                <!-- 조회조건 시작 -->
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                    <tr>
                                        <td colspan="4" class="table_top_line"></td>
                                    </tr>
                                    <tr>
                                        <td class="table_td_subject">공급사</td>
                                        <td class="table_td_contents">
                                            <select id="dispSelectVendor" name="dispSelectVendor" class="select" style="width: 150px;" onchange="javaScript:fnChangeDispselectVendor(this);">
                                                <option value="">선택</option>
                                            </select>
                                        </td>
                                        <td class="table_td_subject" width="80">고객사상품코드</td>
                                        <td class="table_td_contents">
                                            <input id="txtCustGoodIdenNumb" name="txtCustGoodIdenNumb" type="text" value="" style="IME-MODE: disabled" size="20" maxlength="20" style="text-align: left;" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="4" height="1" bgcolor="eaeaea"></td>
                                    </tr>
                                    <tr>
                                        <td class="table_td_subject" width="80">매입가</td>
                                        <td class="table_td_contents">
                                            <input id="txtDispSaleUnitPrice" name="txtDispSaleUnitPrice" alt='number' type="text" value="" size="20" maxlength="8" style="text-align: right;" readonly="readonly" onblur="javascript:fnSetFormatCurrency(this);" />
                                        </td>
                                        <td class="table_td_subject" width="100">판매가</td>
                                        <td class="table_td_contents">
                                            <input id="txtDsipSellPrice" name="txtDsipSellPrice" alt='number' type="text" value="" size="20" maxlength="10" style="text-align: right;" onblur="javascript:fnSetFormatCurrency(this);" /> 
                                            <input id="txtDsipBeforeSellPrice" name="txtDsipBeforeSellPrice" type="hidden" value="" size="20" maxlength="20" style="text-align: right;" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="4" height="1" bgcolor="eaeaea"></td>
                                    </tr>
                                    <tr>
                                        <td class="table_td_subject">계약시작일</td>
                                        <td class="table_td_contents">
                                            <input id="txtDispContractStartDate" name="txtDispContractStartDate" type="text" style="width: 75px;" readonly="readonly" />
                                        </td>
                                        <td class="table_td_subject">계약종료일</td>
                                        <td class="table_td_contents">
                                            <input id="txtDispContractEndDateDiv" name="txtDispContractEndDateDiv" type="text" style="width: 75px;" readonly="readonly" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="4" class="table_top_line"></td>
                                    </tr>
                                    <tr>
                                        <td colspan="4" height='8'></td>
                                    </tr>
                                </table>
                                <!-- 조회조건 끝 -->
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                    <tr>
                                        <td align="center">
                                            <img id="productInsSalePriceSaveButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type3_ok.gif" style='border: 0; cursor: pointer;' />
                                            <img id="productInsSalePriceCloseButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type3_close.gif" style='border: 0; cursor: pointer;' />
                                        </td>
                                    </tr>
                                </table>
                            </td>
                            <td style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_2.gif');">&nbsp;</td>
                        </tr>
                        <tr>
                            <td width="20" height="20">
                                <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_4.gif" width="20" height="20" />
                            </td>
                            <td style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_3.gif');">&nbsp;</td>
                            <td width="20">
                                <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_3.gif" width="20" height="20" />
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </div>
</body>
</html>