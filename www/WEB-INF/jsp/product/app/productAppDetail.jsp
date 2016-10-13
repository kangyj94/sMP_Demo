<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances"%>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%
    @SuppressWarnings("unchecked")
    List<ActivitiesDto> roleList = (List<ActivitiesDto>) request.getAttribute("useActivityList");               // 화면권한가져오기(필수)
    //파라미터 설정 
	String app_good_id = request.getAttribute("app_good_id") == null ? "": (String) request.getAttribute("app_good_id");
    String listWidth = "$(window).width()-60 + Number(gridWidthResizePlus)";
    
//    app_good_id = "103";
    
    System.out.println("app_good_id value [" + app_good_id + "]");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp"%>
<script src="/jq/js/excanvas.js" type="text/javascript"></script> 
<script src="/jq/js/jquery.jqChart.min.js" type="text/javascript"></script> 
<script src="/jq/js/jquery.jqRangeSlider.min.js" type="text/javascript"></script>

<script type="text/javascript">
    	
    var jq = jQuery;							// jQuery  설정 
    var reqParamObj = new Object();				// RequestParameter 설정
	
    
    var defObj = new jQuery.Deferred();			// Deferred() 를 이용하여 비동기 적 실행을 동기적 실행 방식으로 변경한다.
    defObj.progress(
    	function(insMod ){
    	    if(insMod == 'setPramsDone'){
    	        fnLoadDetailData();	       		//	상세 정보를 로드한다.  
    	    }else if(insMod == 'LoadDetailDataDone'){
    	        defObj.resolve();
    	    }
    	}
    ).done(function(){ //page ReSize() 호출
    	
        fnInitChart(); 
    
    	// page Grid 초기화 
        $(window).bind('resize', function() {
            $("#appGood").setGridWidth(<%=listWidth %>);
        }).trigger('resize');
    });
    
    
    $(document).ready(function() {
        
     	// component 이벤트 등록 
        $('#btnAdmAppOk').click( function() 	{ fnAppProduct('ok'); 		});
        $('#btnAdmAppCancel').click( function() { fnAppProduct('cancel'); 	});
        $('#btnCommonClose').click( function()	{ fnModalclose();			});
        
        // 파라미터 설정을 한다. 
	    fnSetRequestParmas();
	});
