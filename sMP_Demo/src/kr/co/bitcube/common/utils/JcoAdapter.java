package kr.co.bitcube.common.utils;

import java.io.File;
import java.io.FileOutputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.Random;

import com.sap.conn.jco.AbapException;
import com.sap.conn.jco.JCoDestination;
import com.sap.conn.jco.JCoDestinationManager;
import com.sap.conn.jco.JCoException;
import com.sap.conn.jco.JCoFieldIterator;
import com.sap.conn.jco.JCoFunction;
import com.sap.conn.jco.JCoParameterList;
import com.sap.conn.jco.JCoStructure;
import com.sap.conn.jco.JCoTable;
import com.sap.conn.jco.ext.DestinationDataProvider;

public class JcoAdapter {

	private String ABAP_AS = "JCoDestination";
	private String returnType = "S";
	private String returnMessage = "";
	public String getReturnType() {
		return this.returnType;
	}
	public String getReturnMessage() {
		return this.returnMessage;
	}
	
	public JcoAdapter() {
		Properties connectProperties = new Properties();
		
		connectProperties.setProperty(DestinationDataProvider.JCO_ASHOST, 			Constances.SAP_JCO_ASHOST);
		connectProperties.setProperty(DestinationDataProvider.JCO_SYSNR, 			Constances.SAP_JCO_SYSNR);
		connectProperties.setProperty(DestinationDataProvider.JCO_CLIENT, 			Constances.SAP_JCO_CLIENT);
		connectProperties.setProperty(DestinationDataProvider.JCO_USER, 			Constances.SAP_JCO_USER);
		connectProperties.setProperty(DestinationDataProvider.JCO_PASSWD, 			Constances.SAP_JCO_PASSWD);
		connectProperties.setProperty(DestinationDataProvider.JCO_LANG, 			Constances.SAP_JCO_LANG);
		connectProperties.setProperty(DestinationDataProvider.JCO_POOL_CAPACITY, 	Constances.SAP_JCO_POOL_CAPACITY);
		connectProperties.setProperty(DestinationDataProvider.JCO_PEAK_LIMIT, 		Constances.SAP_JCO_PEAK_LIMIT);
	
//		TEST
//		sap.jco_ashost = 219.252.78.241
//		sap.jco_sysnr = 00
//		sap.jco_client = 200
//		sap.jco_user = RFCFIMNM
//		sap.jco_passwd = 20090901
//		sap.jco_lang = ko
//		sap.jco_pool_capacity = 3
//		sap.jco_peak_limit = 10
		
//		REAL
//		sap.jco_ashost = 219.252.78.240
//		sap.jco_sysnr = 00
//		sap.jco_client = 100
//		sap.jco_user = RFCFIMNM
//		sap.jco_passwd = 20090901
//		sap.jco_lang = ko
//		sap.jco_pool_capacity = 3
//		sap.jco_peak_limit = 10 
		
//		connectProperties.setProperty(DestinationDataProvider.JCO_ASHOST, 			"219.252.78.240");
//		connectProperties.setProperty(DestinationDataProvider.JCO_SYSNR, 			"00");
//		connectProperties.setProperty(DestinationDataProvider.JCO_CLIENT, 			"100");
//		connectProperties.setProperty(DestinationDataProvider.JCO_USER, 			"RFCFIMNM");
//		connectProperties.setProperty(DestinationDataProvider.JCO_PASSWD, 			"20090901");
//		connectProperties.setProperty(DestinationDataProvider.JCO_LANG, 			"ko");
//		connectProperties.setProperty(DestinationDataProvider.JCO_POOL_CAPACITY, 	"3");
//		connectProperties.setProperty(DestinationDataProvider.JCO_PEAK_LIMIT, 		"10");		
//		createDestinationDataFile(ABAP_AS, connectProperties);
	}
	
	public void createDestinationDataFile(
			String destinationName, Properties connectProperties)	{
		
		File destCfg = new File(destinationName+".jcoDestination");
		if(!destCfg.exists()) {
			
			try {
				FileOutputStream fos = new FileOutputStream(destCfg, false);
				connectProperties.store(fos, "JCO Properties");
				fos.close();
			} catch (Exception e) {
				throw new RuntimeException("Unable to create the destination files", e);
			} finally {
			}
		}
	}
	

