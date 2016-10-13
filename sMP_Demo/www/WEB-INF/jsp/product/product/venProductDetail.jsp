<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="kr.co.bitcube.common.dto.LoginUserDto"%>
<%@ page import="java.util.List"%>

<%
	@SuppressWarnings("unchecked")
	//화면권한가져오기(필수)
	List<ActivitiesDto> roleList = (List<ActivitiesDto>) request.getAttribute("useActivityList");
	LoginUserDto           userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
    
	// parameter
    String good_iden_numb   = request.getAttribute("good_iden_numb") == null   ? ""  : (String)request.getAttribute("good_iden_numb");
    String vendorid         = userInfoDto.getBorgId();
    
    //good_iden_numb   =  "100";
    // Size Params
    String listWidth = "$(window).width()-60 + Number(gridWidthResizePlus)";
    int listHeight = 30;
    
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

<% 	if(Constances.COMMON_ISREAL_SERVER && !"".equals(businessNum)) { %>
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
<%@ include file="/WEB-INF/jsp/common/auth/authBusinessNumberDiv.jsp" %>
<script type="text/javascript">
var authStep = "";
function fnAuth(){
	//fnGetIsExistPublishAuth(svcTypeCd, borgId) - 현재 세션의 공인인증서 인증상태를 확인 (파라미터3 참조)
	authStep = fnGetIsExistPublishAuth('<%=userInfoDto.getSvcTypeCd()%>','<%=userInfoDto.getBorgId()%>');
	fnAuthBusinessNumberDialog("VEN", "ETC", authStep, '<%=businessNum%>',"fnCallBackAuthBusinessNumber", '<%=userInfoDto.getBorgId()%>');
}

function fnCallBackAuthBusinessNumber(userDn) {
	if((userDn != "" && userDn != null) || authStep == "2"){
		if($.trim($("#authMode").val()) == "A"){
			if($("#divSoldOut").css('display') == 'none') {
				fnOepnChagePriceDiv();
			}
		}else if($.trim($("#authMode").val()) == "S"){
			if($("#divReqChangePrice").css('display') == 'none') {
				fnOepnSoldOutDiv();
			}
		}
	}
}
</script>
<%	}else{ %>
<script type="text/javascript">
function fnAuth(){
	if($.trim($("#authMode").val()) == "A"){
		if($("#divSoldOut").css('display') == 'none') {
			fnOepnChagePriceDiv();
		}
	}else if($.trim($("#authMode").val()) == "S"){
		if($("#divReqChangePrice").css('display') == 'none') {
			fnOepnSoldOutDiv();
		}
	}
}
</script>
<%	} %>
<% //------------------------------------------------------------------------------ %>

