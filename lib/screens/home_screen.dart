import 'package:flutter/material.dart';

import '../models/weather.dart';
import '../services/weather_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController controller = TextEditingController();
  final WeatherService weatherService = WeatherService();

  Weather? weather;
  bool isLoading = false;
  String? errorMessage;

  Future<void> fetchWeather() async {
    final city = controller.text.trim();

    if (city.isEmpty) return;

    FocusScope.of(context).unfocus(); // 👈 يقفل الكيبورد

    setState(() {
      isLoading = true;
      errorMessage = null;
      weather = null;
    });

    final result = await weatherService.getWeather(city);

    setState(() {
      isLoading = false;

      if (result == null) {
        errorMessage = "City not found or something went wrong";
      } else {
        weather = result;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF4A90E2),
              Color(0xFF6FB1FC),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),

        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                const Text(
                  "Weather App",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  "Search real-time weather anywhere",
                  style: TextStyle(
                    color: Colors.white70,
                  ),
                ),

                const SizedBox(height: 30),

                // 🔍 Search Field
                TextField(
                  controller: controller,
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    hintText: "Enter city name",
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: fetchWeather,
                    child: const Text("Search"),
                  ),
                ),

                const SizedBox(height: 20),

                // ⏳ Loading
                if (isLoading)
                  const Expanded(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    ),
                  )

                // ❌ Error
                else if (errorMessage != null)
                  Expanded(
                    child: Center(
                      child: Text(
                        errorMessage!,
                        style: const TextStyle(
                          color: Colors.redAccent,
                          fontSize: 18,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )

                // 🌤️ Weather Result
                else if (weather != null)
                  Expanded(
                    child: Center(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // 🌤️ Dynamic Icon
                            Text(
                              weather!.getWeatherIcon(),
                              style: const TextStyle(fontSize: 70),
                            ),

                            const SizedBox(height: 20),

                            Text(
                              weather!.cityName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 10),

                            Text(
                              "${weather!.temperature.toStringAsFixed(0)}°C",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 52,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 10),

                            Text(
                              weather!.description,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 20,
                              ),
                            ),

                            const SizedBox(height: 20),

                            Text(
                              "Humidity: ${weather!.humidity}%",
                              style: const TextStyle(color: Colors.white70),
                            ),

                            Text(
                              "Wind: ${weather!.windSpeed} km/h",
                              style: const TextStyle(color: Colors.white70),
                            ),

                            Text(
                              "Feels like: ${weather!.feelsLike}°C",
                              style: const TextStyle(color: Colors.white70),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )

                // 📭 Empty state
                else
                  const Expanded(
                    child: Center(
                      child: Text(
                        "Enter a city to get weather",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}