	/**
	 * Return 이 테이블의 리스트만 있을 경우
	 * @param callFn
	 * @param param
	 * @param rtnTable
	 * @return
	 * @throws JCoException
	 */
    public List<Map<String, Object>> callRfc(
    		String callFn, Map<String, Object> param, String rtnTable) throws JCoException {
    	
    	List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
    	JCoDestination destination = JCoDestinationManager.getDestination(ABAP_AS);
    	JCoFunction function = destination.getRepository().getFunction(callFn);
    	if(function == null)
    		throw new RuntimeException(callFn + " not found in SAP.");
    	
		Iterator<String> paramItor = param.keySet().iterator();
		while (paramItor.hasNext()) {
			String paramKey = paramItor.next();
			function.getImportParameterList().setValue(paramKey, param.get(paramKey));
		}
    	try {
    		function.execute(destination);
            JCoTable codes = function.getTableParameterList().getTable(rtnTable);
            for (int i = 0; i < codes.getNumRows(); i++) {
                codes.setRow(i);
                Map<String, Object> map = new HashMap<String, Object>();
                map.put("ROWNO", i+1);
                for (int j = 0; j < codes.getMetaData().getFieldCount(); j++) {
                	map.put(codes.getMetaData().getName(j), codes.getString(codes.getMetaData().getName(j)).trim());
                }
                list.add(map);
            }
            return list;
    	}
    	catch(AbapException e) {
    		returnType = "E";
    		returnMessage = "";
    		return list;
    	}
    }

	/**
	 * Return 이 테이블의 리스트만 있을 경우
	 * @param callFn
	 * @param param
	 * @param rtnTable1
	 * @param rtnTable2
	 * @return
	 * @throws JCoException
	 */
    public List<Map<String, Object>> callRfcTableParam(
    		String callFn, Map<String, Object> param, String rtnTable1, String rtnTable2) throws JCoException {
    	
    	List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
    	JCoDestination destination = JCoDestinationManager.getDestination(ABAP_AS);
    	JCoFunction function = destination.getRepository().getFunction(callFn);
    	if(function == null)
    		throw new RuntimeException(callFn + " not found in SAP.");

    	JCoTable jcoTable1 = function.getTableParameterList().getTable(rtnTable1);
    	JCoTable jcoTable2 = function.getTableParameterList().getTable(rtnTable2);
    	if(jcoTable1 == null)
    		throw new RuntimeException(rtnTable1 + " not found in SAP.");
    	if(jcoTable2 == null)
    		throw new RuntimeException(rtnTable2 + " not found in SAP.");
    	
    	jcoTable1.appendRow();
    	jcoTable2.appendRow();
    	
    	Iterator<String> paramItor = param.keySet().iterator();

    	JCoFieldIterator jcoIter = jcoTable2.getFieldIterator();

    	while (paramItor.hasNext()) {
    		String paramKey = paramItor.next();
    		
    		jcoTable1.setValue(paramKey, param.get(paramKey));

        	while(jcoIter.hasNextField()){
        		if(jcoIter.nextField().getName().equals(paramKey)){
        			jcoTable2.setValue(paramKey, param.get(paramKey));
        		}
        	}
    	}
    	try {
    		function.execute(destination);
            JCoTable codes1 = function.getTableParameterList().getTable(rtnTable1);
            for (int i = 0; i < codes1.getNumRows(); i++) {
                codes1.setRow(i);
                Map<String, Object> map = new HashMap<String, Object>();
                map.put("ROWNO", i+1);
                for (int j = 0; j < codes1.getMetaData().getFieldCount(); j++) {
                	map.put(codes1.getMetaData().getName(j), codes1.getString(codes1.getMetaData().getName(j)).trim());
                }
                list.add(map);
            }

            JCoTable codes2 = function.getTableParameterList().getTable(rtnTable2);
            for (int i = 0; i < codes2.getNumRows(); i++) {
            	codes2.setRow(i);
            	Map<String, Object> map = new HashMap<String, Object>();
            	map.put("ROWNO", i+1);
            	for (int j = 0; j < codes2.getMetaData().getFieldCount(); j++) {
            		map.put(codes2.getMetaData().getName(j), codes2.getString(codes2.getMetaData().getName(j)).trim());
            	}
            	list.add(map);
            }
            
            return list;
    	}
    	catch(AbapException e) {
    		returnType = "E";
    		returnMessage = "";
    		return list;
    	}
    }
    