<!-- 버튼 이벤트 스크립트 -->
<script type="text/javascript">
    jQuery.fn.exists = function(){return ($(this).length > 0);};
    var jq = jQuery;							// jQuery 
    var reqParamObj = new Object();				// RequestParameter 설정
    var defObj = new jQuery.Deferred();			// Deferred() 를 이용하여 동기식 처리 방식으로 변환한다.
 
    
    $(document).ready(function() {
     
        // component Event
        $('#btnVenSave').click(  	function() { fnReqProdTranSaction();    });
        $('#btnCommonClose').click( function() { fnThisPageClose();    });
        
        $('#btnAlterPrice').click( function() 	{
        	$("#authMode").val("A");
        	fnAuth();
        //	fnOepnChagePriceDiv();    
        });
        $('#btnSoldOut').click( function() 		{
        	$("#authMode").val("S");
        	fnAuth();        	
        //	fnOepnSoldOutDiv() ;    
        });
        
        $('#btnReqestChangePrice').click(function (){	fnSubmitChangeUnitPrice();   });
        $('#btnReqSoldOut').click(function (){	fnRequestSoldOut();   });
        
        // Image Process Event 
        $("#btnAttachDel").click( function() { attachDel(); });
     
     
     // Edit Setting 
        Editor.getCanvas().setCanvasSize({height:150});  //daum editor height 지정
        Editor.getCanvas().observeJob(Trex.Ev.__CANVAS_PANEL_KEYUP, function(e) {
			fnSetProductDescContents('productInfo',Editor.getContent());
		});
        
     	
        reqParamObj = fnSetRequestParmas(defObj);
        defObj.notify('setPramsDone');
        
        // 동기식처리 
        defObj.progress(
        	function(insMod ){
        	    if(insMod == 'setPramsDone'){
        	        fnLoadCodeDataSet(defObj );	        
        	    }else if(insMod == 'codeDataDone'){
        	        fnLoadReqDataSet(defObj  );    
        	    }else if (insMod == 'loadDataDone') {
        	        fnInitComponents(defObj );
        	    }else if(insMod =='initComponentDone'){
        	        defObj.resolve();
        	    }
        	}
        ).done(function(){
        });
        
        
    });
    
    /**
     * 넘오온 파라미터 정보를 설정한다.  
     */    
    var fnSetRequestParmas = function(defObj ){
        var rtnObj = new Object();
        rtnObj['good_iden_numb']	='<%=good_iden_numb%>';
        rtnObj['vendorid']			='<%=vendorid%>';
        return rtnObj; 
    };
    
    /**
     * 코드 데이터를 로드한다
     * @param defObj([동기방식 처리시 활용 ])  jQuery.Deferred() 
     */
    var fnLoadCodeDataSet = function (defObj ) {
        $.post(
            '<%=Constances.SYSTEM_CONTEXT_PATH %>/product/initDetailCodeInfo.sys',
            {},
            function(arg){
                if(fnTransResult(arg, false)){
                    // 주문단위 
                    var orderUnit = eval('(' + arg + ')').orderUnit;
                    $("#orde_clas_code").html("");
                    $("#orde_clas_code").append("<option value=''>선택</option>");
                    for(var i=0;i<orderUnit.length;i++) {
                        $("#orde_clas_code").append("<option value='"+orderUnit[i].codeVal1+"'>"+orderUnit[i].codeNm1+"</option>");
                    }
                    // 상품구분 
                    var orderGoodsType = eval('(' + arg + ')').orderGoodsType;
                    $("#good_clas_code").html("");
                    $("#good_clas_code").append("<option value=''>선택</option>");
                    for(var i=0;i<orderGoodsType.length;i++) {
                        $("#good_clas_code").append("<option value='"+orderGoodsType[i].codeVal1+"'>"+orderGoodsType[i].codeNm1+"</option>");
                    }
                    // 권역 
                    var deliAreaCodeList = eval('(' + arg + ')').deliAreaCodeList;
                    $("#areatype").html("");
                    $("#areatype").append("<option value=''>선택</option>");
                    for(var i=0;i<deliAreaCodeList.length;i++) {
                        $("#areatype").append("<option value='"+deliAreaCodeList[i].codeVal1+"'>"+deliAreaCodeList[i].codeNm1+"</option>");
                    }
                    
                    defObj.notify('codeDataDone' );
                }
            }
        );
    };
    
    
    /**
     * 그리드 정보를 로드한다. 
     * @param pReq_good_id([상품 등록 요청 Seq])  String 
     * @param defObj([동기방식 처리시 활용 ])  jQuery.Deferred() 
     */
    var fnLoadReqDataSet = function(defObj){
		
		var gridParams = new Object();
		gridParams['good_iden_numb'] 	= reqParamObj['good_iden_numb']; 
	    gridParams['vendorid'] 		= reqParamObj['vendorid'];
		    
        jq("#productInfo").jqGrid({
            url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/productManage/getGoodVendorListForVendorJQGrid.sys',
            datatype:'json',
            mtype:'POST',
            colNames:[
                'good_iden_numb'                 // 상품코드                  
                ,'vendorid'                      // 공급사코드                
                ,'good_name'                     // 상품명                    
                ,'sale_unit_pric'                // 단가                  
                ,'good_st_spec_desc'             // 표준규격                      
                ,'good_spec_desc'                // 규격
                ,'orde_clas_code'                // 단위                      
                ,'deli_mini_day'                 // 납품소요일수              
                ,'deli_mini_quan'                // 최소구매수량              
                ,'make_comp_name'                // 제조사                    
                ,'good_same_word'                // 동의어                    
                ,'original_img_path'             // 대표이미지원본            
                ,'large_img_path'                // 대표이미지대              
                ,'middle_img_path'               // 대표이미지중              
                ,'small_img_path'                // 대표이미지소              
                ,'good_desc'                     // 상품설명                  
                ,'good_clas_code'                // 상품구분                  
                ,'good_inventory_cnt'            // 재고수량                  
                ,'insert_user_id'                // 등록자id                  
                ,'inser_user_nm'                 // 등록자 명                 
                ,'insert_date'                   // 등록일                    
                ,'app_sts'                       // 처리상태                  
                ,'admin_user_id'                 // 담당운영자id              
                ,'admin_user_nm'                 // 담당운영자 명             
                ,'app_user_id'                   // 확인자id                  
                ,'app_user_nm'                   // 확인자 명                 
                ,'app_date'                      // 확인일                    
                ,'create_good_date'              // 품목등록일                
                ,'vendornm'                      /*공급사명 */     
                ,'vendorcd'                      /*공급사코드 */   
                ,'areatype'                      /*공급사권역 */   
                ,'pressentnm'                    /*대표자명 */       
                ,'phonenum'                      /*공급사연락처 */ 
                ,'isfixappexists'                /*공급사 변경에 따른 승인 존재여부 Y N     */
				,'ischangepriceexists'           /*공급사 단가 변경 요청 승인 존재여부 Y N   */
				,'ischangesoldoutexists'         /*공급사 종료 승인 존재여부 Y N           */
				,'full_cate_name'                //카테고리명 
                ,'org_req_good_id'               // 원본상품등록요청seq       
                ,'org_good_iden_numb'             // 원본상품코드              
                ,'org_vendorid'                  // 원본공급사코드            
                ,'org_good_name'                 // 원본상품명                
                ,'org_sale_unit_pric'            // 원본단가
                ,'org_good_st_spec_desc'         // 원본표준규격
                ,'org_good_spec_desc'            // 원본규격                  
                ,'org_orde_clas_code'            // 원본단위                  
                ,'org_deli_mini_day'             // 원본납품소요일수          
                ,'org_deli_mini_quan'            // 원본최소구매수량          
                ,'org_make_comp_name'            // 원본제조사                
                ,'org_good_same_word'            // 원본동의어                
                ,'org_original_img_path'         // 원본대표이미지원본        
                ,'org_large_img_path'            // 원본대표이미지대          
                ,'org_middle_img_path'           // 원본대표이미지중          
                ,'org_small_img_path'            // 원본대표이미지소          
                ,'org_good_desc'                 // 원본상품설명              
                ,'org_good_clas_code'            // 원본상품구분              
                ,'org_good_inventory_cnt'        // 원본재고수량              
                ,'org_insert_user_id'            // 원본등록자id              
                ,'org_inser_user_nm'             // 원본등록자 명             
                ,'org_insert_date'               // 원본등록일                
                ,'org_app_sts'                   // 원본처리상태              
                ,'org_admin_user_id'             // 원본담당운영자id          
                ,'org_admin_user_nm'             // 원본담당운영자 명         
                ,'org_app_user_id'               // 원본확인자id              
                ,'org_app_user_nm'               // 원본확인자 명             
                ,'org_app_date'                  // 원본확인일                
                ,'org_create_good_date'           // 원본품목등록일         
                ,'org_vendornm'                      /*원본공급사명 */     
                ,'org_vendorcd'                      /*원본공급사코드 */   
                ,'org_areatype'                      /*원본공급사권역 */   
                ,'org_pressentnm'                    /*원본대표자명 */       
                ,'org_phonenum'                      /*원본공급사연락처 */
				,'org_isfixappexists'                /*공급사 변경에 따른 승인 존재여부 Y N     */
				,'org_ischangepriceexists'           /*공급사 단가 변경 요청 승인 존재여부 Y N   */
				,'org_ischangesoldoutexists'         /*공급사 종료 승인 존재여부 Y N           */
				,'org_full_cate_name'                //카테고리명
				,'the_day_post'
            ],
            colModel:[
                {name:'good_iden_numb',index:'good_iden_numb',width:100,key:true},                         // 상품코드                 
                {name:'vendorid',index:'vendorid',width:100},                                              // 공급사코드                
                {name:'good_name',index:'good_name',width:100},                                            // 상품명                  
                {name:'sale_unit_pric',index:'sale_unit_pric',width:100},                                  // 단가                 
                {name:'good_st_spec_desc',index:'good_st_spec_desc',width:100},                            // 표준규격                   
                {name:'good_spec_desc',index:'good_spec_desc',width:100},                                  // 규격
                {name:'orde_clas_code',index:'orde_clas_code',width:100},                                  // 단위                   
                {name:'deli_mini_day',index:'deli_mini_day',width:100},                                    // 납품소요일수               
                {name:'deli_mini_quan',index:'deli_mini_quan',width:100},                                  // 최소구매수량               
                {name:'make_comp_name',index:'make_comp_name',width:100},                                  // 제조사                  
                {name:'good_same_word',index:'good_same_word',width:100},                                  // 동의어                  
                {name:'original_img_path',index:'original_img_path',width:100},                            // 대표이미지원본              
                {name:'large_img_path',index:'large_img_path',width:100},                                  // 대표이미지대               
                {name:'middle_img_path',index:'middle_img_path',width:100},                                // 대표이미지중               
                {name:'small_img_path',index:'small_img_path',width:100},                                  // 대표이미지소               
                {name:'good_desc',index:'good_desc',width:100},                                            // 상품설명                 
                {name:'good_clas_code',index:'good_clas_code',width:100},                                  // 상품구분                 
                {name:'good_inventory_cnt',index:'good_inventory_cnt',width:100},                          // 재고수량                 
                {name:'insert_user_id',index:'insert_user_id',width:100},                                  // 등록자ID                
                {name:'inser_user_nm',index:'inser_user_nm',width:100},                                    // 등록자 명                
                {name:'insert_date',index:'insert_date',width:100},                                        // 등록일                  
                {name:'app_sts',index:'app_sts',width:100},                                                // 처리상태                 
                {name:'admin_user_id',index:'admin_user_id',width:100},                                    // 담당운영자ID              
                {name:'admin_user_nm',index:'admin_user_nm',width:100},                                    // 담당운영자 명              
                {name:'app_user_id',index:'app_user_id',width:100},                                        // 확인자ID                
                {name:'app_user_nm',index:'app_user_nm',width:100},                                        // 확인자 명                
                {name:'app_date',index:'app_date',width:100},                                              // 확인일                  
                {name:'create_good_date',index:'create_good_date',width:100},                              // 품목등록일                
                {name:'vendornm'    ,index:'vendornm'    ,width:100},                              /*공급사명 */     
                {name:'vendorcd'    ,index:'vendorcd'    ,width:100},                              /*공급사코드 */    
                {name:'areatype'    ,index:'areatype'    ,width:100},                              /*공급사권역 */    
                {name:'pressentnm'  ,index:'pressentnm'  ,width:100},                              /*대표자명 */     
                {name:'phonenum'    ,index:'phonenum'    ,width:100},                              /*공급사연락처 */
                {name:'isfixappexists'       ,index:'isfixappexists'       ,width:100}, /*공급사 변경에 따른 승인 존재여부 Y N     */   
                {name:'ischangepriceexists'  ,index:'ischangepriceexists'  ,width:100}, /*공급사 단가 변경 요청 승인 존재여부 Y N   */   
                {name:'ischangesoldoutexists',index:'ischangesoldoutexists',width:100}, /*공급사 종료 승인 존재여부 Y N         */
                {name:'full_cate_name',index:'full_cate_name',width:100,hidden:true},                // 카테고리명
                {name:'org_req_good_id',index:'org_req_good_id',width:100,hidden:true},                    // 원본상품등록요청SEQ
                {name:'org_good_iden_numb',index:'org_good_iden_numb',width:100,hidden:true},                // 원본상품코드
                {name:'org_vendorid',index:'org_vendorid',width:100,hidden:true},                          // 원본공급사코드              
                {name:'org_good_name',index:'org_good_name',width:100,hidden:true},                        // 원본상품명                
                {name:'org_sale_unit_pric',index:'org_sale_unit_pric',width:100,hidden:true},              // 원본단가               
                {name:'org_good_st_spec_desc',index:'org_good_st_spec_desc',width:100,hidden:true},        // 원본표준규격                 
                {name:'org_good_spec_desc',index:'org_good_spec_desc',width:100,hidden:true},              // 원본규격
                {name:'org_orde_clas_code',index:'org_orde_clas_code',width:100,hidden:true},              // 원본단위                 
                {name:'org_deli_mini_day',index:'org_deli_mini_day',width:100,hidden:true},                // 원본납품소요일수             
                {name:'org_deli_mini_quan',index:'org_deli_mini_quan',width:100,hidden:true},              // 원본최소구매수량             
                {name:'org_make_comp_name',index:'org_make_comp_name',width:100,hidden:true},              // 원본제조사                
                {name:'org_good_same_word',index:'org_good_same_word',width:100,hidden:true},              // 원본동의어                
                {name:'org_original_img_path',index:'org_original_img_path',width:100,hidden:true},        // 원본대표이미지원본            
                {name:'org_large_img_path',index:'org_large_img_path',width:100,hidden:true},              // 원본대표이미지대             
                {name:'org_middle_img_path',index:'org_middle_img_path',width:100,hidden:true},            // 원본대표이미지중             
                {name:'org_small_img_path',index:'org_small_img_path',width:100,hidden:true},              // 원본대표이미지소             
                {name:'org_good_desc',index:'org_good_desc',width:100,hidden:true},                        // 원본상품설명               
                {name:'org_good_clas_code',index:'org_good_clas_code',width:100,hidden:true},              // 원본상품구분               
                {name:'org_good_inventory_cnt',index:'org_good_inventory_cnt',width:100,hidden:true},      // 원본재고수량               
                {name:'org_insert_user_id',index:'org_insert_user_id',width:100,hidden:true},              // 원본등록자ID              
                {name:'org_inser_user_nm',index:'org_inser_user_nm',width:100,hidden:true},                // 원본등록자 명              
                {name:'org_insert_date',index:'org_insert_date',width:100,hidden:true},                    // 원본등록일                
                {name:'org_app_sts',index:'org_app_sts',width:100,hidden:true},                            // 원본처리상태               
                {name:'org_admin_user_id',index:'org_admin_user_id',width:100,hidden:true},                // 원본담당운영자ID            
                {name:'org_admin_user_nm',index:'org_admin_user_nm',width:100,hidden:true},                // 원본담당운영자 명            
                {name:'org_app_user_id',index:'org_app_user_id',width:100,hidden:true},                    // 원본확인자ID              
                {name:'org_app_user_nm',index:'org_app_user_nm',width:100,hidden:true},                    // 원본확인자 명              
                {name:'org_app_date',index:'org_app_date',width:100,hidden:true},                          // 원본확인일                
                {name:'org_create_good_date',index:'org_create_good_date',width:100,hidden:true},          // 원본품목등록일      
                {name:'org_vendornm'  ,index:'org_vendornm'  ,width:100,hidden:true},           // 원본공급사명 */  
                {name:'org_vendorcd'  ,index:'org_vendorcd'  ,width:100,hidden:true},           // 원본공급사코드 */ 
                {name:'org_areatype'  ,index:'org_areatype'  ,width:100,hidden:true},           // 원본공급사권역 */ 
                {name:'org_pressentnm',index:'org_pressentnm',width:100,hidden:true},           // 원본대표자명 */  
                {name:'org_phonenum'  ,index:'org_phonenum'  ,width:100,hidden:true},           // 원본공급사연락처 */
                {name:'org_isfixappexists'	,index:'org_isfixappexists'       ,width:100,hidden:true}, /*공급사 변경에 따른 승인 존재여부 Y N     */           
                {name:'org_ischangepriceexists' ,index:'org_ischangepriceexists'  ,width:100,hidden:true}, /*공급사 단가 변경 요청 승인 존재여부 Y N   */          
                {name:'org_ischangesoldoutexists',index:'org_ischangesoldoutexists',width:100,hidden:true},  /*공급사 종료 승인 존재여부 Y N         */
                {name:'org_full_cate_name',index:'org_full_cate_name',width:100,hidden:true},                // 카테고리명
                {name:'the_day_post',index:'the_day_post',width:100,hidden:true}                             // 당일발송
            ],
            postData: gridParams,
            rownumbers:false,
            width:$(window).width()-60 + Number(gridWidthResizePlus),
            sortname:'',sortorder:'',
            caption:"공급사 상품정보", 
            viewrecords:true,emptyrecords:'Empty records',loadonce:false,shrinkToFit:false, //해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
            loadComplete:function() {
                
                var rowid = $('#productInfo').getGridParam("selrow");
        	    if(rowid == null) {
        	  	   $("#productInfo").setSelection($("#productInfo").getDataIDs()[0]);
        	  	   rowid = $('#productInfo').getGridParam("selrow");
        	  	}
        	    
        	    var rowData = jq("#productInfo").jqGrid('getRowData',rowid);
        	    
        	    fnSetComponentValByGridDataObject( rowData ,'org_');
        	    
        	 	// 예외 처리 
        	 	// 1. 상세설명 
        	 	if($.trim(rowData['good_desc']) > ' '){
        	 		var gooddesc = unescape(rowData['good_desc']);
					$('#tx_load_content').val(gooddesc);
					$('#tx_load_content').val(gooddesc.replaceAll("\r\n", "<BR>")); 
					loadContent();
        	 	}
        	 	
        	 	// 2.표준규격 및 규격 설정
        	 	if($.trim(rowData['good_st_spec_desc']) > ' '){
        	 	   $('#good_st_spec_desc1').val(rowData['good_st_spec_desc'].split("‡")[0]); 
        	 	 	$('#good_st_spec_desc2').val(rowData['good_st_spec_desc'].split("‡")[1]);
        	 	 	$('#good_st_spec_desc3').val(rowData['good_st_spec_desc'].split("‡")[2]);
        	 	 	$('#good_st_spec_desc4').val(rowData['good_st_spec_desc'].split("‡")[3]);
        	 	 	$('#good_st_spec_desc5').val(rowData['good_st_spec_desc'].split("‡")[4]);
        	 	 	$('#good_st_spec_desc6').val(rowData['good_st_spec_desc'].split("‡")[5]);
        	 	}
        	 	if($.trim(rowData['good_spec_desc']) > ' '){
        	 	 	$('#good_spec_desc1').val(rowData['good_spec_desc'].split("‡")[0]); 
        	 	 	$('#good_spec_desc2').val(rowData['good_spec_desc'].split("‡")[1]);
        	 	 	$('#good_spec_desc3').val(rowData['good_spec_desc'].split("‡")[2]);
        	 	 	$('#good_spec_desc4').val(rowData['good_spec_desc'].split("‡")[3]);
        	 	 	$('#good_spec_desc5').val(rowData['good_spec_desc'].split("‡")[4]);
        	 	 	$('#good_spec_desc6').val(rowData['good_spec_desc'].split("‡")[5]);
        	 	 	$('#good_spec_desc7').val(rowData['good_spec_desc'].split("‡")[6]);    
        	 	 	$('#good_spec_desc8').val(rowData['good_spec_desc'].split("‡")[7]);
        	 	 }
        		
        	 	// 3.동의어 설정
        	 	if($.trim(rowData['good_same_word']) > ' ' ){
        			$('#good_same_word1').val(rowData['good_same_word'].split("‡")[0]);
        	 	 	$('#good_same_word2').val(rowData['good_same_word'].split("‡")[1]);
        	 	 	$('#good_same_word3').val(rowData['good_same_word'].split("‡")[2]);
        	 	 	$('#good_same_word4').val(rowData['good_same_word'].split("‡")[3]);
        	 	 	$('#good_same_word5').val(rowData['good_same_word'].split("‡")[4]);    
        	 	}
        	 	
        		// 4.img 설정
        	 	if($.trim(rowData['small_img_path']) != '' || $.trim(rowData['middle_img_path']) != '' || $.trim(rowData['large_img_path']) != '' ){
        	 	    var imgPathForSMALL = "<%=Constances.SYSTEM_IMAGE_PATH%>/"  + rowData['small_img_path'];
        			var imgPathForMEDIUM = "<%=Constances.SYSTEM_IMAGE_PATH%>/" + rowData['middle_img_path'];
        			var imgPathForLARGE = "<%=Constances.SYSTEM_IMAGE_PATH%>/"  + rowData['large_img_path'];
        			
        			var msg = '' ;
        			msg += '\n imgPathForSMALL  value ['+imgPathForSMALL +']'; 
        			msg += '\n imgPathForMEDIUM value ['+imgPathForMEDIUM+']'; 
        			msg += '\n imgPathForLARGE  value ['+imgPathForLARGE +']'; 
        			//alert(msg);
        			$('#SMALL').attr('src',imgPathForSMALL);
        			$('#MEDIUM').attr('src',imgPathForMEDIUM);
        			$('#LARGE').attr('src',imgPathForLARGE);
        	 	}
        		
        		defObj.notify('loadDataDone' );
            },
            onSelectRow:function(rowid,iRow,iCol,e) {},
            ondblClickRow:function(rowid,iRow,iCol,e) {},
            onCellSelect:function(rowid,iCol,cellcontent,target) {},
            loadError:function(xhr,st,str) { $("#list").html(xhr.responseText); },
            jsonReader: { root:"list",total:"total",records:"records",repeatitems:false,cell:"cell"}
        });
    };
    
    
    /**
     * 컨퍼넌트를 초기화 한다 
     * @param defObj([동기방식 처리시 활용 ])  jQuery.Deferred() 
     */
    var fnInitComponents = function(defObj   ){
        
        // 사용자 분리  1. 고객사 , 2.운영사    
        var rowid = $('#productInfo').getGridParam("selrow");
	    if(rowid == null) {
	  	   $("#productInfo").setSelection($("#productInfo").getDataIDs()[0]);
	  	   rowid = $('#productInfo').getGridParam("selrow");
	  	}
       	var rowData = jq('#productInfo').jqGrid('getRowData',rowid);
        
       	
      	//--------------------------------------------------------------------------------
       	// 상태에 따른 화면 버튼 처리 
       	//--------------------------------------------------------------------------------
        
       	
       	//----------------------------------------------------------------------------------------
       	// Component Value Formatting 
       	//----------------------------------------------------------------------------------------
       	$('#sale_unit_pric').blur();
       	$('#good_inventory_cnt').blur();
       	defObj.notify('initComponentDone');
    };
    
    /**
     *	선택된 데이터 샛을 기준으로 Component 에 바인드 처리한다.   
     */
	var fnBindComponentValue = function(defObj){
	    
        var rowid = $('#productInfo').getGridParam("selrow");
	    if(rowid == null) {
	  	   $("#productInfo").setSelection($("#productInfo").getDataIDs()[0]);
	  	   rowid = $('#productInfo').getGridParam("selrow");
	  	}
	    
	    var rowData = jq("#productInfo").jqGrid('getRowData',rowid);
	    
	    fnSetComponentValByGridDataObject( rowData ,'org_');
	    
	 	// 예외 처리 
	 	// 1. 상세설명 
	 	if($.trim(rowData['good_desc']) > ' '){
	  	   $('#tx_load_content').val(rowData['good_desc']);
	  	    $('#tx_load_content').val(rowData['good_desc'].replaceAll("\r\n", "<BR>")); 
	 	}
	 	
	 	// 2.표준규격 및 규격 설정
	 	if($.trim(rowData['good_st_spec_desc']) > ' '){
 	 	   $('#good_st_spec_desc1').val(rowData['good_st_spec_desc'].split("‡")[0]); 
 	 	 	$('#good_st_spec_desc2').val(rowData['good_st_spec_desc'].split("‡")[1]);
 	 	 	$('#good_st_spec_desc3').val(rowData['good_st_spec_desc'].split("‡")[2]);
 	 	 	$('#good_st_spec_desc4').val(rowData['good_st_spec_desc'].split("‡")[3]);
 	 	 	$('#good_st_spec_desc5').val(rowData['good_st_spec_desc'].split("‡")[4]);
 	 	 	$('#good_st_spec_desc6').val(rowData['good_st_spec_desc'].split("‡")[5]);
 	 	}
	 	if($.trim(rowData['good_spec_desc']) > ' '){
	 	   $('#good_spec_desc1').val(rowData['good_spec_desc'].split("‡")[0]); 
	 	 	$('#good_spec_desc2').val(rowData['good_spec_desc'].split("‡")[1]);
	 	 	$('#good_spec_desc3').val(rowData['good_spec_desc'].split("‡")[2]);
	 	 	$('#good_spec_desc4').val(rowData['good_spec_desc'].split("‡")[3]);
	 	 	$('#good_spec_desc5').val(rowData['good_spec_desc'].split("‡")[4]);
	 	 	$('#good_spec_desc6').val(rowData['good_spec_desc'].split("‡")[5]);
	 	 	$('#good_spec_desc7').val(rowData['good_spec_desc'].split("‡")[6]);    
	 	 	$('#good_spec_desc8').val(rowData['good_spec_desc'].split("‡")[7]);
	 	}
		
	 	// 3.동의어 설정
	 	if($.trim(rowData['good_same_word']) > ' ' ){
			$('#good_same_word1').val(rowData['good_same_word'].split("‡")[0]);
	 	 	$('#good_same_word2').val(rowData['good_same_word'].split("‡")[1]);
	 	 	$('#good_same_word3').val(rowData['good_same_word'].split("‡")[2]);
	 	 	$('#good_same_word4').val(rowData['good_same_word'].split("‡")[3]);
	 	 	$('#good_same_word5').val(rowData['good_same_word'].split("‡")[4]);    
	 	}
	 	
		// 4.img 설정
	 	if($.trim(rowData['small_img_path']) != '' || $.trim(rowData['middle_img_path']) != '' || $.trim(rowData['large_img_path']) != '' ){
	 	    var imgPathForSMALL = "<%=Constances.SYSTEM_IMAGE_PATH%>/"  + rowData['small_img_path'];
			var imgPathForMEDIUM = "<%=Constances.SYSTEM_IMAGE_PATH%>/" + rowData['middle_img_path'];
			var imgPathForLARGE = "<%=Constances.SYSTEM_IMAGE_PATH%>/"  + rowData['large_img_path'];
			
			var msg = '' ;
			msg += '\n imgPathForSMALL  value ['+imgPathForSMALL +']'; 
			msg += '\n imgPathForMEDIUM value ['+imgPathForMEDIUM+']'; 
			msg += '\n imgPathForLARGE  value ['+imgPathForLARGE +']'; 
			//alert(msg);
			$('#SMALL').attr('src',imgPathForSMALL);
			$('#MEDIUM').attr('src',imgPathForMEDIUM);
			$('#LARGE').attr('src',imgPathForLARGE);
	 	}
		
		defObj.notify('loadDataDone' );
	};
	
	
	/**
	*	Transaction 처리 시
	*/
	var fnReqProdTranSaction = function(){
		
		fnSetProductDescContents('productInfo',Editor.getContent());
		
		//Validation 체크 
		if(!fnValidationReqProduct()) return ;
		
		var msg = ''; 
		var rowid = $('#productInfo').getGridParam("selrow");
		if(rowid == null) {
			$("#productInfo").setSelection($("#productInfo").getDataIDs()[0]);
			rowid = $('#productInfo').getGridParam("selrow");
		}
		var rowData = jq('#productInfo').jqGrid('getRowData',rowid);
		
		// 표준규격 및 규격 설정 
		rowData['good_st_spec_desc'] = $('#good_st_spec_desc1').val()
			+'‡'+$('#good_st_spec_desc2').val()
			+'‡'+$('#good_st_spec_desc3').val()
			+'‡'+$('#good_st_spec_desc4').val()
			+'‡'+$('#good_st_spec_desc5').val()
			+'‡'+$('#good_st_spec_desc6').val();
		
		rowData['good_spec_desc'] = $('#good_spec_desc1').val()
			+'‡'+$('#good_spec_desc2').val()
			+'‡'+$('#good_spec_desc3').val()
			+'‡'+$('#good_spec_desc4').val()
			+'‡'+$('#good_spec_desc5').val()
			+'‡'+$('#good_spec_desc6').val()
			+'‡'+$('#good_spec_desc7').val()
		+'‡'+$('#good_spec_desc8').val();
			
		// 동의어 설정 
		rowData['good_same_word'] = $('#good_same_word1').val()
			+'‡'+$('#good_same_word2').val()
			+'‡'+$('#good_same_word3').val()
			+'‡'+$('#good_same_word4').val()
			+'‡'+$('#good_same_word5').val();
		
		if(!confirm("입력 및 수정하신 내용을  수정하시겠습니까?")) return;
		$.post(
			"<%=Constances.SYSTEM_CONTEXT_PATH %>/productManage/setProductVendorInfoExistSaleUnitPrice.sys", 
			rowData,
			function(arg){ 
				if(  fnTransResult(arg, false)  ) {
					alert('성공적으로 처리 하였습니다.');
					opener.fnReLoadDataGrid();
					fnThisPageClose();
				}
			}
		);
	};
	
	/**
	 * 저장 및 수정시 Validation을 채크 한다. 
	 */
	var fnValidationReqProduct = function(){
	    var rowid = $('#productInfo').getGridParam("selrow");
	    if(rowid == null) {
	  	   $("#productInfo").setSelection($("#productInfo").getDataIDs()[0]);
	  	   rowid = $('#productInfo').getGridParam("selrow");
	  	}
       	var rowData = jq('#productInfo').jqGrid('getRowData',rowid);
       	
       	if($.trim(rowData['good_name']) == ''){
			$('#dialogSelectRow').html('<p>상품명은 필수 값입니다.</p>');
			$("#dialogSelectRow").dialog();
    		return false;
        }
       	
       	if($.trim(rowData['sale_unit_pric']) == ''){
			$('#dialogSelectRow').html('<p>단가는 필수 값입니다.</p>');
			$("#dialogSelectRow").dialog();
    		return false;
        }
       	
       	if(  parseInt(rowData['sale_unit_pric'].replace(/,/g , "")) == 0 ){
			$('#dialogSelectRow').html('<p>단가는 0보다 큰값을 입력하셔야 합니다.</p>');
			$("#dialogSelectRow").dialog();
    		return false;
        }
       	
       	if($.trim(rowData['good_clas_code']) == ''){
			$('#dialogSelectRow').html('<p>상품구분은 필수 값입니다.</p>');
			$("#dialogSelectRow").dialog();
    		return false;
        }
       	
       	if($.trim(rowData['orde_clas_code']) == ''){
			$('#dialogSelectRow').html('<p>주문단위는 필수 값입니다.</p>');
			$("#dialogSelectRow").dialog();
    		return false;
        }
       	
       	if($.trim(rowData['deli_mini_quan']) == ''){
			$('#dialogSelectRow').html('<p>최소주문 수량은  필수 값입니다.</p>');
			$("#dialogSelectRow").dialog();
    		return false;
        }
       	
       	if(  parseInt(rowData['deli_mini_quan'].replace(/,/g , "")) == 0 ){
			$('#dialogSelectRow').html('<p>최소주문 수량은 0보다 큰값을 입력하셔야 합니다.</p>');
			$("#dialogSelectRow").dialog();
    		return false;
        }
       	
       	if($.trim(rowData['deli_mini_day']) == ''){
			$('#dialogSelectRow').html('<p>납품소요일은  필수 값입니다.</p>');
			$("#dialogSelectRow").dialog();
    		return false;
        }
       	
       	return true;
	};
	
	/**
	 * 해당 Page 닫기 
	 */
	var fnThisPageClose = function(){
// 	    if(typeof(window.dialogArguments) == 'object'){
// 	        top.close();
	        //window.returnValue='success';
// 	    }
		window.close();
	};
	
	
	/**
	* 단가 변경 요청 팝업을 연다 
	*/
	var fnOepnChagePriceDiv =function(){
		
	    var rowid = $('#productInfo').getGridParam("selrow");
	    if(rowid == null) {
	  	   $("#productInfo").setSelection($("#productInfo").getDataIDs()[0]);
	  	   rowid = $('#productInfo').getGridParam("selrow");
	  	}
       	var rowData = jq('#productInfo').jqGrid('getRowData',rowid);
       	
       	if(rowData['ischangepriceexists']=='Y'){
       	 	$('#dialogSelectRow').html('<p>단가변경중인 상태입니다. \n확인후 이용하시기 바랍니다.</p>');
			$("#dialogSelectRow").dialog();
       	    return false; 
       	}
       	
       	if(rowData['ischangesoldoutexists']=='Y'){
       	 $('#dialogSelectRow').html('<p>종료요청 상태입니다.\n종료요청시 단가변경은 불가합니다. \n확인후 이용하시기 바랍니다.</p>');
			$("#dialogSelectRow").dialog();
       	    return false; 
       	}
       	
       	$('#org_sale_unit_pric').val(rowData['sale_unit_pric']); 
       	$('#org_sale_unit_pric').blur();
       	$('#divReqChangePrice').attr("style", "position:absolute;top:250px;left:300px;z-index:100;display:inline;");
	};
	
	/**
	* 단가 변경 금액 Submit 
	*/
	var fnSubmitChangeUnitPrice = function(){
	    
	    if($.trim($('#price').val())==''){
       	 	$('#dialogSelectRow').html('<p>변경 단가는 필수 값입니다.</p>');
			$("#dialogSelectRow").dialog();
       	    return false; 
       	}
       	
	    if(parseInt($('#price').val().replace(/,/g , "")) == '0'){
			$('#dialogSelectRow').html('<p>변경단가는 0보다 큰 값이여야 합니다. </p>');
			$("#dialogSelectRow").dialog();
       	    return false; 
       	}
       	
       	if(parseInt($('#price').val().replace(/,/g , "")) == parseInt($('#org_sale_unit_pric').val().replace(/,/g , "")) ){
			$('#dialogSelectRow').html('<p>기존 단가와 동일한 경우 처리할수 없습니다.</p>');
			$("#dialogSelectRow").dialog();
       	    return false; 
       	}
       	
       	if(!confirm("입력하신 변경 단가금액을 요청하시겠습니까?")) return;
       	
       	
       	var rowid = $('#productInfo').getGridParam("selrow");
	    if(rowid == null) {
	  	   $("#productInfo").setSelection($("#productInfo").getDataIDs()[0]);
	  	   rowid = $('#productInfo').getGridParam("selrow");
	  	}
       	var rowData = jq('#productInfo').jqGrid('getRowData',rowid);
       	
       	var sumbitObj = new Object(); 
       	sumbitObj['good_iden_numb'] = rowData['good_iden_numb'];
		sumbitObj['vendorid'] 		= rowData['vendorid'];
		sumbitObj['applt_fix_code'] = '20';
		sumbitObj['apply_desc'] 	= $.trim($('#apply_desc').val()); 
		sumbitObj['price'] 			= $.trim($('#price').val());
		sumbitObj['before_price'] 	= $.trim($('#org_sale_unit_pric').val());
	
		$.post(
    		"<%=Constances.SYSTEM_CONTEXT_PATH %>/productManage/setFixGoodUnitPriceTrans.sys", 
    		sumbitObj,
    		function(arg){
    			if(  fnAjaxTransResult(arg)){
    			    fnAlterGridDataProValue('productInfo' , rowid ,'isfixappexists' ,'Y'); 
    			    fnAlterGridDataProValue('productInfo' , rowid ,'ischangepriceexists' ,'Y');
    			    $('#btnCloseChangePrice').click(); 
    			}
    		}
    	);
	};
	
	
	/**
	* 종료요청 버튼 클릭시 발생 이벤트 
	*/
	var fnOepnSoldOutDiv = function() {
	    var rowid = $('#productInfo').getGridParam("selrow");
	    if(rowid == null) {
	  	   $("#productInfo").setSelection($("#productInfo").getDataIDs()[0]);
	  	   rowid = $('#productInfo').getGridParam("selrow");
	  	}
       	var rowData = jq('#productInfo').jqGrid('getRowData',rowid);
       	
       	if(rowData['ischangepriceexists']=='Y'){
       	 	$('#dialogSelectRow').html('<p>단가변경중인 상태입니다. \n단가변경요청시 종료요청은 불가합니다.\n확인후 이용하시기 바랍니다.</p>');
			$("#dialogSelectRow").dialog();
       	    return false; 
       	}
       	
       	if(rowData['ischangesoldoutexists']=='Y'){
       	 $('#dialogSelectRow').html('<p>종료요청 상태입니다. \n확인후 이용하시기 바랍니다.</p>');
			$("#dialogSelectRow").dialog();
       	    return false; 
       	}
       	
       	$('#divSoldOut').attr("style", "position:absolute;top:250px;left:300px;z-index:100;display:inline;");
	};
	
	/**
	* 종료요청 버튼 클릭시 발생이벤트 
	*/
	var fnRequestSoldOut = function () {
	    
	    if($.trim($('#sold_out_desc').val())==''){
       	 	$('#dialogSelectRow').html('<p>종료요청시 사유는 필수 입니다..</p>');
			$("#dialogSelectRow").dialog();
       	    return false; 
       	}
	    
       	
		if(!confirm("입력하신 변경 종료 요청하시겠습니까?")) return;
       	
       	var rowid = $('#productInfo').getGridParam("selrow");
	    if(rowid == null) {
	  	   $("#productInfo").setSelection($("#productInfo").getDataIDs()[0]);
	  	   rowid = $('#productInfo').getGridParam("selrow");
	  	}
       	var rowData = jq('#productInfo').jqGrid('getRowData',rowid);
       	
       	var sumbitObj = new Object(); 
       	sumbitObj['good_iden_numb'] = rowData['good_iden_numb'];
		sumbitObj['vendorid'] 		= rowData['vendorid'];
		sumbitObj['applt_fix_code'] = '30';
		sumbitObj['apply_desc'] 	= $.trim($('#sold_out_desc').val()); 
		sumbitObj['price'] 			= '';
		
		$.post(
    		"<%=Constances.SYSTEM_CONTEXT_PATH %>/productManage/setFixGoodUnitPriceTrans.sys", 
    		sumbitObj,
    		function(arg){
    			if(  fnAjaxTransResult(arg)){
    			    fnAlterGridDataProValue('productInfo' , rowid ,'isfixappexists' ,'Y'); 
    			    fnAlterGridDataProValue('productInfo' , rowid ,'ischangesoldoutexists' ,'Y');
    			    $('#btnCloseSoldOut').click(); 
    			}
    		}
    	);
		
	};
	
