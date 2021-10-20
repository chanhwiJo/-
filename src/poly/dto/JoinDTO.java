package poly.dto;

public class JoinDTO {
	String join_no; //조인될 번호
	String team_no; //동호회번 호
	String user_no; //회원번호
	String join_memo; //가입글
	String join_check; //가입확인
	String reg_no;
	String reg_dt;

	public String getJoin_no() {
		return join_no;
	}

	public void setJoin_no(String join_no) {
		this.join_no = join_no;
	}

	public String getTeam_no() {
		return team_no;
	}

	public void setTeam_no(String team_no) {
		this.team_no = team_no;
	}

	public String getUser_no() {
		return user_no;
	}

	public void setUser_no(String user_no) {
		this.user_no = user_no;
	}

	public String getJoin_memo() {
		return join_memo;
	}

	public void setJoin_memo(String join_memo) {
		this.join_memo = join_memo;
	}

	public String getJoin_check() {
		return join_check;
	}

	public void setJoin_check(String join_check) {
		this.join_check = join_check;
	}

	public String getReg_no() {
		return reg_no;
	}

	public void setReg_no(String reg_no) {
		this.reg_no = reg_no;
	}

	public String getReg_dt() {
		return reg_dt;
	}

	public void setReg_dt(String reg_dt) {
		this.reg_dt = reg_dt;
	}
}