</script>
<script type="text/javascript">

    /**
     * Object 객체 안에 파라미터를 설정한다. 
     * 파라미터 설정후 순차적 처리를 위해 notify Method 를 호출한다.  
     */    
    var fnSetRequestParmas = function(){
        reqParamObj['app_good_id'] 	= '<%=app_good_id%>'; 
        defObj.notify('setPramsDone');
    };
    
    /**
     * 상세 정보를 로드한다.
     */
    var fnLoadDetailData = function(){
        var params = {app_good_id:reqParamObj['app_good_id']};
        
        jq("#productApp").jqGrid({
        	url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/productApp/getAppProductDetailJQGrid.sys',
        	datatype:'json',
        	mtype:'POST',
        	colNames:[
                 'app_good_id'
                ,'chn_price_clas'
                ,'good_iden_numb'
                ,'good_name'
                ,'fix_good_id'
                ,'disp_good_id'
                ,'before_price'
                ,'after_price'
                ,'chn_persent'
                ,'change_reason'
                ,'app_sts_flag'
                ,'register_userid'
                ,'register_nm'
                ,'register_date'
                ,'confirm_userid'
                ,'confirm_nm'
                ,'confirm_date'
                ,'app_userid'
                ,'app_date'
                ,'vendorid'
                ,'vendornm'
                ,'apptypecode'
                ,'apptypenm'
                ,'appstscode'
                ,'appstsnm'
        	],
        	colModel:[
        		{name:'app_good_id'    ,index:'app_good_id'    ,width:100 , key:true },
        		{name:'chn_price_clas' ,index:'chn_price_clas' ,width:100 },
        		{name:'good_iden_numb' ,index:'good_iden_numb' ,width:100 },
        		{name:'good_name'        ,index:'good_name'    ,width:100 },
        		{name:'fix_good_id'    ,index:'fix_good_id'    ,width:100 },
        		{name:'disp_good_id'   ,index:'disp_good_id'   ,width:100 },
        		{name:'before_price'   ,index:'before_price'   ,width:100 },
        		{name:'after_price'    ,index:'after_price'    ,width:100 },
        		{name:'chn_persent'    ,index:'chn_persent'    ,width:100 },
        		{name:'change_reason'  ,index:'change_reason'  ,width:100 },
        		{name:'app_sts_flag'   ,index:'app_sts_flag'   ,width:100 },
        		{name:'register_userid',index:'register_userid',width:100 },
        		{name:'register_nm'    ,index:'register_nm'    ,width:100 },
        		{name:'register_date'  ,index:'register_date'  ,width:100 },
        		{name:'confirm_userid' ,index:'confirm_userid' ,width:100 },
        		{name:'confirm_nm'     ,index:'confirm_nm'     ,width:100 },
        		{name:'confirm_date'   ,index:'confirm_date'   ,width:100 },
        		{name:'app_userid'     ,index:'app_userid'     ,width:100 },
        		{name:'app_date'       ,index:'app_date'       ,width:100 },
        		{name:'vendorid'       ,index:'vendorid'       ,width:100 },
        		{name:'vendornm'       ,index:'vendornm'       ,width:100 },
        		{name:'apptypecode'    ,index:'apptypecode'    ,width:100 },
        		{name:'apptypenm'      ,index:'apptypenm'      ,width:100 },
        		{name:'appstscode'     ,index:'appstscode'     ,width:100 },
        		{name:'appstsnm'       ,index:'appstsnm'       ,width:100 }
        	],
        	postData: params,
        	rownumbers:false,
        	width:$(window).width()-60 + Number(gridWidthResizePlus),
        	sortname:'',sortorder:'',
        	caption:"승인상세 정보", 
        	viewrecords:true,emptyrecords:'Empty records',loadonce:false,shrinkToFit:false,	//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
        	loadComplete:function() {
        	    
        	    var selRowId;
        	    selRowId = $("#productApp").getDataIDs()[0];
         	    $("#productApp").setSelection(selRowId);
         	    
         	    
         	    // 화면에 결과값을 바인드 처리한다. 
         	    fnSetInnerHtml();
         	    //	등록자 
         	    var rowId       = $("#productApp").getGridParam("selrow");
	    		var dtlData 	= $("#productApp").jqGrid('getRowData',rowId);
	    		
	    		// 확인요청자
	    		var text = ''; 
	    		if ($.trim(dtlData['register_nm']) != '') text += dtlData['register_nm'] ;
	    		if ($.trim(dtlData['register_date']) != '') text +=  '('+dtlData['register_date']+')';
	    		if($.trim(dtlData['register_nm']) != $.trim(dtlData['confirm_nm']) ) text += '_'+ dtlData['vendornm']; 
	    		$('#inserInfo').html(text); 
         	    
				//	승인요청자
	    		text = ''; 
	    		if ($.trim(dtlData['confirm_nm']) != '') text += dtlData['confirm_nm'] ;
	    		if ($.trim(dtlData['confirm_date']) != '') text +=  '('+dtlData['confirm_date']+')';
         	    $('#checkInfo').html(text);
         	    
         	    // 기존단가 
         	    text ='';
         	    if($.trim(dtlData['before_price']) != '' || $.number(dtlData['before_price']) != '0') text = $.number(dtlData['before_price']) ;
         	    $('#before_price').html(text);
         	        
         	    // 변경단가 
         	    text ='';
         	    if($.trim(dtlData['after_price']) != '' || $.number(dtlData['after_price']) != '0') text = $.number(dtlData['after_price']) ;
         	    $('#after_price').html(text);
         	    
         	    
         	   	fnSetVisibleBtn();
         	   	
         	   	
         	   	// 파라미터 설정 
         	   	reqParamObj['good_iden_numb'] 	= dtlData['good_iden_numb'];
         	   	
         	   	defObj.notify('LoadDetailDataDone');
        	},
        	onSelectRow:function(rowid,iRow,iCol,e) {},
        	ondblClickRow:function(rowid,iRow,iCol,e) {},
        	onCellSelect:function(rowid,iCol,cellcontent,target) {},
        	loadError:function(xhr,st,str) { $("#list").html(xhr.responseText); },
        	jsonReader: { root:"list",total:"total",records:"records",repeatitems:false,cell:"cell"}
    	});
    };
</script>