</script>

<!-- -------------------------------------------------------------------------------------------------- -->
<!-- 이미지 처리 관련 Script 처리 시작  -->
<!-- -------------------------------------------------------------------------------------------------- -->
<!--------------------------- jQuery Fileupload --------------------------->
<script src="<%=Constances.SYSTEM_JSCSS_URL%>/jq/js/ajaxupload.3.5.js" type="text/javascript"></script>
<% /*------------------------------------Img File Upload 스크립트--------------------------------- */ %>
<script type="text/javascript">
$(function() {
   var btnUpload=$('#btnAttach');
   var status=$('#status');
   new AjaxUpload(btnUpload, {
      action:'<%=Constances.SYSTEM_CONTEXT_PATH%>/common/imageResizeProcess.sys',
      name:'imageFile',
      data:{},
      onSubmit:function(file,ext) {
          if(!(ext && /^(jpg|jpeg|gif)$/.test(ext))) {
              alert('이미지 파일(jpg,jpeg,gif) 파일만 등록 가능합니다.');
             //status.text("이미지 파일만 등록 가능합니다.");   // extension is not allowed
             return false;
          }
         if(!confirm("이미지를 등록하시겠습니까?")) {
            return false;
         }
         status.text('Uploading...');
      },
      onComplete: function(file,response) {
         status.text('');
         var result  = eval("(" +response + ")");
         
         var imgPathForORGIN = "<%=Constances.SYSTEM_IMAGE_PATH%>/"  + result.ORGIN;
         var imgPathForSMALL = "<%=Constances.SYSTEM_IMAGE_PATH%>/" + result.SMALL;
         var imgPathForMEDIUM = "<%=Constances.SYSTEM_IMAGE_PATH%>/" + result.MEDIUM;
         var imgPathForLARGE = "<%=Constances.SYSTEM_IMAGE_PATH%>/" + result.LARGE;
         

         // 이미지 변경  
         $('#SMALL').attr('src',imgPathForSMALL);
         $('#MEDIUM').attr('src',imgPathForMEDIUM);
         $('#LARGE').attr('src',imgPathForLARGE);
         
         // 경로 설정
         $('#original_img_path').val(result.ORGIN);
         $('#large_img_path ').val(result.LARGE);
         $('#middle_img_path').val(result.MEDIUM);
         $('#small_img_path ').val(result.SMALL);
         
         
         var msg = ""; 
         msg = '\n imgPathForORGIN  value['+imgPathForORGIN +']'; 
         msg = '\n imgPathForSMALL  value['+imgPathForSMALL +']'; 
         msg = '\n imgPathForMEDIUM value['+imgPathForMEDIUM+']'; 
         msg = '\n imgPathForLARGE  value['+imgPathForLARGE +']'; 
         msg = '\n '; 
         
         
         
         // 이미지 Grid 등록
         $('#original_img_path').change();
         $('#large_img_path ').change();
         $('#middle_img_path').change();
         $('#small_img_path ').change();
         
      }
   });
});