    /**
     * Return 이 테이블의 리스트만 있을 경우
     * @param callFn
     * @param param
     * @param rtnTable
     * @return
     * @throws JCoException
     */
    public List<Map<String, Object>> callRfcTableParam(
    		String callFn, Map<String, Object> param, String rtnTable) throws JCoException {
    	
    	List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
    	JCoDestination destination = JCoDestinationManager.getDestination(ABAP_AS);
    	JCoFunction function = destination.getRepository().getFunction(callFn);
    	if(function == null)
    		throw new RuntimeException(callFn + " not found in SAP.");
    	
    	JCoTable jcoTable = function.getTableParameterList().getTable(rtnTable);
    	if(jcoTable == null)
    		throw new RuntimeException(rtnTable + " not found in SAP.");
    	
    	jcoTable.appendRow();
    	Iterator<String> paramItor = param.keySet().iterator();
    	while (paramItor.hasNext()) {
    		String paramKey = paramItor.next();
    		jcoTable.setValue(paramKey, param.get(paramKey));
    	}
    	try {
    		function.execute(destination);
    		JCoTable codes = function.getTableParameterList().getTable(rtnTable);
    		for (int i = 0; i < codes.getNumRows(); i++) {
    			codes.setRow(i);
    			Map<String, Object> map = new HashMap<String, Object>();
    			map.put("ROWNO", i+1);
    			for (int j = 0; j < codes.getMetaData().getFieldCount(); j++) {
    				map.put(codes.getMetaData().getName(j), codes.getString(codes.getMetaData().getName(j)).trim());
    			}
    			list.add(map);
    		}
    		return list;
    	}
    	catch(AbapException e) {
    		returnType = "E";
    		returnMessage = "";
    		return list;
    	}
    }
    
	/**
	 * Return 이 Type과 메시지 와 테이블의 리스트가 있을 경우
	 * @param callFn
	 * @param param
	 * @param rtnTable
	 * @return
	 * @throws JCoException
	 */
    public List<Map<String, Object>> callRfcTypeNTable(
    		String callFn, Map<String, Object> param, String rtnTable) throws JCoException {
    	
    	List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
    	JCoDestination destination = JCoDestinationManager.getDestination(ABAP_AS);
    	JCoFunction function = destination.getRepository().getFunction(callFn);
    	if(function == null)
    		throw new RuntimeException(callFn + " not found in SAP.");
    	
		Iterator<String> paramItor = param.keySet().iterator();
		while (paramItor.hasNext()) {
			String paramKey = paramItor.next();
			function.getImportParameterList().setValue(paramKey, param.get(paramKey));
		}
    	try {
    		function.execute(destination);
//    		JCoStructure ret = function.getExportParameterList().getStructure("E_RETURN");
//			returnType = ret.getString("TYPE");
//			returnMessage = ret.getString("MESSAGE");
            JCoTable codes = function.getTableParameterList().getTable(rtnTable);
            for (int i = 0; i < codes.getNumRows(); i++) {
                codes.setRow(i);
                Map<String, Object> map = new HashMap<String, Object>();
                map.put("ROWNO", i+1);
                for (int j = 0; j < codes.getMetaData().getFieldCount(); j++) {
                	map.put(codes.getMetaData().getName(j), codes.getString(codes.getMetaData().getName(j)).trim());
                }
                list.add(map);
            }
            return list;
    	}
    	catch(AbapException e) {
    		returnType = "E";
    		returnMessage = "";
    		return list;
    	}
    }
    
	/**
	 * Return이 메시지 와 테이블의 리스트가 있을 경우
	 * @param callFn
	 * @param param
	 * @param rtnTable
	 * @return
	 * @throws JCoException
	 */
    public List<Map<String, Object>> callRfcTypeNTable(
    		String callFn, Map<String, Object> param, String rtnTable, String rtnName) throws JCoException {
    	
    	List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
    	JCoDestination destination = JCoDestinationManager.getDestination(ABAP_AS);
    	JCoFunction function = destination.getRepository().getFunction(callFn);
    	if(function == null)
    		throw new RuntimeException(callFn + " not found in SAP.");
    	
		Iterator<String> paramItor = param.keySet().iterator();
		while (paramItor.hasNext()) {
			String paramKey = paramItor.next();
			function.getImportParameterList().setValue(paramKey, param.get(paramKey));
		}
    	try {
    		returnMessage = "";
    		function.execute(destination);
    		JCoParameterList outParam = function.getExportParameterList();
    		returnMessage = (String) outParam.getValue(rtnName);
            JCoTable codes = function.getTableParameterList().getTable(rtnTable);
            for (int i = 0; i < codes.getNumRows(); i++) {
                codes.setRow(i);
                Map<String, Object> map = new HashMap<String, Object>();
                map.put("ROWNO", i+1);
                for (int j = 0; j < codes.getMetaData().getFieldCount(); j++) {
                	map.put(codes.getMetaData().getName(j), codes.getString(codes.getMetaData().getName(j)).trim());
                }
                list.add(map);
            }
            return list;
    	}
    	catch(AbapException e) {
    		returnType = "E";
    		returnMessage = "";
    		return list;
    	}
    }
    
