### Swipe ios assignment for intern role


App has 2 screens:
- Product List
- Add Product 

App uses Swift UI and MVVM architecture.


#### Features:
- List of products fetched from API
- Search Products by name
- Mark products as favorites. (Saved Locally)
- Add new Product (with validation for all fields)

#### API end points:

For fetching products, GET https://app.getswipe.in/api/public/get
For adding product, POST https://app.getswipe.in/api/public/add


### How to Build and Run:
1. Clone the repo
`git clone https://github.com/your-username/discover-app.git`

2.Open the project in Xcode:
Navigate to the project folder and open Discover.xcodeproj.

3. Build and run the app:
Select a simulator or a physical device.
Click the Run button (or press Cmd + R).


####Project Structure

Discover/
├── APIservice.swift               # Handles network requests
├── Fonts.swift                    # Handles font variable
├── Font/                          
│   ├── SpaceMono-Regular.ttf      # Has the required font
├── Models/
│   ├── Product.swift              # *Product data model*
├── ViewModels/
│   ├── ProductListViewModel.swift # ViewModel for product listing
│   ├── AddProductViewModel.swift  # ViewModel for adding products
├── Views/
│   ├── ProductListView.swift      # Product listing screen(has ui for product card as well)
│   ├── AddProductView.swift       # Add product screen
│   ├── FloatingTabBar.swift       # Tab bar 


###Demo Video:
[Drive Link]([http://example.com](https://drive.google.com/file/d/1ryXVhRY147PmZNMkMP0a7ZoCiGB2c7KH/view?usp=sharing))
