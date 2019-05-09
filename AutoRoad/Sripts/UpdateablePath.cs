using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[System.Serializable]
public class UpdateablePath {
    public bool initialized = false;
    public bool calculated = false;

    public List<Vector2> EvenlySpacedPoints = new List<Vector2>();

    public int Divisions { get{ return divisions; } }
    public float CurveLength { get{ return estimatedCurveLength; } }

    int divisions;
    float estimatedCurveLength;
    float lerpT;
    float controlNetLength;
    float dstSinceLastEvenPoint;
    float overshootDst;
    Vector2[] segmentPoints;
    Vector2 previousPoint;

    public Vector2 FirstPoint
    {
        get
        {
            if (EvenlySpacedPoints.Count > 0)
                return EvenlySpacedPoints[0];
            else
                return Vector2.zero;
        }
    }

    public Vector2 LastPoint
    {
        get
        {
            if (EvenlySpacedPoints.Count > 0)
                return EvenlySpacedPoints[EvenlySpacedPoints.Count - 1];
            else
                return Vector2.zero;
        }
    }

    public void Initialize(Vector2[] segment, float resolution = 1)
    {
        calculated = false;
        segmentPoints = segment;

        controlNetLength = Vector2.Distance(segmentPoints [0], segmentPoints [1]) + Vector2.Distance(segmentPoints [1], segmentPoints [2]) + Vector2.Distance(segmentPoints [2], segmentPoints [3]);
        estimatedCurveLength = Vector2.Distance(segmentPoints [0], segmentPoints [3]) + controlNetLength / 2f;
        divisions = Mathf.CeilToInt(estimatedCurveLength * resolution);

        dstSinceLastEvenPoint = 0;
        overshootDst = 0;
        lerpT = 0;
     
        if (EvenlySpacedPoints.Count > 0)
            EvenlySpacedPoints.Clear();
        EvenlySpacedPoints.Add(segmentPoints[0]);
        previousPoint = segmentPoints[0];

        initialized = true;
    }

    public bool NextStepCalculatePoint(int repeats = 1, float spacing = 3)
    {
        if (initialized)
        {
            for(int i = 0; i < repeats; i++)
            {
                lerpT += 1f / divisions;

                Vector2 pointOnCurve = Bezier.EvaluateCubic(segmentPoints, lerpT);
                dstSinceLastEvenPoint = overshootDst + Vector2.Distance(previousPoint, pointOnCurve);

                if(dstSinceLastEvenPoint >= spacing)
                {
                    overshootDst = dstSinceLastEvenPoint - spacing;
                    Vector2 newEvenlySpacedPoint = pointOnCurve + (previousPoint - pointOnCurve).normalized * overshootDst;
                    EvenlySpacedPoints.Add(newEvenlySpacedPoint);
                    previousPoint = newEvenlySpacedPoint;
                }   
                
                if (lerpT >= 1)
                {
                    calculated = true;
                    return true;
                }
            }
        }

        return false;
    }

    public int FindClosesPoint(Vector3 myPos, Vector3 carPos)
    {
        carPos -= myPos;
        int i;
        for(i = 0; i < EvenlySpacedPoints.Count; i++)
        {
            if (Vector2.Distance(carPos, EvenlySpacedPoints[i + 1]) > Vector2.Distance(carPos, EvenlySpacedPoints[i]))
                return i;
        }
        return i;
    }

    public Vector2[] LookForPositionsOnSameY(float y, Vector3 tilePosition, float spacing = 3)
    {
        y -= tilePosition.y;
        List<Vector2> sameYPoints = new List<Vector2>();
        for(int i = 0; i < EvenlySpacedPoints.Count; i++)
        {
            Vector2 point = EvenlySpacedPoints[i];
            float min = y - spacing/2;
            float max = y + spacing/2;
            if(point.y >= min && point.y <= max)
            {
                sameYPoints.Add(point + (Vector2)tilePosition);
            }
        }
        return sameYPoints.ToArray();
    }

    

    
}
