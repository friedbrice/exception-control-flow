import Spec._
import Undefined._

object Eithers {

  def failIf[A](p: Boolean, a: => A): Either[A, Unit] =
    if (p) Left(a) else Right(())

  def getUser(req: Request): Either[Response, User] = for {
    token <- req.header.get("Authorization").toRight(noToken).right
    _     <- failIf(`malformed token?`, malformedToken(token)).right
    _     <- failIf(`user not found?`, noUser(token)).right
  } yield `the user`

  def getResource(req: Request): Either[Response, Resource] = for {
    path <- Right(req.path).right
    _    <- failIf(`resource not found?`, noResource(path)).right
  } yield `the resource`

  def execute(content: String, usr: User, src: Resource):
  Either[Response, Unit] = for {
    _ <- failIf(! `is permitted?`, notPermitted(src.path)).right
    _ <- failIf(! `is executed?`, badConnection).right
  } yield {}

  def handlePost(req: Request): Response = {
    for {
      _   <- failIf(req.method != "POST", notAllowed(req.method)).right
      _   <- failIf(req.body.isEmpty, noBody).right
      usr <- getUser(req).right
      src <- getResource(req).right
      _   <- execute(req.body, usr, src).right
    } yield success(req.path, req.body)
  }.fold(identity, identity)
}
