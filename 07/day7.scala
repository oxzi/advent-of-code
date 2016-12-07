import io.Source

/** A representation of an IP address v7.
  * 
  * @param addr The address given as a String
  */
case class IPAddress(addr: String) {
  // Type aliases for below‥
  private type AddrP=List[String]
  private type Addr=(AddrP, AddrP)

  // Two lists of sequences in and out of square brackets
  private lazy val (free, enclosed): Addr = divideAddr(addr, Nil, Nil)

  /** Does this IP address v7 support Transport-layer snooping?
    *
    * @return Does it?
    */
  lazy val supportsTLS: Boolean =
    enclosed.forall(!containsAbba(_)) && free.exists(containsAbba)

  /** Does this IP address v7 support super-secret listening?
    *
    * @return Does it?
    */
  lazy val supportsSSL: Boolean =
    free.exists(containsAbaBab(_, enclosed))

  /** A method which separates the areas in square brackets and the not
    * enclosed areas in two different Lists (see: Addr).
    *
    * @param in String to be analyzed
    * @param free List of 'free' address parts
    * @param enclosed List of address parts in square brackets
    * @return Tuple of list of address parts
    */
  private def divideAddr(in: String, free: AddrP, enclosed: AddrP): Addr = {
    val PartRE = "([a-z]+)\\[([a-z]+)\\](.*)".r
    in match {
      case PartRE(f, e, rest) => divideAddr(rest, f :: free, e :: enclosed)
      case _ => (in :: free, enclosed)
    }
  }

  /** An Autonomous Bridge Bypass Annotation (ABBA) is any four-character
    * sequence which consists of a pair of two different characters followed
    * by the reverse of that pair.
    * This method checks the input for the specification above.
    *
    * @param in String to be checked
    * @return True if 'in' is an ABBA
    */
  private def isAbba(in: String): Boolean =
    in.length == 4 &&
    in.substring(0, 2) == in.substring(2, 4).reverse &&
    in(0) != in(1)

  /** This method slides a window over the given input to check if there is
    * an ABBA inside.
    *
    * @param in String to be checked
    * @return True if an ABBA was found
    */
  private def containsAbba(in: String): Boolean =
    if(in.length < 4) false
    else isAbba(in.substring(0, 4)) || containsAbba(in.substring(1))

  /** An Area-Broadcast Accessor (ABA) is any three-character sequence which
    * which consists of something like ABA where A != B.
    *
    * @param in String to be checked
    * @return True if 'in' is an ABA
    */
  private def isAba(in: String): Boolean =
    in.length == 3 && in(0) == in(2) && in(0) != in(1)

  /** Creates the fitting BAB for a given ABA.
    *
    * @param in ABA-String
    * @return a BAB for that ABA
    */
  private def mkBab(in: String): String =
    in(1).toString + in(0) + in(1)

  /** Checks if there is a BAB in an enclosed part.
    *
    * @param bab BAB-String
    * @param enclosed Enclosed parts of the IP-Address (hypernet parts)
    *
    * @return Is there any BAB-String?
    */
  private def containsBab(bab: String, enclosed: AddrP): Boolean =
    enclosed.exists(_.contains(bab))

  /** This method slides a window over the given input to check if there is
    * an ABA-BAB-combination inside.
    *
    * @param in String to be checked
    * @param enclosed List of hypernet/enclosed-parts
    */
  private def containsAbaBab(in: String, enclosed: AddrP): Boolean =
    if(in.length < 3) false
    else (isAba(in.substring(0, 3)) &&
          containsBab(mkBab(in.substring(0, 3)), enclosed)) |
         containsAbaBab(in.substring(1), enclosed)
}


object Day7 {
  def main(args: Array[String]): Unit = {
    val ips: Seq[IPAddress] = Source.fromFile("input").
      mkString.split('\n').map(IPAddress)
    val tls = ips.filter(_.supportsTLS).size
    val ssl = ips.filter(_.supportsSSL).size

    println(s"Part 1: $tls\nPart 2: $ssl")
  }
}
