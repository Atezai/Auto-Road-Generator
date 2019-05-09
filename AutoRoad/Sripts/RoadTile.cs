using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RoadTile : MonoBehaviour {

    public MeshFilter Road;
    public MeshFilter Roadsides;
    public MeshCollider RoadCollision;
    //public Transform GroundTransform;

    public float RoadWidth = 5;
    public float RoadsideWidth = 10;
    //public float ColliderWidth = 4;

    public RoadPoint StartPoint;
    public RoadPoint EndPoint;
    public UpdateablePath Path = new UpdateablePath();

    public bool Setted = false;
    public bool Initialized = false;
    public bool Calculate = false;

    private Mesh _roadMesh;
    private Mesh _roadsidesMesh;

    private static int _calculatePointRepeats = 8; 
    private static float _spacing = 3;
    private static float _resolution = 1;

    public void Start()
    {
        RoadCollision = Road.GetComponent<MeshCollider>();
    }

    public void Update()
    {
        if (Calculate && !Setted)
        {
            if (Path.calculated)
            {
                EndPoint.position = Path.LastPoint;
                GenerateRoadParts(Path.EvenlySpacedPoints.ToArray());
                //Refresh collider !bugfix
                RoadCollision.enabled = false;
                RoadCollision.enabled = true;
            }
            else
            {
                Path.NextStepCalculatePoint(_calculatePointRepeats, _spacing);
            }
        }
    }
    
    public void StartGeneratingRoad(float widthMin, float widthMax, float estimatedLength, float spacing, float resolution, RoadTile tileBefore = null)
    {
        Setted = false;

        _spacing = spacing;
        _resolution = resolution;

        float pointPosX = Random.Range(widthMin, widthMax) * (Random.Range(0, 100) > 50 ? -1 : 1);
        float pointPosY = estimatedLength;
        EndPoint = new RoadPoint(new Vector2(pointPosX, pointPosY));

        RoadPoint tileBeforeEndPoint;
        if(tileBefore != null)
        {
            transform.position = tileBefore.transform.position + (Vector3)tileBefore.EndPoint.position;
            tileBeforeEndPoint = tileBefore.EndPoint;
        }
        else
        {
            transform.position = Vector3.zero;
            tileBeforeEndPoint = new RoadPoint(Vector2.zero);
        }

        Vector2[] segmentPoints = new Vector2[4];
        segmentPoints[0] = new Vector2(0, 0);
        segmentPoints[1] = tileBeforeEndPoint.Direction * tileBeforeEndPoint.strength * estimatedLength/2;
        segmentPoints[2] = EndPoint.position - EndPoint.Direction * EndPoint.strength * estimatedLength/2;
        segmentPoints[3] = EndPoint.position;

        Path.Initialize(segmentPoints, resolution);

        Calculate = true;
    }

    private void GenerateRoadParts(Vector2[] points)
    {
        if (points.Length < 2)
            return;

        if (_roadMesh == null || _roadMesh.vertices.Length != Path.EvenlySpacedPoints.Count * 2)
        {
            _roadMesh = new Mesh();
            _roadsidesMesh = new Mesh();
            _roadMesh.name = "Road_Mesh";
            _roadsidesMesh.name = "Roadsides_Mesh";
            Road.transform.localPosition = new Vector3(0,0,0);
            Road.transform.localScale = new Vector3(1, 1, 1);
            Roadsides.transform.localPosition = new Vector3(0,0,0);
            Roadsides.transform.localScale = new Vector3(1, 1, 1);
            Road.mesh = _roadMesh;
            RoadCollision.sharedMesh = _roadMesh;
            Roadsides.mesh = _roadsidesMesh;
            Initialized = true;
        }

        Vector2 startForward = Vector2.up, endForward = Vector2.up;
        
        Vector3[] verts = new Vector3[points.Length * 2];
        Vector3[] vertsRoad = new Vector3[points.Length * 2];
        Vector3[] vertsRoadsides = new Vector3[points.Length * 2];
        Vector2[] uvs = new Vector2[verts.Length];
        Vector3[] normals = new Vector3[verts.Length];
        int[] tris = new int[2 * (points.Length - 1) * 3];
        int vertIndex = 0;
        int triIndex = 0;

        for (int i = 0; i < points.Length; i++)
        {
            Vector2 forward = Vector2.zero;
            if (i > 1)
            {
                if (i < points.Length - 1)
                {
                    forward += points[i] - points[i - 1];
                    forward += points[i + 1] - points[i];
                }
                else
                    forward = endForward;
            }
            else
                forward = startForward;

            forward.Normalize();
            Vector2 left = new Vector2(-forward.y, forward.x);

            vertsRoad[vertIndex] = points[i] + left * RoadWidth;
            vertsRoad[vertIndex + 1] = points[i] - left * RoadWidth;
            vertsRoadsides[vertIndex] = points[i] + left * RoadsideWidth;
            vertsRoadsides[vertIndex + 1] = points[i] - left * RoadsideWidth;

            float completionPercent = i / (float)(points.Length - 1);
            uvs[vertIndex] = new Vector2(0, completionPercent);
            uvs[vertIndex + 1] = new Vector2(1, completionPercent);

            normals[vertIndex] = Vector3.back;
            normals[vertIndex + 1] = Vector3.back;

            if (i < points.Length - 1)
            {
                tris[triIndex] = vertIndex;
                tris[triIndex + 1] = vertIndex + 2;
                tris[triIndex + 2] = vertIndex + 1;

                tris[triIndex + 3] = vertIndex + 1;
                tris[triIndex + 4] = vertIndex + 2;
                tris[triIndex + 5] = vertIndex + 3;
            }

            vertIndex += 2;
            triIndex += 6;
        }

        _roadMesh.vertices = vertsRoad;
        _roadMesh.triangles = tris;
        _roadMesh.uv = uvs;
        _roadMesh.normals = normals;
        //roadMesh.RecalculateBounds();
        
        _roadsidesMesh.vertices = vertsRoadsides;
        _roadsidesMesh.triangles = tris;
        _roadsidesMesh.uv = uvs;
        _roadsidesMesh.normals = normals;
        //roadsidesMesh.RecalculateBounds();

        Calculate = false;
        Setted = true;
    }

    public Vector2[] LookForPositionsOnSameY(float y)
    {         
        return  Path.LookForPositionsOnSameY(y, transform.position, _spacing);
    }

    public Vector2 PointForwardVector(int i)
    {
        Vector2 forward = Vector2.zero;
        if (i > 1)
        {
            if (i < Path.EvenlySpacedPoints.Count - 1)
            {
                forward += Path.EvenlySpacedPoints[i] - Path.EvenlySpacedPoints[i - 1];
                forward += Path.EvenlySpacedPoints[i + 1] - Path.EvenlySpacedPoints[i];
            }
            else
                forward = EndPoint.Direction;
        }
        else
            forward = StartPoint.Direction;

        forward.Normalize();

        return forward;
    }

    public Vector2 PointRightVector(int i)
    {
        Vector2 forward = PointForwardVector(i);
        return new Vector2(forward.y, -forward.x);
    }
}
