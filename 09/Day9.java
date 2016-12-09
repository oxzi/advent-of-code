import java.nio.file.*;
import java.util.regex.*;

public class Day9 {

  private static String strRepeat(String in, int times) {
    return new String(new char[times]).replace("\0", in);
  }

  private static Pattern PATTERN = Pattern.compile("^\\((\\d+)x(\\d+)\\)(.*)");

  public static String decompress(String in) {
    Matcher match = PATTERN.matcher(in);

    if(in.isEmpty()) {
      return "";
    } else if(match.matches()) {
      int chrAmount = Integer.parseInt(match.group(1));
      int times = Integer.parseInt(match.group(2));
      String rest = match.group(3);

      String unrolled = strRepeat(rest.substring(0, chrAmount), times);
      return unrolled + decompress(rest.substring(chrAmount));
    } else {
      return in.substring(0, 1) + decompress(in.substring(1));
    }
  }

  public static long length(String in) {
    Matcher match = PATTERN.matcher(in);

    if(in.isEmpty()) {
      return 0;
    } else if(match.matches()) {
      int chrAmount = Integer.parseInt(match.group(1));
      int times = Integer.parseInt(match.group(2));
      String rest = match.group(3);

      long unrolled = length(rest.substring(0, chrAmount)) * times;
      return unrolled + length(rest.substring(chrAmount));
    } else {
      return 1 + length(in.substring(1));
    }
  }

  public static void main(String[] args) throws Throwable {
    // Part One
    Files.lines(Paths.get("input")).
      map(Day9::decompress).map(String::length).
      forEach(System.out::println);

    // Part Two
    Files.lines(Paths.get("input")).
      map(Day9::length).
      forEach(System.out::println);
  }
}