    /**
     * param 과 table를 import로 던져 그 결과를 받아오는 메소드
     * 
     * @author tytolee
     * @param callFn
     * @param param
     * @param importTableInfo
     * @return String
     * @throws Exception
     * @since 2012-04-24
     */
    public String callRfcTypeNTable(String callFn, Map<String, Object> param, Map<String, List<Map<String, Object>>> importTableInfo) throws Exception {
    	JCoDestination destination = null;
    	JCoFunction    function    = null;
    	JCoStructure   ret         = null;
    	
    	destination = JCoDestinationManager.getDestination(ABAP_AS);
    	function = destination.getRepository().getFunction(callFn);
    	
    	if(function == null){
    		throw new RuntimeException(callFn + " not found in SAP.");
    	}
    	
    	function = this.setParamFunction(param, function);                     // 조회 파라미터 값을 function에 설정
    	function = this.setImportTableInfoFunction(importTableInfo, function); // 조회 테이블 정보 설정
    	
    	try {
    		function.execute(destination);
    		
    		ret           = function.getExportParameterList().getStructure("E_RETURN");
			returnType    = ret.getString("TYPE");
			returnMessage = ret.getString("MESSAGE");
            
            return returnType;
    	}
    	catch(AbapException e) {
    		returnType    = "E";
    		returnMessage = "";
    		
    		return returnType;
    	}
    }
    
    /**
	 * 파라미터값과 파라미터 테이블 입력을 받고 Return 이 Type과 메시지 와 테이블의 리스트가 있을 경우
	 * 
	 * @author tytolee
	 * @param callFn (호출할 function명)
	 * @param param (조회 파라미터)
	 * @param importTableInfo (조회 테이블 정보)
	 * @param rtnTable (리턴 테이블명)
	 * @return List<Map<String, Object>>
	 * @throws JCoException
	 * @since 2012-04-09
	 */
    public List<Map<String, Object>> callRfcTypeNTable(String callFn, Map<String, Object> param, Map<String, List<Map<String, Object>>> importTableInfo, String rtnTable) throws Exception {
    	List<Map<String, Object>> list        = null;
    	JCoDestination            destination = null;
    	JCoFunction               function    = null;
    	JCoTable                  codes       = null;
    	int                       i           = 0;
    	int                       j           = 0;
    	Map<String, Object>       map         = null;
    	
    	list = new ArrayList<Map<String, Object>>();
    	
    	destination = JCoDestinationManager.getDestination(ABAP_AS);
    	function = destination.getRepository().getFunction(callFn);
    	
    	if(function == null){
    		throw new RuntimeException(callFn + " not found in SAP.");
    	}
    	
    	function = this.setParamFunction(param, function);                     // 조회 파라미터 값을 function에 설정
    	function = this.setImportTableInfoFunction(importTableInfo, function); // 조회 테이블 정보 설정
    	
    	try {
    		function.execute(destination);
    		
			codes = function.getTableParameterList().getTable(rtnTable);
            
            for(i = 0; i < codes.getNumRows(); i++) {
                codes.setRow(i);
                
                map = new HashMap<String, Object>();
                
                map.put("ROWNO", i+1);
                
                for(j = 0; j < codes.getMetaData().getFieldCount(); j++) {
                	map.put(codes.getMetaData().getName(j), codes.getString(codes.getMetaData().getName(j)).trim());
                }
                
                list.add(map);
            }
            
            return list;
    	}
    	catch(AbapException e) {
    		returnType    = "E";
    		returnMessage = "";
    		
    		return list;
    	}
    }
    
