package geonotes.data;

import java.util.Comparator;
import java.util.Date;

import geonotes.data.model.GeoNote;

/**
 * Comparator for sorting geo note by start date - descending.
 *
 * @author Brian Spiegel
 */
public class GeoNoteSortByStartDate implements Comparator {

    /**
     * Compare based on start date.
     *
     * @param aGeoNote1 appt 1
     * @param aGeoNote2 appt 2
     * @return an int indicating the result of the comparison
     */
    public int compare(Object aGeoNote1, Object aGeoNote2) {
        // Parameter are of type Object, so cast to Date
        Date date1=((GeoNote)aGeoNote1).lastUpdateTime;
        Date date2=((GeoNote)aGeoNote2).lastUpdateTime;

        return date2.compareTo(date1);
    }
}
