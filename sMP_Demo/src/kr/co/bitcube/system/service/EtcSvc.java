package kr.co.bitcube.system.service;

import java.awt.AlphaComposite;
import java.awt.Graphics2D;
import java.awt.Image;
import java.awt.image.BufferedImage;
import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.imageio.ImageIO;

import kr.co.bitcube.common.dto.CodesDto;
import kr.co.bitcube.system.dao.EtcDao;
import kr.co.bitcube.system.dto.CodeTypesDto;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

@Service
public class EtcSvc {
	private Logger logger = Logger.getLogger(getClass());
	
	@Autowired
	private CodeSvc codeSvc;
	@Autowired
	private EtcDao etcDao;
	
	/**
	 * 이미지 리사이즈 하고 그 결과를 반환하는 메소드<br/>
	 * return map 구조 : 코드 타입 IMAGERESIZETYPE에 해당하는 파일명을 담아서 반환
	 * 
	 * @author tytolee
	 * @param imageFile
	 * @param servletContext
	 * @return Map
	 * @throws Exception
	 * @since 2012-07-20
	 */
	public Map<String, String> imageResizeProcess(MultipartFile imageFile, String realPath) throws Exception{
		Map<String, String> processResult   = null;
		Map<String, Object> params          = null;
		File                saveFile        = null;
		List<CodesDto>      imageResizeType = null;
		int                 i               = 0;
		int                 width           = 0;
		int                 height          = 0;
		CodesDto            codesDto        = null;
		String              resizeFileName  = null;
		
		processResult = new HashMap<String, String>();
		params        = new HashMap<String, Object>();
		
		params.put("srcCodeTypeCd", "IMAGERESIZETYPE");
		params.put("orderString",   "A.DISORDER ASC");
		
		imageResizeType = this.codeSvc.getCodeList(params);         // 코드값리스트 구하기
		saveFile        = this.saveFile(imageFile, realPath); // 첨부파일을 저장
		processResult.put("ORGIN", saveFile.getName());
		for(i = 0; i < imageResizeType.size(); i++){
			codesDto = imageResizeType.get(i);
			width    = this.parseInt(codesDto.getCodeVal1(), 0);
			height   = this.parseInt(codesDto.getCodeVal2(), 0);
			
			resizeFileName = this.setImgaeFileResize(saveFile, width, height, realPath); // 파일 리사이즈 후 그 파일명을 반환
			
			processResult.put(codesDto.getCodeNm1(), resizeFileName);
		}
		
		return processResult;
	}
	
	/**
	 * 문자열을 int 형으로 변환하는 메소드
	 * 
	 * @author tytolee
	 * @param string (변환할 문자열)
	 * @param defaultValue (에러 발생시 기본값)
	 * @return int
	 * @since 2012-07-20
	 */
	protected int parseInt(String string, int defaultValue){
		int result = 0;
		
		try{
			result = Integer.parseInt(string);
		}
		catch(Exception e){
			result = defaultValue;
		}
		
		return result;
	}
	
	/**
	 * 파일 리사이즈 후 그 파일명을 받아오는 메소드
	 * 
	 * @author tytolee
	 * @param file
	 * @param width
	 * @param height
	 * @param servletContext
	 * @return String
	 * @throws Exception
	 * @since 2012-07-20
	 */
	protected String setImgaeFileResize(File file, int width, int height, String realPath) throws Exception{
		BufferedImage orImg        = null;
		BufferedImage reImg        = null;
		File          saveFile     = null;
		String        saveFileName = null;
		String        filePath     = null;
		String        filename     = null;
		String        fExt         = null;
		int           index        = 0;
		
		filename     = file.getName();
		index        = filename.lastIndexOf(".");
		fExt         = filename.substring(index + 1);
		saveFileName = filename.substring(0, index) + "_" + width + "." + fExt;
		filePath     = realPath + "/" + saveFileName;
		
		logger.debug("setImgaeFileResize realPath     : >" + realPath + "<");
		logger.debug("setImgaeFileResize saveFileName : >" + saveFileName + "<");
		
		saveFile = new File(filePath);
		
		orImg = ImageIO.read(file);
		reImg = this.createImageResize(orImg, width, height, true); // 이미지 리사이즈를 처리
		
		ImageIO.write(reImg, "jpg", saveFile);
		
		return saveFileName;
	}
	
	/**
	 * 첨부파일을 저장하는 메소드<br/>
	 * 
	 * @author jieun4668
	 * @param file
	 * @param servletContext
	 * @return File (저장된 파일)
	 * @throws Exception
	 * @since 2012-04-02
	 * @modify 2012-07-20 (로직 변경에 따른 파라미터 추가와 리턴값 변경, 소스변경, tytolee)
	 */
	protected File saveFile(MultipartFile file, String realPath) throws Exception{
		File   folder       = null;
		File   saveFile     = null;
		String saveFileName = null;
		String filePath     = null;
		String filename     = null;
		String fExt         = null;
		int    index        = 0;
		
		filename     = file.getOriginalFilename();
		index        = filename.lastIndexOf(".");
		fExt         = filename.substring(index + 1);
		saveFileName = System.currentTimeMillis() + "." + fExt;	// saveFileName = file.getOriginalFilename();
		filePath     = realPath + "/" + saveFileName;
		
		logger.debug("saveFile realPath     : >" + realPath + "<");
		logger.debug("saveFile saveFileName : >" + saveFileName + "<");
		
		folder   = new File(realPath);
		saveFile = new File(filePath);
		
		if(!folder.exists()){ // 업로드 파일 폴더 존재 확인
			folder.mkdirs();
		}
		
		file.transferTo(saveFile); // 파일 저장
		
		return saveFile;
	}	
	
	/**
	 * 이미지 리사이즈를 처리하는 메소드
	 * 
	 * @author http://dalki0126.blog.me/20159361234
	 * @param orimg (원본이미지)
	 * @param width (가로)
	 * @param heigth (세로)
	 * @param alpha (투명화여부, true : 투명화, false : 투명화 안함)
	 * @return BufferedImage
	 * @throws Exception
	 * @since -
	 */
	protected BufferedImage createImageResize(Image orimg, int width, int heigth, boolean alpha) throws Exception{
		int           imgType = 0;
		BufferedImage scale   = null;
		Graphics2D    g       = null;
		
		if(alpha){
			imgType = BufferedImage.TYPE_INT_RGB;
		}
		else{
			imgType = BufferedImage.TYPE_INT_ARGB;
		}
		
		scale = new BufferedImage(width, heigth, imgType);
		
		g = scale.createGraphics();
		
		if(alpha){
			g.setComposite(AlphaComposite.Src);
		}
		
		g.drawImage(orimg, 0, 0, width, heigth, null);
		g.dispose();
		
		return scale;
	}
	
	/**
	 * 코드정보 상세정보를 표시하기 위한 정보를 조회하는 메소드
	 * 
	 * @author taeilyun
	 * @param codeTypeId
	 * @return Map<String, CodeTypesDto>
	 * @throws Exception
	 * @since 2012-09-14
	 */
	public Map<String, Object> getCodeTypesDetailInfo(String srcCodeTypeId) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		CodeTypesDto detailInfo = this.etcDao.selectCodeTypesInfo(srcCodeTypeId);   // 특정 코드정보를 조회
		map.put("detailInfo", detailInfo);
		return map;
	}
}