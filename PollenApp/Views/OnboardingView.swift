//
//  OnboardingView.swift
//  PollenApp
//
//  Created by Sabri Sönmez on 3/30/21.
//

import SwiftUI

struct OnboardingView: View {
    var body: some View {
        // #1
        VStack(alignment: .center ){
            Spacer(minLength: 150)
            Image("cover-2")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(alignment: .center)
                .cornerRadius(10).padding(.leading).padding(.trailing)
            Text("by Sabri Sönmez")
                .font(Font.title2.bold())
                .multilineTextAlignment(.center)
            
//            Spacer(minLength: 20)
            
                Text("This app designed to visualize data collected by Fordham University students led by Professor Guy Robinson PhD.").font(.subheadline).fixedSize(horizontal: false, vertical: true).padding()
                
                Text("There are currently two collection centers, you can switch between them by swiping.").font(.subheadline).fixedSize(horizontal: false, vertical: true).padding()
                
    //            Text("Search, filter, and learn about pollen data around you.")
                Text("Search, filter, and learn about pollen data collected around you.").font(.headline).fixedSize(horizontal: false, vertical: true).padding()
            Spacer()
            
         
            
            // #2
            OnboardingButton()
        }
        .background(Color(hexString: "1c1c1e"))
        .foregroundColor(Color(.white))
        .ignoresSafeArea(.all, edges: .all)
        
    }
}

struct OnboardingButton: View {
    
    // #1
    @AppStorage("needsAppOnboarding") var needsAppOnboarding: Bool = true
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        GeometryReader { proxy in
            LazyHStack {
                Button(action: {
                    
                    // #2
                    needsAppOnboarding = false
                }) {
                    Text("Get Started")
                        .padding(.horizontal, 40)
                        .padding(.vertical, 15)
                        .font(Font.title2.bold())
                }
                .background(Color.white)
                .foregroundColor(Color.black)
                .cornerRadius(10)
                .frame(minWidth: 0, maxWidth: proxy.size.width-40)
            }
            .frame(width: proxy.size.width, height: proxy.size.height/1.5)
        }
    }
}
struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
