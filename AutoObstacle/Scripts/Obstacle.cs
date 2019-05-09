using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[System.Serializable]
public class Obstacle
{
    public Transform Transform;
    public float Chances = 0;
    public bool Empty = true;
    public bool RandomPosition = false;
    public bool RandomRotation = false;
    public bool RandomScale = false;
    public float BaseSize = 1;
    public float MinScale = 1;
    public float MaxScale = 1;

    public void Setup(Transform transform = null)
    {
        Empty = true;
        
        if (transform != null)
            Transform = transform;
        else
            Empty = false;
    }
    
}
