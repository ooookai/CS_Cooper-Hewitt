
public final int PHYSICAL_BUILDINGS_COUNT = 24;
// There are 'virtual buildings' in 'zombie land'.
// These buildings do not have physical representations and can
// never be placed on the grid.  They are permenantly in zombie land.
// Utility: Agents assigned to a residence or office in zombie buildings
// always go in or out of 'zombie land'.
public final int VIRTUAL_ZOMBIE_BUILDING_ID = PHYSICAL_BUILDINGS_COUNT + 1;

public class Grid {
  private ArrayList<Building> buildings; // all the building (24)
  private ArrayList<Building> buildingsOnGrid; // Building present on the grid
  private ArrayList<GridInteractionAnimation> gridAnimation;
  public HashMap<Integer, PVector> gridMap;
  HashMap<PVector,Integer> gridQRcolorMap;

  public PVector zombieLandLocation;
  
  Table table;
   Grid(){

    zombieLandLocation = new PVector(-1, -1);

    // initialize buildings
     buildings = new ArrayList<Building>();
     gridMap = new HashMap<Integer,PVector>();
     gridMap.put(0,new PVector(1,1));gridMap.put(1,new PVector(3,1));gridMap.put(2,new PVector(6,1));gridMap.put(3,new PVector(8,1));gridMap.put(4,new PVector(11,1));gridMap.put(5,new PVector(13,1));
     gridMap.put(6,new PVector(1,4));gridMap.put(7,new PVector(3,4));gridMap.put(8,new PVector(6,4));gridMap.put(9,new PVector(8,4));gridMap.put(10,new PVector(11,4));gridMap.put(11,new PVector(13,4));
     gridMap.put(12,new PVector(1,7));gridMap.put(13,new PVector(3,7));gridMap.put(14,new PVector(6,7));gridMap.put(15,new PVector(8,7));gridMap.put(16,new PVector(11,7));gridMap.put(17,new PVector(13,7));
     gridMap.put(18, zombieLandLocation);gridMap.put(19, zombieLandLocation);gridMap.put(20, zombieLandLocation);gridMap.put(21, zombieLandLocation);gridMap.put(22, zombieLandLocation);gridMap.put(23, zombieLandLocation);
          
     gridQRcolorMap = new HashMap<PVector,Integer>();
     gridQRcolorMap.put(gridMap.get(0),#888888);gridQRcolorMap.put(gridMap.get(1),#888888);gridQRcolorMap.put(gridMap.get(2),#CCCCCC);gridQRcolorMap.put(gridMap.get(3),#CCCCCC);gridQRcolorMap.put(gridMap.get(4),#888888);gridQRcolorMap.put(gridMap.get(5),#888888);
     gridQRcolorMap.put(gridMap.get(6),#888888);gridQRcolorMap.put(gridMap.get(7),#888888);gridQRcolorMap.put(gridMap.get(8),#CCCCCC);gridQRcolorMap.put(gridMap.get(9),#CCCCCC);gridQRcolorMap.put(gridMap.get(10),#888888);gridQRcolorMap.put(gridMap.get(11),#888888);
     gridQRcolorMap.put(gridMap.get(12),#888888);gridQRcolorMap.put(gridMap.get(13),#888888);gridQRcolorMap.put(gridMap.get(14),#CCCCCC);gridQRcolorMap.put(gridMap.get(15),#CCCCCC);gridQRcolorMap.put(gridMap.get(16),#888888);gridQRcolorMap.put(gridMap.get(17),#888888);
     
     table = loadTable("block/Cooper Hewitt Buildings - Building Blocks.csv", "header");
     for (TableRow row : table.rows()) {
      // initialize buildings from data
      int id = row.getInt("id");
      int loc = id;  // initial location is same as building id
      int capacityR = row.getInt("R");
      int capacityO = row.getInt("O");
      int capacityA = row.getInt("A");
      Building b = new Building(gridMap.get(loc), id, capacityR, capacityO, capacityA);
      buildings.add(b);
     }
     
     // initialize buildings on grid as the first 18 buildings
     buildingsOnGrid = new ArrayList<Building>();
     gridAnimation = new ArrayList<GridInteractionAnimation>();
     
     // is there a reason not using a simple for loop?
     int i = 0;
     for (Building b: buildings) {
      buildingsOnGrid.add(b);
      gridAnimation.add(new GridInteractionAnimation(b.loc));
      i += 1;
      if (i >= 18) {
        break;
      }
     }
   }
   
   public void draw(PGraphics p){
     for (Building b: buildingsOnGrid){
       if(b.loc.x!=-1){
         b.draw(p);
       }
     }

     for (GridInteractionAnimation ga: gridAnimation){
       ga.draw(p);
     }
   }
   
   public void updateGridFromUDP(String message){
    //println("message" + message);
    JSONObject json = parseJSONObject(message); 
    JSONArray grids = json.getJSONArray("grid");
    for(int i=0; i < grids.size(); i++) {
      Building b = buildingsOnGrid.get(i);
      if(grids.getJSONArray(i).getInt(0) != -1){

        // something was put onto the table
        if(b.id == -1){
          //update the id of the buildign to send the information of which special building has been sent to the grid Animation
          b.id = grids.getJSONArray(i).getInt(0);
          gridAnimation.get(i).put(b.id);
        }

        
        b.capacityR = buildings.get(grids.getJSONArray(i).getInt(0)).capacityR;
        b.capacityO = buildings.get(grids.getJSONArray(i).getInt(0)).capacityO;
        b.capacityA = buildings.get(grids.getJSONArray(i).getInt(0)).capacityA;
      }
      else {

        // the building was taken from the table
        if(b.id != -1){
          gridAnimation.get(i).take(b.id);
        }

        b.id = -1;
        b.capacityR = -1;
        b.capacityO = -1;
        b.capacityA = -1;
      }
    }
    if(dynamicSlider) {
      JSONArray sliders = json.getJSONArray("slider");
      state.slider = 1.0 - sliders.getFloat(0);
    }   
    
    //FIXME: Keep this for now in case we want to keep the permanent special effect see issue #86
    /*if(isBuildingInCurrentGrid(20)){
      showGlyphs = false;
    }else{
      showGlyphs =true;
    }
    if(isBuildingInCurrentGrid(21)){
      showNetwork = true;
    }else{
      showNetwork =false;
    }
    if(isBuildingInCurrentGrid(22)){
      showCollisionPotential = true;
    }else{
      showCollisionPotential = false;
    }*/
    
    
   }
   
  public boolean isBuildingInCurrentGrid(int id){
    for (Building b: buildingsOnGrid){
      if (b.id == id){
        return true;
      }
    }
    return false;
  }

  public PVector getBuildingCenterPosistionPerId(int id) {
    PVector buildingLoc = getBuildingLocationById(id);
    return new PVector(buildingLoc.x*GRID_CELL_SIZE + BUILDING_SIZE/2, buildingLoc.y*GRID_CELL_SIZE + BUILDING_SIZE/2);
  }

  public PVector getBuildingLocationById(int id) {
    if (id < buildings.size()) {
      return buildings.get(id).loc;
    }
    return zombieLandLocation;
  }

  public void resetAnimation(){
    for(GridInteractionAnimation ga: gridAnimation){
      ga.take(-1);
    }
  }
}
