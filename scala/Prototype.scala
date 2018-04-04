import Spec._
import Undefined._

object Prototype {

  // does the wrong thing if no token, token malformed, or no associated user
  def getUser(req: Request): User = {
    `the user`
  }

  // does the wrong thing if resource not found
  def getResource(req: Request): Resource = {
    `the resource`
  }

  // does the wrong thing if user does not have permission or bad connection
  def execute(content: String, u: User, r: Resource): Unit = {
    `is executed?`
  }

  // does the wrong thing if method is not POST, body is empty, or any of the reasons above
  def handlePost(req: Request): Response = {
    if (req.method != "POST") `halt and catch fire`
    if (req.body.isEmpty) `halt and catch fire`
    val usr = getUser(req)
    val src = getResource(req)
    execute(req.body, usr, src)
    success(req.path, req.body)
  }
}
