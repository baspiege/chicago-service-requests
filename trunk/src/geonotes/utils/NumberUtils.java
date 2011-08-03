package geonotes.utils;

/**
 * Number utilities.
 *
 * @author Brian Spiegel
 */
public class NumberUtils
{
    /**
    * Get a number two decimal precision.
    *
    * @param aNumber to format
    * @return a double with 2 decimal precision
    */
    public static double getNumber2DecimalPrecision(double aNumber)
    {    
      int temp = (int)(aNumber * 100);
      return ((double)temp)/100;
    }
    
    /**
    * Get a number 1 decimal precision.
    *
    * @param aNumber to format
    * @return a double with 1 decimal precision
    */
    public static double getNumber1DecimalPrecision(double aNumber)
    {    
      int temp = (int)(aNumber * 10);
      return ((double)temp)/10;
    }
}
