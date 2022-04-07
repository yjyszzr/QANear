//
//  ViewController.swift
//  Example
//
//  Created by long on 2020/8/11.
//
import UIKit
import ZLPhotoBrowser
import Photos

class ViewController: UIViewController {

    var collectionView: UICollectionView!
    
    var selectedImages: [UIImage] = []
    
    var selectedAssets: [PHAsset] = []
    
    var isOriginal = false
    
    var takeSelectedAssetsSwitch: UISwitch!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTry()
    }
    
    func tt(){
        let layout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
        collectionView.register(ImageCell.classForCoder(), forCellWithReuseIdentifier: "ImageCell")
        
        showImagePicker(true)
    }
    
    func setupTry(){
        title = "Main"
        self.view.backgroundColor = .white
        
        func createBtn(_ title: String, _ action: Selector) -> UIButton {
            let btn = UIButton(type: .custom)
            btn.setTitle(title, for: .normal)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            btn.addTarget(self, action: action, for: .touchUpInside)
            btn.backgroundColor = .black
            btn.layer.cornerRadius = 5
            btn.layer.masksToBounds = true
            return btn
        }
        
        let libratySelectBtn = createBtn("Library selection", #selector(librarySelectPhoto))
        view.addSubview(libratySelectBtn)
        libratySelectBtn.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.top.equalTo(view.snp.topMargin).offset(20)
            } else {
                make.top.equalTo(topLayoutGuide.snp.bottom).offset(20)
            }
            
            make.left.equalToSuperview().offset(30)
        }
        
        let saveBtn = createBtn("save btn", #selector(saveMedia))
        view.addSubview(saveBtn)
        saveBtn.snp.makeConstraints { (make) in
            make.left.equalTo(libratySelectBtn.snp.left)
            make.top.equalTo(libratySelectBtn.snp.bottom).offset(20)

        }
        
        let takeLabel = UILabel()
        takeLabel.font = UIFont.systemFont(ofSize: 14)
        takeLabel.textColor = .black
        takeLabel.text = "Record selected photos："
        view.addSubview(takeLabel)
        takeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(saveBtn.snp.left)
            make.top.equalTo(saveBtn.snp.bottom).offset(20)
        }
        
        takeSelectedAssetsSwitch = UISwitch()
        takeSelectedAssetsSwitch.isOn = false
        view.addSubview(takeSelectedAssetsSwitch)
        takeSelectedAssetsSwitch.snp.makeConstraints { (make) in
            make.left.equalTo(takeLabel.snp.right).offset(20)
            make.centerY.equalTo(takeLabel.snp.centerY)
        }
        
        let layout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(takeSelectedAssetsSwitch.snp.bottom).offset(30)
            make.left.bottom.right.equalToSuperview()
        }

        collectionView.register(ImageCell.classForCoder(), forCellWithReuseIdentifier: "ImageCell")
    }
    
    @objc func configureClick() {
        let vc = PhotoConfigureViewController()
        showDetailViewController(vc, sender: nil)
    }
    
    @objc func cn_configureClick() {
        let vc = PhotoConfigureCNViewController()
        showDetailViewController(vc, sender: nil)
    }
    
    @objc func previewSelectPhoto() {
        showImagePicker(true)
    }
    
    @objc func librarySelectPhoto() {
        showImagePicker(false)
    }
  
    //        for index in selectedImages{
    //            var s = UUID().uuidString
    //            MyClass.sampleCategoryMethod("xxXHW2KyCJ53aRsSlBG1VP_YVpI5WmZyb85mlF43:RvFnpiDv8_vZAig9f6Ic04W9qN4=:eyJzY29wZSI6InJlZGZydWl0IiwiZGVhZGxpbmUiOjE2NDE1Mzg2MjV9",picName:s,uploaddata: index.jpegData(compressionQuality: 0.8))
    //
    //        }
    
    @objc func saveMedia(){
        for index in selectedImages{
            let s = UUID().uuidString
            MyClass.sampleCategoryMethod("xxXHW2KyCJ53aRsSlBG1VP_YVpI5WmZyb85mlF43:RvFnpiDv8_vZAig9f6Ic04W9qN4=:eyJzY29wZSI6InJlZGZydWl0IiwiZGVhZGxpbmUiOjE2NDE1Mzg2MjV9",picName:s,uploaddata: index.jpegData(compressionQuality: 0.8))

        }
        print("test")
       // SaveQuestionCommand(comment: "", imgArr: "",  uploaddata: selectedImages, picName: "")
    }
    
    @objc class SwiftObject: NSObject {
        func s1(){
            //SaveQuestionCommand(comment: "", imgArr: "",  uploaddata: selectedImages, picName: "")
        }
    }
    
    func showImagePicker(_ preview: Bool) {
        let editImageConfiguration = ZLPhotoConfiguration.default().editImageConfiguration
        editImageConfiguration
            .imageStickerContainerView(ImageStickerContainerView())
//            .tools([.draw, .filter, .adjust, .mosaic])
//            .adjustTools([.brightness, .contrast, .saturation])
//            .clipRatios([.custom, .circle, .wh1x1, .wh3x4, .wh16x9, ZLImageClipRatio(title: "2 : 1", whRatio: 2 / 1)])
//            .imageStickerContainerView(ImageStickerContainerView())
//            .filters([.normal, .process, ZLFilter(name: "custom", applier: ZLCustomFilter.hazeRemovalFilter)])
        
        ZLPhotoConfiguration.default()
            .editImageConfiguration(editImageConfiguration)
            .navCancelButtonStyle(.image)
            // You can first determine whether the asset is allowed to be selected.
            .canSelectAsset { asset in
                return true
            }
            .noAuthorityCallback { type in
                switch type {
                case .library:
                    debugPrint("No library authority")
                case .camera:
                    debugPrint("No camera authority")
                case .microphone:
                    debugPrint("No microphone authority")
                }
            }
        
        let ac = ZLPhotoPreviewSheet(selectedAssets: selectedAssets )
        ac.selectImageBlock = { [weak self] (images, assets, isOriginal) in
            self?.selectedImages = images
            self?.selectedAssets = assets
            self?.isOriginal = isOriginal
            self?.collectionView.reloadData()
            debugPrint("\(images)   \(assets)   \(isOriginal)")
        }
        ac.cancelBlock = {
            debugPrint("cancel select")
        }
        ac.selectImageRequestErrorBlock = { (errorAssets, errorIndexs) in
            debugPrint("fetch error assets: \(errorAssets), error indexs: \(errorIndexs)")
        }
        
        if preview {
            ac.showPreview(animate: true, sender: self)
        } else {
            ac.showPhotoLibrary(sender: self)
        }
    }
    
    @objc func previewLocalAndNetImage() {
        var datas: [Any] = []
        // network image
        datas.append(URL(string: "https://cdn.pixabay.com/photo/2020/10/14/18/35/sign-post-5655110_1280.png")!)
        datas.append(URL(string: "https://pic.netbian.com/uploads/allimg/190518/174718-1558172838db13.jpg")!)
        datas.append(URL(string: "http://5b0988e595225.cdn.sohucs.com/images/20190420/1d1070881fd540db817b2a3bdd967f37.gif")!)
        datas.append(URL(string: "https://cdn.pixabay.com/photo/2019/11/08/11/56/cat-4611189_1280.jpg")!)
        
        // network video
        let netVideoUrlString = "https://freevod.nf.migu.cn/mORsHmtum1AysKe3Ry%2FUb5rA1WelPRwa%2BS7ylo4qQCjcD5a2YuwiIC7rpFwwdGcgkgMxZVi%2FVZ%2Fnxf6NkQZ75HC0xnJ5rlB8UwiH8cZUuvErkVufDlxxLUBF%2FIgUEwjiq%2F%2FV%2FoxBQBVMUzAZaWTvOE5dxUFh4V3Oa489Ec%2BPw0IhEGuR64SuKk3MOszdFg0Q/600575Y9FGZ040325.mp4?msisdn=2a257d4c-1ee0-4ad8-8081-b1650c26390a&spid=600906&sid=50816168212200&timestamp=20201026155427&encrypt=70fe12c7473e6d68075e9478df40f207&k=dc156224f8d0835e&t=1603706067279&ec=2&flag=+&FN=%E5%B0%86%E6%95%85%E4%BA%8B%E5%86%99%E6%88%90%E6%88%91%E4%BB%AC"
        datas.append(URL(string: netVideoUrlString)!)
        
        // phasset
        if takeSelectedAssetsSwitch.isOn {
            datas.append(contentsOf: selectedAssets)
        }
        
        // local image
        datas.append(contentsOf:
            (1...3).compactMap { UIImage(named: "image" + String($0)) }
        )
        
        let videoSuffixs = ["mp4", "mov", "avi", "rmvb", "rm", "flv", "3gp", "wmv", "vob", "dat", "m4v", "f4v", "mkv"] // and more suffixs
        let vc = ZLImagePreviewController(datas: datas, index: 0, showSelectBtn: true) { (url) -> ZLURLType in
            // Just for demo.
            if url.absoluteString == netVideoUrlString {
                return .video
            }
            if let sf = url.absoluteString.split(separator: ".").last, videoSuffixs.contains(String(sf)) {
                return .video
            } else {
                return .image
            }
        } urlImageLoader: { (url, imageView, progress, loadFinish) in
            imageView.kf.setImage(with: url) { (receivedSize, totalSize) in
                let percentage = (CGFloat(receivedSize) / CGFloat(totalSize))
                debugPrint("\(percentage)")
                progress(percentage)
            } completionHandler: { (_) in
                loadFinish()
            }
        }
        
        vc.doneBlock = { (datas) in
            debugPrint(datas)
        }
        
        vc.modalPresentationStyle = .fullScreen
        showDetailViewController(vc, sender: nil)
    }
    
    @objc func showCamera() {
        let camera = ZLCustomCamera()
        camera.takeDoneBlock = { [weak self] (image, videoUrl) in
            self?.save(image: image, videoUrl: videoUrl)
        }
        showDetailViewController(camera, sender: nil)
    }
    
    func save(image: UIImage?, videoUrl: URL?) {
        let hud = ZLProgressHUD(style: ZLPhotoConfiguration.default().hudStyle)
        if let image = image {
            hud.show()
            ZLPhotoManager.saveImageToAlbum(image: image) { [weak self] (suc, asset) in
                if suc, let at = asset {
                    self?.selectedImages = [image]
                    self?.selectedAssets = [at]
                    self?.collectionView.reloadData()
                } else {
                    debugPrint("保存图片到相册失败")
                }
                hud.hide()
            }
        } else if let videoUrl = videoUrl {
            hud.show()
            ZLPhotoManager.saveVideoToAlbum(url: videoUrl) { [weak self] (suc, asset) in
                if suc, let at = asset {
                    self?.fetchImage(for: at)
                } else {
                    debugPrint("保存视频到相册失败")
                }
                hud.hide()
            }
        }
    }
    
    func fetchImage(for asset: PHAsset) {
        let option = PHImageRequestOptions()
        option.resizeMode = .fast
        option.isNetworkAccessAllowed = true
        
        PHImageManager.default().requestImage(for: asset, targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFill, options: option) { (image, info) in
            var downloadFinished = false
            if let info = info {
                downloadFinished = !(info[PHImageCancelledKey] as? Bool ?? false) && (info[PHImageErrorKey] == nil)
            }
            let isDegraded = (info?[PHImageResultIsDegradedKey] as? Bool ?? false)
            if downloadFinished, !isDegraded {
                self.selectedImages = [image!]
                self.selectedAssets = [asset]
                self.collectionView.reloadData()
            }
        }
    }
    
    @objc func createWeChatMomentDemo() {
        let vc = WeChatMomentDemoViewController()
        show(vc, sender: nil)
    }
    
}


extension ViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var columnCount: CGFloat = (UI_USER_INTERFACE_IDIOM() == .pad) ? 6 : 4
        if UIApplication.shared.statusBarOrientation.isLandscape {
            columnCount += 2
        }
        let totalW = collectionView.bounds.width - (columnCount - 1) * 2
        let singleW = totalW / columnCount
        return CGSize(width: singleW, height: singleW)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
        
        cell.imageView.image = selectedImages[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let ac = ZLPhotoPreviewSheet()
        ac.selectImageBlock = { [weak self] (images, assets, isOriginal) in
            self?.selectedImages = images
            self?.selectedAssets = assets
            self?.isOriginal = isOriginal
            self?.collectionView.reloadData()
            debugPrint("\(images)   \(assets)   \(isOriginal)")
        }
        
        ac.previewAssets(sender: self, assets: selectedAssets, index: indexPath.row, isOriginal: isOriginal, showBottomViewAndSelectBtn: true)
    }
    
}
