object Spec {

  trait User { def token: String }
  trait Resource { def path: String }

  case class Request(
    path: String,
    method: String,
    body: String,
    header: Map[String, String]
  )

  case class Response(code: Int, content: String)

  def success(path: String, body: String): Response =
    Response(200, s"Successfully posted $body to $path")

  val noBody: Response =
    Response(400, "You must provide a request body")

  val noToken: Response =
    Response(401, "You must provide an authorization header field")

  def malformedToken(token: String): Response =
    Response(401, s"Provided token is malformed: $token")

  def noUser(token: String): Response =
    Response(401, s"No user found for token: $token")

  def notPermitted(path: String): Response =
    Response(403, s"You do not have permission on $path")

  def noResource(path: String): Response =
    Response(404, s"No resource found for path: $path")

  def notAllowed(method: String): Response =
    Response(405, s"Method not allowed: $method")

  val badConnection: Response =
    Response(503, "Connection error, please try again later")
}
