import PackageDescription

let package = Package(
	name:  "SwiftRedis",
	dependencies: [
		.Package(url:  "../RedisC", versions: Version(0,1,0)..<Version(1,0,0))
	]
)
