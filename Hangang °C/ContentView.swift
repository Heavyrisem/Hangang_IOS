//
//  ContentView.swift
//  Hangang °C
//
//  Created by 표인수 on 2021/02/17.
//

import SwiftUI

struct ContentView: View {
    @State var CurrentTemp: String = "Loading.."
    var body: some View {
        VStack {
            Text("현재 한강의 온도는")
            Text("\(CurrentTemp)").font(.largeTitle)
        }.onAppear(perform: {
            GetHangangTemp()
        })
    }
        
    func GetHangangTemp() {
        print("Requesting")
        let url = URL(string: "https://api.qwer.pw/request/hangang_temp?apikey=guest")
        
        let session = URLSession.shared
        var request: URLRequest = URLRequest(url: url!)
        
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        session.dataTask(with: request, completionHandler: {Data, URLResponse, Error in
            guard let data = Data else {
                CurrentTemp = "오류가 발생했습니다."
                return
            }
            let decoder = JSONDecoder()
            
            do {
                let json = try decoder.decode([HangangAPI].self, from: data)
                if json[1].respond?.temp != nil {
                    CurrentTemp = json[1].respond!.temp + " °C"
                    print("Temp is " + CurrentTemp)
                }
            } catch {
                print("err", error)
                CurrentTemp = "오류가 발생했습니다."
            }
            
//            print(String(data: data, encoding: .utf8)!)
        }).resume()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct HangangAPI: Codable {
    var result: String?
    var respond: Respond?
    
    struct Respond: Codable {
        var temp: String
        var location: String
        var year: String
        var month: String
        var day: String
        var time: String
    }
}

enum TestError: Error {
    case Test
}
