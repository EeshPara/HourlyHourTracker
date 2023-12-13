import VisionKit
import SwiftUI

//scans a picture and saves it
struct ScannerView: UIViewControllerRepresentable {
    
    private let completionHandler: (UIImage?) -> Void
     
    init(completion: @escaping (UIImage?) -> Void) {
        self.completionHandler = completion
    }
     
    typealias UIViewControllerType = VNDocumentCameraViewController
     
    func makeUIViewController(context: UIViewControllerRepresentableContext<ScannerView>) -> VNDocumentCameraViewController {
        let viewController = VNDocumentCameraViewController()
        viewController.delegate = context.coordinator
        viewController.view.tintColor = UIColor(named: "Primary")
        return viewController
    }
     
    func updateUIViewController(_ uiViewController: VNDocumentCameraViewController, context: UIViewControllerRepresentableContext<ScannerView>) {}
     
    func makeCoordinator() -> Coordinator {
        return Coordinator(completion: completionHandler)
    }
     
    final class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {
        private let completionHandler: (UIImage?) -> Void
         
        init(completion: @escaping (UIImage?) -> Void) {
            self.completionHandler = completion
        }
        
         
         func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
            print("Document camera view controller did finish with ", scan)
            let image : UIImage? = scan.imageOfPage(at: 0)
            completionHandler(image)

        }
         
        func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
            print("Camera was canceled")
            completionHandler(nil)
        }
         
        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
            print("Document camera view controller did finish with error ", error)
            completionHandler(nil)
        }
    }
}

