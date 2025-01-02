//
//  TproductCard.swift
//  Discover
//
//  Created by ChiduAnush on 02/01/25.
//

import SwiftUI

struct TproductCard: View {
    
//    func bleh (){
//        printSystemFonts()
//    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 20) {
                
                HStack(alignment: .bottom, spacing: 5){
                    Text("999")
                        .font(.custom(Fonts.SpaceMonoRegular, size: 40))
                        .fontWeight(.regular)
                        .foregroundColor(.black)
                    Text("$")
                        .font(.system(size: 20))
                        .padding(.bottom, 10)
                }
                
                
                
                VStack(alignment: .leading, spacing: 5){
                    Text("Product Name")
                        .font(.system(size: 20))
                        .foregroundColor(.black)
                    
                    HStack(spacing: 15) {
                        
                        HStack(spacing: 5){
                            Image(systemName: "number")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 13, height: 13)
                                .foregroundColor(.gray)
                                .bold()
                            Text("Product")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        
                        HStack(spacing: 5){
                            Image(systemName: "doc.text.image")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 16, height: 16)
                                .foregroundColor(.gray)
//                                .bold()
                            Text("3.0")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            Spacer()
            RoundedRectangle(cornerRadius: 0)
                .fill(Color.gray.opacity(0.1))
                .frame(width: 125, height: 125)
//                .onTapGesture(perform: {
//                    bleh()
//                })
        }
        .padding()
//        .background(
//            RoundedRectangle(cornerRadius: 16)
//                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
//                .background(
//                    RoundedRectangle(cornerRadius: 16)
//                        .fill(Color.white)
//                )
//        )
        .padding()
    }
}


#Preview {
    TproductCard()
}
