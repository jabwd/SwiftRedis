import hiredis

class Redis
{
	private var context: UnsafeMutablePointer<redisContext>? = nil
	init()
	{

	}

	deinit {
		if( context != nil ) {
			redisFree(context!)
			context!.destroy()
		}
	}

	func connect(host: String = "127.0.0.1", port: Int32 = 6379)
	{
		context = UnsafeMutablePointer<redisContext>(redisConnect(host, port))
	}

	func disconnect()
	{
		if( context == nil ) {
			return
		}
		redisFree(context!)
		context = nil
	}

	func set(value: String, key: String) -> Bool
	{
		if( context == nil ) {
			return false
		}

		// TODO: Escape the value / key somehow?
		let reply = UnsafeMutablePointer<redisReply>(setCmd(context!, value, key, value.characters.count))

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

	func get(key: String) -> String?
	{
		if( context == nil ) {
			return nil
		}

		let reply = UnsafeMutablePointer<redisReply>(redisCmd(context!, "GET \(key)"))
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
