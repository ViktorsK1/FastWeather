//
// ContentView.swift
// FastWeather
//
// Created by Viktor Kulia on 09.04.2023.
//  

import SwiftUI
import CoreLocation

struct ContentView: View {
    @State private var location: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    TextField("Eneter Location", text: $location)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Button {
                        fetchWeatherData(for: location)
                    } label: {
                        Image(systemName: "magnifyingglass.circle.fill")
                            .font(.title3)
                    }
                }
                Spacer()
            }
            .padding(.horizontal)
            .navigationTitle("Mobile Weather")
        }
    }
    
    func fetchWeatherData(for location: String) {
        let apiService = APIService.shared
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
        CLGeocoder().geocodeAddressString(location) { (placemarks, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            if let lat = placemarks?.first?.location?.coordinate.latitude,
               let lon = placemarks?.first?.location?.coordinate.longitude {
                apiService.getJSON(urlString: "https://api.openweathermap.org/data/3.0/onecall?lat=\(lat)&lon=\(lon)&exclude=current,minutely,hourly,alerts&appid=ed336eb9186b44c07aeee17794ed4690", dateDecodingStrategy: .secondsSince1970) { (result: Result<Forecast,APIService.APIError>) in
                    switch result {
                    case .success(let forecast):
                        for day in forecast.daily {
                            print(dateFormatter.string(from: day.dt))
                            print("  Max: ", day.temp.max)
                            print("  Min: ", day.temp.min)
                            print("  Humidity: ", day.humidity)
                            print("  Description: ", day.weather[0].description)
                            print("  Clouds: ", day.clouds)
                            print("  pop: ", day.pop)
                            print("  IconURL: ", day.weather[0].weatherIconUrl)
                        }
                    case .failure(let apiError):
                        switch apiError {
                        case .error(let errorString):
                            print(errorString)
                        }
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
