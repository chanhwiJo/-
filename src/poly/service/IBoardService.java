package poly.service;

import java.util.List;

import poly.dto.BoardDTO;
import poly.dto.FileDTO;
import poly.dto.JoinDTO;
import poly.dto.LikeDTO;
import poly.dto.ManageDTO;
import poly.dto.UserDTO;

public interface IBoardService {

	// 글 리스트
	List<BoardDTO> getBoardList(String team_no) throws Exception;

	// 게시글 수
	BoardDTO getBoardNum(String team_no) throws Exception;

	// 글 상세
	BoardDTO getBoard(BoardDTO bDTO) throws Exception;

	// 글 등록
	int insertBoard(BoardDTO bDTO) throws Exception;

	// 글 번호
	BoardDTO getBoardNo(BoardDTO bDTO) throws Exception;

	// 파일 추가
	int insertFile(FileDTO f) throws Exception;

	// 조회수 증가
	void updateCnt(BoardDTO cDTO) throws Exception;

	// 좋아요 추가
	int insertLike(LikeDTO lDTO) throws Exception;
	
	// 좋아요 수
	int countLike(LikeDTO lDTO) throws Exception;
	
	// 좋아요 유저 중복 확인
	int sameLike(LikeDTO lDTO) throws Exception;
	
	// 좋아요 삭제
	void deleteLike(LikeDTO lDTO) throws Exception;
	
	// 파일 상세
	FileDTO getFile(FileDTO fDTO) throws Exception;

	// 파일 삭제
	void deleteFile(FileDTO fDTO) throws Exception;

	// 글 수정
	int updateBoard(BoardDTO bDTO) throws Exception;

	// 글 삭제
	int deleteBoard(BoardDTO bDTO) throws Exception;

	// 게시글 페이징
	List<BoardDTO> getboardPaging(BoardDTO bDTO) throws Exception;

	// 게시글 검색
	List<BoardDTO> getboardSearch(BoardDTO bDTO) throws Exception;

	// 게시글 검색 결과 수
	BoardDTO getboardSearchNum(BoardDTO bDTO) throws Exception;

	// 게시글 검색 결과 페이징
	List<BoardDTO> getboardSearchPage(BoardDTO bDTO) throws Exception;

	// 동호회 리스트
	List<ManageDTO> getTeamList() throws Exception;

	// 동호회 수
	ManageDTO getTeamNum() throws Exception;

	// 동호회 중복 체크
	int getTeamName(ManageDTO mDTO) throws Exception;

	// 팀 개설
	int insertTeam(ManageDTO mDTO) throws Exception;

	// 동호회 번호 가져오기
	ManageDTO getTeamNo(ManageDTO mDTO) throws Exception;

	// 팀원수 + 1
	void updateTeamUp(String team_no) throws Exception;

	// 팀원수 - 1
	void updateTeamDwon(String team_no) throws Exception;

	// 동호회 가입
	int insertJoin(JoinDTO jDTO) throws Exception;

	// 동호회 가입 취소
	void deleteJoin(JoinDTO jDTO) throws Exception;

	// 회원 권한, 동호회 번호 수정
	void updateUserTeam(UserDTO uDTO) throws Exception;

	// 권한 수정 (UU로 수정)
	void updateAuth(String user_no) throws Exception;

	// 가입 확인 수정 (O으로 수정)
	void updateJoinCheck(String user_no) throws Exception;

	// 동호회 정보
	ManageDTO getTeam(ManageDTO mDTO) throws Exception;

	// 동호회 수정
	int updateTeam(ManageDTO mDTO) throws Exception;

	// 동호회 삭제
	void deleteTeamDrop(String team_no) throws Exception;

	// 동호회 삭제로 인한 회원 수정 (auth, team_no)
	void updateTeamDrop(UserDTO uDTO) throws Exception;

	// 동호회 삭제로 인한 게시글 삭제
	void deleteTeamBoard(String team_no) throws Exception;

	// 동호회 삭제로 인한 파일 삭제
	void deleteTeamFile(String team_no) throws Exception;

	// 가입 신청 정보
	UserDTO getJoinUser(String user_no) throws Exception;

	// 가입 신청
	JoinDTO getJoin(String user_no) throws Exception;

	// 리더 정보
	UserDTO getUser(String team_no) throws Exception;

	// 팀원 수
	UserDTO getUserNum(String team_no) throws Exception;
	
	// 팀원 리스트
	List<UserDTO> getUserList(String team_no) throws Exception;

	// 팀원 리스트 페이징
	List<UserDTO> getUserTeamPaging(UserDTO uDTO) throws Exception;

	// 팀원 검색
	List<UserDTO> getTeamUserSearch(UserDTO uDTO) throws Exception;

	// 팀원 검색 결과수
	UserDTO getUserTeamSearchNum(UserDTO uDTO) throws Exception;

	// 팀원 검색 페이징
	List<UserDTO> getUserTeamSearchPage(UserDTO uDTO) throws Exception;

	// 동호회 검색
	List<ManageDTO> getTeamSearch(ManageDTO mDTO) throws Exception;

	// 동호회 검색 결과 수
	ManageDTO getTeamSearchNum(ManageDTO mDTO) throws Exception;

	// 동호회 검색 페이징
	List<ManageDTO> getTeamSearchPage(ManageDTO mDTO) throws Exception;

	// 동호회 페이징
	List<ManageDTO> getTeamPaging(ManageDTO mDTO) throws Exception;
	
}
