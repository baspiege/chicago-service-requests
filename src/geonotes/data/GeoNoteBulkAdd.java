package geonotes.data;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.jdo.PersistenceManager;
import javax.jdo.Query;
import javax.servlet.http.HttpServletRequest;

import geonotes.data.model.GeoNote;
import geonotes.utils.RequestUtils;

/**
 * Add notes.
 *
 * @author Brian Spiegel
 */
public class GeoNoteBulkAdd {

    /**
     * Add notes.
     *
     * @param aRequest The request
     *
     * @since 1.0
     */
    public void execute(HttpServletRequest aRequest) {
        String notesInput=(String)aRequest.getAttribute("notes");
        Long type=(Long)aRequest.getAttribute("type");
        PersistenceManager pm=null;
        try {
            pm=PMF.get().getPersistenceManager();

            // Split input
            String notes[] = notesInput.split("\\r?\\n");
            DateFormat formatter = new SimpleDateFormat("MM/dd/yy");
            for (int i=0;i<notes.length;i++) {
                String parts[] = notes[i].split(",");
                GeoNote geoNote=new GeoNote();
                if (type==3){
                    // Example: 08/10/2011,Open,Brick - Painted,Front,41.93571207328131,-87.70261319521063                           
                    geoNote.setNote(parts[2] + " " + parts[3]);
                    geoNote.setLastUpdateTime((Date)formatter.parse(parts[0]));
                    geoNote.setLatitude(new Double(parts[4]).doubleValue());
                    geoNote.setLongitude(new Double(parts[5]).doubleValue());
                }
                
                geoNote.setType(type);
                geoNote.setYes(0);
                pm.makePersistent(geoNote);
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
