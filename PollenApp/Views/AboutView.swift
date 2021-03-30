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
        ZStack {
            if colorScheme == .dark {
                Color(hexString: "1c1c1e")  .ignoresSafeArea()
            } else{  Color(.systemBackground)
                .ignoresSafeArea()
                
            }
                   
                   // Your other content here
                   // Other layers will respect the safe area edges
            VStack {
                Spacer()
                ScrollView {
                    
                    Image("cover")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(alignment: .center)
                        .cornerRadius(10).padding(.leading).padding(.trailing)
                    Text("by Sabri Sönmez")
                        .font(Font.title2.bold())
                        .multilineTextAlignment(.center)
                    
                    
                    VStack(alignment: .leading){
                        Text("This app designed to visualize data collected by Fordham University students led by Professor Guy Robinson PhD.").font(.subheadline).padding().fixedSize(horizontal: false, vertical: true)
                            
                        Text("Search, filter, and learn about pollen data collected around you.").font(.subheadline).padding().fixedSize(horizontal: false, vertical: true)

                    }.padding(.bottom)
                   
                 
                    
                    Text("Check out my other work").font(.headline).fixedSize(horizontal: false, vertical: true).padding()
                    HStack{
                        Link(destination: URL(string: "https://www.linkedin.com/in/sabrisonmez/")!) // <- Add your link here
                        {
                            Image(colorScheme == .dark ? "linkedin-3-512":"linkedInLogo") // <- Change icon to your preferred one
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 60, height: 60)
                                
                                .cornerRadius(10)
                        }.padding()
                        Link(destination: URL(string: "https://github.com/sabrisonmez54")!) // <- Add your link here
                        {
                            Image(colorScheme == .dark ? "GitHub-Mark-Light-120px-plus" : "GitHub-Mark-120px-plus") // <- Change icon to your
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 60, height: 60)
                                
                                .cornerRadius(10)
                        }.padding()
                        Link(destination: URL(string: "https://sabriumut.com/")!) // <- Add your link here
                        {
                            Image("avatar-removebg-preview")
                                .resizable()// <- Change icon to your preferred one
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 60, height: 60)
                                .cornerRadius(10)
                        }.padding()
                    }.padding()
                    
                }
                Spacer()
                
            }
           }
       
        .foregroundColor(Color(.label))
        .navigationTitle("About").background(colorScheme == .dark ? Color(hexString: "1c1c1e") : Color(.systemBackground))
        
        
    }
    
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
