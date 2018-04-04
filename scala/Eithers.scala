import Spec._
import Undefined._

object Eithers {

  def failIf[A](p: Boolean, a: => A): Either[A, Unit] =
    if (p) Left(a) else Right(())

  def getUser(req: Request): Either[Response, User] = for {
    token <- req.header.get("Authorization").toRight(noToken)
    _     <- failIf(`malformed token?`, malformedToken(token))
    _     <- failIf(`user not found?`, noUser(token))
  } yield `the user`

  def getResource(req: Request): Either[Response, Resource] = for {
    path <- Right(req.path)
    _    <- failIf(`resource not found?`, noResource(path))
  } yield `the resource`

  def execute(content: String, usr: User, src: Resource):
  Either[Response, Unit] = for {
    _ <- failIf(! `is permitted?`, notPermitted(src.path))
    _ <- failIf(! `is executed?`, badConnection)
  } yield {}

  def handlePost(req: Request): Response = {
    for {
      _   <- failIf(req.method != "POST", notAllowed(req.method))
      _   <- failIf(req.body.isEmpty, noBody)
      usr <- getUser(req)
      src <- getResource(req)
      _   <- execute(req.body, usr, src)
    } yield success(req.path, req.body)
  }.fold(identity, identity)
}
