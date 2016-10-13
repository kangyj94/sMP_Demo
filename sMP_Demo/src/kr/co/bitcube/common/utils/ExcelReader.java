package kr.co.bitcube.common.utils;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.poifs.filesystem.POIFSFileSystem;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.DateUtil;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

/**
 * Excel File 을 읽어서 List로 반환하는 Object
 * @author jameskang
 *
 */
public class ExcelReader {

	private File readFile = null;
	private String fileExtionsion = "";
	
	public ExcelReader(String uploadedFile) {
		this.readFile = new File(uploadedFile);
		this.fileExtionsion = uploadedFile.substring(uploadedFile.lastIndexOf(".")+1);
	}
	
	/**
	 * ExcelData을 List<Map>으로 반환
	 * @param sheetNum(반환할 시트번호 : 0부터 시작)
	 * @param colNames(컬럼의 MapKey String Array)
	 * @return List<Map<String, Object>>
	 * @throws IOException
	 */
	public List<Map<String, Object>> getExcelReadList(int sheetNum, String[] colNames) throws IOException {
		if("XLS".equals(StringUtils.upperCase(this.fileExtionsion))) {	//xls
			return this.getExcelXlsReadList(sheetNum, colNames);
		} else {	//xlsx
			return this.getExcelXlsxReadList(sheetNum, colNames);
		}
	}
	
	public List<Map<String, Object>> getExcelXlsReadList(int sheetNum, String[] colNames) throws FileNotFoundException, IOException {
		List<Map<String, Object>> excelList = new ArrayList<Map<String, Object>>();
		POIFSFileSystem fs=new POIFSFileSystem(new FileInputStream(this.readFile));
		HSSFWorkbook wb=new HSSFWorkbook(fs);
		HSSFSheet sheet=wb.getSheetAt(sheetNum); //시트 가져오기
		int rows=sheet.getPhysicalNumberOfRows(); //행 갯수 가져오기
		for(int j=1; j<rows; j++){ //row 루프 // 1행은 제목줄
			HSSFRow row=sheet.getRow(j); //row 가져오기 
			if(row!=null) {
				//int cells=row.getPhysicalNumberOfCells(); //cell 갯수 가져오기
				int cells = colNames.length;
				Map<String, Object> cellMap = new HashMap<String, Object>();
				int checkCellCnt = 0;
				for(int c=0; c<cells; c++){ //cell 루프
					HSSFCell cell = row.getCell(c);	//cell 가져오기
					String objValue = "";
					if(cell != null) {
						switch(cell.getCellType()){ //cell 타입에 따른 데이타 저장 
							case Cell.CELL_TYPE_FORMULA: 
								objValue = cell.getCellFormula();
								break;
							case Cell.CELL_TYPE_NUMERIC:
								if (DateUtil.isCellDateFormatted(cell)){ 
									SimpleDateFormat formatter = new SimpleDateFormat("yyyy.MM.dd");
									objValue=""+formatter.format(cell.getDateCellValue());
								} else {
									objValue=""+(long)cell.getNumericCellValue();
								}
								break;
							case Cell.CELL_TYPE_STRING:
								objValue=""+cell.getStringCellValue();
								break;
							case Cell.CELL_TYPE_ERROR:
								objValue=""+cell.getErrorCellValue();
								break;
							default:
						}
					}
					if(!"".equals(objValue)) checkCellCnt++;
					cellMap.put(colNames[c], objValue);
				}
				if(checkCellCnt > 0) {
					excelList.add(cellMap);
				}
			}
		}
		return excelList;
	}
	
	public List<Map<String, Object>> getExcelXlsxReadList(int sheetNum, String[] colNames) throws FileNotFoundException, IOException {
		List<Map<String, Object>> excelList = new ArrayList<Map<String, Object>>();
		XSSFWorkbook wb = new XSSFWorkbook(new FileInputStream(this.readFile));
		XSSFSheet sheet=wb.getSheetAt(sheetNum); //시트 가져오기 
		int rows=sheet.getPhysicalNumberOfRows(); //행 갯수 가져오기
		for(int j=1; j<rows; j++){ //row 루프 // 1행은 제목줄 
			XSSFRow row=sheet.getRow(j); //row 가져오기
			if(row!=null){ 
				//int cells=row.getPhysicalNumberOfCells(); //cell 갯수 가져오기
				int cells = colNames.length;
				Map<String, Object> cellMap = new HashMap<String, Object>();
				int checkCellCnt = 0;
				for(int c=0; c<cells; c++){ //cell 루프
					XSSFCell cell=row.getCell(c); //cell 가져오기 
					String objValue = "";
					if(cell != null) {
						switch(cell.getCellType()){ //cell 타입에 따른 데이타 저장 
							case Cell.CELL_TYPE_FORMULA: 
								objValue = cell.getCellFormula();
								
								break;
							case Cell.CELL_TYPE_NUMERIC:
								if (DateUtil.isCellDateFormatted(cell)){ 
									SimpleDateFormat formatter = new SimpleDateFormat("yyyy.MM.dd");
									objValue=""+formatter.format(cell.getDateCellValue());
								} else {
									//상품규격에 소수점을 입력 할 경우도 있어서 케이스 처리
									if(c >= 16 && c <= 29){
										objValue=""+cell.getRawValue();
									}else{
										objValue=""+(long)cell.getNumericCellValue();
									}
								}
								
								break;
							case Cell.CELL_TYPE_STRING:
								objValue=""+cell.getStringCellValue();
								
								break;
							case Cell.CELL_TYPE_ERROR:
								objValue=""+cell.getErrorCellValue();
								
								break;
							default:
						}
					}
					if(!"".equals(objValue)) checkCellCnt++;
					cellMap.put(colNames[c], objValue);
				}
				if(checkCellCnt > 0) {
					excelList.add(cellMap);
				}
			}
		}
		return excelList;
	}
	
