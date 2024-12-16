# 🚀 SwiftNet

![Swift](https://img.shields.io/badge/Swift-5.7-orange.svg)
![iOS](https://img.shields.io/badge/iOS-16%2B-blue.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)
![Build](https://img.shields.io/badge/build-passing-brightgreen.svg)

**SwiftNet** is a lightweight and easy-to-use networking library written in Swift. It simplifies the process of making network requests, parsing responses, and handling errors, making your iOS development faster and more efficient.

---

## ✨ Features

- 🔗 **Simple API** for making network requests.
- 🛡️ **Error Handling** with error descriptions.
- 🚦 **Asynchronous Requests** using `async/await`.
- 💻 **RxSwift Support** using `Single` api.
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
  pod 'SwiftNet', :github => 'https://github.com/assadjaved/SwiftNet.git'
end