function attachDel() {
    // 이미지 변경
    $('#SMALL').attr('src','/img/system/imageResize/prod_img_50.gif');
    $('#MEDIUM').attr('src','/img/system/imageResize/prod_img_70.gif');
    $('#LARGE').attr('src','/img/system/imageResize/prod_img_100.gif');
    
    // 경로 설정
    $('#original_img_path').val('');
    $('#large_img_path').val('');
    $('#middle_img_path').val('');
    $('#small_img_path').val('');
    $('#original_img_path').focus();
    
    // 이미지 Grid 등록
    $('#original_img_path').change();
    $('#large_img_path ').change();
    $('#middle_img_path').change();
    $('#small_img_path ').change();
    
}
</script>
<!-- -------------------------------------------------------------------------------------------------- -->
<!-- 이미지 처리 관련 Script 처리 끝  -->
<!-- -------------------------------------------------------------------------------------------------- -->



<!-- -------------------------------------------------------------------------------------------------- -->
<!-- Function Start -->
<!-- -------------------------------------------------------------------------------------------------- -->
<script type="text/javascript">

    /**
     *  DataObject 를 기준으로 Property명에 찾아 동일한 Component 존재시 값을 바인드한다. 
     * @param gridData([Object()])      Object
     * @param preWord([복사된 컬럼 접두어]) String
     */
    var fnSetComponentValByGridDataObject = function(gridData,preWord){
        for(var propertyName in gridData){
            if(propertyName.indexOf(preWord) == -1 ) {
                if ($('#'+propertyName).exists()) {
                    $('#'+propertyName).val(gridData[propertyName]);
                }
            }
        }
    };

    /**
     * 해당 로우에 접두어에 해당하는 원본데이터 복사본을 생성한다. 
     * @param gridId([그리드 ObjectId])
     * @param rowId(해당 rowKey)
     * @param preWord(접두어) : 상품상세에서 제공되는 공급사 지정
     */