    /**
     * 조회 테이블 정보를 function에 설정하는 메소드
     * 
     * @author tytolee
     * @param param
     * @param function
     * @return JCoFunction
     * @throws Exception
     * @since 2012-04-09
     */
    protected JCoFunction setImportTableInfoFunction(Map<String, List<Map<String, Object>>> importTableInfo, JCoFunction function) throws Exception{
    	Iterator<String>          importTableInfoIterator = null;
    	Iterator<String>          listInfoIterator        = null;
    	String                    importTableInfoKey      = null;
    	String                    listInfoKey             = null;
    	List<Map<String, Object>> importTableInfoList     = null;
    	JCoParameterList          tableList               = null;
    	JCoTable                  table                   = null;
    	int                       i                       = 0;
    	Map<String, Object>       listInfo                = null;
    	Object                    listInfoObject          = null;
    	
    	tableList               = function.getTableParameterList();
    	importTableInfoIterator = importTableInfo.keySet().iterator();
    	
    	while(importTableInfoIterator.hasNext()){
    		importTableInfoKey  = importTableInfoIterator.next();
    		importTableInfoList = importTableInfo.get(importTableInfoKey);
    		table               = tableList.getTable(importTableInfoKey);
    		
    		for(i = 0; i < importTableInfoList.size(); i++){
    			table.appendRow();
    			listInfo         = importTableInfoList.get(i);
    			listInfoIterator = listInfo.keySet().iterator();
    			
    			while(listInfoIterator.hasNext()){
    				listInfoKey    = listInfoIterator.next();
    				listInfoObject = listInfo.get(listInfoKey);
    				
    				table.setValue(listInfoKey, listInfoObject);
    			}
    		}
		}
    	
    	return function;
    }
    
    /**
     * 조회 파라미터 값을 function에 설정하는 메소드
     * 
     * @author tytolee
     * @param param
     * @param function
     * @return JCoFunction
     * @throws Exception
     * @since 2012-04-09
     */
    protected JCoFunction setParamFunction(Map<String, Object> param, JCoFunction function) throws Exception{
    	Iterator<String> paramItor = null;
    	String           paramKey  = null;
    	
    	paramItor = param.keySet().iterator();
		
		while (paramItor.hasNext()) {
			paramKey = paramItor.next();
			
			function.getImportParameterList().setValue(paramKey, param.get(paramKey));
		}
		
    	return function;
    }
    
    /**
     * Return 이 Type과 메시지만 있을 경우(예:로그인 및 트랜잭션 관련 함수 호출)
     * @param callFn
     * @param param
     * @param returnStructure
     * @throws JCoException
     */
    public void callRfcString(String callFn, Map<String, Object> param) throws JCoException {
    	
    	JCoDestination destination = JCoDestinationManager.getDestination(ABAP_AS);
    	JCoFunction function = destination.getRepository().getFunction(callFn);
    	if(function == null)
    		throw new RuntimeException(callFn + " not found in SAP.");
    	
		Iterator<String> paramItor = param.keySet().iterator();
		while (paramItor.hasNext()) {
			String paramKey = paramItor.next();
			function.getImportParameterList().setValue(paramKey, param.get(paramKey));
		}
		try {
			function.execute(destination);
			JCoStructure ret = function.getExportParameterList().getStructure("E_RETURN");
			returnType = ret.getString("TYPE");
			returnMessage = ret.getString("MESSAGE");
		} catch(AbapException e) {
    		returnType = "E";
    		returnMessage = "";
    	}
    }
    
