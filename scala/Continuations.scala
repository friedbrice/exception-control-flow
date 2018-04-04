import Spec._
import Undefined._

object Continuations {

  def getUser(req: Request)(cont: User => Response): Response = {
    val token = req.header.get("Authorization")
    if (token.isEmpty) noToken else
    if (`malformed token?`) malformedToken(token.get) else
    if (`user not found?`) noUser(token.get) else
    cont(`the user`)
  }

  def getResource(req: Request)(cont: Resource => Response): Response = {
    val path: String = req.path
    if (`resource not found?`) noResource(path) else
    cont(`the resource`)
  }

  def execute(content: String, usr: User, src: Resource)
             (cont: Unit => Response): Response = {
    if (!`is permitted?`) notPermitted(src.path) else
    if (!`is executed?`) badConnection else
    cont(())
  }

  def handlePost(req: Request): Response = {
    if (req.method != "POST") notAllowed(req.method) else
    if (req.body.isEmpty) noBody else
    getUser(req) { usr =>
    getResource(req) { src =>
    execute(req.body, usr, src) { _ =>
    success(req.path, req.body) } } }
  }
}