//     var fnCopyOrgRowData =  function(jqGridId, rowId , preWord ){
//         var dataSet =new Object();
        
//         for(var propertyName in jq("#"+jqGridId).jqGrid('getRowData',rowId)) {
//             if(propertyName.indexOf(preWord) == -1 ) {
                
//                 var  propertyValue = jq("#"+jqGridId).jqGrid('getRowData',rowId)[propertyName];
//                 var col =  preWord+propertyName; 
                
//                 dataSet[preWord+propertyName] = propertyValue;
//             }
//         }
//         $('#'+jqGridId).jqGrid('setRowData',rowId,dataSet);
//     };
    
    /**
     * 상품 설명 상세 변경에 따른 DataSet 반영 
     * @param contents([상세 설명])
     */
    var fnSetProductDescContents = function (gridId , contents) {
       var rowId = $("#"+gridId).getGridParam("selrow");
       if(rowId == null){
           return ; 
       }
       
       contents = escape(contents);
       
       $('#'+gridId).jqGrid('setRowData',rowId,{good_desc:contents});
    };
 
    
    /**
     * fnSetGridDataSet 
     * Component변화에 따른 GridDataSet 변경
     * @param obj([Object ])
     * @param e([Evnet])
     * @param gridId([GridDataSet Id])
     */
    var fnSetGridDataSet = function(obj,e,gridId){
        var rowId = $('#'+gridId).getGridParam("selrow");
        var colNm = $(obj).attr('id');
        var orgVal = jq("#"+gridId).jqGrid('getRowData',rowId)[colNm];
        var modVal = '';
        
//         if(e.target.type == 'text' || e.target.type == 'select-one' ){
            modVal = $(obj).val();
//         }else if (e.target.type == 'radio') {
//             colNm = $(obj).attr('name');
//             modVal = $("input[name='"+colNm+"']:checked").val();
//             orgVal = jq("#"+gridId).jqGrid('getRowData',rowId)[colNm];
//         }
        
        if($.trim(orgVal) != $.trim(modVal)){
            var dataSet = new Object();
            dataSet[colNm] = modVal;
            dataSet["isModify"] = "1";
            $('#'+gridId).jqGrid('setRowData',rowId,dataSet); 
        }
    };
    
    
    // NumberPormatOption 
    var numFormatType = new Array(
                {numType:'persent', option:{decimalSymbol: '.',digitGroupSymbol:'',dropDecimals:false,groupDigits:true,symbol:'',roundToDecimalPlace:2}},
                {numType:'number',  option:{decimalSymbol: '.',digitGroupSymbol:',',dropDecimals:false,groupDigits:true,symbol:'',roundToDecimalPlace:0}}
            );
    
    /**
     * 숫자 형테로 값을 포맷한다. 
     * @param obj([Object ])
     */
    var fnSetFormatCurrency = function(obj){
        var colNm = $(obj).attr('id');
        var altNm = $(obj).attr('alt');
        var modVal = '';
        
        for(var formatIdx = 0 ; formatIdx < numFormatType.length ; formatIdx++){
            if(numFormatType[formatIdx].numType == altNm){
                $(obj).formatCurrency(numFormatType[formatIdx].option);
            }
        }
    };
    
    /**
     *  
     * @param gridId([String]) 해당 그리드 id 
     * @param rowId([String])  해당 그리드 Key 
     * @param propNm([String]) DataObject Property Name
     * @param chnVal([String]) 변경될 값  
     */
    var fnAlterGridDataProValue = function(gridId , rowId , propNm , chnVal) {
		var rtn = false; 
		var dataSet = jq("#"+gridId).jqGrid('getRowData',rowId);
		dataSet['propNm'] = chnVal; 
		if($('#'+gridId).jqGrid('setRowData',rowId,dataSet))	rtn = true;  	 
		return rtn; 
    };
