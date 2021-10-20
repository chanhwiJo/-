package poly.service;

import java.util.List;

import poly.dto.JoinDTO;
import poly.dto.ManageDTO;
import poly.dto.UserDTO;

public interface IManageService {

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

	// 팀원 리스트
	List<UserDTO> getUserList(String team_no) throws Exception;

	// 팀원 수
	UserDTO getUserNum(String team_no) throws Exception;

	// 동호회 검색
	List<ManageDTO> getTeamSearch(ManageDTO mDTO) throws Exception;

	// 동호회 검색 결과 수
	ManageDTO getTeamSearchNum(ManageDTO mDTO) throws Exception;

	// 동호회 검색 페이징
	List<ManageDTO> getTeamSearchPage(ManageDTO mDTO) throws Exception;

	// 동호회 페이징
	List<ManageDTO> getTeamPaging(ManageDTO mDTO) throws Exception;
}