    /**
     * Return 이 Type과 메시지만 있을 경우
     * @param callFn
     * @param param
     * @param rtnNm
     * @param returnStructure
     * @throws JCoException
     */
    public void callRfcString(String callFn, Map<String, Object> param, String rtnNm) throws JCoException {
    	
    	JCoDestination destination = JCoDestinationManager.getDestination(ABAP_AS);
    	JCoFunction function = destination.getRepository().getFunction(callFn);
    	if(function == null)
    		throw new RuntimeException(callFn + " not found in SAP.");
    	
    	Iterator<String> paramItor = param.keySet().iterator();
    	while (paramItor.hasNext()) {
    		String paramKey = paramItor.next();
    		function.getImportParameterList().setValue(paramKey, param.get(paramKey));
    	}
    	try {
    		function.execute(destination);	
    		String ret = function.getExportParameterList().getString(rtnNm);
    		returnMessage = ret;
    	} catch(AbapException e) {
    		returnMessage = "0";
    	}
    }    
	
    
    public static void main(String [] args) {
    	try {
    		JcoAdapter jcoAdapter = new JcoAdapter();
        	Map<String, Object> param = new HashMap<String, Object>();
        	/*--------------------  -------------------*/
//			param.put("I_STCD2"    , "1234567890");	//사업자 등록번호                                           
//			
//			jcoAdapter.callRfcString("ZFI_MAST_06", param, "O_FLAG");
			
        	/*--------------------회원사가입---------------------*/
//		    param.put("BUKRS"     , "SKTS"); 						// 회사 코드                | SKTS            :: CHAR 4                예제)  BUKRS[SKTS]                                           
//		    param.put("KTOKK"     , ""); 							// 공급업체 계정 그룹       | (SAP내부)       :: CHAR 4                       KTOKK[]                                               
//		    param.put("LIFNR"     , "9876577879"); 					// 공급업체 사업자번호      | 번호만 추출한 사업자번호  :: CHAR 10            LIFNR[2178118975]                                     
//		    param.put("SORT1"     , ""); 							// 탐색용어1              | (SAP내부)       :: CHAR 20                      SORT1[]                                               
//		    param.put("SORT2"     , ""); 							// 탐색용어2              | (SAP내부)       :: CHAR 20                      SORT2[]                                               
//		    param.put("BANKS"     , "080"); 						// 은행 국가 키             | (임시) 080      :: CHAR 3                       BANKS[080]                                            
//		    param.put("BANKL"     , "20"); 							// 은행 키                  | param_bank_iden_code (은행코드) :: CHAR 15      BANKL[20]                                             
//		    param.put("BANKN"     , "1234568789"); 						// 은행 계정 번호           | param_paym_bank_acct (계정)     :: CHAR 18      BANKN[1111111111]                                     
//		    param.put("KOINH"     , "김예금"); 						// 예금주명                 | param_bank_admi_name (예금주)   :: CHAR 60      KOINH[111]                                            
//		    param.put("LAND1"     , ""); 							// 국가 키                  | (SAP내부)       :: CHAR 3                       LAND1[]                                               
//		    param.put("NAME1"     , "박준헤어");	 					// 이름 1                 | rc_comp_iden_name (상호)     :: CHAR 35         NAME1[(주)즐거운미래]                                       
//		    param.put("ORT01"     , "경기 성남시 분당구 삼평동 봇들마을4단지"); 	// 도시                     | 주소            :: CHAR 35                      ORT01[경기 이천시 장호원읍 진암1리]
//		    param.put("PSTLZ"     , "463-894"); 					// 우편번호                 | 우편번호        :: CHAR 10                      PSTLZ[467-904]                     
//		    param.put("STRAS"     , "우리집 123123"); 						// 번지 및 상세 주소        | 번지            :: CHAR 35                      STRAS[779번지]                     
//		    param.put("TELF1"     , "01045669283"); 					// 첫번째 전화번호          | 대표전화번호    :: CHAR 16                      TELF1[031-641-9262]                
//		    param.put("TELFX"     , ""); 				// 팩스번호                 | 팩스번호        :: CHAR 31                      TELFX[031-641-9264]                
//		    param.put("SPRAS"     , ""); 							// 언어 키                  | (SAP내부)       :: LANG 1                       SPRAS[]                            
//		    param.put("STCD2"     , "9876577879"); 					// 사업자등록번호           | 번호만 추출한 사업자번호  :: CHAR 11            STCD2[2178118975]                  
//		    param.put("SMTP_ADDR" , "park@bitcube.co.kr"); 			// 전자메일주소             | 대표메일주소    :: CHAR 241                     SMTP_ADDR[ecojf@ecojf.com]         
//		    param.put("J_1KFREPRE", "박준"); 						// 대표자명                 | 대표자명        :: CHAR 10                      J_1KFREPRE[유승구,최원규]          
//		    param.put("J_1KFTBUS" , "서비스"); 						// 업태                     | 업태            :: CHAR 30                      J_1KFTBUS[제조업외]                
//		    param.put("J_1KFTIND" , "미용실"); 						// 종목                     | 업종            :: CHAR 30                      J_1KFTIND[제설재외]                
//		    param.put("AKONT"     , ""); 							// 총계정원장의 조정 계정   | (SAP내부)       :: CHAR 10                      AKONT[]                            
//		    param.put("ZTERM"     , "1030"); 						// 지급 조건 키(매입)      | (임시) 결제조건 :: CHAR 4                       ZTERM[112]                         
//		    param.put("ZWELS"     , ""); 							// 지급 방법(매입)         | (임시) 없음     :: CHAR 10                      ZWELS[]                            
//		    param.put("ZTERM1"    , "1030"); 						// 지급 조건 키(매출)      | (임시) 결제조건 :: CHAR 4                       ZTERM1[112]                        
//		    param.put("ZWELS1"    , ""); 							// 지급 방법(매출)         | (임시) 없음     :: CHAR 10                      ZWELS1[]                           
//		    param.put("SPERR"     , ""); 							// 회사코드에 대해 전기보류 | 현재 사용안함   :: CHAR 1                       SPERR[]                            
//		    param.put("LOEVM"     , ""); 							// 마스터레코드에 대한 삭제 | 현재 사용안함   :: CHAR 1                       LOEVM[]                            
//		    param.put("MSGTY"     , ""); 							// 메시지 유형              |                 :: CHAR 1                       MSGTY[]                            
//		    param.put("MSGLIN"    , ""); 							// 메시지 텍스트            |                 :: CHAR 100                     MSGLIN[]                 	
		    

		    /*--------------------매출전송---------------------*/
//			param.put("ZJOBG" , "05"  ); // 01. 작업구분	//CASE WHEN a.sale_proc_amou >= 0 THEN '05' ELSE '07' END
//			param.put("BUKRS" , "SKTS"  ); // 02. 회사 코드
//			param.put("GJAHR" , "201010"  ); // 03. 회계연도
//			param.put("BELNR" , "3700011007"  ); // 04. 전표번호	//3700011001, 3700011002, 3700011002
//			param.put("BUDAT" , "20101130"  ); // 05. 전기일	//마감일자
//			param.put("BLDAT" , "20101130"  ); // 06. 증빙일	//마감일자
//			param.put("BLART" , "RM"  ); // 07. 전표 유형
//			param.put("WAERS" , "KRW"  ); // 08. 통화코드
//			param.put("USNAM" , "강용준"  ); // 09. 사용자 이름
//			param.put("BKTXT" , "테스트 매출 전체 "  ); // 10. 전표 헤더 텍스트
//			param.put("BUZEI" , ""  ); // 11. 개별항목번호
//			param.put("NEWBS" , ""  ); // 12. 개별항목의 전기키
//			param.put("NEWKO" , "2148618758"  ); // 13. 계정	//사업자등록번호
//			param.put("ZTERM" , "100"  ); // 14. 지급조건
//			param.put("ZLSCH" , ""  ); // 15. 지급방법
//			param.put("BVTYP" , ""  ); // 16. 은행키
//			param.put("MWSKZ" , ""  ); // 17. 세금코드
//			param.put("DMBTR" , ""  ); // 18. 현재통화금액
//			param.put("WRBTR" , 1000  ); // 19. 금액	공급가액 / 100
//			param.put("FWSTE" , 100  ); // 20. 세액	부가세누계액 / 100
//			param.put("BUPLA" , ""  ); // 21. 사업장
//			param.put("GSBER" , ""  ); // 22. 사업 영역
//			param.put("ZUONR" , ""  ); // 23. 지정
//			param.put("SGTXT" , "매출 테스트 개별"  ); // 24. 개별항목 텍스트
//			param.put("KOSTL" , ""  ); // 25. 코스트 센터 
//			param.put("PROJK" , ""  ); // 26. WBS 요소
//			param.put("FKBER" , ""  ); // 27. 기능 영역
//			param.put("VALUT" , ""  ); // 28. 기준일
//			param.put("XREF1" , ""  ); // 29. 참조키1
//			param.put("XREF2" , ""  ); // 20. 참조키2
//			param.put("XREF3" , ""  ); // 31. 참조키3
//			param.put("XNEGP" , ""  ); // 32. 마이너스전기
//			param.put("MSGTY" , ""  ); // 33. 메시지 유형
//			param.put("MSGLIN", "" ); // 34. 메시지 텍스트
			
			
			
        	/*--------------------매출취소전송---------------------*/
//			param.put("ZJOBG" , "09"  ); // 01. 작업구분
//			param.put("BUKRS" , "SKTS"  ); // 02. 회사 코드
//			param.put("GJAHR" , "201010"  ); // 03. 회계연도
//			param.put("BELNR" , "3700011007"  ); // 04. 전표번호	3700011003
//			param.put("STGRD"  , "03"); // 05. 역분개사유
//			param.put("BUDAT"  , ""); // 06. 전기일
//			param.put("MSGTY"  , ""); // 07. 메시지 유형
//			param.put("MSGLIN" , ""); // 08. 메시지 텍스트
//			param.put("BELNR_R", ""); // 09. 역분개전표번호
			
        	
        	/*--------------------매출반제수신---------------------*/
//			param.put("I_BUKRS" , "SKTS"  ); // 01. 회사 코드
//			param.put("I_GJAHR" , "2010"  ); // 02. 회계연도
//			param.put("I_BELNR" , "3700011005"  ); // 03. 전표번호
			
			
			
			/*--------------------매입전송---------------------*/
        	/*
			param.put("ZJOBG" , "04"  ); // 01. 작업구분	CASE WHEN a.buyi_proc_amou >= 0 THEN '04' ELSE '06' END
			param.put("BUKRS" , "SKTS"  ); // 02. 회사 코드
			param.put("GJAHR" , "201010"  ); // 03. 회계연도
			param.put("BELNR" , "3700012003"  ); // 04. 전표번호	//3700012001, 3700012002, 3700012003
			param.put("BUDAT" , "20101130"  ); // 05. 전기일	//마감일자
			param.put("BLDAT" , "20101130"  ); // 06. 증빙일	//마감일자
			param.put("BLART" , "RM"  ); // 07. 전표 유형
			param.put("WAERS" , "KRW"  ); // 08. 통화코드
			param.put("USNAM" , "강용준"  ); // 09. 사용자 이름
			param.put("BKTXT" , "테스트 매입 전체 "  ); // 10. 전표 헤더 텍스트
			param.put("BUZEI" , ""  ); // 11. 개별항목번호
			param.put("NEWBS" , ""  ); // 12. 개별항목의 전기키
			param.put("NEWKO" , "2148618758"  ); // 13. 계정	//사업자등록번호
			param.put("ZTERM" , "100"  ); // 14. 지급조건
			param.put("ZLSCH" , ""  ); // 15. 지급방법
			param.put("BVTYP" , ""  ); // 16. 은행키
			param.put("MWSKZ" , ""  ); // 17. 세금코드
			param.put("DMBTR" , ""  ); // 18. 현재통화금액
			param.put("WRBTR" , 1000  ); // 19. 금액	공급가액 / 100
			param.put("FWSTE" , 100  ); // 20. 세액	부가세누계액 / 100
			param.put("BUPLA" , ""  ); // 21. 사업장
			param.put("GSBER" , ""  ); // 22. 사업 영역
			param.put("ZUONR" , ""  ); // 23. 지정
			param.put("SGTXT" , "매입 테스트 개별"  ); // 24. 개별항목 텍스트
			param.put("KOSTL" , ""  ); // 25. 코스트 센터 
			param.put("PROJK" , ""  ); // 26. WBS 요소
			param.put("FKBER" , ""  ); // 27. 기능 영역
			param.put("VALUT" , ""  ); // 28. 기준일
			param.put("XREF1" , ""  ); // 29. 참조키1
			param.put("XREF2" , ""  ); // 20. 참조키2
			param.put("XREF3" , ""  ); // 31. 참조키3
			param.put("XNEGP" , ""  ); // 32. 마이너스전기
			param.put("MSGTY" , ""  ); // 33. 메시지 유형
			param.put("MSGLIN", "" ); // 34. 메시지 텍스트
			
			*/
			
			/*--------------------매입취소전송---------------------*/
        	/*
			param.put("ZJOBG" , "08"  ); // 01. 작업구분
			param.put("BUKRS" , "SKTS"  ); // 02. 회사 코드
			param.put("GJAHR" , "201010"  ); // 03. 회계연도
			param.put("BELNR" , "3700012003"  ); // 04. 전표번호	3700012003
			param.put("STGRD"  , "03"); // 05. 역분개사유
			param.put("BUDAT"  , ""); // 06. 전기일
			param.put("MSGTY"  , ""); // 07. 메시지 유형
			param.put("MSGLIN" , ""); // 08. 메시지 텍스트
			param.put("BELNR_R", ""); // 09. 역분개전표번호
			
			*/
			
        	/*--------------------매입반제수신---------------------*/
        	
			param.put("I_BUKRS" , "SKTS"  ); // 01. 회사 코드
			param.put("I_GJAHR" , "2014"  ); // 02. 회계연도
			param.put("I_BELNR" , "3500011985"  ); // 03. 전표번호
			
		    
    	} catch(Exception e) {
    		
    	}
    }
}