</script>
<!-- -------------------------------------------------------------------------------------------------- -->
<!-- Function End -->
<!-- -------------------------------------------------------------------------------------------------- -->
</head>
<body>
<div style='position:absolute;top:0;left:0;width:1050px;height:740px;overflow:auto;z-index:50' >
    <form id="frm" name="frm" method="post">
        <table width="100%" border="0" cellspacing="0" cellpadding="0" align="left">
            <tr>
                <td>
                    <!-- 타이틀 시작 -->
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr valign="top">
                            <td width="20" valign="middle">
                                <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_ptitle1.gif" style="width:14px;height:15px;" />
                            </td>
                            <td height="29" class="ptitle">공급사상품</td>
                        </tr>
                    </table>
                    <!-- 타이틀 끝 -->
                </td>
            </tr>
            <tr>
                <td>
                    <!-- 타이틀 시작 -->
                    <table width="100%" style="height:27px;" border="0" cellpadding="0" cellspacing="0">
                        <tr>
                            <td width="20" valign="top">
                                <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_stitle_blue.gif" style="width:5px;height:5px;" class="bullet_stitle" />
                            </td>
                            <td class="stitle">공급사상품상세정보</td>
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
                            <td colspan="6">
                                <div id="jqgrid" style="display:none;"> <!--  -->
                                    <table id="productInfo" ></table>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="6" class="table_top_line"></td>
                        </tr>
                        <tr>
                            <td colspan="6" height="1" bgcolor="eaeaea"></td>
                        </tr>
                        <tr>
                            <td class="table_td_subject" width="100">공급사</td>
                            <td class="table_td_contents">
                                <input id="vendornm" name="vendornm" type="text" value="" size="" maxlength="50" style="width:90%;" class="input_text_none" disabled="disabled" onchange="javascript:fnSetGridDataSet(this,event,'productInfo');" />
                                <input id="vendorid" name="vendorid" type="text" style="visibility:hidden;width:0px;" value="" onchange="javascript:fnSetGridDataSet(this,event,'productInfo');" />
                            </td>
                            <td class="table_td_subject" width="100">공급사코드</td>
                            <td class="table_td_contents">
                                <input id="vendorcd" name="vendorcd" type="text" value="" maxlength="20" style="width:90%;" class="input_text_none" disabled="disabled" onchange="javascript:fnSetGridDataSet(this,event,'productInfo');" />
                            </td>
                            <td class="table_td_subject" width="110">권역</td>
                            <td class="table_td_contents" width="150">
                                <select id="areatype" name="areatype" class="select_none" disabled="disabled" onchange="javascript:fnSetGridDataSet(this,event,'productInfo');"> 
                                    <option value="">선택</option>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="6" height="1" bgcolor="eaeaea"></td>
                        </tr>
                        <tr>
                            <td class="table_td_subject">대표자</td>
                            <td class="table_td_contents">
                                <input id="pressentnm" name="pressentnm" type="text" value="" maxlength="50" style="width:90%;" class="input_text_none" disabled="disabled" onchange="javascript:fnSetGridDataSet(this,event,'productInfo');" />
                            </td>
                            <td class="table_td_subject">연락처</td>
                            <td class="table_td_contents" >
                                <input id="phonenum" name="phonenum" type="text" value="" maxlength="20" style="width:90%;" class="input_text_none" disabled="disabled" onchange="javascript:fnSetGridDataSet(this,event,'productInfo');" />
                            </td>
                            <td class="table_td_subject" width="100">상품코드</td>
                            <td class="table_td_contents">
                                <input id="good_iden_numb" name="good_iden_numb" type="text" value="" maxlength="50" style="width:90%;"  class="input_text_none" disabled="disabled" />
                            </td>
                        </tr>
                        <tr>
                            <td colspan="6" height="1" bgcolor="eaeaea"></td>
                        </tr>
                        <tr>
                            <td class="table_td_subject">카테고리</td>
                            <td class="table_td_contents" colspan="5">
                                <input id="full_cate_name" name="full_cate_name" type="text" value=""  style="width:90%;"  class="input_text_none" disabled="disabled" />
                            </td>
                        </tr>
                        
                        <tr>
                            <td colspan="6" height="1" bgcolor="eaeaea"></td>
                        </tr>
                        <tr>
                            <td class="table_td_subject">상품명</td>
                            <td class="table_td_contents">
                                <input id="good_name" name="good_name" type="text" maxlength="50" style="width:90%;" class="input_text_none" disabled="disabled" onchange="javascript:fnSetGridDataSet(this,event,'productInfo');" />
                            </td>
                            <td class="table_td_subject9" width="100">단가</td>
                            <td colspan="3" class="table_td_contents">
                                <input id="sale_unit_pric" name="sale_unit_pric" alt='number' type="text" value="" size="8" maxlength="18" style="text-align:right;" class="input_text_none" disabled="disabled" onchange="javascript:fnSetGridDataSet(this,event,'productInfo');" onblur="javascript:fnSetFormatCurrency(this);" onkeydown="return onlyNumber(event);" />
                                <input id="authMode" name="authMode" type="hidden"/>&nbsp;
                                <img id="btnAlterPrice" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type2_priceChange.gif" width="62" height="18" style="cursor:pointer;vertical-align:middle;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>"/>
                                <img id="btnSoldOut"    src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type2_discontinue2.gif" width="62" height="18" style="cursor:pointer;vertical-align: middle;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>"/>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="6" height="1" bgcolor="eaeaea"></td>
                        </tr>
                        <tr>
                            <td class="table_td_subject">상품규격</td>
                            <td colspan="5" class="table_td_contents">&nbsp;&nbsp;
                                Ø <input id="good_st_spec_desc1" name="good_st_spec_desc1" type="text" value="" size="5" maxlength="20" style="text-align:right;" onchange="javascript:fnSetGridDataSet(this,event,'productInfo');" />
                                W <input id="good_st_spec_desc2" name="good_st_spec_desc2" type="text" value="" size="5" maxlength="20" style="text-align:right;" onchange="javascript:fnSetGridDataSet(this,event,'productInfo');" />
                                D <input id="good_st_spec_desc3" name="good_st_spec_desc3" type="text" value="" size="5" maxlength="20" style="text-align:right;" onchange="javascript:fnSetGridDataSet(this,event,'productInfo');" />
                                H <input id="good_st_spec_desc4" name="good_st_spec_desc4" type="text" value="" size="5" maxlength="20" style="text-align:right;" onchange="javascript:fnSetGridDataSet(this,event,'productInfo');" />
                                L <input id="good_st_spec_desc5" name="good_st_spec_desc5" type="text" value="" size="5" maxlength="20" style="text-align:right;" onchange="javascript:fnSetGridDataSet(this,event,'productInfo');" />
                                t <input id="good_st_spec_desc6" name="good_st_spec_desc6" type="text" value="" size="5" maxlength="20" style="text-align:right;" onchange="javascript:fnSetGridDataSet(this,event,'productInfo');" /><br />
                                규격 <input id="good_spec_desc1" name="good_spec_desc1" type="text" value="" size="50" maxlength="20" style="text-align:right;" onchange="javascript:fnSetGridDataSet(this,event,'productInfo');" />
                                재질 <input id="good_spec_desc2" name="good_spec_desc2" type="text" value="" size="5" maxlength="20" style="text-align:right;" onchange="javascript:fnSetGridDataSet(this,event,'productInfo');" />
                                크기 <input id="good_spec_desc3" name="good_spec_desc3" type="text" value="" size="5" maxlength="20" style="text-align:right;" onchange="javascript:fnSetGridDataSet(this,event,'productInfo');" />
                                총중량(할증포함) <input id="good_spec_desc4" name="good_spec_desc4" type="text" value="" size="5" maxlength="20" style="text-align:right;" onchange="javascript:fnSetGridDataSet(this,event,'productInfo');" />
                                색상 <input id="good_spec_desc5" name="good_spec_desc5" type="text" value="" size="5" maxlength="20" style="text-align:right;" onchange="javascript:fnSetGridDataSet(this,event,'productInfo');" />
                                TYPE <input id="good_spec_desc6" name="good_spec_desc6" type="text" value="" size="5" maxlength="20" style="text-align:right;" onchange="javascript:fnSetGridDataSet(this,event,'productInfo');" />
                                실중량kg <input id="good_spec_desc7" name="good_spec_desc7" type="text" value="" size="5" maxlength="20" style="text-align:right;" onchange="javascript:fnSetGridDataSet(this,event,'productInfo');" />
                                M(미터) <input id="good_spec_desc8" name="good_spec_desc8" type="text" value="" size="5" maxlength="20" style="text-align:right;" onchange="javascript:fnSetGridDataSet(this,event,'productInfo');" />
                            </td>
                        </tr>
                        <tr>
                            <td colspan="6" height="1" bgcolor="eaeaea"></td>
                        </tr>
                        <tr>
                            <td class="table_td_subject" width="100">제조사</td>
                            <td class="table_td_contents">
                                <input id="make_comp_name" name="make_comp_name" type="text" value="" size="" maxlength="50" onchange="javascript:fnSetGridDataSet(this,event,'productInfo');" />
                            </td>
                            <td class="table_td_subject9" width="100">상품구분</td>
                            <td class="table_td_contents">
                                <select id="good_clas_code" name="good_clas_code" class="select" onchange="javascript:fnSetGridDataSet(this,event,'productInfo');" disabled="disabled"></select>
                            </td>
                            <td class="table_td_subject" width="100">재고수량</td>
                            <td class="table_td_contents">
                                <input id="good_inventory_cnt" name="good_inventory_cnt" alt='number' type="text" value="" size="9" maxlength="7" style="text-align:right;" onchange="javascript:fnSetGridDataSet(this,event,'productInfo');"
                                    onblur="javascript:fnSetFormatCurrency(this);" onkeydown="return onlyNumber(event);" />
                            </td>
                        </tr>
                        <tr>
                            <td colspan="6" height="1" bgcolor="eaeaea"></td>
                        </tr>

                        <tr>
                            <td class="table_td_subject9">주문단위</td>
                            <td class="table_td_contents">
                                <select id="orde_clas_code" name="orde_clas_code" class="select" onchange="javascript:fnSetGridDataSet(this,event,'productInfo');">
                                    <option value="">선택</option>
                                </select>
                            </td>
                            <td class="table_td_subject9">최소구매수량</td>
                            <td class="table_td_contents">
                                <input id="deli_mini_quan" name="deli_mini_quan" alt='number' type="text" value="" size="5" maxlength="4" style="text-align:right;" onchange="javascript:fnSetGridDataSet(this,event,'productInfo');"
                                    onblur="javascript:fnSetFormatCurrency(this);" onkeydown="return onlyNumber(event);" />
                            </td>
                            <td class="table_td_subject9">납품소요일</td>
                            <td class="table_td_contents">
                                <input id="deli_mini_day" name="deli_mini_day" alt='number' type="text" value="" size="4" maxlength="2" style="text-align:right;" onchange="javascript:fnSetGridDataSet(this,event,'productInfo');"
                                    onblur="javascript:fnSetFormatCurrency(this);" onkeydown="return onlyNumber(event);" disabled="disabled"/>일
                            </td>
                        </tr>
                        <tr>
                            <td class="table_td_subject">당일발송</td>
                            <td class="table_td_contents">
                                <select id="the_day_post" name="the_day_post" onchange="javascript:fnSetGridDataSet(this,event,'productInfo');">
                                    <option value="0">아니오</option>
                                    <option value="1">예</option>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="6" height="1" bgcolor="eaeaea"></td>
                        </tr>
                        <tr>
                            <td class="table_td_subject">상품이미지</td>
                            <td class="table_td_contents">
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                    <tr>
                                        <td height="25">
                                            <input id="original_img_path" name="original_img_path" type="text" value="" style="width:90%;" class="input_text_none" disabled="disabled" onchange="javascript:fnSetGridDataSet(this,event,'productInfo');" />
                                            <input id="large_img_path" name="large_img_path" type="text" style="display:none;" value="" onchange="javascript:fnSetGridDataSet(this,event,'productInfo');" />
                                            <input id="middle_img_path" name="middle_img_path" type="text" style="display:none;" value=""onchange="javascript:fnSetGridDataSet(this,event,'productInfo');" /> 
                                            <input id="small_img_path" name="small_img_path" type="text" style="display:none;" value="" onchange="javascript:fnSetGridDataSet(this,event,'productInfo');" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2" height="25">
                                            <img id="btnAttach" name="btnAttach" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type2_imageOK.gif" style="width:75px;height:18px;cursor:pointer;" />
                                            <img id="btnAttachDel" name="btnAttachDel" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type2_imageDelete.gif" style="width:75px;height:18px;cursor:pointer;" />
                                        </td>
                                    </tr>
                                </table>
                            </td>
                            <td class="table_td_subject" >대표상품이미지</td>
                            <td colspan="3" class="table_td_contents4">
                                <table>
                                    <tr>
                                        <td valign="bottom">
                                            SMALL<br />
                                            <img id="SMALL" src="/img/system/imageResize/prod_img_50.gif" alt="SMALL" style="border:0px;" />
                                        </td>
                                        <td valign="bottom">
                                            MEDIUM<br />
                                            <img id="MEDIUM" src="/img/system/imageResize/prod_img_70.gif" alt="MEDIUM" style="border:0px;" />
                                        </td>
                                        <td valign="bottom">
                                            LARGE<br />
                                            <img id="LARGE" src="/img/system/imageResize/prod_img_100.gif" alt="LARGE" style="border:0px;" />

                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="6" height="1" bgcolor="eaeaea"></td>
                        </tr>
                        <tr>
                            <td class="table_td_subject">상품설명</td>
                            <td colspan="5" class="table_td_contents">
                                <%@ include file="/daumeditor/editorbox.jsp"%> 
                                <textarea name="textarea" id="textarea" cols="45" rows="10" style="width:730px;height:50px;display:none;"></textarea>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="6" height="1" bgcolor="eaeaea"></td>
                        </tr>
                        <tr>
                            <td class="table_td_subject">상품 동의어</td>
                            <td colspan="5" class="table_td_contents">
                                <table width="98%" border="0" cellspacing="0" cellpadding="0">
                                    <tr>
                                        <td>
                                            <input id="good_same_word1" name="good_same_word1" type="text" value="" size="20" maxlength="20" style="width:95%;" onchange="javascript:fnSetGridDataSet(this,event,'productInfo');" />
                                        </td>
                                        <td>
                                            <input id="good_same_word2" name="good_same_word2" type="text" value="" size="20" maxlength="20" style="width:95%;" onchange="javascript:fnSetGridDataSet(this,event,'productInfo');" />
                                        </td>
                                        <td>
                                            <input id="good_same_word3" name="good_same_word3" type="text" value="" size="20" maxlength="20" style="width:95%;" onchange="javascript:fnSetGridDataSet(this,event,'productInfo');" />
                                        </td>
                                        <td>
                                            <input id="good_same_word4" name="good_same_word4" type="text" value="" size="20" maxlength="20" style="width:95%;" onchange="javascript:fnSetGridDataSet(this,event,'productInfo');" />
                                        </td>
                                        <td>
                                            <input id="good_same_word5" name="good_same_word5" type="text" value="" size="20" maxlength="20" style="width:95%;" onchange="javascript:fnSetGridDataSet(this,event,'productInfo');" />
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="6" height="1" bgcolor="eaeaea"></td>
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
                <td align="center">
                    <img id='btnVenSave'        src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type5_save.gif"        style="width:65px;height:23px;cursor:pointer;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>" /> 
                    <img id='btnCommonClose'    src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type5_close.gif"       style="width:65px;height:23px;cursor:pointer;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>" />
                </td>
            </tr>
        </table>
        <!-------------------------------- Dialog Div Start -------------------------------->
        <!-------------------------------- Dialog Div End -------------------------------->
        <textarea id="tx_load_content" cols="20" rows="2" style="display:none;"></textarea> 
        <div id="dialogSelectRow" title="Warning" style="display:none;font-size:12px;color:red;">
            <p></p>
        </div>
        <div id="dialog" title="Feature not supported" style="display:none;">
            <p></p>
        </div>
    </form>