	/**
	 * 엑셀다운로드를 통해 다운받은 엑셀파일을 업로드 할시 
	 * 
	 * @param sheetNum(반환할 시트번호 : 0부터 시작)
	 * @param colNames(컬럼의 MapKey String Array)
	 * @return List<Map<String, Object>>
	 * @throws IOException
	 */
	public List<Map<String, Object>> getExcelReadList2(int sheetNum, String[] colNames) throws IOException {
		if("XLS".equals(StringUtils.upperCase(this.fileExtionsion))) {	//xls
			return this.getExcelXlsReadList2(sheetNum, colNames);
		} else {	//xlsx
			return this.getExcelXlsxReadList2(sheetNum, colNames);
		}
	}
	
	public List<Map<String, Object>> getExcelXlsReadList2(int sheetNum, String[] colNames) throws FileNotFoundException, IOException {
		List<Map<String, Object>> excelList = new ArrayList<Map<String, Object>>();
		POIFSFileSystem fs=new POIFSFileSystem(new FileInputStream(this.readFile));
		HSSFWorkbook wb=new HSSFWorkbook(fs);
		HSSFSheet sheet=wb.getSheetAt(sheetNum); //시트 가져오기
		int rows=sheet.getPhysicalNumberOfRows(); //행 갯수 가져오기
		for(int j=3; j<=rows; j++){ //row 루프 // 1행은 제목줄
			HSSFRow row=sheet.getRow(j); //row 가져오기 
			if(row!=null) {
				//int cells=row.getPhysicalNumberOfCells(); //cell 갯수 가져오기
				int cells = colNames.length;
				Map<String, Object> cellMap = new HashMap<String, Object>();
				int checkCellCnt = 0;
				for(int c=0; c<cells; c++){ //cell 루프
					HSSFCell cell = row.getCell(c);	//cell 가져오기
					String objValue = "";
					if(cell != null) {
						
						switch(cell.getCellType()){ //cell 타입에 따른 데이타 저장 
							case Cell.CELL_TYPE_FORMULA: 
								objValue = cell.getCellFormula();
								break;
							case Cell.CELL_TYPE_NUMERIC:
								if (DateUtil.isCellDateFormatted(cell)){ 
									SimpleDateFormat formatter = new SimpleDateFormat("yyyy.MM.dd");
									objValue=""+formatter.format(cell.getDateCellValue());
								} else {
									objValue=""+(long)cell.getNumericCellValue();
								}
								break;
							case Cell.CELL_TYPE_STRING:
								objValue=""+cell.getStringCellValue();
								break;
							case Cell.CELL_TYPE_ERROR:
								objValue=""+cell.getErrorCellValue();
								break;
							default:
						}
					}
					if(!"".equals(objValue)) checkCellCnt++;
					cellMap.put(colNames[c], objValue);
					
				}
				if(checkCellCnt > 0) {
					excelList.add(cellMap);
				}
			}
		}
		return excelList;
	}
	
	public List<Map<String, Object>> getExcelXlsxReadList2(int sheetNum, String[] colNames) throws FileNotFoundException, IOException {
		List<Map<String, Object>> excelList = new ArrayList<Map<String, Object>>();
		XSSFWorkbook wb = new XSSFWorkbook(new FileInputStream(this.readFile));
		XSSFSheet sheet=wb.getSheetAt(sheetNum); //시트 가져오기 
		int rows=sheet.getPhysicalNumberOfRows(); //행 갯수 가져오기
		for(int j=3; j<=rows; j++){ //row 루프 // 1행은 제목줄 
			XSSFRow row=sheet.getRow(j); //row 가져오기
			if(row!=null){ 
				//int cells=row.getPhysicalNumberOfCells(); //cell 갯수 가져오기
				int cells = colNames.length;
				Map<String, Object> cellMap = new HashMap<String, Object>();
				int checkCellCnt = 0;
				for(int c=0; c<cells; c++){ //cell 루프
					XSSFCell cell=row.getCell(c); //cell 가져오기 
					String objValue = "";
					if(cell != null) {
						
						switch(cell.getCellType()){ //cell 타입에 따른 데이타 저장 
							case Cell.CELL_TYPE_FORMULA: 
								objValue = cell.getCellFormula();
								
								break;
							case Cell.CELL_TYPE_NUMERIC:
								if (DateUtil.isCellDateFormatted(cell)){ 
									SimpleDateFormat formatter = new SimpleDateFormat("yyyy.MM.dd");
									objValue=""+formatter.format(cell.getDateCellValue());
								} else {
									//상품규격에 소수점을 입력 할 경우도 있어서 케이스 처리
									if(c >= 16 && c <= 29){
										objValue=""+cell.getRawValue();
									}else{
										objValue=""+(long)cell.getNumericCellValue();
									}
								}
								
								break;
							case Cell.CELL_TYPE_STRING:
								objValue=""+cell.getStringCellValue();
								
								break;
							case Cell.CELL_TYPE_ERROR:
								objValue=""+cell.getErrorCellValue();
								
								break;
							default:
						}
					}
					if(!"".equals(objValue)) checkCellCnt++;
					cellMap.put(colNames[c], objValue);
				}
				if(checkCellCnt > 0) {
					excelList.add(cellMap);
				}
			}
		}
		return excelList;
	}
}
