//import Kingfisher
//import SwiftUI
//
//@available(iOS 14.0, *)
//struct ListDemo : View {
//
//    var body: some View {
//        List(1 ..< 700) { i in
//            ImageCell(index: i)
//                .frame(height: 300)
//        }.navigationBarTitle(Text("SwiftUI List"), displayMode: .inline)
//    }
//}
//
//@available(iOS 14.0, *)
//struct ImageCell: View {
//
//    var alreadyCached: Bool {
//        ImageCache.default.isCached(forKey: url.absoluteString)
//    }
//
//    let index: Int
//    var url: URL {
//        URL(string: "https://github.com/onevcat/Flower-Data-Set/raw/master/rose/rose-\(index).jpg")!
//    }
//
//    var body: some View {
//        HStack(alignment: .center) {
//            Spacer()
//            KFImage.url(url)
//                .resizable()
//                .onSuccess { r in
//                    print("Success: \(self.index) - \(r.cacheType)")
//                }
//                .onFailure { e in
//                    print("Error \(self.index): \(e)")
//                }
//                .onProgress { downloaded, total in
//                    print("\(downloaded) / \(total))")
//                }
//                .placeholder {
//                    HStack {
//                        Image(systemName: "arrow.2.circlepath.circle")
//                            .resizable()
//                            .frame(width: 50, height: 50)
//                            .padding(10)
//                        Text("Loading...").font(.title)
//                    }
//                    .foregroundColor(.gray)
//                }
//                .fade(duration: 1)
//                .cancelOnDisappear(true)
//                .aspectRatio(contentMode: .fit)
//                .cornerRadius(20)
//
//            Spacer()
//        }.padding(.vertical, 12)
//    }
//
//}
//
//@available(iOS 14.0, *)
//struct SwiftUIList_Previews : PreviewProvider {
//    static var previews: some View {
//        ListDemo()
//    }
//}
