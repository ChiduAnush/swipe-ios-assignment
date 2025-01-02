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
    @State private var productType: String = "Electronics"
    @State private var price: String = ""
    @State private var tax: String = ""
    @State private var selectedImage: UIImage? = nil
    
    @State private var showImagePicker: Bool = false
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    
    let productTypes = ["Electronics", "Clothing", "Product",  "Shoes", "Service", "Books", "Home Appliances", "Other"]
    
    var body: some View {
        NavigationView {
            ScrollView {
                
                HStack{
                    Text("Add Product")
                        .font(.system(size: 32))
                        .padding(.top, 30)
                    Spacer()
                }
                .padding(.horizontal)

                
                VStack(spacing: 20) {
                    // Product Details Section
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Product Details")
                            .font(.system(size: 15))
                            .bold()
                            .foregroundStyle(.secondary)
                        
                        // Product Type Picker
                        HStack {
                            Text("Product Type")
//                                .font(.system(size: 14))
                                .foregroundStyle(Color(uiColor: .systemGray2))
                            Spacer()
                            Picker("Product Type", selection: $productType) {
                                ForEach(productTypes, id: \.self) { type in
                                    Text(type).tag(type)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            .accentColor(.primary)
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 11)
                        .background(Color(.secondarySystemBackground).opacity(0.8))
                        .cornerRadius(8)
                        
                        // Product Name TextField
                        TextField("Product Name", text: $productName)
                            .padding()
                            .background(Color(.secondarySystemBackground).opacity(0.8))
                            .cornerRadius(8)
                            .autocapitalization(.words)
                            .padding(.bottom, 15)
                        
                        // Price TextField
                        TextField("Selling Price", text: $price)
                            .padding()
                            .background(Color(.secondarySystemBackground).opacity(0.8))
                            .cornerRadius(8)
                            .keyboardType(.decimalPad)
                        
                        // Tax TextField
                        TextField("Tax Rate", text: $tax)
                            .padding()
                            .background(Color(.secondarySystemBackground).opacity(0.8))
                            .cornerRadius(8)
                            .keyboardType(.decimalPad)
                    }
                    .padding(.horizontal)
                    
                    // Product Image Section
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Product Image (Optional)")
                            .font(.system(size: 15))
                            .bold()
                            .foregroundStyle(.secondary)
                        
                        Button(action: {
                            showImagePicker = true
                        }) {
                            HStack {
                                Image(systemName: "photo")
                                    .foregroundColor(.primary)
                                Text("Select Image")
                                    .foregroundColor(.primary)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(8)
                        }
                        
                        if let image = selectedImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 200)
                                .cornerRadius(8)
                        }
                    }
                    .padding(.horizontal)
                    
                    // Add Product Button
                    Button(action: {
                        validateAndSubmit()
                    }) {
                        Text("Add Product")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 15)
                }
                .padding(.top, 20)
            }
            .navigationTitle("")
//            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    Button("Cancel") {
//                        presentationMode.wrappedValue.dismiss()
//                    }
//                }
//            }
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(image: $selectedImage)
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Message"),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK")) {
                        if alertMessage == "Product added Successfully!" {
//                            resetFields()
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
            alertMessage = "Please enter a valid price, No \",\" allowed"
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
                        resetFields()
                    case .failure(let error):
                        alertMessage = "Failed to add product: \(error.localizedDescription)"
                        showAlert = true
                    }
                }
            }
    }
    
    private func resetFields() {
        productName = ""
        productType = "Electronics"
        price = ""
        tax = ""
        selectedImage = nil
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
                // Check if the image is 1:1 (square)
                if uiImage.size.width == uiImage.size.height {
                    parent.image = uiImage
                } else {
                    let alert = UIAlertController(title: "Invalid Image", message: "Please select a square image (1:1 ratio).", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    picker.present(alert, animated: true)
                    return
                }
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
