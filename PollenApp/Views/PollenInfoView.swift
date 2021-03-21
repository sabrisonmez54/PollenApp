//
//  TipsView.swift
//  Trekr
//
//  Created by Paul Hudson on 22/12/2020.
//

import SwiftUI

struct PollenInfoView: View {
    let pollens: [PollenInfo]

    init() {
        let url = Bundle.main.url(forResource: "pollenInfo", withExtension: "json")!
        let data = try! Data(contentsOf: url)
        pollens = try! JSONDecoder().decode([PollenInfo].self, from: data)
    }

    var body: some View {
        List(pollens, id: \.text, children: \.children) { tip in
            if tip.children != nil {
                Label(tip.text, systemImage: "quote.bubble")
                    .font(.headline)
            } else {
                Text(tip.text)
            }
        }
        .navigationTitle("Pollen Types")
    }
}

struct TipsView_Previews: PreviewProvider {
    static var previews: some View {
        PollenInfoView()
    }
}
