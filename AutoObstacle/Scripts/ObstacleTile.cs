using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ObstacleTile : MonoBehaviour{

    public bool Debug = false;
    public Transform[] Obstacles;
    float _cellSize;

    public void Setup(ObjectPool pool, Vector2[] roadPositions, Obstacle[] exampleObstacles, float cellSize, int _cellCount)
    {
        _cellSize = cellSize;
        //Initialize new array if needed
        if (Obstacles == null || Obstacles.Length != _cellCount)
            Obstacles = new Transform[_cellCount];

        // Setup every cell
        for(int cell_i = 0; cell_i < _cellCount; cell_i++)
        {
            // Get cell position
            Vector2 cellPosition = CalculateCellPosition(cell_i);

            // Check if cell isnt on road
            bool cellIsOnRoad = false;
            foreach (Vector2 roadPos in roadPositions)
                if(Vector2.Distance(roadPos, cellPosition) < cellSize)
                    cellIsOnRoad = true;

            // If cell isnt on road, find random obstacle to place and set it up
            if (!cellIsOnRoad)
            {
                float chanceSum = 0;
                // Calculate sum of chances and create random number
                foreach (Obstacle obs in exampleObstacles)
                    chanceSum += obs.Chances;
                float random = Random.Range(0f, chanceSum);
                // Clear sum
                chanceSum = 0;
                // Find obstacle with chances containing random number
                for(int obs_i = 0; obs_i < exampleObstacles.Length; obs_i++)
                {
                    Obstacle obstacle = exampleObstacles[obs_i];
                    chanceSum += obstacle.Chances;
                    if(random <= chanceSum)
                    {
                        // Setup obstacle and add it to cell
                        if (!obstacle.Empty)
                        {
                            float newScale = 1;
                            Vector2 newPosition = cellPosition;
                            Quaternion newRotation = Quaternion.identity;

                            if (obstacle.RandomScale)
                            {
                                newScale = Random.Range(obstacle.MinScale, obstacle.MaxScale);
                            }

                            if (obstacle.RandomPosition)
                            {
                                float randomRange = cellSize/2 - obstacle.BaseSize * obstacle.MinScale;
                                newPosition = cellPosition + new Vector2(Random.Range(-randomRange,randomRange),Random.Range(-randomRange,randomRange));
                            }

                            if (obstacle.RandomRotation)
                            {
                                Quaternion.Euler(new Vector3(0,0, Random.Range(-180, 180)));
                            }

                            Transform newObstacle = pool.GetObject(obstacle.Transform.name).transform;
                            newObstacle.position = newPosition;
                            newObstacle.rotation = newRotation;
                            newObstacle.localScale = new Vector3(1, 1, 1) * newScale;
                            newObstacle.parent = transform;
                            Obstacles[cell_i] = newObstacle;
                        }
                        else
                        {
                            //obstacles[cell_i] = null;
                        }
                        break;
                    }
                }
            }
        }

    }

    Vector2 CalculateCellPosition(int i)
    {
        // Cell position is tile position offseted by cell index and cell size. Starting from left to right
        Vector2 pos = transform.position;
        pos.x += (i-Obstacles.Length/2) * _cellSize;
        return pos;
    }

    public void ClearObstacles(ObjectPool pool)
    {
        // Put objects back to pool
        for(int i = 0; i < Obstacles.Length; i++)
        {
            if (Obstacles[i] != null)
            {
                pool.PutObject(Obstacles[i].gameObject);
                Obstacles[i] = null;
            }

        }
    }

    public void OnDrawGizmos()
    {
        if (Debug)
        {
            Gizmos.color = Color.red;
            Gizmos.DrawSphere(transform.position, 1);

            float halfSize = _cellSize / 2;
            Vector3 corner_ul = Vector3.up * halfSize + Vector3.left * halfSize + Vector3.back * 0.25f;
            Vector3 corner_ur = Vector3.up * halfSize + Vector3.right * halfSize + Vector3.back * 0.25f;
            Vector3 corner_dl = Vector3.down * halfSize + Vector3.left * halfSize + Vector3.back * 0.25f;
            Vector3 corner_dr = Vector3.down * halfSize + Vector3.right * halfSize + Vector3.back * 0.25f;
            for(int i = 0; i < Obstacles.Length; i++)
            {
                Vector3 cellPos = CalculateCellPosition(i);
                Gizmos.DrawLine(corner_ul + cellPos, corner_ur + cellPos);//up line
                Gizmos.DrawLine(corner_dl + cellPos, corner_dr + cellPos);//down line
                Gizmos.DrawLine(corner_ul + cellPos, corner_dl + cellPos);//left line
                Gizmos.DrawLine(corner_ur + cellPos, corner_dr + cellPos);//right line
            }
        }
        
    }
}
