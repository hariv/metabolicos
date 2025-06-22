//
//  MainViewGlucoseAlertView.swift
//  BioKernel
//
//

import SwiftUI

struct MainViewGlucoseAlertView: View {
    let alertString: String
    var body: some View {
        VStack {
            Text(alertString)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(AppColors.yellow)
        .foregroundColor(.black)
        .bold()
    }
}

#Preview {
    MainViewGlucoseAlertView(alertString: "Testing")
}
