using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[CreateAssetMenu(fileName = "Sample Obstacles", menuName = "AutoRoad/Sample Obstacles")]
public class SampleObstaclesList : ScriptableObject {
    public Obstacle[] obstacles;
}
