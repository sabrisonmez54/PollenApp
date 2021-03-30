//
//  AboutView.swift
//  PollenApp
//
//  Created by Sabri Sönmez on 3/30/21.
//

import SwiftUI

struct AboutView: View {
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        // #1
        VStack(alignment: .center ) {
            Spacer()
            Image("cover")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(alignment: .center)
                .cornerRadius(10).padding(.leading).padding(.trailing)
            Text("by Sabri Sönmez")
                .font(Font.title2.bold().lowercaseSmallCaps())
                .multilineTextAlignment(.center)
            
//            Spacer(minLength: 20)
            
                Text("This app designed to visualize data collected by Fordham University students led by Professor Guy Robinson PhD.").font(.subheadline).fixedSize(horizontal: false, vertical: true).padding()
                
                Text("There are currently two collection centers, you can switch between them by swiping.").font(.subheadline).fixedSize(horizontal: false, vertical: true).padding()
                
    //            Text("Search, filter, and learn about pollen data around you.")
                Text("Search, filter, and learn about pollen data collected around you.").font(.headline).fixedSize(horizontal: false, vertical: true).padding()
            Spacer()
       
        }.background(colorScheme == .dark ? Color(hexString: "1c1c1e") : Color(.systemBackground)).edgesIgnoringSafeArea(.all)
        .foregroundColor(Color(.label))
        .navigationTitle("About")
        
    }

}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
