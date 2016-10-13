    /**
     *  DataObject 를 기준으로 Property명에 찾아 동일한 Component 존재시 값을 바인드한다. 
     * @param gridData([Object()])      Object
     * @param preWord([복사된 컬럼 접두어]) String
     */
    var FNSetComponentValByGridDataObject = function(gridData){
        for(var propertyName in gridData){
//            jQuery('#'+propertyName).val(gridData[propertyName].toUpperCase());
            jQuery('#'+propertyName).val(gridData[propertyName]);
        }
    };

    /**
     * 해당 로우에 접두어에 해당하는 원본데이터 복사본을 생성한다. 
     * @param gridId([그리드 ObjectId])
     * @param rowId(해당 rowKey)
     * @param preWord(접두어) : 상품상세에서 제공되는 공급사 지정
     */
    var FNCopyOrgRowData =  function(jqGridId, rowId , preWord ){
        var dataSet =new Object();
        
        for(var propertyName in jQuery("#"+jqGridId).jqGrid('getRowData',rowId)) {
            if(propertyName.indexOf(preWord) == -1 ) {
                var propertyValue = jQuery("#"+jqGridId).jqGrid('getRowData',rowId)[propertyName];
                var cpPropertyName =  preWord+propertyName;
                dataSet[cpPropertyName] = propertyValue;
            }
        }
        jQuery('#'+jqGridId).jqGrid('setRowData',rowId,dataSet);
    };
    
    /**
     *  해다 그리드 데이터를 propery Name 에 해당하는 Value 를 추출한
     * @param gridId([String]) 해당 그리드 id 
     * @param rowId([String])  해당 그리드 Key 
     * @param propNm([String]) DataObject Property Name
     */
    var FNgetGridDataObj = function(gridId , rowId , propNm ) {
        var rtn = ''; 
        var dataSet = jQuery("#"+gridId).jqGrid('getRowData',rowId);
         
        if(dataSet[propNm] == undefined)    rtn = '';   
        else                                rtn = dataSet[propNm];
            
        return rtn; 
    };
    
    /**
     *  
     * @param gridId([String]) 해당 그리드 id 
     * @param rowId([String])  해당 그리드 Key 
     * @param propNm([String]) DataObject Property Name
     * @param chnVal([String]) 변경될 값  
     */
    var FNAlterGridDataProValue = function(gridId , rowId , propNm , chnVal) {
        var rtn = false; 
        var dataSet = jQuery("#"+gridId).jqGrid('getRowData',rowId);
        dataSet[propNm] = chnVal; 
        if(jQuery('#'+gridId).jqGrid('setRowData',rowId,dataSet))    rtn = true;      
        return rtn; 
    };