<!-- ************************************************************************************ -->
<!--                            차트 관련 스크립트                                                                                                             -->
<!-- ************************************************************************************ -->
<script type="text/javascript">
// 차트 데이터 로드 
function fnInitChart(){
    
    $.post(
        "<%=Constances.SYSTEM_CONTEXT_PATH %>/productApp/getProdVendorUnitPriceChart.sys"
        , {good_iden_numb:reqParamObj['good_iden_numb']}
        //, {good_iden_numb:'100'}
        , function(arg) {
            
            var loadData = eval('(' + arg + ')').prodVendor;
            
            if(loadData.length > 0 ){
                fnMakeProdVendorUnitPriceChart(loadData);    
            }
            
            var loadData = eval('(' + arg + ')').sellUnit;
            
            if(loadData.length > 0 ){
                fnMakeProdSellUnitPriceChart(loadData);    
            }
     });
}

// 공급사 매입단가 차트 그리기 
function fnMakeProdVendorUnitPriceChart(loadData){
    var _xSeparatColNm = 'VENDORNM';
    var identColVal_Array = [];
    
    for(var ii = 0 ; ii < loadData.length ; ii++ ){
        if(identColVal_Array.length > 0 ){
            
            var isDuplicated = false; 
            for(var jj = 0; jj < identColVal_Array.length ; jj++ ){
                if(identColVal_Array[jj] == loadData[ii][_xSeparatColNm]){
                    isDuplicated = true; 
                    break; 
                }
            }
            
            if(!isDuplicated)	identColVal_Array.push(loadData[ii][_xSeparatColNm]);
        }else {
            identColVal_Array.push(loadData[ii][_xSeparatColNm]);
        }
    }
    
    
    var dataObj = [];
    for(var ii = 0 ; ii < identColVal_Array.length ; ii++) {
        
        var eachDataObj = {};
        eachDataObj['type'] 	= 'line';
        eachDataObj['title'] 	= identColVal_Array[ii];
        
        var individual_arr = [];
        for(var jj=0; jj < loadData.length ; jj++ ){
            if(loadData[jj][_xSeparatColNm] == identColVal_Array[ii]){
                 
                var msg = '\n'; 
                msg += 'YEAR['+Number(loadData[jj]['YEAR'])+']';
                msg += 'MON['+Number(loadData[jj]['MON'])+']';
                msg += 'DAY['+Number(loadData[jj]['DAY'])+']';
                
                individual_arr.push(
                        [new Date(
                             	Number(loadData[jj]['YEAR'])
                                ,Number(loadData[jj]['MON'])
                                ,Number(loadData[jj]['DAY'])
							)
                        	, 	Number(loadData[jj]['SALE_UNIT_PRIC'])
						]
                );
                
            }
        }
        eachDataObj['data'] 	= individual_arr;
        dataObj.push(eachDataObj); 
        
        
        
        
    }
    
    $('#jqChart').jqChart({
        
		title: { text: '공급사별 매입가 변화 추이' },
		legend: { visible: false },
		crosshairs: {
            enabled: true, // specifies whether the crosshairs are visible
            snapToDataPoints: true, // specifies whether the crosshairs span to data points
            hLine: { visible: true, strokeStyle: 'red' }, // horizontal line options
            vLine: { visible: true, strokeStyle: 'red' } // vertical line options
		},
		animation: { duration: 1 },
		series: dataObj
	});
    
    $('#jqChart').show(); 
}


function fnMakeProdSellUnitPriceChart(loadData){
    var _xSeparatColNm = 'GROUPCOL';
    var identColVal_Array = [];
    
    for(var ii = 0 ; ii < loadData.length ; ii++ ){
        if(identColVal_Array.length > 0 ){
            
            var isDuplicated = false; 
            for(var jj = 0; jj < identColVal_Array.length ; jj++ ){
                if(identColVal_Array[jj] == loadData[ii][_xSeparatColNm]){
                    isDuplicated = true; 
                    break; 
                }
            }
            
            if(!isDuplicated)	identColVal_Array.push(loadData[ii][_xSeparatColNm]);
        }else {
            identColVal_Array.push(loadData[ii][_xSeparatColNm]);
        }
    }
    
    
    var dataObj = [];
    for(var ii = 0 ; ii < identColVal_Array.length ; ii++) {
        
        var eachDataObj = {};
        eachDataObj['type'] 	= 'line';
        eachDataObj['title'] 	= identColVal_Array[ii];
        
        var individual_arr = [];
        for(var jj=0; jj < loadData.length ; jj++ ){
            if(loadData[jj][_xSeparatColNm] == identColVal_Array[ii]){
                 
                var msg = '\n'; 
                msg += 'YEAR['+Number(loadData[jj]['YEAR'])+']';
                msg += 'MON['+Number(loadData[jj]['MON'])+']';
                msg += 'DAY['+Number(loadData[jj]['DAY'])+']';
                
                individual_arr.push(
                        [new Date(
                             	Number(loadData[jj]['YEAR'])
                                ,Number(loadData[jj]['MON'])
                                ,Number(loadData[jj]['DAY'])
							)
                        	, 	Number(loadData[jj]['SELL_PRICE'])
						]
                );
                
            }
        }
        eachDataObj['data'] 	= individual_arr;
        dataObj.push(eachDataObj); 
    }
    
    $('#jqChart2').jqChart({
        
		title: { text: '상품 판매가 변화 추이' },
		animation: { duration: 1 },
		legend: { visible: false },
		crosshairs: {
            enabled: true, // specifies whether the crosshairs are visible
            snapToDataPoints: true, // specifies whether the crosshairs span to data points\
            legend: { visible: false },
            hLine: { visible: true, strokeStyle: 'red' }, // horizontal line options
            vLine: { visible: true, strokeStyle: 'red' } // vertical line options
		},
		series: dataObj
	});    
    
    $('#jqChart2').show(); 
}

