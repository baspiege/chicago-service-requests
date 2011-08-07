package geonotes.data;

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

        PersistenceManager pm=null;
        try {
            pm=PMF.get().getPersistenceManager();

            // Split input
            String notes[] = notesInput.split("\\r?\\n");
            
            for (int i=0;i<notes.length;i++) {
            
                String parts[] = notes[i].split(",");
                
                //System.out.println(parts[5] + " " + parts[6] + "," + parts[11] + "," + parts[12]);
            
                GeoNote geoNote=new GeoNote();
                geoNote.setNote(parts[5] + " " + parts[6]);
                geoNote.setLastUpdateTime(new Date());  // TODO Update this
                geoNote.setLatitude(new Double(parts[11]).doubleValue());
                geoNote.setLongitude(new Double(parts[12]).doubleValue());
                geoNote.setYes(0);
                geoNote.setType(0); // TODO Update this
                
                // Save
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
