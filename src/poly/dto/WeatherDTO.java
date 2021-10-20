package poly.dto;

public class WeatherDTO {

	private String main; // 날씨
	private double temp; // 온도
	private Long humidity; // 습도
	private double wind; // 바람
	private long clouds; // 구름
	private String description; // 날씨 상세
	private String icon; // 이미지

	private String url;
	private String collect_time; // 수집시간

	public String getMain() {
		return main;
	}

	public void setMain(String main) {
		this.main = main;
	}

	public double getTemp() {
		return temp;
	}

	public void setTemp(double temp) {
		this.temp = temp;
	}

	public Long getHumidity() {
		return humidity;
	}

	public void setHumidity(Long humidity) {
		this.humidity = humidity;
	}

	public double getWind() {
		return wind;
	}

	public void setWind(double wind) {
		this.wind = wind;
	}

	public long getClouds() {
		return clouds;
	}

	public void setClouds(long clouds) {
		this.clouds = clouds;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public String getUrl() {
		return url;
	}

	public void setUrl(String url) {
		this.url = url;
	}

	public String getCollect_time() {
		return collect_time;
	}

	public void setCollect_time(String collect_time) {
		this.collect_time = collect_time;
	}

	public String getIcon() {
		return icon;
	}

	public void setIcon(String icon) {
		this.icon = icon;
	}

}
