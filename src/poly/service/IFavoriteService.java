package poly.service;

import java.util.List;

import poly.dto.FavoriteDTO;

public interface IFavoriteService {
	
	// 즐겨찾기 추가
	int insertFavorite(FavoriteDTO fDTO) throws Exception;
	
	// 즐겨찾기 리스트
	List<FavoriteDTO> getFavoriteList(String user_no) throws Exception;
	
	// 즐겨찾기 중복 확인
	int sameFavorite(FavoriteDTO fDTO) throws Exception;
	
	// 즐겨찾기 삭제
	void deleteFavorite(FavoriteDTO fDTO) throws Exception;
	
}