</div>
<div id="divReqChangePrice" style="position:absolute;top:250px;left:300px;z-index:100;display:none;">
    <table width="450" border="0" cellspacing="0" cellpadding="0">
        <tr>
            <td>
                <table width="100%" border="0" cellpadding="0" cellspacing="0">
                    <tr>
                        <td width="20" height="20">
                            <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_1.gif" width="20" height="20" />
                        </td>
                        <td style="background-image:url(<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_1.gif);" >&nbsp;</td>
                        <td width="20">
                            <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_2.gif" width="20" height="20"/>
                        </td>
                    </tr>
                    <tr>
                        <td style="background-image:url(<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_4.gif);"   >&nbsp;</td>
                        <td bgcolor="#FFFFFF">
                            <table width="100%" cellpadding="0" cellspacing="0" style="height:27px; border: 0;">
                                <tr>
                                    <td width="20" valign="top">
                                        <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_stitle_blue.gif" width="5" height="5" class="bullet_stitle"/>
                                    </td>
                                    <td class="stitle">단가 변경 요청</td>
                                </tr>
                            </table>
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                    <td colspan="2" class="table_top_line"></td>
                                </tr>
                                <tr>
                                    <td colspan="2" height='1'></td>
                                </tr>
                                <tr>
                                    <td width="90" class="table_td_subject">기존 단가</td>
                                    <td class="table_td_contents">
                                        <input id="org_sale_unit_pric" name="org_sale_unit_pric" alt='number' type="text" value="" size="7" maxlength="18" disabled="disabled" style="text-align:right;background-color:#eaeaea;" onblur="javascript:fnSetFormatCurrency(this);" /> </br>
                                    </td>
                                </tr>
                                <tr style="height:1px;" >
                                    <td></td>
                                    <td bgcolor="#EAEAEA"></td>
                                </tr>
                                <tr>
                                    <td width="70" class="table_td_subject">변경 단가</td>
                                    <td class="table_td_contents">
                                        <input id="price" name="price" alt='number' type="text" value="" size="7" maxlength="18" style="text-align:right;" onchange="javascript:fnSetGridDataSet(this,event,'productInfo');" onblur="javascript:fnSetFormatCurrency(this);" onkeydown="return onlyNumber(event);" /> </br>
                                    </td>
                                </tr>
                                <tr style="height:1px;" >
                                    <td></td>
                                    <td bgcolor="#EAEAEA"></td>
                                </tr>
                                <tr>
                                    <td width="70" class="table_td_subject">변경 사유</td>
                                    <td class="table_td_contents">
                                        <input id="apply_desc" name="apply_desc" type="text" style="width:250px;width:98%;" maxlength="100"/>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2" height="2" style="background-image:url(<%=Constances.SYSTEM_IMAGE_URL%>/img/system/table_bottom_line.gif);"></td>
                                </tr>
                            </table>
                            <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/blank.gif" width='100%' class="space" />
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                    <td align="center">
                                        <img id="btnReqestChangePrice" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type3_request.gif" width="65" height="22" border="0" style="cursor:pointer;"/>
                                        <img id="btnCloseChangePrice" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type3_cancel2.gif" width="65" height="22" border="0" style="cursor:pointer;" onclick="javascript: $('#divReqChangePrice').attr('style', 'display:none;');"/>
                                    </td>
                                </tr>
                            </table>
                        </td>
                        <td style="background-image:url(<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_2.gif);" >&nbsp;</td>
                    </tr>
                    <tr>
                        <td>
                            <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_4.gif" width="20" height="20"/>
                        </td>
                        <td style="background-image:url( <%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_3.gif);" >&nbsp;</td>
                        <td height="20">
                            <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_3.gif" width="20" height="20"/>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
