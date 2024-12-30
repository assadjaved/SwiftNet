# 🚀 SwiftNet

![Swift](https://img.shields.io/badge/Swift-5.7-orange.svg)
![iOS](https://img.shields.io/badge/iOS-16%2B-blue.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)
![Build](https://img.shields.io/badge/build-passing-brightgreen.svg)

**SwiftNet** is a lightweight and easy-to-use networking library written in Swift. It simplifies the process of making network requests, parsing responses, and handling errors, making your iOS development faster and more efficient.

---

## ✨ Features

- 🔗 **Simple API** for making network requests.
- 🛡️ **Error Handling** with descriptive errors.
- 🚦 **Asynchronous Requests** using `async/await`.
- 💻 **RxSwift Support** using `Single` API.
- 💾 **Decodable Support** for easy JSON decoding.
- 🔒 **HTTPS** ready with configurable headers and authentication.

---

## 📦 Installation

### CocoaPods

Add `SwiftNet` to your `Podfile`:

```ruby
platform :ios, '16.0'
use_frameworks!

target 'YourApp' do
  pod 'SwiftNet', :git => 'https://github.com/assadjaved/SwiftNet.git'
end
```

Then run:

```bash
pod install
```

---

## 🛠️ Initialization

To initialize `SwiftNet`, simply create an instance of it:

```swift
import SwiftNet

let swiftNet: SwiftNetType = SwiftNet()
```

You can also inject this instance into your service layer or dependency injection framework.

---

## 🔑 Authorization

SwiftNet provides **two ways** to set up authorization tokens:

### 1️⃣ **Via Headers**
You can include the authorization token directly in your request headers:

```swift
var headers: [SwiftNetRequestHeader] {
    [.contentType(value: .json),
     .accept(value: .json),
     .authorization(token: "Bearer token")]
}
```

### 2️⃣ **Using SwiftNetAuthorization**
For a centralized approach, you can set authorization globally via `SwiftNetAuthorization`:

```swift
let tokenRepository = SwiftNetTokenRepository(accessToken: "yourAccessToken", refreshToken: "yourRefreshToken")
swiftNet.setHttpAuthorization(
    SwiftNetAuthorization(tokenRepository: tokenRepository)
)
```

This approach ensures that all requests made via `swiftNet` will automatically include the authorization token.

---

## 📚 Creating a Request Object

All requests in **SwiftNet** inherit from `SwiftNetRequest`. Below is an example of GET and POST request objects.

### **BaseToDoRequest**

Define a base request class to avoid duplication:

```swift
import SwiftNet

class BaseToDoRequest<Response: Decodable>: SwiftNetRequest {
    var baseUrl: String { "https://jsonplaceholder.typicode.com" }
    var path: String { fatalError("Override in subclass") }
    var method: SwiftNetRequestMethod { fatalError("Override in subclass") }
    var headers: [SwiftNetRequestHeader] {
        [.contentType(value: .json), .accept(value: .json)]
    }
    var parameters: [SwiftNetRequestParameter] { fatalError("Override in subclass") }

    func decode(data: Data) throws -> Response {
        let decoder = JSONDecoder()
        return try decoder.decode(Response.self, from: data)
    }
}
```

### **GET Request**

```swift
class GetToDoItemRequest: BaseToDoRequest<GetToDoItemDTO> {
    private let id: Int

    init(id: Int) {
        self.id = id
    }

    override var path: String { "todos/\(id)" }
    override var method: SwiftNetRequestMethod { .get }
    override var parameters: [SwiftNetRequestParameter] {
        [.query(key: "foo", value: "bar")]
    }
}

struct GetToDoItemDTO: Decodable {
    let userId: Int
    let id: Int
    let title: String
    let completed: Bool
}
```

### **POST Request**

```swift
class PostToDoItemRequest: BaseToDoRequest<PostToDoItemDTO> {
    private let requestDTO: PostToDoItemRequestDTO

    init(requestDTO: PostToDoItemRequestDTO) {
        self.requestDTO = requestDTO
    }

    override var path: String { "posts" }
    override var method: SwiftNetRequestMethod { .post }
    override var parameters: [SwiftNetRequestParameter] {
        let jsonEncoder = JSONEncoder()
        guard let jsonData = try? jsonEncoder.encode(requestDTO) else { return [] }
        return [.body(data: jsonData)]
    }
}

struct PostToDoItemDTO: Decodable {
    let id: Int
    let title: String
    let body: String
    let userId: Int
}

struct PostToDoItemRequestDTO: Encodable {
    let title: String
    let body: String
    let userId: Int
}
```

---

## 📡 Making API Calls

### 1️⃣ **Using Result (Completion Handler)**

```swift
swiftNet.request(GetToDoItemRequest(id: 1)) { result in
    switch result {
    case .success(let response):
        print("Response:", response)
    case .failure(let error):
        print("Error:", error)
    }
}
```

### 2️⃣ **Using Async/Await**

```swift
Task {
    do {
        let response = try await swiftNet.request(GetToDoItemRequest(id: 1))
        print("Response:", response)
    } catch {
        print("Error:", error)
    }
}
```

### 3️⃣ **Using RxSwift (Single API)**

```swift
import RxSwift

let disposeBag = DisposeBag()

swiftNet.request(GetToDoItemRequest(id: 1))
    .observe(on: MainScheduler.instance)
    .subscribe { response in
        print("Response:", response)
    } onFailure: { error in
        print("Error:", error)
    }
    .disposed(by: disposeBag)
```

---

## 📝 License

This project is licensed under the MIT License.

---

## 🤝 Contributing

Feel free to submit pull requests or open issues on [GitHub](https://github.com/assadjaved/SwiftNet).

---

## 📬 Support

For any questions or feedback, feel free to contact me or open an issue.
