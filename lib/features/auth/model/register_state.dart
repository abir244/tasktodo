import 'package:freezed_annotation/freezed_annotation.dart';

part 'register_state.freezed.dart';

@freezed
class RegisterState with _$RegisterState {
  const RegisterState._();

  const factory RegisterState({
    @Default('') String name,
    @Default('') String email,
    @Default('') String phone,
    @Default('') String gender,
    DateTime? dob,
    @Default('') String country,
    @Default('') String state,
    @Default('') String city,
    @Default(false) bool isLoading,
    String? errorMessage,
  }) = _RegisterState;

  bool get isValid {
    return name.isNotEmpty &&
        email.isNotEmpty &&
        _isValidEmail(email) &&
        phone.isNotEmpty &&
        gender.isNotEmpty &&
        dob != null &&
        country.isNotEmpty &&
        state.isNotEmpty &&
        city.isNotEmpty;
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  // Helper methods to get location data
  List<String> getAvailableStates() {
    return LocationData.getStatesForCountry(country);
  }

  List<String> getAvailableCities() {
    return LocationData.getCitiesForState(state);
  }
}

// Location data class - separated for clarity
class LocationData {
  static const List<String> countries = [
    'United States of America',
    'Canada',
    'United Kingdom',
    'India',
    'Bangladesh',
    'Australia',
    'Germany',
    'France',
    'Japan',
    'China',
  ];

  static const Map<String, List<String>> statesByCountry = {
    'United States of America': [
      'California',
      'New York',
      'Texas',
      'Florida',
    ],
    'Bangladesh': ['Dhaka', 'Chittagong', 'Sylhet'],
    'India': ['Maharashtra', 'Karnataka', 'Delhi'],
    'Canada': ['Ontario', 'Quebec', 'British Columbia'],
    'United Kingdom': ['England', 'Scotland', 'Wales'],
    'Australia': ['New South Wales', 'Victoria', 'Queensland'],
    'Germany': ['Bavaria', 'Berlin', 'Hamburg'],
    'France': ['Île-de-France', 'Provence', 'Normandy'],
    'Japan': ['Tokyo', 'Osaka', 'Kyoto'],
    'China': ['Beijing', 'Shanghai', 'Guangdong'],
  };

  static const Map<String, List<String>> citiesByState = {
    // USA
    'California': ['San Diego', 'Los Angeles', 'San Francisco', 'Sacramento'],
    'New York': ['New York City', 'Buffalo', 'Rochester', 'Albany'],
    'Texas': ['Houston', 'Dallas', 'Austin', 'San Antonio'],
    'Florida': ['Miami', 'Orlando', 'Tampa', 'Jacksonville'],

    // Bangladesh
    'Dhaka': ['Dhaka', 'Gazipur', 'Narayanganj', 'Savar'],
    'Chittagong': ['Chittagong', 'Cox\'s Bazar', 'Comilla'],
    'Sylhet': ['Sylhet', 'Moulvibazar', 'Habiganj'],

    // India
    'Maharashtra': ['Mumbai', 'Pune', 'Nagpur', 'Thane'],
    'Karnataka': ['Bangalore', 'Mysore', 'Mangalore'],
    'Delhi': ['New Delhi', 'Old Delhi', 'Dwarka'],

    // Canada
    'Ontario': ['Toronto', 'Ottawa', 'Mississauga', 'Hamilton'],
    'Quebec': ['Montreal', 'Quebec City', 'Laval'],
    'British Columbia': ['Vancouver', 'Victoria', 'Surrey'],

    // UK
    'England': ['London', 'Manchester', 'Birmingham', 'Liverpool'],
    'Scotland': ['Edinburgh', 'Glasgow', 'Aberdeen'],
    'Wales': ['Cardiff', 'Swansea', 'Newport'],

    // Australia
    'New South Wales': ['Sydney', 'Newcastle', 'Wollongong'],
    'Victoria': ['Melbourne', 'Geelong', 'Ballarat'],
    'Queensland': ['Brisbane', 'Gold Coast', 'Cairns'],

    // Germany
    'Bavaria': ['Munich', 'Nuremberg', 'Augsburg'],
    'Berlin': ['Berlin'],
    'Hamburg': ['Hamburg'],

    // France
    'Île-de-France': ['Paris', 'Versailles'],
    'Provence': ['Marseille', 'Nice', 'Cannes'],
    'Normandy': ['Rouen', 'Le Havre'],

    // Japan
    'Tokyo': ['Tokyo', 'Yokohama'],
    'Osaka': ['Osaka', 'Kobe'],
    'Kyoto': ['Kyoto'],

    // China
    'Beijing': ['Beijing'],
    'Shanghai': ['Shanghai'],
    'Guangdong': ['Guangzhou', 'Shenzhen'],
  };

  static List<String> getStatesForCountry(String country) {
    return statesByCountry[country] ?? [];
  }

  static List<String> getCitiesForState(String state) {
    return citiesByState[state] ?? [];
  }
}