//
//  AddProductView.swift
//  Discover
//
//  Created by ChiduAnush on 02/01/25.
//


import SwiftUI

struct AddProductView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel = AddProductViewModel()
    @State private var showImagePicker: Bool = false
    
    var parentViewModel: ProductListViewModel?
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    HStack {
                        Text("Add Product")
                            .font(.system(size: 32))
                            .padding(.top, 30)
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    // Product Type Picker
                    HStack {
                        Text("Product Type")
                            .foregroundStyle(Color(uiColor: .systemGray2))
                        Spacer()
                        Picker("Product Type", selection: $viewModel.productType) {
                            ForEach(viewModel.productTypes, id: \.self) { type in
                                Text(type).tag(type)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .accentColor(.primary)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                    .background(Color(.secondarySystemBackground).opacity(0.8))
                    .cornerRadius(8)
                    .padding(.horizontal)
                    
                    // Product Name TextField
                    TextField("Product Name", text: $viewModel.productName)
                        .padding()
                        .background(Color(.secondarySystemBackground).opacity(0.8))
                        .cornerRadius(8)
                        .padding(.horizontal)
                        .padding(.bottom, 15)
                    
                    // Price TextField
                    TextField("Selling Price", text: $viewModel.price)
                        .padding()
                        .background(Color(.secondarySystemBackground).opacity(0.8))
                        .cornerRadius(8)
                        .keyboardType(.decimalPad)
                        .padding(.horizontal)
                    
                    // Tax TextField
                    TextField("Tax Rate", text: $viewModel.tax)
                        .padding()
                        .background(Color(.secondarySystemBackground).opacity(0.8))
                        .cornerRadius(8)
                        .keyboardType(.decimalPad)
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
                        
                        if let image = viewModel.selectedImage {
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
                        viewModel.validateAndSubmit { success in
                            if success {
                                // Refresh the product list in the parent view
                                if let parentViewModel = parentViewModel {
                                    parentViewModel.fetchProducts()
                                }
                                presentationMode.wrappedValue.dismiss()
                            }
                        }
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
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(image: $viewModel.selectedImage)
            }
            .alert(isPresented: $viewModel.showAlert) {
                Alert(
                    title: Text("Message"),
                    message: Text(viewModel.alertMessage),
                    dismissButton: .default(Text("OK")) {
                        if viewModel.alertMessage == "Product added Successfully!" {
                            
                            parentViewModel?.fetchProducts()
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                )
            }
        }
    }
}

// MARK: - Image Picker
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
