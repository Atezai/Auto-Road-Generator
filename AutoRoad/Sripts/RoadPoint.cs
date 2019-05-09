using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[System.Serializable]
public struct RoadPoint{

    public Vector2 position;
    public float angle;
    public float strength;

    public Vector2 Direction
    {
        get
        {
            if (angle == 0)
                return Vector2.up;
            else
                return Quaternion.AngleAxis(angle, Vector3.back) * Vector2.up;
        }
    }

    public Vector2 PilotPointPosition
    {
        get
        {
            return position + Direction * strength;
        }
    }

    public Vector2 NegativePilotPointPosition
    {
        get
        {
            return position + Direction * strength * -1;
        }
    }

    public RoadPoint(Vector2 _position, float _angle = 0, float _strength = 1)
    {
        position = _position;
        angle = _angle;
        strength = _strength;
    }
}
