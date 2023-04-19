//
// ContentView.swift
// FastWeather
//
// Created by Viktor Kulia on 09.04.2023.
//  

import SwiftUI
import CoreLocation

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .padding()
        .onAppear {
            fetchWeatherData()
        }
    }
    
    func fetchWeatherData() {
        let apiService = APIService.shared
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
        CLGeocoder().geocodeAddressString("Paris") { (placemarks, error) in
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
//        apiService.getJSON(urlString: "https://api.openweathermap.org/data/3.0/onecall?lat=50.429290&lon=30.538060&exclude=current,minutely,hourly,alerts&appid=ed336eb9186b44c07aeee17794ed4690", dateDecodingStrategy: .secondsSince1970) { (result: Result<Forecast,APIService.APIError>) in
//            switch result {
//            case .success(let forecast):
//                for day in forecast.daily {
//                    print(dateFormatter.string(from: day.dt))
//                    print("  Max: ", day.temp.max)
//                    print("  Min: ", day.temp.min)
//                    print("  Humidity: ", day.humidity)
//                    print("  Description: ", day.weather[0].description)
//                    print("  Clouds: ", day.clouds)
//                    print("  pop: ", day.pop)
//                    print("  IconURL: ", day.weather[0].weatherIconUrl)
//                }
//            case .failure(let apiError):
//                switch apiError {
//                case .error(let errorString):
//                    print(errorString)
//                }
//            }
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
