//
//  WebImageView.swift
//  Square
//
//  Created by MacDev1 on 2/8/23.
//

import SwiftUI

struct WebImageView: View {
    var urlString: String
    var imageIdentify: String
    
    @ObservedObject var imageService = ImageDownloadSerive()
    @State var image: UIImage = UIImage()
    
    var body: some View {
        Image(uiImage: image)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 100, height: 100)
            .onReceive(imageService.$image) {image in
                self.image = image
            }
            .onAppear{
                imageService.loadImage(urlString: urlString, completion: {})
            }
    }
}

struct WebImageView_Previews: PreviewProvider {
    static var previews: some View {
        WebImageView(urlString:"", imageIdentify: "")
    }
}
