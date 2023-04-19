//
// ForecastModel.swift
// FastWeather
//
// Created by Viktor Kulia on 09.04.2023.
//  

import Foundation

struct Forecast: Codable {
    let daily: [Daily]
}

struct Daily: Codable {
    let dt: Date
    let temp: Temp
    let humidity: Int
    let weather: [Weather]
    let clouds: Int
    let pop: Double
}

struct Temp: Codable {
    let min: Double
    let max: Double
}

struct Weather: Codable {
    let id: Int
    let description: String
    let icon: String
    var weatherIconUrl: URL {
        let urlString = "https://openweathermap.org/img/wn/\(icon)@2x.png"
        return URL(string: urlString)!
    }
}


