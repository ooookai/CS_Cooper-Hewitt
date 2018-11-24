class NetworkEdge {

  private Pathfinder graph;
  private Node start; // Node start
  private int cid; // Connector index of that Start Node

  private float distance;
  private int agentCount;
  private float cost;

  NetworkEdge(Pathfinder graph, Node start, int cid, float distance){
    this.graph = graph;
    this.start = start;
    this.cid = cid;
    this.distance = distance;
    this.agentCount = 0;
    this.cost = distance;
  }

  Connector getConnector() {
    Connector c = (Connector)this.start.links.get(this.cid);
    return c;
  }

  void incrAgentCount(){
    this.agentCount++;
  }

  void decrAgentCount(){
    this.agentCount--;
  }

  void updateCost(){}

}
