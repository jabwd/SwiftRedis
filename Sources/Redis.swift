import hiredis

class Redis
{
	private var context: UnsafeMutablePointer<redisContext>? = nil
	init?(host: String = "127.0.0.1", port: Int32 = 6379) {
		context = UnsafeMutablePointer<redisContext>(redisConnect(host, port))

		// In case the connection fails, simply return a nil object.
		if context == nil {
			return nil
		}
	}

	deinit {
		if let context = context {
			redisFree(context)
			context.destroy()
		}
	}

	func set(value: String, key: String) -> Bool {
		guard let context = context else { return false }

		// TODO: Escape the value / key somehow?
		let reply = UnsafeMutablePointer<redisReply>(setCmd(context, value, key, value.characters.count))

		// Cleanup
		defer {
			reply.destroy()
		}

		let status = reply.memory.type
		if( status == REDIS_REPLY_STATUS ) {
			//print("Status response \(String.fromCString(reply.memory.str))")
			return true
		}

		// Handle an error response, otherwise just false
		// Since we don't know what happened.
		if( status == REDIS_REPLY_ERROR ) {
			let errStr = String.fromCString(reply.memory.str)
			if( errStr != nil ) {
				print("[Redis error] \(errStr)")
			} else {
				print("[Redis error] Unknown error occured")
			}
		}
		return false
	}

	func get(key: String) -> String? {
		guard let context = context else { return nil }

		let reply = UnsafeMutablePointer<redisReply>(redisCmd(context, "GET \(key)"))
		let type  = reply.memory.type

		// Don't leak.
		defer {
			reply.destroy()
		}

		switch(type) {
			case REDIS_REPLY_STRING:
				return String.fromCString(reply.memory.str)

			default:
				break
		}
		return nil
		/*if( reply.memory.type == REDIS_REPLY_STATUS ) {
			print("Status response \(String.fromCString(reply.memory.str))")
		} else if( reply.memory.type == REDIS_REPLY_ERROR ) {
			print("Had a redis error \(String.fromCString(reply.memory.str))")
		} else if( reply.memory.type == REDIS_REPLY_INTEGER ) {
			print("Integer reply")
		} else if( reply.memory.type == REDIS_REPLY_NIL ) {
			print("Nil reply")
		} else if( reply.memory.type == REDIS_REPLY_STRING ) {
			print("REPLIED WITH STRING \(String.fromCString(reply.memory.str))")
		} else if( reply.memory.type == REDIS_REPLY_ARRAY ) {
			print("Array reply")
		} else {
			print("Unknown reply")
		}*/
	}
}
