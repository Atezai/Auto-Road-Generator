using System.Collections;
using System.Collections.Generic;
using UnityEngine;


public class ObstacleManager : MonoBehaviour
{
    public Transform Car;
    public RoadTileManager RoadManager;
    public ObjectPool Pool;

    public ObstacleTile ExampleTile;
    public SampleObstaclesList SampleObstacles; // Obstacles used to fill world
    public List<ObstacleTile> ObstacleTiles = new List<ObstacleTile>(); // Grid made of rows of obstacles

    public float DistanceToAppear = 150;
    public float DistanceToDisappear = 50;

    public int CellSize = 15;
    public int MinCellCount = 15;

    public void Start()
    {
        //Setup Pools
        Pool.CreatePool(ExampleTile.gameObject);
        for (int i = 0; i < SampleObstacles.obstacles.Length; i++)
        {
            if (SampleObstacles.obstacles[i].Transform != null)
                Pool.CreatePool(SampleObstacles.obstacles[i].Transform.gameObject);
        }
    }

    public void Update()
    {
        float min; // minimum border to remove old tile
        float max; // maximum border to add new tile
        Vector2 newTilePosition;

        if (ObstacleTiles.Count > 0)
        {
            min = ObstacleTiles[0].transform.position.y;
            max = ObstacleTiles[ObstacleTiles.Count - 1].transform.position.y;
            newTilePosition = ObstacleTiles[ObstacleTiles.Count - 1].transform.position + Vector3.up * CellSize;
        }
        else
        {
            min = transform.position.y;
            max = transform.position.y;
            newTilePosition = transform.position;
        }

        if (Car.transform.position.y + DistanceToAppear > max)
        {
            AddTile(Pool, RoadManager, newTilePosition);
        }

        if (Car.transform.position.y - DistanceToDisappear > min)
        {
            RemoveTile(Pool);
        }
    }

    public void AddTile(ObjectPool pool, RoadTileManager roadManager, Vector2 tilePosition, float hardness = 1)
    {
        int additionalCells = 0;

        // Get road positions and fix tile position
        Vector2[] roadPositions = roadManager.LookForPositionsOnSameY(tilePosition.y);
        if (roadPositions != null && roadPositions.Length > 0)
        {
            float mostLeft = 0;
            float mostRight = 0;
            float sumOfRoadPositionsX = 0;
            for (int pos_i = 0; pos_i < roadPositions.Length; pos_i++)
            {
                sumOfRoadPositionsX += roadPositions[pos_i].x;
                if (mostLeft > roadPositions[pos_i].x)
                    mostLeft = roadPositions[pos_i].x;
                if (mostRight < roadPositions[pos_i].x)
                    mostRight = roadPositions[pos_i].x;
            }

            tilePosition = new Vector2(sumOfRoadPositionsX / roadPositions.Length, tilePosition.y);
            additionalCells = (int) ((mostRight - mostLeft) / CellSize);
        }
        else
            return; // Road is not ready. Skip.

        // Get and setup new Tile
        ObstacleTile newTile = pool.GetObject(ExampleTile.name).GetComponent<ObstacleTile>();
        newTile.transform.parent = transform;
        newTile.transform.position = tilePosition;
        newTile.Setup(pool, roadPositions, SampleObstacles.obstacles, CellSize, MinCellCount);
        ObstacleTiles.Add(newTile);
    }


    public void RemoveTile(ObjectPool pool)
    {
        if (ObstacleTiles.Count > 0)
        {
            ObstacleTiles[0].ClearObstacles(pool);
            pool.PutObject(ObstacleTiles[0].gameObject);
            ObstacleTiles.RemoveAt(0);
        }
    }
}