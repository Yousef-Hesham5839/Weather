class Weather {
  final String cityName;
  final double temperature;
  final String description;
  final double feelsLike;
  final int humidity;
  final double windSpeed;
  final String icon;

  const Weather({
    required this.cityName,
    required this.temperature,
    required this.description,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.icon,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json["name"],
      temperature: (json["main"]["temp"] as num).toDouble(),
      description: json["weather"][0]["description"],
      feelsLike: (json["main"]["feels_like"] as num).toDouble(),
      humidity: json["main"]["humidity"],
      windSpeed: (json["wind"]["speed"] as num).toDouble(),
      icon: json["weather"][0]["icon"],
    );
  }

  // 🌤️ Weather Icon Mapper (UI-friendly)
  String getWeatherIcon() {
    final condition = description.toLowerCase();

    if (condition.contains("rain")) {
      return "🌧️";
    } else if (condition.contains("cloud")) {
      return "☁️";
    } else if (condition.contains("clear")) {
      return "☀️";
    } else if (condition.contains("snow")) {
      return "❄️";
    } else if (condition.contains("storm") ||
        condition.contains("thunder")) {
      return "⛈️";
    } else if (condition.contains("mist") ||
        condition.contains("fog") ||
        condition.contains("haze")) {
      return "🌫️";
    } else {
      return "🌡️";
    }
  }
}