</script>

<script type="text/javascript" >
	
	/**
	*	inner Html Text 를 변경 한다. 
	*/
	var fnSetInnerHtml = function (){
	    var rowId       = $("#productApp").getGridParam("selrow");
	    var dtlData = $("#productApp").jqGrid('getRowData',rowId);
        
        for(var proNm in dtlData){
            $('#'+proNm).html(dtlData[proNm]); 
        }
	};
	
	/**
	*	버튼 Visible 설정을 한다. 
	*/
	var fnSetVisibleBtn = function() {
	    var rowId       = $("#productApp").getGridParam("selrow");
	    var dtlData = $("#productApp").jqGrid('getRowData',rowId);
	    
	    if(dtlData['app_sts_flag'] != '0'){
	        $('#btnAdmAppOk').hide();
	        $('#btnAdmAppCancel').hide();
	    }
	};
	
	/**
	*	승인및 반려 처리를 한다. 
	*/
	var fnAppProduct = function(mod){
	    var rowId   = $("#productApp").getGridParam("selrow");
	    var dtlData = $("#productApp").jqGrid('getRowData',rowId);
	    
	    var msg = ''; 
	    if (mod == 'ok'){
	        msg += '위에 내용을 승인처리 하시겠습니까? ' ; 
	    }else if(mod == 'cancel' ) {
	        msg += '위에 내용을 반려처리 하시겠습니까? ' ;
	    }
	    
	    if(!confirm(msg)) return;
		
	    var params = new Object(); 
	    params['oper'] = mod; 
	    params['app_good_id'] = dtlData['app_good_id'];
	    
		$.post(
			"<%=Constances.SYSTEM_CONTEXT_PATH %>/productApp/setProductAppConfirmTransGrid.sys", 
			params,
			function(arg){ 
				if(  fnTransResult(arg, false) ) {
				    
				    var msg = eval('(' + arg + ')').msg;
				    
				    if((typeof(msg) != 'undefined') && $.trim(msg).length > 0  ){
				        $("#dialog").html("<font size='2'>"+msg+"</font>");
						$("#dialog").dialog({
							title: 'Success',modal: true,
							buttons: {"Ok": function(){$(this).dialog("close");} }
						});
				    }else {
						$("#dialog").html("<font size='2'>처리 하였습니다.</font>");
						$("#dialog").dialog({
							title: 'Success',modal: true,
							buttons: {"Ok": function(){
							    $(this).dialog("close"); 
							  	}}
						});
				    }
				    
				    if(typeof(window.dialogArguments) != 'undefined' || window.dialogArguments != null ){
				        window.returnValue='success';
				    }
				    
				    fnModalclose();
				}
			}
		);
	    
	};
	
	/**
	*	모달팝업 닫기!
	*/
	var fnModalclose = function (){ 
	    self.close(); 
	};
	
