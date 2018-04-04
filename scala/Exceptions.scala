import Spec._
import Undefined._

object Exceptions {

  case class NoTokenProvided() extends Exception
  case class MalformedToken(token: String) extends Exception
  case class NoUserFound(token: String) extends Exception

  @throws[NoTokenProvided]
  @throws[MalformedToken]
  @throws[NoUserFound]
  def getUser(req: Request): User = {
    val token = req.header.get("Authorization")
    if (token.isEmpty) throw NoTokenProvided()
    if (`malformed token?`) throw MalformedToken(token.get)
    if (`user not found?`) throw NoUserFound(token.get)
    `the user`
  }

  case class NoResourceFound(path: String) extends Exception

  @throws[NoResourceFound]
  def getResource(req: Request): Resource = {
    lazy val path: String = req.path
    if (`resource not found?`) throw NoResourceFound(path)
    `the resource`
  }

  case class NotPermitted(path: String) extends Exception
  case class BadConnection() extends Exception

  @throws[NotPermitted]
  @throws[BadConnection]
  def execute(content: String, usr: User, src: Resource): Unit = {
    if (! `is permitted?`) throw NotPermitted(src.path)
    if (! `is executed?`) throw BadConnection()
  }

  case class MethodNotAllowed(method: String) extends Exception
  case class NoBodyProvided() extends Exception

  @throws[MethodNotAllowed]
  @throws[NoBodyProvided]
  def checkPreconditions(req: Request): Unit = {
    if (req.method != "POST") throw MethodNotAllowed(req.method)
    if (req.body.isEmpty) throw NoBodyProvided()
  }

  def handlePost(req: Request): Response = try {
    checkPreconditions(req)
    val user = getUser(req)
    val resource = getResource(req)
    execute(req.body, user, resource)
    success(req.path, req.body)
  } catch {
    case MethodNotAllowed(method) => notAllowed(method)
    case NoBodyProvided() => noBody
    case NoTokenProvided() => noToken
    case MalformedToken(token) => malformedToken(token)
    case NoUserFound(token) => noUser(token)
    case NoResourceFound(path) => noResource(path)
    case NotPermitted(path) => notPermitted(path)
    case BadConnection() => badConnection
  }
}
