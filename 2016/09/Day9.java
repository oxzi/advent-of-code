import java.nio.file.*;
import java.util.regex.*;

public class Day9 {

  public static long length(String in, int version) {
    Matcher match = Pattern.compile("^\\((\\d+)x(\\d+)\\)(.*)").matcher(in);

    if(in.isEmpty()) {
      return 0;
    } else if(match.matches()) {
      int chrAmount = Integer.parseInt(match.group(1));
      int times = Integer.parseInt(match.group(2));
      String rest = match.group(3);

      long unrolled;
      if(version == 1) {
        unrolled = (rest.substring(0, chrAmount)).length() * times;
      } else {
        unrolled = length(rest.substring(0, chrAmount), version) * times;
      }
      return unrolled + length(rest.substring(chrAmount), version);
    } else {
      return 1 + length(in.substring(1), version);
    }
  }

  public static void main(String[] args) throws Throwable {
    Files.lines(Paths.get("input")).
      map(x -> length(x, 1) + " " +  length(x, 2)).
      forEach(System.out::println);
  }
}
