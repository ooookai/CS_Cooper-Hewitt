class NetworkEdge {

  private int id;

  private Node start; 
  private Node end;
  private boolean isBidirectional;
  private float length;
  private ArrayList<NetworkEdge> connections;

  public ArrayList<Agent> agents; 

  NetworkEdge(int _id, Node _start, Node _end, boolean _isBidirectional){
    id = _id;
    start = _start;
    end = _end;
    isBidirectional = _isBidirectional;
    length = dist(start.x, start.y, end.x, end.y);
    connections = new ArrayList<NetworkEdge>();
    agents = new ArrayList<Agent>();
  }

}

class NetworkEdgeManager {

  private ArrayList<NetworkEdge> edges;
  // we need this to search Nodes in O(1)
  private HashMap<Node, int> nodeToIndex; 
  // a hashmap that links two Nodes to one Edge
  // "aid-bid" -> edge
  private HashMap<String, Edge> idsToEdge;

  NetworkEdgeManager(){
    edges = new ArrayList<NetworkEdge>();
    nodeToIndex = new HashMap<Node, int>();
    idsToEdge = new HashMap<String, Edge>();
  }

  void mapNode(Node newNode){
    if(!NodeToIndex.containsKey(newNode)){
      int maxValue = NodeToIndex.size();
      nodeToIndex.put(newNode, maxValue);  
    } 
  }

  // creates and adds a Edge to it's edges collection.
  // also assigns the edge to a HashMap to be later accessed faster
  void add(Node start, Node end, boolean isBidirectional){
    int id = edge.size(); 
    Edge e = new Edge(id, start, end, isBidirectional);
    edges.add(e)
    String ids = nodesToIds(start, end);
    idsToEdge.put(ids, e);
    // if bidirectional, two keys 
    // ("aid-bid" and "bid-aid") points to one edge
    if(isBidirectional) {
      ids = nodesToIds(end, start);
      idsToEdge.put(ids, e);
    }
  }
  
  public Edge updateEdge(Agent agent, Edge oldEdge, Node newSrc, Node newDest){
    // 1. remove agent from old edge
    if(oldEdge != null){
      oldEdge.agents.remove(agent);
    }

    // 2. assignAgent to new Edge, return this edge
    Edge newEdge = idsToEdge.get(nodesToIds(newSrc, newDest));
    // TODO(Yasushi Sakai): what if null??
    newEdge.agents.add(agent);

    return newEdge;
  }

  // helper function to make "aid-bid" string
  private String nodesToIds(Node a, Node b){
    int idA = nodeToIndex.get(a); 
    int idB = nodeToIndex.get(b);
    return idA + "-" + idB; 
  }
}