</script>
</head>
<body>
    <div>
        <form id="frm" name="frm" method="post">
            <table width="100%" border="0" cellspacing="0" cellpadding="0" align="left">
                <tr>
                    <td>
                        <!-- 타이틀 시작 -->
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr valign="top">
                                <td width="20" valign="middle">
                                    <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_ptitle1.gif" style="width: 14px; height: 15px;" />
                                </td>
                                <td height="29" class="ptitle">상품 승인 상세 </td>
                            </tr>
                        </table>
                        <!-- 타이틀 끝 -->
                    </td>
                </tr>
                <tr>
                    <td>
                        <!-- 타이틀 시작 -->
                        <table width="100%" style="height: 27px;" border="0" cellpadding="0" cellspacing="0">
                            <tr>
                                <td width="20" valign="top">
                                    <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_stitle_blue.gif" style="width: 5px; height: 5px;" class="bullet_stitle" />
                                </td>
                                <td class="stitle">승인요청 상품정보</td>
                            </tr>
                        </table>
                        <!-- 타이틀 끝 -->
                    </td>
                </tr>
                <tr>
                    <td>
                        <!-- 컨텐츠 시작 -->
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td colspan="6" class="table_top_line"></td>
                            </tr>
                            <tr>
                                <td colspan="6">
                                    <div id="jqgrid" style="display:none;">
                                        <table id="productApp"></table>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="6" height="1" bgcolor="eaeaea"></td>
                            </tr>
                            <tr>
                                <td class="table_td_subject">변경유형</td>
                                <td class="table_td_contents" id='apptypenm'></td>
                                <td class="table_td_subject">승인상태</td>
                                <td class="table_td_contents" colspan="3" id="appstsnm"></td>
                            </tr>
                            <tr>
                                <td colspan="6" height="1" bgcolor="eaeaea"></td>
                            </tr>
                            <tr>
                                <td class="table_td_subject">변경사유</td>
                                <td class="table_td_contents" colspan="5" id="change_reason">
                                </td>
                            </tr>
                            <tr>
                                <td colspan="6" height="1" bgcolor="eaeaea"></td>
                            </tr>
                            <tr>
                                <td class="table_td_subject">기존단가</td>
                                <td class="table_td_contents" id="before_price"> </td>
                                <td class="table_td_subject" >변경단가</td>
                                <td class="table_td_contents" id="after_price" colspan="3"> </td>
<!--                                 <td class="table_td_subject" >변화율(%)</td> -->
<!--                                 <td class="table_td_contents" id='chn_persent'> </td> -->
                            </tr>
                            <tr>
                                <td colspan="6" height="1" bgcolor="eaeaea"></td>
                            </tr>
                            <tr>
                                <td class="table_td_subject" width="120">상품명</td>
                                <td class="table_td_contents" id="good_name" width="25%"></td>
                                <td class="table_td_subject"  width="120">상품코드</td>
                                <td class="table_td_contents" id='good_iden_numb' width="25%"></td>
                                <td class="table_td_subject"  width="120">공급사</td>
                                <td class="table_td_contents" id="vendornm" width="25%"></td>
                            </tr>
                            <tr>
                                <td colspan="6" height="1" bgcolor="eaeaea"></td>
                            </tr>
                            <tr>
                                <td class="table_td_subject">등록자</td>
                                <td class="table_td_contents" id="inserInfo"> </td>
                                <td class="table_td_subject" >확인자</td>
                                <td class="table_td_contents" colspan="3" id="checkInfo"> </td>
                            </tr>
                            <tr>
                                <td colspan="6" class="table_top_line"></td>
                            </tr>
                        </table>
                        <!-- 컨텐츠 끝 -->
                    </td>
                </tr>
                <tr>
                    <td>&nbsp;</td>
                </tr>
                <tr>
                    <td>
                       <table width="100%"  border="0" cellspacing="0" cellpadding="0">
                             <tr>
                                <td style="text-align:  center;" align="center">
                                    <div id="jqChart" style="width: 400px; height: 200px; display: none;"></div> 
                                </td>
                                <td style="text-align:  center;" align="center">
                                    <div id="jqChart2" style="width: 400px; height: 200px; display: none;"></div> 
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td>&nbsp;</td>
                </tr>
                <tr>
                    <td align="center">
                        <img id='btnAdmAppOk' src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type5_approval.gif" style="width: 65px; height: 23px; cursor: pointer;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_APP")%>" />
                        <img id='btnAdmAppCancel' src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type5_cancel2.gif" style="width: 110px; height: 23px; cursor: pointer;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_APP")%>" />
                        <img id='btnCommonClose' src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type5_close.gif" style="width: 65px; height: 23px; cursor: pointer;" />
                    </td>
                </tr>
            </table>
            <!-------------------------------- Dialog Div Start -------------------------------->
            <!-------------------------------- Dialog Div End -------------------------------->
            <textarea id="tx_load_content" cols="20" rows="2" style="display: none;"></textarea>
            <div id="dialogSelectRow" title="Warning" style="display: none; font-size: 12px; color: red;">
                <p></p>
            </div>
            <div id="dialog" title="Feature not supported" style="display: none;">
                <p></p>
            </div>
        </form>
    </div>
</body>
</html>