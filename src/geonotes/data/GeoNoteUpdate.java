package geonotes.data;

import java.util.Date;
import java.util.Map;
import javax.jdo.PersistenceManager;
import javax.servlet.http.HttpServletRequest;

import geonotes.data.model.GeoNote;
import geonotes.utils.DisplayUtils;
import geonotes.utils.RequestUtils;

/**
 * Update a note.
 *
 * @author Brian Spiegel
 */
public class GeoNoteUpdate {

    /**
     * Update a note.
	   *
     * @param aRequest The request
     *
     * @since 1.0
     */
    public void execute(HttpServletRequest aRequest) {

        // Get Id.
        Long geoNoteId=(Long)aRequest.getAttribute("id");
        
        // Fields
        String note=(String)aRequest.getAttribute("note");
        Double longitude=(Double)aRequest.getAttribute("longitude");
        Double latitude=(Double)aRequest.getAttribute("latitude");
        Double accuracy=(Double)aRequest.getAttribute("accuracy");

        PersistenceManager pm=null;
        try {
            pm=PMF.get().getPersistenceManager();
                        
            GeoNote geoNote=GeoNoteGetSingle.getGeoNote(aRequest,pm,geoNoteId.longValue());
            
            if (geoNote!=null){
                geoNote.setNote(note);
                geoNote.setLastUpdateTime(new Date());
                geoNote.setLongitude(longitude.doubleValue());
                geoNote.setLatitude(latitude.doubleValue());
                geoNote.setAccuracy(accuracy.doubleValue());
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
}
