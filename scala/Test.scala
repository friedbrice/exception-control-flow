import Spec._

object Test extends App {

  val request1 = Request("path", "POST", "", Map("Authorization" -> "hunter2"))
  val request2 = Request("path", "POST", "body", Map("Nope" -> "nada"))
  val request3 = Request("path", "FOO", "body", Map("Authorization" -> "hunter2"))

  val expected1: Response = noBody
  val expected2: Response = noToken
  val expected3: Response = notAllowed("FOO")

  def assert(msg: String, p: Boolean): Unit =
    if (p) println(s"    Passed: $msg") else throw new Exception(msg)

  def testHandler(name: String, handler: Request => Response): Unit = {
    println(s"Testing $name:")

    def testCase(desc: String, input: Request, expected: Response): Unit = {
      val actual = handler(input)
      println(s"    $actual")
      assert(desc, actual == expected)
    }

    testCase("should handle requests with no body", request1, expected1)
    testCase("should handle requests with no auth", request2, expected2)
    testCase("should handle requests with wrong method", request3, expected3)

    println("Passed.\n")
  }

  println("\nRunning Test Suite\n")
  testHandler("Exceptions", Exceptions.handlePost)
  testHandler("Continuations", Continuations.handlePost)
  testHandler("Eithers", Eithers.handlePost)
  println("All tests pass.\n")
}
