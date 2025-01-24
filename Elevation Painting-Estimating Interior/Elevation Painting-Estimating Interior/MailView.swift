import SwiftUI
import MessageUI

struct MailView: View {
    @Binding var isShowing: Bool
    var pdfData: Data

    var body: some View {
        MailComposer(isShowing: $isShowing, pdfData: pdfData)
    }
}

struct MailComposer: UIViewControllerRepresentable {
    @Binding var isShowing: Bool
    var pdfData: Data

    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        @Binding var isShowing: Bool

        init(isShowing: Binding<Bool>) {
            _isShowing = isShowing
        }

        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            isShowing = false
            controller.dismiss(animated: true)
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(isShowing: $isShowing)
    }

    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        let mailComposeVC = MFMailComposeViewController()
        mailComposeVC.mailComposeDelegate = context.coordinator
        mailComposeVC.setToRecipients(["info@elevationpaintingllc.com"])
        mailComposeVC.setSubject("Interior Painting Estimate")
        mailComposeVC.setMessageBody("Attached is the estimate PDF.", isHTML: false)
        mailComposeVC.addAttachmentData(pdfData, mimeType: "application/pdf", fileName: "estimate.pdf")
        return mailComposeVC
    }

    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {}
}
//
//  MailView.swift
//  Elevation Painting-Estimating Interior
//
//  Created by Zach Pillmore on 1/15/25.
//

