package geonotes.data;

import java.util.ArrayList;
import java.util.List;
import javax.jdo.PersistenceManager;
import javax.jdo.Query;
import javax.servlet.http.HttpServletRequest;

import geonotes.data.model.GeoNote;
import geonotes.utils.NumberUtils;
import geonotes.utils.RequestUtils;

/**
 * Get geo notes.
 *
 * @author Brian Spiegel
 */
public class GeoNoteGetAll {

    public static String FILTER="(latitude2Decimal==latitudeParam && longitude2Decimal==longitudeParam)";
    public static String DECLARED_PARAMETERS="double latitudeParam, double longitudeParam";

    /**
     * Get geo notes.
     *
     * @param aRequest The request
     * @since 1.0
     */
    public void execute(HttpServletRequest aRequest) {
        PersistenceManager pm=null;
        try {
            pm=PMF.get().getPersistenceManager();
            Query query=null;
            try {
                Double latitude=(Double)aRequest.getAttribute("latitude");
                Double longitude=(Double)aRequest.getAttribute("longitude");

                double latitudeCenter=NumberUtils.getNumber2DecimalPrecision(latitude);
                double longitudeCenter=NumberUtils.getNumber2DecimalPrecision(longitude);

                query = pm.newQuery(GeoNote.class);
                query.setFilter(FILTER);
                query.declareParameters(DECLARED_PARAMETERS);
                
                List<GeoNote> results = new ArrayList<GeoNote>();

                // Center                
                List<GeoNote> resultsTemp = (List<GeoNote>) query.execute(latitudeCenter, longitudeCenter);
                transferResults(results,resultsTemp);

                // Left
                boolean left=false;
                if (latitude-latitudeCenter<.0025) {
                    resultsTemp = (List<GeoNote>) query.execute(NumberUtils.getNumber2DecimalPrecision(latitudeCenter-.01), longitudeCenter);
                    transferResults(results,resultsTemp);
                    left=true;
                    //System.out.println("left");
                }

                // Right
                boolean right=false;
                if (latitude-latitudeCenter>.0075) {
                    resultsTemp = (List<GeoNote>) query.execute(NumberUtils.getNumber2DecimalPrecision(latitudeCenter+.01), longitudeCenter);
                    transferResults(results,resultsTemp);
                    right=true;
                    //System.out.println("right");
               }

                // Down
                boolean down=false;
                if (longitudeCenter-longitude<.0025) {
                    resultsTemp = (List<GeoNote>) query.execute(latitudeCenter, NumberUtils.getNumber2DecimalPrecision(longitudeCenter+.01));
                    transferResults(results,resultsTemp);
                    down=true;
                    //System.out.println("down");
                }

                // Up
                boolean up=false;
                if (longitudeCenter-longitude>.0075) {
                    resultsTemp = (List<GeoNote>) query.execute(latitudeCenter, NumberUtils.getNumber2DecimalPrecision(longitudeCenter-.01));
                    transferResults(results,resultsTemp);
                    up=true;
                    //System.out.println("up");
                }

                // Corners
                if (left && up) {
                    resultsTemp = (List<GeoNote>) query.execute(NumberUtils.getNumber2DecimalPrecision(latitudeCenter-.01), NumberUtils.getNumber2DecimalPrecision(longitudeCenter-.01));
                    transferResults(results,resultsTemp);
                    //System.out.println("left up");
                } else if (left && down) {
                    resultsTemp = (List<GeoNote>) query.execute(NumberUtils.getNumber2DecimalPrecision(latitudeCenter-.01), NumberUtils.getNumber2DecimalPrecision(longitudeCenter+.01));
                    transferResults(results,resultsTemp);
                    //System.out.println("left down");
                } else if (right && up) {
                    resultsTemp = (List<GeoNote>) query.execute(NumberUtils.getNumber2DecimalPrecision(latitudeCenter+.01), NumberUtils.getNumber2DecimalPrecision(longitudeCenter-.01));
                    transferResults(results,resultsTemp);
                    //System.out.println("right up");
                } else if (right && down) {
                    resultsTemp = (List<GeoNote>) query.execute(NumberUtils.getNumber2DecimalPrecision(latitudeCenter+.01), NumberUtils.getNumber2DecimalPrecision(longitudeCenter+.01));
                    transferResults(results,resultsTemp);
                    //System.out.println("right down");
                }

                // Set into request
                aRequest.setAttribute("geoNotes", results);
            } finally {
                if (query!=null) {
                    query.closeAll();
                }
            }
        } catch (Exception e) {
            System.err.println(this.getClass().getName() + ": " + e);
            e.printStackTrace();
            RequestUtils.addEditUsingKey(aRequest,"requestNotProcessedEditMsssage");
        } finally {
            if (pm!=null) {
                pm.close();
            }
        }
    }
    
    /**
     * Transfer results
     *
     * @param results results
     * @param resultsTemp results temp
     * @since 1.0
     */
    public void transferResults(List<GeoNote> results, List<GeoNote> resultsTemp) {    
        // Bug workaround.  Get size actually triggers the underlying database call.
        resultsTemp.size();
        for (GeoNote note: resultsTemp) {
          results.add(note);
        }
    }
}
