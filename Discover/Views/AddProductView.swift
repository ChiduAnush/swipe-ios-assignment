//
//  AddProductView.swift
//  Discover
//
//  Created by ChiduAnush on 02/01/25.
//

import SwiftUI

struct AddProductView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var productName: String = ""
    @State private var productType: String = ""
    @State private var price: String = ""
    @State private var tax: String = ""
    @State private var selectedImage: UIImage? = nil
    @State private var showImagePicker: Bool = false
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    
    let productTypes = ["Electronics", "Clothing", "Books", "Home & Kitchen", "Other"]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Product Details")) {
                    Picker("Product Type", selection: $productType) {
                        ForEach(productTypes, id: \.self) { type in
                            Text(type).tag(type)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    
                    TextField("Product Name", text: $productName)
                        .autocapitalization(.words)
                    
                    TextField("Selling Price", text: $price)
                        .keyboardType(.decimalPad)
                    
                    TextField("Tax Rate", text: $tax)
                        .keyboardType(.decimalPad)
                }
                
                Section(header: Text("Product Image (Optional)")) {
                    Button(action: {
                        showImagePicker = true
                    }) {
                        HStack {
                            Image(systemName: "photo")
                            Text("Select Image")
                        }
                    }
                    
                    if let image = selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                            .cornerRadius(8)
                    }
                }
                
                Section {
                    Button(action: {
                        validateAndSubmit()
                    }) {
                        HStack {
                            Spacer()
                            Text("Add Product")
                                .font(.headline)
                                .foregroundColor(.white)
                            Spacer()
                        }
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                    }
                }
            }
            .navigationTitle("Add Product")
            .navigationBarItems(trailing: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(image: $selectedImage)
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Message"),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK")) {
                        if alertMessage == "Product added Successfully!" {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                )
            }
        }
    }
    
    private func validateAndSubmit() {
        guard !productType.isEmpty else {
            alertMessage = "Please select a product type."
            showAlert = true
            return
        }
        
        guard !productName.isEmpty else {
            alertMessage = "Please enter a product name."
            showAlert = true
            return
        }
        
        guard let priceValue = Double(price), priceValue > 0 else {
            alertMessage = "Please enter a valid selling price."
            showAlert = true
            return
        }
        
        guard let taxValue = Double(tax), taxValue >= 0 else {
            alertMessage = "Please enter a valid tax rate."
            showAlert = true
            return
        }
        
        // Convert the selected image to a base64 string
        let imageBase64 = selectedImage?.jpegData(compressionQuality: 0.8)?.base64EncodedString()
        
        let product = Product(productName: productName, productType: productType, price: priceValue, tax: taxValue, image: imageBase64)
        
        APIservice.shared.addProduct(product: product) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let message):
                    alertMessage = message
                    showAlert = true
                case .failure(let error):
                    alertMessage = "Failed to add product: \(error.localizedDescription)"
                    showAlert = true
                }
            }
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Environment(\.presentationMode) var presentationMode
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

struct AddProductView_Previews: PreviewProvider {
    static var previews: some View {
        AddProductView()
    }
}
