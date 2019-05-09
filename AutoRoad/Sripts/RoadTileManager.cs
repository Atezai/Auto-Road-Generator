using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RoadTileManager : MonoBehaviour
{
    public GameObject Car;
    public ObjectPool Pool;

    public List<RoadTile> RoadTiles = new List<RoadTile>();

    public float DistanceToAppear = 150;
    public float DistanceToDisappear = 50;

    public float Spacing = 3f;
    public float Resolution = 1f;

    private float _distanceCreated = 0;
    private float _distanceDeleted = 0;


    public void Update()
    {
        if (RoadTiles.Count > 0)
        {
            RoadTile lastTile = RoadTiles[RoadTiles.Count - 1];
            RoadTile firstTile = RoadTiles[0];

            float distanceToLastTile = (lastTile.transform.position.y + lastTile.EndPoint.position.y) -
                                       Car.transform.position.y;
            float distanceToFirstTile = Car.transform.position.y -
                                        (firstTile.transform.position.y + firstTile.EndPoint.position.y);

            //Debug.Log("Car:" + Car.transform.position.y + "  |firstTilePos:"+ firstTile.transform.position.y + "  |first tile endpoint:" + firstTile.EndPoint.position.y + " |distance:" + distanceToFirstTile);
            if (lastTile.Setted && distanceToLastTile < DistanceToAppear)
                AddTile();

            if (distanceToFirstTile > DistanceToDisappear)
                RemoveTile();
        }
        else
        {
            AddTile();
        }
    }

    private void AddTile()
    {
        RoadTile tile = Pool.GetObject("RoadTile").GetComponent<RoadTile>();
        tile.transform.parent = transform;

        float distance = 100;

        if (RoadTiles.Count > 1)
            tile.StartGeneratingRoad(50, 100, distance, Spacing, Resolution, RoadTiles[RoadTiles.Count - 1]);
        else
            tile.StartGeneratingRoad(0, 0, distance, Spacing, Resolution);

       _distanceCreated += tile.Path.CurveLength;

        RoadTiles.Add(tile);
    }

    private void RemoveTile()
    {
        Pool.PutObject(RoadTiles[0].gameObject);
        _distanceDeleted += RoadTiles[0].Path.CurveLength;
        RoadTiles.RemoveAt(0);
    }

    public RoadTile LookForTileAtPosition(float y)
    {
        foreach (RoadTile tile in RoadTiles)
        {
            if (tile.Initialized && tile.Setted && tile.isActiveAndEnabled)
            {
                float min = tile.StartPoint.position.y + tile.transform.position.y;
                float max = tile.EndPoint.position.y + tile.transform.position.y;
                if (y >= min && y <= max)
                {
                    return tile;
                }
            }
        }

        return null;
    }

    public Vector2[] LookForPositionsOnSameY(float y)
    {
        RoadTile tile = LookForTileAtPosition(y);
        if (tile != null)
            return tile.LookForPositionsOnSameY(y);
        else
            return new Vector2[0];
    }
}