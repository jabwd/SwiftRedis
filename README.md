# SwiftRedis
A redis wrapper around the RedisC hiredis wrapper, giving you an easy to use interface for Swift/Redis

### Reference
`let redis = Redis()`
`redis.connect([host=127.0.0.1], port: [=6379])`

`redis.set(value: String, key: String)`
`redis.get(key: String) -> String?`

More to follow later, the API is very basic at the moment but should make it easy to connect to Redis for now.

### Planned for the future:

* Serialization support
* Support for Arrays/Integer values form Redis directly
* Better error handling
