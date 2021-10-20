package poly.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Service;

import poly.dto.FavoriteDTO;
import poly.persistance.mapper.IFavoriteMapper;
import poly.service.IFavoriteService;

@Service("FavoriteService")
public class FavoriteService implements IFavoriteService{
	
	private Logger log = Logger.getLogger(this.getClass());
	
	@Resource(name="FavoriteMapper")
	private IFavoriteMapper favoriteMapper;

	// 즐겨찾기 추가
	@Override
	public int insertFavorite(FavoriteDTO fDTO) throws Exception {
		return favoriteMapper.insertFavorite(fDTO);
	}

	// 즐겨찾기 리스트
	@Override
	public List<FavoriteDTO> getFavoriteList(String user_no) throws Exception {
		return favoriteMapper.getFavoriteList(user_no);
	}

	// 즐겨찾기 중복 확인
	@Override
	public int sameFavorite(FavoriteDTO fDTO) throws Exception {

		int res = favoriteMapper.sameFavorite(fDTO);
		
		if(res >= 1) {
			log.info("중복되었습니다.");
		}else {
			log.info("즐겨찾기 추가.");
		}
		
		return res;
	}

	// 즐겨찾기 삭제
	@Override
	public void deleteFavorite(FavoriteDTO fDTO) throws Exception {
		favoriteMapper.deleteFavorite(fDTO);
	}

}