</div>
<div id="divSoldOut" style="position:absolute;top:250px;left:300px;z-index:100;display:none;">
    <table width="450" border="0" cellspacing="0" cellpadding="0">
        <tr>
            <td>
                <table width="100%" border="0" cellpadding="0" cellspacing="0">
                    <tr>
                        <td width="20" height="20">
                            <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_1.gif" width="20" height="20"/>
                        </td>
                        <td style="background-image:url(<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_1.gif);" >&nbsp;</td>
                        <td width="20">
                            <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_2.gif" width="20" height="20"/>
                        </td>
                    </tr>
                    <tr>
                        <td style="background-image:url(<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_4.gif);"   >&nbsp;</td>
                        <td bgcolor="#FFFFFF">
                            <table width="100%" height="27" border="0" cellpadding="0" cellspacing="0">
                                <tr>
                                    <td width="20" valign="top">
                                        <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_stitle_blue.gif" width="5" height="5" class="bullet_stitle"/>
                                    </td>
                                    <td class="stitle">종료 요청</td>
                                </tr>
                            </table>
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                    <td colspan="2" class="table_top_line"></td>
                                </tr>
                                <tr>
                                    <td colspan="2" height='1'></td>
                                </tr>
                                <tr>
                                    <td width="90" class="table_td_subject">종료 요청사유</td>
                                    <td class="table_td_contents">
                                        <input id="sold_out_desc" name="sold_out_desc" type="text" style="width:250px;width:98%;" maxlength="100"/>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2" height="2" style="background-image:url(<%=Constances.SYSTEM_IMAGE_URL%>/img/system/table_bottom_line.gif);"  ></td>
                                </tr>
                            </table>
                            <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/blank.gif" width='100%' class="space"/>
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                    <td align="center">
                                        <img id="btnReqSoldOut" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type3_request.gif" width="65" height="22" border="0" style="cursor:pointer;"/>
                                        <img id="btnCloseSoldOut" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type3_cancel2.gif" width="65" height="22" border="0" style="cursor:pointer;" onclick="javascript: $('#divSoldOut').attr('style', 'display:none;');"/>
                                    </td>
                                </tr>
                            </table>
                        </td>
                        <td style="background-image:url(<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_2.gif);" >&nbsp;</td>
                    </tr>
                    <tr>
                        <td>
                            <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_4.gif" width="20" height="20"/>
                        </td>
                        <td style="background-image:url( <%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_3.gif);" >&nbsp;</td>
                        <td height="20">
                            <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_3.gif" width="20" height="20"/>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
</div>
</body>
</html>