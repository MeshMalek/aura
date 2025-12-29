String getWeatherAnimation(String? mainCondition) {
  if (mainCondition == null) return 'assets/lottie/sun.json';
  switch (mainCondition.toLowerCase()) {
    case 'clouds':
    case 'mist':
    case 'smoke':
    case 'haze':
    case 'dust':
    case 'fog':
      return 'assets/cloud.json';
    case 'rain':
    case 'drizzle':
    case 'shower rain':
      return 'assets/Weather-windy.json';
    case 'thunderstorm':
      return 'assets/storm.json';
    case 'clear':
      return 'assets/sun.json';
    default:
      return 'assets/sun.json';
  }
}
